<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/common.jsp" %>
<%@ include file="/advertising/advertising_memu.jsp"%>

<script>

    //JavaScript代码区域
    layui.use(['element','laydate','table'], function(){
        var element = layui.element;
        var laydate = layui.laydate;
        var table = layui.table;
        laydate.render({
            elem: '#edit_time'
            ,type: 'datetime'
        });
        laydate.render({
            elem: '#editend_time'
            ,type: 'datetime'
        });
        table.render({
            elem: '#test'
            ,url:'${pageContext.request.contextPath}/advertising?method=getUrlList'
            //,width: 1900
            ,height: 580
            ,cols: [[
                {type:'checkbox',fixed: 'left'}
                ,{field:'id', width:60, title: 'ID',align:'center',fixed: 'left',sort: true}
                ,{field:'advertlink_name', width:180, title: '广告位链接名称',align:'center',fixed: 'left'}
                ,{field:'remarks', width:220, title: '备注',align:'center',fixed: 'left'}
                ,{field:'url_link', width:180, title: 'URL链接',align:'center',fixed: 'left'}
                ,{field:'category', width:120, title: 'URL类型',align:'center',fixed: 'left',templet: '#Category_status'}
                ,{field:'operator', width:120, title: '最后操作人',align:'center',fixed: 'left'}
                ,{field:'edit_time', width:180, title: '最后操作时间',align:'center',fixed: 'left',sort: true,templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'status', width:150, title: '状态',align:'center',fixed: 'left',templet: '#StatusAdvertUrl'}
                ,{fixed:'right',title:'操作', width:200,align:'center',fixed: 'left', toolbar: "#barDemo"}
            ]]
            ,id: 'listTable'
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
        $('#sreachBtn').on('click', function(){
            var operator = $('#operator').val();
            var advertlink_name = $('#advertlink_name').val();
            var edit_time = $('#edit_time').val();
            var editend_time = $('#editend_time').val();
            if(CompareDate(edit_time,editend_time)){
                layer.msg("开始时间不能大于结束时间");
                return false;
            }
            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    operator: operator,
                    advertlink_name: advertlink_name,
                    edit_time: edit_time,
                    editend_time: editend_time
                }
            });
            return false;
        });

        //批量启用
        $('#status_open').on('click', function(){
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定启用链接吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/advertising",
                        data: "method=updateAdvertUrlStatus&status=1&ids=" + ids,
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
                    })
                });
            }
            return false;
        });

        //批量停用
        $('#status_shut').on('click', function(){
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定停用链接吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/advertising",
                        data: "method=updateAdvertUrlStatus&status=2&ids=" + ids,
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
                    })
                });
            }
            return false;
        });

        $('#add_url').on('click', function (){
            layer.open({
                type: 1
                , title: '编辑'
                , id: 'layerDemo'
                , area: ['600px','600px']
                , content: $('#NewUrlPage')
                , btn: ['保存','取消']
                , btnAlign: 'c' //按钮居中
                , shade: 0 //不显示遮罩
                , yes: function (data) {
                    var advertlink_name = $("#add_advertlink_name").val();
                    var url_link = $("#add_url_link").val();
                    var remarks = $("#add_remarks").val();
                    var category = $("#category").val();
                    if(advertlink_name ==""){
                        layer.msg('请输入广告链接名称');
                    }else if(url_link ==""){
                        layer.msg('请输入广告链接');
                    }else if(category ==""){
                        layer.msg('请选择链接类型');
                    }else{
                        $.ajax({
                            type: "get",
                            async: false, // 同步请求
                            cache: true,// 不使用ajax缓存
                            contentType: "application/json",
                            url: "${ctx}/advertising?method=addAdvertUrl",
                            data: {
                                "advertlink_name": advertlink_name,
                                "url_link":url_link,
                                "remarks":remarks,
                                "category":category
                            },

                            dataType: "json",
                            success: function (data) {
                                if (data.success) {
                                    advert_url_id = data.result.ids;
                                    layer.msg('编辑成功',{time: 1000}, function () {
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

                }
                ,btn2:function () {
                    layer.closeAll();

                }
            });
        });

        table.on('tool(picuresList)', function(obj){
            var data = obj.data;
            if (obj.event === 'urlEdit') {

                var index = layer.open({
                    type: 1
                    , title: '编辑'
                    , id: 'layerDemo'
                    , area: ['600px','600px']
                    , content: $('#UpdateUrlPage')
                    , btn: ['保存','取消']
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //不显示遮罩
                    , yes: function (data) {
                        var return_advertlink_name = $("#return_advertlink_name").val();
                        var return_url_link = $("#return_url_link").val();
                        var return_remarks = $("#return_remarks").val();
                        var return_category = $("#return_category").val();
                        var return_id = $("#return_id").val();
                        $.ajax({
                            type: "get",
                            async: false, // 同步请求
                            cache: true,// 不使用ajax缓存
                            contentType: "application/json",
                            url: "${ctx}/advertising?method=updateAdvertUrl",
                            data: {
                                "advertlink_name": return_advertlink_name,
                                "url_link":return_url_link,
                                "remarks":return_remarks,
                                "category":return_category,
                                "id":return_id
                            },

                            dataType: "json",
                            success: function (data) {
                                if (data.success) {
                                    layer.msg('编辑成功',{time: 1000}, function () {
                                        layer.close(index);
                                        table.reload("listTable");
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
                    ,btn2:function () {
                        var index=parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                    }

                    ,success:function () {

                    }


                });
                $("#return_advertlink_name").val(data.advertlink_name);
                $("#return_url_link").val(data.url_link);
                $("#return_remarks").val(data.remarks);
                $("#return_category").val(data.category);
                layui.form.render();

                $("#return_id").val(data.id);

            }
            if (obj.event === 'urlDelete') {

                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/advertising",
                    data: "method=delAdvertUrl&id=" + data.id,
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
                })
            }
        });

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
    function CompareDate(d1,d2){
        return ((new Date(d1.replace(/-/g,"\/"))) > (new Date(d2.replace(/-/g,"\/"))));
    }

</script>
<%--链接状态--%>
<script type="text/html" id="StatusAdvertUrl">
    {{# if(d.status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.status =='1'){}}
    启用
    {{# }else if(d.status =='2'){ }}
    停用
    {{# } }}
    {{# } }}
</script>

<script type="text/html" id="Category_status">
    {{# if(d.category ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.category =='1'){}}
    商品详情页
    {{# }else if(d.category =='2'){ }}
    栏目列表
    {{# }else if(d.category =='3'){ }}
    活动页面
    {{# } }}
    {{# } }}
</script>

<!-- 操作 -->
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="urlEdit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="urlDelete">删除</a>
</script>


<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            广告链接库
        </div>

        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">最后操作人</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operator" id="operator" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label" style="width: 150px">广告位链接名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="advertlink_name" id="advertlink_name" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label" style="width: 120px">最后操作时间</label>
                    <div class="layui-input-inline" >
                        <input name="edit_time" id="edit_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="editend_time" id="editend_time" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" id="sreachBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>

                </div>

            </div>

        </form>
        <div style="margin-top: 5px">
            <button id="status_open" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>启用</button>
            <button id="status_shut" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>停用</button>
            <button id="add_url" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>新增</button>
        </div>

        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="picuresList"></table>

    </div>

    <!-- 编辑链接 -->
    <div id="UpdateUrlPage" style="display: none; padding: 15px;">
        <form class="layui-form layui-form-pane" action="">

            <div class="layui-form-item">

                <label class="layui-form-label" style="width: 150px">ID</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_id" id="return_id" lay-verify="title" readonly="readonly">
                </div>

                <label class="layui-form-label" style="width: 150px">广告链接名称</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_advertlink_name" id="return_advertlink_name" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">备注</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_remarks" id="return_remarks" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">URL链接</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_url_link" id="return_url_link" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">URL类型</label>
                <div class="layui-input-inline" >
                    <select id="return_category" name="return_category" >
                        <%--<option value="">请选择</option>--%>
                        <option value="1">商品详情页</option>
                        <option value="2">栏目列表</option>
                        <option value="3">活动页面</option>
                    </select>

                </div>



            </div>

        </form>
    </div>

    <!-- 新建链接 -->
    <div id="NewUrlPage" style="display: none; padding: 15px;">
        <form class="layui-form layui-form-pane" action="">

            <div class="layui-form-item">

                <label class="layui-form-label" style="width: 150px">广告链接名称</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="add_advertlink_name" id="add_advertlink_name" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">备注</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="add_remarks" id="add_remarks" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">URL链接</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="add_url_link" id="add_url_link" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">URL类型</label>
                <div class="layui-input-inline" >
                    <select id="category" name="category">
                        <option value="">请选择类型</option>
                        <option value="1">商品详情页</option>
                        <option value="2">栏目列表</option>
                        <option value="3">活动页面</option>
                    </select>

                </div>

            </div>

        </form>
    </div>

</div>
<%@ include file="/common/footer.jsp"%>
