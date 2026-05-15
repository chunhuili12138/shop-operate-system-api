package com.shopoperate.test;

import com.shopoperate.utils.PasswordUtil;

/**
 * 密码加密测试工具
 * 用于生成BCrypt密码哈希，方便插入测试数据
 */
public class PasswordTest {
    
    public static void main(String[] args) {
        // 测试密码
        String[] testPasswords = {"123456", "admin123", "test@123"};
        
        System.out.println("========== BCrypt密码加密测试 ==========");
        System.out.println();
        
        for (String password : testPasswords) {
            String hashed = PasswordUtil.hashPassword(password);
            System.out.println("原始密码: " + password);
            System.out.println("加密后:   " + hashed);
            
            // 验证加密是否正确
            boolean matched = PasswordUtil.checkPassword(password, hashed);
            System.out.println("验证结果: " + (matched ? "✓ 匹配" : "✗ 不匹配"));
            System.out.println();
        }
        
        System.out.println("========== SQL插入示例 ==========");
        System.out.println();
        String adminPassword = PasswordUtil.hashPassword("123456");
        System.out.println("-- 创建管理员账号（密码: 123456）");
        System.out.println("INSERT INTO staff_accounts (staff_id, username, password_hash)");
        System.out.println("VALUES (1, 'admin', '" + adminPassword + "');");
        System.out.println();
    }
}
