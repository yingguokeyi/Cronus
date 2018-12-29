package action.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import common.StringHandler;

public class GoodsCategoryService extends BaseService {

	//获取分类信息
	public static String getCateInfo(String cateId) {
		StringBuffer sql = new StringBuffer();
		sql.append(GoodsSql.getCateInfo(cateId));

		int sid = BaseService.sendObjectBase(9999, sql.toString());
		return StringHandler.getRetString(ResultPoor.getResult(sid));

	}



	//添加分类
	public static String addCategory(String jsonString,HttpServletRequest req) {
		GoodsSql goodsSql = new GoodsSql();
		int userId = StringHandler.getUserId(req);

		JSONObject jsonObject = JSONObject.parseObject(jsonString);
		String categoryName = jsonObject.get("categoryName").toString();
		String optType = jsonObject.get("optType").toString();
		String pCateCode = jsonObject.get("pCateCode").toString();

		int sort = (jsonObject.get("sort")==null? 0:(Integer.valueOf(jsonObject.get("sort").toString())));
		String memo = (jsonObject.get("memo")==null? "":(jsonObject.get("memo").toString()));

		int img_id = 0;
		if(jsonObject.get("imgId")!=null){
			img_id = Integer.valueOf(jsonObject.get("imgId").toString());
		}


		int cateId = 0;
		if(jsonObject.get("cateId")!=null && !"null".equals(jsonObject.get("cateId"))){
			cateId = Integer.valueOf(jsonObject.get("cateId").toString());
		}

		int cateSid =0;
		if(cateId == 0 ){

			String categoryCode = "";
			if("addTopCate".equals(optType)){//添加一级分类

				//查询一级类目最大的编码
				int sid = BaseService.sendObjectBase(9999, GoodsSql.getMax_Top_Code_sql);
				String inString = ResultPoor.getResult(sid);
				int maxTopCode = Integer.valueOf(StringHandler.getKeyOfResult(inString,"maxcode"));
				categoryCode = StringHandler.incrementAndGetCategoryCode(maxTopCode);

				if("".equals(memo)){ memo = "一级类目";}
			}else if("addSubCate".equals(optType)){ //添加二级分类
				String pCateCodeHead  =  pCateCode.substring(0,3);

				//查询所属的二级类目最大的编码
				int sid = BaseService.sendObjectBase(9999, goodsSql.getMax_Sub_Code_sql(pCateCodeHead));
				String inString = ResultPoor.getResult(sid);
				int maxSubCode = Integer.valueOf(StringHandler.getKeyOfResult(inString,"maxcode"));
				categoryCode = StringHandler.incrementAndGetCategoryCode(maxSubCode);

				if("".equals(memo)){ memo = "二级类目";}
			}else if("addMinCate".equals(optType)){ //添加三级分类
				String pCateCodeHead  =  pCateCode.substring(0,6);

				//查询所属的三级类目最大的编码
				int sid = BaseService.sendObjectBase(9999, goodsSql.getMax_Min_Code_sql(pCateCodeHead));
				String inString = ResultPoor.getResult(sid);
				int maxSubCode = Integer.valueOf(StringHandler.getKeyOfResult(inString,"maxcode"));
				categoryCode = StringHandler.incrementAndGetCategoryCode(maxSubCode);

				if("".equals(memo)){ memo = "三级类目";}
			}


			cateSid = sendObjectCreate(22, 1, categoryName,categoryCode,1,memo,userId,1,sort,img_id); //添加类目
		}else {
			cateSid = sendObjectCreate(38, categoryName,memo,userId,sort,img_id,cateId); //更新类目
		}

		String result = ResultPoor.getResult(cateSid);
		return result;
	}


	//逻辑删除分类
	public static String deleteCategory(String ids) {
		GoodsSql goodsSql = new GoodsSql();
		Map<String,String> map = new HashMap<String,String>();


	    String[] idStr  = ids.split(",");
	    map.put("ALLCNT",String.valueOf(idStr.length));
	    int deleteInt = 0;

        for (int i = 0; i < idStr.length; i++) {
			//查询单个分类信息
			String cateInfo = ResultPoor.getResult(sendObject(20,idStr[i]));
			String CateCode = StringHandler.getKeyOfResult(cateInfo,"dict_data_value");
			String pCateCodeHead  =  "";
			String pCateCodeTail  =  CateCode.substring(3,9);



			if ("000000".equals(pCateCodeTail)) { //一级
				pCateCodeHead  =  CateCode.substring(0,3);
			} else if (pCateCodeTail.indexOf("000") > 0) {//二级
				pCateCodeHead  =  CateCode.substring(0,6);
			} else {
				pCateCodeHead  =  CateCode.substring(0,9);//三级
			}

			//先检查分类下有无商品，有则不能删除分类
			StringBuffer sqlTemp = new StringBuffer();
			sqlTemp.append(GoodsSql.getCountSPUByCateCodeHead(pCateCodeHead));
			int countSid = BaseService.sendObjectBase(9999, sqlTemp.toString());

            //TODO
//            String sql =  " WHERE goods_type_id LIKE ? ";
//			String sqlLike = " '" + pCateCodeHead +"%'";
//            int countSid = sendObjectBase(39,sql,sqlLike);
			String cnt = StringHandler.getKeyOfResult(ResultPoor.getResult(countSid),"CNT");

			boolean allowDelete = false;
			if(Integer.valueOf(cnt)==0){
				allowDelete = true; //无商品SPU,允许删除
				System.out.println("无商品SPU,允许删除");
			}else{
				System.out.println("有商品SPU,不允许删除");
			}


			//根据code去删除子类
			if(allowDelete){
				if ("000000".equals(pCateCodeTail)) { //删除一级分类及其子类 及其孙类
					pCateCodeHead  =  CateCode.substring(0,3);
					int allCateInt = BaseService.sendObjectBase(9999, goodsSql.get_Cate_List_sql((pCateCodeHead)));
					List<String> list = StringHandler.getListOfResultByKey(ResultPoor.getResult(allCateInt), "id");
					for (int j = 0; j < list.size(); j++) {
						DictionaryService.updateState("0", list.get(j).toString());
					}
					deleteInt++;
				} else if (pCateCodeTail.indexOf("000") > 0) {//删除二级分类及其子类
					pCateCodeHead  =  CateCode.substring(0,6);
					int allCateInt = BaseService.sendObjectBase(9999, goodsSql.get_Cate_List_sql((pCateCodeHead)));
					List<String> list = StringHandler.getListOfResultByKey(ResultPoor.getResult(allCateInt), "id");
					for (int j = 0; j < list.size(); j++) {
						DictionaryService.updateState("0", list.get(j).toString());
					}
					deleteInt++;
				} else {
					DictionaryService.updateState("0",idStr[i]);
					deleteInt++;
				}
			}

        }

		map.put("DELCNT",String.valueOf(deleteInt));//删除的分类数量
		String json= JSON.toJSONString(map);
		return json;
	}








	//查询一级类目列表
	public static String getTopCategoryList(String categoryName) {
		StringBuffer sql = new StringBuffer();
		sql.append(GoodsSql.getFirstCategoryList_sql);
		//查询条件
		if(categoryName !=null && !categoryName.equals("")){
			sql.append(" and  dict_data_name LIKE '%").append(categoryName).append("%'");
		}
		sql.append(" order by sort");

		//sql.append(" LIMIT ").append(begin).append(",").append(end);//分页
		int sid = BaseService.sendObjectBase(9999,sql.toString());
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}



	//查询二级类目列表
	public static String getSubCateList(String categoryName,String pCateCode) {
		StringBuffer sql = new StringBuffer();

		//TODO
		String pCateCodeHead  =  pCateCode.substring(0,3);
		sql.append(GoodsSql.getSub_Cate_List_sql(pCateCodeHead));

		//查询条件
		if(categoryName !=null && !categoryName.equals("")){
			sql.append(" and  dict_data_name LIKE '%").append(categoryName).append("%'");
		}
		sql.append(" order by sort");

		//sql.append(" LIMIT ").append(begin).append(",").append(end);//分页
		int sid = BaseService.sendObjectBase(9999,sql.toString());
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}





	//查询三级类目列表
	public static String getMinCateList(String categoryName,String pCateCode) {
		StringBuffer sql = new StringBuffer();

		//TODO
		String pCateCodeHead  =  pCateCode.substring(0,6);
		sql.append(GoodsSql.getMin_Cate_List_sql(pCateCodeHead));

		//查询条件
		if(categoryName !=null && !categoryName.equals("")){
			sql.append(" and  dict_data_name LIKE '%").append(categoryName).append("%'");
		}
		sql.append(" order by sort");

		//sql.append(" LIMIT ").append(begin).append(",").append(end);//分页
		int sid = BaseService.sendObjectBase(9999,sql.toString());
		return StringHandler.getRetString(ResultPoor.getResult(sid));
	}


}