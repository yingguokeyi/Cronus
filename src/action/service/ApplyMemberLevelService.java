package action.service;

import cache.ResultPoor;
import common.StringHandler;
import common.Utils;

public class ApplyMemberLevelService extends BaseService{

    public static String getApplyLevel(String userId,String nickName,String status,String phone,String registration_time1,
                                       String endDate,String memberLevel,String pageBegin,String pageEnd){
        Integer page = Integer.valueOf(pageBegin);
        Integer limit = Integer.valueOf(pageEnd);
        StringBuffer sql = new StringBuffer();
        if(userId !=null && !"".equals(userId)){
            sql.append(" and m.user_id="+userId);
        }
        if(nickName !=null && !"".equals(nickName)){
            sql.append(" and u.nick_name like '%"+nickName+"%'");
        }
        if(status !=null && !"".equals(status)){
            sql.append(" and m.state="+status);
        }
        if(phone !=null && !"".equals(phone)){
            sql.append(" and u.phone = "+phone);
        }
        if(registration_time1 !=null && endDate !=null && !"".equals(registration_time1) && !"".equals(endDate)){
            String bDate = Utils.transformToYYMMddHHmmss(registration_time1);
            String eDate = Utils.transformToYYMMddHHmmss(endDate);
            sql.append(" and m.create_time between "+bDate+" and "+eDate);
        }
        if(memberLevel !=null && !"".equals(memberLevel)){
            sql.append(" and u.member_level="+memberLevel);
        }
        sql.append(" order by m.create_time desc");
        int sid = BaseService.sendObjectBase(651, sql.toString(), (page - 1) * limit, limit);
        System.out.println("=========================="+sid);
        String retString = StringHandler.getRetString(ResultPoor.getResult(sid));
        return retString;
    }

    public static String updateMemberlevel(String id,String state,String remark,String applyMemberLevel){
        int i = BaseService.sendObjectCreate(652, state, remark,id);
        if(applyMemberLevel !=null){
            BaseService.sendObjectCreate(653, applyMemberLevel,id);
        }
        String result = ResultPoor.getResult(i);
        return result;
    }
}
