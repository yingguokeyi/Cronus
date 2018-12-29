package action.service;

import action.sqlhelper.OrderSql;
import cache.ResultPoor;
import common.StringHandler;
import common.Utils;

public class OrderCountRebateService extends BaseService {

	public static String getOrderCountRebateInfo(int begin, int end, String order_no, String nick_name, String phoneNum,
			String rebate_userName, String price_min, String price_max, String countRebateType, String order_source) {

		StringBuffer innerSql = new StringBuffer();
		innerSql.append(OrderSql.orderCountRebate_sql);
		if (order_no != null && order_no != "") {
			innerSql.append(" AND b_order.order_no  LIKE '%").append(order_no).append("%'");
		}
		if (nick_name != null && nick_name != "") {
			innerSql.append(" AND t_user.nick_name LIKE '%").append(nick_name).append("%'");
		}
		if (phoneNum != null && phoneNum != "") {
			innerSql.append(" AND t_user.phone LIKE '%").append(phoneNum).append("%'");
		}
		if (rebate_userName != null && rebate_userName != "") {
			innerSql.append(" AND t_user.nick_name LIKE '%").append(rebate_userName).append("%'");
		}
//		if (price_min != null && price_min != "" && price_max != null && price_max != "") {
//			price_min = price_min.replace("-", "").replace(":", "").replace(" ", "").substring(2, 14);
//			price_max = price_max.replace("-", "").replace(":", "").replace(" ", "").substring(2, 14);
//			innerSql.append("AND b_order.created_date >=").append(price_min).append(" b_order.created_date <=").append(price_max);
//		}
		if (price_min != null && !"".equals(price_min)) {
			String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
			innerSql.append(" and created_date between '").append(created_date1).append("'");
		}
		if (price_max != null && !"".equals(price_max)) {
			String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
			innerSql.append(" and '").append(created_date1).append("'");
		}
		if (countRebateType != null && countRebateType.equals("0") == false && countRebateType != "") {
			innerSql.append(" AND rebatesStyle ='").append(countRebateType).append("'");
		}
		if (order_source != null && order_source.equals("0") == false && order_source != "") {
			innerSql.append(" AND b_order.data_source ='").append(order_source).append("'");
		}
		innerSql.append(" GROUP BY b_order.order_no ");
		innerSql.append(" ORDER BY b_order.created_date desc");
		int sid = BaseService.sendObjectBase(9997, innerSql.toString(), begin, end);
		String res = StringHandler.getRetString(ResultPoor.getResult(sid));
		return res;
	}

	public static String getPurchaseUserInfo(String order_id) {
		int order_idInt = Integer.valueOf(order_id);
		int sid = BaseService.sendObject(78, order_idInt);
		String res = StringHandler.getRetString(ResultPoor.getResult(sid));
		return res;
	}

	public static String getRebateUserInfo(String order_id) {
		int order_idInt = Integer.valueOf(order_id);
		int sid = BaseService.sendObject(79, order_idInt);
		String res = StringHandler.getRetString(ResultPoor.getResult(sid));
		return res;
	}
}
