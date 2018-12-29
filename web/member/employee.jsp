<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/member/huiyuan_menu.jsp"%>
<html>
<head>
    <title>员工管理</title>
    <style>
        .checkbox{
            margin-left:0px;
        }
    </style>
    <script>
        var url="${pageContext.request.contextPath}/member?method=getMemberListPage"
        //JavaScript代码区域
        layui.use(['element','layer'], function(){
            var element = layui.element;
            var $ = layui.jquery, layer = layui.layer;

        });
        layui.use('table', function(){
            var table = layui.table;
            table.render({
                elem: '#test'
                ,url:url
                ,width: 994
                ,height: 332
                ,cols: [[
                    {field:'id', width:80, title: ''}
                    ,{type:'checkbox'}
                    ,{field:'nick_name', width:90, title: '会员姓名'}
                    ,{field:'account_number', width:80, title: '账号' }
                    ,{field:'phone', width:80, title: '工号'}
                    ,{field:'Invitation_code', width: 80, title: '姓名'}
                    ,{field:'status', width:90, title: '状态',templet:'#statusTpl'}
                    ,{field:'e_mail', width:90, title: '角色'}
                    ,{field:'registration_time', width:80, title: '联系电话'}
                    ,{field:'source', width:90, title: '部门'}
                    ,{field:'parent_user_id', width:90, title: '职级'}
                    ,{field:'sub_member_num', width:90, title: '电子邮箱'}
                    ,{field:'order_num', width:90, title: '登录时间'}
                ]]
               /* ,id:'testReload'*/
                ,page: true
                ,response: {
                    statusName: 'success'
                    ,statusCode: 1
                    ,msgName: 'errorMessage'
                    ,countName: 'total'
                    ,dataName: 'rs'
                }
            });
        });
        //调用启用
        function enable(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };

            layer.confirm('确定要启用选中的项吗？',function(index){
                layer.close(index);
                var status = 1;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].id;
                    if(checkStatus.data[i].status == 1){
                        layer.msg("已经是启用了！");
                        return false;
                    }
                }
                // var jsonIds= JSON.stringify(ids);
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateStatus&status=" + status +"&id="+ids,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("test")
                        } else {
                            layer.msg("异常");
                        }
                    }
                })
            })
        };
        //调用禁用
        function disable(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            layer.confirm('确定要禁用选中的项吗？',function(index){
                layer.close(index);
                var status = 0;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].id;
                    if(checkStatus.data[i].status == 0){
                        layer.msg("已经是禁用了！");
                        return false;
                    }
                }
                // var jsonIds= JSON.stringify(ids);
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateStatus&status=" + status +"&id="+ids,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("test")
                        } else {
                            layer.msg("异常");
                        }
                    }
                })
            })
        };
        //点击编辑按钮
        function edit_em(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount!=1){
                layer.msg("只能选择一条数据！");
                return false;
            };
            var ids =checkStatus.data;
            parent.$('#nick_name').val(ids[0].nick_name);
            parent.$('#account_number').val(ids[0].account_number);
            parent.$('#e_mail').val(ids[0].e_mail);
            parent.$('#phone').val(ids[0].phone);
            parent.$('#member_level').val(ids[0].member_level);
            parent.$('#status').val(ids[0].status);
            layer.open({
                type:1
                ,title:'员工编辑'
                ,area: ['1000px', '320px']
                ,content:$('#edit_employ')
                , btn: ['取消', '确认']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,success: function (data){
                    if (data.success) {
                        layer.msg("操作成功");
                        table.reload("test")
                    }
                }
                ,yes: function(){
                    layer.closeAll();
                }
            });
        };
        //点击添加按钮
        function add_employee(){

            layer.open({
                type: 1
                ,title:'员工编辑'
                ,area: ['1000px', '500px']
                ,content:$('#edit_add')
                /*   , btn: ['取消', '确认']*/
                ,btnAlign: 'c' //按钮居中
                /*  ,shade: 0 //不显示遮罩*/
                ,success:function(data){
                }
                ,end: function(data){
                    layer.closeAll();
                }
            })
        };

        function saveEEE(){

            alert("hihihihihihih")
            $.ajax({
                url: "${pageContext.request.contextPath}/member?method=MembersAdd&jsonString="+JSON.stringify($('#addForm').serializeObject()),
                //data: "method=MembersAdd&jsonString="+JSON.stringify($('#addForm').serializeObject()),
                contentType:"application/json",  //缺失会出现URL编码，无法转成json对象*/
                cache: true,
                async : false,
                dataType: "json",
                success:function(data) {
                    alert(data)

                    if(data.success){

                        layer.msg('员工添加成功',{icon: 1}, function(){
                            window.location.reload();
                        });

                    }else{
                        layer.msg("异常");
                    }
                },
                error : function() {
                    layer.alert("错误");
                }
            });


            alert("ddddddd")


        }

        /**
         * 自动将form表单封装成json对象
         */
        $.fn.serializeObject = function() {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function() {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [ o[this.name] ];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };
        //搜索功能
        function searchForm(){
            var table = layui.table;
            var account_number = $('#account_number').val();
            var nick_name = $('#nick_name').val();
            var roles =$('modules').val();
            table.reload('test', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                        nick_name: nick_name,
                    account_number:account_number,
                             roles:roles
                }
            });
            console.log(account_number);

        }
    </script>
    <script type="text/html" id="statusTpl">
        {{# if(d.status =='0'){}}
        <span style="color:#FF0000; ">禁用</span>
        {{# }else if(d.status =='1'){ }}
        启用
        {{# } }}
    </script>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!--主体部分 -->
    <div class="layui-body">
        <!-- 上部分查询表单-->
        <div class="main-top" style="background-color:#EEEEEE;width:1000px;height: 100px;margin:0px">
            <div  style=" margin-top:0px;margin-left:10px;" id="demoTable">
                <button class="layui-btn layui-btn-radius layui-btn-normal" id="search" onclick="searchForm()" >搜索</button>
                <button class="layui-btn layui-btn-radius layui-btn-normal" type="reset">重置</button>
            </div>
            <form class="layui-form"  style="margin-top:10px;">
                <div class="layui-form-item" >
                    <div class="layui-inline" style="position:relative;right:50px;">
                        <label class="layui-form-label">账号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="account_number" id="account_number" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline" style="position:relative;right:100px;">
                        <label class="layui-form-label" >姓名</label>
                        <div class="layui-input-inline" >
                            <input type="text" name="nick_name" id="nick_name"  autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline" style="position:relative;right:150px;">
                        <label class="layui-form-label">角色</label>
                        <div class="layui-input-inline">
                            <select name="modules"  lay-search="" id="modules">
                                <option value="">全部</option>
                                <option value="0">读取角色的列表</option>
                                <option value="1">禁用</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline" pane="" style="position:relative;left:830px;bottom:40px;">
                        <div class="layui-input-block checkbox">
                            <input type="checkbox" name="status" lay-skin="primary" title="仅显示启用状态" checked="checked">
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <!-- 中部表单 -->
        <div class="main-top">
            <button class="layui-btn layui-btn-normal layui-btn-radius"  onclick="disable()">禁用</button>
            <button class="layui-btn layui-btn-normal layui-btn-radius"  onclick="enable()">启用</button>
            <button class="layui-btn layui-btn-primary layui-btn-radius" onclick="edit_em()">编辑</button>
            <button class="layui-btn layui-btn-primary layui-btn-radius" onclick="add_employee()">添加员工</button>
            <table class="layui-hide" id="test"></table>
        </div>
    </div>
    <%--点击编辑--%>
    <div id="edit_employ" style="padding: 20px 100px;height:100px; display: none;">
        <div class="" style=""><span style="margin-left:30px;">员工基本信息</span></div>
        <form class="layui-form" >
            <%--隐藏域id--%>
            <input type="hidden" name="id" value="ids[0].id" >
         <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">姓名:</label>
                <div class="layui-input-block">
                    <input type="text" name="nick_name" id="username" value="" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">工号:</label>
                <div class="layui-input-inline">
                    <input type="text" name="account_number" id="account_number" lay-verify="required" autocomplete="off" class="layui-input">
                </div>
            </div>
         </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电子邮箱:</label>
                <div class="layui-input-inline">
                    <input type="text" name="e_mail" lay-verify="email" id="e_mail" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">手机号:</label>
                    <div class="layui-input-block">
                        <input type="text" name="phone" class="layui-input" id="phone" value="" lay-verify="required|number|phone">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" style="margin-top:10px;">
                <div class="layui-inline">
                    <label class="layui-form-label">部门</label>
                    <div class="layui-input-inline">
                        <select name="modules" lay-verify="required" lay-search="">
                            <option value=""></option>
                            <option value="0">读取部门列表</option>
                            <option value="1">女</option>

                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">职级</label>
                    <div class="layui-input-inline">
                        <select name="member_level" lay-verify="required" id="member_level" lay-search="">
                            <option value=""></option>
                            <option value="0"></option>
                            <option value="1"></option>

                        </select>
                    </div>
                </div>
            </div>

            <div class="" ><span style="margin-left:30px;">系统登录信息</span></div>
            <div class="layui-form-item layui-form-text">
                <div class="layui-inline">
                    <label class="layui-form-label">账号:</label>
                    <div class="layui-input-block">
                        <input type="text" name="account_number" id="account_number" lay-verify="required" autocomplete="off"
                               class="layui-input"  disabled="true">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">登录密码:</label>
                <div class="layui-input-inline">
                    <input type="password" name="password" id ="pws"lay-verify="pass" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">确认密码:</label>
                    <div class="layui-input-block">
                        <input type="password" name="password" id="qpws" lay-verify="pass" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block" id="status" >
                    <input type="radio" name="sex" value="0"  checked="">
                    <input type="radio" name="sex" value="1"  >
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="reset" class="layui-btn layui-btn-primary">取消</button>
                    <button class="layui-btn" lay-submit lay-filter="formDemo">确认</button>
                </div>
            </div>
        </form>
    </div>
    <%--点击添加--%>
    <div id="edit_add" style="padding: 20px 100px;height:100px; display: none;">
        <div class="" style=""><span style="margin-left:30px;">员工基本信息</span></div>
        <form class="layui-form" id="addForm">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">姓名:</label>
                    <div class="layui-input-block">
                        <input type="text" name="nick_name" id="username" value="" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">工号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="account_number" id="account_number" lay-verify="required" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电子邮箱:</label>
                <div class="layui-input-inline">
                    <input type="text" name="e_mail" lay-verify="email" id="e_mail" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">手机号:</label>
                    <div class="layui-input-block">
                        <input type="text" name="phone" class="layui-input" id="phone" value="" lay-verify="required|number|phone">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" style="margin-top:10px;">
                <div class="layui-inline">
                    <label class="layui-form-label">部门</label>
                    <div class="layui-input-inline">
                        <select name="modules" lay-verify="required" lay-search="">
                            <option value=""></option>
                            <option value="0">读取部门列表</option>
                            <option value="1">女</option>

                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">职级</label>
                    <div class="layui-input-inline">
                        <select name="member_level" lay-verify="required" id="member_level" lay-search="">
                            <option value=""></option>
                            <option value="0"></option>
                            <option value="1"></option>

                        </select>
                    </div>
                </div>
            </div>

            <div class="" ><span style="margin-left:30px;">系统登录信息</span></div>
            <div class="layui-form-item layui-form-text">
                <div class="layui-inline">
                    <label class="layui-form-label">账号:</label>
                    <div class="layui-input-block">
                        <input type="text" name="account_number" id="account_number" lay-verify="required" autocomplete="off"
                               class="layui-input" >
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">登录密码:</label>
                <div class="layui-input-inline">
                    <input type="password" name="password" id ="pws"lay-verify="pass" autocomplete="off" class="layui-input">
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">确认密码:</label>
                    <div class="layui-input-block">
                        <input type="password" name="password" id="qpws" lay-verify="pass" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block" id="status" >
                    <input type="radio" name="status" value="0" title="禁用" checked="">
                    <input type="radio" name="status" value="1" title="启用" >
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="reset" class="layui-btn layui-btn-primary">取消</button>
                    <button class="layui-btn"  id="saveEmployeedddd" onclick="saveEEE()" >确认</button>
                </div>
            </div>
        </form>
    </div>
</div>
<%@ include file="/common/footer.jsp"%>
</body>
</html>
