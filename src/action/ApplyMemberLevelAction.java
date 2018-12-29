package action;

import action.service.ApplyMemberLevelService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "ApplyMemberLevel", urlPatterns = "/applyMemberLevel")
public class ApplyMemberLevelAction extends BaseServlet{

    /**
     * 查询等级申请列表
     * @param userId
     * @param nickName
     * @param phone
     * @param registration_time1
     * @param endDate
     * @param memberLevel
     * @param page
     * @param limit
     * @return
     */
    public String getApplyMemberLevelList(String userId,String nickName,String phone,String status,String registration_time1,
                                          String endDate,String memberLevel,String page,String limit){
        String applyLevel = ApplyMemberLevelService.getApplyLevel(userId, nickName,status, phone, registration_time1, endDate, memberLevel, page, limit);
        return  applyLevel;
    }

    /**
     * 更新等级申请状态
     * @param id
     * @param state
     * @return
     */
    public String updateMemberLevel(String id,String state,String remark,String applyMemberLevel){
        String s = ApplyMemberLevelService.updateMemberlevel(id, state,remark,applyMemberLevel);
        return s;
    }
}
