<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/order_menu.jsp" %>

<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var element = layui.element;
        table.render({
            elem: '#orderList'
            , height: 710
            , url: '${ctx}/order?method=getRefundsOrder'
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
            , limits: [50,100, 500, 100]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            },
        });



        /*table.on('checkbox(orderlist)', function(obj){
        });*/
        table.on('tool(orderlist)', function(obj){
            if(obj.event === 'orderDetailInfo'){
                console.log("  obj.data.pur_id   "+obj.data.pur_id)
                //return false;
                window.location.href="refundsOrderDetail.jsp?order_id="+obj.data.id+"&pur_id="+obj.data.pur_id+"&order_no="+obj.data.order_no;
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
    var order_no = "";
    var order_type = "";
    var status = "";
    function Foo(order_no, id) {
        layer.open({
            type: 2,
            title: '订单详情',
            shadeClose: true,
            area: ['57%', '85%'],
            content: ['orderDetails.jsp', 'no'],
            yes: function (id) {

            }
            , success: function (layero, index) {
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/order?method=getLineItemByOrderId",
                    data: {'id': id},   //批量处理 status=2 移入回收站
                    dataType: "json",
                    success: function (data) {
                        var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                        if (data.success == 1) {
                            var array = data.result.rs;

                            for (var obj in array) {
                                body.contents().find("#order_no").text(array[obj].order_no);
                                body.contents().find("#order_type").text(array[obj].order_type);
                                if (array[obj].status == "103") {
                                    body.contents().find("#status").text("待备货");
                                }
                                if (array[obj].status == "104") {
                                    body.contents().find("#status").text("待发货");
                                }
                                if (array[obj].status == "101") {
                                    body.contents().find("#status").text("待支付");
                                }
                                if (array[obj].status == "105") {
                                    body.contents().find("#status").text("已发货");
                                }
                                if (array[obj].status == "106") {
                                    body.contents().find("#status").text("待提收");
                                }
                                if (array[obj].status == "107") {
                                    body.contents().find("#status").text("已提收");
                                }
                                if (array[obj].status == "108") {
                                    body.contents().find("#status").text("已完成");
                                }
                                if (array[obj].status == "110") {
                                    body.contents().find("#status").text("已取消");
                                }
                                if (array[obj].status == "111") {
                                    body.contents().find("#status").text("已取消");
                                }
                                if (array[obj].status == "113") {
                                    body.contents().find("#status").text("已取消");
                                }
                                if (array[obj].status == "112") {
                                    body.contents().find("#status").text("异常订单");
                                }
                                if (array[obj].status == "109") {
                                    body.contents().find("#status").text("失效订单");
                                }
                                //body.contents().find("#status").text(array[obj].status);
                                body.contents().find("#payment_way_key").text((array[obj].payment_way_key=="wetcat")?"微信":"---");
                                body.contents().find("#total_price").text("￥" + array[obj].total_price / 100);
                                body.contents().find("#market_price").text("￥" + array[obj].total_price / 100);
                                body.contents().find("#backMoney").text("￥" + array[obj].backMoney / 10000);
                                body.contents().find("#consignee").text(array[obj].consignee);
                                body.contents().find("#delivery_address").text(array[obj].delivery_address);
                                body.contents().find("#consignee_tel").text(array[obj].consignee_tel);
                                if (array[obj].logistics_status == "1") {
                                    body.contents().find("#logistics_status").text("正在途中");
                                }
                                //body.contents().find("#logistics_status").text(array[obj].logistics_status);
                                body.contents().find("#logistics_numbers").text(array[obj].logistics_numbers);
                                body.contents().find("#edit_user").text(array[obj].edit_user);
                                body.contents().find("#remark").text(array[obj].remark);
                                body.contents().find("#edit_time").text(array[obj].edit_time);
                                body.contents().find("#orderInfoGeneral").text(array[obj].orderInfoGeneral);
                                break;
                            }

                        }
                        else {
                            layer.msg("异常");
                        }
                    }
                });
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/order?method=getGoodsByOrderId",
                    data: {'id': id},
                    dataType: "json",
                    success: function (data) {
                        var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                        if (data.success == 1) {
                            var array = data.rs;
                            for (var obj in array) {
                                body.contents().find("#order_no").text(array[obj].order_no);
                                body.contents().find("#order_type").text(array[obj].order_type);
                                body.contents().find("#status").text(array[obj].status);
                                body.contents().find("#source_code").text(array[obj].source_code);
                                body.contents().find("#spu_code").text(array[obj].spu_code);
                                body.contents().find("#sku_name").text(array[obj].sku_name);
                                body.contents().find("#sku_num").text(array[obj].sku_num);
                                body.contents().find("#detail_img_ids").text(array[obj].detail_img_ids);
                                body.contents().find("#backMoney").text("￥" + array[obj].backMoney / 10000);
                                body.contents().find("#market_price").text("￥" + array[obj].market_price / 100);
                                if (array[obj].stock > 0) {
                                    body.contents().find("#stock").text("有货");
                                }
                                if (array[obj].stock <= 0) {
                                    body.contents().find("#stock").text("缺货");
                                }
                                body.contents().find("#goodsInfoDetailList").text(array[obj].order_no);
                                break;
                            }
                        }
                        else {
                            layer.msg("异常");
                        }
                    },

                });
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/order?method=getProStatus",
                    data: {'id': id},
                    dataType: "json",
                    success: function (data) {
                        var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                        if (data.success == 1) {
                            var array = data.rs;
                            for (var obj in array) {
                                body.contents().find("#order_no1").text(array[obj].order_no);
                                body.contents().find("#memo1").text(array[obj].memo);
                                body.contents().find("#payment_way_key1").text(array[obj].payment_way_key);
                                body.contents().find("#edit_user1").text(array[obj].edit_user);
                                body.contents().find("#orderInfoHandleStyle").text(array[obj].orderInfoHandleStyle);
                                break;
                            }
                        }
                        else {
                            layer.msg("异常");
                        }
                    },
                    error: function () {
                        layer.alert("错误");
                    }
                });

            }

        });
    }

    //提交
    function exportOrder() {
        var exportData = "";
        var order_no = $('#order_no').val();
        var nick_name = $('#nick_name').val();
        var phone = $('#phone').val();
        var consignee = $('#consignee').val();
        var submission_time = $('#submission_time').val();
        var logistics_numbers = $('#logistics_numbers').val();
        var transaction_no = $('#transaction_no').val();
        /*var created_date = $('#created_date').val();*/
        var price_min = $('#price_min').val();
        var price_max = $('#price_max').val();
        if(order_no!=""){
            exportData = "&order_no="+order_no
        }
        if(transaction_no!=""){
            exportData = "&transaction_no="+transaction_no
        }
        if(nick_name!=""){
            exportData = exportData+"&nick_name="+nick_name
        }
        if(phone!=""){
            exportData = exportData+"&phone="+phone
        }
        if(consignee!=""){
            exportData = exportData+"&consignee="+consignee
        }
        if(submission_time!=""){
            exportData =exportData+ "&submission_time="+submission_time
        }
        if(logistics_numbers!=""){
            exportData =exportData+ "&logistics_numbers="+logistics_numbers
        }

        /*if(created_date!=""){
            exportData = exportData+"&created_date="+created_date
        }*/
        if(price_min!=""){
            exportData =exportData+ "&price_min="+price_min
        }
        if(price_max!=""){
            exportData =exportData+ "&price_max="+price_max
        }


        var url = "${ctx}/createSimpleExcelToDisk?method=exportOrderExcel";
        if(exportData != "")
            url =url+exportData;
        var fileName = "testAjaxDownload.txt";
        /*  var form = $("<form></form>").attr("action", url).attr("method", "post");
         form.appendTo('body').submit(); */
        window.location.href= url;
        //参数拼装
        // var exportData ="&order_no="+order_no+"&nick_name="+nick_name+"&phone="+phone+"&consignee="+consignee+"&submission_time="+submission_time+
        //          "&logistics_numbers="+logistics_numbers+"&created_date="+created_date;
    }

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
    <div class="layui-body">
        <div style="padding:5px 5px 0px 5px">
            <div class="layui-elem-quote">待处理退款</div>
            <form class="layui-form layui-form-pane">
                <div style="background-color: #f2f2f2;padding:5px 0">
                    <div class="layui-form-item" style="margin-bottom:5px">

                        <label class="layui-form-label">订单编号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="order_no" id="order_no">
                        </div>

                        <label class="layui-form-label">商户订单号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="transaction_no" id="transaction_no">
                        </div>

                        <label class="layui-form-label">买家昵称</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="nick_name" id="nick_name">
                        </div>

                        <label class="layui-form-label">买家手机号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="phone" id="phone">
                        </div>

                        <label class="layui-form-label">商品名称</label>
                        <div class="layui-input-inline" style="width: 150px" >
                            <input class="layui-input" autocomplete="off" name="spu_name" id="spu_name"  autocomplete="off">
                        </div>

                    </div>
                    <div class="layui-form-item" style="margin-bottom: 0">
                        <label class="layui-form-label">收货人</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="consignee" id="consignee">
                        </div>
                        <label class="layui-form-label" style="width: 150px">退款时间</label>

                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>

                        <div class="layui-form-mid">-</div>
                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>


                    </div>
                    <button id="searchBtn"  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索
                    </button>

                    <button  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset"><i class="layui-icon">&#x2746;</i>重置
                    </button>

                    <button id="exportSearch" onclick="exportOrder()" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe67c;</i>导出
                    </button>

                </div>
            </form>
            <table class="layui-table" id="orderList" lay-filter="orderlist"></table>
        </div>
    </div>

    <%@ include file="/common/footer.jsp" %>