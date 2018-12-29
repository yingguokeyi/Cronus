package action;

import action.service.BaseService;
import action.service.OrderService;
import com.alibaba.fastjson.JSONObject;
import common.Utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;

/**
 * Created by 18330 on 2018/8/17.
 */
public class PddOrderManager extends BaseService implements Runnable {

    String pddFormalUrl = "http://gw-api.pinduoduo.com/api/router";
    String clientId = "39c29be29a1d4422a6328b3896975ff6";
    String clientSecret = "c13e59689c11838377f4ef86803f2be17feb47ea";

    @Override
    public void run() {
        addPddOrder();
    }

    public void addPddOrder(){
        System.out.println(" -------------   拼多多订单定时任务zzz   ---------------" + LocalDateTime.now());
        long millis = System.currentTimeMillis();
        JSONObject pddObj = new JSONObject();
        pddObj.put("client_id",clientId);
        pddObj.put("data_type","JSON");
        pddObj.put("end_update_time",String.valueOf(millis/1000));
        pddObj.put("start_update_time",millis/1000 - 21600);
        pddObj.put("timestamp",String.valueOf(millis));
        pddObj.put("type","pdd.ddk.order.list.increment.get");
        pddObj.put("sign", Utils.MD5(Utils.createLinkString(pddObj,clientSecret)).toUpperCase());
        System.out.println(pddObj);
        StringBuffer json = new StringBuffer();
        PrintWriter out = null;
        try {
            URL url = new URL(pddFormalUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            // 发送POST请求必须设置如下两行
            connection.setDoOutput(true);
            connection.setDoInput(true);

            connection.setUseCaches(false);
            connection.setInstanceFollowRedirects(true);
            connection.setRequestMethod("POST"); // 设置请求方式
            connection.setRequestProperty("Content-Type", "application/json"); // 设置接收数据的格式
            connection.connect();

            out = new PrintWriter(connection.getOutputStream());
            out.print(pddObj.toString());
            // flush输出流的缓冲
            out.flush();
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    connection.getInputStream(),"utf-8"));

            String inputLine = null;
            while ( (inputLine = in.readLine()) != null) {
                json.append(inputLine);
            }
            System.out.println("json++++++++++++++++++"+json);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        JSONObject result = JSONObject.parseObject(json.toString());
        String total_count = result.getJSONObject("order_list_get_response").getString("total_count");
        for(int i=0;i<Integer.parseInt(total_count);i++){

            String order_sn = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_sn");
            String goods_id = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("goods_id");
            String goods_name = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("goods_name");
            String goods_thumbnail_url = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("goods_thumbnail_url");
            String goods_quantity = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("goods_quantity");
            String goods_price = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("goods_price");
            String order_amount = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_amount");
            String order_create_time = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_create_time");
            String promotion_rate = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("promotion_rate");
            String promotion_amount = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("promotion_amount");
            String order_status = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_status");
            String p_id = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("p_id");
            String order_status_desc = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_status_desc");
            String order_modify_at = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_modify_at");
            String order_group_success_time = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_group_success_time");
            String order_pay_time = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_pay_time");
            String order_verify_time = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_verify_time");
            String type = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("type");
            String custom_parameters = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("custom_parameters");
            String order_receive_time = result.getJSONObject("order_list_get_response").getJSONArray("order_list").getJSONObject(i).getString("order_receive_time");

            String userId = "";
            if(custom_parameters !=null && !"".equals(custom_parameters)){
                String pddOrderUserId = OrderService.getPddOrderUserId(custom_parameters);
                JSONObject jsonObject = JSONObject.parseObject(pddOrderUserId);
                int rs = jsonObject.getJSONArray("rs").size();
                if(rs!=0){
                    userId = jsonObject.getJSONArray("rs").getJSONObject(0).getString("id");
                }
            }

            String pddOrderOrderInsert = OrderService.getPddOrderSnInsert(order_sn);
            JSONObject reInsert = JSONObject.parseObject(pddOrderOrderInsert);
            int rsInsert = reInsert.getJSONArray("rs").size();

            String pddOrderOrderUpdate = OrderService.getPddOrderUpdate(order_sn,order_modify_at);
            JSONObject reUpdate = JSONObject.parseObject(pddOrderOrderUpdate);
            int rsUpdate = reUpdate.getJSONArray("rs").size();

            if(rsInsert==0){
                OrderService.addPddOrderGoodsInfo(order_sn, goods_id, goods_name, goods_thumbnail_url, goods_quantity, goods_price, order_amount, order_create_time, promotion_rate,
                        promotion_amount, order_status, p_id, order_status_desc, order_modify_at, order_group_success_time, order_pay_time, order_verify_time, type, custom_parameters, order_receive_time,userId);
            }

            if(rsUpdate==1){
                OrderService.updatePddOrderSn(order_status,order_status_desc,order_verify_time,order_receive_time,order_pay_time,order_group_success_time,order_modify_at,order_sn);
            }


        }
        long delmillis = System.currentTimeMillis()/1000-86400;
        OrderService.delPddPendingPayOrder(String.valueOf(delmillis));
        System.out.println(" -------------   拼多多订单定时任务结束   ---------------start tme  form  " + LocalDateTime.now());

        System.out.println(" -------------   拼多多订单定时任务zzz  结束   ---------------" + LocalDateTime.now());
    }
}
