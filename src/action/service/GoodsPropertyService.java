package action.service;


import cache.ResultPoor;
import com.alibaba.fastjson.JSONObject;
import common.StringHandler;

public class GoodsPropertyService extends BaseService{

    public static String getGoodsPropertyList(String goodsTypeId,int begin,int end){
        int goodsTypeIdInt=Integer.valueOf(goodsTypeId);
        int sid = sendObject(67,goodsTypeIdInt,begin,end);
        String rsGoodsPropertyInfo = ResultPoor.getResult(sid);
        String rsGoodsPropertyInfoJson= StringHandler.getRetString(rsGoodsPropertyInfo);
        return rsGoodsPropertyInfoJson;
    }


    /**
     * 添加属性信息
     * 逍遥子_20180319
     * @param goodsTypeId
     * @param jsonStr
     * @param userId
     * @return
     */
    public static String addGoodsPropertyInfo(String goodsTypeId,String jsonStr,String userId){
        JSONObject JO = JSONObject.parseObject(jsonStr);
        String attribute_name = (JO.get("attribute_name")==null? "":(JO.get("attribute_name").toString()));
        int attribute_type = Integer.valueOf(JO.get("attribute_type")==null? "":(JO.get("attribute_type").toString()));
        int retrieval_style = Integer.valueOf(JO.get("retrieval_style")==null? "":(JO.get("retrieval_style").toString()));
        int screening_project = Integer.valueOf(JO.get("screening_project")==null? "":(JO.get("screening_project").toString()));
        int commonattrbuteisnorelation = Integer.valueOf(JO.get("commonattrbuteisnorelation")==null? "":(JO.get("commonattrbuteisnorelation").toString()));
        int entry_mode = Integer.valueOf(JO.get("entry_mode")==null? "":(JO.get("entry_mode").toString()));
        int order_num = getMaxAttributeOrderNumOnGoodsStyle(goodsTypeId);
        int create_user = Integer.valueOf(userId);
        int create_time = StringHandler.getLongDate();
        int addSid = sendObjectCreate(68, attribute_name,attribute_type,entry_mode,retrieval_style,screening_project,commonattrbuteisnorelation,order_num,create_user,create_time);
        String rsTest = ResultPoor.getResult(addSid);
        return rsTest;
    }

    /**
     * 获取当前类型下最大的属性编号
     * 逍遥子_20180319
     * @param goodsTypeId
     * @return
     */
    public static Integer getMaxAttributeOrderNumOnGoodsStyle(String goodsTypeId){
        int goodsTypeIdInt=Integer.valueOf(goodsTypeId);
        int sid = sendObject(69,goodsTypeIdInt);
        String rsTest = ResultPoor.getResult(sid);
        String max_ordernum = StringHandler.getKeyOfResult(rsTest,"max_ordernum");
        int max_ordernumInt=0;
        if(max_ordernum.equals("")){
            max_ordernumInt=1;
        }else{
            max_ordernumInt=Integer.valueOf(max_ordernum);
            max_ordernumInt++;
        }
        return max_ordernumInt;
    }

    /**
     * 添加类型与属性关系表数据
     * 逍遥子_20180319
     * @param goodsTypeId
     * @param attrId
     * @return
     */
    public static String addGoodsStylePropertyInfo(String goodsTypeId,int attrId){
        int goodsTypeIdInt=Integer.valueOf(goodsTypeId);
        int addSid = sendObjectCreate(70, goodsTypeIdInt,attrId);
        String rsTest = ResultPoor.getResult(addSid);
        return rsTest;
    }

    /**
     * 添加属性值
     * 逍遥子_20180319
     * @param entry_modeValue
     * @param attrId
     * @param userId
     * @return
     */
    public static String addGoodsPropertyValueInfo(String entry_modeValue,int attrId,String userId){
        int create_user = Integer.valueOf(userId);
        int create_time = StringHandler.getLongDate();
        int addSid = sendObjectCreate(71,attrId,entry_modeValue,0,create_user,create_time);
        String rsTest = ResultPoor.getResult(addSid);
        return rsTest;
    }

    /**
     * 变更属性类型
     * 逍遥子_20180319
     * @param id
     * @param status
     * @param userId
     * @return
     */
    public static String upGoodsPropertyAttributeType(String id,String status,String userId){
        int statusInt=Integer.valueOf(status);
        int idInt=Integer.parseInt(id);
        int edit_user = Integer.valueOf(userId);
        int edit_time = StringHandler.getLongDate();
        int updateSid = sendObjectCreate(72,statusInt,edit_user,edit_time,idInt);
        String rsTest = ResultPoor.getResult(updateSid);
        return rsTest;
    }

    public static String getGoodsPropertyValList(String goodsPropertyId,int begin,int end){
        int goodsPropertyIdInt=Integer.valueOf(goodsPropertyId);
        int sid = sendObject(77,goodsPropertyIdInt,begin,end);
        String rsGoodsPropertyInfo = ResultPoor.getResult(sid);
        String rsGoodsPropertyInfoJson= StringHandler.getRetString(rsGoodsPropertyInfo);
        return rsGoodsPropertyInfoJson;
    }

    public static String delGoodsPropertyValueInfo(String ids,String userId){
        int id=Integer.valueOf(ids);
        int userIdInt=Integer.valueOf(userId);
        int edit_time = StringHandler.getLongDate();
        int sid = sendObjectCreate(79,1,userIdInt,edit_time,id);
        String rsGoodsPropertyInfo = ResultPoor.getResult(sid);
        return rsGoodsPropertyInfo;
    }


    public static String editGoodsPropertyValueInfo(int idInt,String goodsPropertyVal,String userId){
        int userIdInt=Integer.valueOf(userId);
        int edit_time = StringHandler.getLongDate();
        int sid = sendObjectCreate(80,goodsPropertyVal,userIdInt,edit_time,idInt);
        String rsGoodsPropertyInfo = ResultPoor.getResult(sid);
        return rsGoodsPropertyInfo;
    }
}
