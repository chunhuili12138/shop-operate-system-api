package com.shopoperate.index;

import com.jfinal.kit.Kv;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

import java.util.List;

public class IndexService {

    public static final IndexService me = new IndexService();

    /**
     * 测试数据库链接是否成功
     */
    public List<Record> getUser(String username) {
        Kv condition = new Kv().set("username", username);
        return Db.template("getUser", condition).find();
    }

}
