package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.jfinal.json.Json;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.common.annotation.RepeatSubmit;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.HttpKit;
import org.apache.commons.codec.digest.DigestUtils;

import java.lang.reflect.Method;

public class RepeatSubmitInterceptor implements Interceptor {
    private static final String REPEAT_KEY = "repeat:";

    public void intercept(Invocation inv) {
        Method method = inv.getMethod();
        if (method.isAnnotationPresent(RepeatSubmit.class)) {
            Controller ctrl = inv.getController();

            // 生成请求指纹
            String clientIP = HttpKit.getClientIP(ctrl.getRequest());
            String paramsHash = DigestUtils.md5Hex(Json.getJson().toJson(ctrl.getParaMap()));
            String redisKey = REPEAT_KEY + clientIP + ":" + paramsHash;

            // Redis原子操作设置锁
            boolean isLock = Redis.use().setnx(redisKey, "1") == 1;
            if (!isLock) {
                ctrl.renderJson(new ApiReturn().repeatSubmit());
                return;
            }

            // 设置过期时间
            Redis.use().expire(redisKey, method.getAnnotation(RepeatSubmit.class).lockTime());
        }
        inv.invoke();
    }
}