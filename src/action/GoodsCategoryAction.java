package action;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import action.service.BaseService;
import action.service.DictionaryService;
import action.service.GoodsCategoryService;
import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import servlet.BaseServlet;

@WebServlet(name = "GoodsCategory", urlPatterns = "/goodsCategory")
public class GoodsCategoryAction extends BaseServlet {

	private static final long serialVersionUID = 1L;

	// 获取分类信息
	public static String getCateInfo(String cateId) {
		return GoodsCategoryService.getCateInfo(cateId);
	}

	// 添加分类
	public String addCategory(String jsonData, HttpServletRequest req) {
		return GoodsCategoryService.addCategory(jsonData, req);

	}

	// 逻辑删除分类
	public String deteleCate(String ids) {

		return GoodsCategoryService.deleteCategory(ids);
	}

	// 更新排序
	public String updateSort(String sort, String id) {
		String res = DictionaryService.updateSort(sort, id);
		return res;
	}

	// 获取一级类目信息(联动)
	public String getTopCateInfo() {
		StringBuffer sql = new StringBuffer();
		sql.append(GoodsSql.getFirstCategoryList_sql);
		sql.append(" order by sort");

		int sid = BaseService.sendObjectBase(9999, sql.toString());
		return ResultPoor.getResult(sid);
	}

	// 根据父级编码 获取二级类目信息(联动)
	public String getSubCateInfoByPCode(String pCateCode) {
		StringBuffer sql = new StringBuffer();

		// TODO
		String pCateCodeHead = pCateCode.substring(0, 3);
		sql.append(GoodsSql.getSub_Cate_List_sql(pCateCodeHead));
		sql.append(" order by sort");
		int sid = BaseService.sendObjectBase(9999, sql.toString());
		return ResultPoor.getResult(sid);
	}

	// 根据父级编码 获取三级类目信息(联动)
	public String getMinCateInfoByPCode(String pCateCode) {
		StringBuffer sql = new StringBuffer();

		// TODO
		String pCateCodeHead = pCateCode.substring(0, 6);
		sql.append(GoodsSql.getMin_Cate_List_sql(pCateCodeHead));
		sql.append(" order by sort");
		int sid = BaseService.sendObjectBase(9999, sql.toString());
		return ResultPoor.getResult(sid);
	}

	// 根据三级编码 获取商品类型信息(联动)(启用的，未删除的)
	public String getGoodsTypeInfoByPCode(String pCateCode) {
		StringBuffer sql = new StringBuffer();

		// TODO
		String pCateCodeHead = pCateCode.substring(0, 9);
		sql.append(GoodsSql.getGoods_Type_List_sql(pCateCodeHead));
		sql.append(" and is_fixed != 0  and state != 0 order by sort");
		int sid = BaseService.sendObjectBase(9999, sql.toString());
		return ResultPoor.getResult(sid);
	}

	// 查询一级类目列表
	public String getTopCateList(String categoryName) {
		return GoodsCategoryService.getTopCategoryList(categoryName);
	}

	// 查询二级类目列表
	public String getSubCateList(String categoryName, String pCateCode) {
		// int pageI = (page==null?1:Integer.valueOf(page));
		// int limitI =(limit==null?10:Integer.valueOf(limit));
		return GoodsCategoryService.getSubCateList(categoryName, pCateCode);
	}

	// 查询三级类目列表
	public String getMinCateList(String categoryName, String pCateCode) {
		return GoodsCategoryService.getMinCateList(categoryName, pCateCode);
	}

}