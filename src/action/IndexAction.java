package action;

import action.service.IndexService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "Index", urlPatterns = "/index")
public class IndexAction extends BaseServlet {

    private static final long serialVersionUID = 1L;


    /**
     * 首页查询待处理任务
     * 2018/3/9 木易
     * @return
     */
    public String Selectpending(String status) {
        String res = IndexService.Selectpending(status);
        return res;
    }

}
