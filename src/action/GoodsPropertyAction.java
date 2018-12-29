package action;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSONObject;

import action.service.GoodsPropertyService;
import common.StringHandler;
import servlet.BaseServlet;

/***
 * 商品类型列表
 * 2018/3/7 逍遥子
 */
@WebServlet(name = "GoodsProperty", urlPatterns = "/goodsProperty")
public class GoodsPropertyAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    /**
     * 获取类型下的属性信息
     * @param goodsTypeId
     * @param page
     * @param limit
     * @return
     */
    public String getGoodsPropertyList(String goodsTypeId,String page,String limit){
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = GoodsPropertyService.getGoodsPropertyList(goodsTypeId,(pageI-1)*limitI,pageI*limitI);
        return res;
    }


    /**
     * 添加属性信息
     * 逍遥子_20180319
     * @param goodsTypeId
     * @param jsonStr
     * @param req
     * @return
     */
    public String addGoodsPropertyInfo(String goodsTypeId, String jsonStr, HttpServletRequest req){
        JSONObject JO = JSONObject.parseObject(jsonStr);
        int entry_mode = Integer.valueOf(JO.get("entry_mode")==null? "":(JO.get("entry_mode").toString()));
        String entry_modeValue="";
        if(entry_mode==1){
            entry_modeValue = JO.get("entry_modeValue")==null? "":(JO.get("entry_modeValue").toString());
        }

        HttpSession session=req.getSession();
        String userId=String.valueOf(session.getAttribute("userId"));
        String res = GoodsPropertyService.addGoodsPropertyInfo(goodsTypeId,jsonStr,userId);
        JSONObject addGoodsPropertyInfoJO = JSONObject.parseObject(res);
        String addGoodsPropertyInfoSuccess = addGoodsPropertyInfoJO.get("success")==null? "":(addGoodsPropertyInfoJO.get("success").toString());
        String resGoodsStyleProperty ="";
        String addGoodsPropertyValueInfoRes ="";
        if(addGoodsPropertyInfoSuccess.equals("1")){
            int attrId = Integer.valueOf(StringHandler.getIdsOfResult(res));
            resGoodsStyleProperty = GoodsPropertyService.addGoodsStylePropertyInfo(goodsTypeId,attrId);
            JSONObject.parseObject(resGoodsStyleProperty);
            String addGoodsPropertyInfoSuccess2 = addGoodsPropertyInfoJO.get("success")==null? "":(addGoodsPropertyInfoJO.get("success").toString());
            if(addGoodsPropertyInfoSuccess2.equals("1")){
                addGoodsPropertyValueInfoRes = GoodsPropertyService.addGoodsPropertyValueInfo(entry_modeValue,attrId,userId);
            }
        }
        return addGoodsPropertyValueInfoRes;
    }

    /**
     * 变更属性类型
     * 逍遥子_20180319
     * @param id
     * @param status
     * @param req
     * @return
     */
    public String upGoodsPropertyAttributeType(String id,String status,HttpServletRequest req){
        HttpSession session=req.getSession();
        String userId=String.valueOf(session.getAttribute("userId"));
        String res = GoodsPropertyService.upGoodsPropertyAttributeType(id,status,userId);
        return res;
    }

    /**
     * 属性值列表
     * 逍遥子_20180321
     * @param goodsPropertyId
     * @param page
     * @param limit
     * @return
     */
    public String getGoodsPropertyValList(String goodsPropertyId,String page,String limit){
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = GoodsPropertyService.getGoodsPropertyValList(goodsPropertyId,(pageI-1)*limitI,pageI*limitI);
        return res;
    }

    /**
     * 删除属性值
     * 逍遥子_20180332
     * @param ids
     * @param req
     * @return
     */
    public String delGoodsPropertyValueInfo(String ids,HttpServletRequest req){
        HttpSession session=req.getSession();
        String userId=String.valueOf(session.getAttribute("userId"));
        String res = GoodsPropertyService.delGoodsPropertyValueInfo(ids,userId);
        return res;
    }

    /**
     * 添加属性值
     * 逍遥子_20180323
     * @param goodsProperty_id
     * @param goodsPropertyVal
     * @param req
     * @return
     */
    public String addGoodsPropertyValueInfo(String goodsProperty_id,String goodsPropertyVal,HttpServletRequest req){
        HttpSession session=req.getSession();
        String userId=String.valueOf(session.getAttribute("userId"));
        int goodsProperty_idInt=Integer.valueOf(goodsProperty_id);
        String res = GoodsPropertyService.addGoodsPropertyValueInfo(goodsPropertyVal,goodsProperty_idInt,userId);
        return res;
    }

    /**
     * 编辑属性值
     * 逍遥子_20180323
     * @param id
     * @param goodsPropertyVal
     * @param req
     * @return
     */
    public String editGoodsPropertyValueInfo(String id,String goodsPropertyVal,HttpServletRequest req){
        HttpSession session=req.getSession();
        String userId=String.valueOf(session.getAttribute("userId"));
        int idInt=Integer.valueOf(id);
        String res = GoodsPropertyService.editGoodsPropertyValueInfo(idInt,goodsPropertyVal,userId);
        return res;
    }
}
