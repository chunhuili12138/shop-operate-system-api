package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.shopoperate.utils.ApiReturn;

public class MyExceptionInterceptor implements Interceptor {

    public void intercept(Invocation inv) {
        Controller controller = inv.getController();
        try {
            inv.invoke();
        } catch (Exception e) {
            System.out.println("~~~~~~~~~~~~~error start~~~~~~~~~~~~~~~~");
            System.out.println(e);
            System.out.println("~~~~~~~~~~~~~error   end~~~~~~~~~~~~~~~~");
            controller.renderJson(new ApiReturn().serverErr());
        }
    }
}
