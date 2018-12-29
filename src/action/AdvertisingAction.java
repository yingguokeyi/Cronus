package action;

import action.service.AdvertisingService;
import action.service.UploadService;
import com.alibaba.fastjson.JSONObject;
import common.CreateFileUtil;
import common.PropertiesConf;
import common.Utils;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by 18330 on 2018/6/6.
 */
@WebServlet(name = "Advertising", urlPatterns = "/advertising")
public class AdvertisingAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    //广告位列表查询
    public String getPositionList(String operator,String page_location,String edit_time,String editend_time,String market_time,String marketend_time,String page, String limit){

        int pageI = Integer.valueOf(page);
        int end = Integer.valueOf(limit);

        return AdvertisingService.getPositionList(operator,page_location,edit_time,editend_time,market_time,marketend_time,(pageI - 1) * end, end);
    }
    //修改广告位状态
    public String updatePositionStatus(String status,String ids){
        String res = AdvertisingService.updatePositionStatus(status,ids);
        return res;
    }
    //编辑广告位
    public String updatePositionEdit(String id,String position_name,String page_location,String position,String market_time,String marketend_time,String playback_length,HttpServletRequest request){

        HttpSession session=request.getSession();
        int userId=Integer.valueOf(session.getAttribute("userId").toString());

        String res = AdvertisingService.updatePositionEdit(id, position_name, page_location, position, market_time, marketend_time, playback_length,userId);
        return res;
    }

    //广告列表查询
    public String getAdvertList(String position_id,String status,String start_time,String end_time,String page, String limit){

        int pageI = Integer.valueOf(page);
        int end = Integer.valueOf(limit);
        return AdvertisingService.getAdvertList(position_id,status,start_time,end_time,(pageI - 1) * end, end);
    }

    //修改广告状态
    public String updateAdvertStatus(String status,String ids){
        String res = AdvertisingService.updateAdvertStatus(status,ids);
        return res;
    }

    //查询广告所在广告位信息
    public String getInPosition(String id){
        String res = AdvertisingService.getInPosition(id);
        return res;
    }

    //添加广告链接
    public String addAdvertUrl(String advertlink_name,String url_link,String remarks,String category,HttpServletRequest request){
        HttpSession session = request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String str = AdvertisingService.addAdvertUrl(advertlink_name, url_link, remarks,userId,category);
        return str;
    }

    //查询广告链接库
    public String getUrlList(String operator,String advertlink_name,String edit_time,String editend_time){
        String urlList = AdvertisingService.getUrlList(operator,advertlink_name,edit_time,editend_time);
        return urlList;
    }

    //编辑广告信息
    public String addAdvert(String advert_num,String position_id,String advert_url_id,String imgId,String advert_name,String start_time,String end_time,HttpServletRequest request){

        String advertList = AdvertisingService.findAdvertList(position_id);
        JSONObject getAdvertList = JSONObject.parseObject(advertList);
        int size = getAdvertList.getJSONArray("rs").size();
        if(size != 0){

            for (int i=0;i<size;i++){
                JSONObject jsonObject = getAdvertList.getJSONArray("rs").getJSONObject(i);
                String start_time1 = jsonObject.getString("start_time");
                String end_time1 = jsonObject.getString("end_time");
                long startTime = Long.parseLong(start_time1);
                long endTime = Long.parseLong(end_time1);
                Long start = Long.parseLong(Utils.transformToYYMMddHHmmss(start_time));
                Long end = Long.parseLong(Utils.transformToYYMMddHHmmss(end_time));
                if((startTime <= start && endTime >= start) || (startTime <= end && endTime >= end)){
                    jsonObject = new JSONObject();
                    jsonObject.put("success", 2);
                    return jsonObject.toJSONString();
                }
            }
        }

        HttpSession session=request.getSession();
        int userId =Integer.valueOf(session.getAttribute("userId").toString());
        String addadvert = AdvertisingService.addAdvert(advert_num,position_id,advert_url_id,imgId,advert_name,start_time,end_time,userId);
        return addadvert;
    }
    //删除广告信息
    public String delAdvert(String id){
        String addadvert = AdvertisingService.delAdvert(id);
        return addadvert;
    }

    //修改广告链接状态
    public String updateAdvertUrlStatus(String status,String ids){
        String res = AdvertisingService.updateAdvertUrlStatus(status,ids);
        return res;
    }

    //删除广告链接信息
    public String delAdvertUrl(String id){
        String addadvert = AdvertisingService.delAdvertUrl(id);
        return addadvert;
    }

    //更新广告链接
    public String updateAdvertUrl(String advertlink_name,String url_link,String remarks,String category,String id,HttpServletRequest request){
        HttpSession session = request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String str = AdvertisingService.updateAdvertUrl(advertlink_name, url_link, remarks,category,id,userId);
        return str;
    }
    //获取广告信息
    public String getAdvertInfo(String id){
        String advertInfo = AdvertisingService.getAdvertInfo(id);
        return advertInfo;
    }
    //修改广告信息
    public String updateAdvert(String id,String advert_num,String advert_url_id,String imgId,String advert_name,String start_time,String end_time,String position_id,HttpServletRequest request){

        String advertList = AdvertisingService.findAdvertList(position_id);
        JSONObject getAdvertList = JSONObject.parseObject(advertList);
        int size = getAdvertList.getJSONArray("rs").size();
        if(size != 0){

            for (int i=0;i<size;i++){
                JSONObject jsonObject = getAdvertList.getJSONArray("rs").getJSONObject(i);
                String id1 = jsonObject.getString("id");
                if(!id1.equals(id)){
                    String start_time1 = jsonObject.getString("start_time");
                    String end_time1 = jsonObject.getString("end_time");
                    long startTime = Long.parseLong(start_time1);
                    long endTime = Long.parseLong(end_time1);
                    Long start = Long.parseLong(Utils.transformToYYMMddHHmmss(start_time));
                    Long end = Long.parseLong(Utils.transformToYYMMddHHmmss(end_time));
                    if((startTime <= start && endTime >= start) || (startTime <= end && endTime >= end)){
                        jsonObject = new JSONObject();
                        jsonObject.put("success", 2);
                        return jsonObject.toJSONString();
                    }
                }

            }
        }

        HttpSession session = request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());
        String str = AdvertisingService.updateAdvert(id,advert_num,advert_url_id,imgId,advert_name,start_time,end_time,userId);
        return str;
    }

}
