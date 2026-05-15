package com.shopoperate.utils;


import com.google.gson.Gson;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

import org.json.*;

import java.util.ArrayList;
import java.util.List;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Tool {

    /**
     * 获得一个UUID
     * */
    public static String getUUId() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * 随机生成6位数字
     */
    public static String RandomSixDigitNumber() {
        Random random = new Random();
        int sixDigitNumber = 100000 + random.nextInt(900000);
        return String.valueOf(sixDigitNumber);
    }

    /**
     * json字符串转map
     * */
    public static Map<String, Object> jsonToMap(String jsonStr) {
        Map<String, Object> map = new HashMap<>();
        try {
            JSONObject jsonObject = new JSONObject(jsonStr);
            for (String key : jsonObject.keySet()) {
                map.put(key, jsonObject.get(key));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * json字符串转list
     * */
    public static <T> List<T> jsonToList(String jsonStr, Class<T> clazz) {
        JSONArray jsonArray = new JSONArray(jsonStr);
        JSONObject object = null;
        T t = null;
        List<T> list = new ArrayList<>();
        for (int i = 0; i < jsonArray.length(); i++) {
            Gson gson = new Gson();
            t = gson.fromJson(jsonArray.get(i).toString(), clazz);
            list.add(t);
        }
        return list;
    }

    /**
     * 实体类转map
     * */
    public static Map<String, Object> entityToMap(Object object) {
        Map<String, Object> map = new HashMap<>();
        for (Field field : object.getClass().getDeclaredFields()){
            try {
                boolean flag = field.isAccessible();
                field.setAccessible(true);
                Object o = field.get(object);
                map.put(field.getName(), o);
                field.setAccessible(flag);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return map;
    }

    /**
     * map转实体类
     * */
    public static <T> T mapToEntity(Map<String, Object> map, Class<T> entity) {
        T t = null;
        try {
            t = entity.newInstance();
            for(Field field : entity.getDeclaredFields()) {
                if (map.containsKey(field.getName())) {
                    boolean flag = field.isAccessible();
                    field.setAccessible(true);
                    Object object = map.get(field.getName());
                    if (object!= null && field.getType().isAssignableFrom(object.getClass())) {
                        field.set(t, object);
                    }
                    field.setAccessible(flag);
                }
            }
            return t;
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return t;
    }

    /**
     * 获取到对象的所有字段（包括所有继承的父类）
     * */
    private static Field[] getAllField(Object model){
        Class clazz = model.getClass();
        List<Field> fields = new ArrayList<>();
        while (clazz!=null){
            fields.addAll(new ArrayList<>(Arrays.asList(clazz.getDeclaredFields())));
            clazz = clazz.getSuperclass();
        }
        Field[] field = new Field[fields.size()];
        fields.toArray(field);
        return field;
    }

    /**
     * Java 遍历一个对象的属性 将非空属性赋值给另一个对象
     * 赋值给同类对象
     * */
    public static <T> void mergeObject(T origin, T destination) {
        if (origin == null || destination == null)
            return;
        if (!origin.getClass().equals(destination.getClass()))
            return;

        Field[] fields = getAllField(destination);
        for (int i = 0; i < fields.length; i++) {
            try {
                fields[i].setAccessible(true);
                Object value = fields[i].get(origin);
                if (null != value) {
                    fields[i].set(destination, value);
                }
                fields[i].setAccessible(false);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static String[] getNullPropertyNames (Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for(java.beans.PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null) emptyNames.add(pd.getName());
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }

    /**
     * Java 遍历一个对象的属性 将非空属性赋值给另一个对象
     * 赋值给不同对象
     * */
    public static void copyPropertiesIgnoreNull(Object src, Object target){
        BeanUtils.copyProperties(src, target, getNullPropertyNames(src));
    }


    /**
     * 验证String参数是否是数字组成
     * */
    public static boolean isNumeric(String str) {
        for (int i = 0; i < str.length(); i++) {
            if (!Character.isDigit(str.charAt(i))){
                return false;
            }
        }
        return true;
    }

    /**
     * 判断是否是手机号
     * */
    public static boolean isPhone(String phone) {
        String regex = "^((13[0-9])|(14[5,7,9])|(15([0-3]|[5-9]))|(166)|(17[0,1,3,5,6,7,8])|(18[0-9])|(19[8|9]))\\d{8}$";
        if (phone.length() != 11) {
            return false;
        } else {
            Pattern p = Pattern.compile(regex);
            Matcher m = p.matcher(phone);
            return m.matches();
        }
    }

    /**
     * 验证是否是邮箱
     * */
    public static boolean isEmail(String email){
        final String pattern1 = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
        final Pattern pattern = Pattern.compile(pattern1);
        final Matcher mat = pattern.matcher(email);
        if (!mat.find()) {
            return false;
        }
        return true;
    }

    /**
     * 获取当前日期时间
     */
    public static String getCurrentDateTime(){
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    /**
     * 生成8位唯一码（纯数字）
     * 格式：时间戳后4位 + 4位随机数
     * 重复率极低，适合小规模应用（用户量<10万）
     */
    public static String generateUniqueKey() {
        long timestamp = System.currentTimeMillis();
        String timePart = String.valueOf(timestamp).substring(9);
        Random random = new Random();
        int randomPart = 1000 + random.nextInt(9000);
        return timePart + randomPart;
    }

    /**
     * 将字符串解析为日期
     * @param dateStr 日期字符串
     * @param pattern 日期格式，如 "yyyy-MM-dd"、"yyyy-MM-dd HH:mm:ss"
     * @return 解析后的日期对象
     */
    public static Date parseDate(String dateStr, String pattern) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.parse(dateStr);
    }

    /**
     * 将日期格式化为字符串
     * @param date 日期对象
     * @param pattern 日期格式，如 "yyyy-MM-dd"、"yyyy-MM-dd HH:mm:ss"
     * @return 格式化后的日期字符串
     */
    public static String formatDate(Date date, String pattern) {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(date);
    }
}