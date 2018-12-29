package action.service;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSONObject;

import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import common.BaseCache;
import common.StringHandler;
import common.Utils;

/**
 * @author cuiw
 */
public class PlanService extends BaseService {

    /**
     * 商品加入到首页推荐
     * @param jsonData
     * @param req
     * @return
     */
    public static String saveGoodsPlan(String jsonData, HttpServletRequest req) {

        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        int spuId = (jsonObject.get("ad_spu_id") == null ? 0 : (Integer.valueOf(jsonObject.get("ad_spu_id").toString())));

        //获取SPU商品中show图的第一个id值
        String imgId = GoodsService.getSPUFirstShowImgId(String.valueOf(spuId));

        String title = jsonObject.get("ad_title").toString();
        String planGroup = jsonObject.get("plan_group").toString();
        String memo = jsonObject.get("ad_memo").toString();
        String promote = jsonObject.get("ad_promote").toString();
        int sort = (jsonObject.get("ad_sort") == null || "".equals(jsonObject.get("ad_sort"))) ? 0 : (Integer.valueOf(jsonObject.get("ad_sort").toString()));
        String uri = "spuId=" + spuId;
        String category = "1";

        int cid = sendObject(411, uri);
        String checkResult = ResultPoor.getResult(cid);
        // 防止重复添加推荐商品
        int num = (int) PlanService.getFieldValue(checkResult, "num", Integer.class);
        String retResult = "";
        if (num == 1) {
            // 已经重复 不能添加
            return "{ success:0 }";
        } else {
            int adId = (jsonObject.get("ad_id") == null || "".equals(jsonObject.get("ad_id"))) ? 0 : (Integer.valueOf(jsonObject.get("ad_id").toString()));
            int sid = 0;
            if (adId == 0) {
                sid = sendObjectCreate(304, imgId, category, uri, sort, planGroup, memo, promote, title, spuId);
            } else {
                //编辑
                sid = sendObjectCreate(306, imgId, category, uri, sort, planGroup, memo, promote, title, adId, spuId);
            }

            retResult = ResultPoor.getResult(sid);
        }

        return retResult;
    }


    public static String getGoodsPlanInfo(String spuId) {
        StringBuffer sql = new StringBuffer();
        String uri = "spuId=" + spuId;
        sql.append(GoodsSql.getGoodsPlanInfo(uri));
        int sid = BaseService.sendObjectBase(9999, sql.toString());
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    public static String deleleGoodsPlanInfo(String ids) {

        String[] idArray = ids.split(",");
        int sid = 0;
        for (String planId : idArray) {
            sid = sendObjectCreate(307, planId);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }


    /**
     * 更新首页推荐排序
     * @param sort
     * @param id
     * @param req
     * @return
     */
    public static String updatePlanSort(String sort, String id, HttpServletRequest req) {
        int sid = sendObjectCreate(308, Integer.parseInt(sort), Integer.parseInt(id));
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     * @param spu_name
     * @param goods_source
     * @param spu_code
     * @param cateName
     * @param goodsTypeName
     * @param status
     * @param begin
     * @param end
     * @param online
     * @return
     */
    public static String getExcGoodsList(String spu_name, String goods_source, String spu_code, String cateName, String goodsTypeName, String status, int begin, int end, String online) {
        StringBuffer sql = new StringBuffer();

        //查询条件
        if (spu_name != null && !"".equals(spu_name)) {
            sql.append(" AND spu_name LIKE '%").append(spu_name).append("%'");
        }
        if (goods_source != null && !"".equals(goods_source)) {
            sql.append(" AND source_code = '").append(goods_source).append("'");
        }
        if (spu_code != null && !"".equals(spu_code)) {
            sql.append(" AND spu_code LIKE '%").append(spu_code).append("%'");
        }
        if (goodsTypeName != null && !"".equals(goodsTypeName)) {
            sql.append(" AND goodsTypeName LIKE '%").append(goodsTypeName).append("%'");
        }
        if (cateName != null && !"".equals(cateName)) {
            sql.append(" AND cateName LIKE '%").append(cateName).append("%'");
        }
        if (status != null && !"".equals(status)) {
            sql.append(" AND T.status = ").append(status);
        }

        sql.append(" AND NOT EXISTS ( SELECT spu_key FROM b_plan WHERE spu_key = T.id)");
        int sid;
        if (null != online) {
            sql.append(" AND T.status = 1 ORDER BY sort,edit_time desc");
            sid = sendObjectBase(503, sql.toString(), begin, end);
        } else {
            sql.append(" ORDER BY sort,edit_time desc");
            sid = sendObjectBase(503, sql.toString(), begin, end);
        }
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    public static String getPlanList(String title, String plan_group, String promote, String category, int begin, int end) {

        StringBuffer sql = new StringBuffer();
        sql.append(GoodsSql.getPlanList());

        //查询条件
        sql.append(" WHERE 1=1 ");
        if (title != null && !"".equals(title)) {
            sql.append(" AND P.title LIKE '%").append(title).append("%'");
        }

        if (plan_group != null && !"".equals(plan_group)) {
            sql.append(" and P.plan_group = '").append(plan_group).append("'");
        }
        if (promote != null && !"".equals(promote)) {
            sql.append(" and P.promote LIKE '%").append(promote).append("%'");
        }
        if (category != null && !"".equals(category)) {
            sql.append(" and P.category = '").append(category).append("'");
        }

        sql.append(" ORDER BY plan_group,sort,id");

        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        System.out.println(sid);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }

    /**
     * 查看每个栏目中添加的商品信息
     *
     * @param title
     * @param plan_group
     * @param begin
     * @param end
     * @return
     */
    public static String getColumnProductList(String productStatus,String title, String plan_group,String seckillSource, int begin, int end) {

        StringBuffer sql = new StringBuffer();

        //查询条件

        if (title != null && !"".equals(title)) {
            sql.append(" AND b.title LIKE '%").append(title).append("%'");
        }

        if (plan_group != null && !"".equals(plan_group)) {
            sql.append(" and b.plan_group = '").append(plan_group).append("'");
        }

        if (seckillSource != null && !"".equals(seckillSource)) {
            sql.append(" and b.seckillId = '").append(seckillSource).append("'");
        }
        if (productStatus != null && !"".equals(productStatus)) {
            sql.append(" AND b.product_status = '").append(productStatus).append("'");
        }

        sql.append(" ORDER BY b.sort ASC ");

        int sid = BaseService.sendObjectBase(431, sql.toString(), begin, end);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }

    /**
     * 查看一个栏目列表信息
     *
     * @param cid
     * @return
     */
    public static String selectPlanProductOne(int cid) {
        int sid = sendObject(421, cid);
        String res = ResultPoor.getResult(sid);
        return res;
    }

    /**
     * @param companyName
     * @param begin
     * @param end
     * @return
     */
    public static String getLogisticCompanyList(String companyName, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        //查询条件
        sql.append(" WHERE 1=1 ");
        if (companyName != null && !"".equals(companyName)) {
            sql.append(" AND company_name LIKE '%").append(companyName).append("%'");
        }
        sql.append(" ORDER BY create_date desc");

        int sid = BaseService.sendObjectBase(420, sql.toString(), begin, end);
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);

    }

    /**
     * 查看栏目中商品信息
     *
     * @param spu_id
     * @return
     */
    public static String getColumnProductOneInfo(String spu_id) {
        int sid = sendObject(432, Integer.parseInt(spu_id));
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    /**
     * 修改栏目商品上下架状态
     *
     * @param status
     * @param spu_key
     * @return
     */
    public static String productStatusChange(String status, String spu_key) {
        int sid = sendObjectCreate(433, status, spu_key);
        String res = ResultPoor.getResult(sid);
        return res;
    }

    /**
     * 栏目商品上架时间设定
     * @param begintime
     * @param endtime
     * @param status
     * @param id
     * @return
     */
    public static String productStatusUp(String begintime,String endtime,String status,String id){
        begintime = Utils.transformToYYMMddHHmmss(begintime);
        if ("".equals(endtime)) {
            // 十位 区分正确的时间12位 在前台容易区分显示
            endtime = "999999999999";
        }else{
            endtime = Utils.transformToYYMMddHHmmss(endtime);
        }
        int uid =  sendObjectCreate(442, begintime, endtime,status, id);
        String res =  ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 删除栏目商品
     *
     * @param id
     * @return
     */
    public static String deleColumnProduct(String plan_group, String id) {
        int did = sendObjectCreate(434, plan_group, id);
        String res = ResultPoor.getResult(did);
        return res;
    }

    /**
     * 查看所有秒杀时间段
     *
     * @return
     */
    public static String selectSeckillTimeList() {
        String currentTime = BaseCache.getTIME();
        int sid = sendObject(435, currentTime,currentTime,currentTime);
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    /**
     * 查询可以启用的秒杀状态
     * @return
     */
    public static String selectSeckillTimeList2() {
        int sid = sendObject(456);
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    /**
     * 变更秒杀时段  启用 禁用
     *
     * @param id
     * @param is_default
     * @return
     */
    public static String changeSeckillUse(String id, String is_default) {
        int uid = sendObjectCreate(436, is_default, id);
        String res = ResultPoor.getResult(uid);
        return StringHandler.getRetString(res);
    }

    /**
     * 删除秒杀时段管理
     *
     * @param id
     * @return
     */
    public static String delSeckillUse(String id) {
        int uid = sendObjectCreate(437, id);
        String res = ResultPoor.getResult(uid);
        return StringHandler.getRetString(res);
    }

    public static String getSecKillInfo(String id) {
        int sid = sendObject(438, id);
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    /**
     * @param secKillName
     * @param secStartTime
     * @param secEndTime
     * @param id
     * @return
     */
    public static String updateSeckillTimeSetting(String secKillName, String secStartTime, String secEndTime, String id) {
        secStartTime = Utils.transformToYYMMddHHmmss(secStartTime);
        secEndTime = Utils.transformToYYMMddHHmmss(secEndTime);
        int uid = sendObjectCreate(439, secKillName, secStartTime, secEndTime, id);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 新增秒杀时段管理
     *
     * @param secKillName
     * @param secStartTime
     * @param secEndTime
     * @return
     */
    public static String insertSeckillTimeSetting(String secKillName, String secStartTime, String secEndTime) {
        secStartTime = Utils.transformToYYMMddHHmmss(secStartTime);
        secEndTime = Utils.transformToYYMMddHHmmss(secEndTime);
        String status = "1";
        int isDefault = 0;
        int iid = sendObjectCreate(440, secKillName, secStartTime, secEndTime, status, isDefault);
        String res = ResultPoor.getResult(iid);
        return res;
    }

    /**
     * 商品加入到首页推荐
     * @param jsonData
     * @param req
     * @return
     */
    public static String saveGoodsForSeckillColumn(String jsonData, HttpServletRequest req) {
        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        int pSpuId = (jsonObject.get("p_spu_id") == null ? 0 : (Integer.valueOf(jsonObject.get("p_spu_id").toString())));
        String imgId = GoodsService.getSPUFirstShowImgId(String.valueOf(pSpuId));
        // 获取SPU商品中show图的第一个id值
        int planGroup = (jsonObject.get("plan_group") == null ? 0 : (Integer.valueOf(jsonObject.get("plan_group").toString())));
        // 栏目ID
        String uri = "spuId=" + pSpuId;
        // 拼接uri
        String category = "1";
        // 固定是1
        int seckillId = (jsonObject.get("seckill_id") == null ? 0 : (Integer.valueOf(jsonObject.get("seckill_id").toString())));
        // 秒杀场次
        int productStatus = 0;
        // 默认商品下架状态
        String pddCreatetime = BaseCache.getTIME();
        // 添加商品的时间  == 编辑的时间
        int userId = StringHandler.getUserId(req);
        // 用户ID
        int sort = 0;
        // 排序
        int cid = sendObject(411, uri);
        String checkResult = ResultPoor.getResult(cid);
        // 防止重复添加推荐商品
        int num = (int) PlanService.getFieldValue(checkResult, "num", Integer.class);
        String retResult = "";
        if (num == 1) {
            // 已经重复 不能添加
            return "{ \"msg\":\"已经重复添加过此商品,请检查\" }";
        } else {
            int sid = sendObjectCreate(441,sort,imgId,category,uri,planGroup,pSpuId,seckillId,productStatus,pddCreatetime,pddCreatetime,userId);
            retResult =  ResultPoor.getResult(sid);

        }
        return retResult;
    }

    /**
     *
     * @param original_price
     * @param sort
     * @param bstarttime
     * @param bendtime
     * @param spuId
     * @return
     */
    public static String updateColumnGoods(String original_price,String sort,String bstarttime,String bendtime,String seckillId,String spuId){
        original_price =  Utils.yuanToFen(original_price);
        bstarttime = Utils.transformToYYMMddHHmmss(bstarttime);
        if (bendtime == "") {
            bendtime = "999999999999";
        } else{
            bendtime = Utils.transformToYYMMddHHmmss(bendtime);
        }
        int uid =  sendObjectCreate(443,original_price,bstarttime,bendtime,seckillId,sort,spuId);
        String res =  ResultPoor.getResult(uid);
        return res;
    }

    public static String isExistSeckillProduct(String seckillId){
        int sid =  sendObject(444, seckillId);
        String res =  ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    public static String updateSKUGoodsSeckillPrice(String seckillPrice,String skuId){
        int uid =  sendObjectCreate(458, seckillPrice, skuId);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 启用活禁用SKU秒杀商品价格
     * @param skuId
     * @param status
     * @return
     */
    public static String upOrDownSkuSekillPrice(String skuId,String status){
        int uid =  sendObjectCreate(459, status, skuId);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 验证是否含有启用秒杀价格SKU商品
     * @param spuKey
     * @return
     */
    public static String IsCheckSeckillPriceUp(String spuKey){
        int sid = sendObject(467, spuKey);
        String res = ResultPoor.getResult(sid);
        return res;
    }

}
