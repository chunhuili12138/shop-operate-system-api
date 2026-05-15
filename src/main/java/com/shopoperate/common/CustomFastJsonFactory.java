package com.shopoperate.common;

import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.support.config.FastJsonConfig;
import com.jfinal.json.FastJsonFactory;
import com.jfinal.json.JFinalJson;

public class CustomFastJsonFactory extends FastJsonFactory {

    private static final JFinalJson json = new JFinalJson() {
        @Override
        public String toJson(Object object) {
            FastJsonConfig config = new FastJsonConfig();

            SerializeConfig serializeConfig = SerializeConfig.globalInstance;
            serializeConfig.propertyNamingStrategy = com.alibaba.fastjson.PropertyNamingStrategy.CamelCase;

            config.setSerializeConfig(serializeConfig);
            config.setSerializerFeatures(
                SerializerFeature.WriteMapNullValue,
                SerializerFeature.WriteDateUseDateFormat,
                SerializerFeature.DisableCircularReferenceDetect
            );

            return com.alibaba.fastjson.JSON.toJSONString(object, serializeConfig, config.getSerializerFeatures());
        }
    };

    @Override
    public JFinalJson getJson() {
        return json;
    }
}
