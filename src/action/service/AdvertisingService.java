package action.service;

import cache.ResultPoor;
import common.BaseCache;
import common.PropertiesConf;
import common.StringHandler;
import common.Utils;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by 18330 on 2018/6/6.
 */
public class AdvertisingService extends BaseService{
    //查询广告位列表
    public static String getPositionList(String operator,String page_location,String edit_time,String editend_time,String market_time,String marketend_time,int page, int limit){
        StringBuffer sql = new StringBuffer();
        //条件查询
        if(operator != null && !operator.equals("")){
            sql.append(" AND operator like '%").append(operator).append("%'");
        }
        if(page_location != null && !page_location.equals("")){
            sql.append(" AND page_location = ").append(page_location);
        }
        if((edit_time != null && !edit_time.equals("")) || (editend_time != null && !editend_time.equals(""))){
            String bDate = Utils.transformToYYMMddHHmmss(edit_time);
            String eDate = Utils.transformToYYMMddHHmmss(editend_time);
            sql.append(" and edit_time BETWEEN ").append(bDate).append(" and ").append(eDate);
        }
        if((market_time != null && !market_time.equals(""))){
            String marketTime = Utils.transformToYYMMddHHmmss(market_time);
            sql.append(" and market_time >= ").append(marketTime);
        }
        if((marketend_time != null && !marketend_time.equals(""))){
            String marketendTime = Utils.transformToYYMMddHHmmss(marketend_time);
            sql.append(" and marketend_time <= ").append(marketendTime);
        }
        int sid = sendObjectBase(700, sql.toString());
        System.out.println(sid);
        String retString = StringHandler.getRetString(ResultPoor.getResult(sid));
        System.out.println(retString);
        return retString;
    }

    //修改广告位状态
    public static String updatePositionStatus(String status,String ids){

        String[] idArray = ids.split(",");
        int sid = 0;
        for (String aid : idArray) {
            sid = sendObjectCreate(701,status, aid);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }

    //编辑广告位
    public static String updatePositionEdit(String id,String position_name,String page_location,String position,String market_time,String marketend_time,String playback_length,int userId){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String edit_time= BaseCache.getDateTime();
        String start = "";
        boolean status_start = market_time.contains("-");
        if(status_start){
            start = Utils.transformToYYMMddHHmmss(market_time);
        }else{
            start = market_time;
        }
        String end = "";
        boolean status_end = marketend_time.contains("-");
        if(status_end){
            end = Utils.transformToYYMMddHHmmss(marketend_time);
        }else{
            end = marketend_time;
        }
        int updateId=sendObjectCreate(702,position_name,page_location,position,start,end,playback_length,operator,edit_time,id);
        String res = ResultPoor.getResult(updateId);
        return res;
    }

    //广告列表查询
    public static String getAdvertList(String position_id,String status,String start_time,String end_time,int page, int limit){
        StringBuffer sql = new StringBuffer();
        if (position_id != null && !position_id.equals("")){
            sql.append(" and position_id = ").append(position_id);
        }
        if((start_time != null && !start_time.equals(""))){
            String startTime = Utils.transformToYYMMddHHmmss(start_time);
            sql.append(" and start_time >= ").append(startTime);
        }
        if((end_time != null && !end_time.equals(""))){
            String endTime = Utils.transformToYYMMddHHmmss(end_time);
            sql.append(" and end_time <= ").append(endTime);
        }
        if((status != null && !status.equals("") && !status.equals("0"))){
            sql.append(" and status = ").append(status);
        }
        sql.append(" ORDER BY id ASC ");
        int sid = sendObjectBase(703, sql.toString());
        String retString = StringHandler.getRetString(ResultPoor.getResult(sid));
        System.out.println(retString);
        return retString;
    }

    //修改广告状态
    public static String updateAdvertStatus(String status,String ids){

        String[] arr = ids.split(",");
        int sid = 0;
        for (String aid : arr) {
            sid = sendObjectCreate(707,status, aid);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }

    //查询广告所在广告位信息
    public static String getInPosition(String id){
        int sid = sendObject(708, id);
        String result = ResultPoor.getResult(sid);
        String retString = StringHandler.getRetString(result);
        System.out.println(retString);
        return retString;
    }

    //添加广告链接
    public static String addAdvertUrl(String advertlink_name,String url_link,String remarks,int userId,String category){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String create_time= BaseCache.getDateTime();
        int sid = sendObjectCreate(709,advertlink_name,url_link,remarks,operator,create_time,1,category);
        String result = ResultPoor.getResult(sid);
        return result;

    }

    //查询广告链接库
    public static String getUrlList(String operator,String advertlink_name,String edit_time,String editend_time){

        StringBuffer sql = new StringBuffer();
        if((edit_time != null && !edit_time.equals(""))){
            String editTime = Utils.transformToYYMMddHHmmss(edit_time);
            sql.append(" and edit_time >= ").append(editTime);
        }
        if((editend_time != null && !editend_time.equals(""))){
            String editendTime = Utils.transformToYYMMddHHmmss(editend_time);
            sql.append(" and edit_time <= ").append(editendTime);
        }
        if (advertlink_name != null && !advertlink_name.equals("")){
            sql.append(" and advertlink_name like '%").append(advertlink_name).append("%'");
        }
        if (operator != null && !operator.equals("")){
            sql.append(" and operator like '%").append(operator).append("%'");
        }
        int sid = sendObjectBase(710,sql.toString());
        String result = ResultPoor.getResult(sid);
        String retString = StringHandler.getRetString(result);
        return retString;
    }

    //编辑广告信息
    public static String addAdvert(String advert_num,String position_id,String advert_url_id,String imgId,String advert_name,String start_time,String end_time,int userId){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String edit_time= BaseCache.getDateTime();
        String start = Utils.transformToYYMMddHHmmss(start_time);
        String end = Utils.transformToYYMMddHHmmss(end_time);
        int sid = sendObjectCreate(724,advert_num,position_id,advert_url_id,imgId,advert_name,1,start,end,operator,edit_time);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String findAdvertList(String position_id){
        int sid = sendObject(732, position_id);
        String result = ResultPoor.getResult(sid);
        String str = StringHandler.getRetString(result);
        System.out.println(str);
        return str;
    }

    //删除广告信息
    public static String delAdvert(String id){

        int sid = sendObjectCreate(725,id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    //修改广告链接状态
    public static String updateAdvertUrlStatus(String status,String ids){

        String[] arr = ids.split(",");
        int sid = 0;
        for (String aid : arr) {
            sid = sendObjectCreate(726,status, aid);
        }
        String result = ResultPoor.getResult(sid);
        return result;
    }

    //删除广告链接信息
    public static String delAdvertUrl(String id){

        int sid = sendObjectCreate(727,id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    //更新广告链接
    public static String updateAdvertUrl(String advertlink_name,String url_link,String remarks,String category,String id,int userId){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String edit_time= BaseCache.getDateTime();
        int sid = sendObjectCreate(728,advertlink_name,url_link,remarks,operator,edit_time,category,id);
        String result = ResultPoor.getResult(sid);
        return result;

    }
    //获取广告信息
    public static String getAdvertInfo(String id){
        int sid = sendObject(730, PropertiesConf.IMG_URL_PREFIX_TEST,id);
        String result = ResultPoor.getResult(sid);
        String retString = StringHandler.getRetString(result);
        System.out.println(retString);
        return retString;
    }

    //编辑广告信息
    public static String updateAdvert(String id,String advert_num,String advert_url_id,String imgId,String advert_name,String start_time,String end_time,int userId){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String start = "";
        boolean status_start = start_time.contains("-");
        if(status_start){
            start = Utils.transformToYYMMddHHmmss(start_time);
        }else{
            start = start_time;
        }
        String end = "";
        boolean status_end = end_time.contains("-");
        if(status_end){
            end = Utils.transformToYYMMddHHmmss(end_time);
        }else{
            end = end_time;
        }
        String edit_time= BaseCache.getDateTime();
        int sid = sendObjectCreate(731,advert_num,advert_url_id,imgId,advert_name,start,end,edit_time,operator,id);
        String result = ResultPoor.getResult(sid);
        return result;
    }


}
