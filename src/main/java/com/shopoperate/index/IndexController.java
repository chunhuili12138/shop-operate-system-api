package com.shopoperate.index;

import com.jfinal.core.Controller;
import com.jfinal.core.Path;
import com.jfinal.plugin.activerecord.Record;
import com.shopoperate.common.annotation.MethodValidation;
import com.shopoperate.common.annotation.ParameterValidation;
import com.shopoperate.utils.ApiReturn;

import java.util.List;

@Path(value = "/")
public class IndexController extends Controller {

	private final IndexService indexService = IndexService.me;

	public void index() {
		render("index/index.html");
	}

    @MethodValidation("GET")
    @ParameterValidation({ "username" })
    public void test() {
        String username = getPara("username");
        List<Record> list = indexService.getUser(username);
        renderJson(new ApiReturn().addData("data", list).success());
    }

}



