<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp" %>
<%@include file="../common/Sys_menu.jsp"%>
<script>
    //JavaScript代码区域
    layui.use('element', function(){
        var element = layui.element;

    });
    layui.use('table', function(){
        var table = layui.table;

        table.render({
            elem: '#staffListTab'
            ,url:'${ctx}/user?method=getStaffInfoList'
            ,limit:20
            ,limits:[20,50,100]
            ,height: 600
            ,cols: [[
                {type:'checkbox', fixed: 'left'}
                ,{field:'login_name',   title: '账号',fixed: 'left'}
                ,{field:'department_name',   title: '部门'}
                // ,{field:'job_number', width:100, title: '工号',align:'center', templet:function (d) {
                //         var index=d.department_code+"_"+d.job_number;
                //         return index;
                //     }}
                ,{field:'nick_name',   title: '姓名',align:'center'}
                ,{field:'role_name',   title: '角色',align:'center'}
                ,{field:'STATUS',   title: '状态',align:'center',templet:'#status'}
                ,{field:'phone',   title: '电话',align:'center'}
                ,{field:'e_mail',   title: 'E-mail',align:'center'}
                /*,{field:'classify', width:200, title: '座机',align:'center'}*/
                ,{field:'last_login_time',   title: '最后登录时间',align:'center', templet:function (d) {
                        var index="";
                        if(d.last_login_time!=""){
                            index=20+d.last_login_time.substr(0,2)+"-"+d.last_login_time.substr(2,2)+"-"+d.last_login_time.substr(4,2)+" "+d.last_login_time.substr(6,2)+":"+d.last_login_time.substr(8,2)+":"+d.last_login_time.substr(10,2);
                        }else{
                            index="----";
                        }

                        return index;
                    }}
            ]]
            ,page: true //开启分页
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,id:'staffListTabReload'
        });

        //点击按钮 搜索
        $('#searchBtn').on('click', function(){
            //执行重载
            table.reload('staffListTabReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    login_name: $('#login_name').val(),
                    nick_name: $('#nick_name').val(),
                    role: $('#role').val(),
                    department: $('#department').val(),
                }
            });
            return false;
        });

        $('.staffInfoManage .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });

    function forbidden(){
        alert();
        var table =layui.table;
        var checkStatus = table.checkStatus('staffListTabReload'),
            data = checkStatus.data;
        var selectCount = checkStatus.data.length;
        if(selectCount==0){
            layer.msg("请选择一条数据！");
            return false;
        };
        layer.confirm('确定禁用该账号？',function(index){
            //obj.del();//删除对应行（tr）的DOM结构，并更新缓存
            layer.close(index);
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].id;
            };

            $.ajax({
                type:"get",
                cache: false,
                async : false,
                dataType: "json",
                url : "${ctx}/user?method=forbidden&ids="+ids,
                success : function(data){
                    if (data.success = 1) {
                        layer.msg('禁用成功');
                        table.reload("staffListTabReload")
                    }
                }
            })

        });
    }
    function startuser(){
        var table =layui.table;
        var checkStatus = table.checkStatus('staffListTabReload'),
            data = checkStatus.data;
        var selectCount = checkStatus.data.length;
        if(selectCount==0){
            layer.msg("请选择一条数据！");
            return false;
        };
        layer.confirm('确定启用该账号？',function(index){
            //obj.del();//删除对应行（tr）的DOM结构，并更新缓存
            layer.close(index);
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].id;
            };

            $.ajax({
                type:"get",
                cache: false,
                async : false,
                dataType: "json",
                url : "${ctx}/user?method=stratuser&ids="+ids,
                success : function(data){
                    if (data.success = 1) {
                        layer.msg('启用成功');
                        table.reload("staffListTabReload")
                    }
                }
            })

        });
    }

    function edit(){
        var table =layui.table;
        var checkStatus = table.checkStatus('staffListTabReload'),
            data = checkStatus.data;
        var selectCount = checkStatus.data.length;
        if(selectCount==0){
            layer.msg("请选择一条数据！");
            return false;
        };
        var ids = new Array(selectCount);
        for(var i=0; i<selectCount; i++){
            ids[i]=checkStatus.data[i].id;
        };
        window.location.href='staff_edit.jsp?ids='+ids;

    }
</script>
<script type="text/html" id="status">
    {{# if(d.STATUS=='1'){}}
    <span >可用</span>

    {{# }else if(d.STATUS=='0'){ }}
    <span style="color:#FF0000; ">已禁用</span>
    {{# } }}
</script>
<script>
    $(document).ready(function () {
        //获取部门信息
        $.ajax({
            type: "get",
            contentType : "application/json",
            url : "${ctx}/department?method=getDepartmentInfoToSel",
            cache: false,
            async: false,
            dataType: "json",
            success : function(data){
                if(data.success == 1) {
                    var array = data.rs;
                    for (var obj in array) {
                        $("#department").append("<option value='"+array[obj].id+"'>"+array[obj].department_code+"_"+array[obj].department_name+"</option>");

                    }
                }
            }
        });
        //获取部门信息
        $.ajax({
            type: "get",
            contentType : "application/json",
            url : "${ctx}/role?method=getRoleInfoToSel",
            cache: false,
            async: false,
            dataType: "json",
            success : function(data){
                if(data.success == 1) {
                    var array = data.rs;
                    for (var obj in array) {
                        $("#role").append("<option value='"+array[obj].id+"'>"+array[obj].role_name+"</option>");

                    }
                }
            }
        });
    });
</script>
<div class="layui-layout layui-layout-admin">
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 20px;">
            <div class="layui-row">
                <div class="layui-elem-quote" style="background-color: #EEEEEE">
                    <label>员工管理列表</label>

                </div>

                <form class="layui-form layui-form-pane" action="">  <div style="background-color: #f2f2f2;padding:5px 0">
                    <div class="layui-form-item" style="margin-bottom:5px">

                        <div class="layui-inline">
                            <label class="layui-form-label">账号</label>
                            <div class="layui-input-inline">
                                <input type="text" id="login_name"  autocomplete="off" class="layui-input" placeholder="请输入账号">
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">姓名</label>
                            <div class="layui-input-inline">
                                <input type="text" id="nick_name"   autocomplete="off" class="layui-input" placeholder="请输入姓名">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item" style="margin-bottom: 0">

                        <div class="layui-inline">
                            <label class="layui-form-label">角色</label>
                            <div class="layui-input-inline">
                                <select name="role" id="role" lay-filter="aihao" style="width:20% ;height: 35px">
                                    <option value="" selected>请选择角色</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">部门</label>
                            <div class="layui-input-inline">
                                <select name="department" id="department" lay-filter="aihao" style="width:20% ;height: 35px">
                                    <option value="" selected>请选择部门</option>
                                </select>
                            </div>
                        </div>
                        <%--<div class="layui-input-inline">--%>
                        <%--<input type="checkbox" id="showStopSale" name="showStopSale" value="" title="有停售规格">--%>
                        <%--</div>--%>
                        <button class="layui-btn layui-btn-sm"  style="margin-left:10px;" id="searchBtn" ><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button type="reset" class="layui-btn layui-btn-sm" ><i class="layui-icon">&#x2746;</i>重置</button>


                    </div>
                </div>

                </form>

                <div>
                    <!-- 中部表单 -->
                    <div class="layui-inline staffInfoManage"style="margin-top: 10px;">
                        <button class="layui-btn  layui-btn-sm"  onclick="forbidden()"><i class="layui-icon">&#xe63f;</i>禁用</button>
                        <button class="layui-btn  layui-btn-sm" onclick="startuser()"><i class="layui-icon">&#xe617;</i>启用</button>
                        <button class="layui-btn  layui-btn-sm" onclick="edit()"><i class="layui-icon">&#xe642;</i>编辑</button></a>
                        <%--<a href="staff_add.jsp"> <button class="layui-btn layui-btn-primary layui-btn-sm">添加员工</button></a>--%>
                        <a href="staff_add.jsp"><button class="layui-btn  layui-btn-sm"><i class="layui-icon">&#xe654;</i>添加员工</button></a>

                    </div>
                    <table class="layui-table" id="staffListTab" lay-filter="staffListFilter"></table>

                </div>

            </div>
        </div>

    </div>
    <%@ include file="/common/footer.jsp"%>

