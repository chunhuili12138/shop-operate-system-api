package com.shopoperate.common.annotation;

import java.lang.annotation.*;

/**
 * 需要权限验证的注解
 * 在 Controller 方法上添加此注解，表示该接口需要指定 menu_code 权限
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Inherited
@Documented
@Retention(RetentionPolicy.RUNTIME)
public @interface RequirePermission {
    /**
     * 所需的权限编码（menu_code）
     */
    String value();

    /**
     * 权限校验失败时的提示信息
     */
    String message() default "无权限访问";
}
