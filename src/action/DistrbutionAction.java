package action;

import servlet.BaseServlet;
import action.service.DistrbutionService;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/***
 * 分销
 * 2018/3/7 逍遥子
 */
@WebServlet(name = "Distrbution", urlPatterns = "/distrbution")
public class DistrbutionAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    /**
     * 分销设置_默认分销值列表
     * 逍遥子_20180320
     * @return
     */
    public String defaultDistributionInfoList(){
        String res = DistrbutionService.defaultDistributionInfoList();
        return res;
    }


    /**
     * 分销设置_非默认分销值列表
     * 逍遥子_20180320
     * @return
     */
    public String noDefaultDistributionInfoList(){
        String res = DistrbutionService.noDefaultDistributionInfoList();
        return res;
    }

    /**
     * 分销设置_添加默认分销值
     * 逍遥子_20180320
     * @param jsonString
     * @return
     */
    public String addDefaultDistributionValSet(String jsonString, HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = DistrbutionService.addDefaultDistributionValSet(jsonString,userId);
        return res;
    }


    /**
     *分销设置_添加非默认分销值
     * 逍遥子_20180320
     * @param jsonString
     * @return
     */
    public String addNotDefaultDistributionValSet(String jsonString, HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = DistrbutionService.addNotDefaultDistributionValSet(jsonString,userId);
        return res;
    }

    /**
     * 获取返佣规则详细信息
     * 逍遥子_20180320
     * @param id
     * @return
     */
    public String getDefaultDistributionDetailInfo(String id){
        String res = DistrbutionService.getDefaultDistributionDetailInfo(id);
        return res;
    }



    /**
     * 编辑默认分销值
     * 逍遥子_20180320
     * @param jsonString
     * @return
     */
    public String upDefaultDistributionDetailInfo(String jsonString,String id,String member,HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = DistrbutionService.upDefaultDistributionDetailInfo(jsonString,id,member,userId);
        return res;
    }

    /**
     * 编辑非默认分销值
     * 逍遥子_20180320
     * @param jsonString
     * @return
     */
    public String upNoDefaultDistributionDetailInfo(String jsonString,String id,String member,HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = DistrbutionService.upNoDefaultDistributionDetailInfo(jsonString,id,member,userId);
        return res;
    }

    /**
     * 删除默认分销规则
     * 逍遥子_20180320
     * @param id
     * @param req
     * @return
     */
    public String delDefaultDistributionInfo(String id,HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = DistrbutionService.delDistributionValSet(id,userId);
        return res;
    }

    /**
     * 删除非默认分销规则
     * 逍遥子_20180320
     * @param id
     * @param req
     * @return
     */
    public String noDelDefaultDistributionInfo(String id,HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res = DistrbutionService.noDelDefaultDistributionInfo(id,userId);
        return res;
    }


}
