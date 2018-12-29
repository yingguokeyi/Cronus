package action.service;

import action.sqlhelper.FinanceSql;
import cache.ResultPoor;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.BaseCache;
import common.StringHandler;
import common.Utils;

public class FinanceService extends BaseService {

	public static String getpayment(int begin, int end) {
		int sid = sendObject(81, begin, end);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		return rsFinanceJson;

	}

	public static String updatepayment(String account_name, String account_num, String bank_name, String company_name) {
		int sid = sendObjectCreate(82, account_name, account_num, bank_name, company_name);
		String rsFinance = ResultPoor.getResult(sid);

		return rsFinance;

	}

	public static String Commissio(int begin, int end, String member_level, String phone) {
		StringBuffer sql = new StringBuffer();
		sql.append(FinanceSql.CommissioListPage_sql);
		if (phone != null && !phone.equals("")) {
			sql.append(" and t_user.phone like '%").append(phone).append("%'");
		}
		if (member_level != null && !member_level.equals("")) {
			sql.append(" and member_level like '%").append(member_level).append("%'");
		}

		//sql.append(" GROUP BY `user`.id ");
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
		System.out.println(sid);
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	public static String Withdraw(int begin, int end, String nick_name, String phone, String test5, String test6,

								  String test7, String test8,String status) {
		StringBuffer sql = new StringBuffer();
		if (phone != null && !phone.equals("")) {
			sql.append(" and phone like '%").append(phone).append("%'");
		}
		if (nick_name != null && !nick_name.equals("")) {
			sql.append(" and nick_name like '%").append(nick_name).append("%'");
		}
		if ((test5 != null && !test5.equals("")) || (test6 != null && !test6.equals(""))) {
			String tests = Utils.transformToYYMMddHHmmss(test5);
			String teste = Utils.transformToYYMMddHHmmss(test6);
			sql.append(" and create_time BETWEEN ").append(tests).append(" and ").append(teste);
		}
		if ((test7 != null && !test7.equals("")) || (test8 != null && !test8.equals(""))) {
			String tests = Utils.transformToYYMMddHHmmss(test7);
			String teste = Utils.transformToYYMMddHHmmss(test8);
			sql.append(" and edit_time BETWEEN ").append(tests).append(" and ").append(teste);
		}
		if (status != null && !status.equals("")) {
			sql.append(" and w.status =").append(status).append("");
		}
		sql.append(" ORDER BY w.create_time DESC ");
		int sid = sendObjectBase(711, sql.toString());
		String result = ResultPoor.getResult(sid);
		String retString = StringHandler.getRetString(result);
		return retString;
	}

	public static String WithdrawShowdetail(int begin, int end, String user_id) {

		StringBuffer sql = new StringBuffer();
		//条件查询
		if(user_id != null && !user_id.equals("")){
			sql.append(" AND w.user_id = ").append(user_id);
		}
		sql.append(" ORDER BY w.create_time DESC ");
		int sid = sendObjectBase(711, sql.toString());
		String result = ResultPoor.getResult(sid);
		String retString = StringHandler.getRetString(result);
		System.out.println(retString);
		return retString;
	}

	public static String WithdrawDetail(String id, int begin, int end, String name, String test5, String test6,
			String order_status, String earnings_type) {
		StringBuffer sql = new StringBuffer();
		sql.append(FinanceSql.WithdrawDetailPage_sql(id));
		if (name != null && !name.equals("")) {
			sql.append(" and USER.nick_name like '%").append(name).append("%'");
		}
		if ((test5 != null && !test5.equals("")) || (test6 != null && !test6.equals(""))) {
			String tests = Utils.transformToYYMMddHHmmss(test5);
			String teste = Utils.transformToYYMMddHHmmss(test6);

			sql.append(" and der.created_date BETWEEN ").append(tests).append(" and ").append(teste);
		}
		if (earnings_type != null && !earnings_type.equals("")) {
			sql.append(" and c.profit_source like '%").append(earnings_type).append("%'");
		}
		if (order_status != null && !order_status.equals("")) {
			if (order_status.equals("0")) {
				sql.append(" and der.STATUS in(109,110,112)");
			}
			if (order_status.equals("1")) {
				sql.append(" and der.STATUS =108");
			}
			if (order_status.equals("2")) {
				sql.append(" and der.STATUS in(101,102,103,104,105,106,107)");
			}
		}
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}
	//同意提现
	public static String agreerequest(String id, int userId) {

		int uId = UserService.checkUserPwdFirstStep(userId);
		String operator = UserService.selectLoginName(uId);
		String edit_time= BaseCache.getDateTime();
		String remarks = "";
		String status = "2"; //同意提现
		int updateId=sendObjectCreate(714,remarks,operator,edit_time,status,id);
		String resu = ResultPoor.getResult(updateId);

		return resu;

	}

	public static String rejectrequest(String id, String remarks,int userId) {

		StringBuffer sql = new StringBuffer();
		if (id != null && !id.equals("")) {
			sql.append(" and w.id = ").append(id);
			int sid = sendObjectBase(711, sql.toString());
			String result = ResultPoor.getResult(sid);
			JSONObject res = JSONObject.parseObject(result);
			String money = res.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("money");
			String amount = res.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("amount");
			String user_id = res.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("user_id");


			int uId = UserService.checkUserPwdFirstStep(userId);
			String operator = UserService.selectLoginName(uId);
			String edit_time= BaseCache.getDateTime();
			String status = "3"; //拒绝提现
			int sid1 = sendObjectCreate(714, remarks,operator,edit_time,status,id);
			String rsFinance = ResultPoor.getResult(sid1);
			String rsFinanceJson = StringHandler.getRetString(rsFinance);
			JSONObject jsonObject = JSONObject.parseObject(rsFinanceJson);
			String success = jsonObject.getString("success");

			if ("1".equals(success)){
				int intAmount = Integer.valueOf(amount);
				int intMoney = Integer.valueOf(money)+intAmount;
				sendObjectCreate(715, intMoney, user_id);
				return rsFinanceJson;
			}
			return "";
		}
		return "";
	}

	public static String Getpeople(String user_id) {
		int sid = sendObject(92, user_id);
		String rsIndex = ResultPoor.getResult(sid);
		String OBIndex = StringHandler.getRetString(rsIndex);
		return OBIndex;

	}

	public static String abolishquest(String id,int userId) {
		int uId = UserService.checkUserPwdFirstStep(userId);
		String operator = UserService.selectLoginName(uId);
		String edit_time= BaseCache.getDateTime();
 		String remarks = "";
		String status = "4"; //作废
		int sid = sendObjectCreate(714,remarks,operator,edit_time,status,id);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		return rsFinanceJson;

	}


	//修改提现状态
	public static String updateWithdrawalsStatus(String remarks,String status,String ids,int userId){

		int uId = UserService.checkUserPwdFirstStep(userId);
		String operator = UserService.selectLoginName(uId);
		String edit_time= BaseCache.getDateTime();
		if (remarks == null ) {
			remarks = "";
		}

		String[] idArray = ids.split(",");
		int sid = 0;
		for (String aid : idArray) {
			sid = sendObjectCreate(714,remarks,operator,edit_time,status,aid);
		}
		String result = ResultPoor.getResult(sid);
		return result;

	}


	public static String zdzOrders(int begin, int end, String nick_name, String phone, String test5, String test6,
								  String commi_id, String status,String source) {
		StringBuffer sql = new StringBuffer();
		if (phone != null && !phone.equals("")) {
			sql.append(" and phone like '%").append(phone).append("%'");
		}
		if (nick_name != null && !nick_name.equals("")) {
			sql.append(" and nick_name like '%").append(nick_name).append("%'");
		}
		if ((test5 != null && !test5.equals("")) || (test6 != null && !test6.equals(""))) {
			String tests = Utils.transformToYYMMddHHmmss(test5);
			String teste = Utils.transformToYYMMddHHmmss(test6);
			sql.append(" and operation_time BETWEEN ").append(tests).append(" and ").append(teste);
		}
		if (commi_id != null && !commi_id.equals("")) {
			sql.append(" and commi_id like '%").append(commi_id).append("%'");
		}
		if (status != null && !status.equals("")) {
			if (status.equals("0")) {
				sql.append(" and status =").append(status).append("");
			} else {

				sql.append(" and status in (1,2)");
			}

		}
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);

		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}


	public static String  findUserWallet(int begin, int end,String phone,String price_min,String price_max){
		StringBuffer sql = new StringBuffer();

		if(phone !=null && !"".equals(phone)){
			sql.append(" and u.phone =").append(phone);
		}

		if (price_min != null && !"".equals(price_min)) {
			String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
			sql.append(" and w.operation_time between '").append(created_date1).append("'");
		}
		if (price_max != null && !"".equals(price_max)) {
			String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
			sql.append(" and '").append(created_date1).append("'");
		}
		sql.append(" order by w.operation_time desc");
		int sid = sendObjectBase(615,sql.toString(),begin,end);
		String rsFinance = ResultPoor.getResult(sid);
		String rsFinanceJson = StringHandler.getRetString(rsFinance);
		return rsFinanceJson;
	}

}
