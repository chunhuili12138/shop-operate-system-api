package com.shopoperate.packages;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.*;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;

@Path(value = "/api/packages")
public class PackageController extends Controller {
    private static final Logger log = Logger.getLogger(PackageController.class);
    private final PackageService s = PackageService.me;

    @RequireLogin @MethodValidation("GET") public void page() {
        User u = getSessionAttr("userinfo");
        try {
            Page<Record> p = s.page(getParaToInt("page",1), getParaToInt("size",20),
                getPara("keyword"), getParaToInt("type"), getParaToInt("status"), u.getLoginShopId());
            java.util.Map<String,Object> _m=new java.util.HashMap<>(); _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow()); renderJson(new ApiReturn().addData("data",_m).success());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @MethodValidation("GET") public void info() {
        User u = getSessionAttr("userinfo");
        try { Record r = s.info(getBigInteger("packagesId"), u.getLoginShopId());
            if (r!=null) renderJson(new ApiReturn().addData("data",r).success());
            else renderJson(new ApiReturn().addMsg("套餐不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    @RequireLogin @RequirePermission("btn:package:add") @MethodValidation("POST") public void add() {
        User u = getSessionAttr("userinfo");
        String name = getPara("name");
        if (name == null || name.trim().isEmpty()) {
            renderJson(new ApiReturn().addMsg("套餐名称不能为空").fail());
            return;
        }
        Integer duration = getParaToInt("durationMinutes");
        if (duration == null || duration <= 0) {
            renderJson(new ApiReturn().addMsg("时长必须大于0").fail());
            return;
        }
        try {
            boolean ok = s.add(u.getLoginShopId(), name.trim(), getParaToInt("type",1),
                duration, new BigDecimal(getPara("price","0")),
                parseDecimal("originalPrice"),
                getParaToInt("maxPeoplePerSession",1), getPara("description"), parseBom());
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("套餐名已存在或新增失败").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:package:edit") @MethodValidation("PUT") public void update() {
        User u = getSessionAttr("userinfo");
        String name = getPara("name");
        Integer duration = getParaToInt("durationMinutes");
        if (duration != null && duration <= 0) {
            renderJson(new ApiReturn().addMsg("时长必须大于0").fail());
            return;
        }
        try {
            boolean ok = s.update(getBigInteger("packageId"), name != null ? name.trim() : null, getParaToInt("type"),
                duration, getPara("price")!=null?new BigDecimal(getPara("price")):null,
                parseDecimal("originalPrice"),
                getParaToInt("maxPeoplePerSession"), getPara("description"), parseBom(), u.getLoginShopId());
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("套餐不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:package:status") @MethodValidation("PUT") public void status() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.toggleStatus(getBigInteger("packageId"), getParaToInt("isActive",0), u.getLoginShopId());
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("套餐不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @RequirePermission("btn:package:delete") @MethodValidation("DELETE") public void delete() {
        User u = getSessionAttr("userinfo");
        try {
            boolean ok = s.delete(getBigInteger("packageId"), u.getLoginShopId());
            renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("套餐不存在").fail());
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    @RequireLogin @MethodValidation("GET") public void bom() {
        User u = getSessionAttr("userinfo");
        try { 
            List<Record> list = s.bomList(getBigInteger("packagesId"), u.getLoginShopId());
            if (list != null) {
                renderJson(new ApiReturn().addData("data", list).success());
            } else {
                renderJson(new ApiReturn().addMsg("套餐不存在").fail());
            }
        } catch (Exception e) { 
            log.error(e); 
            renderJson(new ApiReturn().addMsg("查询失败").fail()); 
        }
    }

    private List<Record> parseBom() {
        String json = getPara("bom");
        if (json == null || json.isEmpty()) return null;
        com.alibaba.fastjson.JSONArray jsonArray = com.alibaba.fastjson.JSONArray.parseArray(json);
        List<Record> result = new java.util.ArrayList<>();
        for (int i = 0; i < jsonArray.size(); i++) {
            com.alibaba.fastjson.JSONObject obj = jsonArray.getJSONObject(i);
            Record record = new Record();
            String mid = obj.getString("materialId");
            if (mid != null && !mid.isEmpty()) record.set("materialId", new BigInteger(mid));
            record.set("quantity", obj.getBigDecimal("quantity"));
            result.add(record);
        }
        return result;
    }

    private BigInteger getBigInteger(String n) { String v = getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
    private BigDecimal parseDecimal(String n) { String v = getPara(n); return v==null||v.isEmpty()?null:new BigDecimal(v); }
}
