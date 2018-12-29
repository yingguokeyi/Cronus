package action.service;

import cache.ResultPoor;
import common.StringHandler;
import common.Utils;

public class PddGoodsService extends BaseService {

    public static String addPddGoods(String goods_id,String goods_name,String goods_thumbnail_url,String goods_image_url,
                            int sold_quantity,int min_group_price,int min_normal_price,String mall_name,
                            int coupon_min_order_amount,int coupon_discount,
                            int coupon_total_quantity,int coupon_remain_quantity,String coupon_start_time,
                            String coupon_end_time,String promotion_rate,String goods_eval_score,String goods_eval_count,
                            String cat_ids,int opt_id,String opt_name,String goods_gallery_urls,String avg_desc,
                            String avg_lgst,String avg_serv,int merchant_type,String source_code){
        if("null" == goods_gallery_urls){
            goods_gallery_urls = "";
        }
       int sid = BaseService.sendObjectCreate(628, goods_id, goods_name, goods_thumbnail_url, goods_image_url, sold_quantity, min_group_price,min_normal_price,
               mall_name,coupon_min_order_amount,coupon_discount,coupon_total_quantity,coupon_remain_quantity,coupon_start_time,coupon_end_time,promotion_rate,goods_eval_score,
               goods_eval_count,cat_ids,opt_id,opt_name,goods_gallery_urls,avg_desc,avg_lgst,avg_serv,merchant_type,source_code);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String getPddGoodsList(String promotionRate,String goods_source,String spuCode,String skuName,String state,String price_min,String price_max,int begin, int end){
        StringBuffer sql = new StringBuffer();
        if(skuName !=null && !"".equals(skuName)){
            sql.append(" and goods_name like '%").append(skuName).append("%'");
        }
        if(state !=null && !"".equals(state)){
            sql.append(" and status = ").append(Integer.valueOf(state));
        }
        if(goods_source !=null && !"".equals(goods_source)){
            sql.append(" and opt_id = ").append(Integer.valueOf(goods_source));
        }
        if(spuCode !=null && !"".equals(spuCode)){
            sql.append(" and goods_id = ").append(spuCode);
        }
        if(price_min !=null && !"".equals(price_min)){
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and create_date between '").append(created_date1).append("'");
        }
        if(price_max !=null && !"".equals(price_max)){
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and '").append(created_date1).append("'");
        }
        if(promotionRate !=null && !"".equals(promotionRate)){
            if(promotionRate.equals("1")){
                sql.append(" and promotion_rate between 0 and 50");
            }
            if(promotionRate.equals("2")){
                sql.append(" and promotion_rate between 51 and 100");
            }
            if(promotionRate.equals("3")){
                sql.append(" and promotion_rate between 101 and 200");
            }
            if(promotionRate.equals("4")){
                sql.append(" and promotion_rate between 201 and 300");
            }
            if(promotionRate.equals("5")){
                sql.append(" and promotion_rate between 301 and 500");
            }
            if(promotionRate.equals("6")){
                sql.append(" and promotion_rate between 501 and 1000");
            }
        }
        sql.append(" group by goods_id");
        int sid = BaseService.sendObjectBase(629, sql.toString(), begin, end);
        String result = ResultPoor.getResult(sid);
        return StringHandler.getRetString(result);

    }

    public static String getPddGoodsByGoodsId(String goodsId){
        int i = BaseService.sendObject(630, goodsId);
        String result = ResultPoor.getResult(i);
        return result;
    }

    public static String updatePddGoods(String Goods_id,String goods_desc,String goods_image_url,int coupon_remain_quantity){
        int sid = sendObjectCreate(631, coupon_remain_quantity,goods_desc,goods_image_url, Goods_id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String updateGoods(String id,String state){
        String[] ids = id.split(",");
        int sid = 0;
        for (String id1 : ids) {
            sid = sendObjectCreate(634, state, id1);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String deletePddGoods(String goods_id){
        int i = sendObjectCreate(636, goods_id);
        return ResultPoor.getResult(i);
    }

    public static String getPddGoods(){
        int i = sendObject(637);
        return ResultPoor.getResult(i);
    }
}
