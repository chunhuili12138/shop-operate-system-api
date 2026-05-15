package com.shopoperate.packages;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

public class PackageService {
    public static final PackageService me = new PackageService();

    public Page<Record> page(int pn, int ps, String keyword, Integer type, Integer status, BigInteger shopId) {
        StringBuilder sb = new StringBuilder(" FROM packages WHERE is_deleted=0");
        if (shopId != null) sb.append(" AND shop_id=").append(shopId);
        if (keyword != null && !keyword.isEmpty()) {
            sb.append(" AND name LIKE '%").append(keyword.replace("'","''")).append("%'");
        }
        if (type != null) sb.append(" AND type=").append(type);
        if (status != null) sb.append(" AND is_active=").append(status);
        sb.append(" ORDER BY created_at DESC");
        return Db.paginate(pn, ps, "SELECT *", sb.toString());
    }

    public Record info(BigInteger id, BigInteger shopId) {
        Record pkg = Db.findFirst("SELECT * FROM packages WHERE id=? AND is_deleted=0", id);
        if (pkg == null) return null;
        if (shopId != null) {
            BigInteger pkgShopId = pkg.getBigInteger("shop_id");
            if (pkgShopId == null || !pkgShopId.equals(shopId)) return null;
        }
        pkg.set("bom", Db.find("SELECT mb.*, m.name AS material_name, m.unit FROM package_bom mb LEFT JOIN materials m ON mb.material_id=m.id WHERE mb.package_id=?", id));
        return pkg;
    }

    public boolean add(BigInteger shopId, String name, int type, Integer duration, BigDecimal price,
                       BigDecimal originalPrice, int maxPeople, String description, List<Record> bom) {
        // 检查同名套餐
        long dup = Db.queryLong("SELECT COUNT(*) FROM packages WHERE shop_id=? AND name=? AND is_deleted=0", shopId, name);
        if (dup > 0) return false;
        return Db.tx(() -> {
            Record p = new Record().set("shop_id",shopId).set("name",name).set("type",type)
                .set("duration_minutes",duration).set("price",price).set("original_price",originalPrice)
                .set("max_people_per_session",maxPeople)
                .set("description",description).set("is_active",1).set("is_deleted",0)
                .set("created_at",new Date()).set("updated_at",new Date());
            Db.save("packages", p);
            BigInteger pid = p.getBigInteger("id");
            if (bom != null) for (Record item : bom) {
                Object qtyObj = item.get("quantity");
                BigDecimal quantity = qtyObj == null ? BigDecimal.ZERO : 
                    (qtyObj instanceof BigDecimal ? (BigDecimal)qtyObj : new BigDecimal(qtyObj.toString()));
                Db.save("package_bom", new Record().set("package_id",pid).set("material_id",item.getBigInteger("materialId"))
                    .set("quantity",quantity).set("created_at",new Date()).set("is_deleted",0));
            }
            return true;
        });
    }

    public boolean update(BigInteger id, String name, Integer type, Integer duration, BigDecimal price,
                          BigDecimal originalPrice, Integer maxPeople, String description, List<Record> bom, BigInteger shopId) {
        return Db.tx(() -> {
            Record p = Db.findFirst("SELECT * FROM packages WHERE id=? AND is_deleted=0 FOR UPDATE", id);
            if (p == null) return false;
            if (shopId != null) {
                BigInteger pkgShopId = p.getBigInteger("shop_id");
                if (pkgShopId == null || !pkgShopId.equals(shopId)) return false;
            }
            if (name != null) p.set("name",name);
            if (type != null) p.set("type",type);
            if (duration != null) p.set("duration_minutes",duration);
            if (price != null) p.set("price",price);
            if (originalPrice != null) p.set("original_price",originalPrice);
            if (maxPeople != null) p.set("max_people_per_session",maxPeople);
            if (description != null) p.set("description",description);
            p.set("updated_at",new Date());
            Db.update("packages", p);
            if (bom != null) {
                Db.update("DELETE FROM package_bom WHERE package_id=?", id);
                for (Record item : bom) {
                    Object qtyObj = item.get("quantity");
                    BigDecimal quantity = qtyObj == null ? BigDecimal.ZERO : 
                        (qtyObj instanceof BigDecimal ? (BigDecimal)qtyObj : new BigDecimal(qtyObj.toString()));
                    Db.save("package_bom", new Record().set("package_id",id).set("material_id",item.getBigInteger("materialId"))
                        .set("quantity",quantity).set("created_at",new Date()).set("is_deleted",0));
                }
            }
            return true;
        });
    }

    public boolean toggleStatus(BigInteger id, int isActive, BigInteger shopId) {
        Record p = Db.findFirst("SELECT * FROM packages WHERE id=? AND is_deleted=0 FOR UPDATE", id);
        if (p == null) return false;
        if (shopId != null) {
            BigInteger pkgShopId = p.getBigInteger("shop_id");
            if (pkgShopId == null || !pkgShopId.equals(shopId)) return false;
        }
        p.set("is_active", isActive).set("updated_at", new Date());
        return Db.update("packages", p);
    }

    public boolean delete(BigInteger id, BigInteger shopId) {
        Record p = Db.findFirst("SELECT * FROM packages WHERE id=? AND is_deleted=0", id);
        if (p == null) return false;
        if (shopId != null) {
            BigInteger pkgShopId = p.getBigInteger("shop_id");
            if (pkgShopId == null || !pkgShopId.equals(shopId)) return false;
        }
        p.set("is_deleted", 1).set("deleted_time", new Date()).set("updated_at", new Date());
        return Db.update("packages", p);
    }

    public List<Record> bomList(BigInteger packageId, BigInteger shopId) {
        Record pkg = Db.findFirst("SELECT id, shop_id FROM packages WHERE id=? AND is_deleted=0", packageId);
        if (pkg == null) return null;
        if (shopId != null) {
            BigInteger pkgShopId = pkg.getBigInteger("shop_id");
            if (pkgShopId == null || !pkgShopId.equals(shopId)) return null;
        }
        return Db.find("SELECT mb.*, m.name AS material_name, m.unit FROM package_bom mb LEFT JOIN materials m ON mb.material_id=m.id WHERE mb.package_id=?", packageId);
    }
}
