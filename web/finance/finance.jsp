<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@include file="menu_finance.jsp" %>

<head>
    <title>认证审核 </title>
    <script>
        //JavaScript代码区域
        layui.use(['element', 'laydate', 'layer'], function () {
            var element = layui.element;
            var $ = layui.jquery, layer = layui.layer;

            $('#layerDemo').on('click', function () {
                var othis = $(this), method = othis.data('method');
                active[method] ? active[method].call(this, othis) : '';
            });
            var laydate = layui.laydate;
            laydate.render({
                elem: '#test5'
                , type: 'datetime'
            });
            laydate.render({
                elem: '#test6'
                , type: 'datetime'
            });

        });

        layui.use('table', function () {
            var table = layui.table;

            table.render({
                elem: '#test'
                , url: '${ctx}/finance?method=Commissio' //数据接口
                , height: 'full-290'
                , response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    , statusCode: 1  //成功的状态码，默认：0
                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    , countName: 'total' //数据总数的字段名称，默认：count
                    , dataName: 'rs' //数据列表的字段名称，默认：data
                }
                , cols: [[
                    {type: 'numbers', fixed: 'true', align: 'center'},
                    {type: 'checkbox'}
                    // ,{field:'id', width:80, title: 'ID',align:'center'}
                    , {field: 'phone',
                      //  width: 400,
                        title: '会员手机号', align: 'center'}
                    , {
                        field: 'member_level',
                      //  width: 100,
                        title: '会员类型',
                        templet: '#certification_type',
                        align: 'center'
                    }
                    , {
                        field: 'crash',
                       // width: 300,
                        align: 'center', title: '可提现账户总金额（元）', templet: function (d) {
                            var num = "";
                            if (Number(d.crash) == '') {
                                num = 0;
                            } else {
                                num = Number((d.crash / 10000).toFixed(2));
                            }
                            return '￥' + num;
                        }
                    }
                    , {
                        field: 'preMoney',
                        align: 'center',
                        align: 'center',
                        title: '当前预估总金额（元）',
                      //  width: 300,
                        templet: function (d) {
                            var num = Number((d.preMoney / 10000).toFixed(2));
                            return '￥' + num;
                        }
                    }
                    // ,{field:'moneyY', align:'center' ,width:200, title: '当前收益（元）', templet:function(d){
                    //         var num="";
                    //         if(Number(d.moneyY)=='')
                    //         {
                    //             num=0;
                    //         }else{
                    //             num=Number(d.moneyY);
                    //         }
                    //         return num;
                    //     }}
                    /*,{field:'create_time', align:'center' ,title: '最后统计时间', width:200 ,templet:'#create_timeTpl'}*/
                    , {field: 'wealth', width: 400, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
                ]]
                , page: true //开启自动分页
                , id: 'listTable'
                , limit: 100
                , limits: [50, 100, 500]
                , response: {
                    statusName: 'success'
                    , statusCode: 1
                    , msgName: 'errorMessage'
                    , countName: 'total'
                    , dataName: 'rs'
                },
            });

            $('.demoTableReload .layui-btn').on('click', function () {
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
                        phone: $('#name').val(),
                        member_level: $('#member_level').val(),

                    }
                });
                return false;
            });


        });

        //点击通过按钮

        function adopt() {

            var table = layui.table;
            var checkStatus = table.checkStatus('listTable'),
                data = checkStatus.data;
            var selectCount = checkStatus.data.length;
            alert(selectCount);
            if (selectCount == 0) {
                layer.msg("请选择一条数据！");
                return false;
            }
            ;
            layer.confirm('确定通过已选中的审核请求吗？', function (index) {
                layer.close(index);
                var ids = new Array(selectCount);
                for (var i = 0; i < selectCount; i++) {
                    ids[i] = checkStatus.data[i].id;
                }
                ;

                $.ajax({
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    url: "${ctx}/certification?method=Passmember&ids=" + ids,
                    traditional: true,
                    success: function (data) {
                        if (data.success = 1) {
                            alert('已通过');
                            layer.msg('已通过');
                        }
                    }
                })
            });
        }


        //点击会员姓名
        function Foo() {
            layer.open({
                type: 2,
                title: '会员信息管理',
                shadeClose: true,
                shade: 0.8,
                area: ['900px', '75%'],
                content: '/uidemo/member/certification_edit.jsp'
            });
        }
    </script>

    <%-- <script type="text/html" id="times">
         {{d.time.slice(0,d.time.indexOf("."))}}
     </script>--%>
    <script id="create_timeTpl" type="text/html">

        {{#  if(d.create_time !== ''){ }}
        <span style="color: rgba(10,10,10,0.46);">20{{ d.create_time.substr(0,2) }}-{{ d.create_time.substr(2,2) }}-{{ d.create_time.substr(4,2) }} {{ d.create_time.substr(6,2) }}:{{ d.create_time.substr(8,2) }}:{{ d.create_time.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
    </script>

    <script type="text/html" id="usernameTpl">
        <a href="javascript:void(0)" onclick="Foo('{{d.username}}')" class="a" style="color: #003399">{{d.username}}</a>
    </script>
    <script type="text/html" id="certification_type">
        {{# if(d.member_level=='0'){}}
        <span style="color:#FF0000; ">非会员</span>

        {{# }else if(d.member_level=='1'){ }}
        <span style="color:green; ">会员</span>
        {{# } }}
    </script>

</head>
<div class="layui-layout layui-layout-admin">
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 5px;">
            <div class="layui-row">
                <div class="layui-elem-quote" style="background-color: #EEEEEE">
                    <label>佣金/收益管理</label>
                </div>

                <form class="layui-form layui-form-pane" action="">
                    <div class="layui-elem-quote"
                         >
                        <div class="layui-inline">
                            <label class="layui-form-label">会员手机号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="name" id="name" autocomplete="off" class="layui-input"
                                       placeholder="请输入手机号">
                            </div>
                        </div>

                        <%--<div class="layui-inline">--%>
                        <%--<label class="layui-form-label">会员号</label>--%>
                        <%--<div class="layui-input-inline">--%>
                        <%--<input type="text" name="member_level" id="member_level"   autocomplete="off" class="layui-input" placeholder="请输入会员名称">--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <div class="layui-inline">
                            <label class="layui-form-label">会员类型</label>
                            <div class="layui-input-block">
                                <select name="member_level" id="member_level">
                                    <option value=""></option>
                                    <option value="0">非会员</option>
                                    <option value="1">会员</option>
                                </select>
                            </div>
                        </div>
                        <%--<div class="layui-inline" >--%>
                        <%--<label class="layui-form-label">申请日期</label>--%>
                        <%--<div class="layui-input-inline" style="width:120px;">--%>
                        <%--<input type="text" class="layui-input" id="test5"   placeholder="年/月/日">--%>
                        <%--&lt;%&ndash;<input type="date" class="layui-input" name="date1" id="date1" style="width:120px;">&ndash;%&gt;--%>
                        <%--</div>--%>
                        <%--<span style="line-height:40px;">-</span>--%>
                        <%--</div>--%>
                        <%--<div class="layui-inline" >--%>
                        <%--<div class="layui-input-inline" style="width:120px;">--%>
                        <%--&lt;%&ndash; <input type="date" class="layui-input" id="date2" name="date2" style="width:120px;">&ndash;%&gt;--%>
                        <%--<input type="text" class="layui-input" id="test6"   placeholder="年/月/日">--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <button class="layui-btn layui-btn-sm" style="margin-left:10px;" id="searchBtn"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置
                        </button>
                    </div>
                </form>
                <table class="layui-hide" id="test"></table>

                <div>

                    <script type="text/html" id="barDemo">
                        <a href="financeDetail.jsp?id={{d.id}}">
                            <button lay-event="agree"
                                    style="height: 20px;line-height: 20px;width:100px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">
                                查看个人收益
                            </button>
                        </a>
                    </script>

                    <script>
                        layui.use('table', function () {
                            var table = layui.table;
                            //监听表格复选框选择
                            table.on('checkbox(demo)', function (obj) {
                                console.log(obj)
                            });
                            //监听工具条
                            table.on('tool(demo)', function (obj) {
                                var data = obj.data;
                                if (obj.event === 'detail') {
                                    layer.msg('ID：' + data.id + ' 的查看操作');
                                } else if (obj.event === 'del') {
                                    layer.confirm('真的删除行么', function (index) {
                                        obj.del();
                                        layer.close(index);
                                    });
                                } else if (obj.event === 'edit') {
                                    layer.alert('编辑行：<br>' + JSON.stringify(data))
                                }
                            });

                            var $ = layui.$, active = {
                                getCheckData: function () { //获取选中数据
                                    var checkStatus = table.checkStatus('idTest')
                                        , data = checkStatus.data;
                                    layer.alert(JSON.stringify(data));
                                }
                                , getCheckLength: function () { //获取选中数目
                                    var checkStatus = table.checkStatus('idTest')
                                        , data = checkStatus.data;
                                    layer.msg('选中了：' + data.length + ' 个');
                                }
                                , isAll: function () { //验证是否全选
                                    var checkStatus = table.checkStatus('idTest');
                                    layer.msg(checkStatus.isAll ? '全选' : '未全选')
                                }
                            };

                            $('.demoTable .layui-btn').on('click', function () {
                                var type = $(this).data('type');
                                active[type] ? active[type].call(this) : '';
                            });
                        });
                    </script>
                    <script>
                        function Foo() {
                            layer.open({
                                type: 2,
                                title: '订单详情',
                                shadeClose: true,
                                shade: 0.8,
                                area: ['100%', '100%'],
                                content: 'membershipInformation.jsp'
                            });
                        }

                        //导出订单
                        function exportOrder() {
                            var params = formatParams();
                            if (!params.order_date_start) {
                                M.alert('请选择开始时间！');
                                return false;
                            }
                            window.open("url" + token + "&" + $.param(params));
                        }
                    </script>
                    <%--<script type="text/html" id="usernameTpl">--%>
                    <%--<a href="javascript:void(0)" onclick="Foo('{{d.id}}')" class="a" style="color: #003399">{{d.nick_name}}</a>--%>
                    <%--</script>--%>

                </div>


            </div>
        </div>

    </div>
<%@ include file="/common/footer.jsp" %>