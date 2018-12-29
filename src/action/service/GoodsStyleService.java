package action.service;

import cache.ResultPoor;
import com.alibaba.fastjson.JSONObject;
import common.StringHandler;

import java.lang.Integer;

public class GoodsStyleService extends BaseService{

    public static String addGoodsStuleInfo(String jsonString,int userId){
        JSONObject jsonObject = JSONObject.parseObject(jsonString);
        int dict_id=3;
        String goodsStyleName = jsonObject.get("goodsStyleName").toString();
        String classifyValue = jsonObject.get("classifyValue").toString();
        String classifyValueRe= getSelGoodsStyleToClassify(classifyValue);
//        int classifyValueIn=Integer.valueOf(classifyValueRe.substring(9,12));
////        int classifyValueIn=Integer.valueOf(classifyValueRe);
//        classifyValueRe= Integer.toString(classifyValueIn++);
        int is_fixed = 0;
        String memo="添加商品类型";
        int edit_time=StringHandler.getLongDate();
        int state=1;
        int addSid = sendObjectCreate(51, dict_id,goodsStyleName,classifyValueRe,is_fixed,memo,edit_time,userId,state);
        String rsTest = ResultPoor.getResult(addSid);
        return rsTest;
    }

    public static String getSelGoodsStyleToClassify(String classifyValue){
        int addSid = sendObject(55,classifyValue);
        String rsTest = ResultPoor.getResult(addSid);
        String maxSubCode = StringHandler.getKeyOfResult(rsTest,"dict_data_value");
        String res="";
        if(maxSubCode.length()==9){
            int code=100;
            res=maxSubCode+String.valueOf(code++);
        }else{
            String maxSubCodeStr1=maxSubCode.substring(0,9);
            String maxSubCodeStr2=maxSubCode.substring(9,12);
            int maxSubCodeStr2Int=Integer.valueOf(maxSubCodeStr2);
            maxSubCodeStr2Int=maxSubCodeStr2Int+1;
            maxSubCodeStr2=String.valueOf(maxSubCodeStr2Int);
            res=maxSubCodeStr1+maxSubCodeStr2;
        }
        return res;
    }

    public static  String getGoodsClassifyInfo(String dict_name){
        int getGoodsClassifyInfoSid = sendObject(53,dict_name);
        String getGoodsClassifyInfoSidStr = ResultPoor.getResult(getGoodsClassifyInfoSid);
        return getGoodsClassifyInfoSidStr;
    }

    public static String getGoodsStyleList(int begin,int end,String sql){
        int getGoodsClassifyInfoSid = sendObjectBase(52,sql,begin,end);
        String rsGoodsClassifyInfo = ResultPoor.getResult(getGoodsClassifyInfoSid);
        String rsFinanceJson=StringHandler.getRetString(rsGoodsClassifyInfo);
        return rsFinanceJson;
    }

    public static String delGoodsStyleInfo(String ids){
        String[] id = ids.split(",");
        String rsTest="";
        for (String id1 : id) {
            int delSid = sendObjectCreate(54, id1);
            rsTest = ResultPoor.getResult(delSid);
        }
        return rsTest;
    }


    public static  String upGoodsStuleInfo(String jsonString){
        JSONObject jsonObject = JSONObject.parseObject(jsonString);
        String id = jsonObject.get("id").toString();
        String goodsStyleName = jsonObject.get("goodsStyleName").toString();
        String classifyValue = jsonObject.get("classifyValue").toString();
        int addSid = sendObjectCreate(56, id,goodsStyleName,classifyValue);
        String rsTest = ResultPoor.getResult(addSid);
        return rsTest;
    }


    public static String upGoodsStyleFixed(String ids,String state){
        String[] id = ids.split(",");

        String rsTest="";
        for (String id1 : id) {
            int is_fixed=0;
            if(state.equals("enable")){
                is_fixed=1;
            }
            int delSid = sendObjectCreate(57,is_fixed,id1);
            rsTest = ResultPoor.getResult(delSid);
        }
        return rsTest;
    }
}
