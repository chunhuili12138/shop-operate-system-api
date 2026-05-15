package com.shopoperate.inventory;

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

@Path(value = "/api")
public class InventoryController extends Controller {
    private static final Logger log = Logger.getLogger(InventoryController.class);
    private final InventoryService s = InventoryService.me;

    // ---- Materials ----
    @RequireLogin @MethodValidation("GET") public void materials() {
        User u = getSessionAttr("userinfo");
        try { renderPage(s.materialPage(getParaToInt("page",1), getParaToInt("size",20),
            getPara("keyword"), getPara("category"), getParaToInt("type"), u.getLoginShopId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:material:add") @MethodValidation("POST") public void materialsAdd() {
        User u = getSessionAttr("userinfo");
        try { renderBool(s.addMaterial(u.getLoginShopId(), getPara("name"), getPara("sku"),
            getPara("category"), getPara("unit"), getParaToInt("type"),
            getPara("minStock")!=null?new BigDecimal(getPara("minStock")):null, getPara("remark"))); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:material:edit") @MethodValidation("PUT") public void materialsUpdate() {
        User u = getSessionAttr("userinfo");
        try { renderBool(s.updateMaterial(getBigInteger("materialId"), u.getLoginShopId(), getPara("name"), getPara("sku"),
            getPara("category"), getPara("unit"), getParaToInt("type"),
            getPara("minStock")!=null?new BigDecimal(getPara("minStock")):null, getPara("remark"))); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:material:delete") @MethodValidation("DELETE") public void materialsDelete() {
        User u = getSessionAttr("userinfo");
        try { renderBool(s.deleteMaterial(getBigInteger("materialId"), u.getLoginShopId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }

    // ---- Inventory ----
    @RequireLogin @MethodValidation("GET") public void inventory() {
        User u = getSessionAttr("userinfo");
        try {
            if ("page".equals(getPara(0)) || getPara(0)==null)
                renderPage(s.inventoryPage(getParaToInt("page",1),getParaToInt("size",20),getPara("keyword"),getPara("category"),u.getLoginShopId()));
            else if ("warnings".equals(getPara(0))) {
                List<Record> list = s.warnings(u.getLoginShopId());
                renderJson(new ApiReturn().addData("data",list).success());
            }
        } catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:inventory:inbound") @MethodValidation("POST") public void inventoryInbound() {
        User u = getSessionAttr("userinfo");
        try { renderBool(s.inbound(u.getLoginShopId(), getBigInteger("materialId"),
            new BigDecimal(getPara("quantity")), getPara("remark"), u.getId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @RequirePermission("btn:inventory:outbound") @MethodValidation("POST") public void inventoryOutbound() {
        User u = getSessionAttr("userinfo");
        try { 
            String remark = getPara("remark");
            if (remark == null || remark.trim().isEmpty()) {
                renderJson(new ApiReturn().addMsg("请填写出库原因/备注").fail());
                return;
            }
            boolean ok = s.outbound(u.getLoginShopId(), getBigInteger("materialId"),
                new BigDecimal(getPara("quantity")), remark, u.getId());
            if (ok) renderJson(new ApiReturn().success());
            else renderJson(new ApiReturn().addMsg("出库失败，库存不足或物料不存在").fail());
        }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("系统异常").serverErr()); }
    }
    @RequireLogin @MethodValidation("GET") public void inventoryTransactions() {
        User u = getSessionAttr("userinfo");
        try { renderPage(s.transactions(getParaToInt("page",1),getParaToInt("size",20),
            getBigInteger("materialId"), getParaToInt("type"), getPara("startDate"), getPara("endDate"), u.getLoginShopId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }

    private void renderPage(Page<Record> p) { java.util.Map<String,Object> _m=new java.util.HashMap<>(); _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow()); renderJson(new ApiReturn().addData("data",_m).success()); }
    private void renderBool(boolean ok) { renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("操作失败").fail()); }
    private BigInteger getBigInteger(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
}
