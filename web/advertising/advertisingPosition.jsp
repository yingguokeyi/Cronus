<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/common.jsp" %>
<%@ include file="/advertising/advertising_memu.jsp"%>

<script>

    var return_market_time,return_marketend_time,return_position_name,locationPage;
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
        laydate.render({
            elem: '#market_time'
            ,type: 'datetime'
        });
        laydate.render({
            elem: '#marketend_time'
            ,type: 'datetime'
        });

        table.render({
            elem: '#test'
            ,url:'${pageContext.request.contextPath}/advertising?method=getPositionList'
            //,width: 1900
            ,height: 580
            ,cols: [[
                {type:'checkbox', fixed: 'left'}
//                ,{title: '编号',fixed: 'left',align:'center'}
                ,{field:'id', width:100, title: '广告位ID',align:'center',fixed: 'left',sort: true}
                ,{field:'position_name', width:150, title: '广告位名称',align:'center',fixed: 'left'}
                ,{field:'status', width:100, title: '状态',align:'center',fixed: 'left',templet: '#StatusAdvertising'}

                ,{field:'page_location', width:100, title: '所属页面',align:'center',fixed: 'left',templet: '#pageLocation'}

                ,{field:'position', width:150, title: '广告位位置',align:'center'}
                ,{field:'market_time', width:180, title: '投放开始时间',align:'center',sort: true,templet:function (d) {
                        var index="";
                        if(d.market_time==""){
                            index="----";
                        }else {
                            var index = "20" + d.market_time.substr(0, 2) + "-" + d.market_time.substr(2, 2) + "-" + d.market_time.substr(4, 2) + " " + d.market_time.substr(6, 2) + ":" + d.market_time.substr(8, 2) + ":" + d.market_time.substr(10, 2);
                        }
                        return index;
                    }}
                ,{field:'marketend_time', width:180, title: '投放结束时间',align:'center',sort: true,templet:function (d) {
                    var index="";
                    if(d.marketend_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.marketend_time.substr(0, 2) + "-" + d.marketend_time.substr(2, 2) + "-" + d.marketend_time.substr(4, 2) + " " + d.marketend_time.substr(6, 2) + ":" + d.marketend_time.substr(8, 2) + ":" + d.marketend_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'market_region', width:150, title: '投放地区',align:'center'}

                ,{field:'size', width:150, title: '广告尺寸',align:'center'}
                ,{field:'playback_length', width:150, title: '播放时长',align:'center',templet:function (d) {
                    var index="";
                    if(d.playback_length==""){
                        index="----";
                    }else {
                        var index = d.playback_length+"s" ;
                    }
                    return index;
                }}
                ,{field:'advert_num', width:150, title: '在线广告数',align:'center'}
                ,{field:'scheduling_num', width:150, title: '排期广告数',align:'center'}
                ,{field:'operator', width:150, title: '最后操作人',align:'center'}
                ,{field:'edit_time', width:150, title: '最后操作时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.market_time.substr(8, 2) + ":" + d.market_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{fixed:'right',title:'操作', width:250,align:'center', toolbar: "#barDemo"}
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
            var page_location = $('#page_location').val();
            var edit_time = $('#edit_time').val();
            var editend_time = $('#editend_time').val();
            var market_time = $('#market_time').val();
            var marketend_time = $('#marketend_time').val();

            if(CompareDate(edit_time,editend_time)){
                layer.msg("开始时间不能大于结束时间");
                return false;
            }
            if(CompareDate(market_time,marketend_time)){
                layer.msg("开始时间不能大于结束时间");
                return false;
            }

            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
//                    id: id.val(),
                    operator: operator,
                    page_location: page_location,
                    edit_time: edit_time,
                    editend_time: editend_time,
                    market_time: market_time,
                    marketend_time: marketend_time
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
                layer.confirm('确定开启广告位吗？', function (index) {
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
                        data: "method=updatePositionStatus&status=1&ids=" + ids,
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
                layer.confirm('确定停用广告位吗？', function (index) {
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
                        data: "method=updatePositionStatus&status=2&ids=" + ids,
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


        table.on('tool(positionList)', function(obj){
            var data = obj.data;
            if(obj.event === 'edit'){
                layer.open({
                    type: 1
                    , title: '编辑'
                    , id: 'layerDemo'
                    , area: ['600px','600px']
                    , content: $('#AdvertisingEdit')
                    , btn: ['保存','取消']
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //不显示遮罩
                    , yes: function (data) {
                        var return_id = $("#return_id").val();
                        var return_position_name = $("#return_position_name").val();
                        var return_page_location = $("#return_page_location").val();
                        if($("#return_page_location").val() == "首页"){
                            locationPage = 1;
                        }else if($("#return_page_location").val() == "分类"){
                            locationPage = 2;
                        }
                        else if($("#return_page_location").val() == "会员"){
                            locationPage = 3;
                        }
                        else if($("#return_page_location").val() == "我的"){
                            locationPage = 4;
                        }
                        var return_position = $("#return_position").val();
                        var return_market_time = $("#return_market_time").val();
                        var return_marketend_time = $("#return_marketend_time").val();
                        var return_playback_length = $("#return_playback_length").val();
                        $.ajax({
                            type: "get",
                            async: false, // 同步请求
                            cache: true,// 不使用ajax缓存
                            contentType: "application/json",
                            url: "${ctx}/advertising?method=updatePositionEdit",
                            data: {
                                "id": return_id,
                                "position_name":return_position_name,
                                "page_location":locationPage,
                                "position":return_position,
                                "market_time":return_market_time,
                                "marketend_time":return_marketend_time,
                                "playback_length":return_playback_length
                            },

                            dataType: "json",
                            success: function (data) {
                                if (data.success) {
                                    layer.msg('编辑成功', {time: 1000}, function () {
                                        //do something
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
                    ,btn2:function () {
                        layer.closeAll();
                    }
                    ,success:function () {

                        $("#return_id").val(data.id);
                        $("#return_position_name").val(data.position_name);
                        $("#return_page_location").val(data.page_location);
                        if(data.page_location == "1"){
                            $("#return_page_location").val("首页");
                        }
                        if(data.page_location == "2"){
                            $("#return_page_location").val("分类");
                        }
                        if(data.page_location == "3"){
                            $("#return_page_location").val("会员");
                        }
                        if(data.page_location == "4"){
                            $("#return_page_location").val("我的");
                        }
                        $("#return_position").val(data.position);
                        $("#return_playback_length").val(data.playback_length);

                        var return_market_time = $("#return_market_time").val();
                        var return_marketend_time = $("#return_marketend_time").val();

                        if(typeof data.market_time != "undefined"){
                            var st = data.market_time;
                            return_market_time = "20" + st.substr(0, 2) + "-" + st.substr(2, 2) + "-" + st.substr(4, 2) + " " + st.substr(6, 2) + ":" + st.substr(8, 2) + ":" + st.substr(10, 2);
                            $("#return_market_time").val(return_market_time);
                        }
                        if(typeof data.marketend_time != "undefined"){
                            var et = data.marketend_time;
                            return_marketend_time = "20" + et.substr(0, 2) + "-" + et.substr(2, 2) + "-" + et.substr(4, 2) + " " + et.substr(6, 2) + ":" + et.substr(8, 2) + ":" + et.substr(10, 2);
                            $("#return_marketend_time").val(return_marketend_time);
                        }


                    }
                });
            }
            else if (obj.event === 'advertisementList') {
                var adverts_id = $("#adverts_id").val();
                <%--window.location.href = "${ctx}/advertising/advertList.jsp?id=" + data.id + "&adverts_id=" + data.adverts_id + "&page_location=" + data.page_location + "&position=" + data.position;--%>
                window.location.href = "${ctx}/advertising/advertList.jsp?id=" + data.id;
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

        //时间选择器
        laydate.render({
            elem: '#return_market_time'
            ,type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#return_marketend_time'
            ,type: 'datetime'
        });

    });

    function CompareDate(d1,d2){
        return ((new Date(d1.replace(/-/g,"\/"))) > (new Date(d2.replace(/-/g,"\/"))));
    }


</script>

<!-- 操作 -->
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="advertisementList">查看广告列表</a>
</script>

<%--广告状态--%>
<script type="text/html" id="StatusAdvertising">
    {{# if(d.status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.status =='1'){}}
    启用
    {{# }else if(d.status =='2'){ }}
    停用
    {{# }else if(d.status =='3'){ }}
    排期中
    {{# } }}
    {{# } }}
</script>

<%--所属页面--%>
<script type="text/html" id="pageLocation">
    {{# if(d.page_location ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.page_location =='1'){}}
    首页
    {{# }else if(d.page_location =='2'){ }}
    分类
    {{# }else if(d.page_location =='3'){ }}
    会员
    {{# }else if(d.page_location =='3'){ }}
    我的
    {{# } }}
    {{# } }}
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            广告位列表
        </div>

        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">最后操作人</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operator" id="operator" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label">所属页面：</label>
                    <div class="layui-input-inline" >
                        <select id="page_location" name="page_location">
                            <option value="">全部</option>
                            <option value="1">首页</option>
                            <option value="2">分类</option>
                            <option value="3">会员</option>
                            <option value="4">我的</option>
                        </select>

                    </div>

                    <label class="layui-form-label" style="width: 120px">最后操作时间</label>
                    <div class="layui-input-inline" >
                        <input name="edit_time" id="edit_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="editend_time" id="editend_time" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                </div>

                <div class="layui-form-item" style="margin-bottom: 0">


                    <label class="layui-form-label"  >投放时间</label>
                    <div class="layui-input-inline" >
                        <input name="market_time" id="market_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline" style="width: 150px" >
                        <input name="marketend_time" id="marketend_time" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" id="sreachBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>

                </div>

            </div>

        </form>
        <div style="margin-top: 5px">
            <button id="status_open" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>启用</button>
            <button id="status_shut" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>停用</button>
        </div>

        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="positionList"></table>

    </div>
    <!-- 编辑页面 -->
    <div id="AdvertisingEdit" style="display: none; padding: 15px;">
        <form class="layui-form layui-form-pane" action="">

            <div class="layui-form-item">

                <label class="layui-form-label" style="width: 150px">广告位ID</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_id" id="return_id" value="return_id" lay-verify="title" autocomplete="off" readonly = "readonly">
                </div>

                <label class="layui-form-label" style="width: 150px">广告位名称</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_position_name" id="return_position_name" lay-verify="title" autocomplete="off">
                </div>



                <label class="layui-form-label" style="width: 150px">广告位位置</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_position" id="return_position" lay-verify="title" readonly="readonly">
                </div>

                <label class="layui-form-label" style="width: 150px">投放开始时间</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_market_time" id="return_market_time" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">投放结束时间</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="text" name="return_marketend_time" id="return_marketend_time" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">播放时长（秒）</label>
                <div class="layui-input-block">
                    <input style="width: 350px" class="layui-input" type="number" name="return_playback_length" id="return_playback_length" lay-verify="title|number" autocomplete="off">
                </div>

                <label class="layui-form-label" style="width: 150px">所属页面</label>
                <div class="layui-input-inline">
                    <input style="width: 350px" class="layui-input" type="text" name="return_page_location" id="return_page_location" lay-verify="title|number" readonly="readonly">
                    <%--<select class="layui-select" id="return_page_location" name="return_page_location" lay-filter="error_remarkFilter">--%>
                        <%--<option value="1" selected="">首页</option>--%>
                        <%--<option value="2">分类</option>--%>
                        <%--<option value="3">会员</option>--%>
                        <%--<option value="4">我的</option>--%>
                    <%--</select>--%>
                </div>


            </div>


        </form>
    </div>
</div>
<%@ include file="/common/footer.jsp"%>
