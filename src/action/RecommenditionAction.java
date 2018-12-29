package action;

import action.service.RecommenditionService;
import common.BaseCache;
import common.StringHandler;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * 商品推荐栏目信息
 * @author cuiw
 */
@WebServlet(name = "Recommen", urlPatterns = "/recommen")
public class RecommenditionAction extends BaseServlet {

    /**
     * 栏目列表查询
     *
     * @param cname
     * @param cstatus
     * @param sales
     * @param start_usefultime
     * @param end_usefultime
     * @param page
     * @param limit
     * @return
     */
    public String getColumnList(String cname, String cstatus, String sales, String start_usefultime, String end_usefultime, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = RecommenditionService.getColumnList(cname, cstatus, sales, start_usefultime, end_usefultime, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 修改栏目状态
     *
     * @param cid
     * @param cstatus
     * @param req
     * @return
     */
    public String updateColumnStatus(String cid, String cstatus, HttpServletRequest req) {
        String res = RecommenditionService.updateColumnStatus(cid, cstatus, req);
        return res;
    }

    /**
     * @param column_link
     * @param start_usefultime
     * @param end_usefultime
     * @param page
     * @param limit
     * @return
     */
    public String getColumnLinks(String column_link, String start_usefultime, String end_usefultime, String page, String limit) {
        int pageI = Integer.valueOf(page);
        int limitI = Integer.valueOf(limit);
        String res = RecommenditionService.getColumnLinks(column_link, start_usefultime, end_usefultime, (pageI - 1) * limitI, limitI);
        return res;
    }

    /**
     * 修改栏目链接
     *
     * @param id
     * @param clink_status
     * @param req
     * @return
     */
    public String updateColumnLinkStatus(String id, String clink_status, HttpServletRequest req) {
        String res = RecommenditionService.updateColumnLinkStatus(id, clink_status, req);
        return res;
    }

    /**
     * 逻辑删除栏目链接
     *
     * @param id
     * @return
     */
    public String deleteColumnLink(String id) {
        return RecommenditionService.deleteColumnLink(id);
    }

    /**
     * 查看栏目链接 单条
     *
     * @param id
     * @return
     */
    public String getColumnLinkInfo(String id) {
        return RecommenditionService.getColumnLinkInfo(id);
    }

    /**
     * 修改栏目链接名称
     *
     * @param id
     * @param column_link 栏目链接名称
     * @param url_link    链接
     * @param link_remark 备注
     * @param request
     * @return
     */
    public String updateGoodsLink(String id, String column_link, String url_link, String link_remark,String urlFlag, HttpServletRequest request) {
        String res = RecommenditionService.updateGoodsLink(id, column_link, url_link, link_remark,urlFlag, request);
        // 当前时间
        return res;
    }

    /**
     * 新增栏目链接名称
     *
     * @param column_link
     * @param url_link
     * @param link_remark
     * @param request
     * @return
     */
    public String saveColumnLink(String column_link, String url_link, String link_remark,String urlFlag, HttpServletRequest request) {
        String res = RecommenditionService.saveColumnLink(column_link, url_link, link_remark,urlFlag, request);
        return res;
    }

    /**
     * 批量删除栏目链接
     *
     * @param id
     * @param request
     * @return
     */
    public String batchDelete(String id, HttpServletRequest request) {
        String res = RecommenditionService.batchDelete(id, request);
        return res;
    }

    /**
     * 查看单个栏目链接库信息
     *
     * @param id
     * @return
     */
    public String selectColumuLinkInfo(String id) {
        String res = RecommenditionService.selectColumuLinkInfo(id);
        res = StringHandler.getRetString(res);
        return res;
    }

    /**
     * 更新栏目
     * @param cname
     * @param startTime
     * @param endTime
     * @param imgId
     * @param columnLid
     * @param cproductLinkFlag
     * @param cid
     * @return
     */
    public String updateColumnInfo(String cname,String startTime,String endTime,String imgId,String columnLid,String cproductLinkFlag,String cid){
        String res =  RecommenditionService.updateColumnInfo(cname, startTime, endTime, imgId, columnLid, cproductLinkFlag, cid);
        return res;
    }

    /**
     * 下拉查看可用栏目链接
     * @return
     */
    public String getLinksList(){
        String res =  RecommenditionService.getLinksList();
        return res;
    }



}
