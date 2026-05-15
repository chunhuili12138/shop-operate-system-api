package com.shopoperate.utils;

import org.mindrot.jbcrypt.BCrypt;

import java.util.regex.Pattern;

/**
 * BCrypt密码加密 + 密码强度校验工具类
 *
 * 密码规则（与前端对齐）：
 * - 长度 8-18 位
 * - 必须包含数字、小写字母、大写字母、符号中的至少两种
 * - 不能包含中文
 */
public class PasswordUtil {

    /** 密码正则：8-18位，数字/小写/大写/符号至少两种组合，不含中文 */
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)]|[()])+$)(?!^.*[\\u4E00-\\u9FA5].*$)" +
        "([^(0-9a-zA-Z)]|[()]|[a-z]|[A-Z]|[0-9]){8,18}$"
    );

    /**
     * 校验密码强度
     * @param plainPassword 明文密码
     * @return null=合法，非null=错误提示信息
     */
    public static String validatePassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return "密码不能为空";
        }
        if (plainPassword.length() < 8 || plainPassword.length() > 18) {
            return "密码长度须为8-18位";
        }
        if (!PASSWORD_PATTERN.matcher(plainPassword).matches()) {
            return "密码须为数字、字母、符号的任意两种组合";
        }
        return null;
    }

    /**
     * 对密码进行加密
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * 验证密码是否匹配
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
