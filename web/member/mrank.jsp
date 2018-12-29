<%--
  User: wanzi
  Date: 2018/2/28
  Time: 11:39
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="member_menu.jsp"%>
<html>
<head>
    <title>会员等级</title>
    <script src="../code/highcharts.js"></script>
    <script src="../code/modules/exporting.js"></script>
    <script>
        //JavaScript代码区域
        layui.use('element', function(){
            var element = layui.element;

        });
        /*点击 添加会员按钮弹出对会框*/
        layui.use('layer', function(){
            var $ = layui.jquery, layer = layui.layer;
            //触发事件
            var active = {
                offset: function(othis){
                    var type = othis.data('type')
                        ,text = othis.text();

                    layer.open({
                        type: 1
                        ,offset: type
                        ,title:'添加会员分销等级'
                        ,id: 'layerDemo'+type
                        ,content: '<div style="padding: 20px 100px;height:100px;">'
                        + '<input id="ranktext" type="text" style="height:30px;width:200px" placeholder="请输入会员等级">'
                        +'</div>'
                        ,btn: '保存'
                        ,btnAlign: 'r' //按钮居中
                        ,shade: 0 //不显示遮罩
                        ,yes: function(){
                            layer.closeAll();
                        }
                    });
                }
            };

            $('#layerDemo .layui-btn').on('click', function(){
                var othis = $(this), method = othis.data('method');
                active[method] ? active[method].call(this, othis) : '';
            });

        });
        /*数据信息查询*/
        layui.use('table', function(){
            var table = layui.table;
            table.render({
                elem: '#test'
                ,url:'./demo/table/user.json'
                ,page: {
                    layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                    //,curr: 5 //设定初始在第 5 页
                    ,groups: 1 //只显示 1 个连续页码
                    ,first: false //不显示首页
                    ,last: false //不显示尾页

                }
                ,width: 1109
                ,height: 332
                ,cols: [[
                    {field:'id', width:80, title: ''}
                    ,{field:'sex', width:100, title: '名称'}
                    ,{field:'city', width:100, title: '手机号'}
                    ,{field:'sign', title: '邀请码', minWidth: 150}
                    ,{field:'experience', width:100, title: '上级人员'}
                    ,{field:'score', width:100, title: '下级人数' }
                    ,{field:'classify', width:100, title: '注册时间'}
                    ,{field:'wealth', width:100, title: '状态'}
                    ,{field:'wealth', width:100, title: '操作'}
                ]]

            });
        });
    </script>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 内容主体区域 -->
    <div class="layui-body">
        <!-- 会员等级查询-->
        <div class="main-top" style="width:58%;height: 122px;margin:0px">
            <div class="layui-inline" style=" margin-top:10px;margin-left:10px;font-size:14px;">当前位置：分销系统>分销等级 >会员信息表</div>
            <div class="layui-form-item" style=" margin-top:10px;margin-left:10px;"><img src="image/1.png" /></div>
            <div class="site-demo-button" id="layerDemo" style="margin-bottom: 0;  position: relative; left:500px;">
                <button data-method="offset" data-type="auto" class="layui-btn layui-btn-normal layui-btn-radius">添加会员等级</button>
            </div>
        </div>
        <!-- 中部表格 -->
        <div class="main-top" style="margin-top:10px;">
            <table class="layui-table" lay-filter="test" style="width:610px;">
                <thead>
                <tr>
                    <th lay-data="{field:'id', width:80}"></th>
                    <th lay-data="{field:'username', width:80}">会员等级</th>
                    <th lay-data="{field:'sex', width:80}">人数</th>
                    <th lay-data="{field:'city'}">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td>会员</td>
                    <td>1009</td>
                    <td><a href="javascript:void(0)" onclick="aClick()" style="color:blue">查看</a></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>非会员</td>
                    <td>109</td>
                    <td><a href="javascript:void(0)" style="color:blue" data-method="offset" id="layerDemo" >查看</a></td>
                </tr>
                </tbody>
            </table>
        </div>
        <%-- 数据分布图--%>
        <div class="layui-form-item" style=" margin-top:10px;margin-left:10px;"><img src="image/2.png" /></div>
        <div id="container" style="min-width: 310px; height: 400px; max-width: 600px;margin-left:150px;"></div>
        <script type="text/javascript">
            Highcharts.chart('container', {
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text:null,
                },
                credits: {
                    enabled: false
                },
                exporting:{
                    enabled:false //用来设置是否显示‘打印’,'导出'等功能按钮，不设置时默认为显示
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                            style: {
                               color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            }
                        }
                    }
                },
                series: [{
                    name: '数据分析',
                    colorByPoint: true,
                    data: [{
                        name: '会员',
                        y: 56.33
                    }, {
                        name: '非会员',
                        y: 24.03,
                        sliced: true,
                        selected: true
                    }]
                }]
            });
        </script>
        <%-- 会员信息表--%>
        <div class="layui-form-item" style=" margin-top:10px;margin-left:10px;"><img src="image/3.png" /></div>
        <div class="bb">
            <form class="layui-form" action="">
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-block">
                        <select name="city" lay-verify="required">
                            <option value=""></option>
                            <option value="0">启用</option>
                            <option value="1">禁用</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline">
                        <input type="text" name="date" id="date" lay-verify="date" placeholder="请输入名称和手机号" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-block">
                        <button class="layui-btn layui-btn-normal layui-btn-radius" lay-submit lay-filter="formDemo">搜索</button>
                        <button type="reset" class="layui-btn layui-btn-primary layui-btn-radius">重置</button>
                    </div>
                </div>
            </form>
            <script>
                //Demo
                layui.use('form', function(){
                    var form = layui.form;

                    //监听提交
                    form.on('submit(formDemo)', function(data){
                        layer.msg(JSON.stringify(data.field));
                        return false;
                    });
                });
            </script>
        </div>
        <%--搜索查询信息显示--%>
        <table class="layui-hide" id="test"></table>
    </div>
    <%@ include file="/common/footer.jsp"%>
</div>

</body>
</html>