package com.shopoperate.staff;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.utils.ApiReturn;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Path(value = "/api/permissions")
public class PermissionsController extends Controller {

    private static final Logger logger = Logger.getLogger(PermissionsController.class);

    /**
     * 权限列表（树形结构）
     * GET /api/permissions/list
     */
    @RequireLogin
    @MethodValidation("GET")
    public void list() {
        try {
            List<Record> allPerms = Db.find(
                "SELECT * FROM permissions WHERE is_active = 1 AND is_deleted = 0 ORDER BY parent_id, sort"
            );

            // parent_id -> children
            Map<Integer, List<Record>> parentMap = new HashMap<>();
            for (Record r : allPerms) {
                int parentId = r.getInt("parent_id");
                parentMap.computeIfAbsent(parentId, k -> new ArrayList<>()).add(r);
            }

            // 递归构建
            List<Map<String, Object>> result = new ArrayList<>();
            List<Record> roots = parentMap.getOrDefault(0, new ArrayList<>());
            for (Record r : roots) {
                result.add(buildNode(r, parentMap));
            }

            renderJson(new ApiReturn().addData("data", result).success());
        } catch (Exception e) {
            logger.error("查询权限列表异常", e);
            renderJson(new ApiReturn().addMsg("查询失败").fail());
        }
    }

    private Map<String, Object> buildNode(Record record, Map<Integer, List<Record>> parentMap) {
        Map<String, Object> node = new HashMap<>();
        node.put("id", record.getInt("id"));
        node.put("name", record.getStr("name"));
        node.put("menuCode", record.getStr("menu_code"));
        node.put("type", record.getInt("type"));
        node.put("sort", record.getInt("sort"));
        node.put("parentId", record.getInt("parent_id"));

        int id = record.getInt("id");
        List<Record> children = parentMap.getOrDefault(id, new ArrayList<>());
        if (!children.isEmpty()) {
            List<Map<String, Object>> childNodes = new ArrayList<>();
            for (Record child : children) {
                childNodes.add(buildNode(child, parentMap));
            }
            node.put("children", childNodes);
        }

        return node;
    }
}
