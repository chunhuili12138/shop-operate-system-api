package com.shopoperate.utils;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import javax.imageio.ImageIO;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import static com.shopoperate.utils.Tool.getUUId;

public class CaptchaUtil {
    private static final int WIDTH = 120;
    private static final int HEIGHT = 50;
    private static final String[] FONT_NAMES = { "Verdana", "Georgia", "Arial Rounded MT Bold" }; // 增加字体种类

    public static Map<String, String> getCaptchaQuestion() {
        // 原有逻辑保持不变
        Random random = new Random();
        int num1 = random.nextInt(10);
        int num2 = random.nextInt(10);
        int operation = random.nextInt(3);
        String question;
        int result;
        switch (operation) {
            case 0:
                question = num1 + "+" + num2;
                result = num1 + num2;
                break;
            case 1:
                question = num1 + "-" + num2;
                result = num1 - num2;
                break;
            case 2:
                question = num1 + "x" + num2;
                result = num1 * num2;
                break;
            default:
                question = num1 + "x" + num2;
                result = num1 * num2;
        }
        Map<String, String> resultMap = new HashMap<>();
        resultMap.put("question", question);
        resultMap.put("captchaId", getUUId());
        resultMap.put("result", result + "");
        return resultMap;
    }

    public static byte[] getCaptchaImage(String captchaQuestion) throws IOException {
        BufferedImage bufferedImage = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = bufferedImage.createGraphics();

        // 设置更高质量的抗锯齿
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);

        // 生成更柔和的渐变背景
        Random random = new Random();
        Color startColor = generatePastelColor(random); // 使用柔和的颜色
        Color endColor = generatePastelColor(random);
        GradientPaint gradient = new GradientPaint(
                random.nextInt(20), random.nextInt(20), // 随机起点
                startColor,
                WIDTH - random.nextInt(20), HEIGHT - random.nextInt(20), // 随机终点
                endColor);
        g.setPaint(gradient);
        g.fillRect(0, 0, WIDTH, HEIGHT);

        // 添加干扰元素（减少数量，增加种类）
        addNoise(g, WIDTH, HEIGHT, random);

        // 绘制验证码文字
        drawText(g, captchaQuestion, random);

        g.dispose();
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ImageIO.write(bufferedImage, "png", outputStream);
        return outputStream.toByteArray();
    }

    private static Color generatePastelColor(Random random) {
        // 生成柔和的颜色（150-225范围）
        return new Color(
                150 + random.nextInt(75),
                150 + random.nextInt(75),
                150 + random.nextInt(75));
    }

    private static void addNoise(Graphics2D g, int width, int height, Random random) {
        // 添加半透明干扰线
        for (int i = 0; i < 3; i++) {
            g.setColor(new Color(
                    random.nextInt(256),
                    random.nextInt(256),
                    random.nextInt(256),
                    100)); // 半透明效果
            g.drawLine(
                    random.nextInt(width),
                    random.nextInt(height),
                    random.nextInt(width),
                    random.nextInt(height));
        }

        // 添加少量干扰点
        for (int i = 0; i < 50; i++) { // 减少数量
            int x = random.nextInt(width);
            int y = random.nextInt(height);
            int size = random.nextInt(3) + 1;
            g.setColor(new Color(
                    random.nextInt(256),
                    random.nextInt(256),
                    random.nextInt(256),
                    random.nextInt(100) + 50)); // 半透明效果
            g.fillOval(x, y, size, size);
        }
    }

    private static void drawText(Graphics2D g, String text, Random random) {
        char[] chars = text.toCharArray();
        int x = 10;
        int baseY = HEIGHT / 2 + 10;

        for (int i = 0; i < chars.length; i++) {
            // 随机选择字体和样式
            String fontName = FONT_NAMES[random.nextInt(FONT_NAMES.length)];
            int style = random.nextBoolean() ? Font.BOLD : Font.ITALIC;
            int size = 24 + random.nextInt(8); // 适当放大字号

            Font font = new Font(fontName, style, size);
            g.setFont(font);

            // 生成高对比度文字颜色
            Color textColor = generateContrastColor(g.getBackground(), random);

            // 设置文字阴影
            g.setColor(textColor.darker());
            g.drawString(String.valueOf(chars[i]), x + 1, baseY - 1);

            // 绘制主文字
            g.setColor(textColor);
            g.drawString(String.valueOf(chars[i]), x, baseY);

            // 添加字符间距和轻微旋转
            x += size + 4;
            double rotate = (random.nextDouble() - 0.5) * Math.PI / 9; // 减小旋转角度
            g.rotate(rotate, x, baseY);
        }
    }

    private static Color generateContrastColor(Color bgColor, Random random) {
        // 生成与背景色高对比的颜色
        Color textColor;
        do {
            textColor = new Color(
                    random.nextInt(156) + 50,
                    random.nextInt(156) + 50,
                    random.nextInt(156) + 50);
        } while (getContrastRatio(bgColor, textColor) < 4.5); // WCAG AA标准
        return textColor;
    }

    private static double getContrastRatio(Color c1, Color c2) {
        // 计算对比度比率（WCAG标准）
        double l1 = getLuminance(c1) + 0.05;
        double l2 = getLuminance(c2) + 0.05;
        return (l1 > l2) ? l1 / l2 : l2 / l1;
    }

    private static double getLuminance(Color color) {
        // 计算相对亮度
        double r = color.getRed() / 255.0;
        double g = color.getGreen() / 255.0;
        double b = color.getBlue() / 255.0;

        r = (r <= 0.03928) ? r / 12.92 : Math.pow((r + 0.055) / 1.055, 2.4);
        g = (g <= 0.03928) ? g / 12.92 : Math.pow((g + 0.055) / 1.055, 2.4);
        b = (b <= 0.03928) ? b / 12.92 : Math.pow((b + 0.055) / 1.055, 2.4);

        return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }
}