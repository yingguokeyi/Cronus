<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/common.jsp" %>
<%@ include file="/common/order_menu.jsp" %>


<script>


    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var element = layui.element;
        var $ = layui.jquery;
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table//表格
            , form = layui.form;
        table.render({
            elem: '#OrderToBePaidTable'
            , height: 720
            , url: '${ctx}/order?method=getOrderByStatusPaid'
            , cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                ,{field: 'order_no', width: 250, title: '订单号',align:'center', templet: '#idTpl'}
                ,{field: 'transaction_no', width: 250, title: '订单商户号',align:'center'}
                , {field: 'nick_name', width: 200, title: '买家昵称',align:'center'}
                , {field: 'phone', width: 150, title: '买家手机号', align:'center'}
                , {field: 'sku_num', width: 50, title: '商品数量',align:'center',templet: '#skuNum'}
                , {field: 'attribute_value', width: 180, title: '规格名称1',align:'center',templet: '#attributeValue'}
                , {field: 'attribute_value2', width: 180, title: '规格名称2',align:'center',templet: '#attributeValue2'}
                , {field: 'sku_num', width: 120, title: '商品数量',align:'center',templet: '#skuNum'}
                , {field: 'status', width: 150, title: '状态', align:'center', templet: '#statusTpl'}
                , {field: 'dict_data_name', width:160, title: '类型',align:'center'}
                , {field: 'created_date', width: 300, title: '下单时间', align:'center', templet: '#create_timeTpl'}
                , {field: 'score', width: 300, title: '操作',align:'center', toolbar: "#OrderToBePaidManage"}
            ]]
            , id: 'OrderToBePaidReload'
            , page: true
            , limit: 100
            , limits: [50, 100, 500, 100]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            }
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

        table.on('tool(OrderToBePaidFilter)', function(obj){
            var data = obj.data;
            if(obj.event === 'Order_Error'){
                layer.open({
                    type: 1
                    , title: '异常订单处理'
                    , id: 'layerDemo'
                    , area: ['400px']
                    , content: $('#Order_Error_Page')
                    ,btn: ['保存','取消']
                    , btnAlign: 'c' //按钮居中
                    ,shade: 0 //不显示遮罩
                    , yes: function () {
                        <%--$.ajax({--%>
                            <%--type: "get",--%>
                            <%--async: false, // 同步请求--%>
                            <%--cache: true,// 不使用ajax缓存--%>
                            <%--contentType: "application/json",--%>
                            <%--url: "${ctx}/order?method=getGoodsByOrderId",--%>
                            <%--data: {'id': data.id},   //批量处理 status=2 移入回收站--%>
                            <%--dataType: "json",--%>
                            <%--success: function (data) {--%>
                                <%--table.reload("OrderToBePaidReload");--%>
                                <%--layer.msg(data.order_no+"订单异常处理成功");--%>
                            <%--},--%>
                            <%--error: function () {--%>
                                <%--layer.alert("错误");--%>
                            <%--}--%>
                        <%--});--%>
                    }
                    ,btn2:function () {
                        layer.closeAll();
                    }
                    ,success:function () {
                        $("#error_order_no").val(data.order_no);
                    }
                });
            }
        });

        //搜索
        $('#searchBtn').on('click', function () {
            //执行重载
            table.reload('OrderToBePaidReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    order_no: $('#order_no').val(),
                    nick_name: $('#nick_name').val(),
                    phone: $('#phone').val(),
                    consignee: $('#consignee').val(),
                    price_max:$('#price_max').val(),
                    price_min:$('#price_min').val(),
                    submission_time: $('#submission_time').val(),
                    logistics_numbers: $('#logistics_numbers').val(),
                    created_date: $('#created_date').val(),
                    transaction_no:$('#transaction_no').val()
                }
            });
            return false;
        });
        //重置
        $('#resetBtn').on('click', function () {
            $('#order_no').val("");
            $('#nick_name').val("");
            $('#phone').val("");
            $('#consignee').val("");
            $('#submission_time').val("");
            $('#logistics_numbers').val("");
            $('#created_date').val("");
            $('#price_max').val("");
            $('#price_min').val("");
            $('#transaction_no').val("");

            //执行重载
            table.reload('OrderToBePaidReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    order_no: $('#order_no').val(),
                    nick_name: $('#nick_name').val(),
                    price_max:$('#price_max').val(),
                    price_min:$('price_min').val(),
                    phone: $('#phone').val(),
                    consignee: $('#consignee').val(),
                    submission_time: $('#submission_time').val(),
                    logistics_numbers: $('#logistics_numbers').val(),
                    created_date: $('#created_date').val(),
                    transaction_no:$('#transaction_no').val()
                }
            });
            return false;
        });

        form.on('select(error_remarkFilter)', function(data){
            if($("#error_remark").val()!="0"){
                $("#order_remark").text($("#error_remark").find("option:selected").text());
            }
        });

    });

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
                                if(array[obj].payment_way_key==='wetcat'){
                                    body.contents().find("#payment_way_key").text('微信');
                                }else{
                                    body.contents().find("#payment_way_key").text(array[obj].payment_way_key);
                                }
                                body.contents().find("#total_price").text("￥" + array[obj].total_price / 100);
                                body.contents().find("#market_price1").text("￥" + array[obj].market_price / 100);
                                body.contents().find("#backMoney1").text("￥" + array[obj].backMoney / 10000);
                                body.contents().find("#consignee").text(array[obj].consignee);
                                body.contents().find("#delivery_address").text(array[obj].delivery_address);
                                body.contents().find("#consignee_tel").text(array[obj].consignee_tel);
                                if (array[obj].logistics_status == "1") {
                                    body.contents().find("#logistics_status").text("正在途中");
                                }
                                //body.contents().find("#logistics_status").text(array[obj].logistics_status);
                                body.contents().find("#logistics_numbers").text(array[obj].logistics_numbers);
                                // If(typeof array[obj].created_date=="number"){
                                //     array[obj].created_date+=' ';
                                // }
                                // body.contents().find("#btn").find("#create_time").text(array[obj].created_date);
                                body.contents().find("#goodsTableOrderCode").text(array[obj].order_no);
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
          /*      $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/order?method=getGoodsByOrderId",
                    data: {'id': id},   //批量处理 status=2 移入回收站
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
                                body.contents().find("#goodsTableOrderCode1").text(array[obj].order_no);
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
*/
            }


        });

    }


</script>
<style>
    .layui-form-select dl { max-height:100px; }
</style>

<script type="text/html" id="idTpl">
    <a href="#" onclick="Foo('{{d.order_no}}','{{d.id}}')" class="a" style="color: #003399">{{ d.order_no }}</a>
</script>
<script type="text/html" id="OrderToBePaidManage">
    <a class="layui-btn layui-btn-xs" lay-event="Order_Error">异常订单</a>
</script>


    <div class="layui-body">
        <div style="padding:5px 5px 0px 5px">
            <div class="layui-elem-quote">待支付</div>
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
                        <label class="layui-form-label">手机号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="phone" id="phone">
                        </div>

                    </div>
                    <div class="layui-form-item" style="margin-bottom: 0">
                        <label class="layui-form-label">收货人</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="consignee" id="consignee">
                        </div>
                        <label class="layui-form-label">发货时间</label>
                        <div class="layui-input-inline">
                            <input name="submission_time" lay-verify="date" placeholder="年/月/日" autocomplete="off"
                               class="layui-input" type="text" id="submission_time">
                        </div>
                        <label class="layui-form-label">运单号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="logistics_numbers"
                               id="logistics_numbers">
                        </div>

                        <%--<label class="layui-form-label">下单时间</label>
                        <div class="layui-input-inline">
                            <input lay-verify="date" placeholder="年/月/日" autocomplete="off" class="layui-input" type="text"
                               name="created_date" id="created_date">
                        </div>--%>
                        <label class="layui-form-label" style="width: 150px">下单起止时间</label>

                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>

                        <div class="layui-form-mid">-</div>
                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>

                    </div>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" id="searchBtn">
                        <i class="layui-icon">&#xe615;</i>搜索
                    </button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset" id="resetBtn">
                        <i class="layui-icon">&#x2746;</i>重置
                    </button>
                </div>
            </form>
            <table class="layui-hide" id="OrderToBePaidTable" lay-filter="OrderToBePaidFilter"></table>
        </div>
        <!-- 异常处理页面 -->
        <div id="Order_Error_Page" style="display: none; padding: 15px;">
            <form class="layui-form layui-form-pane" action="">
                <div class="layui-form-item">
                    <label class="layui-form-label">订单号</label>
                    <div class="layui-input-block">
                        <input class="layui-input" type="text" name="error_order_no" id="error_order_no" lay-verify="title" autocomplete="off" readonly="readonly" >
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-block">
                        <select class="layui-select" id="error_remark" name="error_remark" lay-filter="error_remarkFilter">
                            <option value="0" selected="">请选择异常原因</option>
                            <option value="1">收货人信息错误或不具有可执行性</option>
                            <option value="2">买家恶意刷单</option>
                            <option value="3">其他原因</option>
                        </select>
                    </div>
                    <div class="layui-form-item layui-form-text">
                        <div class="layui-input-block">
                            <textarea class="layui-textarea" id="order_remark"></textarea>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script type="text/html" id="statusTpl">
        {{# if(d.status =='103'){}}
        待备货
        {{# }else if(d.status =='104'){ }}
        待发货
        {{# }else if(d.status =='106'){ }}
        待提收
        {{# }else if(d.status =='107'){ }}
        已提收
        {{# }else if(d.status =='108'){ }}
        已完成
        {{# }else if(d.status =='112'){ }}
        异常订单
        {{# }else if(d.status =='110'){ }}
        取消订单
        {{# }else if(d.status =='109'){ }}
        失效订单
        {{# }else if(d.status =='101'){ }}
        待支付
        {{# } }}
    </script>
    <script id="create_timeTpl" type="text/html">

        {{#  if(d.created_date !== ''){ }}
        <span style="color: rgba(10,10,10,0.46);">20{{ d.created_date.substr(0,2) }}-{{ d.created_date.substr(2,2) }}-{{ d.created_date.substr(4,2) }} {{ d.created_date.substr(6,2) }}:{{ d.created_date.substr(8,2) }}:{{ d.created_date.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
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
    <%@ include file="/common/footer.jsp" %>


