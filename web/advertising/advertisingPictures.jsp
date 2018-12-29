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
            ,url:'${pageContext.request.contextPath}/advertising?method=getPositionList'
            //,width: 1900
            ,height: 580
            ,cols: [[
                {type:'checkbox'}
                ,{field:'id', width:80, title: 'ID',align:'center'}
                ,{field:'position_id', width:200, title: '广告图片名称',align:'center'}
                ,{field:'position_name', width:200, title: '适用广告类型',align:'center'}
                ,{field:'edit_time', width:200, title: '最后操作时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.market_time.substr(8, 2) + ":" + d.market_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'operator', width:200, title: '最后操作人',align:'center'}
                ,{field:'status', width:150, title: '状态',align:'center'}
                ,{fixed:'right',title:'操作', width:400,align:'center', toolbar: "#barDemo"}
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


</script>


<!-- 操作 -->
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="advertisementList">查看广告列表</a>
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

                    <label class="layui-form-label" style="width: 120px">广告图片名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="xxxxxxxxxxx" id="xxxxxxxxxxx" autocomplete="off"
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

                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" data-type="sreach" id="searchBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>

                </div>

            </div>

        </form>
        <div style="margin-top: 5px">
            <button id="status_open" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>启用</button>
            <button id="status_shut" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>停用</button>
        </div>

        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="picuresList"></table>

    </div>
</div>
<%@ include file="/common/footer.jsp"%>
