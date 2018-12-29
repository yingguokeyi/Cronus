package action;

import action.service.BaseService;
import action.service.DictionaryService;
import action.service.DistrictService;
import action.service.GoodsCategoryService;
import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

@WebServlet(name = "District", urlPatterns = "/district")
public class DistrictAction extends BaseServlet{
	
	private static final long serialVersionUID = 1L;


    //获取分类信息
    public static String getCateInfo(String cateId) {
        return GoodsCategoryService.getCateInfo(cateId);
    }


	//添加分类
	public String addCategory(String jsonData,HttpServletRequest req) {
		return GoodsCategoryService.addCategory(jsonData,req);

	}





    //获取一级行政区(省)信息(联动)
    public String getShengList(){
        //sql.append(" order by code");
        String res = DistrictService.getDistrictList("1");
        return res;
    }





    //根据父级编码 获取二级行政区信息(联动)
    public String getDiListByPCode(String pCode){
        String pHead  =  pCode.substring(0,2);
        String res = DistrictService.getDistrictListByPCodeHead(pHead,"2");
        return res;
    }



    //根据父级编码 获取三级行政区信息(联动)
    public String getXianListByPCode(String pCode){
        String pHead  =  pCode.substring(0,4);
        String res = DistrictService.getDistrictListByPCodeHead(pHead,"3");
        return res;
    }






    //根据父级编码 获取二级类目信息(联动)
    public String getSubCateInfoByPCode(String pCateCode){
        GoodsSql goodsSql = new GoodsSql();
        StringBuffer sql = new StringBuffer();

        //TODO
        String pCateCodeHead  =  pCateCode.substring(0,3);
        sql.append(goodsSql.getSub_Cate_List_sql(pCateCodeHead));
        sql.append(" order by sort");
        int sid = BaseService.sendObjectBase(9999,sql.toString());
        return ResultPoor.getResult(sid);
    }




    //根据父级编码 获取三级类目信息(联动)
    public String getMinCateInfoByPCode(String pCateCode) {
        GoodsSql goodsSql = new GoodsSql();
        StringBuffer sql = new StringBuffer();

        //TODO
        String pCateCodeHead = pCateCode.substring(0, 6);
        sql.append(goodsSql.getMin_Cate_List_sql(pCateCodeHead));
        sql.append(" order by sort");
        int sid = BaseService.sendObjectBase(9999, sql.toString());
        return ResultPoor.getResult(sid);
    }


    //根据三级编码 获取商品类型信息(联动)(启用的，未删除的)
    public String getGoodsTypeInfoByPCode(String pCateCode) {
        GoodsSql goodsSql = new GoodsSql();
        StringBuffer sql = new StringBuffer();

        //TODO
        String pCateCodeHead = pCateCode.substring(0, 9);
        sql.append(goodsSql.getGoods_Type_List_sql(pCateCodeHead));
        sql.append(" and is_fixed != 0  and state != 0 order by sort");
        int sid = BaseService.sendObjectBase(9999, sql.toString());
        return ResultPoor.getResult(sid);
    }



    //查询一级类目列表
	public String getTopCateList(String categoryName){
		return GoodsCategoryService.getTopCategoryList(categoryName);
	}

    //查询二级类目列表
    public String getSubCateList(String categoryName,String pCateCode){
//		int pageI = (page==null?1:Integer.valueOf(page));
//		int limitI =(limit==null?10:Integer.valueOf(limit));
        return GoodsCategoryService.getSubCateList(categoryName,pCateCode);
    }


    //查询三级类目列表
    public String getMinCateList(String categoryName,String pCateCode){
        return GoodsCategoryService.getMinCateList(categoryName,pCateCode);
    }

}