package com.shopoperate.supplier;

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
public class SupplierController extends Controller {
    private static final Logger log = Logger.getLogger(SupplierController.class);
    private final SupplierService s = SupplierService.me;

    @RequireLogin @MethodValidation("GET") public void suppliers() {
        try { renderPage(s.supplierPage(getParaToInt("page",1),getParaToInt("size",20),getPara("keyword"),shopId())); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("POST") public void suppliersAdd() {
        renderBool(s.addSupplier(shopId(), getPara("name"), getPara("contactPerson"),
            getPara("phone"), getPara("address"), getPara("remark")));
    }
    @RequireLogin @MethodValidation("PUT") public void suppliersUpdate() {
        renderBool(s.updateSupplier(getBigInteger("supplierId"), shopId(), getPara("name"),
            getPara("contactPerson"), getPara("phone"), getPara("address"), getPara("remark")));
    }
    @RequireLogin @MethodValidation("DELETE") public void suppliersDelete() {
        renderBool(s.deleteSupplier(getBigInteger("supplierId"), shopId()));
    }

    @RequireLogin @MethodValidation("GET") public void purchaseOrders() {
        try { renderPage(s.orderPage(getParaToInt("page",1),getParaToInt("size",20),
            getBigInteger("supplierId"), getPara("status"), getPara("type"),
            getPara("startDate"), getPara("endDate"),
            parseDecimal("amountMin"), parseDecimal("amountMax"), shopId(), getPara("keyword"))); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @RequirePermission("btn:purchaseOrder:add") @MethodValidation("POST") public void purchaseOrdersAdd() {
        renderBool(s.addOrder(shopId(), getBigInteger("supplierId"), getPara("orderDate"),
            getParaToInt("type"), getPara("remark"), parseItems(), userId()));
    }
    @RequireLogin @MethodValidation("GET") public void purchaseOrdersItems() {
        try { renderJson(new ApiReturn().addData("data",s.orderItems(getBigInteger("orderId"))).success()); }
        catch (Exception e) { log.error(e); renderJson(new ApiReturn().addMsg("查询失败").fail()); }
    }
    @RequireLogin @MethodValidation("PUT") public void purchaseOrdersStatus() {
        renderBool(s.updateOrderStatus(getBigInteger("orderId"), getParaToInt("status",1), shopId()));
    }
    @RequireLogin @MethodValidation("POST") public void purchaseOrdersPay() {
        renderBool(s.payOrder(getBigInteger("orderId"), new BigDecimal(getPara("amount","0")),
            getPara("paymentMethod"), getPara("paidAt"), getPara("remark"), userId()));
    }

    private List<Record> parseItems() {
        String json = getPara("items"); if (json == null) return null;
        com.alibaba.fastjson.JSONArray jsonArray = com.alibaba.fastjson.JSONArray.parseArray(json);
        List<Record> records = new java.util.ArrayList<>();
        for (int i = 0; i < jsonArray.size(); i++) {
            com.alibaba.fastjson.JSONObject jsonObject = jsonArray.getJSONObject(i);
            Record record = new Record();
            // 将JSONObject中的键值对转换为Record
            for (String key : jsonObject.keySet()) {
                Object value = jsonObject.get(key);
                record.set(key, value);
            }
            records.add(record);
        }
        return records;
    }
    private BigInteger shopId() { User u=getSessionAttr("userinfo"); return u!=null?u.getLoginShopId():null; }
    private BigInteger userId() { User u=getSessionAttr("userinfo"); return u!=null?u.getId():null; }
    private BigInteger getBigInteger(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigInteger(v); }
    private BigDecimal parseDecimal(String n) { String v=getPara(n); return v==null||v.isEmpty()?null:new BigDecimal(v); }
    private void renderPage(Page<Record> p) { java.util.Map<String,Object> _m=new java.util.HashMap<>(); _m.put("list",p.getList()); _m.put("total",(int)p.getTotalRow()); renderJson(new ApiReturn().addData("data",_m).success()); }
    private void renderBool(boolean ok) { renderJson(ok ? new ApiReturn().success() : new ApiReturn().addMsg("操作失败").fail()); }
}
