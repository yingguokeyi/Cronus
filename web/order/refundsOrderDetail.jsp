<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/order_menu.jsp" %>


<%--<script type="text/javascript" src="${ctx}/layui/layui.js?t=1515376178738"></script>--%>
<%
    String order_id = request.getParameter("order_id");
    String pur_id = request.getParameter("pur_id");
    String orderNo = request.getParameter("order_no");
    if (pur_id == "") {
        pur_id = null;
    }
    String url = request.getRequestURI();
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
    System.out.println(imgUrlPrefix);
%>
<script>
    var imgUrlPrefix = "<%=imgUrlPrefix%>";
    var orderNo = "<%=orderNo%>";
    $(document).ready(function () {

        $.ajax({
            type: "get",
            contentType: "application/json",
            url: "${ctx}/taskManage?method=getSkipTasksDetailInfo",
            data: {'order_id':<%=order_id%>, 'pur_id':<%=pur_id%>},
            cache: false,
            async: true,
            dataType: "json",
            success: function (data) {
                var array = data.rs;
                for (var obj in array) {
                    $("#purchas_order_state").val(array[obj].purchas_order_state);
                    if (array[obj].order_error == '1') {
                        var form = layui.form;
                        $("#order_error_Meaker_Div").show();
                        $("#order_error").attr('checked', true);
                        $("#order_error_marker").text(array[obj].order_error_marker);
                        form.render('checkbox');
                        $("#order_error_hide").attr('value', 1);
                    }
                    $("#Consignee").val(array[obj].consignee);
                    $("#Consignee_phone").val(array[obj].consignee_tel);
                    $("#Consignee_site").val(array[obj].delivery_address);
                    if (array[obj].data_source == "miniWetCat") {
                        $("#order_source").val("小程序");
                    } else {
                        $("#order_source").val("APP");
                    }
                    $("#order_no").val(array[obj].order_no);
                    $("#order_no2").val(array[obj].order_no);
                    if (array[obj].created_date != undefined) {
                        $("#pre_order_date").val("20" + array[obj].created_date.substring(0, 2) + "-" + array[obj].created_date.substring(2, 4) + "-" + array[obj].created_date.substring(4, 6) + " " + array[obj].created_date.substring(6, 8) + ":" + array[obj].created_date.substring(6, 8) + ":" + array[obj].created_date.substring(8, 10));
                    }
                    $("#goods_name").val(array[obj].spu_name + array[obj].sku_name);
                    if (array[obj].goods_url) {
                        //document.getElementById("goods_url_copy").style.display = 'block';
                        $("#goods_url_copy").show();
                        $("#goods_url").val(array[obj].goods_url);
                        // $("#goods_url").css('display','none');
                    }
                    /*else{
                                            $("#goods_url").val(array[obj].goods_url);
                                        }*/

                    switch (array[obj].status) {
                        case "101":
                            $("#order_status").val("待支付");
                            break;
                        case "103":
                            $("#order_status").val("待备货");
                            break;
                        case "104":
                            $("#order_status").val("待发货");
                            break;
                        case "106":
                            $("#order_status").val("待提收");
                            break;
                        case "107":
                            $("#order_status").val("已提收");
                            break;
                        case "108":
                            $("#order_status").val("已完成");
                            break;
                        case "109":
                            $("#order_status").val("失效订单");
                            break;
                        case "110":
                            $("#order_status").val("已取消（待支付）");
                            break;
                        case "111":
                            $("#order_status").val("已取消（申请退款）");
                            break;
                        case "112":
                            $("#order_status").val("异常订单");
                            break;
                        case "113":
                            $("#order_status").val("已取消（售后取消）");
                            break;
                    }
                    var image_path = new Array();
                    var http_path = new Array();
                    if (array[obj].http_path == "") {
                        image_path = array[obj].image_path.split(",");
                        for (var i = 0; i < image_path.length; i++) {
                            $('#goods_img').append('<img src="' + imgUrlPrefix + image_path[i] + '"  class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px">')
                        }
                    } else {
                        http_path = array[obj].http_path.split(",");
                        for (var j = 0; j < http_path.length; j++) {
                            $('#goods_img').append('<img src="' + http_path[j] + '"  class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px">')
                        }
                    }
                    $("#total_price").val("￥ " + (array[obj].total_price * 0.01).toFixed(2));
                    $("#buy_num").val(array[obj].sku_num);
                    $("#sku_no").val(array[obj].frist_attribute_value + " " + array[obj].second_attribute_value);
                    $("#original_price").val("￥ " + (array[obj].original_price * 0.01).toFixed(2));
                    $("#order_remark").val(array[obj].remark);
                    if (array[obj].purchas_platform != "") {
                        $("#purchasing_terrace").val(array[obj].purchas_platform);
                    }
                    // if(array[obj].purchase_price!=0 && array[obj].purchase_price!=""){
                    //     $("#purchase_price").val(array[obj].purchase_price*0.01);
                    // }
                    // alert(1.35.toFixed(2));
                    if (array[obj].pay != 0 && array[obj].pay != "") {
                        $("#actual_payment_money").val((array[obj].pay * 0.01).toFixed(2));
                    }
                    $("#purchas_order_id").val(array[obj].pur_order_id);
                    if (array[obj].purchase_number == "") {
                        $("#purchase_number").val(1);
                    } else {
                        $("#purchase_number").val(array[obj].purchase_number);
                    }
                    $("#purchasing_freight").val(array[obj].purchase_freight);
                    $("#purchase_order_no").val(array[obj].purchas_order_no);
                    $("#waybill_no").val(array[obj].waybill_no);
                    // 运单号
                    $("#express_company").val(array[obj].express_company);
                    // 运单公司
                    $("#purchasing_terrace_no").val(array[obj].purchasing_terrace_no);
                    $("#order_error_marker").val(array[obj].logistics_companies);
                    $("#substituter").val(array[obj].substituter);
                    if (array[obj].status == "112") {
                        var form = layui.form;
                        $("#order_error_Meaker_Div").show();
                        $("#order_error").attr('checked', true);
                        $("#order_error_marker").text(array[obj].order_error_marker);
                        form.render('checkbox');
                        $("#order_error_hide").attr('value', 1);
                    }

                }
            }
        });
    });
    var clickTag = 0;

    // 验证 运单号 物流公司填写是否存在空格
    function checkNull(waybill_no, express_company) {
        if (waybill_no.indexOf(" ") == -1) {
            console.log(" 运单号  没有空格  验证通过 ");
            return true;
        } else {
            layer.msg("  填写 运单号 有空格！  ");
            return false;
        }

        if (express_company.indexOf(" ") == -1) {
            console.log(" 物流公司  没有空格  验证通过 ");
            return true;
        } else {
            layer.msg("  填写 物流公司 有空格！  ");
            return false;
        }
    }

    function saveSkipTasksDetailInfo() {
        var waybill_no = $("#waybill_no").val();
        var express_company = $("#express_company").val();

        if (!checkNull(waybill_no, express_company)) {
            // 运单号和物流公司 存在空格
            console.log("   运单号和物流公司 存在空格    ");
            layer.msg("  运单号和物流公司 不可以存在空格  请仔细检查  ");
            return false;
        }
        if (clickTag == 1) {
            alert("请勿频繁点击！");
            return;
        }
        clickTag = 1;
        $.ajax({
            type: "get",
            contentType: "application/json",
            url: "${ctx}/taskManage?method=saveSkipTasksDetailInfo",
            data: {'order_id':<%=order_id%>, 'jsonObj': JSON.stringify($('form').serializeObject())},
            cache: false,
            async: true,
            dataType: "json",
            success: function (data) {
                if (data.success) {
                    clickTag = 0;
                    alert("操作成功");
                    // history.go(-1);
                    window.location.href = "skipTasksInfo.jsp"
                }
            },
            error: function (error) {
                clickTag = 0;
                if (error.responseText != "") {
                    alert(error.responseText)
                }
            }
        });
    }


    function Consignee_Copy() {
        var e = document.getElementById("Consignee");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy", "true", null); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }

    function Consignee_phone_Copy() {
        var e = document.getElementById("Consignee_phone");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }

    function Consignee_site_Copy() {
        // window.clipboardData.setData("text","")
        var e = document.getElementById("Consignee_site");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }

    function goods_name_Copy() {
        var e = document.getElementById("goods_name");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        alert("复制成功");
        return false;
    }

    function goods_url_Copy() {
        //var goods_url =  $('#goods_url').html();
        var goods_url = document.getElementById("goods_url");
        if (goods_url == '') {
            document.execCommand("Clear"); //执行浏览器复制命令
            alert("该商品链接地址为空");
            return false;
        }
        var e = document.getElementById("goods_url");//对象是copy-num1
        e.select(); //选择对象
        document.execCommand("Copy"); //执行浏览器复制命令
        //alert("复制成功");
        window.open($('#goods_url').val(), 'target', '');
        return false;
    }

    layui.use(['form'], function () {
        var form = layui.form;

        form.on('checkbox(order_errorFilter)', function (obj) {
            if (this.name == 'order_error' && obj.elem.checked == false) {
                $("#order_error_Meaker_Div").hide();
                $("#order_error_hide").attr('value', 0);

            } else if (this.name == 'order_error' && obj.elem.checked == true) {
                $("#order_error_Meaker_Div").show();
                $("#order_error_hide").attr('value', 1);
            }
            form.render('checkbox');
        });
    });
</script>


<!-- 内容主体区域 -->
<div class="layui-body" style="padding: 15px">
    <blockquote class="layui-elem-quote">买家申请退款
        <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" style="margin-left: 70%"
                onclick="history.go(-1)">返回
        </button>
    </blockquote>
    <form class="layui-form">
        <input id="purchas_order_state" name="purchas_order_state" autocomplete="off" class="layui-input" type="hidden">
        <input id="order_error_value" name="order_error_value" autocomplete="off" class="layui-input" type="hidden">
        <input id="purchas_order_id" name="purchas_order_id" autocomplete="off" class="layui-input" type="hidden">
        <input id="order_no2" name="order_no2" autocomplete="off" class="layui-input" type="hidden">
        <h3>买家信息 : </h3>
        <hr class="layui-bg-blue">
        <div id="mainId">
            <br>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px;width: 200px">
                    <label style="width: 100px;height: 10px">买家昵称 :</label>&nbsp;&nbsp;
                    <input style="border:none;width: 200px" readonly="readonly" id="Consignee"/>
                </label>
                <label class="layui-label" style="margin-left: 500px;width: 350px">
                    <label style="width: 100px;height: 10px">注册手机号 : </label>&nbsp;&nbsp;
                    <input style="border:none" readonly="readonly" id="Consignee_phone"/>
                </label>
            </div>
            <br>
            <h3>收货人信息 : </h3>
            <hr class="layui-bg-blue">
                <div class="layui-form-item">
                    <label class="layui-label" style="margin-left: 20px;width: 200px">
                        <label style="width: 100px;height: 10px">收&nbsp;&nbsp;&nbsp;货&nbsp;&nbsp;&nbsp;人 :</label>&nbsp;&nbsp;
                        <input style="border:none;width: 200px" readonly="readonly" id="Consignees"/>
                    </label>
                    <label class="layui-label" style="margin-left: 500px;width: 350px">
                        <label style="width: 100px;height: 10px">收货人手机号 : </label>&nbsp;&nbsp;
                        <input style="border:none" readonly="readonly" id="Consignee_phones"/>
                    </label>
                </div>
                <br>
                <div class="layui-form-item">
                    <label class="layui-label" style="margin-left: 15px">
                        <label style="width: 100px;height: 10px">收货人地址 :</label>&nbsp;&nbsp;
                        <input type="text" style="border:none;width: 90%" readonly="readonly" id="Consignee_sites"/>
                    </label>
                </div>


            <h3>订单详情 : </h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单来源：
                    <input type="text" style="border:none;width: 200px;margin-left: 10px;color:#FF0000;"
                           readonly="readonly" id="order_source"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单编号：
                    <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="order_no"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">下单日期：
                    <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="pre_order_date"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单状态：
                    <input style="border:none;width: 200px;margin-left: 10px" readonly="order_status"
                           id="order_status"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">商品名称：
                    <input style="border:none;width: 80%;margin-left: 10px" readonly="readonly" id="goods_name"/>
                    <input style="border:none;width: 1px;" readonly="readonly" id="goods_url"/>
                </label>
                <div style="margin-left:100px;margin-top: 10px">
                    <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"
                            onClick="return goods_name_Copy()">复制商品名称
                    </button>
                    <button id="goods_url_copy" style="display: none;"
                            class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"
                            onClick="return goods_url_Copy()">点击进入商品详情页
                    </button>
                </div>
            </div>

            <%--<div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">商品图片：
                    <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                        <div class="layui-list" style="margin-left: 10px" id="goods_img"></div>
                    </blockquote>
                </label>
            </div>--%>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">支付金额：
                    <input style="border:none;width: 100px;margin-left: 10px" readonly="readonly" id="total_price"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">购买数量：
                    <input style="border:none;width: 100px;margin-left: 10px;color:#FF0000;" readonly="readonly"
                           id="buy_num"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">规格型号：
                    <input style="border:none;width: 200px;margin-left: 10px;color:#FF0000;" readonly="readonly"
                           id="sku_no"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">商品成本价：
                    <input style="border:none;width: 200px;margin-left: 10px;color:#FF0000;" readonly="readonly"
                           id="original_price"/>
                </label>
            </div>
            <div class="layui-form-item">
                <label class="layui-label" style="margin-left: 20px">订单备注：
                    <input style="border:none;width: 200px;margin-left: 10px;color:#FF0000;" readonly="readonly"
                           id="order_remark"/>
                </label>
            </div>
            <h3>代购信息 : </h3>
            <%--第二个代购信息--%>
            <table class="layui-table" id="orderList" lay-filter="orderlist"></table>
        </div>
    </form>
    <div style="margin-left: 20%">
        <button id="saveSkipTasksDetailInfo" onclick="saveSkipTasksDetailInfo()" class="layui-btn layui-btn-normal">确认
        </button>
        <%--<button id="saveAndToSKU" style="margin-left: 80px" class="layui-btn layui-btn-normal">取消</button>--%>
    </div>
</div>

<script>
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var element = layui.element;
        table.render({
            elem: '#orderList'
            , height: 300
            ,cellMinWidth: 80
            , url: '${ctx}/taskManage?method=getPurchasingTerraceList&orderNo='+orderNo
            , cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                /*,{field: 'id', width: 80, title: 'ID', sort: true, fixed: 'left', templet: '#id'}*/
                , {field: 'order_no', width: 200, title: '订单编号',align:'center', templet: '#idTpl'}
                , {field: 'transaction_no', width: 180, title: '商户订单号', align:'center',templet: '#transaction_noTpl'}
                , {field: 'status', width: 100, title: '处理状态', sort: true, align:'center',templet: '#statusTpl'}
                , {field:'goods_source', width:100, title: '商品来源',align:'center'}
                ,{field:'spu_code', width:150, title: '商品编码',align:'center', templet:function(d){
                        return d.spu_code;
                    }}
                , {field: 'nick_name', width: 170, title: '买家昵称', sort: true,align:'center',templet: '#nick_nameTpl'}
                , {field: 'phone', width: 130, title: '买家手机号',align:'center',templet: '#phoneTpl'}
                , {field: 'spu_name', width: 400, title: 'sku-商品名称',align:'center',templet: '#skuName'}
                ,{field:'goods_url', width:350, title: '商品链接',align:'center', templet:function(d){
                        if(d.goods_url == ""){
                            return "无连接"
                        }else {
                            return d.goods_url;
                        }
                    }}
                , {field: 'first_attribute_value', width: 120, title: '规格名称1',align:'center'}
                , {field: 'second_attribute_value', width: 120, title: '规格名称2',align:'center'}
                , {field: 'refunds_number', width: 100, title: '商品数量',align:'center',templet: '#refunds_number'}
                , {field: 'total_price', width: 100, title: '实际付款金额',align:'center',templet: function (d) {
                        var num = "";
                        if (d.top == "") {
                            num = "----"
                        } else {
                            num=Number(d.total_price*0.01).toFixed(2)+"元";
                        }
                        return num;
                    }}
                , {field: 'consignee', width: 100, title: '收货人',align:'center',templet: '#Consignee'}
                , {field: 'delivery_address', width: 100, title: '收货地址',align:'center',templet: '#skuNum'}
                , {field: 'consignee_tel', width: 200, title: '收货人电话',align:'center', templet: '#consignee_tel'}
                , {field: 'create_date', width: 200, title: '申请时间',align:'center', templet: '#create_timeTpl'}
                , {field: 'status', width: 100, title: '订单状态', sort: true, align:'center',templet: '#statusTpl'}
                , {field: 'edit_date', width: 200, title: '最后处理时间',align:'center',templet: '#edit_timeTpl'}
                , {field: 'operation_user', width: 170, title: '最后操作者',align:'center',templet: '#edit_userTpl'}
                , {field: 'orderRemark', width: 200, title: '客户备注',align:'center',templet: '#orderRemark'}
                , {field: 'remark', width: 200, title: '备注',align:'center',templet: '#remark'}
                , {fixed:'right',title:'操作', width:200,align:'center',toolbar:"#orderDetailInfoManage"}
            ]]
            , id: 'testReload'
            , page: true
            , limit: 100
            , limits: [10,20, 30, 50]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            },
        });



        table.on('checkbox(orderlist)', function(obj){
        });
        table.on('tool(orderlist)', function(obj){
            if(obj.event === 'orderDetailInfo'){
                console.log("  obj.data.pur_id   "+obj.data.pur_id)
                //return false;
                window.location.href="refundsOrderDetail.jsp?order_id="+obj.data.id+"&pur_id="+obj.data.pur_id;
            }
        });



        $('.demoTable .layui-btn').on('click', function () {
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

        $('#searchBtn,#exportSearch').on('click', function () {
            var order_no = $('#order_no');
            var transaction_no = $('#transaction_no');
            var nick_name = $('#nick_name');
            var phone = $('#phone');
            var consignee = $('#consignee');
            var submission_time = $('#submission_time');
            var logistics_numbers = $('#logistics_numbers');
            /*var created_date = $('#created_date');*/
            var price_min= $('#price_min').val();
            var price_max= $('#price_max').val();
            //执行重载
            table.reload('testReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    order_no: order_no.val(),
                    transaction_no:transaction_no.val(),
                    nick_name: nick_name.val(),
                    phone: phone.val(),
                    consignee: consignee.val(),
                    submission_time: submission_time.val(),
                    logistics_numbers: logistics_numbers.val(),
                    /*created_date: created_date.val()*/
                    price_min: price_min,
                    price_max: price_max

                }
            });
            return false;
        });

    });
</script>
<script type="text/html" id="statusTpl">
    {{# if(d.status =='0'){}}
    待处理
    {{# }else if(d.status =='1'){ }}
    处理中
    {{# }else if(d.status =='2'){ }}
    挂起
    {{# }else if(d.status =='3'){ }}
    已完成
    {{# }}}
</script>
<script id="create_timeTpl" type="text/html">

    {{#  if(d.create_date !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_date.substr(0,2) }}-{{ d.create_date.substr(2,2) }}-{{ d.create_date.substr(4,2) }} {{ d.create_date.substr(6,2) }}:{{ d.create_date.substr(8,2) }}:{{ d.create_date.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>
<script type="text/html" id="transaction_noTpl">
    {{# if(d.transaction_no==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.transaction_no}}
    {{# } }}
</script>
<script type="text/html" id="logistics_numbersTpl">
    {{# if(d.logistics_numbers ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.logistics_numbers}}
    {{# } }}
</script>
<script type="text/html" id="nick_nameTpl">
    {{# if(d.nick_name ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.nick_name}}
    {{# } }}
</script>
<script type="text/html" id="phoneTpl">
    {{# if(d.phone ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.phone}}
    {{# } }}
</script>


<script type="text/html" id="edit_timeTpl">
    {{# if(d.edit_date ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.edit_date.substr(0,2) }}-{{ d.edit_date.substr(2,2) }}-{{ d.edit_date.substr(4,2) }} {{ d.edit_date.substr(6,2) }}:{{ d.edit_date.substr(8,2) }}:{{ d.edit_date.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="edit_userTpl">
    {{# if(d.operation_user ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.operation_user}}
    {{# } }}
</script>
<script>
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#submission_time'
        });
        //常规用法
        laydate.render({
            elem: '#created_date'
        });
    });

</script>
<script type="text/html" id="idTpl">
    <a href="#" onclick="Foo('{{d.order_no}}','{{d.id}}')" class="a" style="color: #003399">{{ d.order_no }}</a>
</script>
<script type="text/html" id="orderDetailInfoManage">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo" >处理退款</a>
</script>