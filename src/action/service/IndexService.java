package action.service;

import cache.ResultPoor;
import common.StringHandler;

public class IndexService extends BaseService{


    public static String Selectpending(String status){
        int sid = sendObject(83,status);
        String rsIndex = ResultPoor.getResult(sid);
        String OBIndex =StringHandler.getRetString(rsIndex);
        return OBIndex;
    }

}
