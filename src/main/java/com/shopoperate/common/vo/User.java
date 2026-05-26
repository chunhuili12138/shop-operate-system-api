package com.shopoperate.common.vo;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;

/**
 * 登录用户VO
 */
public class User implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private BigInteger id;
    private String username;       // 登录用户名（取自 staff_accounts.username）
    private String name;           // 员工名称（兼容旧字段）
    private String nickname;       // 昵称（复用 name）
    private String phone;
    private String email;
    private String avatar;
    private Integer status;        // 1-在职，0-离职
    private Integer isBan;         // 是否封禁（0否，1是）
    private Integer bossStatus;    // 是否商户主体（0：否，1：是）
    private Integer isSuperAdmin;  // 是否超管（0否，1是）
    private BigInteger loginShopId; // 当前登录店铺ID（超管可为null）
    private String token;          // 登录令牌
    private String refreshToken;   // 刷新令牌
    private Date loginTime;        // 登录时间
    // === 小程序顾客端扩展 ===
    private String userType;       // 用户类型: "customer" / "staff" / "admin"
    private BigInteger customerId; // 顾客ID（userType="customer"时有值）
    private Integer isStaff;       // 是否也是员工（0否，1是），用于前端条件渲染
    
    public User() {
    }
    
    public User(BigInteger id, String name, String phone) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.loginTime = new Date();
    }
    
    // getter and setter methods
    public BigInteger getId() {
        return id;
    }

    public void setId(BigInteger id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        if (this.nickname == null) {
            this.nickname = name;
        }
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getIsBan() {
        return isBan;
    }

    public void setIsBan(Integer isBan) {
        this.isBan = isBan;
    }

    public Integer getBossStatus() {
        return bossStatus;
    }

    public void setBossStatus(Integer bossStatus) {
        this.bossStatus = bossStatus;
    }

    public Integer getIsSuperAdmin() {
        return isSuperAdmin;
    }

    public void setIsSuperAdmin(Integer isSuperAdmin) {
        this.isSuperAdmin = isSuperAdmin;
    }

    public BigInteger getLoginShopId() {
        return loginShopId;
    }

    public void setLoginShopId(BigInteger loginShopId) {
        this.loginShopId = loginShopId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public Date getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(Date loginTime) {
        this.loginTime = loginTime;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public BigInteger getCustomerId() {
        return customerId;
    }

    public void setCustomerId(BigInteger customerId) {
        this.customerId = customerId;
    }

    public Integer getIsStaff() {
        return isStaff;
    }

    public void setIsStaff(Integer isStaff) {
        this.isStaff = isStaff;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", name='" + name + '\'' +
                ", nickname='" + nickname + '\'' +
                ", phone='" + phone + '\'' +
                ", avatar='" + avatar + '\'' +
                ", status=" + status +
                ", isBan=" + isBan +
                ", bossStatus=" + bossStatus +
                ", isSuperAdmin=" + isSuperAdmin +
                ", loginShopId=" + loginShopId +
                ", token='" + token + '\'' +
                ", loginTime=" + loginTime +
                ", userType='" + userType + '\'' +
                ", customerId=" + customerId +
                ", isStaff=" + isStaff +
                '}';
    }
}
