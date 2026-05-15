package com.shopoperate.utils;

import com.jfinal.kit.Prop;
import com.jfinal.kit.PropKit;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class CryptUtil {

    // 使用AES密钥长度（128位、192位或256位）
    private static final int AES_KEY_SIZE = 128; // 16 bytes

    // 加密方法
    public static String encrypt(String plainText, String secretKey) throws Exception {
        // 从密钥字符串获取密钥字节（这里为了简化直接使用了）
        byte[] keyBytes = secretKey.getBytes(StandardCharsets.UTF_8);

        // 截断或填充密钥字节到正确的长度（在实际应用中应避免这样做）
        byte[] key = new byte[AES_KEY_SIZE / 8];
        System.arraycopy(keyBytes, 0, key, 0, Math.min(keyBytes.length, key.length));

        // 创建SecretKeySpec
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");

        // 创建Cipher实例
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);

        // 执行加密操作
        byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

        // 将加密后的字节转换为Base64字符串
        return Base64.getEncoder().encodeToString(encrypted);
    }

    // 解密方法
    public static String decrypt(String encryptedText, String secretKey) throws Exception {
        // 从密钥字符串获取密钥字节（与加密时相同）
        byte[] keyBytes = secretKey.getBytes(StandardCharsets.UTF_8);

        // 截断或填充密钥字节到正确的长度（同样，这在实际应用中是不安全的）
        byte[] key = new byte[AES_KEY_SIZE / 8];
        System.arraycopy(keyBytes, 0, key, 0, Math.min(keyBytes.length, key.length));

        // 创建SecretKeySpec
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");

        // 创建Cipher实例
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);

        // 将Base64字符串解码为字节
        byte[] original = cipher.doFinal(Base64.getDecoder().decode(encryptedText));

        // 将字节转换回字符串
        return new String(original, StandardCharsets.UTF_8);
    }

    /**
     * 加字符串密
     * */
    public static String encryptStr(String originalStr) throws Exception {
        Prop p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
        String key = p.get("cryptKey");
        return encrypt(originalStr, key);
    }

    /**
     * 字符串解密
     * */
    public static String decryptStr(String encryptStr) throws Exception {
        Prop p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
        String key = p.get("cryptKey");
        return decrypt(encryptStr, key);
    }
}
