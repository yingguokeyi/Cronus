package action.service;

import cache.ResultPoor;
import com.alibaba.fastjson.JSONObject;
import common.StringHandler;
import common.Utils;
import model.PurchaseOrderImport;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.OfficeXmlFileException;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.FileStore;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class PurchaseOrderImportService extends BaseService {

    static private Workbook wb;
    static private Sheet sheet;
    static private Row row;

    /**
     * 新增代购订单
     *
     * @param p
     * @return
     * @author cuiw
     * @Date 2018/6/19
     */
    public static String insertPurchaseOrder(int userId, PurchaseOrderImport p) {

        long date = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = sdf.format(date);
        String create_time = Utils.transformToYYMMddHHmmss(str);
        String edit_time = Utils.transformToYYMMddHHmmss(str);

        String purchas_order_status = "1";
        if (p.getWaybilNoo() != null && p.getExpressCompany() != null) {
            // 运单号 物流公司 已经填写
            purchas_order_status = "3";
            // 完成代购 (已提交运单号)
        } else {
            purchas_order_status = "2";
            // 已购买 (未提交运单号)
        }
        int insertId = sendObjectCreate(237,
                p.getId(), p.getCreateUserId(), p.getOrderNo(), p.getPurchasPlatform(),
                0, p.getPay(), p.getPurchasOrderNo(), p.getWaybilNoo(), p.getExpressCompany(),
                p.getPurchasingTerraceNo(), p.getSubstituter(), purchas_order_status, userId,
                create_time, userId, edit_time, 0, "");
        String res = ResultPoor.getResult(insertId);
        TaskManageService.upOrderState(p.getId()+"",userId,Integer.parseInt(purchas_order_status),"",p.getMemo());
        // 此方法中已经返回res 此处无须再返回 执行成功即可
        return res;
    }

    /**
     * @param userId
     * @param p
     * @return
     * @author cuiw
     * @Date 2018/6/19
     */
    public static String updatePurchaseOrder(int userId, PurchaseOrderImport p) {

        long date = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = sdf.format(date);
        String edit_time = Utils.transformToYYMMddHHmmss(str);
        String purchas_order_status = "1";
        try {
            if (p.getWaybilNoo().equals("") && p.getExpressCompany().equals("")) {
                purchas_order_status = "2";
                // 已购买 (未提交运单号)
            } else if (!p.getWaybilNoo().equals("") && !p.getExpressCompany().equals("")) {
                purchas_order_status = "3";
                // 完成代购 (已提交运单号)
            } else {
                purchas_order_status = "2";
                // 已购买 (未提交运单号)
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            return "{\"msg\":" + "\"" + p.getMsg() + "\"" + "}";
        }
        int updateId = sendObjectCreate(238, p.getPurchasPlatform(), 0, p.getPay(), p.getPurchasOrderNo()
                , p.getWaybilNoo(), p.getExpressCompany(), p.getPurchasingTerraceNo()
                , p.getSubstituter(), purchas_order_status, userId, edit_time, 0, "", p.getPid());
        String res = ResultPoor.getResult(updateId);
        TaskManageService.upOrderState(p.getId()+"",userId,Integer.parseInt(purchas_order_status),"","");
        // 此方法中已经返回res 此处无须再返回 执行成功即可
        return res;
    }

    /**
     * @param storeFile 上传服务器路径 发生异常时候 删除此文件
     * @param fileName  上传到服务器得绝对路径文件名字
     * @param sheetNums 读取excel 的 第几个sheet
     * @return list excel信息集合
     * @Date 2018/6/19
     * @author cuiw
     */
    public static ArrayList<PurchaseOrderImport> readExcelContent(File storeFile, HttpServletRequest req, String fileName, Integer sheetNums) {// 第几个sheet读取
        ArrayList<PurchaseOrderImport> plist = null;// 代购订单导入属性VO
        try {
            InputStream is;
            System.out.println(" fileName  is   " + fileName);
            is = new FileInputStream(fileName);
            String postfix = fileName.substring(fileName.lastIndexOf("."), fileName.length());
            if (postfix.equals(".xls")) {
                // 针对 2003 Excel 文件
                wb = new HSSFWorkbook(new POIFSFileSystem(is));
                sheet = wb.getSheetAt(sheetNums);
            } else if (postfix.equals(".xlsx")) {
                // 针对2007 Excel 文件
                wb = new XSSFWorkbook(is);
                sheet = wb.getSheetAt(sheetNums);
            } else {
                storeFile.delete();
//                PurchaseOrderImport p = new PurchaseOrderImport();
//                p.setMsg("不是.xls .xlsx 的文件 请不要上传！！！ ")
//                plist.add(p);
//                JSONObject.parseObject(plist.toString());
                return null;
            }
            sheet = wb.getSheetAt(sheetNums);
            int rowNum = sheet.getLastRowNum();// 得到总行数
            System.out.println("   rowNum is  " + rowNum);
            //row = sheet.getRow(0);// 获取第一行（约定第一行是标题行）
            //int colNum = row.getPhysicalNumberOfCells();// 获取行的列数
            // 正文内容应该从第二行开始,第一行为表头的标题
            if (sheetNums == 0) {
                plist = selectOneSheet(req, plist, rowNum);
            } else {
                // 读取不是第一个sheet  返回提示错误
                return null;
            }

        } catch (OfficeXmlFileException e) {
            storeFile.delete();
            plist.get(0).setMsg("  必须是从系统中导出的excel模板！！！ ");
            e.printStackTrace();
        } catch (IOException e) {
            storeFile.delete();
            plist.get(0).setMsg("  IOException 异常 请立刻联系管理员 ！！！ ");
            e.printStackTrace();
        }
        return plist;
    }

    /**
     * @param plist  存放读取excel vo 集合
     * @param rowNum excel内容行数
     * @return list集合
     * @Date 2018/6/19
     * @author cuiw
     */
    public static ArrayList<PurchaseOrderImport> selectOneSheet(HttpServletRequest req, ArrayList<PurchaseOrderImport> plist, int rowNum) {
        ArrayList<PurchaseOrderImport> list = new ArrayList<>();
        PurchaseOrderImport p = null;
        try {
            for (int i = 1; i <= rowNum; i++) {
                row = sheet.getRow(i);
                p = new PurchaseOrderImport();
                //p.setMsg(" excel读取行数为:" + rowNum + ".  存在多余空格行 请删除");
                // 提示excel 空格行
                // 代购订单导入信息VO
                String orderId = getCellFormatValue(row.getCell(12)).trim();
                if (orderId.equals("") || orderId == null) { // 不能为空
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 13 + "列 订单ID不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setId(Integer.valueOf(orderId));
                }
                // 订单ID处理
                String orderNo = getCellFormatValue(row.getCell(13)).trim();
                if (orderNo.equals("") || orderNo == null) {
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 14 + "列 订单号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setOrderNo(orderNo);
                }
                // 订单号处理
                String purID = getCellFormatValue(row.getCell(17)).trim();
                if (purID.equals("") || purID == null) {
                    // 当前信息无代购人ID 则默认当前导入excel者
                    int userId = StringHandler.getUserId(req);
                    p.setCreateUserId(userId);
                } else {
                    p.setCreateUserId(Integer.valueOf(purID));
                }
                // 代购人ID
                String memo = getCellFormatValue(row.getCell(18)).trim();
                p.setMemo(memo);
                // 用户备注
                String purchasPlatform = getCellFormatValue(row.getCell(19)).trim();
                if (purchasPlatform == null || purchasPlatform.equals("")) {
                    p.setMsg("excel读取总行数为:" + rowNum + ". 第" + (i + 1) + "行" + 20 + "列 代购平台不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setPurchasPlatform(purchasPlatform);
                }
                // 代购平台 必填
                String pay = getCellFormatValue(row.getCell(20)).trim();
                if (pay.equals("0.00") || pay == null) {
                    // 必填
                    p.setMsg("excel读取总行数为:" + rowNum + ". 第" + (i + 1) + "行" + 21 + "列 实际支付金额不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    float pay_temp = Float.parseFloat(pay) * 100;
                    float pay_float = (float) (Math.round(pay_temp * 100)) / 100;
                    int pay_Int = ((Number) pay_float).intValue();
                    p.setPay(Integer.valueOf(pay_Int));
                }
                // 实际支付金额 必填
                String purchasOrderNo = getCellFormatValue(row.getCell(21)).trim();
                if (purchasOrderNo == null || purchasOrderNo.equals("0")) {
                    // 必填
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 22 + "列 代购订单号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setPurchasOrderNo(purchasOrderNo);
                }
                // 代购订单号 必填
                String purchasingTerraceNo = getCellFormatValue(row.getCell(22)).trim();
                if (purchasingTerraceNo == null || purchasingTerraceNo.equals("")) {
                    // 必填
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 23 + "列 下单账号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setPurchasingTerraceNo(purchasingTerraceNo);
                    // 下单账号 必填
                }
                String substituter = getCellFormatValue(row.getCell(23)).trim();
                if (substituter == null || substituter.equals("")) {
                    // 必填
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 24 + "列 代付人不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setSubstituter(substituter);
                    // 代付人 必填
                }
                String expressCompany = getCellFormatValue(row.getCell(24)).trim();
                String waybilNoo = getCellFormatValue(row.getCell(25)).trim();
                if (!expressCompany.equals("") && !waybilNoo.equals("")) {
                    // 两者都填写 可以继续
                    p.setWaybilNoo(waybilNoo);
                    // 运单号 选填
                    p.setExpressCompany(expressCompany);
                    // 运单公司 选填
                    p.setOrderStatus(105);
                    // 此时注意更新订单状态
                    /**
                     * 运单号和物流公司都填写的 订单状态改为待签收 105
                     * 运单号和物流公司未填写的 订单状态改为待发货 104
                     */
                } else if (expressCompany.equals("") && waybilNoo.equals("")) {
                    p.setWaybilNoo(waybilNoo);
                    p.setExpressCompany(expressCompany);
                    p.setOrderStatus(104);
                } else {
                    p.setMsg("excel读取总行数为: " + rowNum + ". 第 " + (i + 1) + " 行 " + 24 + " 和 " + 25 + " 列运单号 和 物流公司 需要填写完整 ");
                    list.add(p);
                    return list;
                }
                String logisticsCompanies = getCellFormatValue(row.getCell(26)).trim();
                p.setLogisticsCompanies(logisticsCompanies);
                // 代购订单备注 选填
                String purchaseId = getCellFormatValue(row.getCell(27)).trim();
                if (purchaseId.equals("") || purchaseId == null) {
                    purchaseId = "0";
                }
                p.setPid(Integer.valueOf(purchaseId));
                // 代购订单ID
                // 校验当前记录行是否在数据库已经重复 主要是 七个字段
                int num = PurchaseOrderImportService.checkImportPurOrder(p);
                if (num != 0) {
                    if (p.getPid() != 0) {
                        //具有代购订单ID 无  说明此条信息是修改覆盖
                        p.setMsg(" 当前第" + (i + 1) + "行数据无任何修改与系统原有数据一致！请误重复导入 ");
                        list.add(p);
                        return list;
                    }
                    // 说明重复
                    p.setMsg(" 当前第" + (i + 1) + "行数据导入重复！请检查必填字段信息是否已经导入过. ");
                    list.add(p);
                    return list;
                }
                list.add(p);
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            // 必填
            p.setMsg("  excel 显示读取行数为 " + rowNum + ". 数据存在非法格式 不符合输入要求  请仔细检查！ ");
            list.add(p);
            return list;
        } catch (IndexOutOfBoundsException e) {
            e.printStackTrace();
            // 必填
            p.setMsg("  excel 显示读取行数为 " + rowNum + ". 存在多余空格行数 请删除！");
            list.add(p);
            return list;
        }
        return list;
    }

    /**
     * 根据Cell类型设置数据
     *
     * @param cell
     * @return
     */
    private static String getCellFormatValue(Cell cell) {
        try {
            String cellvalue = "";
            DecimalFormat df = new DecimalFormat("##.##");
            if (cell != null) {
                // 判断当前Cell的Type
                switch (cell.getCellType()) {
                    // 如果当前Cell的Type为NUMERIC
                    case Cell.CELL_TYPE_NUMERIC:
                        cellvalue = df.format(cell.getNumericCellValue()).toString();
                        break;
//				System.out.println("cellvalue : "+cellvalue);
                    case Cell.CELL_TYPE_FORMULA: {
                        // 判断当前的cell是否为Date
                        if (HSSFDateUtil.isCellDateFormatted(cell)) {
                            // 方法2：这样子的data格式是不带带时分秒的：2011-10-12
                            Date date = cell.getDateCellValue();
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            cellvalue = sdf.format(date);
                        } else {
                            // 如果是纯数字取得当前Cell的数值
                            cellvalue = String.valueOf(cell.getNumericCellValue());
                        }
                        break;
                    }
                    // 如果当前Cell的Type为STRIN
                    case Cell.CELL_TYPE_STRING:
                        // 取得当前的Cell字符串
                        cellvalue = cell.getRichStringCellValue().getString();
                        break;
                    default:
                        // 默认的Cell值
                        cellvalue = " ";
                }
            } else {
                cellvalue = "";
            }

            return cellvalue;
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
            return " ERROR ";
        }

    }


    /**
     * @param p
     * @return
     * @author cuiw
     * @Date2018/6/23
     */
    public static int checkImportPurOrder(PurchaseOrderImport p) {

        int cid = sendObject(419, p.getId(), p.getOrderNo(), p.getCreateUserId()
                , p.getPurchasPlatform(), p.getPay(), p.getPurchasOrderNo()
                , p.getPurchasingTerraceNo(), p.getSubstituter());

        String res = ResultPoor.getResult(cid);
        System.out.println(res);
        int num = (int) getFieldValue(res, "num", Integer.class);
        return num;
    }

}
