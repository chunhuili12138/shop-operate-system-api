package com.shopoperate.common.annotation;

import java.lang.annotation.*;

/**
 * 需要登录验证的注解
 * 在Controller方法上添加此注解，表示该接口需要Token验证
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Inherited
@Documented
@Retention(RetentionPolicy.RUNTIME)
public @interface RequireLogin {
}
