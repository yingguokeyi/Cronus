package action.service;

import cache.ResultPoor;

public class GoodsAttributeService extends BaseService{


    public static  String getGoodsAttributeInfo(String spuId){
        int sid = sendObject(27,spuId);
        String result = ResultPoor.getResult(sid);
        return result;
    }

}
