package com.shopoperate.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 接口标准返回内容
 *
 * 规范：
 * - success=true, code=200 → 业务成功
 * - success=false, code=200 → 业务失败，msg 为错误原因
 * - success=false, code=401/404/500 → 系统级错误，info 为系统描述
 * - 所有业务数据通过 addData 添加，直接放在根层次
 * - 如果返回一个对象有多个字段，调用方先组装 Map 再 addData("data", map)
 */
public class ApiReturn {
    private final Map<String, Object> data = new HashMap<>();
    private String customMsg = null;

    /** 设置业务提示（覆盖默认 msg） */
    public ApiReturn addMsg(String value) {
        this.customMsg = value;
        return this;
    }

    /** 业务成功 */
    public Map<String, Object> success() {
        this.data.put("success", true);
        this.data.put("code", 200);
        this.data.put("msg", customMsg != null ? customMsg : "操作成功");
        this.data.put("timestamp", System.currentTimeMillis());
        return data;
    }

    /** 业务失败 */
    public Map<String, Object> fail() {
        this.data.put("success", false);
        this.data.put("code", 200);
        this.data.put("msg", customMsg != null ? customMsg : "操作失败");
        this.data.put("timestamp", System.currentTimeMillis());
        return data;
    }

    /** 未登录 */
    public Map<String, Object> loginInvalid() {
        return error(HttpStatusCode.UNAUTHORIZED.code, HttpStatusCode.UNAUTHORIZED.message, "未登录或登录已失效");
    }

    /** 服务器错误 */
    public Map<String, Object> serverErr() {
        return error(HttpStatusCode.INTERNAL_SERVER_ERROR.code, HttpStatusCode.INTERNAL_SERVER_ERROR.message, "服务器内部错误");
    }

    /** 请求方法不允许 */
    public Map<String, Object> methodNotAllow() {
        return error(HttpStatusCode.METHOD_NOT_ALLOWED.code, HttpStatusCode.METHOD_NOT_ALLOWED.message, "请求方法不允许");
    }

    /** 资源未找到 */
    public Map<String, Object> notFound() {
        return error(HttpStatusCode.NOT_FOUND.code, HttpStatusCode.NOT_FOUND.message, "请求的资源不存在");
    }

    /** 请求频率过高 */
    public Map<String, Object> tooManyRequest() {
        return error(HttpStatusCode.TOO_MANY_REQUESTS.code, HttpStatusCode.TOO_MANY_REQUESTS.message, "请求过于频繁，请稍后再试");
    }

    /** 无权限 */
    public Map<String, Object> noPermission() {
        return error(HttpStatusCode.FORBIDDEN.code, HttpStatusCode.FORBIDDEN.message, "无权限访问");
    }

    /** 重复提交 */
    public Map<String, Object> repeatSubmit() {
        this.data.put("success", false);
        this.data.put("code", 200);
        this.data.put("msg", "请勿重复提交");
        this.data.put("timestamp", System.currentTimeMillis());
        return data;
    }

    private Map<String, Object> error(int code, String info, String msg) {
        this.data.put("success", false);
        this.data.put("code", code);
        this.data.put("msg", msg);
        this.data.put("info", info);
        this.data.put("timestamp", System.currentTimeMillis());
        return data;
    }

    public ApiReturn addData(String name, List<?> value) {
        data.put(name, value);
        return this;
    }

    public ApiReturn addData(String name, Map<?, ?> value) {
        data.put(name, value);
        return this;
    }

    public ApiReturn addData(String name, Integer value) {
        data.put(name, value);
        return this;
    }

    public ApiReturn addData(String name, String value) {
        data.put(name, value);
        return this;
    }

    public ApiReturn addData(String name, boolean value) {
        data.put(name, value);
        return this;
    }

    public ApiReturn addData(String name, Object value) {
        data.put(name, value);
        return this;
    }
}
