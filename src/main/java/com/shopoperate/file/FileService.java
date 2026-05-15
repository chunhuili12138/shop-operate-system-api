package com.shopoperate.file;

import java.io.*;
import java.nio.channels.FileChannel;

public class FileService {

    public static final FileService me = new FileService();

    public void fileChannelCopy(File s, File t) {
        //文件输入流
        FileInputStream fi = null;
        //文件输出流
        FileOutputStream fo = null;
        FileChannel in = null;
        FileChannel out = null;
        try {
            fi = new FileInputStream(s);
            fo = new FileOutputStream(t);
            //获取读入的文件通道
            in = fi.getChannel();
            //获取写出的文件通道
            out = fo.getChannel();
            // 连接两个通道，从文件输入流读取数据到文件输出流
            in.transferTo(0, in.size(), out);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                assert fi != null;
                fi.close();
                assert in != null;
                in.close();
                fo.close();
                assert out != null;
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public String getMimeType(File file) {
        String fileName = file.getName();
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex == -1) {
            return "application/octet-stream"; // 默认MIME类型
        }
        String extension = fileName.substring(dotIndex + 1).toLowerCase();
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            // 添加更多MIME类型映射...
            default:
                return "application/octet-stream";
        }
    }
}
