<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/header.jsp"%>
<%@include file="member_menu.jsp"%>

<script>

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use(['table'], function(){
        var table = layui.table;
        //默认返佣规则
        table.render({
            elem: '#DefaultDistributionInfoTable'
            ,url:'${ctx}/distrbution?method=defaultDistributionInfoList'
            ,height:300
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,cols: [[
                {type:'numbers',fixed: 'true'}
                ,{field: 'dis_name', title: '返佣名称', width:297,align: 'center'}
                ,{field: 'member', title: '会员类型', width:100,align: 'center',templet: '#memberTpl'}
                ,{field: 'top', title: '顶级', width:100,align: 'center',templet: '#topTpl'}
                ,{field: 'parent', title: '父级', width:100,align: 'center',templet: '#parentTpl'}
                ,{field: 'self', title: '子级', width: 100,align: 'center',templet: '#selfTpl'}
                ,{field: 'create_user', title: '创建人', width: 100,align: 'center'}
                ,{field: 'create_time', title: '创建时间', width: 200,align: 'center'}
                ,{field: 'edit_user', title: '操作人', width: 100,align: 'center'}
                ,{field: 'edit_time', title: '操作时间', width: 200,align: 'center'}
                ,{fixed:'right',title:'操作', width:250,align:'center',toolbar:"#DefaultDistributionInfoManage"}
            ]]
            ,id:'DefaultDistributionInfoTab'
        });

        //非默认返佣规则
        table.render({
            elem: '#NotDefaultDistributionInfoTab'
            ,url:'${ctx}/distrbution?method=noDefaultDistributionInfoList'
            ,height:300
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,cols: [[
                {type:'numbers',fixed: 'true'}
                ,{field: 'dis_name', title: '返佣名称', width:297,align: 'center'}
                ,{field: 'member', title: '会员类型', width:100,align: 'center',templet: '#memberTpl'}
                ,{field: 'top', title: '顶级', width:100,align: 'center',templet: '#topTpl'}
                ,{field: 'parent', title: '父级', width:100,align: 'center',templet: '#parentTpl'}
                ,{field: 'self', title: '子级', width: 100,align: 'center',templet: '#selfTpl'}
                ,{field: 'create_user', title: '创建人', width: 100,align: 'center'}
                ,{field: 'create_time', title: '创建时间', width: 200,align: 'center'}
                ,{field: 'edit_user', title: '操作人', width: 100,align: 'center'}
                ,{field: 'edit_time', title: '操作时间', width: 200,align: 'center'}
                ,{fixed:'right',title:'操作', width:250,align:'center',toolbar:"#NotDefaultDistributionInfoManage"}
            ]]
            ,id:'NotDefaultDistributionInfoTab'
        });

        //默认返佣规则_监听工具条
        table.on('tool(DefaultDistributionInfoFilter)', function(obj){
            var data = obj.data;
            if(obj.event === 'Default_Detail'){
                DefaultDistributionInfo_Detail(data)
            } else if(obj.event === 'Default_Edit'){
                DefaultDistributionInfo_Edit(data)
            } else if(obj.event === 'Default_Del'){
                layer.confirm('确认删除吗？', function(index){
                    DefaultDistributionInfo_Del(data);
                });
            }
        });
        //默认返佣规则_查看
        function DefaultDistributionInfo_Detail(obj){
            layer.open({
                type: 2
                ,title:'设置默认分销值'
                ,area: ['613px', '500px']
                ,content: 'defaultDistributionDetailInfo.jsp'
                ,btn: ['取消']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,moveType: 0 //拖拽模式，0或者1
                ,resize:false
                ,yes: function (index, layero) {
                    layer.closeAll();
                },
                success:function (layero, index) {
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=getDefaultDistributionDetailInfo",
                        data:{'id':obj.id} ,   //批量处理 status=2 移入回收站
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var array = data.rs;
                                for (var obj in array) {
                                    body.contents().find('#member_type').val(array[obj].member);
                                    body.contents().find("#dis_name").val(array[obj].dis_name);
                                    body.contents().find("#top_level_ratio").val(array[obj].top);
                                    body.contents().find("#parent_ratio").val(array[obj].parent);
                                    body.contents().find("#child_ratio").val(array[obj].self);
                                    body.contents().find('#member_type').attr("disabled","disabled");
                                    body.contents().find('#dis_name').attr("disabled","disabled");
                                    body.contents().find('#top_level_ratio').attr("disabled","disabled");
                                    body.contents().find('#parent_ratio').attr("disabled","disabled");
                                    body.contents().find('#child_ratio').attr("disabled","disabled");
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
        //默认返佣规则_编辑
        function DefaultDistributionInfo_Edit(obj){
            layer.open({
                type: 2
                ,title:'设置默认分销值'
                ,area: ['613px', '500px']
                ,content: 'defaultDistributionDetailInfo.jsp'
                ,btn: ['确认','取消']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,moveType: 0 //拖拽模式，0或者1
                ,resize:false
                ,yes: function (index, layero) {
                    var res = window["layui-layer-iframe" + index].selectFunc();//子窗口的方法
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=upDefaultDistributionDetailInfo",
                        data:{'jsonString':JSON.stringify(res),'id':obj.id,'member':obj.member},
                        dataType : "json",
                        success : function(data){
                            if (data.success==1) {
                                layer.closeAll();
                                table.reload("DefaultDistributionInfoTab");
                                layer.msg('编辑成功');
                                return false;
                            }
                        }
                    });
                }
                ,success:function (layero, index) {
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=getDefaultDistributionDetailInfo",
                        data:{'id':obj.id} ,   //批量处理 status=2 移入回收站
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var array = data.rs;
                                for (var obj in array) {
                                    body.contents().find('#member_type').val(array[obj].member);
                                    body.contents().find("#dis_name").val(array[obj].dis_name);
                                    body.contents().find("#top_level_ratio").val(array[obj].top);
                                    body.contents().find("#parent_ratio").val(array[obj].parent);
                                    body.contents().find("#child_ratio").val(array[obj].self);
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
        //默认返佣规则_删除
        function DefaultDistributionInfo_Del(obj){
             $.ajax({
                 type: "get",
                 async : false, // 同步请求
                 cache :true,// 不使用ajax缓存
                 contentType : "application/json",
                 url : "${ctx}/distrbution?method=delDefaultDistributionInfo",
                 data:{'id':obj.id} ,
                 dataType : "json",
                 success : function(data){
                     if (data.success == 1) {
                         layer.closeAll();
                         table.reload("DefaultDistributionInfoTab");
                         layer.msg("删除成功！");
                         return false;
                     }
                     else {
                         layer.closeAll();
                        layer.msg("异常");
                         return false;
                      }
                 },
                 error : function() {
                     layer.closeAll();
                     layer.alert("错误");
                     return false;
                 }
             });

        }




        // //监听工具条
        table.on('tool(NotDefaultDistributionInfoFilter)', function(obj){
            var data = obj.data;
            if(obj.event === 'NotDefault_Detail'){
                NotDefaultDistributionInfo_Detail(data,obj.event)
            } else if(obj.event === 'NotDefault_Edit'){
                NotDefaultDistributionInfo_Edit(data,obj.event)
            } else if(obj.event === 'NotDefault_Del'){
                layer.confirm('确认删除吗？', function(index){
                    NotDefaultDistributionInfo_Del(data);
                    layer.close(index);
                });
            }
        });

        //非默认返佣规则_查看
        function NotDefaultDistributionInfo_Detail(obj){
            layer.open({
                type: 2
                ,title:'设置分销值'
                ,area: ['613px', '500px']
                ,content: 'noDefaultDistributionDetailInfo.jsp'
                ,btn: ['取消']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,moveType: 0 //拖拽模式，0或者1
                ,resize:false
                ,yes: function (index, layero) {
                    layer.closeAll();
                },
                success:function (layero, index) {
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=getDefaultDistributionDetailInfo",
                        data:{'id':obj.id} ,   //批量处理 status=2 移入回收站
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var array = data.rs;
                                for (var obj in array) {
                                    body.contents().find('#member_type').val(array[obj].member);
                                    body.contents().find("#dis_name").val(array[obj].dis_name);
                                    body.contents().find("#top_level_ratio").val(array[obj].top);
                                    body.contents().find("#parent_ratio").val(array[obj].parent);
                                    body.contents().find("#child_ratio").val(array[obj].self);
                                    body.contents().find('#member_type').attr("disabled","disabled");
                                    body.contents().find('#dis_name').attr("disabled","disabled");
                                    body.contents().find('#top_level_ratio').attr("disabled","disabled");
                                    body.contents().find('#parent_ratio').attr("disabled","disabled");
                                    body.contents().find('#child_ratio').attr("disabled","disabled");
                                    break;
                                }
                            }
                            else {
                                layer.msg("异常");
                                return false;
                            }
                        },
                        error : function() {
                            layer.alert("错误");
                            return false;
                        }
                    });
                }
            });
        }
        //非默认返佣规则_编辑
        function NotDefaultDistributionInfo_Edit(obj){
            layer.open({
                type: 2
                ,title:'设置默认分销值'
                ,area: ['613px', '500px']
                ,content: 'noDefaultDistributionDetailInfo.jsp'
                ,btn: ['确认','取消']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,moveType: 0 //拖拽模式，0或者1
                ,resize:false
                ,yes: function (index, layero) {
                    var res = window["layui-layer-iframe" + index].selectFunc();//子窗口的方法
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=upNoDefaultDistributionDetailInfo",
                        data:{'jsonString':JSON.stringify(res),'id':obj.id,'member':obj.member},
                        dataType : "json",
                        success : function(data){
                            if (data.success==1) {
                                layer.closeAll();
                                table.reload('NotDefaultDistributionInfoTab');
                                layer.msg('编辑成功');
                                return false;

                            }
                        },error:function () {
                            layer.closeAll();
                            table.reload('NotDefaultDistributionInfoTab');
                            layer.msg('编辑失败');
                            return false;
                        }
                    });
                }
                ,success:function (layero, index) {
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=getDefaultDistributionDetailInfo",
                        data:{'id':obj.id} ,   //批量处理 status=2 移入回收站
                        dataType : "json",
                        success : function(data){
                            var body = layer.getChildFrame('body', index); //巧妙的地方在这里哦
                            if (data.success == 1) {
                                var array = data.rs;
                                for (var obj in array) {
                                    body.contents().find('#member_type').val(array[obj].member);
                                    body.contents().find("#dis_name").val(array[obj].dis_name);
                                    body.contents().find("#top_level_ratio").val(array[obj].top);
                                    body.contents().find("#parent_ratio").val(array[obj].parent);
                                    body.contents().find("#child_ratio").val(array[obj].self);
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
        //非默认返佣规则_删除
        function NotDefaultDistributionInfo_Del(obj){
            $.ajax({
                type: "get",
                async : false, // 同步请求
                cache :true,// 不使用ajax缓存
                contentType : "application/json",
                url : "${ctx}/distrbution?method=delDefaultDistributionInfo",
                data:{'id':obj.id} ,
                dataType : "json",
                success : function(data){
                    if (data.success == 1) {
                        layer.closeAll();
                        table.reload('NotDefaultDistributionInfoTab');
                        layer.msg("删除成功！");
                        return false;
                    }
                    else {
                        layer.closeAll();
                        table.reload('NotDefaultDistributionInfoTab');
                        layer.msg("异常");
                        return false;
                    }
                },
                error : function() {
                    layer.closeAll();
                    table.reload('NotDefaultDistributionInfoTab');
                    layer.alert("错误");
                    return false;
                }
            });

        }

        var $ = layui.$, active = {
            //默认返佣规则_添加
            DefaultDistributionInfo_Add:function () {
                layer.open({
                    type: 2
                    ,id: 'DefaultDistributionInfo_AddOPEN' //设定一个id，防止重复弹出
                    ,skin: 'layui-layer-demo' //样式类名
                    ,title:'设置默认分销值'
                    ,area: ['613px', '500px']
                    ,content: 'defaultDistributionDetailInfo.jsp'
                    ,btn: ['确认','取消']
                    ,btnAlign: 'r' //按钮居中
                    ,shade: 0 //不显示遮罩
                    ,resize:false
                    ,yes: function (index, layero) {
                        var res = JSON.stringify(window["layui-layer-iframe" + index].selectFunc());//子窗口的方法
                        $.ajax({
                            type: "get",
                            async : false, // 同步请求
                            cache :true,// 不使用ajax缓存
                            contentType : "application/json",
                            url : "${ctx}/distrbution?method=addDefaultDistributionValSet",
                            data:{'jsonString':res},
                            dataType : "json",
                            success : function(data){
                                if (data.success) {
                                    layer.closeAll();
                                    table.reload("DefaultDistributionInfoTab");
                                    layer.msg('添加成功');
                                    return false;
                                }else{
                                    layer.closeAll();
                                    table.reload("DefaultDistributionInfoTab");
                                    layer.msg('添加失败');
                                    return false;
                                }
                            }
                            ,error:function () {
                                layer.closeAll();
                                table.reload("DefaultDistributionInfoTab");
                                layer.msg('添加失败');
                                return false;
                            }
                        });
                    }
                    ,btn2: function(){
                        layer.closeAll();
                    }
                });
            },
            //非默认返佣规则_添加
            NotDefaultDistributionInfo_Add:function(){
            layer.open({
                type: 2
                ,id:'NotDefaultDistributionInfo_AddOPEN'
                ,skin: 'layui-layer-demo' //样式类名
                ,title:'设置默认分销值'
                ,area: ['613px', '500px']
                ,content: 'noDefaultDistributionDetailInfo.jsp'
                ,btn: ['确认','取消']
                ,btnAlign: 'r' //按钮居中
                ,shade: 0 //不显示遮罩
                ,resize:false
                ,yes: function (index, layero) {
                    var res = JSON.stringify(window["layui-layer-iframe" + index].selectFunc());//子窗口的方法
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${ctx}/distrbution?method=addNotDefaultDistributionValSet",
                        data:{'jsonString':res},
                        dataType : "json",
                        success : function(data){
                            if (data.success) {
                                layer.closeAll();
                                table.reload("NotDefaultDistributionInfoTab");
                                layer.msg('添加成功');
                            }else{
                                layer.closeAll();
                                table.reload("NotDefaultDistributionInfoTab");
                                layer.msg('添加失败');
                            }
                        },
                        error:function () {
                            layer.closeAll();
                            table.reload("NotDefaultDistributionInfoTab");
                            layer.msg('添加失败');
                        }
                    });
                }
                ,btn2: function(){
                    layer.closeAll();
                }
            });
        }
        }

        $('.DefaultDistributionInfo_AddDiv .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        $('.NotDefaultDistributionInfo_AddDiv .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });
</script>
<script type="text/html" id="memberTpl">
    {{#  if(d.member === '1'){ }}
    <span style="color: #0C0C0C;">会员</span>
    {{#  } else { }}
    <span style="color: #0C0C0C;">非会员</span>
    {{#  } }}
</script>
<script type="text/html" id="topTpl">
    {{#  if(d.top === '' || d.top === '0'){ }}
    <span style="color: #0C0C0C;">---</span>
    {{#  } else { }}
    <span style="color: #0C0C0C;">{{ d.top }}%</span>
    {{#  } }}
</script>
<script type="text/html" id="parentTpl">
    {{#  if(d.parent === '' || d.parent === '0'){ }}
    <span style="color: #0C0C0C;">---</span>
    {{#  } else { }}
    <span style="color: #0C0C0C;">{{ d.parent }}%</span>
    {{#  } }}
</script>
<script type="text/html" id="selfTpl">
    {{#  if(d.self === '' || d.self === '0'){ }}
    <span style="color: #0C0C0C;">---</span>
    {{#  } else { }}
    <span style="color: #0C0C0C;">{{ d.self }}%</span>
    {{#  } }}
</script>

<script type="text/html" id="DefaultDistributionInfoManage">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="Default_Detail" >查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="Default_Edit" >编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="Default_Del">删除</a>
</script>
<script type="text/html" id="NotDefaultDistributionInfoManage">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="NotDefault_Detail" >查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="NotDefault_Edit" >编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="NotDefault_Del">删除</a>
</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div class="layui-row">
        <div  class="layui-elem-quote" style="background-color: #EEEEEE ;height: 30px;margin-top: 10px;margin-left: 10px">
            <label style="margin-left: 1% ; line-height: 30px" >分销规则设置</label>
        </div>
        <div style="background-color: #EEEEEE ;margin-left: 10px;line-height: 30px">
            <label style="font-size: 18px;margin-left: 2% ; line-height: 10px" >提示：</label>
            <label style=" line-height: 10px;color: #eb7350"  >没有设置等级的分销商将按默认设置计算提成。商品指定的佣金金额的优先级仍是最高的，也就是说只要商品指定了佣金金额就按商品的佣金金额来计算，不受会员等级影响。</label>
        </div>
        <div class="DefaultDistributionInfo_AddDiv" style="margin-top: 10px">
            <button style="margin-left: 1% ;margin-bottom:5px;" class="layui-btn layui-btn-sm" data-type="DefaultDistributionInfo_Add">设置默认分销值</button>
        </div>
        <div style="margin-left: 1%;width: 1600px;margin-top: -10px">
            <table class="layui-table" id="DefaultDistributionInfoTable" lay-filter="DefaultDistributionInfoFilter" ></table>
        </div>
    </div>
    <div>
        <div class="NotDefaultDistributionInfo_AddDiv">
            <button style="margin-left: 1% ; margin-bottom:5px;" class="layui-btn layui-btn-sm"  data-type="NotDefaultDistributionInfo_Add">自定义分销值</button>
        </div>
        <div style="margin-left: 1%;width: 1600px;margin-top: -10px">
            <table class="layui-table" id="NotDefaultDistributionInfoTab"  style="visibility: hidden" lay-filter="NotDefaultDistributionInfoFilter" ></table>
        </div>
    </div>
</div>
<div class="layui-footer">
    <%@ include file="/common/footer.jsp"%>
</div>