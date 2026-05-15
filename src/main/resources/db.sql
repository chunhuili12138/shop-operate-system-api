#sql("getUser")
SELECT * FROM staff_accounts
WHERE username = #para(username)
#end

-- ========================================
-- SQL 模板使用示例
-- ========================================
-- 使用方法：
-- Kv params = new Kv().set("paramName", value);
-- Db.template("templateName", params).find();
-- Db.template("templateName", params).findFirst();
-- Db.template("templateName", params).queryLong();
-- ========================================

-- 示例1：简单查询（无命名空间）
#sql("getUserById")
SELECT * FROM user 
WHERE id = #para(id) 
  AND deleted_time IS NULL
#end

-- 示例2：条件查询（使用 #if 语法）
#sql("searchUsers")
SELECT * FROM user
WHERE deleted_time IS NULL
#if(keyword)
  AND (username LIKE #para(keyword) OR phone LIKE #para(keyword))
#end
#if(status != null)
  AND status = #para(status)
#end
ORDER BY created_time DESC
#end

-- 示例3：使用命名空间（推荐用于大型项目）
#namespace("user")
    -- 查询用户列表（带分页支持）
    #sql("list")
        SELECT * FROM user
        WHERE deleted_time IS NULL
        #if(username)
          AND username LIKE #para(username)
        #end
        #if(phone)
          AND phone LIKE #para(phone)
        #end
        ORDER BY created_time DESC
    #end
    
    -- 统计用户数量
    #sql("count")
        SELECT COUNT(*) as total FROM user
        WHERE deleted_time IS NULL
        #if(status != null)
          AND status = #para(status)
        #end
    #end
    
    -- 根据ID查询用户
    #sql("findById")
        SELECT * FROM user
        WHERE id = #para(id)
          AND deleted_time IS NULL
    #end
#end

-- 示例4：复杂查询（多表关联）
#namespace("order")
    #sql("listWithUser")
        SELECT 
            o.*,
            u.username,
            u.phone
        FROM orders o
        LEFT JOIN user u ON o.user_id = u.id
        WHERE o.deleted_time IS NULL
        #if(userId)
          AND o.user_id = #para(userId)
        #end
        #if(status != null)
          AND o.status = #para(status)
        #end
        ORDER BY o.created_time DESC
    #end
#end