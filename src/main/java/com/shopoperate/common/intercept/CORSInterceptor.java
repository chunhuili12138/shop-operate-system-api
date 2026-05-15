package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.shopoperate.utils.ApiReturn;

public class CORSInterceptor implements Interceptor {

    /**
     * 一般跨域
     * */
    public void intercept(Invocation inv){
        Controller controller = inv.getController();
        controller.getResponse().addHeader("Access-Control-Allow-Origin","*");
        controller.getResponse().addHeader("Access-Control-Allow-Methods","*");
        controller.getResponse().addHeader("Access-Control-Allow-Headers","*");
        controller.getResponse().addHeader("Access-Control-Max-Age", "43200");
        //允许携带cookie时，必须要指定允许的域名
        //controller.getResponse().setHeader("Access-Control-Allow-Credentials","true");
        String method = controller.getRequest().getMethod();
        if("OPTIONS".equals(method)){
            controller.renderJson(new ApiReturn().success());
        }else {
            inv.invoke();
        }
    }
}
