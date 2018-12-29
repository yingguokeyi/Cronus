package action;


import action.service.CreateSimpleExcelService;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.BaseCache;

import common.Utils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import servlet.BaseServlet;

import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "createSimpleExcelToDisk", urlPatterns = "/createSimpleExcelToDisk")
public class CreateSimpleExcelToDisk extends BaseServlet {
    /**
     * 订单导出excel
     * 下单起始截止时间: startTime,endTime
     *
     * @throws Exception
     */
    public void exportOrderExcel(String order_no, String transaction_no, String nick_name, String phone, String consignee, String submission_time, String logistics_numbers, String price_min, String price_max, HttpServletRequest request, HttpServletResponse resp) throws Exception {
        HttpSession session = request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());

        // 第一步，创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("掌大运营系统订单导出表");
        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);
        // 第四步，创建单元格，并设置值表头 设置表头居中
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
        style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        HSSFCell cell = row.createCell((short) 0);
        cell = row.createCell((short) 0);
        cell.setCellValue("序号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 1);
        cell.setCellValue("订单编号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 2);
        cell.setCellValue("商户订单号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 3);
        cell.setCellValue("订单状态");
        cell.setCellStyle(style);
        cell = row.createCell((short) 4);
        cell.setCellValue("订单来源");
        cell.setCellStyle(style);
        cell = row.createCell((short) 5);
        cell.setCellValue("下单时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 6);
        cell.setCellValue("用户备注");
        cell.setCellStyle(style);
        cell = row.createCell((short) 7);
        cell.setCellValue("商品名称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 8);
        cell.setCellValue("商品规格型号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 9);
        cell.setCellValue("下单数量");
        cell.setCellStyle(style);
        cell = row.createCell((short) 10);
        cell.setCellValue("商品链接");
        cell.setCellStyle(style);
        cell = row.createCell((short) 11);
        cell.setCellValue("销售价格（元）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 12);
        cell.setCellValue("原价/成本价（元）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 13);
        cell.setCellValue("商品来源）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 14);
        cell.setCellValue("运单公司");
        cell.setCellStyle(style);
        cell = row.createCell((short) 15);
        cell.setCellValue("运单号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 16);
        cell.setCellValue("用户登录账号/昵称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 17);
        cell.setCellValue("注册手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 18);
        cell.setCellValue("收货人");
        cell.setCellStyle(style);
        cell = row.createCell((short) 19);
        cell.setCellValue("收货人手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 20);
        cell.setCellValue("收货地址");
        cell.setCellStyle(style);
        cell = row.createCell((short) 21);
        cell.setCellValue("支付方式");
        cell.setCellStyle(style);
        cell = row.createCell((short) 22);
        cell.setCellValue("支付总金额（元）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 23);
        cell.setCellValue("返现总金额（元）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 24);
        cell.setCellValue("员工账号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 25);
        cell.setCellValue("最后操作时间");
        cell.setCellStyle(style);


        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，
        String orderListStr = CreateSimpleExcelService.getOrderListExcel(order_no, nick_name, transaction_no, phone, consignee, submission_time, logistics_numbers, price_min, price_max);
        JSONObject result_json = JSONObject.parseObject(orderListStr);
        JSONArray jsonArray = result_json.getJSONObject("result").getJSONArray("rs");

        for (int i = 0; i < jsonArray.size(); i++) {
            row = sheet.createRow((int) i + 1);
            JSONObject obj = jsonArray.getJSONObject(i);
            // 第四步，创建单元格，并设置值
            row.createCell((short) 0).setCellValue(String.valueOf(i + 1));
            row.createCell((short) 1).setCellValue(obj.getString("order_no"));
            row.createCell((short) 2).setCellValue(obj.getString("transaction_no"));
            row.createCell((short) 3).setCellValue(Utils.orderStaueFormat(obj.getString("status")));
            row.createCell((short) 4).setCellValue(Utils.dataSourceToString(obj.getString("data_source")));
            row.createCell((short) 5).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("created_date")));
            row.createCell((short) 6).setCellValue(obj.getString("memo"));
            row.createCell((short) 7).setCellValue(obj.getString("sku_name"));
            row.createCell((short) 8).setCellValue(obj.getString("first_attribute_value") + " " + obj.getString("second_attribute_value"));
            row.createCell((short) 9).setCellValue(obj.getString("sku_num"));
            row.createCell((short) 10).setCellValue(obj.getString("goods_url"));
            row.createCell((short) 11).setCellValue(Utils.fenToYuan(obj.getString("market_price")));
            row.createCell((short) 12).setCellValue(Utils.fenToYuan(obj.getString("original_price")));
            row.createCell((short) 13).setCellValue(obj.getString("source_code"));
            row.createCell((short) 14).setCellValue(obj.getString("logistics_companies"));
            row.createCell((short) 15).setCellValue(obj.getString("logistics_numbers"));
            row.createCell((short) 16).setCellValue(obj.getString("nick_name"));
            row.createCell((short) 17).setCellValue(obj.getString("phone"));
            row.createCell((short) 18).setCellValue(obj.getString("consignee"));
            row.createCell((short) 19).setCellValue(obj.getString("consignee_tel"));
            row.createCell((short) 20).setCellValue(obj.getString("delivery_address"));
            row.createCell((short) 21).setCellValue(Utils.paymentWayKeyToString(obj.getString("payment_way_key")));
            row.createCell((short) 22).setCellValue(Utils.fenToYuan(obj.getString("total_price")));
            //row.createCell((short) 23).setCellValue(Utils.caseReturn(obj.getString("my_is_member"),obj.getString("cashback"),obj.getString("member_self"),obj.getString("outsider_self")));
            row.createCell((short) 23).setCellValue(Utils.fenToYuan(obj.getString("money")));
            row.createCell((short) 24).setCellValue(obj.getString("edit_user"));
            row.createCell((short) 25).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("edit_time")));

        }

        String excelName = "账单信息";
        resp.addHeader("Content-Disposition", "attachment;filename=" + new String(excelName.getBytes("gb2312"), "ISO8859-1") + ".xls");
        ServletOutputStream out = resp.getOutputStream();

        wb.write(out);
        out.close();
    }

    /**
     * 代购订单导出excel
     * 下单起始截止时间: startTime,endTime
     *
     * @throws Exception
     */
    public void exportPurOrderExcel(String orderNum, String transaction_no,String spuCode, String nick_name, String phoneNum, String sku_name, String purchasingOrder_source, String price_min, String price_max, String order_source, String order_Type, String status, HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());

        // 第一步，创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("掌大运营系统代购订单导出表");
        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);
        // 第四步，创建单元格，并设置值表头 设置表头居中
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
        style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        // 代购订单导入字段 标注
        HSSFCellStyle styleImport = wb.createCellStyle();
        styleImport.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
        styleImport.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
        styleImport.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        styleImport.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        styleImport.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        styleImport.setBorderRight(HSSFCellStyle.BORDER_THIN);
        styleImport.setBorderTop(HSSFCellStyle.BORDER_THIN);
        styleImport.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        styleImport.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        HSSFCell cell = row.createCell((short) 0);
        cell = row.createCell((short) 0);
        cell.setCellValue("序号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 1);
        cell.setCellValue("商品名称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 2);
        cell.setCellValue("商品编码");
        cell.setCellStyle(style);
        cell = row.createCell((short) 3);
        cell.setCellValue("商品规格型号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 4);
        cell.setCellValue("商品来源");
        cell.setCellStyle(style);

        cell = row.createCell((short) 5);
        cell.setCellValue("商品备注");
        cell.setCellStyle(style);

        cell = row.createCell((short) 6);
        cell.setCellValue("sku编码");
        cell.setCellStyle(style);
        cell = row.createCell((short) 7);
        cell.setCellValue("商品URL");
        cell.setCellStyle(style);
        cell = row.createCell((short) 8);
        cell.setCellValue("原价");
        cell.setCellStyle(style);
        cell = row.createCell((short) 9);
        cell.setCellValue("销售价");
        cell.setCellStyle(style);
        cell = row.createCell((short) 10);
        cell.setCellValue("下单数量");
        cell.setCellStyle(style);
        cell = row.createCell((short) 11);
        cell.setCellValue("下单时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 12);
        cell.setCellValue("订单ID");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 13);
        cell.setCellValue("订单编号");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 14);
        cell.setCellValue("商户订单号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 15);
        cell.setCellValue("订单状态");
        cell.setCellStyle(style);
        cell = row.createCell((short) 16);
        cell.setCellValue("订单来源");
        cell.setCellStyle(style);
        cell = row.createCell((short) 17);
        cell.setCellValue("代购人ID");
        cell.setCellStyle(styleImport);
        //代购订单导入 新增还是修改信息 判断依据
        cell = row.createCell((short) 18);
        cell.setCellValue("用户备注");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 19);
        cell.setCellValue("代购平台");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 20);
        cell.setCellValue("实际支付金额）");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 21);
        cell.setCellValue("代购订单号");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 22);
        cell.setCellValue("下单账号");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 23);
        cell.setCellValue("代付人");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 24);
        cell.setCellValue("运单公司");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 25);
        cell.setCellValue("运单号");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 26);
        cell.setCellValue("代购订单备注");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 27);
        cell.setCellValue("代购订单id");
        cell.setCellStyle(styleImport);
        cell = row.createCell((short) 28);
        cell.setCellValue("是否为异常订单");
        cell.setCellStyle(style);
        cell = row.createCell((short) 29);
        cell.setCellValue("用户登录账号/昵称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 30);
        cell.setCellValue("注册手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 31);
        cell.setCellValue("收货人");
        cell.setCellStyle(style);
        cell = row.createCell((short) 32);
        cell.setCellValue("收货人手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 33);
        cell.setCellValue("收货地址");
        cell.setCellStyle(style);
        cell = row.createCell((short) 34);
        cell.setCellValue("支付方式");
        cell.setCellStyle(style);
        cell = row.createCell((short) 35);
        cell.setCellValue("支付总金额（元）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 36);
        cell.setCellValue("返现总金额（元）");
        cell.setCellStyle(style);
        cell = row.createCell((short) 37);
        cell.setCellValue("员工账号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 38);
        cell.setCellValue("员工手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 39);
        cell.setCellValue("最后操作时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 40);
        cell.setCellValue("一级类目");
        cell.setCellStyle(style);
        cell = row.createCell((short) 41);
        cell.setCellValue("二级类目");
        cell.setCellStyle(style);
        cell = row.createCell((short) 42);
        cell.setCellValue("三级类目");
        cell.setCellStyle(style);
        cell = row.createCell((short) 43);
        cell.setCellValue("任务指派人");
        cell.setCellStyle(style);
        cell = row.createCell((short) 44);
        cell.setCellValue("任务指派时间");
        cell.setCellStyle(style);

        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，
        String purOrderListStr = CreateSimpleExcelService.getPurOrderListExcel(userId, orderNum, transaction_no,spuCode, nick_name, phoneNum, sku_name, purchasingOrder_source, price_min, price_max, order_source, order_Type, status);
        JSONObject result_json = JSONObject.parseObject(purOrderListStr);
        JSONArray jsonArray = result_json.getJSONObject("result").getJSONArray("rs");

        for (int i = 0; i < jsonArray.size(); i++) {
            row = sheet.createRow((int) i + 1);
            JSONObject obj = jsonArray.getJSONObject(i);
            // 第四步，创建单元格，并设置值
            row.createCell((short) 0).setCellValue(String.valueOf(i + 1));
            row.createCell((short) 1).setCellValue(obj.getString("sku_name"));
            // 新增商品编码
            row.createCell((short) 2).setCellValue(obj.getString("spu_code"));
            row.createCell((short) 3).setCellValue(obj.getString("first_attribute_value") + " " + obj.getString("second_attribute_value"));

            row.createCell((short) 4).setCellValue(obj.getString("source_code"));
            // 新增商品备注
            row.createCell((short) 5).setCellValue(obj.getString("memo"));
            row.createCell((short) 6).setCellValue(obj.getString("sku_code"));
            row.createCell((short) 7).setCellValue(obj.getString("goods_url"));
            row.createCell((short) 8).setCellValue(Utils.fenToYuan(obj.getString("original_price")));
            row.createCell((short) 9).setCellValue(Utils.fenToYuan(obj.getString("market_price")));

            row.createCell((short) 10).setCellValue(obj.getString("sku_num"));
            row.createCell((short) 11).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("created_date")));
            row.createCell((short) 12).setCellValue(obj.getString("id"));
            row.createCell((short) 13).setCellValue(obj.getString("order_no"));
            row.createCell((short) 14).setCellValue(obj.getString("transaction_no"));
            row.createCell((short) 15).setCellValue(Utils.orderStaueFormat(obj.getString("status")));
            row.createCell((short) 16).setCellValue(Utils.dataSourceToString(obj.getString("data_source")));
            row.createCell((short) 17).setCellValue(obj.getString("create_userid"));
            row.createCell((short) 18).setCellValue(obj.getString("remark"));
            row.createCell((short) 19).setCellValue(obj.getString("purchas_platform"));
            row.createCell((short) 20).setCellValue(Utils.fenToYuan(obj.getString("pay")));
            row.createCell((short) 21).setCellValue(obj.getString("purchas_order_no"));
            row.createCell((short) 22).setCellValue(obj.getString("purchasing_terrace_no"));
            row.createCell((short) 23).setCellValue(obj.getString("substituter"));
            row.createCell((short) 24).setCellValue(obj.getString("express_company"));
            row.createCell((short) 25).setCellValue(obj.getString("waybill_no"));
            row.createCell((short) 26).setCellValue(obj.getString("logistics_companies"));
            row.createCell((short) 27).setCellValue(obj.getString("pur_id"));

            row.createCell((short) 28).setCellValue(obj.getString("order_error"));
            row.createCell((short) 29).setCellValue(Utils.fenToYuan(obj.getString("user_nick_name")));
            row.createCell((short) 30).setCellValue(obj.getString("user_phone"));
            row.createCell((short) 31).setCellValue(obj.getString("consignee"));
            row.createCell((short) 32).setCellValue(obj.getString("consignee_tel"));
            row.createCell((short) 33).setCellValue(obj.getString("delivery_address"));
            row.createCell((short) 34).setCellValue(Utils.paymentWayKeyToString(obj.getString("payment_way_key")));
            row.createCell((short) 35).setCellValue(Utils.fenToYuan(obj.getString("total_price")));
            //row.createCell((short)30).setCellValue(Utils.caseReturn(obj.getString("my_is_member"),obj.getString("cashback"),obj.getString("member_self"),obj.getString("outsider_self")));
            row.createCell((short) 36).setCellValue(Utils.fenToYuan(obj.getString("money")));
            row.createCell((short) 37).setCellValue(obj.getString("nick_name"));
            row.createCell((short) 38).setCellValue(obj.getString("phone"));
            row.createCell((short) 39).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("edit_time")));
            row.createCell((short) 40).setCellValue(obj.getString("goodsFirstMenu"));
            row.createCell((short) 41).setCellValue(obj.getString("goodsSecondMenu"));
            row.createCell((short) 42).setCellValue(obj.getString("goodsThirdMenu"));
            row.createCell((short) 43).setCellValue(obj.getString("assign_user"));
            row.createCell((short) 44).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("create_time")));
        }
        // 第六步，将文件存到指定位置     wb
       // String name = BaseCache.getTIME();
        String excelName = "代购订单导出表";
        response.addHeader("Content-Disposition", "attachment;filename=" + new String(excelName.getBytes("gb2312"), "ISO8859-1") + ".xls");
        ServletOutputStream out = response.getOutputStream();
        wb.write(out);
        out.close();
    }

    /**
     * 商品导出
     * @param spuName
     * @param goodsSource
     * @param status
     * @param cateName
     * @param goodsTypeName
     * @param spuCode
     * @param request
     * @param resp
     * @throws Exception
     */
    public void exportGoodsExcel(String spuName, String goodsSource, String status, String cateName, String goodsTypeName, String spuCode, HttpServletRequest request, HttpServletResponse resp) throws Exception {
        HttpSession session = request.getSession();
        int userId = Integer.valueOf(session.getAttribute("userId").toString());

        String goodsListStr = CreateSimpleExcelService.getGoodsListExcel(spuName, goodsSource, status, cateName, goodsTypeName, spuCode);
        // 提前讲数据加载完毕

        // 第一步，创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("掌大运营系统商品导出表");
        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);
        // 第四步，创建单元格，并设置值表头 设置表头居中
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
        style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        HSSFCell cell = row.createCell((short) 0);
        cell = row.createCell((short) 0);
        cell.setCellValue("序号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 1);
        cell.setCellValue("商品名称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 2);
        cell.setCellValue("小程序商品链接");
        cell.setCellStyle(style);
        cell = row.createCell((short) 3);
        cell.setCellValue("一级类目");
        cell.setCellStyle(style);
        cell = row.createCell((short) 4);
        cell.setCellValue("二级类目");
        cell.setCellStyle(style);
        cell = row.createCell((short) 5);
        cell.setCellValue("三级类目");
        cell.setCellStyle(style);
        cell = row.createCell((short) 6);
        cell.setCellValue("商品来源");
        cell.setCellStyle(style);
        cell = row.createCell((short) 7);
        cell.setCellValue("代购商品链接");
        cell.setCellStyle(style);
        cell = row.createCell((short) 8);
        cell.setCellValue("添加时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 9);
        cell.setCellValue("SKU规格名称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 10);
        cell.setCellValue("属性值");
        cell.setCellStyle(style);
        cell = row.createCell((short) 11);
        cell.setCellValue("属性值数量");
        cell.setCellStyle(style);
        cell = row.createCell((short) 12);
        cell.setCellValue("商品金额(元)");
        cell.setCellStyle(style);
        cell = row.createCell((short) 13);
        cell.setCellValue("销售价格(元)");
        cell.setCellStyle(style);
        cell = row.createCell((short) 14);
        cell.setCellValue("原价/成本价(元)");
        cell.setCellStyle(style);
        cell = row.createCell((short) 15);
        cell.setCellValue("库存");
        cell.setCellStyle(style);
        cell = row.createCell((short) 16);
        cell.setCellValue("销售开始时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 17);
        cell.setCellValue("销售结束时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 18);
        cell.setCellValue("限购数量");
        cell.setCellStyle(style);
        cell = row.createCell((short) 19);
        cell.setCellValue("会员-顶级返佣比");
        cell.setCellStyle(style);
        cell = row.createCell((short) 20);
        cell.setCellValue("会员-父级返佣比");
        cell.setCellStyle(style);
        cell = row.createCell((short) 21);
        cell.setCellValue("会员-子级返佣比");
        cell.setCellStyle(style);
        cell = row.createCell((short) 22);
        cell.setCellValue("非会员-顶级返佣比");
        cell.setCellStyle(style);
        cell = row.createCell((short) 23);
        cell.setCellValue("非会员-父级返佣比");
        cell.setCellStyle(style);
        cell = row.createCell((short) 24);
        cell.setCellValue("非会员-子级返佣比");
        cell.setCellStyle(style);
        cell = row.createCell((short) 25);
        cell.setCellValue("员工账号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 26);
        cell.setCellValue("员工手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 27);
        cell.setCellValue("最后操作时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 28);
        cell.setCellValue("备注");
        cell.setCellStyle(style);

        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，
        JSONObject result_json = JSONObject.parseObject(goodsListStr);
        JSONArray jsonArray = result_json.getJSONObject("result").getJSONArray("rs");

        for (int i = 0; i < jsonArray.size(); i++) {
            row = sheet.createRow((int) i + 1);
            JSONObject obj = jsonArray.getJSONObject(i);
            // 第四步，创建单元格，并设置值
            row.createCell((short) 0).setCellValue(String.valueOf(i + 1));
            row.createCell((short) 1).setCellValue(obj.getString("spu_name"));
            //商品名称
            row.createCell((short) 2).setCellValue("");
            // 小程序商品链接
            row.createCell((short) 3).setCellValue(obj.getString("goodsFirstMenu"));
            // 一级类目
            row.createCell((short) 4).setCellValue(obj.getString("goodsSecondMenu"));
            // 二级类目
            row.createCell((short) 5).setCellValue(obj.getString("goodsThirdMenu"));
            // 三级类目
            //row.createCell((short) 6).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("sourceName")+"("+obj.getString("source_code")));
            row.createCell((short) 6).setCellValue(obj.getString("sourceName") + "(" + obj.getString("source_code") + ")");
            // 商品来源
            row.createCell((short) 7).setCellValue(obj.getString("goods_url"));
            // 代购商品链接
            int createTimeSize = obj.getString("create_time").length();
            //System.out.println(" create_time size " + createTimeSize);
            try {
                if (createTimeSize == 10) {
                    // 说明是错误数据 不予录取时间
                    row.createCell((short) 8).setCellValue(" 录入时间格式错误 不予显示 ");
                } else {
                    row.createCell((short) 8).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("create_time")));
                }
            } catch (StringIndexOutOfBoundsException e) {
                System.out.println(" 当前时间格式返回不对 导致格式化失败 ");
            }
            // 添加时间
            row.createCell((short) 9).setCellValue(obj.getString("sku_name"));
            // SKU规格名称
            row.createCell((short) 10).setCellValue(obj.getString("first_attribute") + "/" + obj.getString("second_attribute"));
            // 属性值
            row.createCell((short) 11).setCellValue(obj.getString("skuNum"));
            // 属性值数量
            row.createCell((short) 12).setCellValue("￥"+Utils.fenToYuan(obj.getString("lowestPrice"))+"-"+"￥"+Utils.fenToYuan(obj.getString("highestPrice")));
            // 商品金额(元)
            row.createCell((short) 13).setCellValue(Utils.fenToYuan(obj.getString("market_price")));
            // 销售价格（元）
            row.createCell((short) 14).setCellValue(Utils.fenToYuan(obj.getString("original_price")));
            // 原价/成本价（元）
            row.createCell((short) 15).setCellValue(obj.getString("stock"));
            // 库存
            row.createCell((short) 16).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("presell_begintime")));
            // 销售开始时间
            String presell_endtime = obj.getString("presell_endtime");
            if(presell_endtime.equals("999999999999")){
            // 说明预售结束时间未定
                row.createCell((short) 17).setCellValue("预售截止时间不限");
            }else{
                row.createCell((short) 18).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("presell_endtime")));
            }
            // 销售结束时间
            row.createCell((short) 19).setCellValue(obj.getString("buyconfine"));
            // 限购
            row.createCell((short) 20).setCellValue(obj.getString("member_top") + "%=" + Utils.fenToYuan(obj.getString("member_top_money")) + "元");
            // 会员-顶级返佣比
            row.createCell((short) 21).setCellValue(obj.getString("member_parent") + "%=" + Utils.fenToYuan(obj.getString("member_parent_money")) + "元");
            //会员-父级返佣比
            row.createCell((short) 22).setCellValue(obj.getString("member_self") + "%=" + Utils.fenToYuan(obj.getString("member_self_money")) + "元");
            //会员-子级返佣比
            row.createCell((short) 23).setCellValue(obj.getString("outsider_top") + "%=" + Utils.fenToYuan(obj.getString("outsider_top_money")) + "元");
            //非会员-顶级返佣比
            row.createCell((short) 24).setCellValue(obj.getString("outsider_parent") + "%=" + Utils.fenToYuan(obj.getString("outsider_parent_money")) + "元");
            //非会员-父级返佣比
            row.createCell((short) 25).setCellValue(obj.getString("outsider_self") + "%=" + Utils.fenToYuan(obj.getString("outsider_self_money")) + "元");
            //非会员-子级返佣比
            //row.createCell((short) 23).setCellValue(Utils.caseReturn(obj.getString("my_is_member"),obj.getString("cashback"),obj.getString("member_self"),obj.getString("outsider_self")));
            row.createCell((short) 26).setCellValue(obj.getString("department_name") + "-" + obj.getString("nick_name"));
            //员工账号
            row.createCell((short) 27).setCellValue(obj.getString("phone"));
            //员工手机号
            int editTimeSize = obj.getString("edit_time").length();
            if (editTimeSize == 10) {
                row.createCell((short) 28).setCellValue(obj.getString(" ---- "));
            } else {
                row.createCell((short) 28).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("edit_time")));
                //最后操作时间
            }
        }

        String excelName = "商品信息";
        resp.addHeader("Content-Disposition", "attachment;filename=" + new String(excelName.getBytes("gb2312"), "ISO8859-1") + ".xls");
        ServletOutputStream out = resp.getOutputStream();

        wb.write(out);
        out.close();
    }

    /**
     * 掌小龙订单列表导出
     * @param order_no
     * @param phone
     * @param price_min
     * @param price_max
     * @param request
     * @param resp
     * @throws Exception
     */
    public void exportZhangDZOrderExcel(String order_no,String goodsName,String status,String phone,String price_min, String price_max, HttpServletRequest request, HttpServletResponse resp) throws Exception {
        // 第一步，创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("掌大运营系统订单导出表");
        sheet.autoSizeColumn((short)0); //自动调整列宽
        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);
        // 第四步，创建单元格，并设置值表头 设置表头居中
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
        style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        HSSFCell cell = row.createCell((short) 0);
        cell = row.createCell((short) 0);
        cell.setCellValue("序号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 1);
        cell.setCellValue("录入回填单号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 2);
        cell.setCellValue("状态");
        cell.setCellStyle(style);
        cell = row.createCell((short) 3);
        cell.setCellValue("用户录入时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 4);
        cell.setCellValue("注册人手机号");
        cell.setCellStyle(style);
        cell = row.createCell((short) 5);
        cell.setCellValue("商品名称");
        cell.setCellStyle(style);
        cell = row.createCell((short) 6);
        cell.setCellValue("用户下单时间");
        cell.setCellStyle(style);
        cell = row.createCell((short) 7);
        cell.setCellValue("用户备注）");
        cell.setCellStyle(style);

        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，
        String orderListStr = CreateSimpleExcelService.getZhangDAZOrder(order_no,goodsName,status,phone,price_min, price_max);
        JSONObject result_json = JSONObject.parseObject(orderListStr);
        JSONArray jsonArray = result_json.getJSONObject("result").getJSONArray("rs");
        for (int i = 0; i < jsonArray.size(); i++) {
            row = sheet.createRow((int) i + 1);
            JSONObject obj = jsonArray.getJSONObject(i);
            // 第四步，创建单元格，并设置值
            row.createCell((short) 0).setCellValue(String.valueOf(i + 1));
            row.createCell((short) 1).setCellValue(obj.getString("order_no"));
            row.createCell((short) 2).setCellValue(Utils.zdzOrderStatus(obj.getString("status")));
            row.createCell((short) 3).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("create_date")));
            row.createCell((short) 4).setCellValue(obj.getString("phone"));

            row.createCell((short) 5).setCellValue(obj.getString("goods_name"));
            row.createCell((short) 6).setCellValue(Utils.baseCaseTimeFrmat(obj.getString("create_date")));
            row.createCell((short) 7).setCellValue(obj.getString("remark"));
        }
        String excelName = "掌小龙账单信息";
        resp.addHeader("Content-Disposition", "attachment;filename=" + new String(excelName.getBytes("gb2312"), "ISO8859-1") + ".xls");
        ServletOutputStream out = resp.getOutputStream();
        wb.write(out);
        out.close();
    }
}
