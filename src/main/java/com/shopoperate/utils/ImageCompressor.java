package com.shopoperate.utils;

import javax.imageio.*;
import javax.imageio.stream.ImageOutputStream;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Iterator;

public class ImageCompressor {

    // 默认压缩参数
    private static final float DEFAULT_JPEG_QUALITY = 0.7f;
    private static final float DEFAULT_PNG_QUALITY = 0.8f;
    private static final float DEFAULT_GIF_QUALITY = 0.6f;
    private static final int MAX_DIMENSION = 512;

    public static void compressImage(File inputFile, File outputFile) throws IOException {
        compressImage(inputFile, outputFile, -1f);
    }

    public static void compressImage(File inputFile, File outputFile, float quality) throws IOException {
        String formatName = getFormatName(inputFile);

        // 检查文件格式是否支持
        if (!isSupportedFormat(formatName)) {
            Files.copy(inputFile.toPath(), outputFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Unsupported format: " + formatName + ". File copied without compression.");
            return;
        }

        BufferedImage originalImage = ImageIO.read(inputFile);
        if (originalImage == null) {
            System.out.println("Unable to read the input file. File copied without compression.");
            Files.copy(inputFile.toPath(), outputFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            return;
        }

        BufferedImage scaledImage = scaleImage(originalImage);

        float finalQuality = quality < 0 ? getDefaultQuality(formatName) : quality;

        // 写入压缩图片，任何异常降级为直接复制
        try {
            doCompress(outputFile, formatName, finalQuality, scaledImage);
        } catch (Exception e) {
            System.out.println("Compression failed (" + e.getMessage() + "), copying without compression.");
            if (outputFile.exists()) outputFile.delete();
            Files.copy(inputFile.toPath(), outputFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }

    private static void doCompress(File outputFile, String formatName, float finalQuality, BufferedImage scaledImage) throws IOException {
        try (ImageOutputStream output = ImageIO.createImageOutputStream(outputFile)) {
            Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName(formatName);
            if (!writers.hasNext()) {
                throw new IOException("No ImageWriter found for format: " + formatName);
            }

            ImageWriter writer = writers.next();
            try {
                writer.setOutput(output);
                ImageWriteParam param = writer.getDefaultWriteParam();
                
                boolean canCompress = false;
                try {
                    canCompress = param.canWriteCompressed();
                } catch (UnsupportedOperationException e) {
                    canCompress = false;
                }

                if (canCompress) {
                    try {
                        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
                        if (formatName.equalsIgnoreCase("jpeg") || formatName.equalsIgnoreCase("jpg")) {
                            param.setCompressionQuality(finalQuality);
                        }
                    } catch (UnsupportedOperationException e) {
                        param.setCompressionMode(ImageWriteParam.MODE_DEFAULT);
                    }
                }

                writer.write(null, new IIOImage(scaledImage, null, null), param);
            } finally {
                writer.dispose();
            }
        }
    }

    private static BufferedImage scaleImage(BufferedImage original) {
        int width = original.getWidth();
        int height = original.getHeight();

        // 计算缩放比例
        double scale = Math.min((double) MAX_DIMENSION / width, (double) MAX_DIMENSION / height);
        if (scale >= 1) return original;

        int newWidth = (int) (width * scale);
        int newHeight = (int) (height * scale);

        // 保持宽高比的缩放
        BufferedImage scaled = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = scaled.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g.drawImage(original, 0, 0, newWidth, newHeight, null);
        g.dispose();

        return scaled;
    }

    private static float getDefaultQuality(String format) {
        switch (format.toLowerCase()) {
            case "jpeg":
            case "jpg":
                return DEFAULT_JPEG_QUALITY;
            case "png":
                return DEFAULT_PNG_QUALITY;
            case "gif":
                return DEFAULT_GIF_QUALITY;
            default:
                return 0.7f;
        }
    }

    private static boolean isSupportedFormat(String format) {
        return format.equalsIgnoreCase("jpg") ||
                format.equalsIgnoreCase("jpeg") ||
                format.equalsIgnoreCase("png") ||
                format.equalsIgnoreCase("gif");
    }

    private static String getFormatName(File file) {
        String name = file.getName();
        int dotIndex = name.lastIndexOf('.');
        return (dotIndex > 0) ? name.substring(dotIndex + 1).toLowerCase() : "";
    }

}
