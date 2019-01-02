package action;

import action.service.ArticleService;
import common.StringHandler;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by 18330 on 2018/12/26.
 */
@WebServlet(name = "Article",urlPatterns = "/article")
public class ArticleAction extends BaseServlet {

    //查询文章列表
    public String getArticleList(String page, String limit,String article_content,String article_source,String status,String start_time,String end_time){
        int pageI = (page == null ? 1 : Integer.valueOf(page));
        int limitI = (limit == null ? 10 : Integer.valueOf(limit));
        String articleList = ArticleService.getArticleList((pageI - 1) * limitI, limitI, article_content, article_source,status,start_time,end_time);
        return StringHandler.getRetString(articleList);
    }

    //插入文章
    public String addArticle(String article_title,String article_content,String link_address,String imgId,String article_source,HttpServletRequest req){
        String res = ArticleService.addArticle(article_title,article_content,link_address,imgId,article_source, req);
        return res;
    }

    //修改文章状态
    public String updateArticleStatus(String status, String id,HttpServletRequest request){

        HttpSession session=request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String res = ArticleService.updateArticleStatus(status, id,userId);
        return res;
    }

    //删除文章
    public String delArticle(String id){
        String res = ArticleService.delArticle(id);
        return res;
    }

    //查询文章详情
    public String getArticleInfo(String id){
        String articleInfo = ArticleService.getArticleInfo(id);
        return StringHandler.getRetString(articleInfo);
    }

    //修改文章内容
    public String updateArticle(String article_title,String article_content,String link_address,String imgId,String article_source,String articalId,HttpServletRequest req){
        String res = ArticleService.updateArticle(article_title,article_content, link_address,imgId,article_source,articalId,req);
        return res;
    }
}
