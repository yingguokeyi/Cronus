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
            elem: '#ToBePaid'
            , height: 600
            , url: '${ctx}/order?method=getOrderByStatusCan'
            , cols: [[
                // {field: 'id', width: 80, title: 'ID', sort: true, fixed: 'left'},
                {field: 'order_no', width: 200, title: '订单号',align:'center', templet: '#idTpl'}
                , {field: 'status', width: 170, title: '状态',align:'center', sort: true, templet: '#statusTpl'}
                , {field: 'order_type', width: 100, title: '类型', align:'center',templet: '#order_typeTpl'}
                //, {field: 'sign', width: 130, title: '发货仓库', templet: '#signTpl'}
                , {field: 'sku_name', width: 300, title: '商品名称',align:'center', templet: '#skuName'}
                , {field: 'attribute_value', width: 180, title: '规格类型1',align:'center', templet: '#attribute_value'}
                , {field: 'attribute_value2', width: 180, title: '规格类型2',align:'center', templet: '#attribute_value2'}
                , {field: 'sku_num', width: 120, title: '商品数目',align:'center', templet: '#skuNum'}
                , {field: 'created_date', width: 200, title: '下单时间',align:'center', sort: true, templet: '#create_timeTpl'}
                , {field: 'cancel_date', width: 200, title: '取消时间',align:'center', sort: true, templet: '#cancel_dateTpl'}
                , {field: 'nick_name', width: 170, title: '买家昵称',align:'center', templet: '#nick_nameTpl'}
                , {field: 'phone', width: 150, title: '买家手机号',align:'center', sort: true, templet: '#phoneTpl'}
                , {field: 'score', width: 170, title: '操作',align:'center', sort: true, toolbar: "#barDemo"}
            ]]
            , id: 'testReload'
            , page: true
            , limit: 100
            , limits: [ 50, 100,500,1000]
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


        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        $('#searchBtn').on('click', function () {
            var order_no = $('#order_no');
            var nick_name = $('#nick_name');
            var phone = $('#phone');
            var price_max = $('#price_max');
            var price_min = $('#price_min');
            var consignee = $('#consignee');
            var submission_time = $('#submission_time');
            var logistics_numbers = $('#logistics_numbers');
            var created_date = $('#created_date');
            var transaction_no = $('#transaction_no');
            //执行重载
            table.reload('testReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    order_no: order_no.val(),
                    nick_name: nick_name.val(),
                    phone: phone.val(),
                    price_max: price_max.val(),
                    price_min: price_min.val(),
                    consignee: consignee.val(),
                    submission_time: submission_time.val(),
                    logistics_numbers: logistics_numbers.val(),
                    created_date: created_date.val(),
                    transaction_no: transaction_no.val()
                }
            });


            return false;
        });


    });

    function Foo(order_no, id,logistics_numbers) {
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
                                    body.contents().find("#status").text("已取消（待支付）");
                                }
                                if (array[obj].status == "111") {
                                    body.contents().find("#status").text("已取消（申请退款）");
                                }
                                if (array[obj].status == "113") {
                                    body.contents().find("#status").text("已取消（售后取消）");
                                }
                                if (array[obj].status == "112") {
                                    body.contents().find("#status").text("异常订单");
                                }
                                if (array[obj].status == "109") {
                                    body.contents().find("#status").text("失效订单");
                                }
                                //body.contents().find("#status").text(array[obj].status);
                                body.contents().find("#payment_way_key").text(array[obj].payment_way_key);
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
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/order?method=getGoodsByOrderNo",
                    data: {'orderNo': order_no},   //批量处理 status=2 移入回收站
                    dataType: "json",
                    success: function (data) {
                        var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                        if (data.success == 1) {
                            var array = data.rs;
                            for (var obj in array) {
                                body.contents().find("#status").text(array[obj].status);
                                body.contents().find("#sku_code").text(array[obj].sku_code);
                                body.contents().find("#source_code").text(array[obj].source_code);
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
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    url: "https://biz.trace.ickd.cn/auto/"+logistics_numbers,
                    data: {'mailNo': logistics_numbers},   //批量处理 status=2 移入回收站
                    dataType:'jsonp',
                    success: function (data) {
                        var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                        if (data.status == 3) {
                            var array = data.data;
                            var html = "";
                            for (var obj in array) {
                                body.contents().find("#time").text(array[obj].time);
                                body.contents().find("#context").text(array[obj].context.replace('<i>', '').replace('</i>/', ''));
                                html = body.contents().find("#orderLogistic").append(body.contents().find("#orderLogistic").clone());
                            }
                            console.log(html)
                            body.contents().find("#orderLogisticsInfo").replaceChild(html);

                        }
                        else {
                            layer.msg(data.message);
                        }
                    },
                    error: function () {
                        layer.alert("错误");
                    }
                });

            }


        });

    }

</script>


<script type="text/html" id="idTpl">
    <a href="#" onclick="Foo('{{d.order_no}}','{{d.id}}','{{d.logistics_numbers}}')" class="a" style="color: #003399">{{ d.order_no }}</a>
</script>
<script type="text/html" id="barDemo">
    <a class="layui-btn"
       style="height: 20px;line-height: 20px;width:100px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none"
       lay-event="Foo" onclick="Foo('{{d.order_no}}','{{d.id}}','{{d.logistics_numbers}}')">查看订单</a>
</script>


<div class="layui-body">
    <!-- 内容主体区域 -->

    <div style="padding: 15px;">
        <div class="layui-row">
            <div class="layui-elem-quote" style="background-color: #EEEEEE">
                <label>已取消</label>
            </div>

            <form class="layui-form layui-form-pane">
                <div style="background-color: #f2f2f2;padding:5px 0">

                    <div class="layui-form-item" style="margin-bottom:5px">
                        <label class="layui-form-label">订单编号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="order_no" id="order_no">
                        </div>

                        <label class="layui-form-label">订单商户号</label>
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

                        <label class="layui-form-label" >起止时间</label>

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
                </div>

            </form>

            <table class="layui-hide" id="ToBePaid" lay-filter="ToBePaid"></table>
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
        已取消（待支付）
        {{# }else if(d.status =='111'){ }}
        已取消（申请退款）
        {{# }else if(d.status =='113'){ }}
        已取消（售后取消）
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

    <script id="cancel_dateTpl" type="text/html">

        {{#  if(d.cancel_date !== ''){ }}
        <span style="color: rgba(10,10,10,0.46);">20{{ d.cancel_date.substr(0,2) }}-{{ d.cancel_date.substr(2,2) }}-{{ d.cancel_date.substr(4,2) }} {{ d.cancel_date.substr(6,2) }}:{{ d.cancel_date.substr(8,2) }}:{{ d.cancel_date.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
        {{#  } }}
    </script>
    <script type="text/html" id="create_timeTpl">
        {{# if(d.created_date ==''){}}
        <span style="color: rgba(10,10,10,0.46); text-align: center;"> ----</span>
        {{# }else { }}
        {{d.created_date}}
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
        {{# if(d.edit_time ==''){}}
        <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
        {{# }else { }}
        {{d.edit_time}}
        {{# } }}
    </script>
    <script type="text/html" id="edit_userTpl">
        {{# if(d.edit_user ==''){}}
        <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
        {{# }else { }}
        {{d.edit_user}}
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

    <%@ include file="/common/footer.jsp" %>


