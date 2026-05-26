package com.shopoperate.utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.jfinal.kit.Prop;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.redis.Redis;
import org.apache.log4j.Logger;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.geom.RoundRectangle2D;

/**
 * 微信 API 工具类
 * - 获取 access_token（Redis 缓存）
 * - 生成小程序太阳码（wxacode.getUnlimited）
 */
public class WechatApiUtil {

    private static final Logger log = Logger.getLogger(WechatApiUtil.class);
    private static final Gson gson = new Gson();
    private static final String TOKEN_URL = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s";
    private static final String WXACODE_URL = "https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token=%s";
    private static final String ACCESS_TOKEN_KEY = "wx:access_token";

    /**
     * 获取 access_token（Redis 缓存，有效期 7000s）
     */
    public static String getAccessToken() {
        String cached = Redis.call(j -> j.get(ACCESS_TOKEN_KEY));
        if (cached != null && !cached.isEmpty()) return cached;

        Prop p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
        String appId = p.get("appId");
        String appSecret = p.get("appSecret");

        String url = String.format(TOKEN_URL, appId, appSecret);
        try {
            String resp = httpGet(url);
            JsonObject json = gson.fromJson(resp, JsonObject.class);
            if (json.has("access_token")) {
                String token = json.get("access_token").getAsString();
                int expires = json.has("expires_in") ? json.get("expires_in").getAsInt() - 200 : 7000;
                Redis.call(j -> j.setex(ACCESS_TOKEN_KEY, expires, token));
                return token;
            }
            log.error("获取 access_token 失败: " + resp);
        } catch (Exception e) {
            log.error("获取 access_token 异常", e);
        }
        return null;
    }

    /**
     * 生成小程序太阳码并保存到本地文件
     * @param scene 场景值，如 "sid=123"
     * @param page  小程序页面路径，如 "pages/index/index"
     * @param width 二维码宽度（430-1280）
     * @param outputPath 输出文件绝对路径
     * @return 成功返回 true
     */
    public static boolean generateWxaCode(String scene, String page, int width, String outputPath) {
        String accessToken = getAccessToken();
        if (accessToken == null) return false;

        String urlStr = String.format(WXACODE_URL, accessToken);
        try {
            JsonObject body = new JsonObject();
            body.addProperty("scene", scene);
            body.addProperty("page", page);
            body.addProperty("width", width);
            body.addProperty("check_path", false);
            body.addProperty("env_version", "release");

            byte[] result = httpPost(urlStr, body.toString());

            // 检查是否返回了 JSON 错误
            if (result.length < 500) {
                String s = new String(result, StandardCharsets.UTF_8);
                if (s.startsWith("{")) {
                    JsonObject err = gson.fromJson(s, JsonObject.class);
                    log.error("生成太阳码失败: " + s);
                    return false;
                }
            }

            // 确保目录存在
            File outFile = new File(outputPath);
            if (!outFile.getParentFile().exists()) {
                outFile.getParentFile().mkdirs();
            }

            Files.write(Paths.get(outputPath), result);
            return true;
        } catch (Exception e) {
            log.error("生成太阳码异常", e);
            return false;
        }
    }

    private static String httpGet(String urlStr) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line);
        reader.close();
        conn.disconnect();
        return sb.toString();
    }

    private static byte[] httpPost(String urlStr, String jsonBody) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(8000);
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/json");
        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            os.flush();
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (InputStream is = conn.getInputStream()) {
            byte[] buf = new byte[4096];
            int n;
            while ((n = is.read(buf)) != -1) baos.write(buf, 0, n);
        }
        conn.disconnect();
        return baos.toByteArray();
    }

    /**
     * 将 Logo 图片合成到太阳码中心（圆形裁剪 + 白边）
     * @param qrcodePath 太阳码图片路径
     * @param logoPath   Logo 图片路径
     * @param outputPath 输出图片路径
     */
    public static void overlayLogoOnQrcode(String qrcodePath, String logoPath, String outputPath) {
        try {
            BufferedImage qrcode = ImageIO.read(new File(qrcodePath));
            File logoFile = new File(logoPath);
            if (!logoFile.exists()) return;
            BufferedImage logo = ImageIO.read(logoFile);

            int qrSize = qrcode.getWidth();
            int logoSize = (int) (qrSize * 0.22); // Logo 占 22%
            int logoX = (qrSize - logoSize) / 2;
            int logoY = (qrSize - logoSize) / 2;

            Graphics2D g = qrcode.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

            // 白底圆形
            int padding = 4;
            g.setColor(Color.WHITE);
            g.fill(new RoundRectangle2D.Float(logoX - padding, logoY - padding,
                logoSize + padding * 2, logoSize + padding * 2, logoSize / 4, logoSize / 4));

            // 裁剪为圆形
            BufferedImage rounded = new BufferedImage(logoSize, logoSize, BufferedImage.TYPE_INT_ARGB);
            Graphics2D g2 = rounded.createGraphics();
            g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2.setClip(new RoundRectangle2D.Float(0, 0, logoSize, logoSize, logoSize / 4, logoSize / 4));
            g2.drawImage(logo.getScaledInstance(logoSize, logoSize, Image.SCALE_SMOOTH), 0, 0, null);
            g2.dispose();

            g.drawImage(rounded, logoX, logoY, null);
            g.dispose();

            ImageIO.write(qrcode, "png", new File(outputPath));
        } catch (Exception e) {
            log.warn("合成Logo到太阳码失败: " + e.getMessage());
        }
    }
}
