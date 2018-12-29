package model;

import action.service.BaseService;
import cache.ResultPoor;
import com.alibaba.fastjson.JSONObject;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * @author cuiw
 * 每天24点 递增启用状态的秒杀时段24个小时
 *
 */
public class SeckillTimeManager extends BaseService implements Runnable {
	/**
	 * 查询出启用状态秒杀段 向后递增24小时 回写数据库
	 */
	@Override
	public void run() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyMMddHHmmss");
		/**
		 * @param startTime 声明变量初始值
		 *  @param endTime  声明变量初始值
		 *   @param edtString 默认值 无具体时间
		 */
		String startTime = "180724202111";
		String endTime = "180724202111";
		String edtString = "999999999999";
		try {
			int sid = sendObject(446,0,20);
			String res =  ResultPoor.getResult(sid);
			JSONObject result = JSONObject.parseObject(res).getJSONObject("result");
			JSONObject resultObject = JSONObject.parseObject(result.toJSONString());
			Object tmp = resultObject.get("total");
			int total = (int) tmp;
			for (int i = 0 ; i < total ; i++){
				int id = (int) BaseService.getFieldEachValue(res, "id", Integer.class,i);
				startTime = (String) BaseService.getFieldEachValue(res, "start_time", String.class,i);
				endTime = (String) BaseService.getFieldEachValue(res, "end_time", String.class,i);
				LocalDateTime sdt = LocalDateTime.parse(startTime,dtf);
				String sdtString = sdt.plusDays(1).format(dtf);
				if (!"999999999999".equals(endTime)) {
					LocalDateTime edt = LocalDateTime.parse(endTime,dtf);
					edtString = edt.plusDays(1).format(dtf);
				}
				int uid =  sendObjectCreate(447,sdtString,edtString,id);
				String UpdateResult = ResultPoor.getResult(uid);
				System.out.println("   -----------------  已经成功 回写 数据库   ------------------- "+UpdateResult);
			}
				System.out.println(" --------------  秒杀时段 递增时刻任务  ------------------ " + LocalDateTime.now());
		} catch (NullPointerException e){
			e.printStackTrace();
		}

	}
}
