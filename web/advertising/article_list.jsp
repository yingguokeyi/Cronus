<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/advertising/advertising_memu.jsp"%>
<head>
    <title>文章列表</title>

    <script>
        //JavaScript代码区域
        layui.use(['element','laydate','table'], function(){
            var element = layui.element;
            var laydate = layui.laydate;
            var table = layui.table;
            laydate.render({
                elem: '#start_time'
                ,type: 'datetime'
            });
            laydate.render({
                elem: '#end_time'
                ,type: 'datetime'
            });
            laydate.render({
                elem: '#stime'
                ,type: 'datetime'
            });
            laydate.render({
                elem: '#etime'
                ,type: 'datetime'
            });
            table.render({
                elem: '#test'
                ,url:'${pageContext.request.contextPath}/article?method=getArticleList'
                //,width: 1900
                ,height: 580
                ,cols: [[
                    {type:'numbers', fixed: 'left'}
                    ,{type:'checkbox', fixed: 'left'}
//                    ,{field:'id', width:100, title: 'ID',  fixed: 'left',align:'center'}
                    ,{field:'article_title', width:300, title: '文章标题',fixed: 'left',align:'center'}
//                    ,{field:'article_content', width:220, title: '文章内容',fixed: 'left',align:'center'}
                    ,{field:'article_source', width:100, title: '文章来源',align:'center' }
                    ,{field:'link_address', width:240, title: '链接',align:'center' }
                    ,{field:'status', width:80, title: '状态', templet:'#statusTpl',align:'center'}
                    ,{field:'edit_time', width:170, title: '同时上架时间',align:'center',sort: true,templet:function (d) {
                        var index="";
                        if(d.edit_time==""){
                            index="----";
                        }else if(d.status==0){
                            index="----";
                        }else {
                            index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                        }
                        return index;
                    }}
                    ,{field:'create_time', width:170, title: '添加文章时间',align:'center',sort: true,templet:function (d) {
                        var index="";
                        if(d.create_time==""){
                            index="----";
                        }else {
                            index = "20" + d.create_time.substr(0, 2) + "-" + d.create_time.substr(2, 2) + "-" + d.create_time.substr(4, 2) + " " + d.create_time.substr(6, 2) + ":" + d.create_time.substr(8, 2) + ":" + d.create_time.substr(10, 2);
                        }
                        return index;
                    }}
                    ,{field:'auditor', width: 100, title: '操作人',align:'center'}
                    ,{field:'wealth', width:250, title: '操作',toolbar:"#barDemo",align:'center'}
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
                var article_title = $('#article_title');
//                var article_content = $('#article_content');
                var article_source = $('#article_source');
                var status = $('#status');
                var start_time = $('#start_time');
                var end_time = $('#end_time');
                var stime = $('#stime');
                var etime = $('#etime');
                table.reload('test', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        article_title: article_title.val(),
//                        article_content: article_content.val(),
                        article_source: article_source.val(),
                        status: status.val(),
                        start_time: start_time.val(),
                        end_time: end_time.val(),
                        stime: stime.val(),
                        etime: etime.val()
                    }
                });
                return false;
            });


            //监听工具条
            table.on('tool(useruv)', function (obj) {
                var data = obj.data;
//                if (obj.event === 'enable') {
//                    enable(data)
//                }
//                else if (obj.event === 'forbidden'){
//                    forbidden(data)
//                }else
                if (obj.event === 'delArticle'){
                    delArticle(data)
                }else if (obj.event === 'checks'){
//                    window.location.href = data.link_address;
                    javascript:window.open(data.link_address,'_blank');
                }else if (obj.event === 'edit'){
                    var id = data.id;
                    window.location.href = "${ctx}/advertising/article_edit.jsp?&id="+id;
                }
            });

            //添加文章
            $('#add_article').on('click', function (){
                $("#add_article").empty();
                window.location.href = "article_add.jsp";


            });

            //批量上架
            $('#enable').on('click', function (){

                var table = layui.table;
                var checkStatus = table.checkStatus('test');
                var selectCount = checkStatus.data.length;
                if(selectCount==0){
                    layer.msg("请选择一条数据！");
                    return false;
                };
                layer.confirm('确定要上架选中的项吗？',function(index){
                    layer.close(index);
                    var status = 1;
                    var ids = new Array(selectCount);
                    for(var i=0; i<selectCount; i++){
                        ids[i]=checkStatus.data[i].id;
                        if(checkStatus.data[i].status == 1){
                            layer.msg("已经是上架了！");
                            return false;
                        }
                    }
                    $.ajax({
                        type: "post",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/article?method=updateArticleStatus&status=" + status +"&id="+ids,//url
                        dataType : "json",
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
                    })
                })

            });

            //批量下架
            $('#forbidden').on('click', function (){

                var table = layui.table;
                var checkStatus = table.checkStatus('test');
                var selectCount = checkStatus.data.length;
                if(selectCount==0){
                    layer.msg("请选择一条数据！");
                    return false;
                };
                layer.confirm('确定要下架选中的项吗？',function(index){
                    layer.close(index);
                    var status = 0;
                    var ids = new Array(selectCount);
                    for(var i=0; i<selectCount; i++){
                        ids[i]=checkStatus.data[i].id;
                        if(checkStatus.data[i].status == 0){
                            layer.msg("已经是下架了！");
                            return false;
                        }
                    }
                    $.ajax({
                        type: "post",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/article?method=updateArticleStatus&status=" + status +"&id="+ids,//url
                        dataType : "json",
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
                    })
                })

            });

            //删除文章
            function delArticle(obj) {
                var id = obj.id;
                layer.confirm('确定要删除文章吗？',function(index){
                    layer.close(index);
                    $.ajax({
                        //几个参数需要注意一下
                        type: "post",//方法类型
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${ctx}/article?method=delArticle&id="+id,//url
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
                })
                return false;
            }




        });


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

    <%--改变状态--%>
    <script type="text/html" id="statusTpl">
        {{# if(d.status =='0'){}}
        <span style="color:#FF0000; ">下架</span>
        {{# }else if(d.status =='1'){ }}
        <span style="color:green; ">上架</span>
        {{# } }}
    </script>

    <script type="text/html" id="barDemo">
        {{#  if(d.status == '0'){ }}
        <a  lay-event="checks" style="color: blue">查看详情</a>
        <a  lay-event="edit" style="color: blue">编辑</a>
        <a  lay-event="delArticle" style="color: blue">删除</a>
        <%--<a  lay-event="enable" style="color: blue">启用</a>--%>
        {{# }else if(d.status == '1'){ }}
        <a  lay-event="checks" style="color: blue">查看详情</a>
        <a  lay-event="edit" style="color: blue">编辑</a>
        <%--<a  lay-event="delArticle" style="color: blue">删除</a>--%>
        <%--<a  lay-event="forbidden" style="color: blue">禁用</a>--%>
        {{#  } }}
    </script>

</head>

<!--主体部分 -->
<div class="layui-body">

    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            文章列表
        </div>

        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <%--<label class="layui-form-label">文章内容：</label>--%>
                    <%--<div class="layui-input-inline">--%>
                        <%--<input type="text" name="article_content" id="article_content" autocomplete="off"--%>
                               <%--class="layui-input">--%>
                    <%--</div>--%>

                    <label class="layui-form-label">文章来源：</label>
                    <div class="layui-input-inline">
                        <input type="text" name="article_source" id="article_source" autocomplete="off"
                               class="layui-input">
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">文章状态</label>
                        <div class="layui-input-inline" >
                            <select id="status" name="status" lay-filter="statusI">
                                <option value=""></option>
                                <option value="0">下架</option>
                                <option value="1">上架</option>
                            </select>
                        </div>
                    </div>

                    <label class="layui-form-label" >同时上架时间</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="stime" id="stime" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="etime" id="etime" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                </div>

                <div class="layui-form-item" style="margin-bottom: 0">

                    <label class="layui-form-label">文章标题：</label>
                    <div class="layui-input-inline">
                        <input type="text" name="article_content" id="article_title" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label" >添加文章时间</label>
                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="start_time" id="start_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="end_time" id="end_time" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <button id="searchBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button data-type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset"><i class="layui-icon">&#x2746;</i>重置</button>

                </div>

            </div>


        </form>
        <div style="margin-top: 5px;margin-left:10px">
            <button id="add_article" class="layui-btn layui-btn-sm" style="margin-top: 5px">添加文章</button>
            <button id="enable" class="layui-btn layui-btn-sm" style="margin-top: 5px">同时上架</button>
            <button id="forbidden" class="layui-btn layui-btn-sm" style="margin-top: 5px">批量下架</button>
        </div>
        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="useruv"></table>
    </div>
<%@ include file="/common/footer.jsp"%>
