package com.shopoperate.utils;

import com.shopoperate.common.model.OperationLogs;

import java.math.BigInteger;
import java.util.Date;

/**
 * 操作日志工具类
 */
public class OperationLogUtil {
    
    /**
     * 记录操作日志
     * 
     * @param operatorType 操作人类型（1-staff, 2-customer）
     * @param operatorId 操作人ID
     * @param action 操作类型（login/logout/add/update/delete等）
     * @param targetType 目标对象类型（staff/shop/customer等）
     * @param targetId 目标对象ID
     * @param detail 操作详情（JSON格式）
     * @param ipAddress IP地址
     */
    public static void log(Integer operatorType, BigInteger operatorId, String action, 
                          String targetType, BigInteger targetId, String detail, String ipAddress) {
        try {
            OperationLogs log = new OperationLogs();
            log.setOperatorType(operatorType);
            log.setOperatorId(operatorId);
            log.setAction(action);
            log.setTargetType(targetType);
            log.setTargetId(targetId);
            log.setDetail(detail);
            log.setIpAddress(ipAddress);
            log.setCreatedAt(new Date());
            log.save();
        } catch (Exception e) {
            // 日志记录失败不影响主流程
            e.printStackTrace();
        }
    }
    
    /**
     * 记录登录日志
     */
    public static void logLogin(BigInteger staffId, String ipAddress, boolean success, String message) {
        String detail = String.format("{\"success\":%b,\"message\":\"%s\"}", success, message);
        log(1, staffId, success ? "login" : "login_failed", 
            "staff", staffId, detail, ipAddress);
    }
    
    /**
     * 记录退出登录日志
     */
    public static void logLogout(BigInteger staffId, String ipAddress) {
        log(1, staffId, "logout", "staff", staffId, null, ipAddress);
    }
}
