package action;

import action.service.PurchaseOrderImportService;
import action.service.ZdzOrderImportService;
import common.ImportExcelUtils;
import common.StringHandler;
import model.ZdzOrderImport;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.Map;

@WebServlet(name = "zdzOrderImport", urlPatterns = "/zdzOrderImport")
public class ZdzOrderImportAction extends BaseServlet {
    
    public static String zdzExcrlImport(HttpServletRequest request, HttpServletResponse response){
        Map<String, Object> fileMap = ImportExcelUtils.uploadExcel(request);
        ArrayList<ZdzOrderImport> plist = null;
        File storeFile = (File) fileMap.get("file");
        try{
             plist = ZdzOrderImportService.readExcelContent(storeFile, request, fileMap.get("fileName").toString(), 0);
            // 上传文件成功 获取文件路径 读取制定excel文件的sheet 返回集合
            int userId = StringHandler.getUserId(request);
            int pSize = plist.size();
            if (plist.size() == 0) {
                return "{\"msg\":\"3\",\"msg\":\"excel 内容读取失败-1 请重新上传或联系管理员\"}";
            } else if (0 == plist.get(pSize - 1).getId()
                    || null == plist.get(pSize - 1).getOrderNo()
                    || null == plist.get(pSize - 1).getStatus()
                    || null == plist.get(pSize - 1).getPhone()
                    || null == plist.get(pSize - 1).getGoodsName()
                    || null == plist.get(pSize - 1).getCreateDate()
                    || null == plist.get(pSize - 1).getOrderTime()
                    ) {
                storeFile.delete();
                // excel 读取过多空格行 提示错误行数
                return "{\"msg\":" + "\"" + plist.get(pSize - 1).getMsg() + "\"" + "}";
            }
            else if (plist.get(plist.size() - 1).getMsg() != null) {
                storeFile.delete();
                return "{\"msg\":" + "\"" + plist.get(plist.size() - 1).getMsg() + "\"" + "}";
            }
            else if (plist.size() > 0) {
                // 准备进行数据库持久化操作
                plist.forEach(p -> {
                    System.out.println("  p is : " + p);
                        ZdzOrderImportService.updateZdzOrder(userId, p);
                });
                // 删除上传的文件
                storeFile.delete();
                plist.get(0).setMsg(" 掌小龙回填单导入成功! ");
                return "{\"msg\":" + "\"" + plist.get(0).getMsg() + "\"" + "}";
            } else {
                return "{\"msg\":\"3\",\"msg\":\"excel 内容读取失败 请重新上传或联系管理员\"}";
            }
        } catch (NullPointerException e) {
            storeFile.delete();
            e.printStackTrace();
            return "{\"msg\":" + "\"" + " 请使用系统导出代购订单Excel模板进行填写!! " + "\"" + "}";
        } catch (NumberFormatException e) {
            storeFile.delete();
            e.printStackTrace();
            return "{\"msg\":" + "\"" + " 数据输入存在非法格式 请仔细检查! " + "\"" + "}";
        }
    }
    
}
