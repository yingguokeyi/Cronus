package action.sqlhelper;

public class OrderSql {

    public static final int currentPage = 1;

    public static int PageSize = 1;

    public static final String selectOrderList = "SELECT\n" +
            "\tT.id AS id,\n" +
            "\tT.order_no AS order_no,\n" +
            "\tT.`STATUS` AS STATUS,\n" +
            "\tT.created_date AS create_date,\n" +
            "\tT.edit_time AS edit_time,\n" +
            "\tT.nick_name AS nick_name,\n" +
            "\tT.phone AS phone,\n" +
            "\tT.transaction_no AS transaction_no,\n" +
            "\tT.logistics_numbers AS logistics_numbers,\n" +
            "\tT.sku_name AS sku_name,\n" +
            "\tT.sku_num AS sku_num,\n" +
            "\tT.first_attribute_value,\n" +
            "\tT.second_attribute_value\n" +
            "FROM\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\to.id,\n" +
            "\t\t\to.order_no,\n" +
            "\t\t\to. STATUS AS STATUS,\n" +
            "\t\t\to.created_date,\n" +
            "\t\t\to.edit_time,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tnick_name\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\turanus.t_user\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = o.edit_user\n" +
            "\t\t\t) AS edit_user,\n" +
            "\t\t\to.sku_num AS sku_num,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tnick_name\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\turanus.t_user\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = o.buyer_id\n" +
            "\t\t\t) AS nick_name,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tphone\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\turanus.t_user\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = o.buyer_id\n" +
            "\t\t\t) AS phone,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\ttransaction_no\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\tb_transactions\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\ttransaction_id = o.transaction_id\n" +
            "\t\t\t) AS transaction_no,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT DISTINCT\n" +
            "\t\t\t\t\twaybill_no\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\tb_purchas_order\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\torder_id = o.id\n" +
            "\t\t\t\tGROUP BY\n" +
            "\t\t\t\t\torder_no\n" +
            "\t\t\t) AS logistics_numbers,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tsku_name\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\tb_sku\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = o.sku_id\n" +
            "\t\t\t) AS sku_name,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tspu_id AS spuId\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\tb_sku\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = o.sku_id\n" +
            "\t\t\t\tGROUP BY\n" +
            "\t\t\t\t\tspu_id\n" +
            "\t\t\t) AS spuId,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tattribute_value\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\turanus.b_spu_attribute\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = k.first_attribute_id\n" +
            "\t\t\t) AS first_attribute_value,\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\tattribute_value\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\turanus.b_spu_attribute\n" +
            "\t\t\t\tWHERE\n" +
            "\t\t\t\t\tid = k.second_attribute_id\n" +
            "\t\t\t) AS second_attribute_value\n" +
            "\t\tFROM\n" +
            "\t\t\t(\n" +
            "\t\t\t\tSELECT\n" +
            "\t\t\t\t\t*\n" +
            "\t\t\t\tFROM\n" +
            "\t\t\t\t\turanus.b_order\n" +

            "\t\t\t\tLIMIT" + "0,\n" +
            "\t\t\t\t20\n" +
            +OrderSql.currentPage +
            "\t\t\t) AS o\n" +
            "\t\tLEFT JOIN uranus.b_sku k ON o.sku_id = k.id\n" +
            "\t) T\n" +
            "WHERE\n" +
            "\t1 = 1";

    public static final String getOrderByField_sql = "SELECT DISTINCT\n" +
            "\to.id,\n" +
            "\to.order_no,\n" +
            "\to. STATUS AS status,\n" +
            "\to.created_date,\n" +
            "\to.edit_time,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tnick_name\n" +
            "\t\tFROM\n" +
            "\t\t\turanus.t_user\n" +
            "\t\tWHERE\n" +
            "\t\t\tid = o.edit_user\n" +
            "\t) AS edit_user,\n" +
            "(\n" +
            "select money from uranus.b_commission c where c.order_id = o.id and profit_source = 1\n" +
            " \n" +
            ") as top,\n" +
            "(\n" +
            "select money from uranus.b_commission c where c.order_id = o.id and profit_source = 2\n" +
            " \n" +
            ") as parent,\n" +
            "(\n" +
            "select money from uranus.b_commission c where c.order_id = o.id and profit_source = 3\n" +
            " \n" +
            ") as self,\n" +
            "\tu.nick_name,\n" +
            "\tu.member_level,\n" +
            "\to.sup_is_member,\n" +
            "\to.top_is_member,\n" +
            "\tu.phone,\n" +
            "\tt.transaction_no,\n" +
            "\tp.logistics_numbers,\n" +
            "\tk.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\t(select attribute_value from uranus.b_spu_attribute where id = k.first_attribute_id) as first_attribute_value,\n" +
            "\t(select attribute_value from uranus.b_spu_attribute where id = k.second_attribute_id) as second_attribute_value\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_transactions t ON o.transaction_id = t.transaction_id\n" +
            "LEFT JOIN uranus.b_order_logistics p ON o.id = p.order_id\n" +
            "LEFT JOIN uranus.b_sku k ON o.sku_id = k.id\n" +
            "WHERE\n" +
            "\t1 = 1";



    // 订单列表查询
    //条件查询
    // 修正 订单查询重复问题 20180505
    // 更新 添加订单所购买商品的信息: 名称 规格 数量
    public static final String getOrderByField_sql_1 = "SELECT DISTINCT\n" +
            "\to.id,\n" +
            "\to.order_no,\n" +
            "\to. STATUS AS status,\n" +
            "\to.created_date,\n" +
            "\to.edit_time,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tnick_name\n" +
            "\t\tFROM\n" +
            "\t\t\turanus.t_user\n" +
            "\t\tWHERE\n" +
            "\t\t\tid = o.edit_user\n" +
            "\t) AS edit_user,\n" +
            "\tu.nick_name,\n" +
            "\tu.phone,\n" +
            "\tt.transaction_no,\n" +
            "\tp.waybill_no AS logistics_numbers,\n" +
            "\tk.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\t(select attribute_value from uranus.b_spu_attribute where id = k.first_attribute_id) as first_attribute_value,\n" +
            "\t(select attribute_value from uranus.b_spu_attribute where id = k.second_attribute_id) as second_attribute_value\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_transactions t ON o.transaction_id = t.transaction_id\n" +
            "LEFT JOIN uranus.b_purchas_order p ON o.id = p.order_id\n" +
            "LEFT JOIN uranus.b_sku k ON o.sku_id = k.id\n" +
            "WHERE\n" +
            "\t1 = 1";

    //  //根据待支付状态查询
    // 2018/5/8  增加显示商品名称 规格 数量
    public static final String getOrderByStaPaid_sql = "SELECT\n" +
            "\torderInfo.id,\n" +
            "\torderInfo.order_no,\n" +
            "\torderInfo.`status`,\n" +
            "\tdic_data.dict_data_name,\n" +
            "\torder_log.logistics_numbers,\n" +
            "\tuserInfo.nick_name,\n" +
            "\tuserInfo.phone,\n" +
            "\torderInfo.created_date,\n" +
            "\torderInfo.sku_num AS sku_num,\n" +
            "\tb_sku.sku_name AS sku_name,\n" +
            "\tb_spu_att.attribute_value AS attribute_value,\n" +
            "\tb_spu_att2.attribute_value AS attribute_value2,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order AS orderInfo\n" +
            "LEFT JOIN uranus.b_order_logistics AS order_log ON orderInfo.id = order_log.order_id\n" +
            "LEFT JOIN uranus.t_user AS userInfo ON orderInfo.buyer_id = userInfo.id\n" +
            "LEFT JOIN uranus.s_dictionary_data AS dic_data ON dic_data.dict_data_value = orderInfo.order_type\n" +
            "LEFT JOIN uranus.b_sku AS b_sku ON b_sku.id = orderInfo.sku_id\n" +
            "LEFT JOIN uranus.b_spu_attribute AS b_spu_att ON b_spu_att.id = b_sku.first_attribute_id\n" +
            "LEFT JOIN uranus.b_spu_attribute AS b_spu_att2 ON b_spu_att2.id = b_sku.second_attribute_id\n" +
            "LEFT JOIN uranus.b_transactions t ON t.transaction_id = orderInfo.transaction_id\n" +
            "WHERE\n" +
            "\torderInfo.`status` = '101'";
    //根据待备货状态查询
    //2018/5/9 添加商品名称 规格 数量
    public static final String getOrderByStaWaitGoods_sql = "SELECT\n" +
            "\to.id AS id,\n" +
            "\to.sku_id AS sku_id,\n" +
            "\to.buyer_id AS buyer_id,\n" +
            "\to.order_no AS order_no,\n" +
            "\to.created_date,\n" +
            "\to.`status`,\n" +
            "\to.`order_ style`,\n" +
            "\to.data_source,\n" +
            "\to.lead_time,\n" +
            "\to.order_type,\n" +
            "\tdelivery_address,\n" +
            "\tconsignee,\n" +
            "\tol.logistics_numbers,\n" +
            "\tu.nick_name,\n" +
            "\tu.phone,\n" +
            "\tbs.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\tbsp1.attribute_value AS attribute_value,\n" +
            "\tbsp2.attribute_value AS attribute_value2,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.b_order_logistics ol ON o.id = ol.order_id\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_sku bs ON bs.id = o.sku_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp1 ON bsp1.id = bs.first_attribute_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp2 ON bsp2.id = bs.second_attribute_id\n" +
            "LEFT JOIN uranus.b_transactions AS t ON t.transaction_id = o.transaction_id\n" +
            "WHERE\n" +
            "\to.`status` = '103'";
    //根据待提货状态查询
    public static final String getOrderByStaWaitRecGoods_sql = "SELECT\n" +
            "\to.id AS id,\n" +
            "\to.sku_id AS sku_id,\n" +
            "\to.buyer_id AS buyer_id,\n" +
            "\to.order_no AS order_no,\n" +
            "\to.created_date,\n" +
            "\to.`status`,\n" +
            "\to.`order_ style`,\n" +
            "\to.data_source,\n" +
            "\to.lead_time,\n" +
            "\to.order_type,\n" +
            "\tu.nick_name,\n" +
            "\tu.phone,\n" +
            "\tbs.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\tbsp1.attribute_value AS attribute_value,\n" +
            "\tbsp2.attribute_value AS attribute_value2,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.b_order_logistics ol ON o.id = ol.order_id\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_sku bs ON bs.id = o.sku_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp1 ON bsp1.id = bs.first_attribute_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp2 ON bsp2.id = bs.second_attribute_id\n" +
            "LEFT JOIN uranus.b_transactions t ON t.transaction_id = o.transaction_id\n" +
            "WHERE\n" +
            "\to.`status` = '106'";
    //根据已提货状态查询
    public static final String getOrderByStaRecGoods_sql = "SELECT\n" +
            "\to.*, ol.logistics_numbers,\n" +
            "\tu.nick_name,\n" +
            "\tu.phone,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.b_order_logistics ol ON o.id = ol.order_id\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_transactions t ON t.transaction_id = o.transaction_id\n" +
            "WHERE\n" +
            "\to.`status` = '107'";

    //根据已完成状态查询
    //根据添加商品名称 规格样式 个数
    public static final String getOrderByStaComp_sql = "SELECT\n" +
            "\to.id,\n" +
            "\to.order_no,\n" +
            "\to.`status`,\n" +
            "\to.order_type,\n" +
            "\to.created_date,\n" +
            "\tol.logistics_numbers,\n" +
            "\tu.nick_name AS nick_name,\n" +
            "\tu.phone AS phone,\n" +
            "\tbs.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\tbsp1.attribute_value AS attribute_value,\n" +
            "\tbsp2.attribute_value AS attribute_value2,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.b_order_logistics ol ON o.id = ol.order_id\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_sku bs ON bs.id = o.sku_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp1 ON bsp1.id = bs.first_attribute_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp2 ON bsp2.id = bs.second_attribute_id\n" +
            "LEFT JOIN uranus.b_transactions t ON t.transaction_id = o.transaction_id\n" +
            "WHERE\n" +
            "\to.`status` = '108'";

    //根据已取消状态查询
    //2018/5/9  添加商品显示 规格 数目
    public static final String getOrderByStaCan_sql = "SELECT\n" +
            "\to.order_no,\n" +
            "\to.`status`,\n" +
            "\to.order_type,\n" +
            "\to.created_date,\n" +
            "\to.cancel_date,\n" +
            "\tol.logistics_numbers,\n" +
            "\tu.nick_name AS nick_name,\n" +
            "\tu.phone AS phone,\n" +
            "\tbs.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\tbsp1.attribute_value AS attribute_value,\n" +
            "\tbsp2.attribute_value AS attribute_value2,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.b_order_logistics ol ON o.id = ol.order_id\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_sku bs ON bs.id = o.sku_id\n" +
            "LEFT JOIN uranus.b_transactions t ON t.transaction_id = o.transaction_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp1 ON bsp1.id = bs.first_attribute_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp2 ON bsp2.id = bs.second_attribute_id\n" +
            "WHERE\n" +
            "\to.`status` IN ('110', '111', '113')";

    //根据待发货状态查询
    //2018/5/9 添加商品名称 规格 个数
    public static final String getOrderByStapendDeli_sql = "SELECT\n" +
            "\to.order_no,\n" +
            "\to.`status`,\n" +
            "\to.order_type,\n" +
            "\to.created_date,\n" +
            "\tol.logistics_numbers,\n" +
            "\tu.nick_name,\n" +
            "\tu.phone,\n" +
            "\tbs.sku_name AS sku_name,\n" +
            "\to.sku_num AS sku_num,\n" +
            "\tbsp1.attribute_value AS attribute_value,\n" +
            "\tbsp2.attribute_value AS attribute_value2,\n" +
            "\tt.transaction_no AS transaction_no\n" +
            "FROM\n" +
            "\turanus.b_order o\n" +
            "LEFT JOIN uranus.b_order_logistics ol ON o.id = ol.order_id\n" +
            "LEFT JOIN uranus.t_user u ON o.buyer_id = u.id\n" +
            "LEFT JOIN uranus.b_sku bs ON bs.id = o.sku_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp1 ON bsp1.id = bs.first_attribute_id\n" +
            "LEFT JOIN uranus.b_spu_attribute bsp2 ON bsp2.id = bs.second_attribute_id\n" +
            "LEFT JOIN uranus.b_transactions t ON t.transaction_id = o.transaction_id\n" +
            "WHERE\n" +
            "\to.`status` = '104'";
    //
    public static final String orderCountRebate_sql = "SELECT\n" +
            "\tb_order.id AS id,\n" +
            "\tb_order.order_no AS order_no,\n" +
            "\tt_user.nick_name AS rebate_userName,\n" +
            "\tt_user.nick_name AS nick_name,\n" +
            "\tt_user.member_level AS member_level,\n" +
            "\tb_order.sku_num AS sku_num,\n" +
            "\tt_user.phone AS phoneNum,\n" +
            "\tb_order.created_date AS create_time,\n" +
            "\tb_order.payment_way_key AS payment_way_key,\n" +
            "\tb_order.data_source AS order_source,\n" +
            "\tb_spu.spu_name AS spu_name,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tdict.dict_data_name\n" +
            "\t\tFROM\n" +
            "\t\t\turanus.s_dictionary_data AS dict\n" +
            "\t\tWHERE\n" +
            "\t\t\tdict.dict_data_value = b_spu.source_code\n" +
            "\t) AS source_name,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tSUM(money)\n" +
            "\t\tFROM\n" +
            "\t\t\tb_commission b\n" +
            "\t\tWHERE\n" +
            "\t\t\tprofit_source = 3\n" +
            "\t\tAND b.order_id = b_order.id\n" +
            "\t) member_self,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tSUM(money)\n" +
            "\t\tFROM\n" +
            "\t\t\tb_commission b\n" +
            "\t\tWHERE\n" +
            "\t\t\tprofit_source = 2\n" +
            "\t\tAND b.order_id = b_order.id\n" +
            "\t) member_parent,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tsum(money)\n" +
            "\t\tFROM\n" +
            "\t\t\tb_commission b\n" +
            "\t\tWHERE\n" +
            "\t\t\tprofit_source = 1\n" +
            "\t\tAND b.order_id = b_order.id\n" +
            "\t) member_top,\n" +
            "\tb_commission.profit_source AS profit_source\n" +
            "FROM\n" +
            "\tb_order AS b_order\n" +
            "LEFT JOIN b_sku AS b_sku ON b_order.sku_id = b_sku.id\n" +
            "LEFT JOIN b_spu AS b_spu ON b_sku.spu_id = b_spu.id\n" +
            "LEFT JOIN t_user AS t_user ON t_user.id = b_order.buyer_id\n" +
            "LEFT JOIN b_commission AS b_commission ON b_commission.order_id = b_order.id\n" +
            "WHERE\n" +
            "\tb_order.If_Commission = 1\n";
    /*//修改待收货为已收货
    public static final String upStatusRece_sql="UPDATE uranus.b_order AS o SET o.`status`='107' WHERE o.`status`='106'";
    //修改已收货为已完成
    public static final String upStatusDeliv_sql="UPDATE uranus.b_order AS o SET o.`status`='108' WHERE o.`status`='107'";*/

}
