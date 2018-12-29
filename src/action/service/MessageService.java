package action.service;

import cache.ResultPoor;
import common.BaseCache;
import common.PropertiesConf;
import common.StringHandler;
import common.Utils;

import javax.servlet.http.HttpServletRequest;

/**
 * @author cuiw
 */
public class MessageService extends BaseService {

    /**
     * * 查询所有发布信息
     *
     * @param publisher   发布人
     * @param status      状态
     * @param messageType 信息类型
     * @param sendType    发送方式
     * @param memberLevel 接收信息范围
     * @param publishMin
     * @param publishMax
     * @param addMin
     * @param addMax
     * @param pageI
     * @param limitI
     * @return
     */
    public static String getMessageInfoList(String publisher, String status, String messageType, String sendType,
                                            String memberLevel, String publishMin, String publishMax, String addMin, String addMax, int pageI, int limitI) {
        StringBuffer sql = new StringBuffer();
        // 用户条件查询
        // 查询条件
        if (publisher != null && !publisher.equals("")) {
            sql.append(" AND msg.create_user LIKE '%").append(publisher).append("%'");
        }

        if (status != null && !status.equals("")) {
            sql.append(" AND msg.status = '").append(status).append("'");
        }

        if (messageType != null && !"".equals(messageType)) {
            sql.append(" AND msg.message_type LIKE '%").append(messageType).append("'");
        }

//        if (sendType != null && !"".equals(sendType)) {
//            sql.append(" AND send_type LIKE '%").append(sendType).append("'");
//        }

        if (memberLevel != null && !"".equals(memberLevel)) {
            sql.append(" AND msg.member_level = '").append(memberLevel).append("'");
        }

        if (publishMin != null && !"".equals(publishMin)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(publishMin);
            sql.append(" and msg.publish_time between '").append(created_date1).append("'");
        }
        if (publishMax != null && !"".equals(publishMax)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(publishMax);
            sql.append(" and '").append(created_date1).append("'");
        }

        if (addMin != null && !"".equals(addMin)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(addMin);
            sql.append(" and msg.publish_time between '").append(created_date1).append("'");
        }
        if (addMax != null && !"".equals(addMax)) {
            String created_date1 = Utils.transformToYYMMddHHmmss(addMax);
            sql.append(" and '").append(created_date1).append("'");
        }

        sql.append(" ORDER BY msg.publish_time DESC");

        int sid = sendObjectBase(468, sql.toString(), PropertiesConf.IMG_URL_PREFIX, pageI, limitI);
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    public static String selectMessageOne(String id) {
        int sid = sendObject(469, PropertiesConf.IMG_URL_PREFIX, id);
        String res = ResultPoor.getResult(sid);
        return StringHandler.getRetString(res);
    }

    public static String updateMessageInfo(HttpServletRequest request, String messageId, String messageType, String scopes, String messageName, String messageContext,
                                           String showImgIds, String linkAddress, String begintime) {
        String createTime = Utils.transformToYYMMddHHmmss(begintime);
        int userId = StringHandler.getUserId(request);
        String[] scopeStr = scopes.split(",");
        StringBuffer temp = new StringBuffer();
        String scopeValue = "";
        for (int i = 0; i < scopeStr.length; i++) {
            System.out.println(scopeStr[i] == "");
            if (!"".equals(scopeStr[i])) {
                temp.append(scopeStr[i] + ",");
            }
            if (i == scopeStr.length - 1) {
                scopeValue = temp.substring(0, temp.lastIndexOf(","));
            }
        }
        if (showImgIds == "") {
            showImgIds = "0";
        }
        int uid = sendObjectCreate(470, messageType, scopeValue, messageName, messageContext, showImgIds, createTime, userId, createTime, linkAddress, userId, messageId);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    /**
     * 删除消息
     *
     * @param messageId
     * @return
     */
    public static String deleteMessageInfo(String messageId) {
        int uid = sendObjectCreate(472, "1", messageId);
        String res = ResultPoor.getResult(uid);
        return res;
    }

    public static String InsertMessageInfo(HttpServletRequest request, String messageType, String messageScopes, String messageName,
                                           String messageContext, String showImgIds,
                                           String linkAddress, String beginTime) {
        String createTime = Utils.transformToYYMMddHHmmss(beginTime);
        int userId = StringHandler.getUserId(request);
        String[] scopeStr = messageScopes.split(",");
        StringBuffer temp = new StringBuffer();
        String scopeValue = "";
        for (int i = 0; i < scopeStr.length; i++) {
            System.out.println(scopeStr[i] == "");
            if (!"".equals(scopeStr[i])) {
                temp.append(scopeStr[i] + ",");
            }
            if (i == scopeStr.length - 1) {
                scopeValue = temp.substring(0, temp.lastIndexOf(","));
            }
        }
        if (showImgIds == null) {
            showImgIds = "0";
        }
        int uid = sendObjectCreate(474, messageType, scopeValue, messageName, messageContext, showImgIds, BaseCache.getTIME(), userId,userId, createTime, linkAddress);
        String res = ResultPoor.getResult(uid);
        return res;
    }
}
