package action.sqlhelper;

public class FinanceSql {

    public static final String CommissioListPage_sql = "SELECT\n" +
            "\tt_user.id AS id,\n" +
            "\tt_user.nick_name AS nick_name,\n" +
            "\tt_user.phone AS phone,\n" +
            "\tt_user.member_level AS member_level,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tSUM(money)\n" +
            "\t\tFROM\n" +
            "\t\t\tb_commission AS b_commission\n" +
            "\t\tWHERE\n" +
            "\t\t\tb_commission.beneficiary_id = t_user.id\n" +
            "\t\tAND b_commission.`status` = '2'\n" +
            "\t) AS crash,\n" +
            "\t(\n" +
            "\t\tSELECT\n" +
            "\t\t\tSUM(money)\n" +
            "\t\tFROM\n" +
            "\t\t\tb_commission AS b_commission\n" +
            "\t\tWHERE\n" +
            "\t\t\tb_commission.beneficiary_id = t_user.id\n" +
            "\t\tAND b_commission.`status` = '0'\n" +
            "\t) AS preMoney\n" +
            "FROM\n" +
            "\turanus.t_user AS t_user "
            +" WHERE 1=1 and t_user.department_id IS NULL";


    public static final String WithdrawListPage_sql ="\n" +
            "SELECT user.nick_name,user.member_level,wallet.order_id,wallet.id,user.phone,amount.rental,preddwict.commimoney,wallet.operation_time,wallet.money,wallet.status,from_unixtime(unix_timestamp()) AS time,wallet.reason,wallet.user_id FROM uranus.b_wallet AS wallet\n" +
            "LEFT JOIN (SELECT SUM(wallet.money) AS rental,wallet.user_id,wallet.id FROM uranus.b_wallet AS wallet WHERE wallet.status=1 GROUP BY wallet.user_id) AS amount ON wallet.user_id=amount.user_id \n" +
            "LEFT JOIN (SELECT SUM(commi.money) AS commimoney,commi.beneficiary_id FROM uranus.b_commission AS commi WHERE commi.status=1 GROUP BY commi.beneficiary_id) AS preddwict ON wallet.user_id=preddwict.beneficiary_id\n" +
            "LEFT JOIN (SELECT nick_name,phone,member_level,id FROM uranus.t_user ) AS user ON wallet.user_id=user.id where 1=1";

   // public static final String WithdrawDetailPage_sql = ;
    public static String WithdrawDetailPage_sql (String id){
        StringBuffer sql  =  new StringBuffer("SELECT\n" +
                "\tc.profit_source,\n" +
                "\tUSER .parent_user_id,\n" +
                "\tUSER .nick_name,\n" +
                "\tder.buyer_id,\n" +
                "\tder.created_date,\n" +
                "\tder.order_no,\n" +
                "\tder. STATUS,\n" +
                "\tc.money,\n" +
                "\tc.order_id\n" +
                "FROM\n" +
                "\t(\n" +
                "\t\tSELECT\n" +
                "\t\t\tcomm.order_id AS order_id,\n" +
                "\t\t\tcomm.money AS money,\n" +
                "\t\t\tcomm.profit_source\n" +
                "\t\tFROM\n" +
                "\t\t\turanus.b_commission AS comm\n" +
                "\t\tWHERE\n" +
                "\t\t\tcomm.beneficiary_id ="+id+" \n" +
                "\t) AS c,\n" +
                "\turanus.b_order AS der,\n" +
                "\turanus.t_user AS USER\n" +
                "WHERE\n" +
                "\tder.id = c.order_id\n" +
                "AND USER .id = der.buyer_id");
        return sql.toString();
    }

    public static String WithdrawListDetailPage_sql (int id,String order_id){
        StringBuffer sql  =  new StringBuffer("SELECT aa.nick_name,orderInfo.order_no,aa.phone,aa.operation_time,aa.rental,aa.status,aa.money,aa.commimoney\n" +
                " FROM  uranus.b_order AS orderInfo\n" +
                "LEFT JOIN (\n" +
                "SELECT user.nick_name,user.member_level,wallet.order_id,wallet.id,user.phone,amount.rental,preddwict.commimoney,wallet.operation_time,wallet.money,wallet.status,from_unixtime(unix_timestamp()) AS time,wallet.reason,wallet.user_id FROM uranus.b_wallet AS wallet\n" +
                "LEFT JOIN (SELECT SUM(wallet.money) AS rental,wallet.user_id,wallet.id FROM uranus.b_wallet AS wallet WHERE wallet.status=1 GROUP BY wallet.user_id) AS amount ON wallet.user_id=amount.user_id \n" +
                "LEFT JOIN (SELECT SUM(commi.money) AS commimoney,commi.beneficiary_id FROM uranus.b_commission AS commi WHERE commi.status=1 GROUP BY commi.beneficiary_id) AS preddwict ON wallet.user_id=preddwict.beneficiary_id\n" +
                "LEFT JOIN (SELECT nick_name,phone,member_level,id FROM uranus.t_user ) AS user ON wallet.user_id=user.id WHERE wallet.id="+id+"\n" +
                "\n" +
                ") AS aa ON orderInfo.id IN ("+order_id+") \n" +
                " WHERE orderInfo.id IN ("+order_id+") \n" +
                "GROUP BY orderInfo.id\n");
        return sql.toString();
    }
}