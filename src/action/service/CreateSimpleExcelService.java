package action.service;

import cache.ResultPoor;
import common.Utils;

public class CreateSimpleExcelService  extends BaseService {

    /**
     * 订单导出表后台搂数据
     */
    public static String getOrderListExcel(String order_no,String nick_name,String transaction_no, String phone, String consignee,String submission_time,String logistics_numbers, String price_min,String price_max) throws Exception
    {
        StringBuffer sql = new StringBuffer();
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and o.order_no like '%").append(order_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and u.nick_name like '%").append(nick_name).append("%'");
        }
        if( transaction_no !=null && transaction_no !=""){
            transaction_no="'%"+transaction_no+"%'";
            sql.append(" AND trans.transaction_no LIKE ").append(transaction_no);
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and u.phone like '%").append(phone).append("%'");
        }
        if (consignee != null && !"".equals(consignee)) {
            sql.append(" and consignee like '%").append(consignee).append("%'");
        }
        if (submission_time != null && !"".equals(submission_time)) {
            String submission_time1 = Utils.transformToYYMMddHHmmss(submission_time);
            sql.append(" and submission_time like '%").append(submission_time1).append("%'");
        }
        if (logistics_numbers != null && !"".equals(logistics_numbers)) {
            sql.append(" and logistics_numbers like '%").append(logistics_numbers).append("%'");
        }
       /* if ((created_date != null && !created_date.equals("")) || (created_date_end != null && !created_date_end.equals(""))) {
            String start = Utils.transformToYYMMddHHmmss(created_date)+"000000";
            String end = Utils.transformToYYMMddHHmmss(created_date_end)+"000000";
            sql.append(" and created_date BETWEEN ").append(start).append(" and ").append(end);
        }*/
        if((price_min !=null && price_min !="") && (price_max !=null && price_max !="")){
            price_min=price_min.replace("-","").replace(":","").replace(" ","").substring(2,14);
            price_max=price_max.replace("-","").replace(":","").replace(" ","").substring(2,14);
            sql.append(" AND o.created_date > ").append(price_min).append(" AND o.created_date < ").append(price_max);
        }
        System.out.println("*************"+sql.toString());
        sql.append(" group by o.id order by o.created_date desc");
        int sid = BaseService.sendObjectBase(501, sql.toString());
        return ResultPoor.getResult(sid);
    }

    /**
     * 代购订单导出表后台搂数据
     */
    public static String getPurOrderListExcel(int userId,String orderNum,String transaction_no,String spuCode,String nick_name,String phoneNum,String sku_name,String purchasingOrder_source,String price_min,String price_max,String order_source,String order_Type,String status) throws Exception
    {
        StringBuffer sql=new StringBuffer();
        if( orderNum !=null && orderNum !=""){
            orderNum="'%"+orderNum+"%'";
            sql.append(" AND o.order_no LIKE ").append(orderNum);
        }
        if( transaction_no !=null && transaction_no !=""){
            transaction_no="'%"+transaction_no+"%'";
            sql.append(" AND trans.transaction_no LIKE ").append(transaction_no);
        }
        if( sku_name !=null && sku_name !=""){
            sku_name="'%"+sku_name+"%'";
            sql.append(" AND k.sku_name LIKE ").append(sku_name);
        }
        if( spuCode !=null && spuCode !=""){
            spuCode="'%"+spuCode+"%'";
            sql.append(" AND p.spu_code LIKE ").append(spuCode);
        }
        if(nick_name !=null && nick_name !=""){
            nick_name="'%"+nick_name+"%'";
            sql.append(" AND pur.nick_name LIKE ").append(nick_name);
        }
        if(phoneNum !=null && phoneNum !=""){
            phoneNum="'%"+phoneNum+"%'";
            sql.append(" AND u.phone LIKE ").append(phoneNum);
        }
        if(purchasingOrder_source !="0" && purchasingOrder_source !=null && purchasingOrder_source !=""){
            sql.append(" AND p.source_code = '").append(purchasingOrder_source).append("'");
        }
        if((price_min !=null && price_min !="") && (price_max !=null && price_max !="")){
            price_min=price_min.replace("-","").replace(":","").replace(" ","").substring(2,14);
            price_max=price_max.replace("-","").replace(":","").replace(" ","").substring(2,14);
            sql.append(" AND o.created_date > ").append(price_min).append(" AND o.created_date < ").append(price_max);
        }
        if(order_source !=null && order_source !=""){

            sql.append(" AND o.data_source = '").append(order_source).append("'");
        }
        if(order_Type !=null && order_Type !=""){
            if(order_Type.equals("-1")==true){
                sql.append(" AND pur.purchas_order_state IS NULL ");
            }else{
                sql.append(" AND pur.purchas_order_state = ").append(Integer.valueOf(order_Type));
            }
        }
        if(status !=null && status !=""){
            sql.append(" AND o.status = ").append(status);
        }
        //sql.append(" GROUP BY o.order_no ORDER BY o.created_date DESC");
        sql.append(" ORDER BY o.created_date DESC");
        int sid = BaseService.sendObjectBase(502, sql.toString());
        return ResultPoor.getResult(sid);
    }


    public static String getGoodsListExcel(String spuName,String goodsSource,String status, String cateName, String goodsTypeName,String spuCode) throws Exception
    {
        StringBuffer sql = new StringBuffer();
        if (spuName != null && !spuName.equals("")) {
            sql.append(" AND b_spu.spu_name LIKE '%").append(spuName).append("%'");
        }else if (goodsSource != null && !goodsSource.equals("")) {
            sql.append(" AND source_code = '").append(goodsSource).append("'");
        }else if (status != null && !status.equals("")) {
            sql.append(" AND b_spu.status = ").append(status);
        }else if (spuCode != null && !spuCode.equals("")) {
            sql.append(" AND b_spu.spu_code LIKE '%").append(spuCode).append("%'");
        }else{
            // 筛选条件为空 则选择 全部上架商品导出
            sql.append(" AND b_sku.sku_status = 1 ");
        }

       /* if ((created_date != null && !created_date.equals("")) || (created_date_end != null && !created_date_end.equals(""))) {
            String start = Utils.transformToYYMMddHHmmss(created_date)+"000000";
            String end = Utils.transformToYYMMddHHmmss(created_date_end)+"000000";
            sql.append(" and created_date BETWEEN ").append(start).append(" and ").append(end);
        }*/
//        if((price_min !=null && price_min !="") && (price_max !=null && price_max !="")){
////            price_min=price_min.replace("-","").replace(":","").replace(" ","").substring(2,14);
////            price_max=price_max.replace("-","").replace(":","").replace(" ","").substring(2,14);
////            sql.append(" AND o.created_date > ").append(price_min).append(" AND o.created_date < ").append(price_max);
////        }
        System.out.println("*************"+sql.toString());
        sql.append(" ORDER BY sort,edit_time desc");
        int sid = BaseService.sendObjectBase(410, sql.toString());
        return ResultPoor.getResult(sid);
    }


    /**
     * 掌小龙订单导出查询
     * @param orderNo
     * @param phone
     * @param price_min
     * @param price_max
     * @return
     */
    public static String getZhangDAZOrder(String orderNo,String goodsName,String status,String phone,String price_min,String price_max){
        StringBuffer sql = new StringBuffer();
        if(orderNo !=null && !"".equals(orderNo)){
            sql.append( " and order_no =").append(orderNo);
        }
        if(orderNo !=null && !"".equals(orderNo)){
            sql.append( " and goods_name like '%").append(goodsName).append("%'");
        }
        if(phone !=null && !"".equals(phone)){
            sql.append(" and phone =").append(phone);
        }
        if(status !=null && !"".equals(status)){
            sql.append(" and status =").append(status);
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and create_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" order by create_date desc");
        int sid = BaseService.sendObjectBase(610, sql.toString());
        return ResultPoor.getResult(sid);
    }
}
