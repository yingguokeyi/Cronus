package action.service;

import action.sqlhelper.GoodsSql;
import cache.ResultPoor;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.BaseCache;
import common.PropertiesConf;
import common.StringHandler;
import common.Utils;
import common.kuaidi.Result;

import javax.rmi.CORBA.Util;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class GoodsService extends BaseService {


    //获取商品SPU中show图的第一张id
    public static String getSPUFirstShowImgId(String spu_id) {
        StringBuffer sql = new StringBuffer();
        sql.append(GoodsSql.getGoodSPU(spu_id));
        int sid = BaseService.sendObjectBase(9999, sql.toString());
        String ids = StringHandler.getKeyOfResult(ResultPoor.getResult(sid), "show_img_ids");
        String[] idsArray = ids.split(",");
        return idsArray[0].toString();
    }


    // 获取商品SPU信息
    public static String getSPUInfo(String spu_id) {
        int sid = sendObject(65, PropertiesConf.IMG_URL_PREFIX, PropertiesConf.IMG_URL_PREFIX, spu_id);
        return StringHandler.getRetString(ResultPoor.getResult(sid));

    }


    // 获取准备数据（添加或编辑SPU前）
    public static String prepareDataForSpuHandle() {
        Map<String, Object> map = new HashMap<String, Object>();

        //获取有效的商品来源列表
        JSONArray goodsSourceList = StringHandler.getRsOfResult(getValidGoodsSourceList());
        //获取启用的商品品牌
        int sid2 = sendObject(300);
        JSONArray brandList = StringHandler.getRsOfResult(ResultPoor.getResult(sid2));

        map.put("result", "success");
        map.put("goodsSourceList", goodsSourceList);
        map.put("brandList", brandList);

        String outString = JSON.toJSONString(map);
        System.out.println("outString>>>>>>>>>>>>>>>>>>" + outString);
        return outString;

    }


    //新增或保存商品SPU
    public static String saveGoodsSPU(String jsonString, HttpServletRequest req) {
        JSONObject jsonObject = JSONObject.parseObject(jsonString);
        String spu_id = (jsonObject.get("spu_id") == null ? "" : (jsonObject.get("spu_id").toString()));
        String spu_name = jsonObject.get("spu_name").toString();
        String goods_url = jsonObject.get("goods_url_hidden").toString();
        String source_code = (jsonObject.get("source_code") == null ? "" : jsonObject.get("source_code").toString());
        String spu_code = source_code + Utils.SpuProductCodeRule();
        // 商品编码生成规则
        int brand_id = (jsonObject.get("brand_id") == null || "".equals(jsonObject.get("brand_id")) ? 0 : (Integer.valueOf(jsonObject.get("brand_id").toString())));
        int supplier_id = (jsonObject.get("supplier_id") == null ? 0 : (Integer.valueOf(jsonObject.get("supplier_id").toString())));
        int district_id = (jsonObject.get("district_id") == null || "".equals(jsonObject.get("district_id")) ? 0 : (Integer.valueOf(jsonObject.get("district_id").toString())));

        String first_attribute = jsonObject.get("first_attribute").toString();
        String second_attribute = jsonObject.get("second_attribute").toString();
        String show_img_ids = (jsonObject.get("showImgIds") == null ? "" : (jsonObject.get("showImgIds").toString()));
        String detail_img_ids = (jsonObject.get("detailImgIds") == null ? "" : (jsonObject.get("detailImgIds").toString()));//详细商品图片

        String category_id = jsonObject.get("minCateCode").toString();
        String goods_type_id = jsonObject.get("goodsTypeCode").toString();

        String sort = ("".equals(jsonObject.get("sort")) ? "0" : (jsonObject.get("sort").toString()));
        String detail = (jsonObject.get("detail") == null ? "" : (jsonObject.get("detail").toString()));
        String memo = (jsonObject.get("memo") == null ? "" : (jsonObject.get("memo").toString()));
        String distribution = (jsonObject.get("distribution") == null ? "" : (jsonObject.get("distribution").toString()));

        long date = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = sdf.format(date);
        String create_time = Utils.transformToYYMMddHHmmss(str);
        String edit_time = Utils.transformToYYMMddHHmmss(str);
        int edit_user_id = StringHandler.getUserId(req);

        int sid = 0;
        if ("".equals(spu_id)) {
            //新增
            int status = 0;//表示未发布状态(下架)
            sid = sendObjectCreate(26, spu_code, spu_name, source_code, goods_url, brand_id, supplier_id, district_id, first_attribute, second_attribute,
                    show_img_ids, detail_img_ids, status, category_id, goods_type_id, sort, detail, create_time, edit_time, edit_user_id, memo,distribution);
        } else {
            //编辑
            int status = 0;//表示未发布状态(下架)
            sid = sendObjectCreate(31, "", spu_name, source_code, goods_url, brand_id, supplier_id, district_id, first_attribute, second_attribute,
                    show_img_ids, detail_img_ids, status, category_id, goods_type_id, sort, detail, edit_time, edit_user_id, memo, distribution, spu_id);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }


    //获取商品SKU信息
    public static String getSKUInfo(String sku_id) {
        StringBuffer sql = new StringBuffer();
        sql.append(GoodsSql.getGoodSKU(sku_id));

        int sid = BaseService.sendObjectBase(9999, sql.toString());
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }

    //设置默认
    public static String updateSkuDefault(String status, String spuId, String id, HttpServletRequest req) {
        int edit_user = StringHandler.getUserId(req);

        //先将全部sku设为非默认
        BaseService.sendObjectCreate(302, 0, edit_user, spuId);
        //再设置选中的sku默认状态
        int editsid = BaseService.sendObjectCreate(303, Integer.valueOf(status), edit_user, id);
        return ResultPoor.getResult(editsid);
    }


    //新增或保存SKU（规格）
    public static String saveGoodsSKU(String jsonString, HttpServletRequest req) {
        JSONObject jsonObject = JSONObject.parseObject(jsonString);

        int spu_id = (jsonObject.get("spu_id") == null ? 0 : (Integer.valueOf(jsonObject.get("spu_id").toString())));
        String sku_id = (jsonObject.get("sku_id") == null ? "" : (jsonObject.get("sku_id").toString()));
        //int is_default = (jsonObject.get("is_default")==null || "".equals(jsonObject.get("is_default"))? 0:1);
        //String sku_code = jsonObject.get("sku_code").toString();
        //暂时不添加显示 20180505修改

        String sku_name = jsonObject.get("sku_name").toString();
        String spu_name = jsonObject.get("spu_name").toString();

        String memo = jsonObject.get("memo").toString();


        String market_price = ("".equals(jsonObject.get("market_price").toString()) ? "" : (jsonObject.get("market_price").toString()));//市场价
        String original_price = ("".equals(jsonObject.get("original_price").toString()) ? "" : (jsonObject.get("original_price").toString()));//原价
        //前端输入的是单位元，后台转换为单位分
        String market_priceS = Utils.yuanToFen(market_price);
        String original_priceS = Utils.yuanToFen(original_price);

        int stock = (jsonObject.get("stock") == "" ? 0 : (Integer.valueOf(jsonObject.get("stock").toString())));//库存

        String checkFirst = (jsonObject.get("checkFirst") == null ? "" : (jsonObject.get("checkFirst").toString()));
        String txtFirst = (jsonObject.get("txtFirst") == null ? "" : (jsonObject.get("txtFirst").toString()));

        String checkSecond = (jsonObject.get("checkSecond") == null ? "" : (jsonObject.get("checkSecond").toString()));
        String txtSecond = (jsonObject.get("txtSecond") == null ? "" : (jsonObject.get("txtSecond").toString()));

        int first_attribute_id = (jsonObject.get("selectFirst") == null || "".equals(jsonObject.get("selectFirst")) ? 0 : (Integer.valueOf(jsonObject.get("selectFirst").toString())));
        int second_attribute_id = (jsonObject.get("selectSecond") == null || "".equals(jsonObject.get("selectSecond")) ? 0 : (Integer.valueOf(jsonObject.get("selectSecond").toString())));


        //分销规则
        int member_distribution_id = (jsonObject.get("selectMemberDistri") == null || "".equals(jsonObject.get("selectMemberDistri")) ? 0 : (Integer.valueOf(jsonObject.get("selectMemberDistri").toString())));
        int outsider_distribution_id = (jsonObject.get("selectOutsiderDistri") == null || "".equals(jsonObject.get("selectOutsiderDistri")) ? 0 : (Integer.valueOf(jsonObject.get("selectOutsiderDistri").toString())));

        int outsider_top, outsider_parent, outsider_self, member_top, member_parent, member_self;
        member_top = ("".equals(jsonObject.get("T_A").toString()) ? null : (Integer.valueOf(jsonObject.get("T_A").toString())));
        member_parent = ("".equals(jsonObject.get("T_B").toString()) ? null : (Integer.valueOf(jsonObject.get("T_B").toString())));
        member_self = ("".equals(jsonObject.get("T_C").toString()) ? null : (Integer.valueOf(jsonObject.get("T_C").toString())));
        outsider_top = ("".equals(jsonObject.get("T_D").toString()) ? null : (Integer.valueOf(jsonObject.get("T_D").toString())));
        outsider_parent = ("".equals(jsonObject.get("T_E").toString()) ? null : (Integer.valueOf(jsonObject.get("T_E").toString())));
        outsider_self = ("".equals(jsonObject.get("T_F").toString()) ? null : (Integer.valueOf(jsonObject.get("T_F").toString())));

        String member_top_money = ("".equals(jsonObject.get("Z_A").toString()) ? null : (jsonObject.get("Z_A").toString()));
        String member_parent_money = ("".equals(jsonObject.get("Z_B").toString()) ? null : (jsonObject.get("Z_B").toString()));
        String member_self_money = ("".equals(jsonObject.get("Z_C").toString()) ? null : (jsonObject.get("Z_C").toString()));
        String outsider_top_money = ("".equals(jsonObject.get("Z_D").toString()) ? null : (jsonObject.get("Z_D").toString()));
        String outsider_parent_money = ("".equals(jsonObject.get("Z_E").toString()) ? null : (jsonObject.get("Z_E").toString()));
        String outsider_self_money = ("".equals(jsonObject.get("Z_F").toString()) ? null : (jsonObject.get("Z_F").toString()));

        String member_top_money1 = member_top_money.substring(0, member_top_money.length() - 1);
        String member_parent_money1 = member_parent_money.substring(0, member_top_money.length() - 1);
        String member_self_money1 = member_self_money.substring(0, member_top_money.length() - 1);
        String outsider_top_money1 = outsider_top_money.substring(0, member_top_money.length() - 1);
        String outsider_parent_money1 = outsider_parent_money.substring(0, member_top_money.length() - 1);
        String outsider_self_money1 = outsider_self_money.substring(0, member_top_money.length() - 1);

        //前端输入的是单位元，后台转换为单位分
        String member_top_money_result = Utils.yuanToFen(member_top_money1);
        String member_parent_money_result = Utils.yuanToFen(member_parent_money1);
        String member_self_money_result = Utils.yuanToFen(member_self_money1);
        String outsider_top_money_result = Utils.yuanToFen(outsider_top_money1);
        String outsider_parent_money_result = Utils.yuanToFen(outsider_parent_money1);
        String outsider_self_money_result = Utils.yuanToFen(outsider_self_money1);
        //处理时间
        String presellTimeStartStr = (jsonObject.get("presell_begintime") == null ? "" : (jsonObject.get("presell_begintime").toString()));
        String presellTimeEndStr = (("".equals(jsonObject.get("presell_endtime"))) ? "0000-00-00 00:00:00" : (jsonObject.get("presell_endtime").toString()));
        String presell_begintime = Utils.transformToYYMMddHHmmss(presellTimeStartStr);
        String presell_endtime = Utils.transformToYYMMddHHmmss(presellTimeEndStr);
        //如果不限制预期停售时间，习惯将值变成999999999999
        if (presell_endtime.equals("000000000000")) {
            presell_endtime = "999999999999";
        }

        String distribution_begintime = "0";
        String distribution_endtime = "0";
//		String distributionTimeStartStr = (jsonObject.get("distribution_begintime")==null? "":(jsonObject.get("distribution_begintime").toString()));
//		String distributionTimeEndStr = (("".equals(jsonObject.get("distribution_endtime")))? "0000-00-00 00:00:00":(jsonObject.get("distribution_endtime").toString()));
//		String distribution_begintime = Utils.transformToYYMMddHHmmss(distributionTimeStartStr);
//		String distribution_endtime = Utils.transformToYYMMddHHmmss(distributionTimeEndStr);

        String buyconfineStr = (jsonObject.get("buyconfine") == null ? "" : (jsonObject.get("buyconfine").toString()));
        String buyconfine_NumStr = (jsonObject.get("buyconfine_Num") == null ? "" : (jsonObject.get("buyconfine_Num").toString()));

        String bounty = (jsonObject.get("bounty") == null ? "" : (jsonObject.get("bounty").toString()));
        String bountyValue = Utils.yuanToFen(bounty);
        // 奖励金
        //int bountyValue =  Utils.StringConvertToInt(bounty);

        //处理是否推荐到首页
        /**
         String isJoinAD = (jsonObject.get("isJoinAD")==null? "":(jsonObject.get("isJoinAD").toString()));
         PlanService plan = new PlanService();

         if("on".equals(isJoinAD)){
         plan.saveGoodsPlan(jsonString,req);
         }else{
         //如果存在ad_id,要清除
         int ad_id = (jsonObject.get("ad_id")==null || "".equals(jsonObject.get("ad_id"))) ? 0:(Integer.valueOf(jsonObject.get("ad_id").toString()));
         if(ad_id != 0 ){
         plan.deleleGoodsPlanInfo(ad_id);

         }

         }
         **/
        int coupon = 0;

        int sku_style = 1;//删除状态：1.正常（默认）
        int sales_volume = 0;
        //int is_default = 1;
        int sku_status = (jsonObject.get("sku_status") == null ? 0 : (Integer.valueOf(jsonObject.get("sku_status").toString())));

        String result = "";
        int create_user = 0;
        int edit_user = 0;
        int is_default = 0;
        int buyconfine = 0;
        if (buyconfineStr.equals("on") == true) {
            buyconfine = Integer.valueOf(buyconfine_NumStr);
        }

        boolean flag = false;
        if (checkFirst.equals("NEED") && !"".equals(txtFirst)) {
            // 第一个输入销售属性的文本框
            //保存第一个 spu_attribute
            int position = 1; //位置为1
            String isHaveSku = isHaveThisSkuAttri(spu_id, txtFirst, position);
            if (!isHaveSku.equals("0")) {
                // 说明此销售属性已经添加过 只需要将fist Attribute id值 拿过来即可

            } else {
                flag = true;
                // 说明此销售属性是未添加过的 需要向表中添加 得到新的销售属性值的 first attribute id
                int firstSid = sendObjectCreate(28, spu_id, txtFirst, position, 0, 1);
                String firstResult = ResultPoor.getResult(firstSid);
                first_attribute_id = (Integer.valueOf(StringHandler.getIdsOfResult(firstResult)));
            }

        }
        if (checkSecond.equals("NEED") && !"".equals(txtSecond)) {
            // 第二个输入销售属性的文本框
            //保存第二个 spu_attribute
            int position = 2; //位置为2
            String isHaveSku = isHaveThisSkuAttri(spu_id, txtSecond, position);
            if ("0" != isHaveSku) {
                // 说明 用户手动录用的销售属性与数据库中的完全一样 不予录入
                second_attribute_id = Integer.valueOf(isHaveSku);
            } else {
                flag = true;
                int secondSid = sendObjectCreate(28, spu_id, txtSecond, position, 0, 1);
                String secondResult = ResultPoor.getResult(secondSid);
                second_attribute_id = (Integer.valueOf(StringHandler.getIdsOfResult(secondResult)));
            }

        } else if ("".equals(sku_id)) {
            // 目前只有新增SPU商品的时候，sku_id=0  添加规格  编辑规格 目前都有sku_id存在
            // 说明是新添加商品
            int skuCompValuesId = sendObject(405, spu_id, first_attribute_id, second_attribute_id);
            String skuCompValueRes = ResultPoor.getResult(skuCompValuesId);
            int skuCompNums = (int) GoodsService.getFieldValue(skuCompValueRes, "skuCompNums", Integer.class);
            if (skuCompNums == 2) {
                // 说明此spu下的商品组合 已经添加过
                /*
                 此时需要在说明 在b_sku 中 是否已经存在此
                 */
                String resId1 = isSkuExistFirst(spu_id, first_attribute_id, second_attribute_id);

                String resId2 = isSkuExistSecond(spu_id, second_attribute_id, first_attribute_id);

                // 两个函数有一个返回为false  都不能继续进行
                if (resId1.equals("0") && resId2.equals("0")) {
                    // 未添加此销售属性组合的SKU商品
                    flag = true;

                } else {
                    // 已经添加  返回告知 不能添加这组合

                    jsonObject = new JSONObject();
                    jsonObject.put("success", 2);
                    return jsonObject.toJSONString();
                }

            } else if (skuCompNums == 1) {
                // 仅有一种规格添加过 可以再次添加此spu商品 所具有的sku商品信息 新增一条
                flag = true;
            } else if (skuCompNums < 1) {
                // 此规格组合 完全没有添加过  新创建一个 create
                flag = true;
            }

        }

        if ("".equals(sku_id) && flag) {
            /**
             * 当sku_id 不存在：第一次添加SPU商品时候 保存之后 马上添加sku_id 此时sku_id=0
             * newSku 用来标记 是添加规格功能 触发此段代码
             */
            //新增sku信息
            //先判断是否有默认SKU
            int findSid = sendObject(301, spu_id);
            String findResult = ResultPoor.getResult(findSid);
            String cnt = StringHandler.getKeyOfResult(findResult, "CNT");

            if (Integer.valueOf(cnt) == 0) {
                //当前无默认的sku,则将新增的设为默认  此规格为暂时使用
                // 正确选择默认SKU规则为
                /*
                 1. 首次添加该SPU商品下的SKU商品 默认为SKU
                 2. 非首次添加，则按照商品的市场的销售价格 由低到高 售卖
                 3. 若出现多件商品价格相同 则 按照 添加时间 排序 选择最近添加的商品
                 4. 必须保证一个SPU下 有一个唯一的默认的SKU
                 5。 此排序和商品上架 下架 无关
                 */
                is_default = 1;
            }
            // 创建
            create_user = StringHandler.getUserId(req);
            edit_user = StringHandler.getUserId(req);
            int addSid = sendObjectCreate(29, spu_id, "", spu_name, sku_name, first_attribute_id, second_attribute_id, market_priceS, original_priceS,
                    outsider_top, outsider_parent, outsider_self, member_top, member_parent, member_self, outsider_top_money_result,
                    outsider_parent_money_result, outsider_self_money_result, member_top_money_result, member_parent_money_result, member_self_money_result, member_distribution_id, outsider_distribution_id,
                    stock, is_default, sku_status, coupon, distribution_begintime, distribution_endtime, presell_begintime, presell_endtime, sku_style, create_user, edit_user, sales_volume, memo, buyconfine,bountyValue);
            result = ResultPoor.getResult(addSid);
        } else {
            //编辑sku信息
            edit_user = StringHandler.getUserId(req);
            int addSid = sendObjectCreate(32, spu_id, "", spu_name, sku_name, first_attribute_id, second_attribute_id, market_priceS, original_priceS,
                    outsider_top, outsider_parent, outsider_self, member_top, member_parent, member_self, outsider_top_money_result,
                    outsider_parent_money_result, outsider_self_money_result, member_top_money_result, member_parent_money_result, member_self_money_result, member_distribution_id, outsider_distribution_id,
                    stock, coupon, distribution_begintime, distribution_endtime, presell_begintime, presell_endtime, sku_style, edit_user, sales_volume, memo, buyconfine,bountyValue, sku_id);
            result = ResultPoor.getResult(addSid);
        }
        return result;
    }

    /**
     * 检验在b_sku 是否存在此spu_id 的SKU商品  1
     *
     * @param spu_id
     * @param firsAttributeId
     * @param secondAttriId
     * @return
     */
    public static String isSkuExistFirst(int spu_id, int firsAttributeId, int secondAttriId) {
        int sid = sendObject(407, spu_id, firsAttributeId, secondAttriId);
        String result = ResultPoor.getResult(sid);
        String id = "0";
        //  JSONArray temp = JSONObject.parseObject(result).getJSONObject("result").getJSONArray("total");
        try {
            id = (String) GoodsService.getFieldValue(result, "id", String.class);
        } catch (Exception e) {
            //e.printStackTrace();
            System.out.println("  ==============  isSkuExistFirst  =====================");
            id = "0";
        }
        return id;
    }


    /**
     * 检验在b_sku 是否存在此spu_id 的SKU商品 2
     *
     * @param spu_id
     * @param firsAttributeId
     * @param secondAttriId
     * @return
     */
    public static String isSkuExistSecond(int spu_id, int secondAttriId, int firsAttributeId) {
        int sid = sendObject(408, spu_id, firsAttributeId, secondAttriId);
        String result = ResultPoor.getResult(sid);
        String id = "0";
        try {
            id = (String) GoodsService.getFieldValue(result, "id", String.class);
        } catch (Exception e) {
            // e.printStackTrace();
            System.out.println("  ==============  isSkuExistFirst  =====================");
            id = "0";
        }
        return id;
    }

    /**
     * 提交输入的销售属性值
     *
     * @param spu_id
     * @param txtContents
     * @param position
     * @return
     */
    public static String isHaveThisSkuAttri(int spu_id, String txtContents, int position) {
        int sid = sendObject(406, spu_id, txtContents, position);
        String result = ResultPoor.getResult(sid);
        String id = "0";
        try {
            id = (String) GoodsService.getFieldValue(result, "id", String.class);
        } catch (Exception e) {
            // e.printStackTrace();
            System.out.println("  ==============  isSkuExistFirst  =====================");
            id = "0";
        }
        return id;
    }

    //(更新商品的状态)
    public static String updateGoodsSPUStatus(String status, String spuId, HttpServletRequest req) {
        int userId = StringHandler.getUserId(req);
        long dateTime = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(dateTime);
        String dateTimeStr = Utils.transformToYYMMddHHmmss(dateStr);
        int sid = sendObjectCreate(30, Integer.valueOf(status), dateTimeStr, userId, Integer.valueOf(spuId));
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     * 商品中心商品下架-栏目商品随之下架
     * @param spuId
     * @return
     */
    public static String DownStatusPlanGoods(String spuId){
        int uid = sendObjectCreate(463, spuId);
        String res =  ResultPoor.getResult(uid);
        return res;
    }

    //(更新商品的状态)
    public static String updateGoodsSPUStatusBatch(String status, String Ids, HttpServletRequest req) {

        int userId = StringHandler.getUserId(req);
        String[] ids = Ids.split(",");
        int sid = 0;
        for (String id : ids) {
            sid = sendObjectCreate(30, status, userId, id);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }


    //更新SPU排序
    public static String updateSPUSort(String sort, String id, HttpServletRequest req) {
        int userId = StringHandler.getUserId(req);
        int sid = sendObjectCreate(35, Integer.parseInt(sort), userId, Integer.parseInt(id));
        String result = ResultPoor.getResult(sid);
        return result;
    }


    //商品查询
    public static String getGoodsList(String spu_name, String goods_source, String spu_code, String cateName, String goodsTypeName, String status, int begin, int end, String online) {
//		String stopSale,

        StringBuffer sql = new StringBuffer();

        //查询条件
        if (spu_name != null && !spu_name.equals("")) {
            sql.append(" AND spu_name LIKE '%").append(spu_name).append("%'");
        }
        if (goods_source != null && !goods_source.equals("")) {
            sql.append(" AND source_code = '").append(goods_source).append("'");
        }
        if (spu_code != null && !spu_code.equals("")) {
            sql.append(" AND spu_code LIKE '%").append(spu_code).append("%'");
        }
        if (goodsTypeName != null && !goodsTypeName.equals("")) {
            sql.append(" AND goodsTypeName LIKE '%").append(goodsTypeName).append("%'");
        }
        if (cateName != null && !cateName.equals("")) {
            sql.append(" AND cateName LIKE '%").append(cateName).append("%'");
        }
        if (status != null && !status.equals("")) {
            sql.append(" AND T.status = ").append(status);
        }


        //解决特殊分页效率问题（适用范围：只能传一个分页参数字符串类型，外部条件以buffer形式动态拼接，数据里只存主体部分）
        //String limit = "limit " + begin + "," + end;
        //int sid = BaseService.sendObject(503, sql.toString());
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

////////
    //商品回收站查询
//	public static String getGoodsTrashList(int begin,int end) {
//		StringBuffer sql = new StringBuffer();
//		sql.append(GoodsSql.getAllGoods_sql);
//
//
//		sql.append(" limit ").append(begin).append(",").append(end);//分页
//		int sid = BaseService.sendObjectBase(9999, sql.toString());
//		return StringHandler.getRetString(ResultPoor.getResult(sid));
//	}


    //添加商品来源
    public static String addGoodsSource(String sourceName, String sourceCode, String memo, int userId) {
        Map<String, String> map = new HashMap<String, String>();
        //编辑时间和最后编辑者

        long timeInt = System.currentTimeMillis();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date2 = df.format(timeInt);
        String edit_time = Utils.transformToYYMMddHHmmss(date2);

        //先查询系统里是否有重复的sourceCode
        int findSid = sendObject(48, 5, sourceCode);
        String findResult = ResultPoor.getResult(findSid);
        String cnt = StringHandler.getKeyOfResult(findResult, "CNT");

        if (Integer.valueOf(cnt) == 0) {
            //无重复sourceCode,允许添加
            sendObjectCreate(22, 5, sourceName, sourceCode, 0, memo, edit_time, userId, 1, 0, 0);
            map.put("result", "success");
        } else {
            map.put("result", "fail");//有重复的sourceCode,添加失败
        }
        String json = JSON.toJSONString(map);
        return json;
    }


    //查询商品来源列表
    public static String getGoodsSourceList(int begin, int end) {
        int addSid = sendObject(21, 5, begin, end);
        String result = ResultPoor.getResult(addSid);
        return StringHandler.getRetString(result);
    }

    //获取有效的商品来源列表
    public static String getValidGoodsSourceList() {
        int addSid = sendObject(45, 5);
        return ResultPoor.getResult(addSid);
    }

    //获取正常的全部（不含已删除）的商品来源列表
    public static String getAllNormalGoodsSourceList() {
        String res = DictionaryService.getAllNormalDictListByDictId("5");
        return res;
    }


    //添加品牌
    public static String addBrand(String jsonString) {

        JSONObject jsonObject = JSONObject.parseObject(jsonString);
        int brandId = 0;
        if (jsonObject.get("brandId") != null && !"null".equals(jsonObject.get("brandId"))) {
            brandId = Integer.valueOf(jsonObject.get("brandId").toString());
        }


        String brand_name = jsonObject.get("brand_name").toString();
        String url = jsonObject.get("url").toString();
        String logo_img_id = jsonObject.get("imgId").toString();
        String detail = jsonObject.get("detail").toString();
        System.out.println(url);


        int sid = 0;
        if (brandId == 0) {
            sid = sendObjectCreate(24, brand_name, logo_img_id, url, detail);
        } else {
            sid = sendObjectCreate(47, brand_name, logo_img_id, url, detail, 0, brandId);
        }


        return ResultPoor.getResult(sid);
    }


    //获取品牌信息
    public static String getBrandInfo(String brandId) {
        int sid = BaseService.sendObject(46, brandId);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    //更新品牌状态
    public static String updateBrandStatus(String status, String id) {
        int sid = BaseService.sendObjectCreate(50, status, id);
        return ResultPoor.getResult(sid);
    }


    //查询品牌列表
    public static String getBrandList(String searchName, int begin, int end) {
        StringBuffer sql = new StringBuffer();

        //之前的方式
//		sql.append(GoodsSql.getBrandList_sql);
//		//查询条件
//		if(searchName !=null && !searchName.equals("")){
//			sql.append(" where (brand_name LIKE '%").append(searchName).append("%' or detail LIKE '%").append(searchName).append("%')");
//		}
        //sql.append(" LIMIT ").append(begin).append(",").append(end);//分页
//		int sid = BaseService.sendObjectBase(9997,sql.toString(),begin,end);
//		return StringHandler.getRetString(ResultPoor.getResult(sid));

        //现在的方式
        //查询条件
        sql.append("");
        String searchNameLike = "";
        int sid;
        if (searchName != null && !searchName.equals("")) {
            sql.append(" where (B.brand_name LIKE ? or B.detail LIKE ?)");
            searchNameLike = "%" + searchName + "%";
            sid = sendObjectBase(49, sql.toString(), searchNameLike, searchNameLike, begin, end);
        } else {
            sid = sendObject(49, begin, end);
        }


        String result = ResultPoor.getResult(sid);
        return StringHandler.getRetString(result);

    }


    //查询供应商列表
    public static String getSupplierList(String searchName, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        //查询条件
        sql.append("");
        String searchNameLike = "";
        int sid;
        if (searchName != null && !searchName.equals("")) {
            sql.append(" where (S.supplier_name LIKE ? or S.memo LIKE ?)");
            searchNameLike = "%" + searchName + "%";
            sid = sendObjectBase(309, sql.toString(), searchNameLike, searchNameLike, begin, end);
        } else {
            sid = sendObject(309, begin, end);
        }

        String result = ResultPoor.getResult(sid);
        return StringHandler.getRetString(result);

    }

    //获取供应商信息
    public static String getSupplierInfo(String supplierId) {
        int sid = BaseService.sendObject(312, supplierId);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    //删除供应商信息
    public static String deleteSupplier(String supplierId) {
        int sid = BaseService.sendObjectCreate(313, supplierId);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    //添加供应商
    public static String addSupplier(String jsonData) {
        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        int supplierId = 0;
        if (jsonObject.get("supplierId") != null && !"null".equals(jsonObject.get("supplierId"))) {
            supplierId = Integer.valueOf(jsonObject.get("supplierId").toString());
        }
        String supplier_name = jsonObject.get("supplier_name").toString();
        String tel = jsonObject.get("tel").toString();
        String address = jsonObject.get("address").toString();
        String memo = jsonObject.get("memo").toString();

        int sid = 0;
        if (supplierId == 0) {
            sid = sendObjectCreate(310, supplier_name, tel, address, memo);
        } else {
            sid = sendObjectCreate(311, supplier_name, tel, address, memo, supplierId);
        }
        return ResultPoor.getResult(sid);
    }


    //查询单位数量列表
    public static String getQuantityUnitList(String searchName, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        //查询条件
        sql.append("");
        String searchNameLike = "";
        int sid;
        if (searchName != null && !searchName.equals("")) {
            sql.append(" and (dict_data_name LIKE ? or memo LIKE ?) order by sort,id");
            searchNameLike = "%" + searchName + "%";
            sid = sendObjectBase(315, sql.toString(), 4, searchNameLike, searchNameLike, begin, end);
        } else {
            sql.append("  order by sort,id");
            sid = sendObjectBase(315, sql.toString(), 4, begin, end);
        }

        String result = ResultPoor.getResult(sid);
        return StringHandler.getRetString(result);

    }


    //添加数量单位
    public static String addQuantityUnit(String unitName, String memo, String unitId, int userId) {
        Map<String, String> map = new HashMap<String, String>();
        int totalInt = 0;


        if ("".equals(unitId) || unitId == null) {
            String[] nameArray = unitName.split(",");
            //先查询系统里是否有重复的数量单位
            for (int i = 0; i < nameArray.length; i++) {
                int findSid = sendObject(316, 4, nameArray[i]);
                String findResult = ResultPoor.getResult(findSid);
                totalInt = Integer.valueOf(StringHandler.getKeyOfResult(findResult, "CNT")) + totalInt;
            }

            if (totalInt == 0) {
                //无重复sourceCode,允许添加
                for (int i = 0; i < nameArray.length; i++) {
                    sendObjectCreate(22, 4, nameArray[i], "unit", 0, memo, userId, 1, 0, 0);
                }
                map.put("result", "success");
            } else {
                map.put("result", "fail");//有重复的数量单位,添加失败
            }
        } else {//修改数量单位

            //先查询系统里是否有重复的数量单位
            int findSid = sendObject(317, 4, unitName, unitId);
            String findResult = ResultPoor.getResult(findSid);
            int cnt = Integer.valueOf(StringHandler.getKeyOfResult(findResult, "CNT"));

            if (cnt == 0) {
                sendObjectCreate(38, unitName, memo, userId, 0, 0, unitId); //更新数据字典
                map.put("result", "success");
            } else {
                map.put("result", "fail");//有重复的数量单位,添加失败
            }

        }

        String json = JSON.toJSONString(map);
        return json;
    }


    //删除数量单位（逻辑删除）
    public static String deteleQuantityUnit(String unitId) {
        DictionaryService.updateState("0", unitId);
        return DictionaryService.updateState("0", unitId);
    }

    //更新数量单位排序
    public static String updateQuantityUnitSort(String sort, String id, HttpServletRequest req) {
        int userId = StringHandler.getUserId(req);
        String res = DictionaryService.updateSort(sort, id);
        return res;
    }


    //获取数量单位
    public static String getQuantityUnit(String unitId) {
        int sid = BaseService.sendObject(20, unitId);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }


    //获取分销列表 by luyou
    public static String getDistributionList(String type) {
        int sid = 0;
        if ("member".equals(type)) {
            sid = sendObject(36, 1);
        } else if ("outsider".equals((type))) {
            sid = sendObject(36, 2);
        }

        String result = ResultPoor.getResult(sid);
        return result;
    }


    //获取全部有效的分销列表 by luyou
    public static String getAllValidDistributionList() {
        int sid = sendObject(40);
        String result = ResultPoor.getResult(sid);
        return result;
    }


    public static String getGoodsSKUList(int begin, int end, String goodsSPUId) {
        int sid = sendObject(62, goodsSPUId, begin, end);
        String rsGoodsSKULInfo = ResultPoor.getResult(sid);
        String rsGoodsSKULJson = StringHandler.getRetString(rsGoodsSKULInfo);
        return rsGoodsSKULJson;
    }

    /**
     * b_spu_attribute id
     *
     * @param id
     * @return
     */
    public static String delGoodsSpuAttribute(String id) {
        int sid = sendObjectCreate(409, id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String upSKUGoodsStatus(String userId, String id, String presell_newEndtime, String style, String goodsSPUId) throws Exception {
        int sid = 0;
        int sku_status = 0;
        int edit_user = Integer.valueOf(userId);
        int edit_time = StringHandler.getLongDate();
        String[] idStr = id.split(",");
        String result = "";
        boolean flag = false;
        boolean lastOne = false;
        // 是否需要设置默认SKU
        if ("beginSell".equals(style)) {
            for (int i = 0; i < idStr.length; i++) {
                //商品起售
                sku_status = 1;
                sid = sendObjectCreate(63, edit_user, edit_time, sku_status, idStr[i]);
                result = ResultPoor.getResult(sid);
            }
        } else {
            //商品停售
            String is_default = "0";
            for (int i = 0; i < idStr.length; i++) {
                int updateId = sendObject(413, idStr[i]);
                String resUpdate = ResultPoor.getResult(updateId);
                int num = (int) GoodsService.getFieldValue(resUpdate, "num", Integer.class);
                // num = 1 说明此商品是默认SKU商品 准备停售
                if (num != 0) {
                    flag = true;
                    // 此商品是原有默认SKU商品 准备寻找新的SKU 接管默认SKU位置
                }
                sku_status = 0;
                int LastNumId =  sendObject(415, goodsSPUId);
                String res =  ResultPoor.getResult(LastNumId);
                // 查询当前剩余SKU中 有几个还在起售状态
                // 检测 剩下起售状态的商品 用于保留停售最后一个商品时候的默认SKU状态
                int LastResNum = (int) GoodsService.getFieldValue(res, "num", Integer.class);
                // 最后剩下的起售SKU商品数量
                if (LastResNum == 1){
                    // 至少有一个存在 不会为0
                    is_default = "1";
                    lastOne = true;
                }
                sid = sendObjectCreate(416, edit_user, edit_time, sku_status,is_default, idStr[i]);
                result = ResultPoor.getResult(sid);
                if(result.equals("")){
                    return "";
                }else if (lastOne){
                    return result;
                }
            }
            if (flag) {
                // 说明需要重新设置默认SKU
                int skuListId = sendObject(414, goodsSPUId);
                String resSkuId = ResultPoor.getResult(skuListId);
                // int id = (int) GoodsService.getFieldValue(resSkuId, "id", Integer.class);
                try {
                    int skuId = (int) GoodsService.getFieldValue(resSkuId, "id", Integer.class);
                    // 如果存在 则用此为默认SKUID 商品
                    int editsid = sendObjectCreate(303, "1", edit_user, skuId);
                    String uIdRes = ResultPoor.getResult(editsid);
                    return uIdRes;
                } catch (NullPointerException e) {
                    System.out.println("   nullPointerException   ");
                } catch (IndexOutOfBoundsException e){
                    System.out.println("   IndexOutOfBoundsException  ");
                }
            }
            JSONObject addGoodsPropertyInfoJO = JSONObject.parseObject(result);
            String logStatus = addGoodsPropertyInfoJO.get("success") == null ? ""
                    : (addGoodsPropertyInfoJO.get("success").toString());
            if (logStatus.equals("1")) {
                String rsGoodsSKULInfo = selBeginSellSKUNum(goodsSPUId);
                String rs_Str = StringHandler.getRsOfResult(rsGoodsSKULInfo).toString();
                if (rs_Str.equals("[]")) {
                    int spu_id = Integer.valueOf(goodsSPUId);
                    int spuId = sendObjectCreate(30, 0, edit_time, edit_user, spu_id);
                    result = ResultPoor.getResult(spuId);
                }

            }
        }// 停售结束


        return result;
    }

    public static String selBeginSellSKUNum(String goodsSPUId) {
        int selid = sendObject(241, Integer.valueOf(goodsSPUId));
        String rsGoodsSKULInfo = ResultPoor.getResult(selid);
        return rsGoodsSKULInfo;
    }


    public static String delGoodsSKU(String id, String userId, String spuId) {
        int sku_style = 2;
        int edit_user = Integer.valueOf(userId);
        int edit_time = StringHandler.getLongDate();
        String[] idStr = id.split(",");
        // idStr is  skuId
        String result = "";
        boolean flag = false;
        // 是否需要设置默认SKU
        for (int i = 0; i < idStr.length; i++) {
            int updateId = sendObject(413, idStr[i]);
            String resUpdate = ResultPoor.getResult(updateId);
            int num = (int) GoodsService.getFieldValue(resUpdate, "num", Integer.class);
            if (num != 0) {
                flag = true;
            }
            int sid = sendObjectCreate(64, edit_user, edit_time, sku_style, idStr[i]);
            result = ResultPoor.getResult(sid);
        }
        if (flag) {
            // 说明需要重新设置默认SKU
            int skuListId = sendObject(412, spuId);
            String resSkuId = ResultPoor.getResult(skuListId);
            // int id = (int) GoodsService.getFieldValue(resSkuId, "id", Integer.class);
            try {
                int skuId = (int) GoodsService.getFieldValue(resSkuId, "id", Integer.class);
                // 如果存在 则用此为默认SKUID 商品
                int editsid = sendObjectCreate(303, "1", edit_user, skuId);
                String uIdRes = ResultPoor.getResult(editsid);
                return uIdRes;
            } catch (NullPointerException e) {
                System.out.println("   nullPointerException   ");
            }

        }

        return result;
    }

    public static String getGoodsSKUAttributeList(int begin, int end, String id) {
        int getGoodsClassifyInfoSid = sendObject(62, id, begin, end);
        String rsGoodsSKULInfo = ResultPoor.getResult(getGoodsClassifyInfoSid);
        String rsGoodsSKULJson = StringHandler.getRetString(rsGoodsSKULInfo);
        return rsGoodsSKULJson;
    }

    public static String updateGoodsSkUStatus(String status, String spuId, HttpServletRequest req) {
        int userId = StringHandler.getUserId(req);
        int status_int = Integer.valueOf(status);
        int spu_id = Integer.valueOf(spuId);
        String edit_time = BaseCache.getDateTime();
        int sid = sendObjectCreate(240, status_int, userId, edit_time, spu_id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     * 校验上传SPU信息是否正确
     * 无误 返回空。
     *
     * @param jsonString
     * @return
     */
    public static String addSPUCheckInfo(String jsonString) {
        JSONObject jsonObject = JSONObject.parseObject(jsonString);
        if (jsonObject.get("first_attribute").toString().equals("")) {
            return "请填写属性名称1";
        }
//      else if(jsonObject.get("second_attribute").toString().equals("")){
//			return "请填写属性名称2";
//		}
        else if (jsonObject.get("distribution").toString().equals("")) {
            return "请填写配送说明";
        }
        else if (jsonObject.get("spu_name").toString().equals("")) {
            return "请填写商品名称";
        } else if (jsonObject.get("detail").toString().equals("")) {
            return "请填写商品属性";
        } else if (jsonObject.get("showImgIds").toString().equals("")) {
            return "请上传轮播图";
        } else if (jsonObject.get("detailImgIds").toString().equals("")) {
            return "请上传详细图";
        } else {
            return "";
        }
    }

    public static String checkSPUNameISNOExist(String spu_name) {
        int sid = sendObject(245, spu_name);
        String result = ResultPoor.getResult(sid);
        String rsGoodsSKULJson = StringHandler.getRetString(result);
        return rsGoodsSKULJson;
    }

    public static String saveZhangDZGoods(String spuName,String spuId,String bounty,int userId){
        String spu_code = "ZD" + Utils.SpuProductCodeRule();
        //商品初始状态为启用：0
        int state = 0;
        long date = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = sdf.format(date);
        String create_time = Utils.transformToYYMMddHHmmss(str);

        float b_temp = Float.parseFloat(bounty) * 100;
        float b_float = (float) (Math.round(b_temp * 100)) / 100;
        int b_Int = ((Number) b_float).intValue();

        int sid = 0;
        //spuId不为null为更新
        if(spuId == null || "".equals(spuId)) {
             sid = BaseService.sendObjectCreate(604, spuName, spu_code, state, create_time, create_time, userId,b_Int);
        }else {
            sid = BaseService.sendObjectCreate(609, spuName,create_time,b_Int,spuId);
        }
        return ResultPoor.getResult(sid);
    }

    public static String getZhangDZGoodsList(String spuName,String state,String price_min,String price_max,int begin, int end){
        StringBuffer sql = new StringBuffer();
        if(spuName !=null && !"".equals(spuName)){
            sql.append(" and goods_name like '%").append(spuName).append("%'");
        }
        if(state !=null && !"".equals(state)){
            sql.append(" and state = ").append(state);
        }
        if(price_min !=null && !"".equals(price_min)){
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and create_date between '").append(created_date1).append("'");
        }
        if(price_max !=null && !"".equals(price_max)){
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" order by create_date desc");
        int sid = BaseService.sendObjectBase(605, sql.toString(), begin, end);
        String result = ResultPoor.getResult(sid);
        return StringHandler.getRetString(result);

    }

    public static String getZhangDZGoodsList(){
        int sid = sendObject(607);
        String result = ResultPoor.getResult(sid);
        return StringHandler.getRetString(result);
    }

    public static String updateGoods(String id,String state){
        String[] ids = id.split(",");
        int sid = 0;
        for (String id1 : ids) {
            sid = sendObjectCreate(606, state, id1);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     * 商品来源 是否是掌小龙
     * @param spu_id
     * @return
     */
    public static String checkIsBounty(String spu_id){
        int sid =  sendObject(427, Integer.parseInt(spu_id));
        String res =  ResultPoor.getResult(sid);
        return res;
    }

}