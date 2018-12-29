package action;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import action.service.BaseService;
import cache.ResultPoor;
import servlet.BaseServlet;

@WebServlet(name = "Demo", urlPatterns = "/demo")
public class DemoAction extends BaseServlet {

	private static final long serialVersionUID = -9039795233261644955L;

	public String addData(String jsonString, HttpServletRequest req) {
		int sid = BaseService.sendObjectBase(9999,"SELECT date_format(now(),'%Y-%m-%d %H:%I:%S') as sysdate FROM dual");
		return ResultPoor.getResult(sid);
	}
}