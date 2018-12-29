package action.service;

import cache.ResultPoor;
import common.BaseCache;
import common.PropertiesConf;
import common.StringHandler;
import common.Utils;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;

/**
 * @author cuiw
 */
public class RecommenditionService extends BaseService {

    public static String getColumnList(String cname, String cstatus, String sales, String start_usefultime, String end_usefultime, int pageI, int limitI) {

        StringBuffer sql = new StringBuffer();
        // 用户条件查询
        //查询条件
        if (cname != null && !cname.equals("")) {
            sql.append(" AND cname LIKE '%").append(cname).append("%'");
        }
        if (cstatus != null && !cstatus.equals("")) {
            sql.append(" AND cstatus = '").append(cstatus).append("'");
        }
        if (start_usefultime != null && !"".equals(start_usefultime)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(start_usefultime);
            sql.append(" and start_usefultime between '").append(created_date1).append("'");
        }
        if (end_usefultime != null && !"".equals(end_usefultime)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(end_usefultime);
            sql.append(" and '").append(created_date1).append("'");
        }
        int sid = BaseService.sendObjectBase(417, sql.toString(), pageI, limitI);
        String res = StringHandler.getRetString(ResultPoor.getResult(sid));
        return res;
    }

    /**
     * 修改栏目状态
     *
     * @param cid
     * @param cstatus
     * @param request
     * @return
     */
    public static String updateColumnStatus(String cid, String cstatus, HttpServletRequest request) {
        int userId = StringHandler.getUserId(request);
        long dateTime = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(dateTime);
        String dateTimeStr = Utils.transformToYYMMddHHmmss(dateStr);
        int sid = sendObjectCreate(418, cstatus, dateTimeStr, userId, Integer.valueOf(cid));
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     * 查询链接库
     *
     * @param column_link
     * @param start_usefultime
     * @param end_usefultime
     * @return
     */
    public static String getColumnLinks(String column_link, String start_usefultime, String end_usefultime, int pageI, int limitI) {
        StringBuffer sql = new StringBuffer();
        // 用户条件查询
        //查询条件
        if (column_link != null && !column_link.equals("")) {
            sql.append(" AND column_link LIKE '%").append(column_link).append("%'");
        }

        if (start_usefultime != null && !"".equals(start_usefultime)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(start_usefultime);
            sql.append(" and last_oper_time between '").append(created_date1).append("'");
        }
        if (end_usefultime != null && !"".equals(end_usefultime)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(end_usefultime);
            sql.append(" and '").append(created_date1).append("'");
        }
        int sid = sendObjectBase(422, sql.toString(), pageI, limitI);
        return StringHandler.getRetString(ResultPoor.getResult(sid));
    }

    /**
     * @param id
     * @param clink_status
     * @param req
     * @return
     */
    public static String updateColumnLinkStatus(String id, String clink_status, HttpServletRequest req) {
        int userId = StringHandler.getUserId(req);
        long dateTime = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(dateTime);
        String dateTimeStr = Utils.transformToYYMMddHHmmss(dateStr);
        int sid = sendObjectCreate(423, clink_status, dateTimeStr, userId, Integer.valueOf(id));
        String result = ResultPoor.getResult(sid);
        return result;
    }

    /**
     * 逻辑删除栏目链接库信息
     *
     * @param id
     * @return
     */
    public static String deleteColumnLink(String id) {
        int uid = sendObjectCreate(424, id);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 查看栏目链接库信息 单条
     *
     * @param id
     * @return
     */
    public static String getColumnLinkInfo(String id) {
        int gid = sendObject(425, id);
        return StringHandler.getRetString(ResultPoor.getResult(gid));
    }

    /**
     * 栏目链接库更新
     *
     * @param column_link
     * @param url_link
     * @param link_remark
     * @param request
     * @return
     */
    public static String updateGoodsLink(String id, String column_link, String url_link, String link_remark,String urlFlag, HttpServletRequest request) {
        String curTime = BaseCache.getDateTime();
        int userid = StringHandler.getUserId(request);
        int uid = sendObjectCreate(426, column_link, url_link, link_remark, curTime, userid,urlFlag, id);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 新增栏目链接库信息
     * @param column_link
     * @param url_link
     * @param link_remark
     * @param request
     * @return
     */
    public static String saveColumnLink(String column_link, String url_link, String link_remark,String urlFlag, HttpServletRequest request) {
        String curTime = BaseCache.getDateTime();
        int userid = StringHandler.getUserId(request);
        int uid = sendObjectCreate(428, column_link, curTime,url_link, link_remark, curTime, userid,"1",0,urlFlag);
        // 最后两个参数含义 clink_status = '1' 栏目状态正常 is_default = 0  未删除的
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 批量删除栏目链接
     * @param id
     * @param request
     * @return
     */
    public static String batchDelete(String id, HttpServletRequest request){
        String curTime = BaseCache.getDateTime();
        int userid = StringHandler.getUserId(request);
        String[] idStr = id.split(",");
        String res = "";
        for (int i = 0; i < idStr.length; i++) {
            int uid = sendObjectCreate(429,curTime,userid,1,Integer.parseInt(idStr[i]));
            res = ResultPoor.getResult(uid);
        }
        return res;
    }

    /**
     * 查看栏目链接库信息
     * @param id
     * @return
     */
    public static String selectColumuLinkInfo(String id){
        int sid = sendObject(430, PropertiesConf.IMG_URL_PREFIX ,id);
        String res = ResultPoor.getResult(sid);
        return res;
    }

    /**
     * 更新栏目信息
     * @param cname
     * @param startTime
     * @param endTime
     * @param imgId
     * @param columnLid
     * @param cproductLinkFlag
     * @param cid
     * @return
     */
    public static String updateColumnInfo(String cname,String startTime,String endTime,String imgId,String columnLid,String cproductLinkFlag,String cid){
        startTime = Utils.transformToYYMMddHHmmss(startTime);
        if (endTime == "999999999999") {

        } else if ("".equals(endTime)) {
            endTime = "999999999999";
        } else{
            endTime = Utils.transformToYYMMddHHmmss(endTime);
        }
        int uid = sendObjectCreate(448, cname, startTime, endTime, imgId, columnLid, cproductLinkFlag, cid);
        String res =  ResultPoor.getResult(uid);
        return res;
    }

    public static String getLinksList(){
        int sid =  sendObject(449);
        String res =  ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }
}