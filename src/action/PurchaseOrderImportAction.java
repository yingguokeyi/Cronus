package action;

import action.service.OrderService;
import action.service.PurchaseOrderImportService;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.StringHandler;
import model.PurchaseOrderImport;
import model.ZdzOrderImport;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "purchaseOrderImport", urlPatterns = "/purchaseOrderImport")
public class PurchaseOrderImportAction extends BaseServlet {

    // 上传文件存储目录
    private static final String UPLOAD_DIRECTORY = "upload";

    // 上传配置
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    /**
     * 上传代购订单导入excel文件 支持xls xlsx
     * @author cuiw
     * @param request
     * @param response
     * @return
     */
    public static String uploadExcel(HttpServletRequest request, HttpServletResponse response) {

        // 配置上传参数
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 设置内存临界值 - 超过后将产生临时文件并存储于临时目录中
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        // 设置临时存储目录
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        ServletFileUpload upload = new ServletFileUpload(factory);
        // 设置最大文件上传值
        upload.setFileSizeMax(MAX_FILE_SIZE);
        // 设置最大请求值 (包含文件和表单数据)
        upload.setSizeMax(MAX_REQUEST_SIZE);
        // 中文处理
        upload.setHeaderEncoding("UTF-8");
        // 构造临时路径来存储上传的文件
        // 这个路径相对当前应用的目录
        String uploadPath = request.getServletContext().getRealPath("./") + File.separator + UPLOAD_DIRECTORY;
        System.out.println("     uploadPath   " + uploadPath);
        // 如果目录不存在则创建
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        String filePath = null;
        File storeFile = null;
        try {
            // 解析请求的内容提取文件数据
            List<FileItem> formItems = upload.parseRequest(request);
            if (formItems != null && formItems.size() > 0) {
                // 迭代表单数据
                for (FileItem item : formItems) {
                    // 处理不在表单中的字段
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        // 获得原始文件名字
                        String extName = fileName.substring(fileName.lastIndexOf("."));//.jpg
                        // 获取扩展
                        String uuid = UUID.randomUUID().toString().replaceAll("-", "");
                        // 生成uuid 命名新文件名字
                        filePath = uploadPath + File.separator + uuid + extName;
                        //filePath = uploadPath + File.separator + fileName;
                        storeFile = new File(filePath);
                        // 在控制台输出文件的上传路径
                        System.out.println(filePath);
                        // 保存文件到硬盘
                        item.write(storeFile);
                        request.setAttribute("message",
                                "文件上传成功!");
                    }
                }
            }
        } catch (Exception ex) {
            request.setAttribute("message",
                    "错误信息: " + ex.getMessage());
            return "{\"msg\":\"2\",\"msg\":\"上传文件失败!请重新尝试或联系开发人员\"}";
        }
        ArrayList<PurchaseOrderImport> plist = null;
        try {
            plist = PurchaseOrderImportService.readExcelContent(storeFile, request, filePath, 0);
            // 上传文件成功 获取文件路径 读取制定excel文件的sheet 返回集合
            int userId = StringHandler.getUserId(request);
            int pSize = plist.size();
            if (plist.size() == 0) {
                return "{\"msg\":\"3\",\"msg\":\"excel 内容读取失败 请重新上传或联系管理员\"}";
            } else if (0 == plist.get(pSize - 1).getId()
                    || null == plist.get(pSize - 1).getOrderNo()
                    || null == plist.get(pSize - 1).getPurchasPlatform()
                    || 0 == plist.get(pSize - 1).getPay()
                    || null == plist.get(pSize - 1).getPurchasOrderNo()
                    || null == plist.get(pSize - 1).getPurchasingTerraceNo()
                    || null == plist.get(pSize - 1).getSubstituter()
                    || null == plist.get(pSize - 1).getExpressCompany()
                    && null == plist.get(pSize - 1).getWaybilNoo()
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
                    if (p.getPid() == 0) {
                        PurchaseOrderImportService.insertPurchaseOrder(userId, p);
                    } else if (p.getCreateUserId() != 0) {
                        //  代购订单ID不为空
                        PurchaseOrderImportService.updatePurchaseOrder(userId, p);
                    } else {
                        System.out.println("  导入失败 ");
                    }
                });
                // 删除上传的文件
                storeFile.delete();
                plist.get(0).setMsg(" 代购订单导入成功! ");
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
