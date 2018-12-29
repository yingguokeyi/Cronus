<%--
  Created by IntelliJ IDEA.
  User: wanzi
  Date: 2018/2/28
  Time: 9:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="/uidemo/layui/css/layui.css"/>
<script type="text/javascript" src="/uidemo/layui/layui.js"></script>
<html>
<head>
    <title>认证审核-申请信息 </title>
</head>
<body class="layui-layout-body">
<!--主体部分 -->
<div class="" style=""><span style="margin-left:30px;">联系人信息</span></div>
<div class="" style="">
    <form class="layui-form" action="">
        <div class="layui-inline">
            <label class="layui-form-label">姓名:</label>
            <div class="layui-input-block">
                <input type="text" name="username" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">手机号:</label>
            <div class="layui-input-inline">
                <input type="text" name="phonenumber" lay-verify="required|phone|number" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item" style="margin-top:10px;">
            <div class="layui-inline">
                <label class="layui-form-label">性别:</label>
                <div class="layui-input-inline">
                  <input type="text" name="phonenumber"    class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">生日:</label>
                <div class="layui-input-inline">
                    <input type="text" name="date" id="date" lay-verify="date" placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱:</label>
            <div class="layui-input-inline">
                <input type="text" name="email" lay-verify="email" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">职务:</label>
                <div class="layui-input-block">
                    <input type="text" name="post" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">联系人名片:</label>
            <div class="layui-input-block" id="LAY_demo3">
                <img src="image/1.png">
            </div>
        </div>
        <div class="" style=""><span style="margin-left:30px;">处理状态</span></div>
        <div class="layui-form-item layui-form-text">
            <div class="layui-inline">
                <label class="layui-form-label">审核状态:</label>
                <div class="layui-input-block">
                    <input type="text" name="username"  lay-verify="required" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">处理说明:</label>
            <div class="layui-input-inline">
                <input type="text" name="email" lay-verify="email" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="reset" class="layui-btn layui-btn-primary">取消</button>
                <button class="layui-btn" lay-submit lay-filter="formDemo">确认</button>
            </div>
        </div>
    </form>

    <script>
        layui.use(['form', 'laydate'], function () {
            var form = layui.form, laydate = layui.laydate;
            ;
            //监听提交
            form.on('submit(formDemo)', function (data) {
                layer.msg(JSON.stringify(data.field));
                return false;
            });
            //日期
            laydate.render({
                elem: '#date'
            });
            laydate.render({
                elem: '#date1'
            });
        });
    </script>
</div>
</body>
</html>
