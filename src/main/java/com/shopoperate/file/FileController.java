package com.shopoperate.file;

import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.upload.UploadFile;
import com.shopoperate.utils.ApiReturn;
import com.mysql.cj.util.StringUtils;
import com.shopoperate.utils.ImageCompressor;
import org.apache.log4j.Logger;

import java.io.*;
import java.math.BigInteger;
import java.util.List;

import static com.shopoperate.utils.FileUtil.getFileTempNameByExt;

@Path("/api/file")
public class FileController extends Controller {

    private static final Logger logger = Logger.getLogger(FileController.class);

    private FileService fileService = FileService.me;

    /**
     * 返回图片/视频文件
     * GET /api/file/image?name={relative_path}
     * 基础路径: C:/shop-operate/
     */
    @MethodValidation("GET")
    public void image() {
        String fileName = getPara("name");
        if (StringUtils.isNullOrEmpty(fileName)) {
            fileName = "public/default.png";
        }
        if (fileName.contains("..") || fileName.contains("\\")) {
            renderError(403);
            return;
        }
        String fullPath = "C:/shop-operate/" + fileName;
        File imageFile = new File(fullPath);
        if (!imageFile.exists()) {
            logger.error("文件不存在: " + fullPath);
            renderError(404);
            return;
        }
        try (FileInputStream fis = new FileInputStream(imageFile)) {
            byte[] imageBytes = new byte[(int) imageFile.length()];
            fis.read(imageBytes);
            String contentType = getContentTypeByFileName(fileName);
            getResponse().setContentType(contentType);
            getResponse().getOutputStream().write(imageBytes);
            getResponse().getOutputStream().flush();
            renderNull();
        } catch (IOException e) {
            logger.error("文件读取失败: " + fullPath, e);
            renderError(500);
        }
    }

    private String getContentTypeByFileName(String fileName) {
        if (fileName == null) return "image/jpeg";
        String lowerName = fileName.toLowerCase();
        if (lowerName.endsWith(".png")) return "image/png";
        if (lowerName.endsWith(".gif")) return "image/gif";
        if (lowerName.endsWith(".webp")) return "image/webp";
        if (lowerName.endsWith(".svg")) return "image/svg+xml";
        if (lowerName.endsWith(".mp4")) return "video/mp4";
        if (lowerName.endsWith(".webm")) return "video/webm";
        if (lowerName.endsWith(".pdf")) return "application/pdf";
        return "image/jpeg";
    }

    /** 允许上传的文件后缀白名单 */
    private static final java.util.Set<String> ALLOWED_EXTENSIONS = new java.util.HashSet<>(
        java.util.Arrays.asList("jpg", "jpeg", "png", "gif", "webp", "svg", "bmp", "ico",
                                "doc", "docx", "xls", "xlsx", "pdf", "txt", "zip", "rar",
                                "mp4", "mov", "avi", "webm", "mkv", "flv")
    );

    // ==================== 通用上传 ====================

    /**
     * 通用文件上传
     * POST /api/file/upload
     * 存储: C:/shop-operate/public/files/{fname}
     * 返回: public/files/{fname}
     */
    @MethodValidation("POST")
    public void upload() {
        List<UploadFile> uploadFileList = getFiles();
        for (UploadFile uploadFile : uploadFileList) {
            String fileName = uploadFile.getOriginalFileName();
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!ALLOWED_EXTENSIONS.contains(fileExt)) {
                renderJson(new ApiReturn().addMsg("不支持的文件类型: " + fileExt).fail());
                return;
            }
            File file = uploadFile.getFile();
            String newFileName = getFileTempNameByExt(fileExt);
            String fileUploadPath = "C:/shop-operate/public/files";
            File uploadPath = new File(fileUploadPath);
            if (!uploadPath.exists()) uploadPath.mkdirs();
            File t = new File(uploadPath, newFileName);
            try {
                t.createNewFile();
                fileService.fileChannelCopy(file, t);
                file.delete();
                renderJson(new ApiReturn().addData("data", "public/files/" + newFileName).success());
            } catch (IOException e) {
                logger.error("文件上传失败", e);
                renderJson(new ApiReturn().addMsg("uploadFail").fail());
                return;
            }
        }
    }

    // ==================== 文章上传（已符合规范，不变） ====================

    @RequireLogin @MethodValidation("POST")
    public void uploadArticleCover() { doArticleUpload("article-cover", true, false); }

    @RequireLogin @MethodValidation("POST")
    public void uploadArticleImage() { doArticleUpload("article-image", true, false); }

    @RequireLogin @MethodValidation("POST")
    public void uploadArticleVideo() { doArticleUpload("article-video", false, true); }

    /**
     * 文章文件上传通用逻辑
     * 存储: C:/shop-operate/{shopId}/{dir}/{fname}
     * 返回: {shopId}/{dir}/{fname}
     */
    private void doArticleUpload(String dir, boolean imageOnly, boolean videoOnly) {
        User u = getSessionAttr("userinfo");
        BigInteger shopId = u != null ? u.getLoginShopId() : BigInteger.ZERO;
        List<UploadFile> uploadFileList = getFiles();
        if (uploadFileList == null || uploadFileList.isEmpty()) {
            renderJson(new ApiReturn().addMsg("未接收到文件").fail());
            return;
        }
        for (UploadFile uploadFile : uploadFileList) {
            String fileName = uploadFile.getOriginalFileName();
            if (fileName == null || fileName.isEmpty()) continue;
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (imageOnly && !isImageExt(fileExt)) {
                renderJson(new ApiReturn().addMsg("仅支持 jpg/png/gif/webp 格式").fail()); return;
            }
            if (videoOnly && !isVideoExt(fileExt)) {
                renderJson(new ApiReturn().addMsg("仅支持 mp4/mov/avi/webm/mkv 格式").fail()); return;
            }
            saveFile(uploadFile.getFile(), fileExt, shopId + "/" + dir, imageOnly, false);
        }
    }

    // ==================== 微信头像 ====================

    /**
     * 微信头像上传（无登录态）
     * POST /api/file/uploadWxAvatar
     * 存储: C:/shop-operate/public/wx-avatar/{fname}
     * 返回: public/wx-avatar/{fname}
     */
    @MethodValidation("POST")
    public void uploadWxAvatar() {
        List<UploadFile> uploadFileList = getFiles();
        if (uploadFileList == null || uploadFileList.isEmpty()) {
            renderJson(new ApiReturn().addMsg("未接收到文件").fail());
            return;
        }
        for (UploadFile uploadFile : uploadFileList) {
            String fileName = uploadFile.getOriginalFileName();
            if (fileName == null || fileName.isEmpty()) continue;
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!isImageExt(fileExt)) {
                renderJson(new ApiReturn().addMsg("不支持的文件格式").fail()); return;
            }
            saveFile(uploadFile.getFile(), fileExt, "public/wx-avatar", true, false);
        }
    }

    // ==================== 用户头像 ====================

    /**
     * 用户头像上传（需登录）
     * POST /api/file/uploadAvatar
     * 存储: C:/shop-operate/{shopId}/avatar/{fname}
     * 返回: {shopId}/avatar/{fname}
     */
    @RequireLogin @MethodValidation("POST")
    public void uploadAvatar() {
        User u = getSessionAttr("userinfo");
        BigInteger shopId = u != null ? u.getLoginShopId() : BigInteger.ZERO;
        List<UploadFile> uploadFileList = getFiles();
        if (uploadFileList == null || uploadFileList.isEmpty()) {
            renderJson(new ApiReturn().addMsg("未接收到文件").fail());
            return;
        }
        for (UploadFile uploadFile : uploadFileList) {
            String fileName = uploadFile.getOriginalFileName();
            if (fileName == null || fileName.isEmpty()) continue;
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!isImageExt(fileExt)) {
                renderJson(new ApiReturn().addMsg("不支持的文件类型: " + fileExt).fail()); return;
            }
            saveFile(uploadFile.getFile(), fileExt, shopId + "/avatar", true, false);
        }
    }

    // ==================== 发票图片 ====================

    /**
     * 发票图片上传
     * POST /api/file/uploadInvoice
     * 存储: C:/shop-operate/{shopId}/invoice/{fname}
     * 返回: {shopId}/invoice/{fname}
     */
    @RequireLogin @MethodValidation("POST")
    public void uploadInvoice() {
        User u = getSessionAttr("userinfo");
        BigInteger shopId = u.getLoginShopId();
        List<UploadFile> uploadFileList = getFiles();
        if (uploadFileList == null || uploadFileList.isEmpty()) {
            renderJson(new ApiReturn().addMsg("未接收到文件").fail());
            return;
        }
        for (UploadFile uploadFile : uploadFileList) {
            String fileName = uploadFile.getOriginalFileName();
            if (fileName == null || fileName.isEmpty()) continue;
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!isImageExt(fileExt) && !fileExt.equals("pdf")) {
                renderJson(new ApiReturn().addMsg("不支持的文件类型: " + fileExt).fail()); return;
            }
            saveFile(uploadFile.getFile(), fileExt, shopId + "/invoice", isImageExt(fileExt), false);
        }
    }

    // ==================== 店铺招牌 ====================

    /**
     * 店铺招牌照片上传
     * POST /api/file/uploadShopPhoto
     * 存储: C:/shop-operate/{shopId}/shop/{fname}
     * 返回: {shopId}/shop/{fname}
     */
    @RequireLogin @MethodValidation("POST")
    public void uploadShopPhoto() {
        User u = getSessionAttr("userinfo");
        BigInteger shopId = u != null ? u.getLoginShopId() : BigInteger.ZERO;
        List<UploadFile> uploadFileList = getFiles();
        if (uploadFileList == null || uploadFileList.isEmpty()) {
            renderJson(new ApiReturn().addMsg("未接收到文件").fail());
            return;
        }
        for (UploadFile uploadFile : uploadFileList) {
            String fileName = uploadFile.getOriginalFileName();
            if (fileName == null || fileName.isEmpty()) continue;
            String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!isImageExt(fileExt)) {
                renderJson(new ApiReturn().addMsg("不支持的文件类型: " + fileExt).fail()); return;
            }
            saveFile(uploadFile.getFile(), fileExt, shopId + "/shop", true, false);
        }
    }

    // ==================== 通用保存逻辑 ====================

    /**
     * @param relativeDir  相对于 C:/shop-operate/ 的目录路径，如 "5/avatar"
     * @param compress     是否尝试压缩（仅图片生效）
     * @param isVideo      是否视频文件
     */
    private void saveFile(File srcFile, String fileExt, String relativeDir, boolean compress, boolean isVideo) {
        String newFileName = getFileTempNameByExt(fileExt);
        String fullDir = "C:/shop-operate/" + relativeDir;
        File uploadPath = new File(fullDir);
        if (!uploadPath.exists()) uploadPath.mkdirs();
        File destFile = new File(uploadPath, newFileName);
        try {
            destFile.createNewFile();
            if (compress) {
                try {
                    ImageCompressor.compressImage(srcFile, destFile);
                } catch (Exception e) {
                    logger.warn("压缩失败，使用原图: " + e.getMessage());
                    destFile.delete();
                    destFile.createNewFile();
                    fileService.fileChannelCopy(srcFile, destFile);
                }
            } else {
                fileService.fileChannelCopy(srcFile, destFile);
            }
            srcFile.delete();
            renderJson(new ApiReturn().addData("data", relativeDir + "/" + newFileName).success());
        } catch (IOException e) {
            logger.error("文件保存失败", e);
            renderJson(new ApiReturn().addMsg("uploadFail").fail());
        }
    }

    private boolean isImageExt(String ext) {
        return ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png") || ext.equals("gif") || ext.equals("webp");
    }

    private boolean isVideoExt(String ext) {
        return ext.equals("mp4") || ext.equals("mov") || ext.equals("avi") || ext.equals("webm") || ext.equals("mkv");
    }
}
