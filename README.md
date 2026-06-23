# 店铺管理系统 API

基于 JFinal 框架开发的 SaaS 多租户店铺管理系统后端 API 服务。

---

## 快速开始

### 首次启动

1. 执行根目录 `shop_operate_system_db.sql` 建库建表
2. 复制 `src/main/resources/start-config-dev.example.txt` 为 `start-config-dev.txt`
3. 修改 `start-config-dev.txt` 中数据库密码和 Redis 配置
4. 确保 Redis 已启动（默认 `localhost:6379`）
5. 运行 `StartConfig.main()` 启动项目
6. 首次启动自动初始化基础数据（超管账号 `admin / admin123`，含角色/权限/字典）

### 启动入口

```java
com.shopoperate.common.StartConfig.main(args)
```

默认端口：**8081**（配置于 `undertow.txt`）

### 打包

```bash
mvn clean package -DskipTests
# 输出: target/shop-operate-system-api.jar
```

---

## 技术栈

| 类别 | 技术 | 版本 |
|------|------|------|
| Web 框架 | JFinal + Undertow | 5.2.2 / 3.0 |
| 数据库 | MySQL | 8.0+ |
| 连接池 | Druid | 1.2.6 |
| 缓存 | Redis (Jedis) | 3.6.3 |
| 定时任务 | Quartz | 2.3.2 |
| 密码加密 | BCrypt (jbcrypt) | 0.4 |
| JSON | FastJSON / Gson | 1.2.78 / 2.8.9 |
| 文件上传 | COS | 2022.2 |
| 手机号验证 | libphonenumber | 8.13.26 |
| 构建 | Maven + JDK 1.8 | — |

---

## 项目结构

```
com.shopoperate/
├── admin/              # 商户管理（席位订阅/流水）
├── app/                # 小程序端 API
├── auth/               # 认证（登录/退出/Token/验证码）
├── common/
│   ├── annotation/     # 自定义注解（5个）
│   ├── intercept/      # 拦截器（10个）
│   ├── model/          # ActiveRecord Model（42张表）
│   ├── vo/             # 值对象（User）
│   ├── DataInitializer.java   # 首次启动自动初始化
│   └── StartConfig.java       # JFinal 主配置类
├── customer/           # 顾客管理（含钱包/积分）
├── dashboard/          # 仪表盘数据服务
├── feedback/           # 评价反馈
├── file/               # 文件上传/图片服务
├── finance/            # 财务（收支/发票/提成/考勤/排班/通知/报表）
├── index/              # 首页/测试接口
├── inventory/          # 物料/库存/出入库
├── marketing/          # 优惠券/文章管理
├── packages/           # 套餐管理（含BOM）
├── shop/               # 店铺管理
├── staff/              # 员工/角色/权限管理
├── supplier/           # 供应商/采购单
├── system/             # 字典管理 + 7个定时任务
├── trade/              # 购买/核销/退款（完整交易闭环）
└── utils/              # 工具类（13个）
```

---

## 认证与权限

### 认证方式

```
Header: Authorization: Bearer {token}                  # 超管
Header: Authorization: Bearer-{shopId}-{token}          # 商户/员工
```

### 权限体系

```
staff → staff_roles → roles → role_permissions → permissions(menu_code)
```

### 常用注解

| 注解 | 用途 |
|------|------|
| `@RequireLogin` | 需登录（TokenInterceptor 校验，未登录返回 401） |
| `@RequirePermission("btn:xxx")` | 按钮级权限（PermissionInterceptor 校验） |
| `@MethodValidation("GET/POST")` | 限制 HTTP 方法 |
| `@ParameterValidation({"p1"})` | 参数必填校验 |
| `@RepeatSubmit(lockTime=2)` | 防重复提交（Redis setnx） |
| `@Before(ShopDataIsolationInterceptor.class)` | 店铺级数据隔离 |

### 全局拦截器链

```
CORS → Exception → ParameterValidation → MethodValidation
  → RateLimit → RepeatSubmit → Token → Permission
```

---

## API 响应规范

```json
// 业务成功
{ "success": true,  "code": 200, "msg": "操作成功",         "data": {...}, "timestamp": 123 }

// 业务失败
{ "success": false, "code": 200, "msg": "用户名或密码错误",   "timestamp": 123 }

// 系统错误（未登录/无权限/404/500）
{ "success": false, "code": 401, "msg": "未登录或登录已失效", "info": "Unauthorized", "timestamp": 123 }
```

| 字段 | 说明 |
|------|------|
| `success` | **唯一业务成功标志**，`true`=成功，`false`=失败 |
| `code` | `200`=业务已处理，`401/403/404/429/500`=系统错误 |
| `msg` | 前端展示提示 |
| `info` | 系统错误英文描述（仅 code≠200 时出现） |

前端统一使用 `res.success === true` 判断业务成功。

---

## 核心接口速查

| 模块 | 路径前缀 | Controller |
|------|----------|------------|
| 认证 | `/api/auth/*` | `AuthController` |
| 字典 | `/api/system/dict/*` | `SysDictController` |
| 商户/席位 | `/api/admin/tenants/*` | `TenantController` |
| 店铺 | `/api/shops/*` | `ShopController` |
| 员工 | `/api/staff/*` | `StaffController` |
| 角色 | `/api/roles/*` | `RolesController` |
| 权限 | `/api/permissions/*` | `PermissionsController` |
| 顾客 | `/api/customers/*` | `CustomerController` |
| 套餐 | `/api/packages/*` | `PackageController` |
| 交易（购买/核销/退款） | `/api/purchases*`, `/api/gameSessions*`, `/api/purchasesRefunds*` | `TradeController` |
| 财务（收支/发票/提成/考勤/排班/通知/报表） | `/api/revenues*`, `/api/expenses*`, `/api/commission*`, `/api/attendance*`, `/api/staffSchedules*`, `/api/notifications*`, `/api/dashboard*`, `/api/dailySnapshots*` | `FinanceController` |
| 库存（物料/出入库） | `/api/materials*`, `/api/inventory*` | `InventoryController` |
| 供应商/采购 | `/api/suppliers*`, `/api/purchaseOrders*` | `SupplierController` |
| 营销（优惠券/文章） | `/api/coupons*`, `/api/articles*` | `MarketingController` |
| 评价反馈 | `/api/feedbacks/*` | `FeedbackController` |
| 文件 | `/api/file/*` | `FileController` |
| 小程序端 | `/api/app/customer/*` | `AppCustomerController` |

---

## 数据库操作

### Record 方式（推荐）

```java
Record r = Db.findById("staff", id);
Db.save("staff", r);
Db.update("staff", r);
Page<Record> p = Db.paginate(page, size, "SELECT *", "FROM staff WHERE is_deleted=0");

// 事务
Db.tx(() -> {
    Db.save("table1", r1);
    Db.update("table2", r2);
    return true;
});
```

### SQL 模板（db.sql）

```sql
#sql("getUser")
SELECT * FROM staff_accounts WHERE username = #para(username)
#end

#namespace("user")
    #sql("findByKeyword")
        SELECT * FROM user WHERE deleted_time IS NULL
        #if(keyword)
            AND (username LIKE ? OR phone LIKE ?)
        #end
    #end
#end
```

```java
Kv cond = new Kv().set("username", username);
Record r = Db.template("getUser", cond).findFirst();
```

### 常用查询

```java
List<Record> list = Db.find("SELECT * FROM user WHERE status = ?", 1);
Record user = Db.findFirst("SELECT * FROM user WHERE id = ?", 1);
Long count = Db.queryLong("SELECT COUNT(*) FROM user WHERE status = ?", 1);
```

---

## 新增业务模块指南

### 1. 创建 Service（单例模式）

```java
package com.shopoperate.xxx;

public class XxxService {
    public static final XxxService me = new XxxService();

    public List<Record> getList(int shopId) {
        return Db.find("SELECT * FROM xxx WHERE shop_id = ?", shopId);
    }
}
```

### 2. 创建 Controller

```java
package com.shopoperate.xxx;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.shopoperate.common.annotation.RequireLogin;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.utils.ApiReturn;

@Path(value = "/api/xxx")
public class XxxController extends Controller {

    private XxxService service = XxxService.me;

    @RequireLogin
    @MethodValidation("GET")
    public void page() {
        int page = getParaToInt("page", 1);
        int size = getParaToInt("size", 20);
        Page<Record> p = Db.paginate(page, size, "SELECT *", "FROM xxx WHERE shop_id=?", User.loginShopId);
        renderJson(new ApiReturn()
            .addData("list", p.getList())
            .addData("total", p.getTotalRow())
            .success());
    }
}
```

Controller 通过 `me.scan("com.shopoperate.")` 自动注册，无需手动配置路由。如需特殊 URL 映射，在 `StartConfig.configRoute()` 中显式添加。

---

## 项目规范要点

| 规则 | 说明 |
|------|------|
| Service 单例 | `public static final XxxService me = new XxxService()` |
| 数据隔离 | 所有 SQL 必须 `WHERE shop_id = ?`（非超管强制） |
| 逻辑删除 | 查询条件 `WHERE deleted_time IS NULL` |
| 命名规范 | DB 字段下划线 `created_time`，Java 变量驼峰 `createTime` |
| 统一响应 | 使用 `ApiReturn` 构建，禁止直接 `renderJson(map)` |
| 字典枚举 | 前端动态加载 `/api/system/dict/data/{dictCode}`，禁止硬编码 |
| Model 生成 | 表结构变更后运行 `_JFinalGenerator.main()` 重新生成 |

---

## 配置文件

| 文件 | 说明 |
|------|------|
| `start-config-dev.example.txt` | 开发环境配置模板（复制为 `start-config-dev.txt` 使用） |
| `undertow.txt` | 服务器配置（端口 8081 / Gzip / SSL） |
| `db.sql` | SQL 模板文件（Enjoy 引擎） |
| `log4j.properties` | 日志配置 |

启动时按 `start-config-prod.txt` → `start-config-dev.txt` 顺序查找，使用最先找到的配置文件。

---

## 常见问题

| 问题 | 检查项 |
|------|--------|
| 数据库连接失败 | MySQL 是否启动？`start-config-dev.txt` 中密码是否正确？（从 `.example.txt` 复制） |
| Redis 连接失败 | Redis 是否启动？默认 `localhost:6379` |
| Token 验证失败 | 请求头是否包含 `Authorization`？Token 是否过期？ |
| 端口冲突 | 修改 `undertow.txt` 中 `undertow.port` |
| 文件上传失败 | 上传目录是否有写权限？文件大小是否超过 64MB？ |
