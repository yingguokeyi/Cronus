package action;


import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import action.service.AdvertisingService;
import action.service.OrderService;
import com.alibaba.fastjson.JSONObject;
import common.PropertiesConf;
import common.StringHandler;
import common.Utils;
import servlet.BaseServlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "Order", urlPatterns = "/order")
public class OrderAction extends BaseServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 查询全部订单列表
     * 2018/3/7 安蛋蛋
     *
     * @return
     */
    public String getOrderAll(String page, String limit) {

        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        return OrderService.getOrderAll((pageI - 1) * limitI, limitI);
    }

    /**
     * 根据字段查询订单
     * 2018/3/8 安蛋蛋
     *
     * @return
     */

    public String getOrderByField(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time,String logistics_numbers, String created_date, String price_min,String price_max, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = OrderService.getOrderByField(order_no,transaction_no, nick_name, phone, consignee, submission_time,logistics_numbers,created_date,price_min,price_max, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 根据id查询订单详情首页
     * 2018/3/9 安蛋蛋
     *
     * @return
     */
    public String getLineItemByOrderId(String id) {
        String res = OrderService.getLineItemByOrderId(id);
        return res;

    }

    /**
     * 根据id查询商品清单
     * 2018/3/9 安蛋蛋
     *
     * @return
     */
    public String getGoodsByOrderNo(String orderNo) {
        String rs=OrderService.getGoodsByOrderId(orderNo);
        return rs;

    }

    /**
     * 根据id查询物流信息
     * 2018/3/10 安蛋蛋
     *
     * @return
     */
    public String getLogisticsByOrderId(String id) {
        return OrderService.getLogisticsByOrderId(id);
    }

    /**
     * 根据id查询订单号
     * 2018/3/10 安蛋蛋
     *
     * @return
     */
    public String getOrderNoById(String id) {
        return OrderService.getOrderNoById(id);
    }

    /**
     * 添加异常订单信息
     * 2018/3/10 安蛋蛋
     *
     * @return
     */
    public String addAbnormalOrders(String order_no, String memo) {
        String rs=OrderService.addAbnormalOrders(order_no, memo);
        return rs;
    }

    /**
     * 查询待支付状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStatusPaid(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStatusPaid(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date,price_max,price_min, (pageI - 1) * limitI, limitI);

    }

    /**
     * 查询待备货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStatusStockUp(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStatusStockUp(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date, price_max,price_min,(pageI - 1) * limitI, limitI);

    }

    /**
     * 查询待提货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStatusWaitRecGoods(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStatusWaitRecGoods(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date,price_max, price_min, (pageI - 1) * limitI, limitI);
    }

    /**
     * 查询已提货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStatusRecGoods(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStatusRecGoods(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date,price_max,price_min, (pageI - 1) * limitI, limitI);

    }

    /**
     * 查询已完成状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStatusComp(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStatusComp(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date,price_max,price_min, (pageI - 1) * limitI, limitI);

    }

    /**
     * 查询已取消状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStatusCan(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time, String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStatusCan(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date,price_max,price_min, (pageI - 1) * limitI, limitI);

    }

    /**
     * 查询待发货状态订单
     * 2018/3/15 安蛋蛋
     *
     * @return
     */
    public String getOrderByStapendDeli(String order_no,String transaction_no, String nick_name, String phone, String consignee,String submission_time,String logistics_numbers, String created_date,String price_max,String price_min, String page, String limit) {
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        return OrderService.getOrderByStapendDeli(order_no,transaction_no, nick_name, phone, consignee,submission_time,logistics_numbers, created_date, price_max,price_min,(pageI - 1) * limitI, limitI);

    }

    /**
     * 根据id查询订单编号
     * 2018/3/16 安蛋蛋
     * getOrderNOById
     *
     * @return
     */
    public String getOrderById(String id) {
        String rs=OrderService.getOrderById(id);
        return rs;

    }

    /**
     * 提交物流信息
     * 2018/3/16 安蛋蛋
     * addLogistics
     *
     * @return
     */
    public String addLogistic(String jsonData) {
        String rs=OrderService.addLogistic(jsonData);
        return rs;

    }

    /**
     * 修改订单状态
     * 2018/3/16 安蛋蛋
     *updateStatus
     * @return
     */
   public String updateStatus(String id){
      String rs=OrderService.updateStatus(id);
       return rs;

    }
    /**
     * 根据id查询处理状态
     * 2018/3/21 安蛋蛋
     *
     * @return
     */
    public String getProStatus(String id) {
        String rs=OrderService.getProStatus(id);
        return rs;

    }
   /**
    * 添加处理状态
    * 2018/3/27 安蛋蛋
    *
    * @return
    */
   public String upDisposeStatus(String jsonData,String id){
       String rs=OrderService.upDisposeStatus(jsonData,id);
       return rs;

   }
    /**
     * 修改处理状态(已收货)
     * 2018/3/29 安蛋蛋
     *
     * @return
     */
    public String upProStatus(String id){
        String rs=OrderService.upProStatus(id);
        return rs;

    }

    /**
     * 查询提货收货状态
     * 2018/4/3 安蛋蛋
     *
     * @return
     */
    public static String getStatus(){
        String rs=OrderService.getStatus();
        return rs;

    }
    //根据id查询备货
    public String getStockStatus(String id){
        String rs=OrderService.getStockStatus(id);
        return rs;

    }

    //备货确认
    public String upStockUp(String jsonData, String id, HttpServletRequest request){
        int userId = StringHandler.getUserId(request);
        String rs=OrderService.upStockUp(jsonData,id,userId);
        return rs;
    }

    public String getOrderOnGoodsInfo(String order_no){
        String res = OrderService.getOrderOnGoodsInfo(order_no);
        return res;
    }

    /**
     * 查询退款订单列表
     */
    public String getRefundsOrder(String order_no,String transaction_no,String nick_name,String phone,String spu_name,
                                  String consignee,String goods_source,String price_min,String price_max, String page, String limit){
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = OrderService.getRefundsOrder(order_no,transaction_no, nick_name, phone, spu_name,consignee,
                goods_source,price_min,price_max, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 查询掌大赚订单列表
     * @param orderNo
     * @param phone
     * @param price_min
     * @param price_max
     * @param page
     * @param limit
     * @return
     */
    public String getzhangdzOrder(String userId,String orderNo,String goodsName,String phone,String status,String price_min,String price_max,String page, String limit){
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = OrderService.getzhangdzOrder(userId,orderNo, goodsName,phone, status,price_min, price_max, (pageI - 1) * limitI, limitI);
        return res;
    }


    public String updateZdzOrder(String orderNo,String orderId,String goodsName,String remark){
        JSONObject json = new JSONObject();
        if(!orderNo.matches("[0-9]+") || orderNo.length() !=18){
            json.put("state",0);
            json.put("msg","订单号应为18位纯数字！");
            return json.toString();
        }
        if("null".equals(goodsName) || null == goodsName){
            json.put("state",0);
            json.put("msg","请选择商品！");
            return json.toString();
        }
        String res = OrderService.updateZdzOrder(orderNo,orderId, goodsName,remark);
        json.put("state",1);
        json.put("msg","编辑成功");
        return json.toString();

    }

    //获取拼多多订单列表
    public String getPddOrderList(String order_sn,String goods_id,String goods_name,String order_status,String custom_parameters){
        return OrderService.getPddOrderList(order_sn,goods_id,goods_name,order_status,custom_parameters);
    }
}