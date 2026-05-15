package com.shopoperate.inventory;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class InventoryService {
    public static final InventoryService me = new InventoryService();

    // ---- Materials ----
    public Page<Record> materialPage(int pn, int ps, String keyword, String category, Integer type, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM materials m LEFT JOIN inventory i ON m.id=i.material_id AND i.shop_id=m.shop_id WHERE m.is_deleted=0");
        if (shopId != null) sb.append(" AND m.shop_id=").append(shopId);
        if (keyword != null) sb.append(" AND m.name LIKE '%").append(keyword.replace("'","''")).append("%'");
        if (category != null) sb.append(" AND m.category='").append(category.replace("'","''")).append("'");
        if (type != null) sb.append(" AND m.type=").append(type);
        sb.append(" ORDER BY m.created_at DESC");
        return Db.paginate(pn, ps, "SELECT m.*, COALESCE(i.quantity, 0) AS quantity", sb.toString());
    }

    public boolean addMaterial(BigInteger shopId, String name, String sku, String category, String unit, Integer type, BigDecimal minStock, String remark) {
        return Db.save("materials", new Record().set("shop_id",shopId).set("name",name).set("sku",sku)
            .set("category",category).set("unit",unit!=null?unit:"个").set("type",type!=null?type:1)
            .set("min_stock",minStock).set("remark",remark).set("is_deleted",0)
            .set("created_at",new Date()).set("updated_at",new Date()));
    }

    public boolean updateMaterial(BigInteger id, BigInteger shopId, String name, String sku, String category, String unit, Integer type, BigDecimal minStock, String remark) {
        Record m = Db.findById("materials", id); if (m == null) return false;
        if (shopId != null && !shopId.equals(m.getBigInteger("shop_id"))) return false;
        if (name != null) m.set("name",name); if (sku != null) m.set("sku",sku);
        if (category != null) m.set("category",category); if (unit != null) m.set("unit",unit);
        if (type != null) m.set("type",type); if (minStock != null) m.set("min_stock",minStock);
        if (remark != null) m.set("remark",remark); m.set("updated_at",new Date());
        return Db.update("materials", m);
    }

    public boolean deleteMaterial(BigInteger id, BigInteger shopId) {
        Record m = Db.findById("materials", id); if (m == null) return false;
        if (shopId != null && !shopId.equals(m.getBigInteger("shop_id"))) return false;
        m.set("is_deleted",1); return Db.update("materials", m);
    }

    // ---- Inventory ----
    public Page<Record> inventoryPage(int pn, int ps, String keyword, String category, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM materials m LEFT JOIN inventory i ON i.material_id=m.id AND i.shop_id=m.shop_id WHERE m.is_deleted=0");
        if (shopId != null) sb.append(" AND m.shop_id=").append(shopId);
        if (keyword != null) sb.append(" AND (m.name LIKE '%").append(keyword.replace("'","''")).append("%' OR m.sku LIKE '%").append(keyword.replace("'","''")).append("%')");
        if (category != null) sb.append(" AND m.category='").append(category.replace("'","''")).append("'");
        sb.append(" ORDER BY m.name");
        return Db.paginate(pn, ps, "SELECT COALESCE(i.quantity,0) AS quantity, i.id, i.shop_id, i.material_id, i.updated_at, m.name AS material_name, m.sku, m.unit, m.category, m.min_stock, m.type AS material_type", sb.toString());
    }

    public boolean inbound(BigInteger shopId, BigInteger materialId, BigDecimal quantity, String remark, BigInteger operatorId) {
        return Db.tx(() -> {
            Record inv = Db.findFirst("SELECT * FROM inventory WHERE shop_id=? AND material_id=? FOR UPDATE", shopId, materialId);
            BigDecimal oldQty = inv != null ? (BigDecimal) inv.get("quantity") : BigDecimal.ZERO;
            if (inv == null) {
                inv = new Record().set("shop_id",shopId).set("material_id",materialId).set("quantity",quantity).set("updated_at",new Date());
                Db.save("inventory", inv);
            } else {
                inv.set("quantity", oldQty.add(quantity)).set("updated_at",new Date());
                Db.update("inventory", inv);
            }
            Db.save("inventory_transactions", new Record().set("shop_id",shopId).set("material_id",materialId)
                .set("transaction_type",1).set("quantity",quantity).set("balance_after",oldQty.add(quantity))
                .set("operator_staff_id",operatorId).set("remark",remark).set("created_at",new Date()));
            return true;
        });
    }

    public boolean outbound(BigInteger shopId, BigInteger materialId, BigDecimal quantity, String remark, BigInteger operatorId) {
        return Db.tx(() -> {
            Record inv = Db.findFirst("SELECT * FROM inventory WHERE shop_id=? AND material_id=? FOR UPDATE", shopId, materialId);
            if (inv == null) return false;
            BigDecimal oldQty = (BigDecimal) inv.get("quantity");
            if (oldQty.compareTo(quantity) < 0) return false;
            BigDecimal newQty = oldQty.subtract(quantity);
            inv.set("quantity", newQty).set("updated_at",new Date());
            Db.update("inventory", inv);
            Db.save("inventory_transactions", new Record().set("shop_id",shopId).set("material_id",materialId)
                .set("transaction_type",2).set("quantity",quantity).set("balance_after",newQty)
                .set("operator_staff_id",operatorId).set("remark",remark).set("created_at",new Date()));
            // 出库后检查是否低于库存预警线，实时发送站内信
            Record mat = Db.findById("materials", materialId);
            if (mat != null) {
                BigDecimal minStock = mat.getBigDecimal("min_stock");
                if (minStock != null && newQty.compareTo(minStock) <= 0) {
                    String title = "库存预警";
                    String content = "物料【" + mat.getStr("name") + "】（" + mat.getStr("sku") +
                        "）库存不足，当前库存 " + newQty +
                        "，最低预警线 " + minStock + "。请及时采购。";
                    List<Record> staffList = Db.find(
                        "SELECT DISTINCT s.id FROM staff s " +
                        "INNER JOIN staff_shops ss ON s.id = ss.staff_id " +
                        "INNER JOIN staff_roles sr ON s.id = sr.staff_id " +
                        "WHERE ss.shop_id = ? AND sr.role_id IN (3,5) AND s.status = 1 AND s.is_deleted = 0", shopId);
                    // 补充店铺老板（通过 shops.owner_staff_id 关联，不在 staff_shops 中）
                    Record owner = Db.findFirst(
                        "SELECT s.id FROM staff s INNER JOIN staff_roles sr ON s.id=sr.staff_id " +
                        "INNER JOIN shops sh ON sh.owner_staff_id=s.id " +
                        "WHERE sh.id=? AND sr.role_id IN (3,5) AND s.status=1 AND s.is_deleted=0", shopId);
                    if (owner != null) {
                        boolean found = false;
                        for (Record r : staffList) { if (r.getBigInteger("id").equals(owner.getBigInteger("id"))) { found = true; break; } }
                        if (!found) staffList.add(owner);
                    }
                    for (Record staff : staffList) {
                        Db.save("notification_logs", new Record()
                            .set("shop_id", shopId).set("recipient_type", 2)
                            .set("recipient_id", staff.getBigInteger("id"))
                            .set("channel", 3).set("title", title).set("content", content)
                            .set("status", 1).set("created_at", new Date()));
                    }
                }
            }
            return true;
        });
    }

    public Page<Record> transactions(int pn, int ps, BigInteger materialId, Integer type, String startDate, String endDate, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM inventory_transactions it LEFT JOIN materials m ON it.material_id=m.id WHERE 1=1");
        if (shopId != null) sb.append(" AND it.shop_id=").append(shopId);
        if (materialId != null) sb.append(" AND it.material_id=").append(materialId);
        if (type != null) sb.append(" AND it.transaction_type=").append(type);
        if (startDate != null) sb.append(" AND it.created_at>='").append(startDate).append("'");
        if (endDate != null) sb.append(" AND it.created_at<='").append(endDate).append(" 23:59:59'");
        sb.append(" ORDER BY it.created_at DESC");
        return Db.paginate(pn, ps, "SELECT it.*, m.name AS material_name, m.unit", sb.toString());
    }

    public List<Record> warnings(BigInteger shopId) {
        return Db.find("SELECT i.*, m.name AS material_name, m.sku, m.unit, m.min_stock FROM inventory i " +
            "INNER JOIN materials m ON i.material_id=m.id WHERE i.shop_id=? AND i.quantity <= m.min_stock AND m.is_deleted=0", shopId);
    }
}
