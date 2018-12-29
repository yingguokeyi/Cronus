package action.service;

import cache.ResultPoor;
import common.StringHandler;
import common.Utils;
import model.PurchaseOrderImport;
import model.ZdzOrderImport;
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
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class ZdzOrderImportService  extends BaseService{
    static private Workbook wb;
    static private Sheet sheet;
    static private Row row;

    /**
     * @param storeFile 上传服务器路径 发生异常时候 删除此文件
     * @param fileName  上传到服务器得绝对路径文件名字
     * @param sheetNums 读取excel 的 第几个sheet
     * @return list excel信息集合
     * @Date 2018/6/19
     * @author cuiw
     */
    public static ArrayList<ZdzOrderImport> readExcelContent(File storeFile, HttpServletRequest req, String fileName, Integer sheetNums) {// 第几个sheet读取
        ArrayList<ZdzOrderImport> plist = null;// 代购订单导入属性VO
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
    public static ArrayList<ZdzOrderImport> selectOneSheet(HttpServletRequest req, ArrayList<ZdzOrderImport> plist, int rowNum) {
        ArrayList<ZdzOrderImport> list = new ArrayList<>();
        ZdzOrderImport p = null;
        try {
            for (int i = 1; i <= rowNum; i++) {
                row = sheet.getRow(i);
                p = new ZdzOrderImport();
                //p.setMsg(" excel读取行数为:" + rowNum + ".  存在多余空格行 请删除");
                // 提示excel 空格行
                // 代购订单导入信息VO
                String id = getCellFormatValue(row.getCell(0)).trim();
                if (id.equals("") || id == null) { // 不能为空
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 1 + "列 序号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setId(Integer.valueOf(id));
                }
                // 订单ID处理
                String orderNo = getCellFormatValue(row.getCell(1)).trim();
                if (orderNo.equals("") || orderNo == null) {
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 2 + "列 订单号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setOrderNo(orderNo);
                }
                // 订单状态处理
                String status = getCellFormatValue(row.getCell(2)).trim();
                if (status.equals("") || status == null) {
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 3 + "列 订单状态不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setStatus(status);
                }
                // 录入时间
                String createDate = getCellFormatValue(row.getCell(3)).trim();
                p.setCreateDate(createDate);
                // 注册人手机号
                String phone = getCellFormatValue(row.getCell(4)).trim();
                if (phone.equals("") || phone == null) {
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 5 + "列 注册人手机号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setPhone(phone);
                }
                // 商品名称
                String goodsName = getCellFormatValue(row.getCell(5)).trim();
                if (goodsName.equals("") || goodsName == null) {
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 6 + "列 商品名称号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setGoodsName(goodsName);
                }

                // 用户下单时间
                String editTime = getCellFormatValue(row.getCell(6)).trim();
                if (editTime.equals("") || editTime == null) {
                    p.setMsg("excel读取总行数为:" + rowNum + ".  第" + (i + 1) + "行" + 7 + "列 商品名称号不能为空 ");
                    list.add(p);
                    return list;
                } else {
                    p.setOrderTime(editTime);
                }
                // 用户备注
                String remark = getCellFormatValue(row.getCell(7)).trim();
                    p.setRemark(remark);
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


    public static String updateZdzOrder(int userId, ZdzOrderImport p) {

        long date = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = sdf.format(date);
        String edit_time = Utils.transformToYYMMddHHmmss(str);
        String status = "0";
        try {
            if (p.getStatus().equals("已完成")) {
               status = "1";
            } else if (p.getStatus().equals("已失效")) {
                status = "2";
            } else if(p.getStatus().equals("用户退款")){
                status = "3";
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            return "{\"msg\":" + "\"" + p.getMsg() + "\"" + "}";
        }
        int updateId = sendObjectCreate(624, status, edit_time,p.getOrderNo());
        String res = ResultPoor.getResult(updateId);
        // 此方法中已经返回res 此处无须再返回 执行成功即可
        return res;
    }
}
