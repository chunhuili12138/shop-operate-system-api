package com.shopoperate.utils;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.Phonenumber;

public class PhoneValidator {
    private final PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil.getInstance();

    /**
     * 验证手机号是否格式正确（支持国际号码）
     * @param phone 手机号
     * @param region 国家/地区代码（如 "CN" 表示中国）
     * @return 如果手机号格式正确，返回true；否则返回false
     */
    public boolean isValidPhone(String phone, String region) {
        try {
            Phonenumber.PhoneNumber numberProto = phoneNumberUtil.parse(phone, region);
            return phoneNumberUtil.isValidNumber(numberProto);
        } catch (NumberParseException e) {
            return false;
        }
    }
}