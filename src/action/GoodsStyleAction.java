package action;


import action.service.GoodsStyleService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/***
 * 商品类型列表
 * 2018/3/7 逍遥子
 */
@WebServlet(name = "GoodsStyle", urlPatterns = "/goodsStyle")
public class GoodsStyleAction extends BaseServlet{

    private static final long serialVersionUID = 1L;

    /**
     * 获取商品类型信息
     * 2018/3/7 逍遥子
     * @return
     */
    public String getGoodsStyleList(String goodsStyleName,String goodsClassify,String page,String limit){
        String sql="";
        if(("".equals(goodsStyleName)==true || goodsStyleName ==null) && ("".equals(goodsClassify)==true || goodsClassify ==null)){
            sql=" GROUP BY Id ORDER BY style.edit_time DESC";
        }else if("".equals(goodsStyleName)!=true && "null".equals(goodsStyleName)!=true){
            goodsStyleName="'%"+goodsStyleName+"%'";
            sql=" AND style.dict_data_name LIKE "+goodsStyleName+" GROUP BY Id ORDER BY style.edit_time DESC";
        }else if("".equals(goodsClassify)!=true && "null".equals(goodsClassify)!=true){
            goodsClassify="'%"+goodsClassify+"%'";
            sql=" AND classifyAtair.dict_data_name LIKE "+goodsClassify+" AND classifySecond.dict_data_name LIKE "+goodsClassify+" AND classifyThree.dict_data_name LIKE "+goodsClassify+" GROUP BY Id ORDER BY style.edit_time DESC";
        }else{
            sql=" AND classifyAtair.dict_data_name LIKE "+goodsClassify+" AND classifySecond.dict_data_name LIKE "+goodsClassify+" AND classifyThree.dict_data_name LIKE "+goodsClassify+" AND style.dict_data_name LIKE "+goodsStyleName+" GROUP BY Id ORDER BY style.edit_time DESC";
        }
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = GoodsStyleService.getGoodsStyleList((pageI-1)*limitI,pageI*limitI,sql);
        return res;

    }

    /**
     * 添加商品类型信息
     * 2018/3/7 逍遥子
     * @param jsonString
     * @return
     */
    public String addGoodsStuleInfo(String jsonString, HttpServletRequest req){
        HttpSession session=req.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());
        String res=GoodsStyleService.addGoodsStuleInfo(jsonString,userId);
        return res;
    }

    /**
     * 获取商品类目
     * 2018/3/7 逍遥子
     * @return
     */
    public String getGoodsClassifyInfo(){
        String res = GoodsStyleService.getGoodsClassifyInfo("商品类目");
        return res;
    }

    /**
     * 删除商品类型
     * 2018/3/11 逍遥子
     * @param ids
     * @return
     */
    public String delGoodsStyleInfo(String ids){
        String res=GoodsStyleService.delGoodsStyleInfo(ids);
        return res;
    }

    /**
     * 编辑商品类型
     * 2018/3/11 逍遥子
     * @param jsonString
     * @return
     */
    public String upGoodsStuleInfo(String jsonString){
        return GoodsStyleService.upGoodsStuleInfo(jsonString);
    }

    public String upGoodsStyleFixed(String ids,String state){
        String res=GoodsStyleService.upGoodsStyleFixed(ids,state);
        return res;
    }
}
