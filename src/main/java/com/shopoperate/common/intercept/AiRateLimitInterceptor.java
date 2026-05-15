package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.jfinal.plugin.redis.Redis;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;

import java.math.BigInteger;

public class AiRateLimitInterceptor implements Interceptor {

    private static final String COOLDOWN_KEY_PREFIX = "ai_receipt_cooldown:";
    private static final String DAILY_COUNT_KEY_PREFIX = "ai_receipt_daily:";

    private static final int COOLDOWN_SECONDS = 20;
    private static final int MAX_DAILY_REQUESTS = 20;

    @Override
    public void intercept(Invocation inv) {
        Controller c = inv.getController();
        User user = c.getSessionAttr("userinfo");

        if (user == null) {
            c.renderJson(new ApiReturn().loginInvalid());
            return;
        }

        BigInteger userId = user.getId();
        String cooldownKey = COOLDOWN_KEY_PREFIX + userId;
        String dailyKey = DAILY_COUNT_KEY_PREFIX + userId;

        Long cooldownCount = Redis.use().incr(cooldownKey);
        if (cooldownCount == 1) {
            Redis.use().expire(cooldownKey, COOLDOWN_SECONDS);
        }
        if (cooldownCount > 1) {
            c.renderJson(new ApiReturn().addMsg("操作过于频繁，请" + COOLDOWN_SECONDS + "秒后再试").fail());
            return;
        }

        Long dailyCount = Redis.use().incr(dailyKey);
        if (dailyCount == 1) {
            Redis.use().expireAt(dailyKey, getEndOfDayTimestamp());
        }
        if (dailyCount > MAX_DAILY_REQUESTS) {
            c.renderJson(new ApiReturn().addMsg("今日识别次数已达上限（" + MAX_DAILY_REQUESTS + "次）").fail());
            return;
        }

        inv.invoke();
    }

    private long getEndOfDayTimestamp() {
        java.util.Calendar calendar = java.util.Calendar.getInstance();
        calendar.set(java.util.Calendar.HOUR_OF_DAY, 23);
        calendar.set(java.util.Calendar.MINUTE, 59);
        calendar.set(java.util.Calendar.SECOND, 59);
        calendar.set(java.util.Calendar.MILLISECOND, 999);
        return calendar.getTimeInMillis() / 1000;
    }
}
