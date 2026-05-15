package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.utils.ApiReturn;
import org.apache.commons.lang.StringUtils;

public class ParameterValidationInterceptor implements Interceptor {

    public void intercept(Invocation inv){
        Controller controller = inv.getController();
        String method = controller.getRequest().getMethod();

        // if("post".equals(method)){
        //     String jsonStr =  HttpKit.readData(controller.getRequest());
        //     if (StrKit.notBlank(jsonStr)) {
        //         @SuppressWarnings("unchecked")
        //         Map<String, Object> ls = (Map<String, Object>) JSONObject.toBean(new JSONObject().fromObject(jsonStr), Map.class);
        //         for(Map.Entry<String, Object> entry : ls.entrySet()){
        //             controller.setAttr(entry.getKey(),entry.getValue());
        //         }
        //     }
        // }

        ParameterValidation pv = inv.getMethod().getAnnotation(ParameterValidation.class);
        if(pv != null){
            String param = "";
            boolean isPass = true;
            String[] params = pv.value();
            if("post".equals(method)){
                for(String p : params){
                    if(StringUtils.isBlank(controller.getAttr(p))){
                        isPass = false;
                        param = p;
                    }
                }
            }else{
                for(String p : params){
                    if(StringUtils.isBlank(controller.getPara(p))){
                        isPass = false;
                        param = p;
                    }
                }
            }

            if(isPass){
                inv.invoke();
            }else{
                controller.renderJson(new ApiReturn().addMsg(param+"参数不能为空！").fail());
            }
        }else{
            inv.invoke();
        }

    }
}
