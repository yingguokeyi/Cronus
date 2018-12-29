package action;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import action.service.PlanService;
import common.BaseCache;
import common.StringHandler;
import servlet.BaseServlet;

/**
 * @author cuiw
 */
@WebServlet(name = "Plan", urlPatterns = "/plan")
public class PlanAction extends BaseServlet {

    private static final long serialVersionUID = 1L;


    public String getGoodsPlanInfo(String spuId) {
        String res = PlanService.getGoodsPlanInfo(spuId);
        return res;
    }

    /**
     * 删除
     * @param ids
     * @return
     */
    public String deleleGoodsPlanInfo(String ids) {
        String res = PlanService.deleleGoodsPlanInfo(ids);
        return res;
    }

    /**
     * 将SPU添加到首页推荐（新增或修改）
     * @param jsonString
     * @param req
     * @return
     */
    public String saveGoodsPlan(String jsonString, HttpServletRequest req) {
        String res = PlanService.saveGoodsPlan(jsonString, req);
        return res;
    }

    /**
     * 更新排序
     * @param sort
     * @param id
     * @param req
     * @return
     */
    public String updatePlanSort(String sort, String id, HttpServletRequest req) {
        String res = PlanService.updatePlanSort(sort, id, req);
        return res;
    }

    public String getPlanList(String title, String plan_group, String promote, String category, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getPlanList(title, plan_group, promote, category, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 查看每个栏目中添加的商品信息
     *
     * @param title
     * @param plan_group
     * @param page
     * @param limit
     * @return
     */
    public String getColumnProductList(String productStatus,String title, String plan_group,String seckillSource, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getColumnProductList(productStatus,title, plan_group,seckillSource, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 查询所有栏目列表信息
     *
     * @param spu_name
     * @param goods_source
     * @param spu_code
     * @param cateName
     * @param goodsTypeName
     * @param status
     * @param page
     * @param limit
     * @param online
     * @return
     */
    public String getExcGoodsList(String spu_name, String goods_source, String spu_code, String cateName, String goodsTypeName, String status, String page, String limit, String online) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getExcGoodsList(spu_name, goods_source, spu_code, cateName, goodsTypeName, status, (pageI - 1) * limitI, limitI, online);
        return res;
    }


    /**
     * 查询出所有快递物流公司
     * 此方法不宜写此处 以后迁移
     *
     * @param company_name
     * @param page
     * @param limit
     * @return
     */
    public String getLogisticCompanyList(String company_name, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = PlanService.getLogisticCompanyList(company_name, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 查看一个栏目列表信息
     *
     * @param cid
     * @return
     */
    public String selectPlanProductOne(int cid) {
        String res = PlanService.selectPlanProductOne(cid);
        return res;
    }

    /**
     * 查看栏目商品单个详细信息
     *
     * @param spu_id
     * @return
     */
    public String getColumnProductOneInfo(String spu_id) {
        String res = PlanService.getColumnProductOneInfo(spu_id);
        return res;
    }

    /**
     * 修改栏目上下架商品状态
     *
     * @param status
     * @param spu_key
     * @return
     */
    public String productStatusChange(String status, String spu_key) {
        String res = PlanService.productStatusChange(status, spu_key);
        return res;
    }

    /**
     * 秒杀栏目上架商品
     * @param begintime
     * @param endtime
     * @param status
     * @param id
     * @return
     */
    public String productStatusUp(String begintime,String endtime,String status,String id){
        String res=  PlanService.productStatusUp(begintime, endtime, status, id);
        return res;
    }

    /**
     * 删除添加在栏目中的商品
     *
     * @param id
     * @param plan_group
     * @return
     */
    public String deleColumnProduct(String plan_group, String id) {
        String res = PlanService.deleColumnProduct(plan_group, id);
        return res;
    }

    /**
     * 查看所有秒杀时间段
     *
     * @return
     */
    public String selectSeckillTimeList() {
        String res = PlanService.selectSeckillTimeList();
        return res;
    }

    /**
     * 查询启用的秒杀状态
     * @return
     */
    public String selectSeckillTimeList2() {
        String res = PlanService.selectSeckillTimeList2();
        return res;
    }

    /**
     * 变更秒杀时段的使用 启用 禁用
     *
     * @param id
     * @param is_default
     * @return
     */
    public String changeSeckillUse(String id, String is_default) {
        String res = PlanService.changeSeckillUse(id, is_default);
        return res;
    }

    /**
     * 刪除秒杀时间段
     *
     * @param id
     * @return
     */
    public String delSeckillUse(String id) {
        String res = PlanService.delSeckillUse(id);
        return res;
    }

    /**
     * 编辑秒杀时段处理
     *
     * @param id
     * @return
     */
    public String getSecKillInfo(String id) {
        String res = PlanService.getSecKillInfo(id);
        return res;
    }

    /**
     * 更新秒杀时段管理
     *
     * @param secKillName
     * @param secStartTime
     * @param secEndTime
     * @param id
     * @return
     */
    public String updateSeckillTimeSetting(String secKillName, String secStartTime, String secEndTime, String id) {
        String res = PlanService.updateSeckillTimeSetting(secKillName, secStartTime, secEndTime, id);
        return res;
    }

    /**
     * 新增秒杀时段
     *
     * @param secKillName
     * @param secStartTime
     * @param secEndTime
     * @return
     */
    public String insertSeckillTimeSetting(String secKillName, String secStartTime, String secEndTime) {
        String res = PlanService.insertSeckillTimeSetting(secKillName, secStartTime, secEndTime);
        return res;
    }

    /**
     * 保存秒杀
     * @param jsonString
     * @param req
     * @return
     */
    public String saveGoodsForSeckillColumn(String jsonString, HttpServletRequest req){
        String res = PlanService.saveGoodsForSeckillColumn(jsonString, req);
        return res;
    }

    /**
     * 栏目商品信息保存
     * @param original_price
     * @param sort
     * @param bstarttime
     * @param bendtime
     * @param spuId
     * @return
     */
    public String updateColumnGoods(String original_price,String sort,String bstarttime,String bendtime,String seckillId,String spuId){
        String res = PlanService.updateColumnGoods(original_price, sort, bstarttime, bendtime,seckillId, spuId);
        return res;
    }

    /**
     *
     * @param seckillId
     * @return
     */
    public String isExistSeckillProduct(String seckillId){
        String res =  PlanService.isExistSeckillProduct(seckillId);
        return res;
    }

    public String updateSKUGoodsSeckillPrice(String seckillPrice,String skuId){
        String res =  PlanService.updateSKUGoodsSeckillPrice(seckillPrice, skuId);
        return StringHandler.getRetString(res);
    }

    /**
     * 启用活禁用SKU秒杀商品价格
     * @param skuId
     * @param status
     * @return
     */
    public String upOrDownSkuSekillPrice(String skuId,String status){
        String res=  PlanService.upOrDownSkuSekillPrice(skuId, status);
        return StringHandler.getRetString(res);
    }

    /**
     * 验证上架商品中是否含有已经启用的秒杀价格SKU商品
     * @param spuKey
     * @return
     */
    public String IsCheckSeckillPriceUp(String spuKey){
        String res = PlanService.IsCheckSeckillPriceUp(spuKey);
        return StringHandler.getRetString(res);
    }

}
