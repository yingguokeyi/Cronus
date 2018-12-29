package action;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import action.service.TaskManageService;
import servlet.BaseServlet;

@WebServlet(name = "TaskManage", urlPatterns = "/taskManage")
public class TaskManageAction extends BaseServlet{

    /**  
	* @Fields field:field:{todo}(用一句话描述这个变量表示什么)  
	*/
	private static final long serialVersionUID = -2618591112637804465L;

	/**
     * 任务列表_获取数据
     * 逍遥子_20180328
     * @param orderNum
     * @param nick_name
     * @param phoneNum
     * @param purchasingOrder_source
     * @param price_min
     * @param price_max
     * @param order_source
     * @param order_Type
     * @param page
     * @param limit
     * @return
     */

    public String getSkipTasksInfo(String orderNum,String transaction_no,String spuCode,String nick_name,String phoneNum,String purchasingOrder_source,String price_min,String price_max,String order_source,String order_Type,String status,String page,String limit,HttpServletRequest request,String sku_name){
        HttpSession session = request.getSession();
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res="";
            res = TaskManageService.getSkipTasksInfo((pageI-1)*limitI,pageI*limitI,orderNum,transaction_no,spuCode, nick_name,phoneNum,purchasingOrder_source,price_min,price_max,order_source,order_Type,status,sku_name);

        return res;
    }

    /**
     * 获取指派任务的员工信息
     * 逍遥子_20180330
     * @param page
     * @param limit
     * @param request
     * @return
     */
    public String getPurchaserList(String page,String limit,String dep_name,String user_name,HttpServletRequest request){
        HttpSession session=request.getSession();
        int department_id=Integer.valueOf(session.getAttribute("department_id").toString());
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = TaskManageService.getPurchaserList((pageI-1)*limitI,pageI*limitI,department_id,userId,dep_name,user_name);
        return res;
    }

    /**
     * 指派任务
     * 逍遥子_20180330
     * @param id
     * @param order_id
     * @param req
     * @return
     */
    public String appointedTask(String id,String order_id,HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = TaskManageService.appointedTask(id,order_id,userId);
        //关联系统订单表，修改b_order的状态
        return res;
    }


    /**
     * 获取订单详情信息
     * 逍遥子_20180403
     * @param order_id
     * @return
     */
    public String getSkipTasksDetailInfo(String order_id,String pur_id){
        String res = TaskManageService.getSkipTasksDetailInfo(order_id,pur_id);
        return res;
    }

    /**
     * 获取代购平台信息
     * 逍遥子_20180404
     * @return
     */
    public String getPurchasingTerraceInfo(){
        String res = TaskManageService.getPurchasingTerraceInfo();
        return res;
    }

    public String saveSkipTasksDetailInfo(String order_id,String jsonObj,HttpServletRequest request){
        HttpSession session=request.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res= TaskManageService.saveSkipTasksDetailInfo(order_id,jsonObj,userId);
        return res;
    }

    public String getpurchasingOrderHandleList(String orderNum,String nick_name,String phoneNum,String purchasingOrder_source,String price_min,String price_max,String order_source,String order_Type,String status,String page,String limit,HttpServletRequest request){
        HttpSession session=request.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = TaskManageService.getpurchasingOrderHandleList((pageI-1)*limitI,pageI*limitI,userId,orderNum,nick_name,phoneNum,purchasingOrder_source,price_min,price_max,order_source,order_Type,status);
        return res;
    }

    /**
     * 根据订单编号查询代购信息
     * @param orderNo
     * @return
     */
    public String getPurchasingTerraceList(String orderNo){
        String res = TaskManageService.getPurchasingTerraceList(orderNo);
        return res;
    }
}
