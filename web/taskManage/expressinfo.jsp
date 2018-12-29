<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/taskManage/menu_task.jsp"%>


<%

    String waybill_no = request.getParameter("waybill_no");
    String express_company = request.getParameter("express_company");
%>
<script>
    var waybill_no = "<%=waybill_no%>";
    var express_company = "<%=express_company%>";
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

        table.render({
            elem: '#test'
            ,url:'${ctx}/express?method=getExpressDatainfo&waybill_no='+waybill_no+'&express_company='+express_company
            ,height: 580
            ,cols: [[
                {field:'time', width:400, title: '时间',align:'center',fixed: 'left'}
                ,{field:'context', width:1200, title: '地点和跟踪进度',align:'center',fixed: 'left'}
            ]]
            ,id: 'listTable'
            ,limit:20
            ,limits:[20,30,40,50,100]
            ,page: false
            ,response: {
                statusName: 'status'
                ,statusCode: '200'
                ,msgName: 'message'
                ,countName: 50
                ,dataName: 'data'
            }
        });

    });

</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            物流信息
        </div>
        <div class="layui-elem-quote">
            物流编号：<%=waybill_no%>
        </div>
        <div class="layui-elem-quote">
            物流公司：<%=express_company%>
        </div>
        <form class="layui-form layui-form-pane" >


        </form>
        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="positionList"></table>

    </div>
</div>

<%@ include file="/common/footer.jsp"%>