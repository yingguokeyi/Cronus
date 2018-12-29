package action;

import action.service.CertificationService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "Certification", urlPatterns = "/certification")
public class CertificationAction extends BaseServlet {

    private static final long serialVersionUID = 1L;


    /**
     * 会员审核列表
     * 2018/3/15 木易
     * @return
     */
    public String Selectpending(String page,String limit,String phone,String date1, String date2,String nick_name,String audit_status) {
        int pageI = Integer.valueOf(page);
        int limitI =Integer.valueOf(limit);
        String res = CertificationService.Selectpending((pageI-1)*limitI,pageI*limitI,phone,date1,date2,nick_name,audit_status);
        return res;
    }

    /**
     * 会员审核
     * 2018/3/16 木易
     * @return
     */

    public String Passmember(String ids) {
        String res = CertificationService.Passmember(ids);
        return res;
    }
    /**
     * 会员审核(拒绝)
     * 2018/3/16 木易
     * @return
     */

    public String Rejectmember(String ids) {
        String res = CertificationService.Rejectmember(ids);
        return res;
    }

}
