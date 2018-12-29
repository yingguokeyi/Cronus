package action;

import action.service.BaseService;
import action.service.DictionaryService;
import action.service.GoodsService;
import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import common.StringHandler;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "Goods", urlPatterns = "/goods")
public class GoodsAction extends BaseServlet{

	private static final long serialVersionUID = 1L;


	//获取商品SPU信息
	public static String getSPUInfo(String spu_id) {
		return GoodsService.getSPUInfo(spu_id);
	}

	//获取准备数据（添加或编辑SPU前）
	public String prepareDataForSpuHandle(){
		return GoodsService.prepareDataForSpuHandle();
	}

	//新增或保存商品SPU
	public String addSPU(String jsonString,HttpServletRequest req){
		String res=GoodsService.addSPUCheckInfo(jsonString);
		if(res.equals("")){
			res=GoodsService.saveGoodsSPU(jsonString,req);
		}
		return res;
	}

	//获取商品SKU信息
	public static String getSKUInfo(String sku_id) {
		return GoodsService.getSKUInfo(sku_id);
	}

	//设置默认
	public static String updateSkuDefault(String status,String spuId,String id,HttpServletRequest req) {
		return GoodsService.updateSkuDefault(status,spuId,id,req);
	}



	//新增或保存商品规格SKU
	public String addSKU(String jsonString,HttpServletRequest req){
		return GoodsService.saveGoodsSKU(jsonString,req);
	}


	//发布商品SPU
	public String publishGoods(String spuId,HttpServletRequest req){
		//TODO
		String status = "1"; //1 发布状态(SPU上架)
		return GoodsService.updateGoodsSPUStatus(status,spuId,req);
	}



	//更新商品的状态（上架、下架、移入移出回收站）
	//0下架  1上架 2在回收站的状态
	public String updateGoodsStatus(String status,String id,HttpServletRequest req) {
		String res = GoodsService.updateGoodsSPUStatus(status,id,req);
		return res;
	}


	//更新商品的状态（上架、下架、移入移出回收站）
	//0下架  1上架 2在回收站的状态
	public String updateGoodsSPUStatus(String status,String id,HttpServletRequest req) {

		//status为1时是上架操作，查询所属的起售SKU的数量来决定是否上架SPU
		if("1".equals(status)){
			StringBuffer sql = new StringBuffer();
			sql.append(GoodsSql.getCountStartSaleSKU(id));
			int resSid = BaseService.sendObjectBase(9999, sql.toString());

			Map<String,String> map = new HashMap<String,String>();
			String cnt = StringHandler.getKeyOfResult(ResultPoor.getResult(resSid),"CNT");
			if(Integer.valueOf(cnt)==0){
				System.out.println("不存在起售SKU，SPU不能上架");
				map.put("CNT","NO");
				String json= JSON.toJSONString(map);
				System.out.println(json.toString());
				return json;
			}else{
				String res = GoodsService.updateGoodsSPUStatus(status,id,req);
				return res;
			}
		}else {
			String result = GoodsService.DownStatusPlanGoods(id);
			System.out.println("  =============b_plan goods down status ======="+result);
			String res ="";
			String spu_res = GoodsService.updateGoodsSPUStatus(status,id,req);
			JSONObject spu_res_json = JSONObject.parseObject(spu_res);
			String spu_res_Str = spu_res_json.get("success") == null ? ""
					: (spu_res_json.get("success").toString());
			if (spu_res_Str.equals("1")) {
				res = GoodsService.updateGoodsSkUStatus(status, id, req);
			}
			return res;
		}
	}


	/**
	 * 批量更新商品上架 cuiwjava 2018-5-11
	 * @param status
	 * @param ids
	 * @param request
	 * @return
	 */
	public String updateSpuAndSubSkuStatus(String status,String ids, HttpServletRequest request){
		StringBuffer sql = new StringBuffer();

		sql.append(GoodsSql.getCountStartSaleSKU(ids));

		int resSid = BaseService.sendObject(9999,sql.toString());

		Map<String,String> map = new HashMap<String,String>();
		String cnt = StringHandler.getKeyOfResult(ResultPoor.getResult(resSid),"CNT");
		if(Integer.valueOf(cnt)==0){
			System.out.println("不存在起售SKU，SPU不能上架");
			map.put("CNT","NO");
			String json= JSON.toJSONString(map);
			System.out.println(json.toString());
			return json;
		}

		return "";
	}

	/**
	 * 商品是否具有SKU商品
	 * @param ids
	 * @return
	 */
	public String checkProductSkuIsExist(String ids){

		return "";
	}

    //批量更新商品的状态（移入移出回收站）
    //0下架  1上架 2在回收站的状态
    public String updateGoodsStatusBatch(String status,String ids,HttpServletRequest req) {
        String res = GoodsService.updateGoodsSPUStatusBatch(status,ids,req);
        return res;
    }


	//更新排序
	public String updateSPUSort(String sort,String id,HttpServletRequest req) {
		String res = GoodsService.updateSPUSort(sort,id,req);
		return res;
	}


	//查询商品
	public String getGoodsList(String spu_name,String goods_source,String spu_code,String cateName,String goodsTypeName,String status,String page,String limit,String online){
//		String stopSale,stopSale,
		int pageI = Integer.valueOf(page);
		int limitI =Integer.valueOf(limit);
		String res=GoodsService.getGoodsList(spu_name,goods_source,spu_code,cateName,goodsTypeName,status,(pageI-1)*limitI,limitI,online);
		return res;
	}

	//添加商品来源
	public String addGoodsSource(String sourceName,String sourceCode,String memo,HttpServletRequest req) {
		int userId = StringHandler.getUserId(req);
		return GoodsService.addGoodsSource(sourceName,sourceCode,memo,userId);
	}

	public String delGoodsSpuAttribute(String id){
		return GoodsService.delGoodsSpuAttribute(id);
	}

	//查询商品来源列表
	public String getGoodsSourceList(String page,String limit){
		int pageI = Integer.valueOf(page);
		int limitI =Integer.valueOf(limit);
		return GoodsService.getGoodsSourceList((pageI-1)*limitI,limitI);
	}

    //获取有效的商品来源列表
    public String getValidGoodsSourceList(){
        return GoodsService.getValidGoodsSourceList();
    }
	//获取正常的全部的商品来源列表
	public String getAllNormalGoodsSourceList(){
		return GoodsService.getAllNormalGoodsSourceList();
	}


	//更新商品来源的状态（启用、禁用）
	public String updateGoodsSourceStatus(String status,String id) {
    		String res = DictionaryService.updateFixed(status,id);
		return res;
	}

	//添加品牌
	public String addBrand(String jsonString) {
		return GoodsService.addBrand(jsonString);
	}

	public String getBrandInfo(String brandId){
		return GoodsService.getBrandInfo(brandId);
	}

	//查询品牌列表
	public String getBrandList(String searchName,String page,String limit){
		int pageI = (page==null?1:Integer.valueOf(page));
		int limitI =(limit==null?10:Integer.valueOf(limit));
		return GoodsService.getBrandList(searchName,(pageI-1)*limitI,limitI);
	}

	//更新商品品牌的状态（启用、禁用）
	public String updateBrandStatus(String status,String id) {
		String res = GoodsService.updateBrandStatus(status,id);
		return res;
	}

	//添加供应商
	public String addSupplier(String jsonData) {
		return GoodsService.addSupplier(jsonData);
	}
	public String deteleSupplier(String supplierId){
	    return GoodsService.deleteSupplier(supplierId);
    }
	public String getSupplierInfo(String supplierId){
		return GoodsService.getSupplierInfo(supplierId);
	}

	//查询供应商列表
	public String getSupplierList(String searchName,String page,String limit){
		int pageI = (page==null?1:Integer.valueOf(page));
		int limitI =(limit==null?10:Integer.valueOf(limit));
		return GoodsService.getSupplierList(searchName,(pageI-1)*limitI,limitI);
	}

	//查询单位数量列表
	public String getQuantityUnitList(String searchName,String page,String limit){
		int pageI = (page==null?1:Integer.valueOf(page));
		int limitI =(limit==null?10:Integer.valueOf(limit));
		return GoodsService.getQuantityUnitList(searchName,(pageI-1)*limitI,limitI);
	}

    //添加数量单位
    public String addQuantityUnit(String unitName,String memo,String unitId,HttpServletRequest req) {
        int userId = StringHandler.getUserId(req);
        return GoodsService.addQuantityUnit(unitName,memo,unitId,userId);
    }
    //删除数量单位
    public String deteleQuantityUnit(String unitId){
        return GoodsService.deteleQuantityUnit(unitId);
    }
	public String getQuantityUnit(String unitId){
		return GoodsService.getQuantityUnit(unitId);
	}

	//更新数量单位的状态（常用、少用）
	public String updateQuantityUnitStatus(String status,String id) {
		String res = DictionaryService.updateFixed(status,id);
		return res;
	}
	//更新数量单位的排序
	public static String updateQuantityUnitSort(String sort,String id,HttpServletRequest req) {
		String res = GoodsService.updateQuantityUnitSort(sort,id,req);
		return res;
	}



	/**
	 * 获取分销列表 by luyou
	 * @return
	 */
	public String getDistributionList(String type){
		String res = GoodsService.getDistributionList(type);
		return res;
	}

	/**
	 * 获取全部有效的分销列表 by luyou
	 * @return
	 */
	public String getAllValidDistributionList(){
		String res  = GoodsService.getAllValidDistributionList();
		return res;
	}



	/**
	 * 商品列表_规格管理_列表信息
	 * 2018-03-13 逍遥子
	 * @param goodsSPUId
	 * @param page
	 * @param limit
	 * @return
	 */
	public String getGoodsSKUList(String goodsSPUId,String page,String limit){
		int pageI = Integer.valueOf(page);
		int limitI =Integer.valueOf(limit);
		String res=GoodsService.getGoodsSKUList((pageI-1)*limitI,limitI,goodsSPUId);
		return res;
	}

	/**
	 * 商品列表_规格管理_起/停售商品_根据SPU获取SKU信息
	 * 2018-03-13 逍遥子
	 * @param id
	 * @param presell_newEndtime
	 * @param style
	 * @return
	 */
	public String upSKUGoodsStatus(String id, String presell_newEndtime, String style,String goodsSPUId,HttpServletRequest req) throws Exception{
//		String sql="";
//		if(!"".equals(presell_newEndtime)){
//			sql=",sku.presell_endtime=? WHERE sku.id=?";
//		}else{
//			sql=" WHERE sku.id=?";
//		}
		HttpSession session=req.getSession();
		String userId=String.valueOf(session.getAttribute("userId"));
		String res  = GoodsService.upSKUGoodsStatus(userId,id,presell_newEndtime,style,goodsSPUId);
		return res;
	}

	/**
	 * 商品列表_规格管理_删除规格信息
	 * 2018-03-13 逍遥子
	 * @param id
	 * @return
	 */
	public String delGoodsSKU(String id, HttpServletRequest req,String spuId){
		HttpSession session=req.getSession();
		System.out.println(session.getAttribute("userId"));
		String userId=String.valueOf(session.getAttribute("userId"));
		String res  = GoodsService.delGoodsSKU(id,userId,spuId);
		return res;
	}

	public String getGoodsSKUAttributeList(String id,String page,String limit){
		int pageI = Integer.valueOf(page);
		int limitI =Integer.valueOf(limit);
		String res=GoodsService.getGoodsSKUAttributeList((pageI-1)*limitI,pageI*limitI,id);
		return res;
	}

	public String checkSPUNameISNOExist(String spu_name){
		String re=GoodsService.checkSPUNameISNOExist(spu_name);
		return re;
	}

	/**
	 * 保存掌大赚新增商品
	 * @param spuName
	 * @param request
	 * @return
	 */
	public String addZhangDZGoods(String spuName,String spuId,String bounty,HttpServletRequest request){
		HttpSession session=request.getSession();
		int userId=Integer.valueOf(session.getAttribute("userId").toString());
		String res = GoodsService.saveZhangDZGoods(spuName,spuId,bounty,userId);
		return res;
	}

	/**
	 * 查询掌大赚商品列表
	 * @param spuName
	 * @param state
	 * @param price_min
	 * @param price_max
	 * @return
	 */
	public String getZhangDZGoods(String spuName,String state,String price_min,String price_max,String page, String limit){
		int pageI = Integer.valueOf(page);
		int limitI = Integer.valueOf(limit);
		String res = GoodsService.getZhangDZGoodsList(spuName, state, price_min, price_max, (pageI - 1) * limitI, limitI);
		return res;
	}

	public String updateGoodsState(String id,String state){
		String res = GoodsService.updateGoods(id, state);
		return res;
	}

    /**
     * 获取掌小龙的商品列表
     * @return
     */
    public static String getZhangDZGood(){
        String rs = GoodsService.getZhangDZGoodsList();
        return rs;
    }

	/**
	 * 查看当前添加SKU信息时候，商品来源是否是掌小龙
	 * @param spu_id
	 * @return
	 */
	public String checkIsBounty(String spu_id){
		String res = GoodsService.checkIsBounty(spu_id);
		return StringHandler.getRetString(res);
	}

}