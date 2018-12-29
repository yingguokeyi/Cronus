package action.service;

import cache.ResultPoor;

public class TestService extends BaseService {
	public static String testAdd(String a, String b) {
		int addSid = sendObjectCreate(6, a, b);
		String rsTest = ResultPoor.getResult(addSid);
		return rsTest;
	}
}