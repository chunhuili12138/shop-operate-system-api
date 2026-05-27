package com.shopoperate.mp;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.math.BigInteger;
import java.util.*;

/**
 * 小程序套餐控制器
 * 路径前缀：/api/mp/packages
 */
@Path(value = "/api/mp/packages")
public class MpPackageController extends Controller {

    private static final Logger log = Logger.getLogger(MpPackageController.class);

    /**
     * 套餐分页列表（免登录，仅返回在售套餐）
     * GET /api/mp/packages/list?shopId=&type=&page=&size=
     */
    @MethodValidation("GET")
    public void list() {
        BigInteger shopId = MpHelper.getShopId(this);
        if (shopId == null) { renderJson(new ApiReturn().addMsg("shopId不能为空").fail()); return; }

        int page = getParaToInt("page", 1);
        int size = getParaToInt("size", 20);
        String type = getPara("type");

        try {
            StringBuilder where = new StringBuilder("WHERE p.shop_id = ? AND p.is_active = 1 AND p.is_deleted = 0");
            List<Object> params = new ArrayList<>();
            params.add(shopId);

            if (type != null) {
                where.append(" AND p.type = ?");
                params.add(type);
            }

            String select = "SELECT p.*";
            String from = "FROM packages p " + where + " ORDER BY p.created_at DESC";
            Page<Record> pg = Db.paginate(page, size, select, from, params.toArray());

            List<Map<String, Object>> list = new ArrayList<>();
            for (Record p : pg.getList()) {
                list.add(MpHelper.packageToMap(p));
            }

            renderJson(new ApiReturn().addData("data", new HashMap<String,Object>() {{
                put("list", list);
                put("total", (int)pg.getTotalRow());
                put("page", page);
                put("size", size);
            }}).success());
        } catch (Exception e) {
            log.error("套餐列表异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }

    /**
     * 套餐详情（免登录，含BOM物料清单）
     * GET /api/mp/packages/{id}
     */
    @MethodValidation("GET")
    public void detail() {
        BigInteger id = MpHelper.parseBigInteger(getPara(0));
        if (id == null) { renderJson(new ApiReturn().addMsg("套餐ID不能为空").fail()); return; }

        try {
            Record p = Db.findById("packages", id);
            if (p == null || p.getInt("is_deleted") == 1) {
                renderJson(new ApiReturn().addMsg("套餐不存在").fail()); return;
            }

            Map<String, Object> data = MpHelper.packageToMap(p);

            // BOM 物料清单
            List<Record> bom = Db.find(
                "SELECT pb.*, m.name AS material_name, m.sku, m.unit " +
                "FROM package_bom pb " +
                "LEFT JOIN materials m ON pb.material_id = m.id AND m.is_deleted = 0 " +
                "WHERE pb.package_id = ?", id);
            List<Map<String, Object>> bomList = new ArrayList<>();
            for (Record b : bom) {
                Map<String, Object> item = new HashMap<>();
                item.put("materialId", b.getBigInteger("material_id"));
                item.put("materialName", b.getStr("material_name"));
                item.put("sku", b.getStr("sku"));
                item.put("unit", b.getStr("unit"));
                item.put("quantity", b.getBigDecimal("quantity"));
                bomList.add(item);
            }
            data.put("bom", bomList);

            renderJson(new ApiReturn().addData("data", data).success());
        } catch (Exception e) {
            log.error("套餐详情异常", e);
            renderJson(new ApiReturn().addMsg("系统异常").serverErr());
        }
    }
}
