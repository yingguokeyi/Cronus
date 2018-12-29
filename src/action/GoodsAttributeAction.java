package action;


import javax.servlet.annotation.WebServlet;

import action.service.GoodsAttributeService;
import servlet.BaseServlet;

@WebServlet(name = "GoodsAttribute", urlPatterns = "/goodsAttribute")
public class GoodsAttributeAction extends BaseServlet{

    private static final long serialVersionUID = 1L;


    /**
     * 获取attribute 信息
     * 2018/3/13 luyou
     * @return
     */
    public String getGoodsAttributeInfo(String spuId){


        String res = GoodsAttributeService.getGoodsAttributeInfo(spuId);
        return res;
    }


}
