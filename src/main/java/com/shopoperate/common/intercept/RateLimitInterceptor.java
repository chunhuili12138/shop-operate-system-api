package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.utils.ApiReturn;
import com.shopoperate.utils.HttpKit;

public class RateLimitInterceptor implements Interceptor {

    // 时间窗口（单位：秒）
    private static final int TIME_WINDOW = 1;
    // 最大请求次数
    private static final int MAX_REQUESTS = 50;

    @Override
    public void intercept(Invocation inv) {
        Controller c = inv.getController();
        String clientIP = HttpKit.getClientIP(c.getRequest());

        String key = "rate_limit:" + clientIP;
        Long count = Redis.use().incr(key);

        if (count == 1) {
            Redis.use().expire(key, TIME_WINDOW);
        }
        if (count > MAX_REQUESTS) {
            c.renderJson(new ApiReturn().tooManyRequest());
            return;
        }

        inv.invoke();
    }
}
