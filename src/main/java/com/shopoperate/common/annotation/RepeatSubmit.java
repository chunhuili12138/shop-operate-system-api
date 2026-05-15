package com.shopoperate.common.annotation;

import java.lang.annotation.*;

@Inherited
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
public @interface RepeatSubmit {
    int lockTime() default 2; // 锁定时间(秒)
}
