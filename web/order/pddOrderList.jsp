<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/common.jsp" %>
<%@ include file="/common/order_menu.jsp" %>

<script>
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var element = layui.element;
        table.render({
            elem: '#pddOrderList'
            , height: 710
            , url: '${ctx}/order?method=getPddOrderList'
            , cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                , {field: 'order_sn', width: 150, title: '订单编号',fixed: 'left',align:'center'}
                , {field: 'custom_parameters', width: 150, title: '用户手机号', fixed: 'left',align:'center'}
                , {field: 'goods_id', width: 150, title: '商品ID', fixed: 'left',align:'center'}
                , {field: 'goods_name', width: 200, title: '商品标题',fixed: 'left',align:'center'}
                , {field: 'goods_quantity', width: 150, title: '购买商品的数量',align:'center'}
                , {field: 'goods_price', width: 100, title: '商品价格',align:'center',templet: function (d) {
                    return "￥" + d.goods_price / 100;
                    }
                }
                , {field: 'order_amount', width: 150, title: '实际支付金额',align:'center',templet: function (d) {
                    return "￥" + d.order_amount / 100;
                    }
                }
                , {field: 'promotion_rate', width: 100, title: '佣金比例',align:'center',templet: function (d) {
                    var index="";
                    if(d.promotion_rate==""){
                        index="--";
                    }else {
                        var index = d.promotion_rate/10 + "%";
                    }
                    return index;
                    }
                }
                , {field: 'promotion_amount', width: 150, title: '佣金金额',align:'center',templet: function (d) {
                    return "￥" + d.promotion_amount / 100;
                }
                }
                , {field: 'order_status', width: 120, title: '订单状态',align:'center',templet: '#orderStatus'}
                , {field: 'type', width: 180, title: '订单来源',align:'center',templet: '#orderType'}
                , {field: 'order_create_time', width: 180, title: '订单生成时间',align:'center',templet: function (d) {
                    var index="";
                    if(d.order_create_time==""){
                        index="----";
                    }else {
                        var index = formatDateTime(d.order_create_time*1000);
                    }
                    return index;
                    }
                }
                , {field: 'order_modify_at', width: 180, title: '最后更新时间',align:'center',templet: function (d) {
                    var index="";
                    if(d.order_modify_at==""){
                        index="----";
                    }else {
                        var index = formatDateTime(d.order_create_time*1000);
                    }
                    return index;
                    }
                }
                , {field: 'order_pay_time', width: 180, title: '支付时间',align:'center',templet: function (d) {
                    var index="";
                    if(d.order_pay_time==""){
                        index="----";
                    }else {
                        var index = formatDateTime(d.order_pay_time*1000);
                    }
                    return index;
                    }
                }
                , {field: 'order_receive_time', width: 180, title: '订单确认签收时间',align:'center',templet: function (d) {
                    var index="";
                    if(d.order_receive_time==""){
                        index="----";
                    }else {
                        var index = formatDateTime(d.order_receive_time*1000);
                    }
                    return index;
                    }
                }
            ]]
            , id: 'testReload'
            , page: true
            , limit: 100
            , limits: [50,100, 500, 1000]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            },
        });

        //点击按钮 搜索
        $('#sreachBtn').on('click', function(){

            var order_sn = $('#order_sn').val();
            var goods_id = $('#goods_id').val();
            var goods_name = $('#goods_name').val();
            var order_status = $('#order_status').val();
            var custom_parameters = $('#custom_parameters').val();

            table.reload('testReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    order_sn: order_sn,
                    goods_id: goods_id,
                    goods_name: goods_name,
                    order_status:order_status,
                    custom_parameters:custom_parameters
                }
            });
            return false;
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

    function formatDateTime(inputTime) {
        var date = new Date(inputTime);
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        m = m < 10 ? ('0' + m) : m;
        var d = date.getDate();
        d = d < 10 ? ('0' + d) : d;
        var h = date.getHours();
        h = h < 10 ? ('0' + h) : h;
        var minute = date.getMinutes();
        var second = date.getSeconds();
        minute = minute < 10 ? ('0' + minute) : minute;
        second = second < 10 ? ('0' + second) : second;
        return y + '-' + m + '-' + d+' '+h+':'+minute+':'+second;
    };



</script>

<script type="text/html" id="orderStatus">
    {{# if(d.order_status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.order_status =='-1'){}}
    <%--未支付--%>
    待付款
    {{# }else if(d.order_status =='0'){ }}
    <%--已支付--%>
    待收货
    {{# }else if(d.order_status =='1'){ }}
    <%--已成团--%>
    待收货
    {{# }else if(d.order_status =='2'){ }}
    <%--确认收货--%>
    已完成
    <%--{{# }else if(d.order_status =='3'){ }}--%>
    <%--审核成功--%>
    <%--{{# }else if(d.order_status =='4'){ }}--%>
    <%--审核失败--%>
    <%--{{# }else if(d.order_status =='5'){ }}--%>
    <%--已经结算--%>
    <%--{{# }else if(d.order_status =='8'){ }}--%>
    <%--非多多金宝商品--%>
    <%--{{# }else if(d.order_status =='10'){ }}--%>
    <%--已处罚--%>
    {{# } }}
    {{# } }}
</script>

<script type="text/html" id="orderType">
    {{# if(d.type ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.type =='0'){}}
    单品推广
    {{# }else if(d.type =='1'){ }}
    红包活动推广
    {{# }else if(d.type =='2'){ }}
    领券页底部推荐
    {{# } }}
    {{# } }}
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            拼多多订单列表
        </div>

        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">订单编号：</label>
                    <div class="layui-input-inline">
                        <input type="text" name="order_sn" id="order_sn" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label">商品ID：</label>
                    <div class="layui-input-inline">
                        <input type="text" name="goods_id" id="goods_id" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label">商品名称：</label>
                    <div class="layui-input-inline">
                        <input type="text" name="goods_name" id="goods_name" autocomplete="off"
                               class="layui-input">
                    </div>

                </div>


                <div class="layui-form-item" style="margin-bottom:5px">
                    <label class="layui-form-label">订单状态：</label>
                    <div class="layui-input-inline" >
                        <select id="order_status" name="order_status">
                            <option value="">全部</option>
                            <option value="-1">待付款</option>
                            <option value="0">待收货</option>
                            <%--<option value="1">已成团</option>--%>
                            <option value="2">已完成</option>
                            <%--<option value="3">审核成功</option>--%>
                            <%--<option value="4">审核失败</option>--%>
                            <%--<option value="5">已经结算</option>--%>
                            <%--<option value="8">非多多进宝商品</option>--%>
                            <%--<option value="10">已处罚</option>--%>
                        </select>
                    </div>

                    <label class="layui-form-label">手机号：</label>
                    <div class="layui-input-inline">
                        <input type="text" name="custom_parameters" id="custom_parameters" autocomplete="off"
                               class="layui-input">
                    </div>

                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" id="sreachBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>

                </div>



            </div>

        </form>

        <!-- 表格显示-->
        <table class="layui-hide" id="pddOrderList" lay-filter="pddOrderList"></table>

    </div>

</div>
<%@ include file="/common/footer.jsp"%>
