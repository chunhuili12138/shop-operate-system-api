package com.shopoperate.system;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.RequirePermission;
import com.shopoperate.common.vo.User;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.util.List;

/**
 * 字典管理
 * 路径前缀：/api/system/dict
 */
@Path(value = "/api/system/dict")
public class SysDictController extends Controller {

    private static final Logger logger = Logger.getLogger(SysDictController.class);

    /**
     * 字典分页列表
     * GET /system/dict/page
     */
    @RequireLogin
    @MethodValidation("GET")
    public void page() {
        Integer pageNum = getParaToInt("page", 1);
        Integer pageSize = getParaToInt("size", 20);
        String dictCode = getPara("dictCode");
        String keyword = getPara("keyword");

        StringBuilder select = new StringBuilder("SELECT *");
        StringBuilder from = new StringBuilder(" FROM sys_dicts WHERE 1=1");

        if (dictCode != null && !dictCode.isEmpty()) {
            from.append(" AND dict_code = '").append(dictCode.replace("'", "''")).append("'");
        }
        if (keyword != null && !keyword.isEmpty()) {
            from.append(" AND (dict_value LIKE '%").append(keyword.replace("'", "''"))
                .append("%' OR dict_label LIKE '%").append(keyword.replace("'", "''"))
                .append("%')");
        }

        from.append(" ORDER BY dict_code, sort");

        try {
            Page<Record> pd = Db.paginate(pageNum, pageSize, select.toString(), from.toString());
            java.util.Map<String,Object> _m=new java.util.HashMap<>();
            _m.put("list",pd.getList()); _m.put("total",(int)pd.getTotalRow());
            _m.put("pageNum",pageNum); _m.put("pageSize",pageSize);
            renderJson(new ApiReturn().addData("data",_m).success());
        } catch (Exception e) {
            logger.error("查询字典分页异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    /**
     * 按 dictCode 查询字典数据
     * 前端调用: GET /system/dict/data/{dictCode}
     *           也可: GET /system/dict/data?dictCode=xxx
     */
    @RequireLogin
    @MethodValidation("GET")
    public void data() {
        // JFinal 路径参数: getPara(0) 取 /data/ 后面的第一个参数
        String dictCode = getPara(0);
        if (dictCode == null || dictCode.isEmpty()) {
            dictCode = getPara("dictCode");
        }
        Integer shopId = getParaToInt("shopId", 0);

        if (dictCode == null || dictCode.isEmpty()) {
            renderJson(new ApiReturn().addMsg("dictCode不能为空").fail());
            return;
        }

        try {
            List<Record> list = Db.find(
                "SELECT * FROM sys_dicts WHERE dict_code = ? AND (shop_id = 0 OR shop_id = ?) AND is_active = 1 ORDER BY sort",
                dictCode, shopId
            );
            renderJson(new ApiReturn()
                .addData("data", list)
                .success());
        } catch (Exception e) {
            logger.error("查询字典数据异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    /**
     * 新增字典项
     * POST /system/dict
     */
    @RequireLogin
    @RequirePermission("btn:dict:add")
    @MethodValidation("POST")
    @ParameterValidation({ "dictCode", "dictKey", "dictValue" })
    public void add() {
        User u = getSessionAttr("userinfo");
        Record record = new Record();
        record.set("dict_code", getPara("dictCode"));
        record.set("dict_key", getParaToInt("dictKey"));
        record.set("dict_value", getPara("dictValue"));
        record.set("dict_label", getPara("dictLabel"));
        record.set("sort", getParaToInt("sort", 0));
        // 非超管强制使用当前店铺ID，忽略前端传入值
        int shopId = (u.getIsSuperAdmin() == 1) ? getParaToInt("shopId", 0) : u.getLoginShopId().intValue();
        record.set("shop_id", shopId);
        record.set("is_active", 1);

        // 校验同 dict_code + shop_id 下 dict_value/dict_label 不重复
        String dictCode = getPara("dictCode");
        String dictValue = getPara("dictValue");
        String dictLabel = getPara("dictLabel");
        if (Db.queryLong("SELECT COUNT(*) FROM sys_dicts WHERE dict_code=? AND dict_value=? AND shop_id=?",
                dictCode, dictValue, shopId) > 0) {
            renderJson(new ApiReturn().addMsg("该分类名称已存在").fail());
            return;
        }
        if (dictLabel != null && !dictLabel.isEmpty() && Db.queryLong(
                "SELECT COUNT(*) FROM sys_dicts WHERE dict_code=? AND dict_label=? AND shop_id=?",
                dictCode, dictLabel, shopId) > 0) {
            renderJson(new ApiReturn().addMsg("该分类编码已存在").fail());
            return;
        }

        try {
            Db.save("sys_dicts", record);
            renderJson(new ApiReturn().success());
        } catch (Exception e) {
            logger.error("新增字典项异常", e);
            renderJson(new ApiReturn().addMsg("新增失败").fail());
        }
    }

    /**
     * 更新字典项
     * PUT /system/dict
     */
    @RequireLogin
    @RequirePermission("btn:dict:edit")
    @MethodValidation("PUT")
    @ParameterValidation({ "id" })
    public void update() {
        User u = getSessionAttr("userinfo");
        Integer id = getParaToInt("id");

        Record record = Db.findById("sys_dicts", id);
        if (record == null) {
            renderJson(new ApiReturn().addMsg("字典项不存在").fail());
            return;
        }

        // 非超管只能编辑本店的字典项
        if (u.getIsSuperAdmin() != 1) {
            int dictShopId = record.getInt("shop_id");
            int loginShopId = u.getLoginShopId().intValue();
            if (dictShopId != 0 && dictShopId != loginShopId) {
                renderJson(new ApiReturn().addMsg("无权操作其他店铺的字典项").fail());
                return;
            }
            if (dictShopId == 0) {
                renderJson(new ApiReturn().addMsg("全局字典项不可修改").fail());
                return;
            }
        }

        String dictValue = getPara("dictValue");
        String dictLabel = getPara("dictLabel");
        Integer sort = getParaToInt("sort");
        Integer isActive = getParaToInt("isActive");

        // 校验同 dict_code + shop_id 下 dict_value/dict_label 不重复（排除自身）
        String dictCode = record.getStr("dict_code");
        int shopId = record.getInt("shop_id");
        if (dictValue != null && Db.queryLong(
                "SELECT COUNT(*) FROM sys_dicts WHERE dict_code=? AND dict_value=? AND shop_id=? AND id<>?",
                dictCode, dictValue, shopId, id) > 0) {
            renderJson(new ApiReturn().addMsg("该分类名称已存在").fail());
            return;
        }
        if (dictLabel != null && !dictLabel.isEmpty() && Db.queryLong(
                "SELECT COUNT(*) FROM sys_dicts WHERE dict_code=? AND dict_label=? AND shop_id=? AND id<>?",
                dictCode, dictLabel, shopId, id) > 0) {
            renderJson(new ApiReturn().addMsg("该分类编码已存在").fail());
            return;
        }

        if (dictValue != null) record.set("dict_value", dictValue);
        if (dictLabel != null) record.set("dict_label", dictLabel);
        if (sort != null) record.set("sort", sort);
        if (isActive != null) record.set("is_active", isActive);

        try {
            Db.update("sys_dicts", record);
            renderJson(new ApiReturn().success());
        } catch (Exception e) {
            logger.error("更新字典项异常", e);
            renderJson(new ApiReturn().addMsg("更新失败").fail());
        }
    }

    /**
     * 删除字典项
     * DELETE /system/dict/{id}
     */
    @RequireLogin
    @RequirePermission("btn:dict:delete")
    @MethodValidation("DELETE")
    public void delete() {
        User u = getSessionAttr("userinfo");
        String idStr = getPara(0);
        if (idStr == null) {
            renderJson(new ApiReturn().addMsg("ID不能为空").fail());
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Record record = Db.findById("sys_dicts", id);
            if (record == null) {
                renderJson(new ApiReturn().addMsg("字典项不存在").fail());
                return;
            }

            // 非超管只能删除本店的字典项
            if (u.getIsSuperAdmin() != 1) {
                int dictShopId = record.getInt("shop_id");
                int loginShopId = u.getLoginShopId().intValue();
                if (dictShopId != 0 && dictShopId != loginShopId) {
                    renderJson(new ApiReturn().addMsg("无权操作其他店铺的字典项").fail());
                    return;
                }
                if (dictShopId == 0) {
                    renderJson(new ApiReturn().addMsg("全局字典项不可删除").fail());
                    return;
                }
            }

            record.set("is_active", 0).set("updated_at", new java.util.Date());
            boolean success = Db.update("sys_dicts", record);
            if (success) {
                renderJson(new ApiReturn().success());
            } else {
                renderJson(new ApiReturn().addMsg("字典项不存在").fail());
            }
        } catch (NumberFormatException e) {
            renderJson(new ApiReturn().addMsg("无效的ID").fail());
        } catch (Exception e) {
            logger.error("删除字典项异常", e);
            renderJson(new ApiReturn().addMsg("删除失败").fail());
        }
    }
}
