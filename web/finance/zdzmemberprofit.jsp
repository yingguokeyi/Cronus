<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../common/header.jsp" %>
<%@include file="menu_finance.jsp" %>

<script>
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var element = layui.element;
        table.render({
            elem: '#orderList'
            , height: 710
            , url: '${ctx}/finance?method=userWallet'
            , cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                ,{type: 'checkbox', fixed: 'left', field: "id"}
                , {field: 'phone', width: 200, title: '注册手机号',align:'center',templet: '#phoneTpl'}
                , {field: 'member_level', width: 200, title: '会员类型',align:'center', templet: '#member_level'}
                , {field: 'money', width: 200, title: '可提现账户总金额（元）',align:'center',templet: function (d) {
                        var num = "";
                        if (Number(d.money) == '') {
                            num = 0;
                        } else {
                            num = Number((d.money / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }}
                , {field: 'totalPreIncome', width: 200, title: '当前预估总金额（元）',align:'center',templet: function (d) {
                        var num = "";
                        if (Number(d.totalPreIncome) == '') {
                            num = 0;
                        } else {
                            num = Number((d.totalPreIncome / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }}
                , {field: 'zdz_money', width: 200, title: '当前实际收益（元）',align:'center',templet: function (d) {
                        var num = "";
                        if (Number(d.zdz_money) == '') {
                            num = 0;
                        } else {
                            num = Number((d.zdz_money / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }}
                , {field: 'operation_time', width: 200, title: '最后统计时间',align:'center',templet: '#create_timeTpl'}
                , {field: 'wealth', width: 260, fixed: 'right', align: 'center', title: '操作', toolbar: "#operation"}
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

        //点击按钮 搜索商品
        $('#searchBtn').on('click', function () {
            var phone = $('#phone');
            var price_min= $('#price_min');
            var price_max= $('#price_max');
            table.reload('testReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    phone: phone.val(),
                    price_min:price_min.val(),
                    price_max:price_max.val()
                }
            });
            return false;
        });

        table.on('tool(orderlist)', function (obj) {
            if (obj.event === 'memberProfit') {
                    console.log("  obj.data.pur_id   " + obj.data.user_id)
                    //return false;
                    window.location.href = "zdzuserprofit.jsp?user_id=" + obj.data.user_id;

            }
        });
    });


</script>
<script id="create_timeTpl" type="text/html">
    {{#  if(d.operation_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.operation_time.substr(0,2) }}-{{ d.operation_time.substr(2,2) }}-{{ d.operation_time.substr(4,2) }} {{ d.operation_time.substr(6,2) }}:{{ d.operation_time.substr(8,2) }}:{{ d.operation_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>

<script type="text/html" id="phoneTpl">
    {{# if(d.phone ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.phone}}
    {{# } }}
</script>

<script type="text/html" id="status">
    {{# if(d.status == 1){}}
    未完成
    {{# }else if(d.status == 2){}}
    已完成
    {{#  } }}
</script>
<script type="text/html" id="member_level">
    {{# if(d.member_level == 1){}}
    会员
    {{# }else if(d.member_level == 0){}}
    非会员
    {{#  } }}
</script>
<script type="text/html" id="memberSelfMoney">
￥{{d.member_self_money/100}}
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

<script type="text/html" id="operation">

    <a  lay-event="memberProfit" style="color: blue">查看个人收益</a>

</script>
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">掌小龙会员收益列表</div>
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">
                    <label class="layui-form-label">注册手机号</label>
                    <div class="layui-input-inline">
                        <input autocomplete="off" class="layui-input" type="text" name="phone" id="phone">
                    </div>

                    <label class="layui-form-label" style="width: 150px">最后统计日期</label>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input lay-verify="date" name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input lay-verify="date" name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <button id="searchBtn"  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset"><i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </div>
        </form>
        <%--<div style="margin-top: 5px">
            <button id="exportSearch" onclick="exportOrder()" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe67c;</i>导出</button>
        </div>--%>
        <table class="layui-table" id="orderList" lay-filter="orderlist"></table>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>