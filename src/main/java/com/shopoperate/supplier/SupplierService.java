package com.shopoperate.supplier;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class SupplierService {
    public static final SupplierService me = new SupplierService();

    public Page<Record> supplierPage(int pn, int ps, String keyword, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM suppliers WHERE is_deleted=0");
        if (shopId != null) sb.append(" AND shop_id=").append(shopId);
        if (keyword != null) sb.append(" AND name LIKE '%").append(keyword.replace("'","''")).append("%'");
        sb.append(" ORDER BY created_at DESC");
        return Db.paginate(pn, ps, "SELECT *", sb.toString());
    }

    public boolean addSupplier(BigInteger shopId, String name, String contact, String phone, String address, String remark) {
        return Db.save("suppliers", new Record().set("shop_id",shopId).set("name",name)
            .set("contact_person",contact).set("phone",phone).set("address",address)
            .set("remark",remark).set("is_deleted",0).set("created_at",new Date()));
    }

    public boolean updateSupplier(BigInteger id, BigInteger shopId, String name, String contact, String phone, String address, String remark) {
        Record r = Db.findById("suppliers", id); if (r == null) return false;
        if (shopId != null && !shopId.equals(r.getBigInteger("shop_id"))) return false;
        if (name != null) r.set("name",name); if (contact != null) r.set("contact_person",contact);
        if (phone != null) r.set("phone",phone); if (address != null) r.set("address",address);
        if (remark != null) r.set("remark",remark); return Db.update("suppliers", r);
    }

    public boolean deleteSupplier(BigInteger id, BigInteger shopId) {
        Record r = Db.findById("suppliers", id); if (r == null) return false;
        if (shopId != null && !shopId.equals(r.getBigInteger("shop_id"))) return false;
        r.set("is_deleted",1); return Db.update("suppliers", r);
    }

    // ---- Purchase Orders ----
    public Page<Record> orderPage(int pn, int ps, BigInteger supplierId, String status, String type,
                                   String startDate, String endDate, BigDecimal amountMin, BigDecimal amountMax, BigInteger shopId, String keyword) {
        StringBuilder sb = new StringBuilder(" FROM purchase_orders po"
            + " LEFT JOIN suppliers s ON po.supplier_id=s.id"
            + " LEFT JOIN purchase_order_items poi ON poi.purchase_order_id=po.id"
            + " LEFT JOIN materials m ON poi.material_id=m.id"
            + " WHERE 1=1");
        if (shopId != null) sb.append(" AND po.shop_id=").append(shopId);
        if (supplierId != null) sb.append(" AND po.supplier_id=").append(supplierId);
        if (status != null) sb.append(" AND po.status=").append(status);
        if (type != null) sb.append(" AND po.type=").append(type);
        if (startDate != null) sb.append(" AND po.order_date>='").append(startDate).append("'");
        if (endDate != null) sb.append(" AND po.order_date<='").append(endDate).append("'");
        if (amountMin != null) sb.append(" AND po.total_amount>=").append(amountMin);
        if (amountMax != null) sb.append(" AND po.total_amount<=").append(amountMax);
        if (keyword != null && !keyword.isEmpty()) sb.append(" AND (po.order_number LIKE '%").append(keyword.replace("'","''")).append("%' OR s.name LIKE '%").append(keyword.replace("'","''")).append("%')");
        sb.append(" GROUP BY po.id ORDER BY po.created_at DESC");
        return Db.paginate(pn, ps, "SELECT po.*, s.name AS supplier_name,"
            + " COALESCE(GROUP_CONCAT(DISTINCT m.name ORDER BY poi.id SEPARATOR '、'), '') AS material_names",
            sb.toString());
    }

    public boolean addOrder(BigInteger shopId, BigInteger supplierId, String orderDate, Integer type, String remark, List<Record> items, BigInteger operatorId) {
        return Db.tx(() -> {
            BigDecimal total = BigDecimal.ZERO;
            if (items != null) for (Record item : items) {
                // 获取数量和单价
                Object quantityObj = item.get("quantity");
                Object unitPriceObj = item.get("unitPrice");
                
                if (quantityObj != null && unitPriceObj != null) {
                    BigDecimal quantity = new BigDecimal(quantityObj.toString());
                    BigDecimal unitPrice = new BigDecimal(unitPriceObj.toString());
                    total = total.add(unitPrice.multiply(quantity));
                }
            }
            Record po = new Record().set("shop_id",shopId).set("supplier_id",supplierId)
                .set("order_number","PO"+System.currentTimeMillis()+"-"+(System.nanoTime()%10000)).set("order_date",java.sql.Date.valueOf(orderDate))
                .set("type",type!=null?type:1).set("total_amount",total).set("paid_amount",BigDecimal.ZERO)
                .set("status",1).set("operator_staff_id",operatorId).set("remark",remark)
                .set("created_at",new Date()).set("updated_at",new Date());
            Db.save("purchase_orders", po);
            BigInteger poId = po.getBigInteger("id");
            if (items != null) for (Record item : items) {
                // 获取物料ID、数量和单价
                Object materialIdObj = item.get("materialId");
                Object quantityObj = item.get("quantity");
                Object unitPriceObj = item.get("unitPrice");
                
                if (materialIdObj != null && quantityObj != null && unitPriceObj != null) {
                    BigInteger materialId = new BigInteger(materialIdObj.toString());
                    BigDecimal quantity = new BigDecimal(quantityObj.toString());
                    BigDecimal unitPrice = new BigDecimal(unitPriceObj.toString());
                    
                    Db.save("purchase_order_items", new Record().set("purchase_order_id",poId)
                        .set("material_id",materialId)
                        .set("quantity",quantity)
                        .set("unit_price",unitPrice).set("created_at",new Date()));
                }
            }
            return true;
        });
    }

    public boolean updateOrderStatus(BigInteger id, int status, BigInteger shopId) {
        return Db.tx(() -> {
            Record po = Db.findById("purchase_orders", id); if (po == null) return false;
            if (!shopId.equals(po.getBigInteger("shop_id"))) return false;
            po.set("status", status).set("updated_at",new Date());
            Db.update("purchase_orders", po);
            if (status == 2) { // 完成时自动入库
                List<Record> items = Db.find("SELECT * FROM purchase_order_items WHERE purchase_order_id=?", id);
                for (Record item : items) {
                    BigInteger mid = item.getBigInteger("material_id");
                    BigDecimal qty = (BigDecimal) item.get("quantity");
                    Record inv = Db.findFirst("SELECT * FROM inventory WHERE shop_id=? AND material_id=? FOR UPDATE", shopId, mid);
                    if (inv == null) {
                        inv = new Record().set("shop_id",shopId).set("material_id",mid).set("quantity",qty).set("updated_at",new Date());
                        Db.save("inventory", inv);
                    } else {
                        inv.set("quantity", ((BigDecimal)inv.get("quantity")).add(qty)).set("updated_at",new Date());
                        Db.update("inventory", inv);
                    }
                    Db.save("inventory_transactions", new Record().set("shop_id",shopId).set("material_id",mid)
                        .set("transaction_type",1).set("quantity",qty).set("balance_after",((BigDecimal)inv.get("quantity")))
                        .set("reference_type","purchase_order").set("reference_id",id).set("created_at",new Date()));
                }
            }
            return true;
        });
    }

    public boolean payOrder(BigInteger id, BigDecimal amount, String paymentMethod, String paidAt, String remark, BigInteger operatorId) {
        return Db.tx(() -> {
            Record po = Db.findById("purchase_orders", id); if (po == null) return false;
            BigDecimal totalAmount = (BigDecimal) po.get("total_amount");
            BigDecimal paidAmount = (BigDecimal) po.get("paid_amount");
            if (paidAmount.add(amount).compareTo(totalAmount) > 0) return false;
            po.set("paid_amount", paidAmount.add(amount)).set("updated_at",new Date());
            Db.update("purchase_orders", po);
            Record payment = new Record().set("purchase_order_id",id).set("amount",amount)
                .set("payment_method",paymentMethod).set("paid_at",paidAt!=null?java.sql.Date.valueOf(paidAt):new Date())
                .set("remark",remark).set("created_at",new Date());
            Db.save("purchase_payments", payment);

            // 同步写入 expenses 表（采购支出）
            BigInteger shopId = po.getBigInteger("shop_id");
            String supplierName = "";
            Record supplier = Db.findById("suppliers", po.getBigInteger("supplier_id"));
            if (supplier != null) supplierName = supplier.getStr("name");
            Long categoryId = Db.queryLong("SELECT id FROM expense_categories WHERE shop_id=? AND name='采购支出' LIMIT 1", shopId);
            Record expense = new Record().set("shop_id", shopId)
                .set("amount", amount).set("payment_method", paymentMethod)
                .set("expense_date", paidAt!=null?java.sql.Date.valueOf(paidAt):new java.sql.Date(System.currentTimeMillis()))
                .set("source_type", "purchase_order").set("source_id", id)
                .set("operator_staff_id", operatorId)
                .set("remark", "采购-" + supplierName + (remark != null ? "-" + remark : ""))
                .set("created_at", new Date());
            if (categoryId != null) expense.set("category_id", new BigInteger(String.valueOf(categoryId)));
            else expense.set("category_id", BigInteger.ZERO);
            Db.save("expenses", expense);
            payment.set("expense_id", expense.getBigInteger("id"));
            Db.update("purchase_payments", payment);
            return true;
        });
    }

    public List<Record> orderItems(BigInteger orderId) {
        return Db.find("SELECT poi.*, m.name AS material_name, m.unit FROM purchase_order_items poi LEFT JOIN materials m ON poi.material_id=m.id WHERE poi.purchase_order_id=?", orderId);
    }
}
