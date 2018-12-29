<%--
  Created by IntelliJ IDEA.
  User: wanzi
  Date: 2018/2/28
  Time: 9:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/member/huiyuan_menu.jsp"%>

<html>
<head>
    <title>认证审核 </title>
    <script>
        //JavaScript代码区域
        layui.use(['element','laydate','layer'], function(){
            var element = layui.element;
            var $ = layui.jquery, layer = layui.layer;
            var laydate = layui.laydate;
            laydate.render({
                elem: '#date1'
                ,type: 'datetime'
            });
            laydate.render({
                elem: '#date2'
                ,type: 'datetime'
            });
            // 点击拒绝按钮
            var active = {
                offset: function(othis){
                    var type = othis.data('type')
                        ,text = othis.text();
                    layer.open({
                        type: 1
                        ,offset: type
                        ,title:'拒绝提示框'
                        ,id: 'layerDemo'+type
                        ,area: ['400px', '320px']
                        ,content:$('#textarea_add')
                        , btn: ['确认', '取消']
                        ,btnAlign: 'c' //按钮居中
                        ,shade: 0 //不显示遮罩
                        ,yes: function(){
                            layer.closeAll();

                            var table =layui.table;
                            var checkStatus = table.checkStatus('listTable'),
                                data = checkStatus.data;
                            var selectCount = checkStatus.data.length;
                            alert(selectCount);
                            if(selectCount==0){
                                layer.msg("请选择一条数据！");
                                return false;
                            };
                            layer.confirm('确定拒绝已选中的审核请求吗？',function(index){
                                layer.close(index);

                                var ids = new Array(selectCount);
                                for(var i=0; i<selectCount; i++){
                                    ids[i]=checkStatus.data[i].id;
                                };

                                $.ajax({
                                    async : false, // 同步请求
                                    cache : true,// 不使用ajax缓存
                                    url : "${pageContext.request.contextPath}/certification?method=Rejectmember&ids="+ids,
                                    traditional: true,
                                    success : function(data){
                                        if (data.success = 1) {

                                            layer.msg('已拒绝');
                                        }
                                    }
                                })
                            });
                        }
                    });
                }
            };

            $('#layerDemo').on('click', function(){
                var othis = $(this), method = othis.data('method');
                active[method] ? active[method].call(this, othis) : '';
            });


        });
        layui.use('table', function(){
            var table = layui.table;

            table.render({
                elem: '#test'
                ,url: '${pageContext.request.contextPath}/certification?method=Selectpending' //数据接口
                ,height: 600
                ,width:1276
                ,response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    ,statusCode: 1  //成功的状态码，默认：0
                    ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    ,countName: 'total' //数据总数的字段名称，默认：count
                    ,dataName: 'rs' //数据列表的字段名称，默认：data
                }
                ,cols: [[
                    {type:'checkbox'}
                    ,{field:'id', width:80, title: 'ID'}
                    ,{field:'nick_name', width:122, title: '名称'}
                    ,{field:'type', width:119, title: '审核状态',templet:'#certification_type'}
                    ,{field:'city', width:300, title: '地址'}
                    ,{field:'phone', title: '手机号', width:184}
                    ,{field:'registration_time', width:212, title: '申请时间'}
                    ,{field:'wealth', width:200, fixed: 'right', align:'center',title: '操作',toolbar:"#barDemo"}
                ]]
                ,page: true //开启自动分页
                ,id:'listTable'
            });
            var $ = layui.$, active = {
                sreach: function () {
                    //执行重载
                    table.reload('testReload', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {
                            phone: $('#phone').val(),
                            date1: $('#date1').val(),
                            date2: $('#date2').val(),
                            nick_name: $('#nick_name').val(),
                            audit_status :$("#audit_status option:checked").text(),
                        }
                    });
                }
            };
            $('.demoTableReload .layui-btn').on('click', function(){
                var type = $(this).data('type');
                active[type] ? active[type].call(this) : '';
            });


            //点击按钮 搜索
            $('#searchBtn').on('click', function(){

                //执行重载
                table.reload('listTable', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: {
                        phone: $('#phone').val(),
                        date1: $('#date1').val(),
                        date2: $('#date2').val(),
                        nick_name: $('#nick_name').val(),
                        audit_status :$('#audit_status').val(),
                    }
                });
                return false;
            });

        });
        //点击通过按钮

        function adopt(){

            var table =layui.table;
            var checkStatus = table.checkStatus('listTable'),
                data = checkStatus.data;
            var selectCount = checkStatus.data.length;
            alert(selectCount);
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            layer.confirm('确定通过已选中的审核请求吗？',function(index){
                layer.close(index);

                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].id;
                };

                $.ajax({
                    async : false, // 同步请求
                    cache : true,// 不使用ajax缓存
                    url : "${pageContext.request.contextPath}/certification?method=Passmember&ids="+ids,
                    traditional: true,
                    success : function(data){
                        if (data.success = 1) {
                            alert('已通过');
                            layer.msg('已通过');
                        }
                    }
                })
            });
        }
        //点击会员姓名
        function Foo(){
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
    <script type="text/html" id="usernameTpl">
        <a href="javascript:void(0)" onclick="Foo('{{d.username}}')" class="a" style="color: #003399">{{d.username}}</a>
    </script>
    <script type="text/html" id="certification_type">
        {{# if(d.audit_status=='0'){}}
        <span style="color:#FF0000; ">待审核</span>
        {{# }else if(d.audit_status=='-1'){ }}
        <span style="color:gray; ">拒绝</span>
        {{# }else if(d.audit_status=='1'){ }}
        <span style="color:green; ">通过</span>
        {{# } }}
    </script>
</head>
<body class="layui-layout-body">
<!--主体部分 -->
<div class="layui-layout layui-layout-admin">
    <div class="layui-body">
        <!-- 上部分查询表单-->
        <div class="main-top" >
            <div class="layui-elem-quote" style="margin-top:10px;margin-left:15px;">
                会员认证
            </div>
            <%--            <div class="layui-elem-quote" style="margin-left: 20px;margin-top: 10px;background-color: #EEEEEE">
                        <button class="layui-btn" data-type="sreach" id="searchBtn" style=" margin-top:10px;margin-left:20px;">搜索</button>
                        <button type="reset" class="layui-btn" style=" margin-top:10px;margin-left:20px;">重置</button>
                        </div>--%>
            <form class="layui-form layui-form-pane"   style="margin-top:10px;">
                <div class="layui-elem-quote" style="margin-left: 15px;margin-top: 10px;background-color: #EEEEEE">
                    <div class="layui-inline">
                        <label class="layui-form-label">注册手机号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="phone" id="phone" lay-verify="required|number"  autocomplete="off" class="layui-input" placeholder="请输入手机号">
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="nick_name" id="nick_name" lay-verify="required|number" autocomplete="off" class="layui-input" placeholder="请输入名称">
                        </div>
                    </div>

                    <div class="layui-inline" >
                        <label class="layui-form-label">申请日期</label>
                        <div class="layui-input-inline" style="width:120px;">
                            <input type="text" class="layui-input" id="date1" name="date1" placeholder="年/月/日">
                            <%--<input type="date" class="layui-input" name="date1" id="date1" style="width:120px;">--%>
                        </div>
                        <span style="line-height:40px;">-</span>
                    </div>

                    <div class="layui-inline" >
                        <div class="layui-input-inline" style="width:120px;">
                            <%-- <input type="date" class="layui-input" id="date2" name="date2" style="width:120px;">--%>
                            <input type="text" class="layui-input" id="date2" name="date2" placeholder="年/月/日">
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">审核状态</label>
                        <div class="layui-input-inline">
                            <select id="audit_status" lay-verify="required" lay-search="">
                                <option value="">全部</option>
                                <option value="0">待审核</option>
                                <option value="1">通过</option>
                                <option value="2">已拒绝</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-inline" style="margin-left: 72%;margin-top: 10px;">
                        <%-- <div class="layui-input-inline" style="width:400px">--%>
                        <button class="layui-btn layui-btn-sm"  style="margin-left:10px;" id="searchBtn" ><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button type="reset" class="layui-btn layui-btn-sm" ><i class="layui-icon">&#x2746;</i>重置</button>
                        <button class="layui-btn layui-btn-sm" onclick="adopt()"><i class="layui-icon">&#xe610;</i>通过</button>
                        <button class="layui-btn layui-btn-sm" id="layerDemo" data-method="offset" data-type="auto"><i class="layui-icon">&#x1007;</i>拒绝</button>

                        <%-- </div>--%>
                    </div>

                </div>
            </form>
        </div>
        <!-- 中部表单 -->
        <div class="main-top" style="margin-left: 15px;margin-top: 10px;">
            <table class="layui-hide" id="test"></table>

            <script type="text/html" id="barDemo">
                <%--<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>--%>
                <button  onclick="adopt()" style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">通过</button>
                <button  id="layerDemo" data-method="offset" data-type="auto" style="height: 20px;line-height: 20px;width:50px;background-color: #1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">拒绝</button>
            </script>
        </div>

    </div>
    <div style="padding: 20px 100px;height:100px; display: none;" id="textarea_add">
        请详细填写拒绝原因，此内容将反馈给会员。
        <textarea name="textarea" id="area1" cols="30" rows="10"></textarea>
    </div>

    <%@ include file="/common/footer.jsp"%>
</body>
</html>
