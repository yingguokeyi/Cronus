package model;

/**
 * 代购订单信息 导入字段
 */

public class PurchaseOrderImport {
    public int id;
    // 订单ID
    public String orderNo;
    // 订单编号
    public int createUserId;
    // 代购人ID
    public String memo;
    // 用户备注
    public String purchasPlatform;
    // 代购平台
    public int pay;
    // 实际支付金额
    public String purchasOrderNo;
    // 代购订单编号
    public String purchasingTerraceNo;
    // 下单账号
    public String substituter;
    // 代付人
    public String expressCompany;
    // 运单公司
    public String waybilNoo;
    // 运单号
    public String logisticsCompanies;
    // 代购订单备注
    public String updateDate;
    // 当前信息修改时间
    public int pid;
    // 代购订单ID
    public String msg;
    // 返回前台信息提示
    public int orderStatus;
    // 更新订单状态
    /**
     * 104 待发货
     * 105 待签收
     */

    public PurchaseOrderImport(){

    }

    public PurchaseOrderImport(int orderStatus,String msg,int pid,int id, String orderNo, int createUserId, String memo, String purchasPlatform, int pay, String purchasOrderNo, String purchasingTerraceNo, String substituter, String expressCompany, String waybilNoo, String logisticsCompanies, String updateDate) {
        this.pid = pid;
        this.id = id;
        this.orderNo = orderNo;
        this.createUserId = createUserId;
        this.memo = memo;
        this.purchasPlatform = purchasPlatform;
        this.pay = pay;
        this.purchasOrderNo = purchasOrderNo;
        this.purchasingTerraceNo = purchasingTerraceNo;
        this.substituter = substituter;
        this.expressCompany = expressCompany;
        this.waybilNoo = waybilNoo;
        this.logisticsCompanies = logisticsCompanies;
        this.updateDate = updateDate;
        this.orderStatus = orderStatus;
        this.msg = msg;
    }

    @Override
    public String toString() {
        return "PurchaseOrderImport{" +
                "id=" + id +
                ", orderNo='" + orderNo + '\'' +
                ", createUserId=" + createUserId +
                ", memo='" + memo + '\'' +
                ", purchasPlatform='" + purchasPlatform + '\'' +
                ", pay=" + pay +
                ", purchasOrderNo='" + purchasOrderNo + '\'' +
                ", purchasingTerraceNo='" + purchasingTerraceNo + '\'' +
                ", substituter='" + substituter + '\'' +
                ", expressCompany='" + expressCompany + '\'' +
                ", waybilNoo='" + waybilNoo + '\'' +
                ", logisticsCompanies='" + logisticsCompanies + '\'' +
                ", updateDate='" + updateDate + '\'' +
                ", pid=" + pid +
                ", msg="+ msg +
                ", orderStatus="+orderStatus+
                '}';
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public int getPid() {
        return pid;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public int getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(int createUserId) {
        this.createUserId = createUserId;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getPurchasPlatform() {
        return purchasPlatform;
    }

    public void setPurchasPlatform(String purchasPlatform) {
        this.purchasPlatform = purchasPlatform;
    }

    public int getPay() {
        return pay;
    }

    public void setPay(int pay) {
        this.pay = pay;
    }

    public String getPurchasOrderNo() {
        return purchasOrderNo;
    }

    public void setPurchasOrderNo(String purchasOrderNo) {
        this.purchasOrderNo = purchasOrderNo;
    }

    public String getPurchasingTerraceNo() {
        return purchasingTerraceNo;
    }

    public void setPurchasingTerraceNo(String purchasingTerraceNo) {
        this.purchasingTerraceNo = purchasingTerraceNo;
    }

    public String getSubstituter() {
        return substituter;
    }

    public void setSubstituter(String substituter) {
        this.substituter = substituter;
    }

    public String getExpressCompany() {
        return expressCompany;
    }

    public void setExpressCompany(String expressCompany) {
        this.expressCompany = expressCompany;
    }

    public String getWaybilNoo() {
        return waybilNoo;
    }

    public void setWaybilNoo(String waybilNoo) {
        this.waybilNoo = waybilNoo;
    }

    public String getLogisticsCompanies() {
        return logisticsCompanies;
    }

    public void setLogisticsCompanies(String logisticsCompanies) {
        this.logisticsCompanies = logisticsCompanies;
    }

    public String getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(String updateDate) {
        this.updateDate = updateDate;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public int getOrderStatus() {
        return orderStatus;
    }
}
