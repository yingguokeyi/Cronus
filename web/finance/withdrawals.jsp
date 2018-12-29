<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../common/header.jsp" %>
<%@include file="menu_finance.jsp" %>

<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
        <div class="layui-row">
            <div class="layui-elem-quote" style="margin-top: 3px;background-color: #EEEEEE">
                <label>提现管理</label>
            </div>

            <form class="layui-form layui-form-pane">
                <div class="layui-elem-quote"
                     style="margin-top: 10px;background-color: #EEEEEE;margin-top: 10px;height: 30px">

                    <div class="layui-inline">
                        <label class="layui-form-label">申请日期</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test5" placeholder="请输入开始时间">
                        </div>
                        <span style="line-height:40px;">~</span>
                    </div>

                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test6" placeholder="请输入结束时间">
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">手机号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="phone" autocomplete="off" class="layui-input" placeholder="请输入手机号">
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">处理状态</label>
                        <div class="layui-input-inline">
                            <select class="layui-select" id="status" autocomplete="off">
                                <option value="" selected="selected">全部</option>
                                <option value="1">未处理</option>
                                <option value="2">已同意</option>
                                <option value="3">已拒绝</option>
                                <%--<option value="4">已作废</option>--%>
                                <option value="5">成功提现</option>
                                <option value="6">提现失败</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-elem-quote"
                     style="margin-top: 10px;background-color: #EEEEEE;margin-top: 10px;height: 30px">
                    <div class="layui-inline">
                        <label class="layui-form-label">处理日期</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test7" placeholder="请输入开始时间">
                        </div>
                        <span style="line-height:40px;">~</span>
                    </div>

                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test8" placeholder="请输入结束时间">
                        </div>
                    </div>


                        <button class="layui-btn layui-btn-sm" style="margin-left:10px;" id="searchBtn"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置</button>

                </div>

            </form>
            <div style="margin-top: 5px">
                <button id="status_agree" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>批量同意</button>
                <button id="status_refuse" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>批量拒绝</button>
                <%--<button id="status_nullify" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>批量作废</button>--%>
            </div>

            <table class="layui-table" id="withdrawalsList" lay-filter="withdrawals"></table>
        </div>
    </div>




<%@ include file="/common/footer.jsp" %>


<%--<script type="text/html" id="barDemo">--%>
    <%--<button lay-event="agree"--%>
            <%--style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">--%>
        <%--同意--%>
    <%--</button>--%>
    <%--<button lay-event="refuse"--%>
            <%--style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">--%>
        <%--拒绝--%>
    <%--</button>--%>
    <%--<button lay-event="abolish"--%>
            <%--style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">--%>
        <%--作废--%>
    <%--</button>--%>
    <%--<button lay-event="detail"--%>
            <%--style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">--%>
        <%--详情--%>
    <%--</button>--%>
<%--</script>--%>

<script>
    layui.use('table', function () {
        var table = layui.table;
        var form = layui.form;
        //列表加载
        table.render({
            elem: '#withdrawalsList'
            , url: '${ctx}/finance?method=Withdraw' //数据接口
            , cellMinWidth: 100 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , page: true
            //,height: 650
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , cols: [[
                {type: 'numbers', fixed: 'true'}
                , {type: 'checkbox', fixed: 'true'}
                , {field: 'nick_name', title: '姓名', align: 'center', width: '150', sort: true, fixed: true}
//                , {field: 'user_id', title: '用户id', align: 'center', width: '80', sort: true, fixed: true}
                , {field: 'phone', title: '手机号', sort: true, width: '150',align: 'center', fixed: true}
                , {
                    field: 'money', title: '可提现账户总金额(元)', align: 'center', width: '170', templet: function (d) {
                        var num = "";
                        if (Number(d.money) == '') {
                            num = 0;
                        } else {
                            num = Number((d.money / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }
                }
                , {
                    field: 'totalPreIncome', title: '当前预估总金额（元）', width: 170, templet: function (d) {
                        var num = "";
                        if (Number(d.totalPreIncome) == '') {
                            num = 0;
                        } else {
                            num = Number((d.totalPreIncome / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }
                }
                ,{field:'edit_time', width:180, title: '最后编辑时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'create_time', width:180, title: '申请时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.create_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.create_time.substr(0, 2) + "-" + d.create_time.substr(2, 2) + "-" + d.create_time.substr(4, 2) + " " + d.create_time.substr(6, 2) + ":" + d.create_time.substr(8, 2) + ":" + d.create_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field: 'amount',title: '申请提现金额(元)',align: 'center',width: 170,templet: function (d) {
                    var num = Number((d.amount / 100).toFixed(2));
                    return '￥' + num;
                }
                }
                , {field: 'status', title: '处理状态', sort: true, align: 'center', templet: '#statu'}
                , {field: 'withdrawals_on', title: '提现单号', align: 'center', sort: true, width: '150'}
                , {field: 'withdrawals_way_key', title: '打款方式', align: 'center', sort: true, templet: '#withdrawals_way_key'}
                , {field: 'remarks', title: '决绝原因', align: 'center', sort: true, width: '150'}
                , {fixed: 'right', title: '操作', width: 250, align: 'center', toolbar: "#barDemo"}
            ]]
            , id: 'listTable'

        });

        var $ = layui.$, active = {};

        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        //点击按钮 搜索
        $('#searchBtn').on('click', function () {

            //执行重载
            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    nick_name: $('#name').val(),
                    phone: $('#phone').val(),
                    test5: $('#test5').val(),
                    test6: $('#test6').val(),
                    test7: $('#test7').val(),
                    test8: $('#test8').val(),
                    status: $('#status').val(),
                }
            });
            return false;
        });
        //监听工具条
        table.on('tool(withdrawals)', function (obj) {
            var data = obj.data;
            if (obj.event === 'agree') {
                agree(data)
            } else if (obj.event === 'refuse') {
                refuse(data)
            } else if (obj.event === 'abolish') {
                layer.confirm('确认作废吗？', function (obj) {
                    abolish(data);

                });
            } else if (obj.event === 'detail') {

                window.location.href = 'withdrawalsDetailInfo.jsp?user_id=' + data.user_id + '&id=' + data.id;
            }
        });

        function agree(obj) {
            layer.open({
                type: 1
                , title: '提现确认'
                , area: ['390px', '260px']
                , content: '<ul class=""  lay-filter="test">'
                + '<li class="layui-nav-item"><a>&nbsp;提现单号:' + obj.withdrawals_on + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现金额:' + obj.amount/100 + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现方式:' + '微信' + '</a></li>'
                + '<li class="layui-nav-item"><hr class="layui-bg-gray"></li>'
                + '<li class="layui-nav-item"><a>确认后，提现金额将自动转入会员账户</a></li></ul>'
                , btn: '确认'
                , btnAlign: 'c' //按钮居中
                , shade: 0 //不显示遮罩
                , yes: function () {
                    var id = obj.id;
                    var order_id = obj.order_id;
                    $.ajax({
                        //几个参数需要注意一下
                        type: "post",//方法类型
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/finance?method=Agreerequest",//url
                        async: true,
                        data: {id: id},
                        success: function (res) {
                            var obj = JSON.parse(JSON.stringify(res));
                            if (obj.success == 1) {
                                layer.msg('操作成功', {time: 1000}, function () {
                                    window.location.reload();
                                });
                            }
                        },
                        error: function () {
                            layer.msg("异常");;

                        },
                    });
                    return false;
                }
            });
        }

        function refuse(obj) {
            layer.open({
                type: 1
                , title: '拒绝提现确认'
                , area: ['390px', '260px']
                , content: '<ul class=""  lay-filter="test">'
                + '<li class="layui-nav-item"><a>&nbsp;提现单号:' + obj.withdrawals_on + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现金额:' + obj.amount/100 + '</a></li>'
                + '<li class="layui-nav-item"><a>&nbsp;提现方式:' + '微信' + '</a></li>'
                + '<li class="layui-nav-item"><hr class="layui-bg-gray"></li>'
                + '<li class="layui-nav-item"><a>备注:</a><textarea id="remarks"></textarea></li>'
                + '</ul>'
                , btn: '确认'
                , btnAlign: 'c' //按钮居中
                , titAlign: 'c'
                , shade: 0 //不显示遮罩
                , yes: function () {
                    var id = obj.id;
                    var remarks = $('#remarks').val();

                    $.ajax({
                        //几个参数需要注意一下
                        type: "post",//方法类型
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/finance?method=Rejectrequest",//url
                        async: true,
                        data: {id: obj.id, remarks: remarks},
                        success: function (res) {
                            var obj = JSON.parse(JSON.stringify(res));
                            if (obj.success == 1) {
                                layer.msg('操作成功', {time: 1000}, function () {
                                    window.location.reload();
                                });

                            }
                        },
                        error: function () {
                            layer.msg("异常");
                        },
                    });


                }
            });
        }

        function abolish(obj) {
            var id = obj.id;
            $.ajax({
                //几个参数需要注意一下
                type: "post",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                <%--url: "${ctx}/finance?method=abolishquest",//url--%>
                async: true,
                data: {id: id},
                success: function (res) {
                    var obj = JSON.parse(JSON.stringify(res));
                    if (obj.success == 1) {
                        layer.msg('操作成功', {time: 1000}, function () {
                            window.location.reload();
                        });
                    }
                },
                error: function () {
                    layer.msg("异常");
                },
            });
            return false;


        }

//        table.on('tool(withdrawalsList)', function (obj) {
//            if (obj.event === 'edit') {
//
//                window.location.href = 'withdrawalsDetailInfo.jsp?user_id=' + obj.user_id + '&id=' + obj.id;
//
//            }
//        });

        //批量同意
        $('#status_agree').on('click', function(){
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定批量同意吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        if(checkStatus.data[i].status != 1){
                            layer.msg("已经操作过了！");
                            return false;
                        }
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/finance",
                        data: "method=updateWithdrawalsStatus&remarks=&status=2&ids=" + ids,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("listTable");
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    });
                });
            }
            return false;
        });

        //批量拒绝
        $('#status_refuse').on('click', function(){
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定批量拒绝吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        if(checkStatus.data[i].status != 1){
                            layer.msg("已经操作过了！");
                            return false;
                        }
                        ids[i] = checkStatus.data[i].id;
                    }

                    layer.open({
                        type: 1
                        , title: '拒绝提现确认'
                        , area: ['390px', '260px']
                        , content: '<ul class=""  lay-filter="test">'
                        + '<li class="layui-nav-item"><a>备注:</a><textarea id="remark"></textarea></li>'
                        + '</ul>'
                        , btn: '确认'
                        , btnAlign: 'c' //按钮居中
                        , titAlign: 'c'
                        , shade: 0 //不显示遮罩
                        , yes: function () {
                            var remarks = $('#remark').val();
                            $.ajax({
                                //几个参数需要注意一下
                                type: "post",//方法类型
                                dataType: "json",//预期服务器返回的数据类型
                                url: "${ctx}/finance",
                                data: "method=updateWithdrawalsStatus&remarks="+remarks+"&status=3&ids=" + ids,
                                async: false,
                                cache: true,
                                dataType: "json",
                                success: function (data) {
                                    if (data.success) {
                                        layer.msg('操作成功', {time: 1000}, function () {
                                            window.location.reload();
                                        });
                                    } else {
                                        layer.msg("异常");
                                    }
                                },
                                error: function () {
                                    layer.alert("错误");
                                }
                            });


                        }
                    });
                });
            }
            return false;
        });
        //批量作废
        $('#status_nullify').on('click', function(){
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定批量作废吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        if(checkStatus.data[i].status != 1){
                            layer.msg("已经操作过了！");
                            return false;
                        }
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/finance",
                        data: "method=updateWithdrawalsStatus&remarks=&status=4&ids=" + ids,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("listTable");
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    });
                });
            }
            return false;
        });
    });
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#price_min'
        });
        laydate.render({
            elem: '#price_max'
        });
    });

    layui.use('element', function () {
        var element = layui.element;
    });

</script>
<script>
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //时间选择器
        laydate.render({
            elem: '#test5'
            , type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#test6'
            , type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#test7'
            , type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#test8'
            , type: 'datetime'
        });
    })
</script>
<script type="text/html" id="barDemo">
    {{#  if(d.status != '1'){ }}
    <a  style="color: grey">同意</a>
    <a  style="color: grey">拒绝</a>
    <%--<a  style="color: grey">作废</a>--%>
    <a  lay-event="detail" style="color: blue">详情</a>
    {{#  } else if(d.status == '1') { }}
    <a  lay-event="agree" style="color: blue">同意</a>
    <a  lay-event="refuse" style="color: blue">拒绝</a>
    <%--<a  lay-event="abolish" style="color: blue">作废</a>--%>
    <a  lay-event="detail" style="color: blue">详情</a>
    {{#  } }}
</script>
<script type="text/html" id="statu">

    {{# if(d.status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.status =='1'){}}
    <span style="color:#FF0000; ">未处理</span>
    {{# }else if(d.status =='2'){ }}
    已同意
    {{# }else if(d.status =='3'){ }}
    已拒绝
    {{# }else if(d.status =='4'){ }}
    已作废
    {{# }else if(d.status =='5'){ }}
    已提现
    {{# }else if(d.status =='6'){ }}
    提现失败
    {{# } }}
    {{# } }}
</script>

<script type="text/html" id="withdrawals_way_key">

    {{# if(d.withdrawals_way_key ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.withdrawals_way_key =='1'){}}
    微信钱包
    {{# }else if(d.withdrawals_way_key =='2'){ }}
    银行卡
    {{# }else if(d.withdrawals_way_key =='3'){ }}
    其他
    {{# } }}
    {{# } }}
</script>