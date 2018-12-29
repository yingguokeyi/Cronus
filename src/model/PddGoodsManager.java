package model;

import action.service.BaseService;
import action.service.PddGoodsService;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import utils.HttpUtil;
import utils.MD5Util;
import utils.StringUtil;

/**
 * 每天24点定时 拉取拼多多商品列表
 *
 */
public class PddGoodsManager extends BaseService implements Runnable {
    static String client_id="39c29be29a1d4422a6328b3896975ff6";
    static String client_secret = "c13e59689c11838377f4ef86803f2be17feb47ea";
    static String url = "http://gw-api.pinduoduo.com/api/router";

    @Override
    public void run() {
        System.out.println("拉取拼多多商品定时任务开始执行。。。。");
        addPdd("2");
        getPddGoodsList();
    }
    /**
     * 拉取多多进宝商品
     */
    public void addPdd(String sort_type){
       for(int page = 1;page <100;page++) {
            JSONObject pddParameter = new JSONObject();
            pddParameter.put("client_id", client_id);
            pddParameter.put("data_type", "JSON");
            pddParameter.put("page", Integer.valueOf(page));
            pddParameter.put("sort_type", sort_type);
            pddParameter.put("timestamp", String.valueOf(System.currentTimeMillis()));
            pddParameter.put("type", "pdd.ddk.goods.search");
            pddParameter.put("with_coupon", true);
            pddParameter.put("sign", MD5Util.sign(StringUtil.createLinkString(pddParameter, client_secret), "utf-8").toUpperCase());
            HttpUtil httpUtil = new HttpUtil();
            try {
                String s = httpUtil.postGeneralUrl(url, "application/json", pddParameter.toString(), "utf-8");
                //System.out.println("拉取结果：" + s);
                JSONObject pddGoodsResult = JSONObject.parseObject(s);
                Object goods_list = pddGoodsResult.get("goods_search_response");
                JSONObject jsonObject = JSONArray.parseObject(goods_list.toString());
                Object goods_list1 = jsonObject.get("goods_list");
                Object total_count = jsonObject.get("total_count");
                System.out.println("从拼多多——多多进宝商品共有：" + total_count + " 件");
                JSONArray wordsArray = JSONArray.parseArray(goods_list1.toString());
                System.out.println("拉取第 " + page + " 页,商品件数为：" + wordsArray.size());
                for (Object goods : wordsArray) {
                    JSONObject jsonWords = JSONObject.parseObject(goods.toString());
                    Object opt_id = jsonWords.get("opt_id");
                    if (null != opt_id) {
                        //商品入库
                        String pddGoods = PddGoodsService.getPddGoodsByGoodsId(jsonWords.get("goods_id").toString());
                        JSONArray pddGoodsResults = JSONObject.parseObject(pddGoods).getJSONObject("result").getJSONArray("rs");
                        if (pddGoodsResults.size() ==0) {
                            PddGoodsService.addPddGoods(jsonWords.get("goods_id").toString(), jsonWords.get("goods_name").toString(),
                                    jsonWords.get("goods_thumbnail_url").toString(), jsonWords.get("goods_image_url").toString(), Integer.valueOf(jsonWords.get("sold_quantity").toString()),
                                    Integer.valueOf(jsonWords.get("min_group_price").toString()), Integer.valueOf(jsonWords.get("min_normal_price").toString()), jsonWords.get("mall_name").toString(),
                                    Integer.valueOf(String.valueOf(jsonWords.get("coupon_min_order_amount"))), Integer.valueOf(String.valueOf(jsonWords.get("coupon_discount"))), Integer.valueOf(String.valueOf(jsonWords.get("coupon_total_quantity"))),
                                    Integer.valueOf(jsonWords.get("coupon_remain_quantity").toString()), jsonWords.get("coupon_start_time").toString(), jsonWords.get("coupon_end_time").toString(),
                                    String.valueOf(jsonWords.get("promotion_rate")), String.valueOf(jsonWords.get("goods_eval_score")), String.valueOf(jsonWords.get("goods_eval_count")),
                                    String.valueOf(jsonWords.get("cat_ids")), Integer.valueOf(opt_id.toString()),
                                    String.valueOf(jsonWords.get("opt_name")), String.valueOf(jsonWords.get("goods_gallery_urls")),
                                    String.valueOf(jsonWords.get("avg_desc")), String.valueOf(jsonWords.get("avg_lgst")),
                                    String.valueOf(jsonWords.get("avg_serv")), Integer.valueOf(jsonWords.get("merchant_type").toString()), "PDD");
                            /*String goods_detail = getPddGoodsDetail(jsonWords.get("goods_id").toString());
                            JSONObject jsonObject1 = JSONObject.parseObject(goods_detail);
                            JSONArray goodsDetail = jsonObject1.getJSONObject("goods_detail_response").getJSONArray("goods_details");
                            if (goodsDetail.size() == 0) {
                                PddGoodsService.deletePddGoods(jsonWords.get("goods_id").toString());
                            } else {
                                JSONObject o = goodsDetail.getJSONObject(0);
                                Integer coupon_remain_quantity = Integer.valueOf(o.get("coupon_remain_quantity").toString());
                                String goods_desc = (String) o.get("goods_desc");
                                String goods_gallery_urls = String.valueOf(o.get("goods_gallery_urls"));
                                PddGoodsService.updatePddGoods(jsonWords.get("goods_id").toString(), goods_desc, goods_gallery_urls, coupon_remain_quantity);
                            }*/

                            /*String goods_detail = getPddGoodsDetail(jsonWords.get("goods_id").toString());
                            JSONObject jsonObject1 = JSONObject.parseObject(goods_detail);
                            JSONArray goodsDetail = jsonObject1.getJSONObject("goods_detail_response").getJSONArray("goods_details");
                            if(goodsDetail.size() == 0){
                                PddGoodsService.deletePddGoods(jsonWords.get("goods_id").toString());
                            }else {
                                JSONObject o = goodsDetail.getJSONObject(0);
                                Integer coupon_remain_quantity = Integer.valueOf(o.get("coupon_remain_quantity").toString());
                                String goods_desc = (String) o.get("goods_desc");
                                String goods_gallery_urls = String.valueOf(o.get("goods_gallery_urls"));
                                PddGoodsService.updatePddGoods(jsonWords.get("goods_id").toString(), goods_desc, goods_gallery_urls, coupon_remain_quantity);
                            }*/
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static String getPddGoodsDetail(String goods_id){
        String goods_id_list = "["+goods_id+"]";
        JSONObject pddParameter = new JSONObject();
        pddParameter.put("client_id", client_id);
        pddParameter.put("data_type", "JSON");
        pddParameter.put("goods_id_list", goods_id_list);
        pddParameter.put("timestamp", String.valueOf(System.currentTimeMillis()));
        pddParameter.put("type", "pdd.ddk.goods.detail");
        pddParameter.put("sign", MD5Util.sign(StringUtil.createLinkString(pddParameter, client_secret), "utf-8").toUpperCase());
        HttpUtil httpUtil = new HttpUtil();
        String s = null;
        try {
            s = httpUtil.postGeneralUrl(url, "application/json", pddParameter.toString(), "utf-8");
            //System.out.println("拉取结果：" + s);
            return s;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    public static void getPddGoodsList(){
        String pddGoodsList = PddGoodsService.getPddGoods();
        JSONArray jsonArray2 = JSONObject.parseObject(pddGoodsList).getJSONObject("result").getJSONArray("rs");
        for (int i=0;i<jsonArray2.size();i++){
            JSONObject pddGoods = jsonArray2.getJSONObject(i);
            String goods_id = pddGoods.getString("goods_id");
            String pddGoodsDetail = getPddGoodsDetail(goods_id);
            JSONObject jsonObject1 = JSONObject.parseObject(pddGoodsDetail);
            JSONObject errorGoods = jsonObject1.getJSONObject("error_response");
            if(errorGoods ==null){
                JSONArray goodsDetail = jsonObject1.getJSONObject("goods_detail_response").getJSONArray("goods_details");
                if (goodsDetail.size() == 0) {
                    PddGoodsService.deletePddGoods(goods_id);
                } else {
                    JSONObject o = goodsDetail.getJSONObject(0);
                    int coupon_remain_quantity = 0;
                    if(null != o.get("coupon_remain_quantity")) {
                        coupon_remain_quantity = Integer.valueOf(o.get("coupon_remain_quantity").toString());
                        String goods_desc = (String) o.get("goods_desc");
                        String goods_gallery_urls = String.valueOf(o.get("goods_gallery_urls"));
                        PddGoodsService.updatePddGoods(goods_id, goods_desc, goods_gallery_urls, coupon_remain_quantity);
                    }else{
                        PddGoodsService.deletePddGoods(goods_id);
                    }
                }
            }

        }
    }
}
