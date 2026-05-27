package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.vo.User;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

class MpHelper {

    static BigInteger getShopId(Controller c) {
        String s = c.getPara("shopId");
        if (s != null && !s.isEmpty()) {
            try { return new BigInteger(s); } catch (NumberFormatException ignored) {}
        }
        User u = c.getSessionAttr("userinfo");
        if (u != null) return u.getLoginShopId();
        return null;
    }

    static BigInteger getCustomerId(Controller c) {
        User u = c.getSessionAttr("userinfo");
        if (u != null && u.getCustomerId() != null) return u.getCustomerId();
        return null;
    }

    static BigInteger parseBigInteger(String s) {
        if (s == null || s.isEmpty()) return null;
        try { return new BigInteger(s); } catch (NumberFormatException e) { return null; }
    }

    static Map<String, Object> packageToMap(Record p) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", p.getBigInteger("id"));
        m.put("name", p.getStr("name"));
        m.put("type", p.getStr("type"));
        m.put("price", p.getBigDecimal("price"));
        m.put("originalPrice", p.getBigDecimal("original_price"));
        m.put("durationMinutes", p.getInt("duration_minutes"));
        m.put("maxPeoplePerSession", p.getInt("max_people_per_session"));
        m.put("description", p.getStr("description"));
        m.put("image", p.getStr("image"));
        m.put("isActive", p.getInt("is_active"));
        return m;
    }

    static Map<String, Object> shopToMap(Record s) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", s.getBigInteger("id"));
        m.put("name", s.getStr("name"));
        m.put("address", s.getStr("address"));
        m.put("status", s.getInt("status"));
        m.put("signPhoto", s.getStr("sign_photo"));
        m.put("contactPhone", s.getStr("contact_phone"));
        m.put("maxCapacity", s.getInt("max_capacity"));
        m.put("description", s.getStr("description"));
        return m;
    }
}
