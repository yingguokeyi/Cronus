<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree"  lay-filter="test">
            <li class="layui-nav-item layui-nav-itemed">
                <dl class="layui-nav-child">
                    <dd><a href="${ctx}/taskManage/skipTasksInfo.jsp">代购订单任务分配表</a></dd>
                    <dd><a href="${ctx}/taskManage/purchasingOrderHandleList.jsp">代购订单处理表</a></dd>
                    <%--<dd><a href="${ctx}/taskManage?method=skipTasksInfo">订单处理统计表</a></dd>--%>
                </dl>
            </li>
        </ul>
    </div>
</div>
