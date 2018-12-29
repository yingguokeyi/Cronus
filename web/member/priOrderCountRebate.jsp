<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/header.jsp"%>
<%@include file="member_menu.jsp"%>
<script>
    layui.use(['laydate', 'layer', 'table', 'element'], function(){
        var table = layui.table;
        var laydate = layui.laydate; //日期
        var element = layui.element;
        //列表加载
        var tableIns = table.render({
            elem: '#OrderCountRebateList'
            ,url:'${ctx}/orderCountRebate?method=getOrderCountRebateInfo'
            ,limit:20
            ,limits:[20,50,100]
            ,height: 640
            ,cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                ,{field:'order_no', width:200, title: '订单编号',align:'center',fixed: 'left'}
                ,{field:'rebate_userName', width:150, title: '返佣用户名',align:'center',fixed: 'left'}
                ,{field:'nick_name', width:150, title: '下单用户名',align:'center',fixed: 'left'}
                ,{field:'member_level', width:150, title: '用户类型',align:'center',fixed: 'left',templet:'#certification_type'}

                ,{field:'member_top', width:150, title: '奖金',align:'center' ,templet:'#top'}
                ,{field:'member_parent', width:150, title: '佣金',align:'center' , templet:'#parent'}
                ,{field:'member_self', width:150, title: '返现',align:'center' , templet:'#self'}

                ,{field:'spu_name', width:400, title: '商品名称',align:'center', templet: '#goodsNameTpl'}
                ,{field:'sku_num', width:150, title: '购买商品数量',align:'center'}

                ,{field:'phoneNum', width:150, title: '注册手机号',align:'center'}
                ,{field:'create_time', width:200, title: '下单时间',align:'center',templet: '#create_timeTpl'}
                ,{field:'payment_way_key', width:100, title: '支付方式',align:'center',templet: '#p_way_key'}
                ,{field:'order_source', width:150, title: '订单来源',align:'center',templet: '#o_source'}
                ,{field:'source_name', width:100, title: '商品来源',align:'center'}
               /* ,{field:'incomeNum', width:100, title: '订单受益人数',align:'center'}*/
                ,{fixed:'right',title:'操作', width:150,align:'center',toolbar:"#OrderCountRebateManage"}
            ]]
            ,id:'priOrderCountRebateInfoReload'
            ,page:true//关闭自动分页
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            },
        });

        $('#searchBtn').on('click', function () {
            var order_no = $('#order_no');
            var nick_name = $('#nick_name');
            var phoneNum = $('#phoneNum');
            var rebate_userName = $('#rebate_userName');
            var countRebateType = $('#countRebateType');
            var order_source = $('#order_source');
            /*var created_date = $('#created_date');*/
            var price_min= $('#price_min').val();
            var price_max= $('#price_max').val();
            //执行重载
            tableIns.reload({
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    order_no: order_no.val(),
                    nick_name: nick_name.val(),
                    // 下单用户
                    phoneNum: phoneNum.val(),
                    rebate_userName:rebate_userName.val(),
                    countRebateType:countRebateType.val(),
                    order_source: order_source.val(),
                    /*created_date: created_date.val()*/
                    price_min: price_min,
                    price_max: price_max

                }
            });
            return false;
        });

        //监听工具条
        table.on('tool(OrderCountRebateFilter)', function(obj){
            console.log("    obj   "+obj)
            var data = obj.data;
            if(obj.event === 'orderDetailInfo'){
                // layer.msg('本版本上不支持');
                orderDetailInfo(data)
            }else if(obj.event === 'PurchaseUserInfo'){
                PurchaseUserInfo(data)
            }else if(obj.event === 'RebateUserInfo'){
                RebateUserInfo(data)
            }
        });

        function orderDetailInfo(obj){
            var order_no="";
            var order_type="";
            var status="";
            layer.open({
                type: 2,
                title: '订单详情',
                shadeClose: true,
                area: ['900px', '85%'],
                content: ['../order/orderDetails.jsp', 'no'],
                yes:function(id){

                }
                ,success: function(layero, index){
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/order?method=getLineItemByOrderId",
                        data:{'id':obj.id} ,   //批量处理 status=2 移入回收站
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var array = data.result.rs;

                                for (var obj in array) {
                                    body.contents().find("#order_no").text(array[obj].order_no);
                                    body.contents().find("#order_type").text(array[obj].order_type);
                                    body.contents().find("#status").text(array[obj].status);
                                    body.contents().find("#payment_way_key").text(array[obj].payment_way_key);

                                    body.contents().find("#market_price").text((array[obj].market_price/100).toFixed(2));
                                    body.contents().find("#total_price").text((array[obj].total_price/100).toFixed(2));
                                    body.contents().find("#member_self").text((array[obj].member_self/100).toFixed(2));
                                    body.contents().find("#backMoney").text((array[obj].backMoney/10000).toFixed(2));
                                    body.contents().find("#amount").text("￥"+array[obj].amount+".00");


                                    body.contents().find('#amount').text(array[obj].amount/100);
                                    // alert(body.contents().find("#amount"));

                                    body.contents().find("#money").text("￥"+array[obj].money+".00");
                                    body.contents().find("#consignee").text(array[obj].consignee);

                                    body.contents().find("#delivery_address").text(array[obj].delivery_address);
                                    body.contents().find("#consignee_tel").text(array[obj].consignee_tel);
                                    body.contents().find("#logistics_status").text(array[obj].logistics_status);
                                    body.contents().find("#logistics_numbers").text(array[obj].logistics_numbers);
                                    body.contents().find("#edit_user").text(array[obj].edit_user);
                                    body.contents().find("#edit_time").text(array[obj].edit_time);
                                    body.contents().find("#orderInfoGeneral").text(array[obj].orderInfoGeneral);
                                    break;
                                }

                            }
                            else {
                                layer.msg("异常");
                            }
                        },
                        error : function() {
                            layer.alert("错误");
                        }
                    });
                    <%--$.ajax({--%>
                        <%--type: "get",--%>
                        <%--async : false, // 同步请求--%>
                        <%--cache :true,// 不使用ajax缓存--%>
                        <%--contentType : "application/json",--%>
                        <%--url : "${ctx}/order?method=getGoodsByOrderId",--%>
                        <%--data:{'id':obj.id} ,--%>
                        <%--dataType : "json",--%>
                        <%--success : function(data){--%>
                            <%--var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦--%>
                            <%--if (data.success == 1) {--%>
                                <%--var array= data.rs;--%>
                                <%--for (var obj in array) {--%>
                                    <%--body.contents().find("#order_no").text(array[obj].order_no);--%>
                                    <%--body.contents().find("#order_type").text(array[obj].order_type);--%>
                                    <%--body.contents().find("#status").text(array[obj].status);--%>
                                    <%--body.contents().find("#data_source").text(array[obj].data_source);--%>
                                    <%--body.contents().find("#spu_code").text(array[obj].spu_code);--%>
                                    <%--body.contents().find("#spu_name").text(array[obj].spu_name);--%>
                                    <%--body.contents().find("#sku_num").text(array[obj].sku_num);--%>
                                    <%--body.contents().find("#detail_img_ids").text(array[obj].detail_img_ids);--%>
                                    <%--body.contents().find("#original_price").text("￥"+array[obj].original_price+".00");--%>
                                    <%--body.contents().find("#market_price").text("￥"+array[obj].market_price+".00");--%>
                                    <%--body.contents().find("#classifyAtairName").text(array[obj].classifyAtairName);--%>
                                    <%--body.contents().find("#stock").text(array[obj].stock);--%>
                                    <%--body.contents().find("#goodsInfoDetailList").text(array[obj].order_no);--%>
                                    <%--break;--%>
                                <%--}--%>
                            <%--}--%>
                            <%--else {--%>
                                <%--layer.msg("异常");--%>
                            <%--}--%>
                        <%--},--%>
                        <%--error : function() {--%>
                            <%--layer.alert("错误");--%>
                        <%--}--%>
                    <%--});--%>
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/order?method=getProStatus",
                        data:{'id':obj.id} ,
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var array= data.rs;
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
                        error : function() {
                            layer.alert("错误");
                        }
                    });

                }

            });
        }

        function PurchaseUserInfo(obj){
            layer.open({
                type: 1
                ,content: $('#PurchaseUserInfoDiv')
                ,btn: ['关闭']
                ,area: ['600px', '350px']
                ,btnAlign: 'r' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(index){
                    layer.closeAll();
                }
                ,success: function(layero, index){
                    $("#Purchase_nick_nameLabl").text(obj.nick_name);
                    $("#Purchase_order_numLabl").text(obj.order_no);

                    // $("#nick_nameLabl").val(obj.nick_name);
                    // $("#order_numLabl").val(obj.order_no);
                    table.render({
                        elem: '#PurchaseUserInfoTab'
                        ,url:'${ctx}/orderCountRebate?method=getPurchaseUserInfo'
                        ,response: {
                            statusName: 'success' //数据状态的字段名称，默认：code
                            ,statusCode: 1  //成功的状态码，默认：0
                            ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                            ,countName: 'total' //数据总数的字段名称，默认：count
                            ,dataName: 'rs' //数据列表的字段名称，默认：data
                        }
                        ,cols: [[
                            {type:'numbers',fixed: 'true',align:'center'}
                            ,{field:'nick_name', width:150, title: '用户名称',align:'center',fixed: 'left'}
                            ,{field:'level_typle', width:150, title: '返佣关系',align:'center'}
                            ,{field:'num', width:150, title: '总返佣金额',align:'center'}
                        ]]
                        ,where:{
                            order_id: obj.id
                        }
                    });
                }
            });
        }

        function RebateUserInfo(obj){
            layer.open({
                type: 1
                ,content: $('#RebateUserInfoDiv')
                ,btn: ['关闭']
                ,area: ['600px', '350px']
                ,btnAlign: 'r' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(index){
                    layer.closeAll();
                }
                ,success: function(layero, index){
                    var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                    body.contents().find("#nick_nameLabl").text(obj.nick_name);
                    body.contents().find("#order_numLabl").text(obj.order_no);

                    // $("#nick_nameLabl").val(obj.nick_name);
                    // $("#order_numLabl").val(obj.order_no);
                    table.render({
                        elem: '#RebateUserInfoTab'
                        ,width:500
                        ,url:'${ctx}/orderCountRebate?method=getRebateUserInfo'
                        ,response: {
                            statusName: 'success' //数据状态的字段名称，默认：code
                            ,statusCode: 1  //成功的状态码，默认：0
                            ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                            ,countName: 'total' //数据总数的字段名称，默认：count
                            ,dataName: 'rs' //数据列表的字段名称，默认：data
                        }
                        ,cols: [[
                            {type:'numbers',fixed: 'true',align:'center'}
                            ,{field:'nick_name', width:155, title: '用户名称',align:'center',fixed: 'left'}
                            ,{field:'level_typle', width:150, title: '返佣关系',align:'center'}
                            ,{field:'num', width:150, title: '总返佣金额',align:'center'}
                        ]]
                        ,where:{
                            order_id: obj.id
                        }
                    });
                }
            });
        }


    });
    layui.use('laydate', function(){
        var laydate = layui.laydate;
        //时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });

    });

</script>
<script type="text/html" id="p_way_key">
    {{# if(d.payment_way_key=='WetCat'){}}
    <span>微信</span>
    {{# } }}
</script>
<script type="text/html" id="o_source">
    {{# if(d.order_source=='miniWetCat'){}}
    <span>微信</span>
    {{# } }}
</script>
<script type="text/html" id="certification_type">
    {{# if(d.member_level=='0'){}}
    <span style="color:#FF0000; ">非会员</span>

    {{# }else if(d.member_level=='1'){ }}
    <span style="color:green; ">会员</span>
    {{# } }}
</script>

<script id="create_timeTpl" type="text/html">
    {{#  if(d.create_time !== ''){ }}
    <%--<span style="color: rgba(10,10,10,0.46);">{{ d.registration_time.substr(0,2) }}</span>--%>
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_time.substr(0,2) }}-{{ d.create_time.substr(2,2) }}-{{ d.create_time.substr(4,2) }} {{ d.create_time.substr(6,2) }}:{{ d.create_time.substr(8,2) }}:{{ d.create_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>

<script id="top" type="text/html">
    ￥{{(d.member_top/10000).toFixed(2)}}
</script>
<script id="parent" type="text/html">
    ￥{{(d.member_parent/10000).toFixed(2)}}
</script>
<script id="self" type="text/html">
    ￥{{(d.member_self/10000).toFixed(2)}}
</script>


<script id="goodsNameTpl" type="text/html">
    {{#  if(d.spu_name !== '' && d.sku_name !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">{{ d.spu_name }}_{{ d.sku_name }}</span>
    {{#  } else if(d.spu_name !== '' && d.sku_name === ''){ }}
    <span style="color: rgba(10,10,10,0.46);">{{ d.spu_name }}</span>
    {{#  } }}
</script>
<script type="text/html" id="OrderCountRebateManage">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo" >订单详情</a>
    <%--<a class="layui-btn layui-btn-primary layui-btn-normal" lay-event="PurchaseUserInfo" >自购用户信息</a>--%>
    <%--<a class="layui-btn layui-btn-primary layui-btn-normal" lay-event="RebateUserInfo" >返佣用户信息</a>--%>
    <%--<a class="layui-btn layui-btn-mini" lay-event="selOrderInfo" >查看原始订单</a>--%>
</script>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 20px;">
        <div class="layui-row">
            <blockquote  class="layui-elem-quote" style="margin-top: -10px">
                订单返佣统计
            </blockquote>
            <form class="layui-form layui-form-pane">
                <div style="background-color:#f2f2f2;padding: 15px;">

                    <div class="layui-form-item" style="margin-bottom:5px">

                        <label class="layui-form-label">订单编号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="order_no" id="order_no">
                        </div>

                        <label class="layui-form-label ">下单用户：</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="nick_name" id="nick_name">
                        </div>

                        <label class="layui-form-label"> 注册手机：</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="phoneNum" id="phoneNum"  autocomplete="off">
                        </div>

                        <label  class="layui-form-label">返佣用户：</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" name="rebate_userName" id="rebate_userName"  autocomplete="off">
                        </div>

                    </div>

                    <div class="layui-form-item">
                       <%-- <label class="layui-form-label"  >返现类型：</label>
                        <div class="layui-input-inline" style="width: 190px">
                            <select class="layui-select" style="width: 170px" name="countRebateType" id="countRebateType" autocomplete="off">
                                <option value="0" selected="selected">全部</option>
                                <option value="佣金">佣金</option>
                                <option value="奖金">奖金</option>
                                <option value="自购">自购</option>
                            </select>
                        </div>--%>

                        <label class="layui-form-label">订单来源：</label>
                        <div class="layui-input-inline" >
                            <select class="layui-select" style="width: 185px;margin-left: 15px" name="order_source" id="order_source" autocomplete="off">
                                <option value="0" selected="selected">全部</option>
                                <option value="APP">APP</option>
                                <option value="miniWetCat">小程序</option>
                            </select>
                        </div>

                        <label class="layui-form-label" >成交日期：</label>
                        <div class="layui-inline">
                            <div class="layui-input-inline" style="width: 150px;">
                                <input name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                            </div>
                            <div class="layui-form-mid">-</div>
                            <div class="layui-input-inline" style="width: 150px;">
                                <input name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                            </div>
                        </div>

                        <button class="layui-btn layui-btn-sm" style="margin-left: 10px" data-type="sreach" id="searchBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button class="layui-btn layui-btn-sm" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>

                </div>
            </form>
        </div>

        <table class="layui-table"  id="OrderCountRebateList"  lay-filter="OrderCountRebateFilter"></table>
    </div>
</div>
<!-- 自购用户的订单详情 -->
<div class="layui-layer-iframe" id="PurchaseUserInfoDiv" style="display: none" >
    <div class="layui-elem-quote" style="margin-left: 20px">
        【<label id="Purchase_nick_nameLabl"></label>】订单号：<label id="Purchase_order_numLabl"></label>
    </div>
    <div style="margin-left: 20px">
        <label>当前位置：分销系统 >  返佣统计列表  > 自购用户的订单详情</label>
    </div>
    <hr class="layui-bg-gray">
    <div style="margin-left: 30px; width: 500px">
        <table class="layui-table"  id="PurchaseUserInfoTab" lay-filter="PurchaseUserInfoTabFilter"></table>
    </div>
</div>

<!-- 返佣用户的订单详情 -->
<div class="layui-layer-iframe" id="RebateUserInfoDiv" style="display: none">
    <div class="layui-elem-quote" style="margin-left: 20px">
        <label id="Rebate_nick_nameLabl"></label>订单号<label id="Rebate_order_numLabl"></label>
    </div>
    <div style="margin-left: 20px">
        <label>当前位置：分销系统 >  返佣统计列表  > 自购用户的订单详情</label>
    </div>
    <hr class="layui-bg-gray">
    <div style="margin-left: 30px; width: 500px">
        <table class="layui-table" id="RebateUserInfoTab" lay-filter="RebateUserInfoTabFilter"></table>
    </div>
</div>

<div class="layui-footer">
    <%@ include file="/common/footer.jsp"%>
</div>