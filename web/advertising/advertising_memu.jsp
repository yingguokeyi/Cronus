<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree"  lay-filter="test">
            <li class="layui-nav-item layui-nav-itemed">
                <dl class="layui-nav-child">
                    <dd><a href="advertisingPosition.jsp">广告位列表</a></dd>
                    <dd><a href="advertisingLinks.jsp">广告链接库</a></dd>
                    <dd><a href="article_list.jsp">文章列表</a></dd>

                </dl>
            </li>
        </ul>
    </div>
</div>
<%@ include file="/common/footer.jsp"%>
