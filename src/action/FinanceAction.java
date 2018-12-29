package action;

import action.service.AdvertisingService;
import action.service.FinanceService;
import com.alibaba.fastjson.JSON;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

@WebServlet(name = "Finance", urlPatterns = "/finance")
public class FinanceAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    /**
     * 获取支付信息列表
     * 2018/3/8 木易
     * @return
     */
       public String getpayment(String page,String limit) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.getpayment((pageI-1)*limitI,pageI*limitI);
        return res;
    }

    /**
     * 更改支付信息列表
     * 2018/3/8 木易
     * @return
     */
    public String updatepayment(String account_name ,String account_num,String bank_name,String company_name) {
        String res = FinanceService.updatepayment(account_name,account_num,bank_name,company_name);
        return res;
    }

    /**
     * 佣金收益管理列表
     * 2018/3/20 木易
     * @return
     */
    public String Commissio(String page,String limit,String member_level,String phone) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.Commissio((pageI-1)*limitI,pageI*limitI,member_level, phone);
        return res;
    }


    public String Withdraw(String page,String limit,String nick_name,String phone,String test5,String test6,String test7,String test8,String status) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.Withdraw((pageI-1)*limitI,pageI*limitI,nick_name, phone,test5,test6,test7,test8,status);

        return res;
    }
    public String WithdrawShowdetail(String page,String limit,String user_id) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.WithdrawShowdetail((pageI-1)*limitI,pageI*limitI,user_id);
        return res;
    }

    public String WithdrawDetail(String id,String page,String limit,String name,String test5,String test6,String order_status,String earnings_type) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.WithdrawDetail(id,(pageI-1)*limitI,pageI*limitI,name,test5,test6,order_status,earnings_type);
        return res;
    }


    //同意提现
    public String Agreerequest(String id,HttpServletRequest request) {
        HttpSession session=request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String res = FinanceService.agreerequest(id,userId);

        return res;
    }

    public String Getpeople(String user_id) {

        String res = FinanceService.Getpeople(user_id);

        return res;
    }
    //拒绝提现
    public String Rejectrequest(String id,String remarks,HttpServletRequest request) {


        HttpSession session=request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String res = FinanceService.rejectrequest(id,remarks,userId);
        return res;
    }


    //提现作废
    public String  abolishquest(String id,HttpServletRequest request) {
        HttpSession session=request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String res = FinanceService.abolishquest(id,userId);
        return res;
    }


    //修改提现状态
    public String updateWithdrawalsStatus(String remarks,String status,String ids,HttpServletRequest request){

        HashMap<String,Object> map = new HashMap<String,Object>();

        HttpSession session=request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());

        if  (status.equals("3")){

            String[] idArray = ids.split(",");
            int sid = 0;
            String res = null;

            for (String aid : idArray) {
                FinanceService.rejectrequest(aid,remarks,userId);
            }
            map.put("success", 1);
            String json = JSON.toJSONString(map);
            return json;


        }

        String res = FinanceService.updateWithdrawalsStatus(remarks,status,ids,userId);
        return res;
    }


    /**
     * 掌小龙奖励金管理
     * @param page
     * @param limit
     * @param nick_name
     * @param phone
     * @param test5
     * @param test6
     * @param commi_id
     * @param status
     * @param source
     * @return
     */
    public String zdzOrder(String page,String limit,String nick_name,String phone,String test5,String test6,String commi_id,String status,String source) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = FinanceService.zdzOrders((pageI-1)*limitI,pageI*limitI,nick_name, phone,test5,test6,commi_id,status,source);
        return res;
    }

    public String userWallet(String page,String limit,String phone,String price_min,String price_max){
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String userWallet = FinanceService.findUserWallet((pageI-1)*limitI,pageI*limitI,phone,price_max,price_min);
        return userWallet;
    }


}
