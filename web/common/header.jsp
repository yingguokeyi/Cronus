<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/common.jsp" %>

<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo">运营平台</div>


        <ul class="layui-nav layui-layout-left">


            <li class="layui-nav-item"><a href="${ctx}/goods/index.jsp">商品中心</a></li>
            <li class="layui-nav-item"><a href="${ctx}/order/orderList.jsp">订单中心</a></li>
            <li class="layui-nav-item"><a href="${ctx}/finance/finance.jsp">财务管理</a></li>
            <li class="layui-nav-item"><a href="${ctx}/member/memberList.jsp">会员管理</a></li>
            <li class="layui-nav-item"><a href="${ctx}/member/distributionSet.jsp">分销管理</a></li>
            <li class="layui-nav-item"><a href="${ctx}/taskManage/skipTasksInfo.jsp">任务管理</a></li>
            <li class="layui-nav-item"><a href="${ctx}/zhangDaZhuan/zhangDaOrderList.jsp">掌小龙回填单</a></li>
            <li class="layui-nav-item"><a href="${ctx}/advertising/advertisingData.jsp">广告管理</a></li>
            <li class="layui-nav-item"><a href="${ctx}/recommen/column_lists.jsp">商品推荐</a></li>
            <li class="layui-nav-item"><a href="${ctx}/message/publish_message.jsp">消息发布</a></li>
        <%--<li class="layui-nav-item">--%>
            <%--<a href="javascript:;">其它管理</a>--%>
            <%--<dl class="layui-nav-child">--%>
            <%--<dd><a href="">邮件管理</a></dd>--%>
            <%--<dd><a href="">消息管理</a></dd>--%>
            <%--<dd><a href="">授权管理</a></dd>--%>
            <%--</dl>--%>
            <%--</li>--%>
        </ul>

        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item"><a href="${ctx}/index.jsp">首页</a></li>
            <li class="layui-nav-item"><a href="${ctx}/System_settings/staff_management.jsp">系统设置</a></li>
            <li class="layui-nav-item"><a href="${ctx}/System_settings/person_settings.jsp">个人设置</a></li>
            <li class="layui-nav-item">
                <a href="javascript:;">
                    <img src="http://t.cn/RCzsdCq" class="layui-nav-img">

                </a>
                <dl class="layui-nav-child">
                    <dd><a href="">基本资料</a></dd>
                    <dd><a href="">安全设置</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item"><a href="${ctx}/login.jsp">退出</a></li>
        </ul>

    </div>