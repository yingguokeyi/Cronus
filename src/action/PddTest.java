package action;

import action.service.GoodsService;
import action.service.PddGoodsService;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import servlet.BaseServlet;
import utils.HttpUtil;
import utils.MD5Util;
import utils.StringUtil;

import javax.servlet.annotation.WebServlet;


//@WebServlet(name = "pdd", urlPatterns = "/pddTest")
public class PddTest {
    static String client_id="39c29be29a1d4422a6328b3896975ff6";
    static String client_secret = "c13e59689c11838377f4ef86803f2be17feb47ea";
    static String url = "http://gw-api.pinduoduo.com/api/router";
    public static void main(String[] args) {

        //getPddGoodsDetail("2213290470");
        getPddGoodsDetail();
    }

    public void addP(String page){
        int i = Integer.valueOf(page);
        addPdd(i);

    }

    public void addPdd(int page){
        String client_id="39c29be29a1d4422a6328b3896975ff6";
        String client_secret = "c13e59689c11838377f4ef86803f2be17feb47ea";
        String url = "http://gw-api.pinduoduo.com/api/router";
        JSONObject pddParameter = new JSONObject();
        pddParameter.put("client_id",client_id);
        pddParameter.put("data_type","JSON");
        pddParameter.put("page",Integer.valueOf(page));
        pddParameter.put("sort_type",1);
        pddParameter.put("timestamp",String.valueOf(System.currentTimeMillis()));
        pddParameter.put("type","pdd.ddk.goods.search");
        pddParameter.put("with_coupon",true);
        pddParameter.put("sign", MD5Util.sign(StringUtil.createLinkString(pddParameter,client_secret), "utf-8").toUpperCase());
        System.out.println("sign: "+MD5Util.sign(StringUtil.createLinkString(pddParameter,client_secret), "utf-8").toUpperCase());
        HttpUtil  httpUtil = new HttpUtil();
        try {
            String s = httpUtil.postGeneralUrl(url, "application/json", pddParameter.toString(), "utf-8");
            System.out.println("拉取结果："+s);
            JSONObject pddGoodsResult = JSONObject.parseObject(s);
            Object goods_list = pddGoodsResult.get("goods_search_response");
            JSONObject jsonObject = JSONArray.parseObject(goods_list.toString());
            Object goods_list1 = jsonObject.get("goods_list");
            Object total_count = jsonObject.get("total_count");
            System.out.println("从拼多多——多多进宝商品共有："+total_count+" 件");
            JSONArray wordsArray = JSONArray.parseArray(goods_list1.toString());
            System.out.println("拉取第 "+page+" 页,商品件数为："+wordsArray.size());
            for (Object goods:wordsArray) {
                    JSONObject jsonWords = JSONObject.parseObject(goods.toString());
                Object opt_id = jsonWords.get("opt_id");
                int opt_ids;
                if(null != opt_id){
                    opt_ids = Integer.valueOf(jsonWords.get("opt_id").toString());
                }else {
                    opt_ids = 0;
                }
                //商品入库
                    /*PddGoodsService.addPddGoods(jsonWords.get("goods_id").toString(), jsonWords.get("goods_name").toString(),
                            jsonWords.get("goods_thumbnail_url").toString(), jsonWords.get("goods_image_url").toString(), Integer.valueOf(jsonWords.get("sold_quantity").toString()),
                            Integer.valueOf(jsonWords.get("min_group_price").toString()), Integer.valueOf(jsonWords.get("min_normal_price").toString()), jsonWords.get("mall_name").toString(),
                            Integer.valueOf(jsonWords.get("coupon_min_order_amount").toString()), Integer.valueOf(jsonWords.get("coupon_discount").toString()), Integer.valueOf(jsonWords.get("coupon_total_quantity").toString()),
                            Integer.valueOf(jsonWords.get("coupon_remain_quantity").toString()), jsonWords.get("coupon_start_time").toString(), jsonWords.get("coupon_end_time").toString(),
                            String.valueOf(jsonWords.get("promotion_rate")), String.valueOf(jsonWords.get("goods_eval_score")), String.valueOf(jsonWords.get("goods_eval_count")),
                            String.valueOf(jsonWords.get("cat_ids")), opt_ids,
                            String.valueOf(jsonWords.get("opt_name")), String.valueOf(jsonWords.get("goods_gallery_urls")),
                            String.valueOf(jsonWords.get("avg_desc")), String.valueOf(jsonWords.get("avg_lgst")),
                            String.valueOf(jsonWords.get("avg_serv")), Integer.valueOf(jsonWords.get("merchant_type").toString()));*/
                }

                //addPdd(++page);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void getPddGoodsDetail(){
        String pddGoodsList = PddGoodsService.getPddGoods();
        JSONArray jsonArray2 = JSONObject.parseObject(pddGoodsList).getJSONArray("rs");
        for (int i=0;i<jsonArray2.size();i++){
            JSONObject pddGoods = jsonArray2.getJSONObject(i);
           String goods_id = pddGoods.getString("goods_id");
            System.out.println("goods_id"+goods_id+"   "+i);

        }
    }

    public static  String getPddGoodsDetail(String goods_id){
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
            System.out.println("s:"+s);
            //System.out.println("拉取结果：" + s);
            JSONArray pddGoodsResults = JSONObject.parseObject(s).getJSONObject("goods_detail_response").getJSONArray("goods_details");
            JSONObject o = pddGoodsResults.getJSONObject(0);
            System.out.println("pdd:"+o);
            return s;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }
}
