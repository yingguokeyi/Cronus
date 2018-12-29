package common.kuaidi;

import java.util.HashMap;

/**
 * Created by 18330 on 2018/6/29.
 */
public class ExpressPush {

    public static void subscribe(String Company,String number){
        TaskRequest req = new TaskRequest();
        req.setCompany(Company);
        req.setNumber(number);
        req.getParameters().put("callbackurl", "http://5kspsm.natappfree.cc/kuaidi");
        req.setKey("OiaZLpGL7251");

        HashMap<String, String> p = new HashMap<String, String>();
        p.put("schema", "json");
        p.put("param", JacksonHelper.toJSON(req));
        try {
            String ret = HttpRequest.postData("http://poll.kuaidi100.com/poll", p, "UTF-8");
            TaskResponse resp = JacksonHelper.fromJSON(ret, TaskResponse.class);
            if(resp.getResult()==true){
                System.out.println("订阅成功");
            }else{
                System.out.println("订阅失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
