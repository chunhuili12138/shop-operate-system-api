package com.shopoperate.utils;

import java.io.*;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class FileUtil {
    private final static String format_date = "yyyy-MM-dd";

    /**
     * 检查文件夹是否存在（true存在，false不存在）
     *
     * @param path
     * @return boolean
     */
    public static boolean checkFolder(String path) {
        File file = new File(path);
        return file.isDirectory();
    }

    /**
     * 检查文件是否存在（true存在，false不存在）
     *
     * @param path
     * @return boolean
     */
    public static boolean checkFile(String path) {
        File file = new File(path);
        return file.exists();
    }

    /**
     * 生成指定位数的字符串
     *
     * @param rand
     * @param pos
     * @return String
     */
    public static String toStringNum(Integer rand, Integer pos) {
        String Sn = String.valueOf(rand);
        if (Sn == null) {
            return "";
        }
        Integer i = pos - Sn.length();
        while (i > 0) {
            Sn = "0" + Sn;
            i--;
        }
        return Sn;
    }

    /**
     * 根据日前生成字符串
     *
     * @param pos
     * @return String
     */
    public static String toStringNum(Integer pos) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Date currentTime = new Date();// 得到当前系统时间
        String FILE_ADDR = (String) formatter.format(currentTime);
        Random random = new Random();
        Integer rand = random.nextInt(999999999);
        String Sn = String.valueOf(rand);
        if (Sn == null) {
            return "";
        }
        Integer i = pos - Sn.length();
        while (i > 0) {
            Sn = "0" + Sn;
            i--;
        }
        return FILE_ADDR + Sn;
    }

    /**
     * 根据日前生成字符串
     *
     * @param pos
     *            随机几位数
     * @return String
     */
    public static String getRandNumString(Integer pos) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Date currentTime = new Date();// 得到当前系统时间
        String FILE_ADDR = (String) formatter.format(currentTime);
        Random random = new Random();
        Integer rand = random.nextInt(999999999);
        String Sn = String.valueOf(rand);
        if (Sn == null) {
            return "";
        }
        Integer i = pos - Sn.length();
        while (i > 0) {
            Sn = "0" + Sn;
            i--;
        }
        return FILE_ADDR + Sn;
    }

    /**
     * 返回随机临时文件名
     *
     * @param ext
     *            后缀名 如"doc"
     * @return String
     */
    public static synchronized String getFileTempNameByExt(String ext) {
        if (ext == null){
            ext = "txt";
        }
        Date dt = new Date(System.currentTimeMillis());
        SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String fileName = fmt.format(dt);
        Random rand = new Random();// 生成随机数
        int random = rand.nextInt();
        fileName = fileName + "_"
                + String.valueOf(random > 0 ? random : (-1) * random) + "." + ext;
        return fileName;
    }

    /**
     * 返回随机临时文件名
     *
     * @param filename
     *            文件全名
     * @return String
     */
    public static synchronized String getFileTempName(String filename) {
        String ext = "";
        if (filename.lastIndexOf(".") != -1) {
            ext = filename.substring(filename.lastIndexOf("."));
        }
        Date dt = new Date(System.currentTimeMillis());
        SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String fileName = fmt.format(dt);
        Random rand = new Random();// 生成随机数
        int random = rand.nextInt();
        fileName = fileName + "_"
                + String.valueOf(random > 0 ? random : (-1) * random) + ext;
        return fileName;
    }

    /**
     * 根据文件名返回后缀名
     *
     * @param fileName
     * @return String
     */
    public static String getPostFix(String fileName) {
        String x[] = fileName.split("\\.");
        if (x.length < 1){
            return "";
        }
        return x[x.length - 1];
    }

    /**
     * 获取文件大小
     *
     * @param filesize
     * @return String
     */
    public static String FormatFileSize(long filesize) {
        DecimalFormat formater = new DecimalFormat(".##");
        formater.applyPattern(".00");
        BigDecimal filesizeBD = new BigDecimal(filesize);
        BigDecimal num = null;
        if (filesize < 0) {
            return "";
        } else if (filesize >= 1024 * 1024 * 1024) {
            // 文件大小大于或等于1024MB
            num = new BigDecimal(1024 * 1024 * 1024);
            filesizeBD = filesizeBD.divide(num, 2, BigDecimal.ROUND_HALF_UP);
            return formater.format(filesizeBD) + " GB";
        } else if (filesize >= 1024 * 1024) {
            // 文件大小大于或等于1024KB
            num = new BigDecimal(1024 * 1024);
            filesizeBD = filesizeBD.divide(num, 2, BigDecimal.ROUND_HALF_UP);
            return formater.format(filesizeBD) + " MB";
        } else if (filesize >= 1024) {
            // 文件大小大于等于1024bytes
            num = new BigDecimal(1024);
            filesizeBD = filesizeBD.divide(num, 2, BigDecimal.ROUND_HALF_UP);
            return formater.format(filesizeBD) + " KB";
        } else {
            return formater.format(filesizeBD) + " bytes";
        }
    }

    /** *********************返回集合*************************** */

    /**
     * 遍历文件夹
     *
     * @param path
     */
    public static List<String> getFolderName(String path) {
        List<String> list = new ArrayList<String>();
        try {
            File dir = new File(path);
            String[] fs = dir.list();
            if (fs != null && fs.length > 0) {
                for (int i = 0; i < fs.length; i++) {
                    if (fs[i].indexOf(".") != -1) {
                    } else {
                        list.add(fs[i] + "");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return list;
    }

    /**
     * 遍历文件(集合中只有文件名)
     *
     * @param path
     */
    public static List<String> getFileName(String path) {
        List<String> list = new ArrayList<String>();
        File d = new File(path);// 建立当前目录中文件的File对象
        File[] fl = d.listFiles();// 取得目录中所有文件的File对象数组
        if (fl != null && fl.length > 0) {
            for (int i = 0; i < fl.length; i++) {
                // 目录下的文件：
                File e = fl[i];
                if (e.isFile()) {
                    list.add(e.getName() + "");
                }
            }
        }
        return list;
    }

    /**
     * 遍历文件(集合中有文件对象)
     * @param path
     * @return List<File>
     */
    public static List<File> getFileList(String path) {
        List<File> list = new ArrayList<File>();
        File file = new File(path);
        if (file.exists() && file.isDirectory()) {
            File[] files = file.listFiles();
            for (File file2 : files) {
                list.add(file2);
            }
        }
        return list;
    }

    /** *********************创建*************************** */

    /**
     * 创建文件夹
     *
     * @param path
     *            路径
     */
    public static void createFolder(String path) {
        File folder = new File(path);
        if (!folder.exists()) {
            folder.mkdirs();
        }
    }

    /**
     * 按时间(年月)来创建分时文件夹
     *
     * @param Path
     * @return String
     */
    public static String makeDateDir(String Path) {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(format_date);
        String str = formatter.format(date);
        File dir = null;
        Path = Path + File.separator + str + File.separator;
        dir = new File(Path);
        if (!dir.exists()) {
            dir.mkdirs(); // 检查dir目录是否存在,没有则建立dir目录
        }
        return Path;
    }


    /**
     * 追加当前日期
     * @param path
     * @return
     */
    public static String appendCurrentDate(String path) {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(format_date);
        String str = formatter.format(date);
        path = path + "/" + str + "/";
        return path ;
    }


    /**
     * 写入文件
     *
     * @param dirStart
     *            复制起始目录文件
     * @param dirEnd
     *            复制目标目录文件
     */
    public static void writeFile(String dirStart, String dirEnd) {
        try {
            File file = new File(dirEnd);
            if (!file.exists()) {
                BufferedInputStream bis = new BufferedInputStream(
                        new FileInputStream(dirStart));
                BufferedOutputStream bos = new BufferedOutputStream(
                        new FileOutputStream(dirEnd));
                int i = 0;
                byte[] b = new byte[1024];
                while ((i = bis.read(b, 0, b.length)) != -1) {
                    bos.write(b, 0, i);
                }
                bos.flush();
                bos.close();
                bis.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 复制文件(用流)开始路径文件没删除
     *
     * @param dirStart
     *            开始路径(E:\\entProcessFile\\FA5DD6D4459E4B60BFBFD212D4D17AE2)
     * @param dirEnd
     *            目的路径(E:\\entOfficialFile\\AAADD6D4459E4B60BFBFD212D4D17AE2)
     * @return String
     */
    public static String fileCopyIO(String dirStart, String dirEnd) {
        try {
            if (dirStart == null || "".equals(dirStart) || dirEnd == null
                    || "".equals(dirEnd)) {
                return "路径为空!";
            }
            FileUtil.createFolder(dirEnd);
            List<File> fileList = FileUtil.getFileList(dirStart);
            if (fileList == null || fileList.size() <= 0) {
                return "开始路径下没有文件!";
            }
            for (int i = 0; i < fileList.size(); i++) {
                String filename = fileList.get(i).getName();
                String fileStart = dirStart + "\\" + filename;
                String fileEnd = dirEnd + "\\" + filename;
                FileUtil.writeFile(fileStart, fileEnd);
            }
        } catch (Exception e) {
            return "复制文件异常!";
        }
        return "success";
    }

    /**
     * 复制文件(用File.renameTo)开始路径文件删除
     *
     * @param dirStart
     *            开始路径(E:\\entProcessFile\\FA5DD6D4459E4B60BFBFD212D4D17AE2)
     * @param dirEnd
     *            目的路径(E:\\entOfficialFile\\AAADD6D4459E4B60BFBFD212D4D17AE2)
     * @return String
     */
    public static String fileCopy(String dirStart, String dirEnd) {
        try {
            if (dirStart == null || "".equals(dirStart) || dirEnd == null
                    || "".equals(dirEnd)) {
                return "路径为空!";
            }
            // 移动时如果E:\\entOfficialFile文件夹不存在，无法移动，要初始好最终文件夹前一级
            String[] dirArr = dirEnd.split("\\\\");
            if (dirArr == null || dirArr.length <= 0) {
                return "路径错误!";
            }
            String pathEnd = "";
            for (int i = 0; i < dirArr.length - 1; i++) {
                pathEnd += dirArr[i] + File.separator;
            }
            FileUtil.createFolder(pathEnd);
            // 移动文件
            File file = new File(dirStart);
            File file2 = new File(dirEnd);
            file.renameTo(file2);
        } catch (Exception e) {
            return "复制文件异常";
        }
        return "success";
    }

    /** *********************删除*************************** */

    /**
     * 递归删除文件
     *
     * @param f
     */
    public static void deleteFile(File f) {
        if (f.isDirectory()) {
            File[] list = f.listFiles();
            for (int i = 0; i < list.length; i++) {
                deleteFile(list[i]);
            }
        }
        f.delete();
    }

    /**
     * 通过文件路径删除文件
     *
     * @param path
     * @return boolean
     */
    public static boolean delFileByPath(String path) {
        if (path == null || "".equals(path)) {
            return true;
        }
        File file = new File(path);
        if (file.exists()) {
            if (file.delete()) {
                return true;
            } else {
                return false;
            }
        }
        return true;
    }


    /**
     * 写入文件
     * @param path
     * @param content
     * @param encoding
     * @throws Exception
     */
    public static void writeFile(String path , String content , String encoding) throws Exception {
        File file = new File(path);
        if(!file.exists()){
            file.mkdirs();
        }
        FileOutputStream fos = new FileOutputStream(file);
        OutputStreamWriter out = new OutputStreamWriter(fos, encoding);
        out.write(content);
        out.flush();

        fos.close();
        out.close();
    }


    /**
     * 获取目录下所有文件
     * @param dir
     * @param files
     * @param dirs
     *  
     */
    public static void getFiles(String dir, List<File> files, List<String> dirs) {
        File[] list = new File(dir).listFiles();
        for (File f : list) {
            if (f.isFile()) {
                files.add(f);
            } else if (f.isDirectory()) {
                dirs.add(f.getPath().replace("\\", "/"));
                getFiles(f.getPath(), files, dirs);
            }
        }
    }

    /**
     * 删除文件，可以是单个文件或文件夹
     *
     * @param fileName 待删除的文件名
     * @return 文件删除成功返回true, 否则返回false
     */
    public static boolean delete(String fileName) {
        File file = new File(fileName);
        if (!file.exists()) {
            System.out.println("删除文件失败：" + fileName + "文件不存在");
            return false;
        } else {
            if (file.isFile()) {

                return deleteFile(fileName);
            } else {
                return deleteDirectory(fileName);
            }
        }
    }

    /**
     * 删除单个文件
     *
     * @param fileName 被删除文件的文件名
     * @return 单个文件删除成功返回true, 否则返回false
     */
    public static boolean deleteFile(String fileName) {
        File file = new File(fileName);
        if (file.isFile() && file.exists()) {
            file.delete();
            System.out.println("删除单个文件" + fileName + "成功！");
            return true;
        } else {
            System.out.println("删除单个文件" + fileName + "失败！");
            return false;
        }
    }

    /**
     * 删除目录（文件夹）以及目录下的文件
     *
     * @param dir 被删除目录的文件路径
     * @return 目录删除成功返回true, 否则返回false
     */
    public static boolean deleteDirectory(String dir) {
        // 如果dir不以文件分隔符结尾，自动添加文件分隔符
        if (!dir.endsWith(File.separator)) {
            dir = dir + File.separator;
        }
        File dirFile = new File(dir);
        // 如果dir对应的文件不存在，或者不是一个目录，则退出
        if (!dirFile.exists() || !dirFile.isDirectory()) {
            System.out.println("删除目录失败" + dir + "目录不存在！");
            return false;
        }
        boolean flag = true;
        // 删除文件夹下的所有文件(包括子目录)
        File[] files = dirFile.listFiles();
        for (int i = 0; i < files.length; i++) {
            // 删除子文件
            if (files[i].isFile()) {
                flag = deleteFile(files[i].getAbsolutePath());
                if (!flag) {
                    break;
                }
            }
            // 删除子目录
            else {
                flag = deleteDirectory(files[i].getAbsolutePath());
                if (!flag) {
                    break;
                }
            }
        }

        if (!flag) {
            System.out.println("删除目录失败");
            return false;
        }

        // 删除当前目录
        if (dirFile.delete()) {
            System.out.println("删除目录" + dir + "成功！");
            return true;
        } else {
            System.out.println("删除目录" + dir + "失败！");
            return false;
        }
    }
    // 删除文件夹
    // param folderPath 文件夹完整绝对路径

    public static void delFolder(String folderPath) {
        try {
            delAllFile(folderPath); // 删除完里面所有内容
            String filePath = folderPath;
            filePath = filePath.toString();
            File myFilePath = new File(filePath);
            myFilePath.delete(); // 删除空文件夹
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 删除指定文件夹下所有文件
    // param path 文件夹完整绝对路径
    public static boolean delAllFile(String path) {
        boolean flag = false;
        File file = new File(path);
        if (!file.exists()) {
            return flag;
        }
        if (!file.isDirectory()) {
            return flag;
        }
        String[] tempList = file.list();
        File temp = null;
        for (int i = 0; i < tempList.length; i++) {
            if (path.endsWith(File.separator)) {
                temp = new File(path + tempList[i]);
            } else {
                temp = new File(path + File.separator + tempList[i]);
            }
            if (temp.isFile()) {
                temp.delete();
            }
            if (temp.isDirectory()) {
                delAllFile(path + "/" + tempList[i]);// 先删除文件夹里面的文件
                delFolder(path + "/" + tempList[i]);// 再删除空文件夹
                flag = true;
            }
        }
        return flag;
    }

}
