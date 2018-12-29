package action.service;

import action.sqlhelper.MemberSql;
import cache.ResultPoor;
import common.StringHandler;

public class CertificationService extends BaseService {
	/**
	 * 会员审核列表 2018/3/15 木易
	 * 
	 * @return
	 */
	public static String Selectpending(int begin, int end, String phone, String beginDate, String endDate,
			String nick_name, String audit_status) {
		StringBuffer sql = new StringBuffer();
		sql.append(MemberSql.certificationListPage_sql);
		if (phone != null && !phone.equals("")) {
			sql.append(" and phone like '%").append(phone).append("%'");
		}
		if (beginDate != null && !beginDate.equals("")) {
			int bDate = Integer.parseInt(beginDate.replace("-", ""));

			sql.append(" and registration_time >=" + bDate + "");
		}
		if (endDate != null && !endDate.equals("")) {
			int eDate = Integer.parseInt(endDate.replace("-", ""));
			sql.append(" and registration_time <=" + eDate + "");
		}
		if (nick_name != null && !nick_name.equals("")) {
			sql.append(" and nick_name like '%").append(nick_name).append("%'");
		}
		if (audit_status != null && !audit_status.equals("")) {
			if (Integer.parseInt(audit_status) == 0) {
				sql.append(" and audit_status='0'");
			}
			if (Integer.parseInt(audit_status) == 1) {
				sql.append(" and audit_status = 1");
			}
			if (Integer.parseInt(audit_status) == 2) {
				sql.append(" and audit_status = -1");
			}
		}
		sql.append(" order by registration_time desc ");
		int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
		System.out.println(sid);
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	/**
	 * 会员审核 2018/3/16 木易
	 * 
	 * @return
	 */
	public static String Passmember(String ids) {
		String[] id = ids.split(",");
		int sid = 0;
		for (String id1 : id) {
			sid = sendObjectCreate(88, id1);
		}
		String result = ResultPoor.getResult(sid);
		return result;
	}

	/**
	 * 会员审核（拒绝） 2018/3/16 木易
	 * 
	 * @return
	 */
	public static String Rejectmember(String ids) {
		String[] id = ids.split(",");
		int sid = 0;
		for (String id1 : id) {
			sid = sendObjectCreate(89, id1);
		}
		String result = ResultPoor.getResult(sid);
		return result;
	}

}
