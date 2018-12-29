<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/header.jsp" %>
<%@include file="menu_task.jsp" %>

<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use(['laydate', 'upload', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table //表格
            , upload = layui.upload
            , element = layui.element; //元素操作
        var form = layui.form;
        //列表加载
        table.render({
            elem: '#PurchasingOrderList'
            , url: '${ctx}/taskManage?method=getSkipTasksInfo'
            , limit: 100
            , limits: [50, 100, 500, 1000]
            , height: 690
            , cols: [[
                {type: 'numbers', fixed: 'true', align: 'center'}
                , {type: 'checkbox', fixed: 'left'}
                , {field: 'order_no', width: 200, title: '订单编号', align: 'center', templet: '#order_noTpl'}
                , {field: 'transaction_no', width: 180, title: '商户订单号', align: 'center'}
                , {
                    field: 'status', width: 120, title: '订单状态', align: 'center', templet: function (d) {
                        switch (d.status) {
                            case "101":
                                return "待支付";
                            case "102":
                                return "待处理";
                            case "103":
                                return "待备货";
                            case "104":
                                return "待发货";
                            case "105":
                                return "待签收";
                            case "106":
                                return "待签收";
                            case "107":
                                return "已签收";
                            case "108":
                                return "已完成";
                            case "109":
                                return "失效订单";
                            case "110":
                                return "取消订单（待支付）";
                            case "111":
                                return "取消订单（申请退款）";
                            case "112":
                                return "异常订单";
                            case "113":
                                return "已取消（售后取消）";
                            default:
                                return "----";
                        }
                    }
                }
                , {
                    field: 'spu_name', width: 400, title: '商品名称', align: 'center', templet: function (d) {
                        return d.spu_name;
                    }
                }
                , {
                    field: 'spu_code', width: 150, title: '商品编码', align: 'center', templet: function (d) {
                        return d.spu_code;
                    }
                }
                , {field: 'sku_num', width: 100, title: '商品数量', align: 'center'}

                , {
                    field: 'goods_url', width: 350, title: '商品链接', align: 'center', templet: function (d) {
                        if (d.goods_url == "") {
                            return "无连接"
                        } else {
                            return d.goods_url;
                        }

                    }
                }

                , {
                    field: 'created_date', width: 170, title: '用户下单时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.created_date == "") {
                            index = "----";
                        } else {
                            index = "20" + d.created_date.substr(0, 2) + "-" + d.created_date.substr(2, 2) + "-" + d.created_date.substr(4, 2) + " " + d.created_date.substr(6, 2) + ":" + d.created_date.substr(8, 2) + ":" + d.created_date.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {
                    field: 'purchas_order_state', width: 150, title: '处理状态', align: 'center', templet: function (d) {
                        // if(d.goods_source=="代购自营"){
                        if (d.purchas_order_state == "1") {
                            return "已分配";
                        } else if (d.purchas_order_state == "2") {
                            return "已购买（未提交运单号）";
                        } else if (d.purchas_order_state == "3") {
                            return "完成代购（已提交运单号）";
                        } else if (d.purchas_order_state == "4") {
                            return "已完成（提交运单号七天后）";
                        } else if (d.purchas_order_state == "5") {
                            return "已取消";
                        } else {
                            return "待分配";
                        }
                        // }else{
                        //     return "----";
                        // }

                    }
                }
                , {
                    field: 'substituter', width: 150, title: '代购人', align: 'center', templet: function (d) {
                        if (d.substituter == "") {
                            return "---";
                        } else {
                            //return d.department_name+"-"+d.nick_name;
                            return d.substituter;
                        }

                    }
                }
                , {field: 'phone', width: 150, title: '手机号', align: 'center'}
                , {
                    field: 'payment_way_key', width: 100, title: '支付方式', align: 'center', templet: function (d) {
                        if (d.payment_way_key == "WetCat") {
                            return "微信支付";
                        }
                    }
                }
                , {
                    field: 'data_source', width: 150, title: '订单来源', align: 'center', templet: function (d) {
                        if (d.data_source == "miniWetCat") {
                            return "小程序";
                        } else {
                            return "APP";
                        }
                    }
                }
                , {field: 'goods_source', width: 100, title: '商品来源', align: 'center'}
                , {field: 'waybill_no', width: 100, title: '运单号', align: 'center'}
                , {field: 'assign_user', width: 100, title: '任务指派人', align: 'center'}
                , {
                    field: 'create_time', width: 170, title: '任务指派时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.create_time == "") {
                            index = "----";
                        } else {
                            index = "20" + d.create_time.substr(0, 2) + "-" + d.create_time.substr(2, 2) + "-" + d.create_time.substr(4, 2) + " " + d.create_time.substr(6, 2) + ":" + d.create_time.substr(8, 2) + ":" + d.create_time.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {field: 'edit_user', width: 100, title: '操作人', align: 'center'}
                , {
                    field: 'edit_time', width: 170, title: '操作时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.edit_time == "") {
                            index = "----";
                        } else {
                            index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {fixed: 'right', title: '操作', width: 200, align: 'center', toolbar: "#orderDetailInfoManage"}
            ]]
            , page: true//关闭自动分页
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , id: 'PurchasingOrderListInfoReload'
        });


        table.on('checkbox(PurchasingOrderListFilter)', function (obj) {
        });
        table.on('tool(PurchasingOrderListFilter)', function (obj) {
            if (obj.event === 'orderDetailInfo') {
                if (obj.data.purchas_order_state == "") {
                    layer.msg("请先分配代购人");
                } else {
                    console.log("  obj.data.pur_id   " + obj.data.pur_id)
                    //return false;
                    window.location.href = "orderCountRebateDetail.jsp?order_id=" + obj.data.id + "&pur_id=" + obj.data.pur_id;
                }
            }
        });
        var $ = layui.$, active = {
            Assignment_Task_Btu: function () {
                $("#dep_name").find("option").remove();
                $("#user_name").val("");
                var checkStatus = table.checkStatus('PurchasingOrderListInfoReload');
                var data = checkStatus.data;
                var selectCount = data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条数据！");
                    return false;
                }
                ;
                var ids = new Array(selectCount);
                //var nick_name=new Array(selectCount);
                var assign_user = new Array(selectCount);
                var status = new Map();
                for (var i = 0; i < selectCount; i++) {
                    ids[i] = checkStatus.data[i].id;
                    //nick_name[i]=checkStatus.data[i].nick_name;
                    assign_user[i] = checkStatus.data[i].assign_user;
                    status.set(checkStatus.data[i].order_no, checkStatus.data[i].status);
                }
                ;
                /*for(var obj in nick_name){
                    if(nick_name[obj]!=""){
                        layer.msg("请选择未指派订单！");
                        return false;
                    }
                };*/
                for (var obj in assign_user) {
                    if (assign_user[obj] != "") {
                        layer.msg("请选择未指派订单！");
                        return false;
                    }
                }
                ;
                status.forEach(function (value, key, map) {
                    if (value == "101") {
                        layer.msg("订单号：" + key + "为待支付状态不能指派");
                        return false;
                    } else if (value == "106") {
                        layer.msg("订单号：" + key + "为待提收状态不能指派");
                        return false;
                    } else if (value == "107") {
                        layer.msg("订单号：" + key + "为已提收状态不能指派");
                        return false;
                    } else if (value == "108") {
                        layer.msg("订单号：" + key + "为已完成状态不能指派");
                        return false;
                    } else if (value == "109") {
                        layer.msg("订单号：" + key + "为失效订单状态不能指派");
                        return false;
                    } else if (value == "110") {
                        layer.msg("订单号：" + key + "为已提收状态不能指派");
                        return false;
                    } else if (value == "111") {
                        layer.msg("订单号：" + key + "为已取消（申请退款）状态不能指派");
                        return false;
                    } else if (value == "112") {
                        layer.msg("订单号：" + key + "为异常订单状态不能指派");
                        return false;
                    } else if (value == "113") {
                        layer.msg("订单号：" + key + "为已取消（售后取消）状态不能指派");
                        return false;
                    } else {
                        openAssignment_Task();
                    }

                });


            }
        };

        function openAssignment_Task() {
            layer.open({
                type: 1
                , title: ['分配任务—员工列表', 'font-size: 20px']
                , offset: 'auto'
                , id: 'Assignment_Task_Manage'
                , area: ['800px', '500px']
                , content: $('#Assignment_Task_Div')
                //,btn: '关闭'
                , shade: 0 //不显示遮罩
                , btnAlign: 'c' //按钮居中
                , yes: function () {
                    layer.closeAll();
                }
                , success: function () {
                    <%--var url="";--%>
                    <%--if($('#dep_name').val()!=null || $('#user_name').val() !=""){--%>
                    <%--alert(1111)--%>
                    <%--url="${ctx}/taskManage?method=getPurchaserList";--%>
                    <%--}--%>
                    table.render({
                        elem: '#PurchaserList'
                        , url: '${ctx}/taskManage?method=getPurchaserList'
                        , height: 300
                        , cols: [[
                            {type: 'numbers', fixed: 'true', align: 'center'}
                            , {type: 'checkbox', fixed: 'left'}
                            , {field: 'nick_name', width: 400, title: '代购人姓名', align: 'center', fixed: 'left'}
                            // ,{field:'department_name', width:150, title: '本月已完成代购订单数量',align:'center',fixed: 'left'}
                            // ,{field:'phone', width:150, title: '本周已完成代购订单数量',align:'center'}
                            // ,{field:'created_date', width:150, title: '未完成代购订单数量',align:'center'}
                            , {fixed: 'right', title: '操作', width: 207, align: 'center', toolbar: "#PurchaserManage"}
                        ]]
                        , page: true//关闭自动分页
                        , limit: 50 //每页显示的条数
                        , limits: [50, 100]
                        , response: {
                            statusName: 'success' //数据状态的字段名称，默认：code
                            , statusCode: 1  //成功的状态码，默认：0
                            , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                            , countName: 'total' //数据总数的字段名称，默认：count
                            , dataName: 'rs' //数据列表的字段名称，默认：data
                        }
                        , id: 'PurchaserListInfoReload'
                    });

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/department",
                        data: "method=getDepartmentInfoToSel",
                        dataType: "json",
                        success: function (data) {
                            var array = data.rs;
                            if (array.length > 0) {
                                for (var obj in array) {
                                    $("#dep_name").append("<option value='" + array[obj].id + "'>" + array[obj].department_name + "</option>");
                                }
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    });

                }
            });
        }


        $("#sreach").on('click', function () {
            table.reload('PurchasingOrderListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    orderNum: $('#orderNum').val(),
                    transaction_no: $('#transaction_no').val(),
                    nick_name: $('#nick_name').val(),
                    phoneNum: $('#phoneNum').val(),
                    purchasingOrder_source: $('#purchasingOrder_source').val(),
                    price_min: $('#price_min').val(),
                    price_max: $('#price_max').val(),
                    order_source: $('#order_source').val(),
                    order_Type: $('#order_Type').val(),
                    status: $('#status').val(),
                    sku_name: $('#sku_name').val(),
                    spuCode: $('#spu_code').val()
                }
            });
            return false;
        });

        $("#PurchaserReset").on('click', function () {
            $('#orderNum').val("");
            $('#transaction_no').val("");
            $('#nick_name').val("");
            $('#phoneNum').val("");
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
                , where: {
                    orderNum: $('#orderNum').val(),
                    transaction_no: $('#transaction_no').val(),
                    nick_name: $('#nick_name').val(),
                    phoneNum: $('#phoneNum').val(),
                    purchasingOrder_source: $('#purchasingOrder_source').val(),
                    price_min: $('#price_min').val(),
                    price_max: $('#price_max').val(),
                    order_source: $('#order_source').val(),
                    order_Type: $('#order_Type').val(),
                    status: $('#status').val(),
                    sku_name: $('#sku_name').val(),
                    spuCode: $('#spu_code').val()
                }
            });
            return false;
        });


        $("#PurchaserSreach").on('click', function () {
            table.reload('PurchaserListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    dep_name: $('#dep_name').val(),
                    user_name: $('#user_name').val()
                }
            });
            return false;
        });

        $("#PurchaserReset").on('click', function () {
            // $('#dep_name').val("");
            $('#user_name').val("");
            //执行重载
            table.reload('PurchaserListInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    orderNum: $('#dep_name').val(),
                    nick_name: $('#user_name').val()
                }
            });
            return false;
        });


        table.on('tool(PurchaserFilter)', function (obj) {
            var lock = false;
            if (obj.event === 'Appointed_Task') {
                var checkStatus = table.checkStatus('PurchasingOrderListInfoReload');
                var data = checkStatus.data;
                var selectCount = data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条数据！");
                    return false;
                }
                ;
                var ids = new Array(selectCount);
                for (var i = 0; i < selectCount; i++) {
                    ids[i] = checkStatus.data[i].id;
                }
                layer.confirm('确认指派吗？', function (index) {
                    if (lock) {
                        alert("请勿连续点击");
                        return;
                    }
                    lock = true;
                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/taskManage?method=appointedTask&id=" + obj.data.id + "&order_id=" + ids,
                        // data:{'id':obj.data.id,'order_id':ids} ,   //批量处理 status=2 移入回收站
                        dataType: "json",
                        success: function (data) {
                            if (data.success == 1) {
                                layer.closeAll();
                                table.reload("PurchasingOrderListInfoReload");
                                layer.msg("指派成功");

                            }
                            else {
                                layer.closeAll();
                                table.reload("PurchasingOrderListInfoReload");
                                layer.msg("异常");

                            }
                        },
                        error: function () {
                            layer.closeAll();
                            table.reload("PurchasingOrderListInfoReload");
                            layer.alert("错误");
                        }
                    });
                });
            }
        });

        $('.Assignment_Task_Div .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_min'
            , type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_max'
            , type: 'datetime'
        });

        function onLoadData() {
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/taskManage",
                data: "method=getPurchasingTerraceInfo",
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        var array = data.result.rs;
                        if (array.length > 0) {
                            for (var obj in array) {
                                $("#purchasingOrder_source").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</option>");

                            }
                        }
                        //(注意：需要重新渲染)

                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });

            form.render('select');
            return false;
        };

        onLoadData();
    });
    //导入代购订单
    <%--function importOrder() {--%>
    <%--var url = "${ctx}/purchaseOrderImport?method=uploadExcel";--%>
    <%--window.location.href= url;--%>
    <%--}--%>
    //导出订单
    function exportOrder() {
        var exportData = "";
        var orderNum = $('#orderNum').val();
        var transaction_no = $('#transaction_no').val();
        //var nick_name = $('#nick_name').val();
        var phoneNum = $('#phoneNum').val();
        var purchasingOrder_source = $('#purchasingOrder_source').val();
        var price_min = $('#price_min').val();
        var price_max = $('#price_max').val();
        var order_source = $('#order_source').val();
        var order_Type = $('#order_Type').val();
        var status = $('#status').val();
        var sku_name = $('#sku_name').val();
        var spuCode = $('#spu_code').val();

        if (spuCode != "") {
            exportData = "&spuCode=" + spuCode
        }
        if (orderNum != "") {
            exportData = "&orderNum=" + orderNum
        }
        if (transaction_no != "") {
            exportData = "&transaction_no=" + transaction_no
        }
        /*if(nick_name!=""){
            exportData = exportData+"&nick_name="+nick_name
        }*/
        if (sku_name != "") {
            exportData = exportData + "&sku_name=" + sku_name
        }
        if (phoneNum != "") {
            exportData = exportData + "&phoneNum=" + phoneNum
        }
        if (purchasingOrder_source != "") {
            exportData = exportData + "&purchasingOrder_source=" + purchasingOrder_source
        }
        if (price_min != "") {
            exportData = exportData + "&price_min=" + price_min
        }
        if (price_max != "") {
            exportData = exportData + "&price_max=" + price_max
        }
        if (order_source != "") {
            exportData = exportData + "&order_source=" + order_source
        }
        if (order_Type != "") {
            exportData = exportData + "&order_Type=" + order_Type
        }
        if (status != "") {
            exportData = exportData + "&status=" + status
        }
        debugger
        var url = "${ctx}/createSimpleExcelToDisk?method=exportPurOrderExcel";
        if (exportData != "")
            url = url + exportData;
        var fileName = "testAjaxDownload.txt";
        /*  var form = $("<form></form>").attr("action", url).attr("method", "post");
         form.appendTo('body').submit(); */
        window.location.href = url;


    }
</script>

<script id="create_timeTpl" type="text/html">

    {{#  if(d.create_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_time.substr(0,2) }}-{{ d.create_time.substr(2,2) }}-{{ d.create_time.substr(4,2) }} {{ d.create_time.substr(6,2) }}:{{ d.create_time.substr(8,2) }}:{{ d.create_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>
<script type="text/html" id="order_noTpl">
    <a href="#" onclick="Foo('{{d.order_no}}','{{d.id}}')" class="a" style="color: #003399">{{ d.order_no }}</a>
</script>
<script type="text/html" id="goodsNameTpl">
    <a href="#" onclick="Foo('{{d.spu_name}}','{{d.id}}')" class="a" style="color: #003399">{{ d.spu_name }}</a>
</script>
<script type="text/html" id="orderDetailInfoManage">
    {{#  if(d.purchas_order_state == 2){ }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">查看详情</a>
    {{#  } else if(d.purchas_order_state == 3) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">查看详情</a>
    {{#  } else if(d.purchas_order_state == 4) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">查看详情</a>
    {{#  } else if(d.purchas_order_state == 5) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">查看详情</a>
    {{#  } else  { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">去处理</a>

    {{#  } }}
</script>
<script type="text/html" id="PurchaserManage">
    <button class="layui-btn layui-btn-xs" lay-event="Appointed_Task">指派任务</button>
</script>

<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">代购订单任务分配表</div>
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">
                    <label class="layui-form-label">订单编号</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="orderNum" id="orderNum">
                    </div>

                    <label class="layui-form-label">商户订单号</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="transaction_no" id="transaction_no">
                    </div>
                    <%--<label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input class="layui-input" autocomplete="off" name="nick_name" id="nick_name"  autocomplete="off">
                    </div>--%>

                    <label class="layui-form-label">手机号</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="phoneNum" id="phoneNum" autocomplete="off">
                    </div>

                    <label class="layui-form-label">商品名称</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="sku_name" id="sku_name" autocomplete="off">
                    </div>

                    <label class="layui-form-label" style="width: 150px">代购订单来源</label>
                    <div class="layui-input-inline">
                        <select name="purchasingOrder_source" style="width: 150px" id="purchasingOrder_source"
                                lay-filter="aihao" lay-verify="required">
                            <option value="">全部</option>
                        </select>
                    </div>
                </div>

                <div class="layui-form-item" style="margin-bottom: 0">
                    <label class="layui-form-label">订单来源</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <select class="layui-select" name="order_source" id="order_source" autocomplete="off">
                            <option value="" selected="selected">全部</option>
                            <option value="miniWetCat">小程序</option>
                            <option value="App">APP</option>
                        </select>
                    </div>

                    <label class="layui-form-label">商品编码</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="spu_code" id="spu_code" autocomplete="off">
                    </div>

                    <label class="layui-form-label">订单状态</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <select class="layui-select" name="status" id="status" lay-filter="aihao">
                            <option value="" selected="selected">全部</option>
                            <option value="101">待支付</option>
                            <option value="103">待备货</option>
                            <option value="104">待发货</option>
                            <option value="105">已发货</option>
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
                        <select class="layui-select" style="width: 150px" name="order_Type" id="order_Type"
                                lay-filter="aihao">
                            <option value="" selected="selected">全部</option>
                            <option value="-1">待分配</option>
                            <option value="1">已分配</option>
                            <option value="2">已购买（未提交运单号）</option>
                            <option value="4">已完成</option>
                            <option value="5">已取消</option>
                        </select>
                    </div>

                    <label class="layui-form-label">下单时间</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input"
                               type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px">
                        <input name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input"
                               type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-input-inline" style="width: 200px">
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="sreach"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="reset"><i class="layui-icon">&#x2746;</i>重置
                        </button>
                    </div>

                </div>
            </div>
        </form>
        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="exportSearch" onclick="exportOrder()"><i
                class="layui-icon">&#xe67c;</i>导出
        </button>
        <div class="layui-inline Assignment_Task_Div" style="margin-top: 5px">
            <button class="layui-btn layui-btn-sm" data-type="Assignment_Task_Btu" id="Assignment_Task_Btu"><i
                    class="layui-icon">&#xe614;</i>任务分配
            </button>
        </div>

        <button type="button" class="layui-btn layui-btn-sm" style="margin-top:5px;" id="importSearch">选择文件</button>
        <button type="button" class="layui-btn layui-btn-sm" style="margin-top:5px;" value="免费获取验证码"
                onclick="settime(this)" id="test9">
            开始上传
        </button>

        <%-- <button type="button" class="layui-btn layui-btn-sm"  style="margin-top:5px;" id="importSearch">
             <i class="layui-icon">&#xe67c;</i>导入
         </button>--%>

        <script type="application/javascript">
            function subtraction(count) {
                var countdown = count;
                return countdown;
            }

            function settime(val) {
                var countdown = subtraction('');
                if (countdown == '') {
                    countdown = 300;
                }
                console.log("    countdown   " + countdown);
                if (countdown == 0) {
                    val.removeAttribute("disabled");
                    val.value = "可以开始上传EXCEL 支持格式后缀为xls和xlsx 请注意查看";
                    // layer.msg(val.value);
                    layer.msg(val.value,{time:30*1000},function() {
//回调
                    })
                } else {
                    val.setAttribute("disabled", true);
                    val.value = "系统正在努力加载EXCEL中..请稍等";
                    // layer.msg(val.value);
                    layer.msg(val.value,{time:300*1000},function() {
//回调
                    })
                }
                // setTimeout(function () {
                //     settime(val)
                // }, 1000)
            }

            layui.use('upload', function () {
                var $ = layui.jquery
                    , upload = layui.upload;
                var layer = layui.layer;
                //指定允许上传的文件类型
                <%--upload.render({--%>
                <%--elem: '#importSearch'--%>
                <%--, url: '${ctx}/purchaseOrderImport?method=uploadExcel'--%>
                <%--, accept: 'file' //普通文件--%>
                <%--, done: function (res) {--%>
                <%--console.log("  res   " + res.msg);--%>
                <%--layer.msg(res.msg);--%>
                <%--//setTimeout(6000,navigators());--%>
                <%--}--%>
                <%--});--%>

                //选完文件后不自动上传
                upload.render({
                    elem: '#importSearch'
                    , url: '${ctx}/purchaseOrderImport?method=uploadExcel'
                    , accept: 'file' //普通文件
                    , auto: false
                    //,multiple: true
                    , bindAction: '#test9'
                    , done: function (res) {
                        console.log("  res   " + res.msg);
                        layer.msg(res.msg);
                        subtraction(0);
                        $('#test9').attr("disabled", false);
                    }
                });

            });

            function navigators() {
                window.location.href = "skipTasksInfo.jsp";
            }
        </script>


        <table class="layui-hide" id="PurchasingOrderList" lay-filter="PurchasingOrderListFilter"></table>
        <!-- 分配任务 -->
        <div id="Assignment_Task_Div" style="display: none;">
            <div style="padding: 15px;margin-left: 20px">
                <div class="layui-inline">
                    <label>部门</label>
                    <div class="layui-inline">
                        <select class="layui-select" style="width: 200px" autocomplete="off" name="dep_name"
                                id="dep_name">
                            <%--<option value="" >请选择</option>--%>
                        </select>
                    </div>
                </div>
                <div class="layui-inline" style="margin-left: 30px">
                    <label>姓名</label>
                    <div class="layui-inline">
                        <input class="layui-input" name="user_name" id="user_name">
                    </div>
                </div>
                <button class="layui-btn layui-btn-sm" style="margin-left: 10px" id="PurchaserSreach"><i
                        class="layui-icon">&#xe615;</i>搜索
                </button>
                <button class="layui-btn layui-btn-sm" id="PurchaserReset"><i class="layui-icon">&#x2746;</i>重置</button>
            </div>

            <div style="margin-left: 30px;width: 700px">
                <table class="layui-table" id="PurchaserList" lay-filter="PurchaserFilter"></table>
            </div>
        </div>
    </div>

</div>

<div class="layui-footer">
    <%@ include file="/common/footer.jsp" %>
</div>






