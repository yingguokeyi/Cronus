package action;

import javax.servlet.annotation.WebServlet;

import action.service.BaseService;
import action.service.TestService;
import cache.ResultPoor;
import servlet.BaseServlet;

@WebServlet(name = "Test", urlPatterns = "/test")
public class Test extends BaseServlet{
	
	private static final long serialVersionUID = -9039795233261644955L;

	public String testAdd(String a,String b) {
		return TestService.testAdd(a, b);
	}
	
	public String testGet() {
		int sid = BaseService.sendObjectBase(9999, "SELECT sysdate() as libaiå FROM dual");
		return ResultPoor.getResult(sid);
	}
	
}