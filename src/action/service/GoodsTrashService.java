package action.service;

import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import common.StringHandler;

public class GoodsTrashService extends BaseService {

	public static String GoodsTrash(String spu_name,  String supplier_name , String brand_name ,String dict_data_name,String spu_code, int begin,int end){

		StringBuffer innerSql = new StringBuffer();
		innerSql.append(GoodsSql.getGoodsList());
		innerSql.append(" WHERE P.status=2 ");//status=2 为处于回收站的状态
		StringBuffer sql  = new StringBuffer ("SELECT * FROM (" + innerSql.toString());
		sql.append(") T ");
		//查询条件
		sql.append(" WHERE 1=1 ");
		if(spu_name !=null && !spu_name.equals("")){
			sql.append(" AND spu_name LIKE '%").append(spu_name).append("%'");
		}
		if(spu_code !=null && !spu_code.equals("")){
			sql.append(" AND spu_code LIKE '%").append(spu_code).append("%'");
		}

		if(supplier_name!=null && !supplier_name.equals("")){
			sql.append(" and supplierName LIKE '%").append(supplier_name).append("%'");
		} if(brand_name!=null && !"".equals(brand_name)){
			sql.append(" and brandName LIKE '%").append(brand_name).append("%'");
		} if(dict_data_name!=null&& !"".equals(dict_data_name)){
			sql.append(" and cateName LIKE '%").append(dict_data_name).append("%'");
		}

		sql.append(" ORDER BY sort,id");

		int sid=BaseService.sendObjectBase(9997,sql.toString(),begin,end);
		System.out.println(sid);
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}

	public static String DeleteTrash(String ids){
		String[] id = ids.split(",");
		int sid = 0;
		for (String id1 : id) {
			sid = sendObjectCreate(85, id1);
		}
		String result = ResultPoor.getResult(sid);
		return result;
	}

	public static String SKUGoodsTrash(int begin,int end,String id){
		int sid = sendObject(86,id,begin,end);
		String rsTrash = ResultPoor.getResult(sid);
		String rsSkuTrashJson= StringHandler.getRetString(rsTrash);
		return rsSkuTrashJson;

	}

	public static String restore(String ids){
		String[] id = ids.split(",");
		int sid = 0;
		for (String id1 : id) {
			sid = sendObjectCreate(87, id1);
		}
		String result = ResultPoor.getResult(sid);
		return result;
	}

}