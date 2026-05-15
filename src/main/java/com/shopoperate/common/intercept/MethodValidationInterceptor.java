package com.shopoperate.common.intercept;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.utils.ApiReturn;

public class MethodValidationInterceptor implements Interceptor {

    public void intercept(Invocation inv){
        Controller controller = inv.getController();
        String method = controller.getRequest().getMethod();

        MethodValidation mv = inv.getMethod().getAnnotation(MethodValidation.class);
        if (mv != null) {
            String allMethod = mv.value();
            if (method.equals(allMethod)) {
                inv.invoke();
            } else {
                controller.renderJson(new ApiReturn().methodNotAllow());
            }
        } else {
            inv.invoke();
        }
    }
}
