package action.service;

import action.sqlhelper.MemberSql;
import cache.ResultPoor;
import common.BaseCache;
import common.PropertiesConf;
import common.Utils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by 18330 on 2018/12/26.
 */
public class ArticleService extends BaseService {

    public static String getArticleList(int pageI,int limitI,String article_content,String article_source,String status,String start_time,String end_time){
        StringBuffer sql = new StringBuffer();
        sql.append(MemberSql.getArticleListPage_sql);
        if (!"".equals(article_content) && article_content != null){
            sql.append(" and article_content LIKE '%").append(article_content).append("%'");
        }
        if (!"".equals(article_source) && article_source != null){
            sql.append(" and article_source LIKE '%").append(article_source).append("%'");
        }
        if (!"".equals(status) && status != null){
            sql.append(" and status = ").append(status);
        }
        if ((start_time != null && !"".equals(start_time)) || (end_time!=null && !"".equals(end_time))) {
            String bDate = Utils.transformToYYMMddHHmmss(start_time);
            String eDate = Utils.transformToYYMMddHHmmss(end_time);
            System.out.println(bDate);
            sql.append(" and create_time BETWEEN ").append(bDate).append(" and ").append(eDate);
        }
        sql.append(" order by create_time desc ");
        int sid = BaseService.sendObjectBase(9997,sql.toString(),pageI,limitI);
        String res = ResultPoor.getResult(sid);
        return res;
    }

    public static String addArticle(String article_title,String article_content,String link_address,String imgId,String article_source,HttpServletRequest req){
        String currentTime = BaseCache.getTIME();

        int uid = sendObjectCreate(998,article_title,article_content,link_address,article_source,currentTime,0,imgId);
        String res = ResultPoor.getResult(uid);
        return res;

    }

    public static String updateArticleStatus(String status,String id,int userId){
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String edit_time= BaseCache.getDateTime();
        int sid = sendObjectCreate(999, status,edit_time,operator,id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String delArticle(String id){
        int sid = sendObjectCreate(1000,id);
        String result = ResultPoor.getResult(sid);
        return result;
    }

    public static String getArticleInfo(String id){
        int sid = sendObject(1001, PropertiesConf.IMG_URL_PREFIX_TEST,id);
        String res = ResultPoor.getResult(sid);
        return res;
    }


    public static String updateArticle(String article_title,String article_content,String link_address,String imgId,String article_source,String articalId,HttpServletRequest req){

        HttpSession session=req.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        int uId = UserService.checkUserPwdFirstStep(userId);
        String operator = UserService.selectLoginName(uId);
        String edit_time= BaseCache.getDateTime();

        int uid = sendObjectCreate(1002,article_title,article_content,link_address,article_source,edit_time,operator,imgId,articalId);
        String res = ResultPoor.getResult(uid);
        return res;

    }

}
