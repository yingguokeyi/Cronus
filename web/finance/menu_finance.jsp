
<%--
  Created by IntelliJ IDEA.
  User: luyou
  Date: 2018/2/27
  Time: 17:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree"  lay-filter="test">
            <li class="layui-nav-item layui-nav-itemed">
                <a class="" href="javascript:;">财务管理</a>
                <dl class="layui-nav-child">
                    <dd><a href="${ctx}/finance/finance.jsp">佣金/收益管理</a></dd>
                    <dd><a href="${ctx}/finance/payment_information.jsp">支付信息</a></dd>
                    <dd><a href="${ctx}/finance/withdrawals.jsp">提现处理</a></dd>
                    <dd><a href="${ctx}/finance/zdzwithdrawals.jsp">掌小龙订单收益列表</a></dd>
                    <dd><a href="${ctx}/finance/zdzmemberprofit.jsp">掌小龙会员收益列表</a></dd>
                </dl>
            </li>
        </ul>
    </div>
</div>
