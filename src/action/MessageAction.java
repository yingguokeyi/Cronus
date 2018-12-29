package action;

import action.service.MessageService;
import servlet.BaseServlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * @author cuiw
 */
@WebServlet(name = "Message", urlPatterns = "/message")
public class MessageAction extends BaseServlet {

    /**
     * 查询所有发布信息
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
     * @param page
     * @param limit
     * @return
     */
    public String getMessageInfoList(String publisher, String status, String messageType, String sendType,
                                     String memberLevel, String publishMin, String publishMax, String addMin, String addMax, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = MessageService.getMessageInfoList(publisher, status, messageType, sendType,
                memberLevel, publishMin, publishMax, addMin, addMax, (pageI - 1) * limitI, limitI);
        return res;
    }

    public String selectMessageOne(String id) {
        String res = MessageService.selectMessageOne(id);
        return res;
    }

    /**
     * 编辑消息
     *
     * @param messageId      消息主键
     * @param messageType    消息类型 YH 优惠  XT 系统
     * @param scopes         接收消息范围  1 普通  2 小掌柜  3  大掌柜
     * @param messageName    消息名字
     * @param messageContext 消息内容
     * @param showImgIds     宣传图片
     * @param linkAddress    链接地址
     * @param begintime      发送时间
     * @return
     */
    public String updateMessageInfo(HttpServletRequest request, String messageId, String messageType, String scopes, String messageName, String messageContext,
                                    String showImgIds, String linkAddress, String begintime) {
        return MessageService.updateMessageInfo(request, messageId, messageType, scopes, messageName,
                messageContext, showImgIds, linkAddress, begintime);
    }

    /**
     * @param messageId
     * @return
     */
    public String deleteMessageInfo(String messageId) {
        String res = MessageService.deleteMessageInfo(messageId);
        return res;
    }

    public String InsertMessageInfo(HttpServletRequest request, String messageType, String messageScopes, String messageName,
                                    String messageContext, String showImgIds,
                                    String linkAddress, String beginTime) {
        String res = MessageService.InsertMessageInfo(request, messageType, messageScopes, messageName, messageContext, showImgIds, linkAddress, beginTime);
        return res;
    }
}
