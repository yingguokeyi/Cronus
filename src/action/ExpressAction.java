package action;

import com.alibaba.fastjson.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

@WebServlet(name = "Express", urlPatterns = "/express")
public class ExpressAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    private static MessageDigest _mdInst = null;
    private static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    public String getExpressDatainfo(String waybill_no,String express_company){

        String param ="{\"com\":\""+ express_company +"\",\"num\":\""+ waybill_no +"\"}";
        String customer ="2B3D5DAE6EA5B286EC5169ED3D5FDBE8";
        String key = "OiaZLpGL7251";
        String sign = encode(param+key+customer).toUpperCase();
        HashMap params = new HashMap();
        params.put("param",param);
        params.put("sign",sign);
        params.put("customer",customer);
        String resp = null;
        try {
            resp = postData("http://poll.kuaidi100.com/poll/query.do?", params, "utf-8").toString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resp;

    }

    private static MessageDigest getMdInst() {
        if (_mdInst == null) {
            try {
                _mdInst = MessageDigest.getInstance("MD5");
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
        }
        return _mdInst;
    }
    public static String encode(String s) {
        try {
            byte[] btInput = s.getBytes();
            // 使用指定的字节更新摘要
            getMdInst().update(btInput);
            // 获得密文
            byte[] md = getMdInst().digest();
            // 把密文转换成十六进制的字符串形式
            int j = md.length;
            char str[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public static String addUrl(String head, String tail) {
        if (head.endsWith("/")) {
            if (tail.startsWith("/")) {
                return head.substring(0, head.length() - 1) + tail;
            } else {
                return head + tail;
            }
        } else {
            if (tail.startsWith("/")) {
                return head + tail;
            } else {
                return head + "/" + tail;
            }
        }
    }


    public synchronized static String postData(String url, Map<String, String> params, String codePage) throws Exception {

        final HttpClient httpClient = new HttpClient();
        httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(25 * 1000);
        httpClient.getHttpConnectionManager().getParams().setSoTimeout(30 * 1000);

        final PostMethod method = new PostMethod(url);
        if (params != null){
            method.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET,codePage);
            method.setRequestBody(assembleRequestParams(params));
        }
        String result = "";
        try{
            httpClient.executeMethod(method);
            result = new String(method.getResponseBody(),codePage);
        }catch (final  Exception e){
            throw e;
        }finally {
            method.releaseConnection();
        }

        return result;
    }

    public synchronized static String postData(String url, String codePage) throws Exception {

        final HttpClient httpClient = new HttpClient();
        httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(10 * 1000);
        httpClient.getHttpConnectionManager().getParams().setSoTimeout(30 * 1000);

        final PostMethod method = new PostMethod(url);
        String result = "";
        try{
            httpClient.executeMethod(method);
            result = new String(method.getResponseBody(),codePage);
        }catch (final  Exception e){
            throw e;
        }finally {
            method.releaseConnection();
        }
        return null;
    }

    private synchronized static NameValuePair[] assembleRequestParams(Map<String, String> data) {
        final List<NameValuePair> nameValueList = new ArrayList<NameValuePair>();
        Iterator<Map.Entry<String, String>> it = data.entrySet().iterator();
        while (it.hasNext()){
            Map.Entry<String, String> entry = (Map.Entry<String, String>)it.next();
            nameValueList.add(new NameValuePair((String) entry.getKey(),(String)entry.getValue()));
        }

        return nameValueList.toArray(new NameValuePair[nameValueList.size()]);
    }



}
