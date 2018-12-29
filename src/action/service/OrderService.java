package action.service;

import action.sqlhelper.OrderSql;
import cache.ResultPoor;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.BaseCache;
import common.StringHandler;
import common.Utils;
import model.PurchaseOrderImport;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class OrderService extends BaseService {


    /**
     * 查询全部订单列表
     * 2018/3/7 安蛋蛋
     *
     * @return
     */
    public static String getOrderAll(int begin, int end) {
        int selectAllSid = sendObject(111, begin, end);
        String rsOrgAll = ResultPoor.getResult(selectAllSid);
        String rsOrgAllJson = StringHandler.getRetString(rsOrgAll);
        return rsOrgAllJson;
    }

    /**
     * 根据字段查询订单
     * 2018/3/8 安蛋蛋
     * aaa
     *
     * @return
     */
    public static String getOrderByField(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time,String logistics_numbers, String created_date, String price_min,String price_max,int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByField_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and o.order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and u.nick_name like '%").append(nick_name).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" group by o.id order by o.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        System.out.println(sid);
        String res = StringHandler.getRetString(ResultPoor.getResult(sid));
        return res;
    }

    /**
     * 根据id查询订单详情首页
     * 2018/3/9 安蛋蛋
     *
     * @return
     */
    public static String getLineItemByOrderId(String id) {
        int selectByOrderId = sendObject(114, id);
        String rsOrdLineItem = ResultPoor.getResult(selectByOrderId);
        return rsOrdLineItem;
    }

    /**
     * 根据id查询商品清单
     * 2018/3/9 安蛋蛋
     *
     * @return
     */
    public static String getGoodsByOrderId(String orderNo) {
        int selectGoodsByOrderId = sendObject(115, orderNo);
        String rsOrdGoods = ResultPoor.getResult(selectGoodsByOrderId);
        String rsOrgAllJson = StringHandler.getRetString(rsOrdGoods);
        return rsOrgAllJson;
    }

    /**
     * 根据id查询物流信息
     * 2018/3/10 安蛋蛋
     *
     * @return
     */
    public static String getLogisticsByOrderId(String id) {
        int selectLogisticsByOrderId = sendObject(116, id);
        String rsOrdLogistics = ResultPoor.getResult(selectLogisticsByOrderId);
        String rsOrgAllJson = StringHandler.getRetString(rsOrdLogistics);
        return rsOrgAllJson;
    }

    /**
     * 根据id查询订单号
     * 2018/3/10 安蛋蛋
     *
     * @return
     */
    public static String getOrderNoById(String id) {
        int selectOrderNoById = sendObject(117, id);
        String rsOrdNoById = ResultPoor.getResult(selectOrderNoById);
        String rsOrgAllJson = StringHandler.getRetString(rsOrdNoById);
        return rsOrgAllJson;
    }

    /**
     * 添加异常订单信息
     * 2018/3/10 安蛋蛋
     *
     * @return
     */
    public static String addAbnormalOrders(String order_no, String memo) {
        int selectAbnormalOrders = sendObject(118, order_no, memo);
        String rsAbnormalOrders = ResultPoor.getResult(selectAbnormalOrders);
        return rsAbnormalOrders;
    }

    /**
     * 查询待支付状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStatusPaid(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStaPaid_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }

        sql.append(" order by orderInfo.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询待备货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStatusStockUp(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStaWaitGoods_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }

        sql.append(" order by o.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询待提货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStatusWaitRecGoods(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStaWaitRecGoods_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" order by o.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询已提货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStatusRecGoods(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStaRecGoods_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" order by o.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询已完成状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStatusComp(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStaComp_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append("GROUP BY o.order_no ");
        sql.append(" order by o.created_date desc");

        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询已取消状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStatusCan(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStaCan_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" order by o.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询待发货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public static String getOrderByStapendDeli(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, int begin, int end) {
        StringBuffer sql = new StringBuffer();
        sql.append(OrderSql.getOrderByStapendDeli_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and t.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
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
        if (created_date != null && !"".equals(created_date)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(created_date);
            sql.append(" and created_date like '%").append(created_date1).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" GROUP BY o.id order by o.created_date desc");
        int sid = BaseService.sendObjectBase(9997, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 根据id查询订单编号
     * 2018/3/17 安蛋蛋
     *
     * @return
     */
    public static String getOrderById(String id) {
        int selectGoodsByOrderId = sendObject(121, id);
        String rsOrdGoods = ResultPoor.getResult(selectGoodsByOrderId);
        String rsOrgAllJson = StringHandler.getRetString(rsOrdGoods);
        return rsOrgAllJson;
    }

    /**
     * 提交物流信息
     * 2018/3/17 安蛋蛋
     *
     * @return
     */
    public static String addLogistic(String jsonData) {
        //获取参数
        JSONObject JO = JSONObject.parseObject(jsonData);
        int order_id = Integer.valueOf((JO.get("order_id") == null ||"".equals(JO.get("order_id")) ? "" : (JO.get("order_id").toString())));
        String logistics_numbers = (JO.get("logistics_numbers") == null ||"".equals(JO.get("order_id")) ? "" : (JO.get("logistics_numbers").toString()));
        String memo = (JO.get("memo") == null ||"".equals(JO.get("order_id"))? "" : (JO.get("memo").toString()));
        int addLogistics = sendObjectCreate(119, order_id, logistics_numbers, memo);
        String data = ResultPoor.getResult(addLogistics);
        //添加物流单号成功，订单需要更新到待提货状态
        String submission_time =BaseCache.getTIME();
        int updateStatus = sendObjectCreate(196, submission_time, order_id);
        ResultPoor.getResult(updateStatus);
        return data;
    }

    /**
     * 修改订单状态
     * 2018/3/17 安蛋蛋
     *
     * @return
     */
    public static String updateStatus(String id) {
        Date date=new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date2 = df.format(date);
        String submission_time =Utils.transformToYYMMddHHmmss(date2);
        System.out.println(submission_time);
        System.out.println("=================="+submission_time);
        int updateStatus = sendObjectCreate(122,submission_time,id);
        String rs = ResultPoor.getResult(updateStatus);
        return rs;
    }

    /**
     * 根据id查询处理状态
     * 2018/3/21 安蛋蛋
     *
     * @return
     */
    public static String getProStatus(String id) {
        int selectProStatusByOrderId = sendObject(123, id);
        String rsOrdProStatus = ResultPoor.getResult(selectProStatusByOrderId);
        String rs = StringHandler.getRetString(rsOrdProStatus);
        return rs;
    }

    /**
     * 添加处理状态
     * 2018/3/27 安蛋蛋
     *
     * @return
     */
    public static String upDisposeStatus(String jsonData,String id) {
        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        String idInt = (jsonObject.get("id") == null ? "" : jsonObject.get("id").toString());
        String dispose_way_key = (jsonObject.get("dispose_way_key") == null ? "" : jsonObject.get("dispose_way_key").toString());
        String memo = (jsonObject.get("memo") == null ? "" : jsonObject.get("memo").toString());
        int sid = sendObjectCreate(124, dispose_way_key, memo,idInt);
        String result = ResultPoor.getResult(sid);
        return result;
    }
    /**
     * 修改处理状态(已收货)
     * 2018/3/29 安蛋蛋
     *
     * @return
     */
    public static String upProStatus(String id) {
        int upProStatus = sendObjectCreate(125, id);
        String rsUpSta = ResultPoor.getResult(upProStatus);
        return rsUpSta;
    }
    /**
     * 查询提货收货状态
     * 2018/4/3 安蛋蛋
     *
     * @return
     */
    public static String getStatus() {
        int getStatus = sendObject(130);
        String rs = ResultPoor.getResult(getStatus);
        return rs;
    }
    //根据id查询备货
    public static String getStockStatus(String id){
        int sid = sendObject(133,id);
        String getStockStatus= ResultPoor.getResult(sid);
        String rs = StringHandler.getRetString(getStockStatus);
        return rs;
    }
    //备货确认
    public static String upStockUp(String jsonData,String id,int userId){
        JSONObject jsonObject = JSONObject.parseObject(jsonData);
        String idInt = (jsonObject.get("id") == null ? "" : jsonObject.get("id").toString());
        String memo = (jsonObject.get("memo") == null ? "" : jsonObject.get("memo").toString());
        String time= BaseCache.getTIME();
        int upStockUp = sendObjectCreate(131,104,memo,userId,time,idInt);
        String rs = ResultPoor.getResult(upStockUp);
        return rs;
    }

    public static String getOrderOnGoodsInfo(String order_no){
        int sid = BaseService.sendObject(244, order_no);
        String res = StringHandler.getRetString(ResultPoor.getResult(sid));
        return res;
    }

    /**
     * 查询退款订单列表
     * 2018/6/8 安蛋蛋
     *
     * @return
     */
    public static String getRefundsOrder(String order_no,String transaction_no,String nick_name,String phone,String spu_name,
                                         String consignee,String goods_source,String price_min,String price_max,int begin, int end) {
        StringBuffer sql = new StringBuffer();
        //sql.append(OrderSql.getOrderByStapendDeli_sql);
        if (order_no != null && !order_no.equals("")) {
            sql.append(" and refunds.order_no like '%").append(order_no).append("%'");
        }
        if (transaction_no != null && !transaction_no.equals("")){
            sql.append(" and trans.transaction_no like '%").append(transaction_no).append("%'");
        }
        if (nick_name != null && !nick_name.equals("")) {
            sql.append(" and userInfo.nick_name like '%").append(nick_name).append("%'");
        }
        if (phone != null && !"".equals(phone)) {
            sql.append(" and phone like '%").append(phone).append("%'");
        }
        if (consignee != null && !"".equals(consignee)) {
            sql.append(" and consignee like '%").append(consignee).append("%'");
        }
        if (spu_name != null && !"".equals(spu_name)) {
            sql.append(" and spu_name like '%").append(spu_name).append("%'");
        }
        if (goods_source != null && !"".equals(goods_source)) {
            sql.append(" and goods_source like '%").append(goods_source).append("%'");
        }
        if (price_min != null && !"".equals(price_min)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_min);
            sql.append(" and created_date between '").append(created_date1).append("'");
        }
        if (price_max != null && !"".equals(price_max)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(price_max);
            sql.append(" and '").append(created_date1).append("'");
        }
        sql.append(" order by refunds.create_date desc");
        int sid = BaseService.sendObjectBase(601, sql.toString(), begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    /**
     * 查询掌大赚订单列表
     * @param orderNo
     * @param phone
     * @param price_min
     * @param price_max
     * @return
     */
    public static String getzhangdzOrder(String userId,String orderNo,String goodsName,String phone,String state,String price_min,String price_max,int begin, int end){
        /*Date date=new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date2 = df.format(date);
        String orderDate = Utils.transformToYYMMddHHmmss(date2);*/
        StringBuffer sql = new StringBuffer();
        if(userId !=null && !"".equals(userId)){
            sql.append( " and user_id =").append(userId);
        }
        if(orderNo !=null && !"".equals(orderNo)){
            sql.append( " and order_no =").append(orderNo);
        }
        if(goodsName !=null && !"".equals(goodsName)){
            sql.append( " and goods_name like'%").append(goodsName).append("%'");
        }
        if(phone !=null && !"".equals(phone)){
            sql.append(" and phone =").append(phone);
        }
        if(state !=null && !"".equals(state)){
            sql.append( " and status =").append(state);
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
        int sid = BaseService.sendObjectBase(603, sql.toString(), 0,begin, end);
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }


    public static String updateStatusByNum(String waybill_no) {
        int sid = sendObjectCreate(706, waybill_no);
        String str = ResultPoor.getResult(sid);
        return str;
    }

    public static String updateZdzOrder(String orderNo,String orderId,String goodsId,String remark){
        int sd = sendObject(613, goodsId);
        String result = ResultPoor.getResult(sd);
        JSONArray jsonArray1 = JSONObject.parseObject(result).getJSONObject("result").getJSONArray("rs");
        String sku_name = jsonArray1.getJSONObject(0).getString("sku_name");
        String bounty = jsonArray1.getJSONObject(0).getString("bounty");
        if("".equals(bounty)){
            bounty = "0";
        }
        //1查询原有订单的奖励金和商品id
        int sid1 = sendObject(626, orderId);
        String results = ResultPoor.getResult(sid1);
        JSONArray jsonArray2 = JSONObject.parseObject(results).getJSONObject("result").getJSONArray("rs");
        int sid = 0;
        if(jsonArray2.size() != 0) {
            String bounty1 = jsonArray2.getJSONObject(0).getString("member_self_money");
            String goodsId1 = jsonArray2.getJSONObject(0).getString("goods_id");
            String userId = jsonArray2.getJSONObject(0).getString("user_id");
            //2查询该用户钱包
            int wallet = sendObject(616, userId);
            String userWallets = ResultPoor.getResult(wallet);
            JSONArray userWallet = JSONObject.parseObject(userWallets).getJSONObject("result").getJSONArray("rs");
            JSONObject userWallet3 = userWallet.getJSONObject(0);
            String totalPreIncomes = userWallet3.getString("totalPreIncome");
            String zdzPreIncomes = userWallet3.getString("zdz_money");
            //3判断更改是商品还是商品价格
            if (!goodsId1.equals(goodsId)) {
                String endtotalPreIncome = moneySub(totalPreIncomes, bounty1);
                String zdzPreIncome = moneySub(zdzPreIncomes, bounty1);
                sendObjectCreate(620, endtotalPreIncome, zdzPreIncome, userId);
                sid = sendObjectCreate(614, sku_name, remark, orderNo, bounty, goodsId, 0, orderId);
            } else {
                sid = sendObjectCreate(614, sku_name, remark, orderNo, bounty1, goodsId, 1, orderId);
            }
        }else {
            sid = sendObjectCreate(614, sku_name, remark, orderNo, bounty, goodsId, 0, orderId);
        }
        String str = ResultPoor.getResult(sid);
        return str;
    }

    /**
     * 金额相减
     *
     * @param valueStr
     *            基础值
     * @param minusValueStr
     *            减数
     * @return
     */
    public static DecimalFormat fnum = new DecimalFormat("##0.00");
    public static String moneySub(String valueStr, String minusStr) {
        BigDecimal value = new BigDecimal(valueStr);
        BigDecimal subtrahend = new BigDecimal(minusStr);
        return fnum.format(value.subtract(subtrahend));
    }

    //查询拼多多订单列表
    public static String getPddOrderList(String order_sn,String goods_id,String goods_name,String order_status,String custom_parameters){
        StringBuffer sql = new StringBuffer();
        if(order_sn !=null && !"".equals(order_sn)){
            sql.append(" and order_sn like '%").append(order_sn).append("%'");
        }
        if(goods_id !=null && !"".equals(goods_id)){
            sql.append(" and goods_id = ").append(goods_id);
        }
        if(goods_name !=null && !"".equals(goods_name)){
            sql.append(" and goods_name like '%").append(goods_name).append("%'");
        }
        if(order_status !=null && !"".equals(order_status)){
            if("0".equals(order_status)){
                sql.append(" and order_status in (0,1)");
            }else{
                sql.append(" and order_status =").append(order_status);
            }
        }else{
            sql.append(" and order_status in (-1,0,1,2)");
        }
        if(custom_parameters !=null && !"".equals(custom_parameters)){
            sql.append(" and custom_parameters like '%").append(custom_parameters).append("%'");
        }
        sql.append(" order by order_modify_at desc");
        int sid = sendObjectBase(733,sql.toString());
        String rsResult = ResultPoor.getResult(sid);
        return StringHandler.getRetString(rsResult);
    }

    //查询拼多多订单
    public static String getPddOrderUpdate(String order_sn,String order_modify_at){
        int selectOrderSn = sendObject(734, order_sn,order_modify_at);
        String rsOrderSn = ResultPoor.getResult(selectOrderSn);
        String rs = StringHandler.getRetString(rsOrderSn);
        return rs;
    }

    //查询拼多多订单用户ID
    public static String getPddOrderUserId(String custom_parameters){
        int selectOrderUserId = sendObject(517, custom_parameters);
        String userId = ResultPoor.getResult(selectOrderUserId);
        String rs = StringHandler.getRetString(userId);
        return rs;
    }

    public static String getPddOrderSnInsert(String order_sn){
        int selectOrderSn = sendObject(737, order_sn);
        String rsOrderSn = ResultPoor.getResult(selectOrderSn);
        String rs = StringHandler.getRetString(rsOrderSn);
        return rs;
    }

    //添加拼多多订单信息
    public static String addPddOrderGoodsInfo(String order_sn,String goods_id,String goods_name,String goods_thumbnail_url,String goods_quantity,String goods_price,String order_amount,
                 String order_create_time,String promotion_rate,String promotion_amount,String order_status,String p_id,String order_status_desc,String order_modify_at,String order_group_success_time,
                 String order_pay_time,String order_verify_time,String type,String custom_parameters,String order_receive_time,String userId){
        if( order_verify_time == null){
            order_verify_time = "";
        }
        if(order_receive_time == null){
            order_receive_time = "";
        }
        if(order_pay_time== null){
            order_pay_time = "";
        }
        if(order_group_success_time == null){
            order_group_success_time = "";
        }
        int sid = sendObjectCreate(735,order_sn,goods_id,goods_name,goods_thumbnail_url,Integer.parseInt(goods_quantity),Integer.parseInt(goods_price),Integer.parseInt(order_amount),order_create_time,
                Integer.parseInt(promotion_rate),Integer.parseInt(promotion_amount),Integer.parseInt(order_status),p_id,order_status_desc,order_modify_at,order_group_success_time,order_pay_time,order_verify_time,Integer.parseInt(type),custom_parameters,order_receive_time,userId);
        String result = ResultPoor.getResult(sid);
        return result;
    }
    //修改拼多多订单信息
    public static String updatePddOrderSn(String order_status,String order_status_desc,String order_verify_time,String order_receive_time,String order_pay_time,String order_group_success_time,String order_modify_at,String order_sn){

        if( order_verify_time == null){
            order_verify_time = "";
        }
        if(order_receive_time == null){
            order_receive_time = "";
        }
        if(order_pay_time== null){
            order_pay_time = "";
        }
        if(order_group_success_time == null){
            order_group_success_time = "";
        }
        int sid = sendObjectCreate(736,Integer.parseInt(order_status),order_status_desc,order_verify_time,order_receive_time,order_pay_time,order_group_success_time,order_modify_at,order_sn);
        String result = ResultPoor.getResult(sid);
        return result;
    }
    //删除拼多多待支付订单
    public static String delPddPendingPayOrder(String delmillis){
        int sid = sendObjectCreate(738,delmillis);
        String result = ResultPoor.getResult(sid);
        return result;
    }
}