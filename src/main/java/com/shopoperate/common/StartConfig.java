package com.shopoperate.common;

import com.shopoperate.common.intercept.*;
import com.shopoperate.system.ScheduleTaskManager;
import com.jfinal.json.Json;
import com.jfinal.plugin.redis.RedisPlugin;
import com.shopoperate.common.model._MappingKit;
import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.kit.Prop;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.druid.DruidPlugin;
import com.jfinal.server.undertow.UndertowServer;
import com.jfinal.template.Engine;
import com.shopoperate.utils.ApiReturn;

/**
 * API 引导式配置
 */
public class StartConfig extends JFinalConfig {
	
	static Prop p;
	
	/**
	 * 启动入口，运行此 main 方法可以启动项目，此 main 方法可以放置在任意的 Class 类定义中，不一定要放于此
	 */
	public static void main(String[] args) {
		 UndertowServer.start(StartConfig.class);
	}
	
	/**
	 * PropKit.useFirstFound(...) 使用参数中从左到右最先被找到的配置文件
	 * 从左到右依次去找配置，找到则立即加载并立即返回，后续配置将被忽略
	 */
	static void loadConfig() {
		if (p == null) {
			p = PropKit.useFirstFound("start-config-prod.txt", "start-config-dev.txt");
		}
	}
	
	/**
	 * 配置常量
	 */
	public void configConstant(Constants me) {
		loadConfig();
		
		me.setDevMode(p.getBoolean("devMode", false));

		me.setJsonFactory(new CustomFastJsonFactory());

		/*
		  支持 Controller、Interceptor、Validator 之中使用 @Inject 注入业务层，并且自动实现 AOP
		  注入动作支持任意深度并自动处理循环注入
		 */
		me.setInjectDependency(true);
		
		// 配置对超类中的属性进行注入
		me.setInjectSuperClass(true);

		// 开启解析 json 请求
		me.setResolveJsonRequest(true);

		// 自定义404返回
		me.setErrorJsonContent(404, Json.getJson().toJson(new ApiReturn().notFound()));

		// 配置上传文件最大数据量，默认 10M
		me.setMaxPostSize(64 * 1024 * 1024);

		// 配置文件下载的基础路径
		me.setBaseDownloadPath("C:/shop-operate/files");

		// 配置文件上传的基础路径
		me.setBaseUploadPath("C:/shop-operate/files");
	}
	
	/**
	 * 配置路由
	 */
	public void configRoute(Routes me) {
		// 使用 jfinal 4.9.03 新增的路由扫描功能
		me.scan("com.shopoperate.");

		// 前端路径与后端方法名不一致的，显式映射
		// /api/auth/refresh-token → AuthController.refreshToken()
		me.add("/api/auth/refresh-token", com.shopoperate.auth.AuthController.class, "refreshToken");
	}
	
	public void configEngine(Engine me) {}
	
	/**
	 * 配置插件
	 */
	public void configPlugin(Plugins me) {
		// 配置 druid 数据库连接池插件
		DruidPlugin druidPlugin = new DruidPlugin(p.get("jdbcUrl"), p.get("user"), p.get("password"));
		
		// 配置连接池大小
		druidPlugin.setInitialSize(5);
		druidPlugin.setMinIdle(5);
		druidPlugin.setMaxActive(20);
		
		// 配置获取连接等待超时的时间
		druidPlugin.setMaxWait(60000);
		
		// 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
		druidPlugin.setTimeBetweenEvictionRunsMillis(60000);
		
		// 配置一个连接在池中最小生存的时间，单位是毫秒
		druidPlugin.setMinEvictableIdleTimeMillis(300000);
		
		// 配置连接保活机制
		druidPlugin.setKeepAlive(true);
		
		// 配置连接有效性检测
		druidPlugin.setTestWhileIdle(true);
		druidPlugin.setTestOnBorrow(false);
		druidPlugin.setTestOnReturn(false);
		
		// 配置验证查询
		druidPlugin.setValidationQuery("SELECT 1");
		druidPlugin.setValidationQueryTimeout(3);
		
		me.add(druidPlugin);
		
		// 配置ActiveRecord插件
		ActiveRecordPlugin arp = new ActiveRecordPlugin(druidPlugin);

		arp.addSqlTemplate("db.sql");

		// 显示sql语句
		arp.setShowSql(true);

		// 所有映射在 MappingKit 中自动化搞定
		_MappingKit.mapping(arp);
		me.add(arp);

		// redis服务
		RedisPlugin myRedis = new RedisPlugin("myRedis", "localhost");
		me.add(myRedis);
	}
	
	public static DruidPlugin createDruidPlugin() {
		loadConfig();
		
		return new DruidPlugin(p.get("jdbcUrl"), p.get("user"), p.get("password"));
	}
	
	/**
	 * 配置全局拦截器
	 */
	public void configInterceptor(Interceptors me) {
		// 跨域拦截
		me.add(new CORSInterceptor());
		// 报错拦截
		me.add(new MyExceptionInterceptor());
		// 参数验证拦截
		me.add(new ParameterValidationInterceptor());
		// 请求类型拦截
		me.add(new MethodValidationInterceptor());
		// 请求过多拦截
		me.add(new RateLimitInterceptor());
		// 频率拦截
		me.add(new RepeatSubmitInterceptor());
		// Token认证拦截（只拦截带@RequireLogin注解的方法）
		me.add(new TokenInterceptor());
		// 权限校验拦截（配合@RequirePermission注解）
		me.add(new PermissionInterceptor());
	}
	
	/**
	 * 配置处理器
	 */
	public void configHandler(Handlers me) {}

	@Override
	public void onStart() {
		System.out.println("===========project start===========");
		// 初始化基础数据（幂等：已有则跳过）
		DataInitializer.initialize();
		// 启动定时任务
		ScheduleTaskManager.me().start();
		System.out.println("----------project start finish----------");
	}

	@Override
	public void onStop() {
		ScheduleTaskManager.me().stop();
		System.out.println("project stop");
	}
}
