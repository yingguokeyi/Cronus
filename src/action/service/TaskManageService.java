package action.service;

import com.alibaba.fastjson.JSONObject;

import cache.ResultPoor;
import common.BaseCache;
import common.StringHandler;
import common.kuaidi.ExpressPush;

public class TaskManageService extends BaseService{

    /**
     * 任务列表_获取数据
     * 逍遥子_20180328
     * @param begin
     * @param end
     * @param orderNum
     * @param nick_name
     * @param phoneNum
     * @param purchasingOrder_source
     * @param price_min
     * @param price_max
     * @param order_source
     * @param order_Type
     * @return
     */

    public static String getSkipTasksInfo(int begin,int end,String orderNum,String transaction_no,String spuCode,String nick_name,String phoneNum,String purchasingOrder_source,String price_min,String price_max,String order_source,String order_Type,String status,String sku_name){
        StringBuffer sql=new StringBuffer();
        int sid=0;
        if( orderNum !=null && orderNum !=""){
            orderNum="'%"+orderNum+"%'";
            sql.append(" AND orderInfo.order_no LIKE ").append(orderNum);
        }
        if( transaction_no !=null && transaction_no !=""){
            transaction_no="'%"+transaction_no+"%'";
            sql.append(" AND trans.transaction_no LIKE ").append(transaction_no);
        }
        if( spuCode !=null && spuCode !=""){
            spuCode="'%"+spuCode+"%'";
            sql.append(" AND spu.spu_code LIKE ").append(spuCode);
        }
        if(nick_name !=null && nick_name !=""){
            nick_name="'%"+nick_name+"%'";
            sql.append(" AND pur_userInfo.nick_name LIKE ").append(nick_name);
        }
        if(phoneNum !=null && phoneNum !=""){
            phoneNum="'%"+phoneNum+"%'";
            sql.append(" AND pur_userInfo.phone LIKE ").append(phoneNum);
        }
        if(purchasingOrder_source !="0" && purchasingOrder_source !=null && purchasingOrder_source !=""){
            sql.append(" AND spu.source_code = '").append(purchasingOrder_source).append("'");
        }
        if((price_min !=null && price_min !="") && (price_max !=null && price_max !="")){
            price_min=price_min.replace("-","").replace(":","").replace(" ","").substring(2,14);
            price_max=price_max.replace("-","").replace(":","").replace(" ","").substring(2,14);
            sql.append(" AND orderInfo.created_date > ").append(price_min).append(" AND orderInfo.created_date < ").append(price_max);
        }
        if(order_source !=null && order_source !=""){

            sql.append(" AND orderInfo.data_source = '").append(order_source).append("'");
        }
        if(order_Type !=null && order_Type !=""){
            if(order_Type.equals("-1")==true){
                sql.append(" AND pur_order.purchas_order_state IS NULL ");
            }else{
                sql.append(" AND pur_order.purchas_order_state = ").append(Integer.valueOf(order_Type));
            }
        }
        if(status !=null && status !=""){
            sql.append(" AND orderInfo.status = ").append(status);

        }
        if(sku_name !=null && sku_name !=""){
            sku_name="'%"+sku_name+"%'";
            sql.append(" AND sku.sku_name LIKE ").append(sku_name);
        }
            //代购订单表里展现的必须是已经确认支付的订单信息 所以必须加上判断
            //sql.append(" GROUP BY orderInfo.order_no ORDER BY orderInfo.created_date DESC");
        sql.append(" ORDER BY orderInfo.created_date DESC");
        sid = sendObjectBase(222,sql.toString(),begin,end);
        String rsGoodsClassifyInfo = ResultPoor.getResult(sid);
        String rsFinanceJson= StringHandler.getRetString(rsGoodsClassifyInfo);
        return rsFinanceJson;
    }


    /**
     * 获取指派任务的员工信息
     * 逍遥子_20180330
     * @param begin
     * @param end
     * @param department_id
     * @param userId
     * @return
     */
    public static String getPurchaserList(int begin,int end,int department_id,int userId,String dep_name,String user_name){
        String sql="";
        String rsFinanceJson="";
        /*if((dep_name!=null && dep_name !="") || (user_name!=null && user_name !="")){*/
            if((dep_name!=null && dep_name !="") && (user_name!=null && user_name !="")){
                sql+=" WHERE";
                sql+=" dep.id = "+Integer.valueOf(dep_name);
                sql+=" And userInfo.nick_name LIKE '%"+user_name+"%'";
            }else{
                if((dep_name!=null && dep_name !="") || (user_name!=null && user_name !="")){
                    if(dep_name!=null && dep_name !=""){
                        sql+=" WHERE";
                        sql+=" dep.id = "+Integer.valueOf(dep_name);
                    }
                    if(user_name!=null && user_name !=""){
                        sql+=" WHERE";
                        sql+=" userInfo.nick_name LIKE '%"+user_name+"%'";
                    }
                }
            }

            sql+=" ORDER BY userInfo.job_number";
            int sid = sendObjectBase(230,sql,begin,end);
            String rsGoodsClassifyInfo = ResultPoor.getResult(sid);
            rsFinanceJson= StringHandler.getRetString(rsGoodsClassifyInfo);
       /* }else{
        }*/

        return rsFinanceJson;
    }

    /**
     * 指派任务
     * 逍遥子_20180330
     * @param id
     * @param order_ids
     * @param userId
     * @return
     */
    public static String appointedTask(String id,String order_ids,int userId){
        String[] order_id = order_ids.split(",");
        String rsTest="";
        int status= 103;
        for (String id1 : order_id) {
            String order_no=getAppointedTaskToOrderInfo(id1);
            String time= BaseCache.getDateTime();
            int order_idnum=Integer.valueOf(id1);
            int purchaser_id=Integer.valueOf(id);
            int pur_id = getPurchasingOrderToOrder_ID(id1);
            int addSid = 0;
            if(pur_id ==0){
                addSid = sendObjectCreate(232,order_idnum,order_no,purchaser_id,1,userId,time);
                sendObjectCreate(612,status,order_idnum);
            }else{
            }
            rsTest = ResultPoor.getResult(addSid);
        }
        return rsTest;
    }

    /**
     * 获取指派任务订单的详细信息
     * 逍遥子_20180330
     * @param order_id
     * @return
     */
    public static String getAppointedTaskToOrderInfo(String order_id){
        int sid = sendObject(231,order_id);
        String order_no = getFieldValue(ResultPoor.getResult(sid), "order_no",String.class).toString();
        return order_no;
    }


    /**
     * 获取订单详情信息
     * 逍遥子_20180403
     * @param obj
     * @return
     */
    public static String getSkipTasksDetailInfo(String obj,String pur_id){
        int sid = 0;
        if(pur_id.equals("")){
            sid = sendObject(600, obj);
        }else {
            sid = sendObject(235, obj, pur_id);
        }
        String rsGoodsClassifyInfo = ResultPoor.getResult(sid);
        String rsFinanceJson = StringHandler.getRetString(rsGoodsClassifyInfo);
        return rsFinanceJson;
    }

    /**
     * 获取代购平台信息
     * 逍遥子_20180404
     * @return
     */
    public static String getPurchasingTerraceInfo(){
         int sid = sendObject(234,"商品来源");
        String rsGoodsClassifyInfo = ResultPoor.getResult(sid);
        return rsGoodsClassifyInfo;
    }

    /**
     * 保存代购信息
     * 逍遥子_20180408
     * @param order_id
     * @param jsonString
     * @return
     */
    public static String saveSkipTasksDetailInfo(String order_id,String jsonString,int userId){
        String res=SkipTasksDetailInfo(jsonString);
        //res为空字符串，说明参数通过了校验
        if(res.equals("")){
            String time=BaseCache.getDateTime();
            //判断该订单在是否已经加入代购订单表
            //int pur_id = getPurchasingOrderToOrder_ID(order_id);

            JSONObject jsonObject = JSONObject.parseObject(jsonString);
            String order_no2 = jsonObject.get("order_no2").toString();
            String purchasing_terrace = jsonObject.get("purchasing_terrace").toString();
            String[] purchasing_terrace_array = purchasing_terrace.split(",");
            // 测试数据 9.9  19.9 通过
            String actual_payment_money = jsonObject.get("actual_payment_money").toString();
            String[] actual_payment_money_array = actual_payment_money.split(",");
            String purchase_order_no = jsonObject.get("purchase_order_no").toString();
            String[] purchase_order_no_array = purchase_order_no.split(",");
            String waybill_no = jsonObject.get("waybill_no").toString();
            String[] waybill_no_array = waybill_no.split(",");
            String purchasing_terrace_no = jsonObject.get("purchasing_terrace_no").toString();
            String[] purchasing_terrace_no_array = purchasing_terrace_no.split(",");
            String substituter = jsonObject.get("substituter").toString();
            String[] substituter_array = substituter.split(",");
            String express_company = jsonObject.get("express_company").toString();
            String[] express_company_array = express_company.split(",");
            String order_error_marker = jsonObject.get("order_error_marker").toString();
            String order_error = jsonObject.get("order_error_hide").toString();
            String purchas_order_state = jsonObject.get("purchas_order_state").toString();
            Object purchas_order_id1 = jsonObject.get("purchas_order_id");
            //代购数量和购运费
            String Purchase_number = jsonObject.get("purchase_number").toString();
            String[] Purchase_number_array = Purchase_number.split(",");
            String purchasing_freight = jsonObject.get("purchase_freight").toString();
            String[] purchasing_freight_array = purchasing_freight.split(",");

            //String purchas_order_id= jsonObject.get("purchas_order_id").toString();

            System.out.println(purchas_order_id1);

            int commission_Int=0;
            int save_status = 0;
            for (int i=0;i<purchasing_terrace_array.length;i++) {
                if(!"\"\"".equals(purchasing_terrace_array[i]) && !"\"\"]".equals(purchasing_terrace_array[i])){
                    //根据运单号waybill_no 确定代购订单状态
                    int state= 0;
                    if(!purchas_order_state.equals('4')||!purchas_order_state.equals('5')){
                        if(waybill_no_array[0].equals("")||express_company_array[0].equals("")){
                            state=2;
                        }else{
                            state=3;
                        }
                    }else{
                        state = Integer.valueOf(purchas_order_state);
                    }

                    String purchasing_terrace_resoult = null;
                    String substring1 = null;
                    String purchase_order_no_resoult = null;
                    String purchasing_terrace_no_resoult = null;
                    String substituter_array_resoult = null;
                    String waybill_no_array_resoult = null;
                    String express_company_array_resoult =null;
                    String Purchase_number_array_resoult = null;
                    String purchasing_freight_array_resoult = null;
                    if(purchasing_terrace_array.length>1) {
                        //代购平台
                        String pur = purchasing_terrace_array[i];
                        String substring2 = pur.substring(pur.indexOf('"') + 1);
                         purchasing_terrace_resoult = substring2.substring(0, substring2.lastIndexOf('"'));
                        //支付金额
                        String s = actual_payment_money_array[i];
                        String substring = s.substring(s.indexOf('"') + 1);
                         substring1 = substring.substring(0, substring.lastIndexOf('"'));
                        //代购订单号
                        String pur1 = purchase_order_no_array[i];
                        String substring3 = pur1.substring(pur1.indexOf('"') + 1);
                         purchase_order_no_resoult = substring3.substring(0, substring3.lastIndexOf('"'));
                        //下单帐号
                        String pur2 = purchasing_terrace_no_array[i];
                        String substring4 = pur2.substring(pur2.indexOf('"') + 1);
                         purchasing_terrace_no_resoult = substring4.substring(0, substring4.lastIndexOf('"'));
                        //代付人
                        String pur3 = substituter_array[i];
                        String substring5 = pur3.substring(pur3.indexOf('"') + 1);
                         substituter_array_resoult = substring5.substring(0, substring5.lastIndexOf('"'));
                        //运单号
                        if(waybill_no_array.length>1){
                            String pur4 = waybill_no_array[i];
                            String substring6 = pur4.substring(pur4.indexOf('"') + 1);
                            waybill_no_array_resoult = substring6.substring(0, substring6.lastIndexOf('"'));
                        }else {
                            waybill_no_array_resoult = waybill_no;
                        }
                        //运单公司
                        if(express_company_array.length>1){
                            String pur5 = express_company_array[i];
                            String substring7 = pur5.substring(pur5.indexOf('"') + 1);
                            express_company_array_resoult = substring7.substring(0, substring7.lastIndexOf('"'));
                        }else {
                            express_company_array_resoult =express_company;
                        }
                        if(!waybill_no_array_resoult.equals("") && !express_company_array_resoult.equals("")){
                            ExpressPush.subscribe(express_company_array_resoult,waybill_no_array_resoult);
                        }
                         //代购数量
                        String s1 = Purchase_number_array[i];
                        String substring8 = s1.substring(s1.indexOf('"') + 1);
                         Purchase_number_array_resoult = substring8.substring(0, substring8.lastIndexOf('"'));
                        //购运费
                        if(purchasing_freight_array.length>1){
                            String s2 = purchasing_freight_array[i];
                            String substring9 = s2.substring(s2.indexOf('"') + 1);
                            purchasing_freight_array_resoult = substring9.substring(0, substring9.lastIndexOf('"'));
                        }else {
                            purchasing_freight_array_resoult = purchasing_freight;
                        }
                    }else{
                        purchasing_terrace_resoult = purchasing_terrace;
                        substring1 = actual_payment_money;
                        purchase_order_no_resoult = purchase_order_no;
                        purchasing_terrace_no_resoult = purchasing_terrace_no;
                        substituter_array_resoult = substituter;
                        waybill_no_array_resoult = waybill_no;
                        express_company_array_resoult =express_company;
                        Purchase_number_array_resoult=Purchase_number;
                        purchasing_freight_array_resoult = purchasing_freight;
                        if(!waybill_no_array_resoult.equals("") && !express_company_array_resoult.equals("")){
                            ExpressPush.subscribe(express_company_array_resoult,waybill_no_array_resoult);
                        }
                    }
                        float actual_payment_money_temp = Float.parseFloat(substring1) * 100;
                        float actual_payment_money_float = (float) (Math.round(actual_payment_money_temp * 100)) / 100;
                        int actual_payment_money_Int = ((Number) actual_payment_money_float).intValue();

                    //purchas_order_id1为空情况为新加入情况
                    if(purchas_order_id1.equals("")){
                            int addSid = sendObjectCreate(237, Integer.valueOf(order_id), userId, order_no2,purchasing_terrace_resoult, commission_Int, actual_payment_money_Int, purchase_order_no_resoult, waybill_no_array_resoult, express_company_array_resoult, purchasing_terrace_no_resoult, substituter_array_resoult, state, userId, time, userId, time,Purchase_number_array_resoult,purchasing_freight_array_resoult);
                            res = ResultPoor.getResult(addSid);
                            if (BaseCache.getSuccessVal(res).equals("1")) {
                                addPurchasingOrder_logisticsInfo(state, order_id, waybill_no_array_resoult, userId, order_error_marker);
                                res = upOrderState(order_id, userId, state, order_error, order_error_marker);
                            }
                    }else{
                        if(save_status == 1) {
                            int addSid = sendObjectCreate(237, Integer.valueOf(order_id), userId, order_no2,purchasing_terrace_resoult, commission_Int, actual_payment_money_Int, purchase_order_no_resoult, waybill_no_array_resoult, express_company_array_resoult, purchasing_terrace_no_resoult, substituter_array_resoult, state, userId, time, userId, time,Purchase_number_array_resoult,purchasing_freight_array_resoult);
                            res = ResultPoor.getResult(addSid);
                            if (BaseCache.getSuccessVal(res).equals("1")) {
                                addPurchasingOrder_logisticsInfo(state, order_id, waybill_no_array_resoult, userId, order_error_marker);
                                res = upOrderState(order_id, userId, state, order_error, order_error_marker);
                            }

                        }else {
                            int upSid = sendObjectCreate(238, purchasing_terrace_resoult, commission_Int, actual_payment_money_Int, purchase_order_no_resoult, waybill_no_array_resoult, express_company_array_resoult, purchasing_terrace_no_resoult, substituter_array_resoult, state, userId, time,Purchase_number_array_resoult,purchasing_freight_array_resoult,purchas_order_id1);
                            res = ResultPoor.getResult(upSid);
                            if (BaseCache.getSuccessVal(res).equals("1")) {
                                addPurchasingOrder_logisticsInfo(state, order_id, waybill_no_array_resoult, userId, order_error_marker);
                                res = upOrderState(order_id, userId, state, order_error, order_error_marker);
                            }
                            save_status = 1;
                        }
                    }
                }
            }
        }
        return res;
    }


    public static String saveOrderEditInfo(int state,String order_id,String waybill_no,int userId,String logistics_companies){
        String time=BaseCache.getDateTime();
        int orderstate_code=0;
        String orderstate_name="";
        if(waybill_no.equals("")){
            orderstate_code=0;
            orderstate_name="";
        }
//        if()
        int addSid = sendObjectCreate(247,Integer.valueOf(order_id),logistics_companies,waybill_no,userId,time,userId,time);
        String res = ResultPoor.getResult(addSid);
        return res;
    }


    /**
     * 添加代购订单物流信息
     * @param state
     * @param order_id
     * @param waybill_no
     * @param userId
     * @return
     */
    public static String addPurchasingOrder_logisticsInfo(int state,String order_id,String waybill_no,int userId,String logistics_companies){
        String res="";
        if(state==3){
            String time=BaseCache.getDateTime();
            int orderId = Integer.valueOf(order_id);
            int addSid = sendObjectCreate(242,orderId,logistics_companies,waybill_no,userId,time,userId,time);
            res = ResultPoor.getResult(addSid);
        }
        return res;
    }

    /**
     * 修改代购订单状态——改为以发货
     * @param order_id
     * @param userId
     * @return order_id,userId ,state,order_error,order_error_marker
     */
    public static String upOrderState(String order_id,int userId,int state,String order_error,String order_error_marker){
        String time=BaseCache.getDateTime();
        //根据代购订单的状态修改订单状态
        int orderState = 0;
        if(state==2){
            orderState = 104;
        }else if(state==3){
            orderState = 105;
        }else if(state==4){
            orderState = 107;
        }else{
            orderState = 111;
        }

        int addSid = 0;
        if(order_error.equals("0")){
            addSid = sendObjectCreate(243,orderState,userId,time,0,"",Integer.valueOf(order_id));
        }else{
            addSid = sendObjectCreate(243,orderState,userId,time,1,order_error_marker,Integer.valueOf(order_id));
        }

        String res = ResultPoor.getResult(addSid);
        return res;
    }



    /**
     * 代购信息非空验证
     * 逍遥子_20180408
     * @param jsonString
     * @return
     */
    public static String SkipTasksDetailInfo(String jsonString){
         JSONObject jsonObject = JSONObject.parseObject(jsonString);
        String rsTest ="";
            if(jsonObject.get("purchasing_terrace").equals("")){
                rsTest="请选择代购平台";
            }else if(jsonObject.get("actual_payment_money").equals("")){
                rsTest="请填写实际支付金额";
            }else if(jsonObject.get("purchase_order_no").equals("")){
                rsTest="请填写代购订单号";
            }else if(jsonObject.get("purchasing_terrace_no").equals("")){
                rsTest="请填写下单账号";
            }else if(jsonObject.get("substituter").equals("")){
                rsTest="请填写代购人";
            }
        return rsTest;
    }

    /**
     * 查看订单是否已分配
     * 逍遥子_20180408
     * @param order_id
     * @return
     */
    public static Integer getPurchasingOrderToOrder_ID(String order_id){
        int id=0;
        int sid = sendObject(236,order_id);
        String rsGoodsClassifyInfo = ResultPoor.getResult(sid);
        String rsFinanceJson= StringHandler.getRetString(rsGoodsClassifyInfo);
        JSONObject json = JSONObject.parseObject(rsFinanceJson);
        String result="";
        for (int i = 0; i < json.size(); i++) {
            result= json.getString("rs");
        }
        if(result.equals("[]")==false){
            id = (int) TaskManageService.getFieldValue(rsGoodsClassifyInfo, "id", Integer.class);
        }


        return id;
    }


    public static String getpurchasingOrderHandleList(int begin,int end,int userId,String orderNum,String nick_name,String phoneNum,String purchasingOrder_source,String price_min,String price_max,String order_source,String order_Type,String status){
        StringBuffer sql=new StringBuffer();
        int sid=0;
        if( orderNum !=null && orderNum !=""){
            orderNum="'%"+orderNum+"%'";
            sql.append(" AND orderInfo.order_no LIKE ").append(orderNum);
        }
        if(nick_name !=null && nick_name !=""){
            nick_name="'%"+nick_name+"%'";
            sql.append(" AND pur_userInfo.nick_name LIKE ").append(nick_name);
        }
        if(phoneNum !=null && phoneNum !=""){
            phoneNum="'%"+phoneNum+"%'";
            sql.append(" AND pur_userInfo.phone LIKE ").append(phoneNum);
        }
        if(purchasingOrder_source !="0" && purchasingOrder_source !=null && purchasingOrder_source !=""){
            sql.append(" AND spu.source_code = '").append(purchasingOrder_source).append("'");
        }
        if((price_min !=null && price_min !="") && (price_max !=null && price_max !="")){
            price_min=price_min.replace("-","").replace(":","").replace(" ","").substring(2,14);
            price_max=price_max.replace("-","").replace(":","").replace(" ","").substring(2,14);
            sql.append(" AND orderInfo.created_date > ").append(price_min).append(" AND orderInfo.created_date < ").append(price_max);
        }
        if(order_source !=null && order_source !=""){

            sql.append(" AND orderInfo.data_source = '").append(order_source).append("'");
        }
        if(order_Type !=null && order_Type !=""){
            if(order_Type.equals("-1")==true){
                sql.append(" AND pur_order.purchas_order_state IS NULL ");
            }else{
                sql.append(" AND pur_order.purchas_order_state = ").append(Integer.valueOf(order_Type));
            }

        }
        if(status !=null && status !=""){
            sql.append(" AND orderInfo.status = ").append(status);
        }
        sql.append(" AND not exists (SELECT 1 FROM uranus.b_purchas_order WHERE pur_order.order_no=order_no AND pur_order.create_time<create_time) GROUP BY orderInfo.order_no ORDER BY orderInfo.created_date DESC");
        sid = sendObjectBase(233,sql.toString(),userId,begin,end);
        String rsGoodsClassifyInfo = ResultPoor.getResult(sid);
        String rsFinanceJson= StringHandler.getRetString(rsGoodsClassifyInfo);
        return rsFinanceJson;
    }

    public static String getPurchasingTerraceList(String orderNo){
        int sid = sendObject(602, orderNo);
        String result = ResultPoor.getResult(sid);
        String purchasingResult= StringHandler.getRetString(result);
        return purchasingResult;
    }
}
