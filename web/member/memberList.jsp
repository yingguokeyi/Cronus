<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/member/huiyuan_menu.jsp"%>
<head>
    <title>会员管理</title>

    <script>
        //JavaScript代码区域
        layui.use(['element','laydate','table'], function(){
            var element = layui.element;
            var laydate = layui.laydate;
            var table = layui.table;
            laydate.render({
                elem: '#registration_time'
                ,type: 'datetime'
            });
            laydate.render({
                elem: '#endDate'
                ,type: 'datetime'
            });
            table.render({
                elem: '#test'
                ,url:'${pageContext.request.contextPath}/member?method=getMemberListPage'
                //,width: 1900
                ,height: 580
                ,cols: [[
                    {type:'checkbox', fixed: 'left'}
                    ,{field:'id', width:60, title: 'ID',  fixed: 'left'}
                    // ,{field:'account_number', width:121, title: '账号',templet: '#accountTpl',align:'center'}
                    ,{field:'nick_name', width:120, title: '会员昵称',templet:'#usernameTpl',align:'center' }
                    ,{field:'phone', width:118, title: '手机号',templet:'#telPhoneTpl',align:'center'}
                    ,{field:'Invitation_code1', width: 118, title: '邀请码',templet:'#Invitation_code',align:'center'}
                    ,{field:'member_level', width:111, title: '会员类型', templet:'#member_levelTpl',align:'center'}
                    ,{field:'status', width:90, title: '账号状态', templet:'#statusTpl',align:'center'}
                    ,{field:'e_mail', width:113, title: 'E-mail',templet:'#EmialTpl',align:'center'}
                    ,{field:'registration_time', width:165, title: '注册时间',templet: '#create_timeTpl',align:'center'}
                    ,{field:'source', width:95, title: '注册来源',templet:'#sourceTpl',align:'center'}
                    ,{field:'sup_member_name', width:90, title: '上级会员',templet:'#sup_memberTpl',align:'center'}
                    ,{field:'self_num', width:119, title: '下级会员人数',templet:function(d){
                            return Number(d.self_num)+Number(d.pare_num);
                        },align:'center'}
                    ,{field:'countOrder', width:101, title: '成交订单数',align:'center'}
                    ,{field:'wealth', width:450, title: '操作',toolbar:"#barDemo",fixed: 'right'}
                ]]
                ,limit:20
                ,limits:[20,30,40,50,100]
                ,page: true
                ,response: {
                    statusName: 'success'
                    ,statusCode: 1
                    ,msgName: 'errorMessage'
                    ,countName: 'total'
                    ,dataName: 'rs'
                }
            });
            //点击按钮 搜索
            $('#searchBtn').on('click', function(){
                var account_number = $('#account_number');
                var phone = $('#phone');
                var status = $('#status');
                var registration_time = $('#registration_time');
                var endDate = $('#endDate');
                var source = $('#source');
                var member_level = $('#member_level');
                table.reload('test', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        nick_name: account_number.val(),
                        phone: phone.val(),
                        status: status.val(),
                        registration_time: registration_time.val(),
                        endDate: endDate.val(),
                        source: source.val(),
                        member_level: member_level.val()
                    }
                });
                return false;
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
            //点击禁用按钮 弹框中的状态
            function disableaa(obj){
                var table = layui.table;
                layer.confirm('确定要禁用选中的项吗？',function(index){
                    layer.close(index);
                    var status =0;
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${pageContext.request.contextPath}/member",
                        data : "method=updateStatus&status=" + status +"&id="+obj,
                        dataType : "json",
                        success : function(data){
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("selectMemberDown1");

                            } else {
                                layer.msg("异常");
                            }
                        }
                    })
                });
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
            //点击禁用按钮 弹框中的状态
            function disableaa(obj){

                var table = layui.table;
                layer.confirm('确定要禁用选中的项吗？',function(index){
                    layer.close(index);
                    var status =0;
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${pageContext.request.contextPath}/member",
                        data : "method=updateStatus&status=" + status +"&id="+obj,
                        dataType : "json",
                        success : function(data){
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("selectMemberDown1");
                            } else {
                                layer.msg("异常");
                            }
                        }
                    })
                });
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

        //成为会员
        function become_Member(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            layer.confirm('确定选中项成为会员吗？',function(index){
                layer.close(index);
                var member_level = 1;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].id;
                    if(checkStatus.data[i].member_level == 1){
                        layer.msg("已经是会员了！");
                        return false;
                    }
                }
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateMemberLevel&member_level=" + member_level +"&id="+ids,
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
        //取消会员
        function cancel_Member(){

            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            layer.confirm('确定选中项取消会员吗？',function(index){
                layer.close(index);
                var member_level = 0;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].id;
                    if(checkStatus.data[i].member_level == 0){
                        layer.msg("已经是非会员了！");
                        return false;
                    }
                }
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateMemberLevel&member_level=" + member_level +"&id="+ids,
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

        //删除
        function m_del(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            //你确定删除吗
            /* if(!confirm("已关联会员，无法删除")){
                 return;
             }*/
            layer.confirm('确定要删除选中的项吗？',function(index){
                layer.close(index);
                var del_status = 1;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].id;

                    if(checkStatus.data[i].parent_user_id != "" && checkStatus.data[i].parent_user_id !=0){
                        layer.msg("已关联会员，无法删除！");
                        return false;
                    }
                }
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=delMembers&del_status=" + del_status +"&id="+ids,
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
        //数据表格显示
        layui.use('table', function(){
            //    var table = layui.table;
            var table2 = layui.table;
            //搜索查询信息显示
            table2.render({
                elem: '#test2'
                ,url:'${pageContext.request.contextPath}/member?method=getMemberListPage'
                ,page: {
                    layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                    ,curr: 5 //设定初始在第 5 页
                    ,groups: 1 //只显示 1 个连续页码
                    ,first: false //不显示首页
                    ,last: false //不显示尾页

                }
                ,width: 1000
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
                ,page: true
            });
        });
        //添加地址信息
        function address_add(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount !=1){
                layer.msg("请选择一条数据！");
                return false;
            };
            var ids =checkStatus.data[0].id;
            layer.open({
                type: 2,
                title: '会员管理--地址信息',
                shadeClose: true,
                shade: false,
                maxmin: true, //开启最大化最小化按钮
                area: ['893px', '600px'],
                content: '${pageContext.request.contextPath}/member/address_add.jsp', //iframe的url，no代表不显示滚动条
                yes:function(id){

                },
                success: function(layero, index){
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/member?method=getMemberAddress",
                        data:{'id':ids} ,
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index);
                            var trObj = document.createElement("tr");
                            if (data.success == 1) {
                                var length = data.rs.length;
                                var array = data.rs;
                                //alert(JSON.stringify(array));
                                if(length ==0 ){
                                    alert("该会员没有地址信息！");
                                    return false
                                };
                                console.log(JSON.stringify(array))
                                for (var obj in array) {
                                    body.contents().find("#consignee").text(array[obj].consignee);
                                    body.contents().find("#address_name").text(array[obj].address_name);
                                    body.contents().find("#e_mail").text(array[obj].e_mail);
                                    body.contents().find("#phone").text(array[obj].phone);
                                    body.contents().find("#district_code").text(array[obj].district_code);
                                }
                            } else {
                                layer.msg("异常");
                            }
                        },error : function() {
                            layer.alert("错误");
                        }
                    })
                }
            });
        };
        //编辑会员信息
        function m_edit(){
            var table = layui.table;
            var checkStatus = table.checkStatus('test');
            var selectCount = checkStatus.data.length;
            if(selectCount!=1){
                layer.msg("只能选择一条数据！");
                return false;
            };
            var ids =checkStatus.data[0].id;
            layer.open({
                type: 2,
                title: '会员管理--会员编辑',
                shadeClose: true,
                shade: false,
                maxmin: true, //开启最大化最小化按钮
                area: ['893px', '600px'],
                btn: ['保存','取消'],
                content: '${pageContext.request.contextPath}/member/member_edit.jsp',
                yes:function(index){
                    var res = window["layui-layer-iframe" + index].selectFunc();//子窗口的方法
                    if(res =="pwdNotSame"){
                        layer.msg("密码错误，请重新输入！");
                        return false;
                    };
                    $.ajax({
                        url: "${pageContext.request.contextPath}/member?method=updataMember",
                        data: {'jsonData':JSON.stringify(res),'id':ids},
                        contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                        cache: true,
                        async : false,
                        dataType: "json",
                        success:function(data) {
                            if(data.success){
                                layer.msg('会员修改成功',{time:2000}, function(){
                                    window.parent.location.reload();
                                    parent.layer.closeAll('iframe');
                                });
                            }else{
                                layer.msg("异常");
                            }
                        },
                        error : function() {
                            layer.alert("错误");
                        }
                    });
                },
                success: function(layero, index){
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/member?method=selectUpdata",
                        data:{'id':ids} ,
                        dataType : "json",

                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var length = data.rs.length;
                                var array = data.rs;
                                //alert(JSON.stringify(array));
                                if(length ==0 ){
                                    alert("该会员没有详细信息！");
                                    return false
                                };
                                //  console.log(JSON.stringify(array))
                                body.contents().find("#id").val(array[0].id);
                                body.contents().find("#nick_name").val(array[0].nick_name);
                                body.contents().find("#e_mail").val(array[0].e_mail);
                                body.contents().find("#phone").val(array[0].phone);
                                body.contents().find("#account_number").val(array[0].account_number);
                                body.contents().find("#Invitation_code").val(array[0].Invitation_code);
                                body.contents().find("#member_level").val(array[0].member_level);
                                body.contents().find("#registration_time").val(array[0].registration_time);
                                body.contents().find("#source").val(array[0].source);
                                body.contents().find("#pwd").val(array[0].password);
                                body.contents().find("#pwd1").val(array[0].password);
                                body.contents().find("#sex").val(array[0].sex);
                            } else {
                                layer.msg("异常");
                            }
                        },error : function() {
                            layer.alert("错误");
                        }
                    })
                }
            });
        };
        //添加会员信息
        function m_add(){
            layer.open({
                type: 2,
                title: '会员管理--添加会员',
                shadeClose: true,
                shade: false,
                maxmin: true, //开启最大化最小化按钮
                area: ['893px', '600px'],
                content: ['${pageContext.request.contextPath}/member/member_add.jsp', 'yes'], //iframe的url，no代表不显示滚动条

            });
        };
        //点击会员姓名
        function Foo(obj){
//            alert(obj);
            layer.open({
                type: 2,
                title: '会员信息管理',
                shadeClose: true,
                shade: 0.8,
                area: ['900px', '75%'],
                content: '${pageContext.request.contextPath}/member/member_edit.jsp',
                success: function(layero, index){
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/member?method=selectUpdata",
                        data:{'id':obj} ,
                        dataType : "json",

                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var length = data.rs.length;
                                var array = data.rs;
//                                alert(JSON.stringify(array));
                                if(length ==0 ){
                                    alert("该会员没有详细信息！");
                                    return false
                                };
                                //    console.log(JSON.stringify(array))
                                body.contents().find("#id").val(array[0].id);
                                body.contents().find("#nick_name").val(array[0].nick_name);
                                body.contents().find("#e_mail").val(array[0].e_mail);
                                body.contents().find("#phone").val(array[0].phone);
                                body.contents().find("#account_number").val(array[0].account_number);
                                body.contents().find("#Invitation_code").val(array[0].Invitation_code);
                                body.contents().find("#member_level").val(array[0].member_level);
                                body.contents().find("#registration_time").val(array[0].registration_time);
                                body.contents().find("#source").val(array[0].source);
                                body.contents().find("#pwd").val(array[0].password);
                                body.contents().find("#pwd1").val(array[0].password);
                                body.contents().find("#sex").val(array[0].sex);
                            } else {
                                layer.msg("异常");
                            }
                        },error : function() {
                            layer.alert("错误");
                        }
                    })
                }
            });
        }
        //查看上级人员列表
        function look_member_top(ids){
            //  alert(ids);
            layer.open({
                type: 1
                ,title:'上级人员列表'
                ,id: 'layerDemo'
                ,area: ['60%', '65%']
                //,area: ['1000px', '320px']
                ,content:$('#look_member_top_select')
                ,shade: 0 //不显示遮罩
                //, btn: ['关闭']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(){
                    layer.closeAll();
                }
                ,success: function(data, index){
                    var table = layui.table;
                    table.render({
                        elem: '#look_member_t'
                        ,url:'${pageContext.request.contextPath}/member?method=selectMember&id='+ids
                        ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
                        ,cols: [[
                            {field:'nick_name',  title: '姓名', align: 'center'}
                            ,{field:'phone', title: '手机号', align: 'center'}
                            ,{field:'beInvite_date',  title: '邀请成功时间', align: 'center',templet: '#beInvite_timeTpl' }
                            ,{field:'registration_time', title: '注册时间',templet: '#create_timeTpl', align: 'center'}
                            ,{field:'status',  title: '状态',templet:'#statusTpl', align: 'center'}
                            ,{field:'wealth',  title: '操作',toolbar:"#barDemo1", align: 'center'}
                        ]]
                        ,response: {
                            statusName: 'success'
                            ,statusCode: 1
                            ,msgName: 'errorMessage'
                            ,countName: 'total'
                            ,dataName: 'rs'
                        }
                    });
                }
            })
        }
        //查看下级人员列表
        function look_member_bo(id){
            //alert(id);
            layer.open({
                type: 1
                ,title:'下级人员列表'
                ,id: 'layerDemo'
                ,area: ['60%', '65%']
                //,area: ['1000px', '500px']
                ,content:$('#look_member_bo_select')
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                //, btn: ['关闭']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,resize:false

                ,yes: function(){
                    layer.closeAll();
                }
                ,success: function(data, index){
                    var table = layui.table;
                    table.render({
                        elem: '#selectMemberDown1'
                        ,url:'${pageContext.request.contextPath}/member?method=selectMembers&id='+id
                        ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
                        ,height:500
                        ,cols: [[
                            {field:'nick_name',  title: '姓名',align: 'center'}
                            ,{field:'phone', title: '手机号',align: 'center'}
                            ,{field:'beInvite_date',  title: '邀请成功时间',align: 'center',templet: '#beInvite_timeTpl' }
                            ,{field:'registration_time', title: '注册时间',align: 'center',templet: '#create_timeTpl'}
                            ,{field:'status',  title: '状态',templet:'#statusTpl',align: 'center'}
                            ,{field:'wealth',  title: '操作',align:'center',toolbar:"#barDemo1"}
                        ]]
                        ,response: {
                            statusName: 'success'
                            ,statusCode: 1
                            ,msgName: 'errorMessage'
                            ,countName: 'total'
                            ,dataName: 'rs'
                        }
                        ,limit:20
                        ,limits:[20,50,100]
                        ,page: true
                    });
                    //点击按钮 搜索
                    $('#searchMember').on('click', function(){
                        var phone = $('#phones').val();
                        var status = $('#statuss').val();
                        table.reload('selectMemberDown1', {
                            page: {
                                curr: 1 //重新从第 1 页开始
                            }
                            ,where: {
                                phone: phone,
                                status: status,
                            }
                        });
                        return false;
                    });
                }
            });
        };

        //查看订单信息列表
        function look_orders(id){
            layer.open({
                type: 1
                ,title: '查看订单信息'
                ,offset: 'auto'
                ,id: 'listOrdersOpen'
                //,area: ['800px', '550px']
                ,area: ['70%','80%']
                ,content: $('#listOrdersDiv')
                //,btn: '关闭'
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //遮罩
                ,yes: function(){
                    layer.closeAll();
                }
                ,success: function (data) {   //层销毁后触发的回调
                    var tableOrder = layui.table;
                    tableOrder.render({
                        elem: '#listOrders'
                        ,height: 540
                        , url: '${ctx}/member?method=getMemberOrdersList&userId='+id
                        , response: {
                            statusName: 'success' //数据状态的字段名称，默认：code
                            , statusCode: 1  //成功的状态码，默认：0
                            , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                            , countName: 'total' //数据总数的字段名称，默认：count
                            , dataName: 'rs' //数据列表的字段名称，默认：data
                        }
                        //  , id: 'listOrders'
                        , limit: 20 //每页显示的条数
                        , limits: [20, 50, 100]
                        , page: true //开启分页
                        , cols: [[ //表头
                            // {type: 'checkbox', fixed: 'left', field: "ids"}
                            // , {field: 'id', width: 50, title: 'ID', fixed: 'left'}
                            {field: 'order_no', width: 180, title: '订单编号'}
                            ,{field: 'source_code', width: 100, title: '商品来源',templet:'#source_codeTpl'}
                            , {field: 'spu_code', width: 150, title: '商品编码'}
                            ,{field:'sku_name', width:258, title: '商品名称'}
                            ,{field:'sku_num', width:93, title: '数量'}
                            , {field: 'market_price', width: 99, title: '到手价',templet: '#market_priceTpl'}
                            , {field: 'backMoney', width: 98, title: '返现',templet: '#backMoneyTpl'}
                            , {field: 'created_date', width: 191, title: '下单时间',templet: '#created_dateTpl'}
                            , {field: 'status', width: 100, title: '状态',templet: '#orderStatusTpl'}
                            //  , {field: 'memo', width: 100, title: '备注'}
                            //  , {field: 'wealth', width: 230, fixed: 'right', align: 'center', title: '操作', toolbar: "#listGoodsBar"}
                        ]]
                    });
                    //点击按钮 搜索
                    $('#o_searchBtn').on('click', function(){
                        var order_no = $('#order_no').val();
                        var sku_name = $('#sku_name').val();
                        var order_status =$('#order_status').val();
                        tableOrder.reload('listOrders', {
                            page: {
                                curr: 1 //重新从第 1 页开始
                            }
                            ,where: {
                                order_no: order_no,
                                sku_name: sku_name,
                                order_status:order_status
                            }
                        });
                        return false;
                    });
                }

            });

            //获取订单中获取订单状态
            var from = layui.from;
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/member",
                data: "method=getMembersOrderStatusList",
                dataType: "json",
                success: function (data) {
                    if (data.success ==1) {
                        var array = data.result.rs;
                        if (array.length > 0) {
                            //  alert(array.length);
                            for (var obj in array) {
                                // alert(array[obj].dict_data_name );
                                $("#order_status").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</input>");
                            }
                        }
                        //(注意：需要重新渲染)
                        // alert("lllll")
                        form.render('select');
                        // renderForm();
                        //alert("dddddddddd")
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });
        };
        //点击会员启用按钮
        function enableaa(obj){
            //alert(obj);
            var table = layui.table;

            layer.confirm('确定要启用选中的项吗？',function(index){
                layer.close(index);
                var status =1;
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateStatus&status=" + status +"&id="+obj,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("look_member_t");
                            table.reload("selectMemberDown1")
                        } else {
                            layer.msg("异常");
                        }
                    }
                })
            });
        }
        //点击会员禁用按钮
        function disableaa(obj){
            var table = layui.table;
            layer.confirm('确定要禁用选中的项吗？',function(index){
                layer.close(index);
                var status =0;
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${pageContext.request.contextPath}/member",
                    data : "method=updateStatus&status=" + status +"&id="+obj,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("look_member_t");
                            table.reload("selectMemberDown1")

                        } else {
                            layer.msg("异常");
                        }
                    }
                })
            });
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
    </script>
    <%--查看上下级会员--%>
    <script type="text/html" id="barDemo">
        <a class="layui-btn" lay-event="detail" onclick="look_orders({{d.id}})"  style="height: 20px;line-height: 20px;width:100px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none" >查看订单信息</a>
        <a class="layui-btn" lay-event="edit"   onclick="look_member_top({{d.id}})"  style="height: 20px;line-height: 20px;width:100px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">查看上级会员</a>
        <a class="layui-btn"  onclick="look_member_bo({{d.id}})"  style="height: 20px;line-height: 20px;width:100px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">查看下级会员</a>
    </script>
    <%-- 转时间 --%>
    <script id="create_timeTpl" type="text/html">
        {{#  if(d.registration_time !== ''){ }}
        <%--<span style="color: rgba(10,10,10,0.46);">{{ d.registration_time.substr(0,2) }}</span>--%>
        <span style="color: rgba(10,10,10,0.46);">20{{ d.registration_time.substr(0,2) }}-{{ d.registration_time.substr(2,2) }}-{{ d.registration_time.substr(4,2) }} {{ d.registration_time.substr(6,2) }}:{{ d.registration_time.substr(8,2) }}:{{ d.registration_time.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
    </script>
    <%--获取用户名--%>
    <script type="text/html" id="usernameTpl">
        <a href="javascript:void(0)" onclick="Foo('{{d.id}}')" class="a" style="color: #003399">{{d.nick_name}}</a>
    </script>
    <%--改变状态--%>
    <script type="text/html" id="statusTpl">
        {{# if(d.status =='0'){}}
        <span style="color:#FF0000; ">禁用</span>
        {{# }else if(d.status =='1'){ }}
        启用
        {{# } }}
    </script>
    <%-- 会员类型--%>
    <script type="text/html" id="member_levelTpl">
        {{# if(d.member_level =='0'){}}
        <span style="color:#FF0000; ">非会员</span>
        {{# }else if(d.member_level =='1'){ }}
        <span style="color:green; ">会员</span>
        {{# } }}
    </script>
    <%--判断会员 --%>
    <script type="text/html" id="self_num">
        {{# if(d.self_num =='0'){}}
        非会员
        {{# }else if(d.member_level =='1'){ }}
        会员
        {{# } }}
    </script>
    <%--邀请码--%>
    <script type="text/html" id="Invitation_code">
        {{# if(d.Invitation_code1 ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.Invitation_code1}}
        {{# } }}
    </script>
    <%--账号--%>
    <script type="text/html" id="accountTpl">
        {{# if(d.account_number ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.account_number}}
        {{# } }}
    </script>
    <%--Email--%>
    <script type="text/html" id="EmialTpl">
        {{# if(d.e_mail ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.e_mail}}
        {{# } }}
    </script>
    <%--上级会员--%>
    <script type="text/html" id="sup_memberTpl">
        {{# if(d.sup_member_name ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.sup_member_name}}
        {{# } }}
    </script>
    <%--手机号--%>
    <script type="text/html" id="telPhoneTpl">
        {{# if(d.phone ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.phone}}
        {{# } }}
    </script>
    <%--注册来源--%>
    <script type="text/html" id="sourceTpl">
        {{# if(d.source ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{# if(d.source =='0'){}}
        App-ios
        {{# }else if(d.source =='1'){ }}
        小程序
        {{# }else if(d.source =='2'){ }}
        App-Android
        {{# }else if(d.source =='3'){ }}
        运营后台
        {{# } }}
        {{# } }}
    </script>
    <%--邀请时间转换--%>
    <script id="beInvite_timeTpl" type="text/html">
        {{#  if(d.beInvite_date !== ''){ }}
        <span style="color: rgba(10,10,10,0.46);">20{{ d.beInvite_date.substr(0,2) }}-{{ d.beInvite_date.substr(2,2) }}-{{ d.beInvite_date.substr(4,2) }} {{ d.beInvite_date.substr(6,2) }}:{{ d.beInvite_date.substr(8,2) }}:{{ d.beInvite_date.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
    </script>
    <%--订单时间转换--%>
    <script id="created_dateTpl" type="text/html">
        {{#  if(d.created_date !== ''){ }}
        <span style="color: rgba(10,10,10,0.46);">20{{ d.created_date.substr(0,2) }}-{{ d.created_date.substr(2,2) }}-{{ d.created_date.substr(4,2) }} {{ d.created_date.substr(6,2) }}:{{ d.created_date.substr(8,2) }}:{{ d.created_date.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
    </script>
    <%--订单状态--%>
    <script type="text/html" id="orderStatusTpl">
        {{# if(d.status ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{# if(d.status =='103'){}}
        待备货
        {{# }else if(d.status =='104'){ }}
        待发货
        {{# }else if(d.status =='101'){ }}
        待支付
        {{# }else if(d.status =='106'){ }}
        待提收
        {{# }else if(d.status =='107'){ }}
        已提收
        {{# }else if(d.status =='108'){ }}
        已完成
        {{# }else if(d.status =='110'){ }}
        已取消
        {{# }else if(d.status =='111'){ }}
        已取消
        {{# }else if(d.status =='113'){ }}
        已取消
        {{# }else if(d.status =='112'){ }}
        异常订单
        {{# }else if(d.status =='109'){ }}
        失效订单
        {{# } }}
        {{# } }}
    </script>
    <%--订单状态--%>
    <script type="text/html" id="source_codeTpl">
        {{# if(d.source_code ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{# if(d.source_code =='TB'){}}
        代购自营
        {{# }else if(d.source_code =='LB'){ }}
        礼包
        {{# }else if(d.source_code =='smimi'){ }}
        史蒂芬
        {{# }else if(d.source_code =='redbook'){ }}
        小红书
        {{# }else if(d.source_code =='tmall'){ }}
        天猫
        {{# }else if(d.source_code =='alibaba'){ }}
        阿里
        {{# }else if(d.source_code =='xiaohongshu'){ }}
        小红书
        {{# }else if(d.source_code =='jingdong'){ }}
        京东
        {{# }else if(d.source_code =='taobao'){ }}
        淘宝
        {{# } }}
        {{# } }}
    </script>
    <%--到手价--%>
    <script type="text/html" id="market_priceTpl">
        {{# if(d.market_price ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.market_price /100}}
        {{# } }}
    </script>
    <%--返现--%>
    <script type="text/html" id="backMoneyTpl">
        {{# if(d.backMoney ==''){}}
        <span style="color: rgba(10,10,10,0.46);"> ----</span>
        {{# }else { }}
        {{d.backMoney /10000}}
        {{# } }}
    </script>
</head>
<script type="text/html" id="barDemo1">
    <%-- <a class="layui-btn layui-btn-primary layui-btn-xs"  onclick="disableaa({{d.id}})">禁用</a>
     <a class="layui-btn layui-btn-xs" onclick="enableaa({{d.id}})">启用</a>--%>
    {{#  if(d.status == '0'){ }}
    <a class="layui-btn layui-btn-primary layui-btn-xs "  onclick="enableaa({{d.id}})">启用</a>
    {{#  } else { }}
    <a class="layui-btn layui-btn-xs" onclick="disableaa({{d.id}})">禁用</a>
    {{#  } }}

</script>

<!--主体部分 -->
<div class="layui-body">

    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            会员列表
        </div>

        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">账号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nick_name" id="account_number" autocomplete="off"
                               class="layui-input">
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline" >
                            <select id="status" name="status" lay-filter="statusI">
                                <option value=""></option>
                                <option value="1">启用</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">注册来源</label>
                        <div class="layui-input-inline"  >
                            <select name="source" id="source" lay-filter="aihao">
                                <option value=""></option>
                                <option value="0">App-ios</option>
                                <option value="2">App-android</option>
                                <option value="1">小程序</option>
                                <option value="3">运营后台</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">是否为会员</label>
                        <div class="layui-input-inline" >
                            <select id="member_level" name="member_level">
                                <option value=""></option>
                                <option value="1">会员</option>
                                <option value="0">非会员</option>
                            </select>
                        </div>
                    </div>

                    <%--<div class="layui-input-inline">--%>
                    <%--<input type="checkbox" id="showStopSale" name="showStopSale" value="" title="有停售规格">--%>
                    <%--</div>--%>
                </div>

                <div class="layui-form-item" style="margin-bottom: 0">


                    <label class="layui-form-label">注册手机号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="phone" id="phone" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label"  >注册日期</label>
                    <div class="layui-input-inline" >
                        <input name="registration_time" id="registration_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="endDate" id="endDate" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <button id="searchBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置</button>


                </div>

            </div>


        </form>
        <div style="margin-top: 5px">
            <button class="layui-btn layui-btn-sm" onclick="disable()"><i class="layui-icon">&#x1007;</i>禁用</button>
            <button class="layui-btn layui-btn-sm" onclick="enable()"><i class="layui-icon">&#xe610;</i>启用</button>
            <button class="layui-btn layui-btn-sm" onclick="address_add()"><i class="layui-icon">&#xe715;</i>地址信息</button>
            <button class="layui-btn layui-btn-sm" onclick="m_edit()"><i class="layui-icon">&#xe642;</i>编辑</button>
            <button class="layui-btn layui-btn-sm" onclick="m_del()"><i class="layui-icon">&#xe640;</i>删除</button>
            <button class="layui-btn layui-btn-sm" onclick="m_add()"><i class="layui-icon">&#xe61f;</i>添加</button>
            <button class="layui-btn layui-btn-sm" onclick="become_Member()"><i class="layui-icon">&#xe63c;</i>成为会员</button>
            <button class="layui-btn layui-btn-sm" onclick="cancel_Member()"><i class="layui-icon">&#xe63c;</i>取消会员</button>
        </div>
        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="useruv"></table>
    </div>





    <%--查看上级会员信息--%>
    <div id="look_member_top_select" style="margin-top:0;display: none;">
        <table class="layui-hide" id="look_member_t"></table>
    </div>
    <%--查看下级会员信息--%>
    <div id="look_member_bo_select" style="display: none;">
        <form class="layui-form">
            <div class="layui-inline">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block" style="width:90px;">
                    <select name="status" id="statuss">
                        <option value=""></option>
                        <option value="0">禁用</option>
                        <option value="1">启用</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">名称/手机</label>
                <div class="layui-inline">
                    <input type="text" name="phone" id="phones" placeholder="请输入名称和手机号" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-sm" style=" margin-top:10px;margin-left:10px;"
                            id="searchMember"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button type="reset" class="layui-btn layui-btn-sm" style=" margin-top:10px;margin-left:10px;">
                        <i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </div>
            <%--搜索查询信息显示--%>
            <table class="layui-hide" id="selectMemberDown1"></table>
        </form>
        <script>
            //Demo
            layui.use('form', function () {
                var form = layui.form;
                //监听提交
                form.on('submit(formDemo)', function (data) {
                    layer.msg(JSON.stringify(data.field));
                    return false;
                });
            });
        </script>
    </div>

    <%--    <div style="padding: 20px 100px;height:100px; display: none;" id="textarea_add">
            <textarea name="textarea" id="area1" cols="30" rows="10"></textarea>
            可以设置通配符，每个关键字一行，可使用通配符 "*"   如 "*admin*"(不含引号)。
        </div>--%>


    <!-- 查看订单信息 start -->
    <div id="listOrdersDiv" style="display: none;padding: 15px;">
        <form class="layui-form" id="listOrdersForm">
            <div style="background-color:#f2f2f2;">
                <div class="layui-form-item" style="padding: 15px;">
                    <label class="layui-label">订单编号</label>
                    <div class="layui-inline">
                        <input type="text" id="order_no" name="order_no" lay-verify="title" autocomplete="off"
                               placeholder="" class="layui-input">
                    </div>
                    <label class="layui-label">商品名称</label>
                    <div class="layui-inline">
                        <input type="text" id="sku_name" name="sku_name" lay-verify="title" autocomplete="off"
                               placeholder="" class="layui-input">
                    </div>
                    <label class="layui-label">订单状态</label>
                    <div class="layui-inline" style="width:150px;">
                        <select id="order_status" name="order_status">
                            <option value="">请选择</option>
                            <option value="103">待备货</option>
                            <option value="104">待发货</option>
                            <option value="101">待支付</option>
                            <option value="106">待提收</option>
                            <option value="107">已提收</option>
                            <option value="108">已完成</option>
                            <option value="110">已取消（待支付）</option>
                            <option value="111">已取消（申请退款）</option>
                            <option value="113">已取消（售后取消）</option>
                            <option value="109">失效订单</option>
                        </select>
                    </div>
                    <div class="layui-inline">
                        <button id="o_searchBtn" class="layui-btn layui-btn-sm" lay-submit="" lay-filter="demo1"><i
                                class="layui-icon">&#xe615;</i>搜索</button>
                        <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置
                        </button>
                    </div>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="listOrders" lay-filter="listOrdersFilter"></table>
        <!-- 查看订单信息 end -->
    </div>
    <%@ include file="/common/footer.jsp"%>
