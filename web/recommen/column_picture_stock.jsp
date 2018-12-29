<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/header.jsp"%>
<%@include file="/recommen/menu_recommen.jsp" %>

<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });
    layui.use(['laydate', 'upload', 'layer', 'table', 'element'] , function(){
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table //表格
            , upload = layui.upload
            , element = layui.element; //元素操作
        var form = layui.form;
        //列表加载
        table.render({
            elem: '#purchasingOrderHandleListTab'
          //  ,url:'${ctx}/taskManage?method=getpurchasingOrderHandleList'
            ,limit:100
            ,limits:[50,100,500,1000]
            ,height: 640
            ,cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                ,{type:'checkbox', fixed: 'left'}
                ,{field:'order_no', width:150, title: '订单编号',align:'center',fixed: 'left',templet: '#order_noTpl'}
                ,{field:'transaction_no', width:150, title: '商户订单号',align:'center',fixed: 'left'}
                ,{field:'status', width:150, title: '订单状态',align:'center',templet:function (d) {
                        switch (d.status){
                            case "101":
                                return "待支付";
                            case "103":
                                return "待备货";
                            case "104":
                                return "待发货";
                            case "106":
                                return "待提收";
                            case "107":
                                return "已提收";
                            case "108":
                                return "已完成";
                            case "109":
                                return "失效订单";
                            case "110":
                                return "已取消（待支付）";
                            case "111":
                                return "已取消（申请退款）";
                            case "112":
                                return "异常订单";
                            case "113":
                                return "已取消（售后取消）";
                            default:
                                return "----";
                        }
                    }}
                ,{field:'spu_name', width:400, title: '商品名称',align:'center', templet:function(d){
                        return d.spu_name+"_"+d.sku_name;
                    }}
                ,{field:'created_date', width:150, title: '用户下单时间',align:'center'}
                ,{field:'purchas_order_state', width:150, title: '代购状态',align:'center',templet:function (d) {
                        if(d.purchas_order_state=="1"){
                            return "已分配";
                        }else if(d.purchas_order_state=="2"){
                            return "已购买（未提交运单号）";
                        }else if(d.purchas_order_state=="4"){
                            return "已完成";
                        }else if(d.purchas_order_state=="5"){
                            return "已取消";
                        }
                    }}
                ,{field:'nick_name', width:150, title: '代购人',align:'center',templet: function (d) {
                        if(d.nick_name==""){
                            return "---";
                        }else{
                            return d.department_name+"-"+d.nick_name;
                        }

                    }}
                ,{field:'phone', width:150, title: '手机号',align:'center'}
                ,{field:'payment_way_key', width:100, title: '支付方式',align:'center',templet:function (d) {
                        if(d.payment_way_key=="WetCat"){
                            return "微信支付";
                        }
                    }}
                ,{field:'data_source', width:150, title: '订单来源',align:'center',templet:function (d) {
                        if(d.data_source=="miniWetCat"){
                            return "小程序";
                        }else {
                            return "APP";
                        }
                    }}
                ,{field:'goods_source', width:100, title: '商品来源',align:'center'}
                ,{field:'waybill_no', width:100, title: '运单号',align:'center'}
                ,{field:'assign_user', width:100, title: '任务指派人',align:'center'}
                ,{field:'create_time', width:150, title: '任务指派时间',align:'center',templet:function (d) {
                        var index="20"+d.create_time.substr(0,2)+"-"+d.create_time.substr(2,2)+"-"+d.create_time.substr(4,2)+" "+d.create_time.substr(6,2)+":"+d.create_time.substr(8,2)+":"+d.create_time.substr(10,2);
                        return index;
                    }}
                ,{field:'edit_user', width:100, title: '操作人',align:'center'}
                ,{field:'edit_time', width:100, title: '操作时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else{
                        var index="20"+d.edit_time.substr(0,2)+"-"+d.edit_time.substr(2,2)+"-"+d.edit_time.substr(4,2)+" "+d.edit_time.substr(6,2)+":"+d.edit_time.substr(8,2)+":"+d.edit_time.substr(10,2);
                    }
                        return index;
                    }}
                ,{fixed:'right',title:'操作', width:150,align:'center',toolbar:"#purchasingOrderHandleListTabManage"}
            ]]
            ,page:true//关闭自动分页
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,id:'PurchasingOrderListInfoReload'
        });

        table.on('checkbox(purchasingOrderHandleListFilter)', function(obj){
            console.log(obj.length)
            checkStatus = table.checkStatus('PurchasingOrderListInfoReload');
            data = checkStatus.data;
            selectCount = checkStatus.data.length;
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].Id;
            }
        });
        table.on('tool(purchasingOrderHandleListFilter)', function(obj){
            if(obj.event === 'purchasingOrderHandleDetailInfo'){
                window.location.href="orderCountRebateDetail.jsp?order_id="+obj.data.id;
            }
        });
        // var $ = layui.$, active = {
        //
        // };

        $("#sreach").on('click',function () {
            table.reload('PurchasingOrderListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    orderNum: $('#orderNum').val(),
                    transaction_no: $('#transaction_no').val(),
                    nick_name: $('#nick_name').val(),
                    phoneNum: $('#phoneNum').val(),
                    purchasingOrder_source: $('#purchasingOrder_source').val(),
                    price_min: $('#price_min').val(),
                    price_max: $('#price_max').val(),
                    order_source: $('#order_source').val(),
                    order_Type: $('#order_Type').val(),
                    status: $('#status').val()
                }
            });
            return false;
        });

        $("#reset").on('click',function () {
            $("#orderNum").val("");
            $("#transaction_no").val("");
            $("#nick_name").val("");
            $("#phoneNum").val("");
            $("#purchasingOrder_source").empty();
            $("#purchasingOrder_source").text("");
            $('#price_min').val("");
            $('#price_max').val("");
            $("#order_Type").text("");
            $("#order_Type").empty();
            $("#order_source").empty();
            $("#order_source").text("");
            $('#status').val("");
            //执行重载
            table.reload('PurchasingOrderListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    orderNum: $('#orderNum').val(),
                    transaction_no: $("#transaction_no").val(),
                    nick_name: $('#nick_name').val(),
                    phoneNum: $('#phoneNum').val(),
                    purchasingOrder_source: $('#purchasingOrder_source').val(),
                    price_min: $('#price_min').val(),
                    price_max: $('#price_max').val(),
                    order_source: $('#order_source').val(),
                    order_Type: $('#order_Type').val(),
                    status: $('#status').val()
                }
            });
            return false;
        });

        $('.Assignment_Task_Div .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });

    });


</script>
<script type="text/html" id="purchasingOrderHandleListTabManage">
    <a class="layui-btn layui-btn-xs" lay-event="purchasingOrderHandleDetailInfo" >查看详情</a>
</script>
<div class="layui-body" style="display: none">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">代购订单处理表</div>
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">
                    <label  class="layui-form-label">订单编号</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input class="layui-input"  autocomplete="off" name="orderNum" id="orderNum" >
                    </div>
                    <label  class="layui-form-label">商户订单号</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input class="layui-input"  autocomplete="off" name="transaction_no" id="transaction_no" >
                    </div>
                    <label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input class="layui-input" autocomplete="off" name="nick_name" id="nick_name"  autocomplete="off">
                    </div>
                    <label class="layui-form-label" style="width: 150px">手机号</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input class="layui-input" autocomplete="off" name="phoneNum" id="phoneNum"  autocomplete="off">
                    </div>

                    <label class="layui-form-label" style="width: 150px">代购订单来源</label>
                    <div class="layui-input-inline">
                        <select  name="purchasingOrder_source" style="width: 150px"  id="purchasingOrder_source" lay-filter="aihao" lay-verify="required">
                            <option value="">全部</option>
                        </select>
                    </div>



                </div>

                <div class="layui-form-item" style="margin-bottom: 0">

                    <label class="layui-form-label">订单来源</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <select class="layui-select"  name="order_source" id="order_source" autocomplete="off">
                            <option value="" selected="selected">全部</option>
                            <option value="miniWetCat">小程序</option>
                            <option value="App">APP</option>
                        </select>
                    </div>

                    <label class="layui-form-label">订单状态</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <select class="layui-select"  name="status" id="status" lay-filter="aihao">
                            <option value="" selected="selected">全部</option>
                            <option value="101">待支付</option>
                            <option value="103">待备货</option>
                            <option value="104">待发货</option>
                            <option value="106">待提收</option>
                            <option value="107">已提收</option>
                            <option value="108">已完成</option>
                            <option value="109">失效订单</option>
                            <option value="110">已取消（待支付）</option>
                            <option value="111">已取消（申请退款）</option>
                            <option value="112">异常订单</option>
                            <option value="113">已取消（售后取消）</option>
                        </select>
                    </div>

                    <label class="layui-form-label">代购状态</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <select class="layui-select" style="width: 150px" name="order_Type" id="order_Type" lay-filter="aihao">
                            <option value="" selected="selected">全部</option>
                            <option value="-1">待分配</option>
                            <option value="1">已分配</option>
                            <option value="2">已购买（未提交运单号）</option>
                            <option value="4">已完成</option>
                            <option value="5">已取消</option>
                        </select>
                    </div>

                    <label class="layui-form-label" style="width: 150px">用户下单时间</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <div class="layui-input-inline" style="width: 300px" >
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="sreach"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="reset" ><i class="layui-icon">&#x2746;</i>重置</button>
                        
                    </div>

                </div>
            </div>
        </form>
        <%--<button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="exportSearch" onclick="exportOrder()"><i class="layui-icon">&#xe67c;</i>导出</button>--%>
        <table class="layui-table"  id="purchasingOrderHandleListTab"  lay-filter="purchasingOrderHandleListFilter"></table>
    </div>
</div>
<div class="layui-footer">
    <%@ include file="/common/footer.jsp"%>
</div>


