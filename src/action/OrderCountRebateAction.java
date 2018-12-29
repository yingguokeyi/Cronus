package action;

import servlet.BaseServlet;
import action.service.OrderCountRebateService;
import javax.servlet.annotation.WebServlet;

@WebServlet(name = "OrderCountRebate", urlPatterns = "/orderCountRebate")
public class OrderCountRebateAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    public String getOrderCountRebateInfo(String order_no,String nick_name,String phoneNum,String rebate_userName,String price_min,String price_max,String countRebateType,String order_source,String page,String limit){
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res=OrderCountRebateService.getOrderCountRebateInfo((pageI-1)*limitI,pageI*limitI,order_no,nick_name,phoneNum,rebate_userName,price_min,price_max,countRebateType,order_source);
        return res;
    }


    public String getPurchaseUserInfo(String order_id){
        String res=OrderCountRebateService.getPurchaseUserInfo(order_id);
        return res;
    }


    public String getRebateUserInfo(String order_id){
        String res=OrderCountRebateService.getRebateUserInfo(order_id);
        return res;
    }
}
