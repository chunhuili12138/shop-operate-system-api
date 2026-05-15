package com.shopoperate.utils;

/**
 * 常量
 * */
public class Constants {

    /**
     * 是否状态 - 是
     */
    public static final int YES = 1;
    /**
     * 是否状态 - 否
     */
    public static final int NO = 0;

    /**
     * 是否删除 - 删除
     */
    public static final int IS_DEL_YES = 1;
    /**
     * 是否删除 - 未删除
     */
    public static final int IS_DEL_NO = 0;

    /**
     * 邀请状态 - 等待确认
     */
    public static final int AUDIT_WAITING = 0;
    /**
     * 邀请状态 - 同意
     */
    public static final int AUDIT_SUCCESS = 1;
    /**
     * 邀请状态 - 拒绝
     */
    public static final int AUDIT_FAILED = 2;

    // ==================== 通知类型常量 ====================
    
    /**
     * 通知类型 - 账本加入申请
     */
    public static final String NOTIFICATION_TYPE_BOOK_JOIN_REQUEST = "book_join_request";
    
    /**
     * 通知类型 - 成员退出账本
     */
    public static final String NOTIFICATION_TYPE_BOOK_JOIN_QUIT = "book_join_quit";
    
    /**
     * 通知类型 - 合同到期
     */
    public static final String NOTIFICATION_TYPE_CONTRACT_EXPIRE = "contract_expire";
    
    /**
     * 通知类型 - 账单生成
     */
    public static final String NOTIFICATION_TYPE_BILL_GENERATED = "bill_generated";
    
    /**
     * 通知类型 - 账单逾期
     */
    public static final String NOTIFICATION_TYPE_BILL_OVERDUE = "bill_overdue";

    // ==================== 通知级别常量 ====================
    
    /**
     * 通知级别 - 警告
     */
    public static final String NOTIFICATION_LEVEL_WARNING = "warning";
    
    /**
     * 通知级别 - 信息
     */
    public static final String NOTIFICATION_LEVEL_INFO = "info";

}
