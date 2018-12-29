package action.service;

import cache.ResultPoor;

public class DictionaryService extends BaseService {



	//查询单个字典信息
	public static String getDict(String id) {
		int sid = sendObjectCreate(20,id);
		String result = ResultPoor.getResult(sid);
		return result;
	}



	//更新fixed (启用禁用)
	public static String updateFixed(String status,String id) {
		int sid = sendObjectCreate(23, status,id);
		String result = ResultPoor.getResult(sid);
		return result;
	}



	//更新排序
	public static String updateSort(String sort,String id) {
		int sid = sendObjectCreate(34, sort,id);
		String result = ResultPoor.getResult(sid);
		return result;
	}


	//更新state (用于逻辑删除)
	public static String updateState(String state,String id) {
		int sid = sendObjectCreate(25, state,id);
		String result = ResultPoor.getResult(sid);
		return result;
	}


	public static String getAllNormalDictListByDictId(String dictId){
		int sid = sendObject(318,dictId);
		return ResultPoor.getResult(sid);
	}

}