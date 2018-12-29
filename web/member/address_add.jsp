<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/3/2
  Time: 14:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>会员管理-地址信息</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/layui/css/layui.css" />
    <script type="text/javascript" src="${pageContext.request.contextPath}/layui/layui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/common/third-part/jquery-1.11.3.min.js"></script>
<%--    <script>
        layui.use('table', function(){
            var table = layui.table;

            table.render({
                elem: '#test'
                ,url:''
                ,width: 892
                ,height: 332
                ,cols: [[
                     {field:'consignee', width:80, title: '姓名', sort: true, fixed: 'left'}
                    ,{field:'address_name', width:80, title: '地址'}
                    ,{field:'district_code', width:80, title: '邮编', sort: true}
                    ,{field:'phone', width:80, title: '手机'}
                    ,{field:'tel', width: 219, title: '固定电话'}
                    ,{field:'e_mail', width:80, title: 'E-mail', sort: true}
                ]]
              });
        });
    </script>--%>
</head>
<body>
<div class="" style=""><span style="margin-left:30px;">收货地址</span></div>
<div class="">
<%--
     <table class="layui-hide" id="test"></table>
--%>

    <form>
        <table  class="layui-table" id="#table1">
            <tr>
                <td>姓名</td>
                <td>地址</td>
                <td>邮编</td>
                <td>手机</td>
                <td>固定电话</td>
                <td>E-mail</td>
            </tr>
            <tr>
                <td id="consignee" name="consignee"></td>
                <td id="address_name" name="address_name"></td>
                <td id="district_code" name="district_code"></td>
                <td id="phone" name="phone"></td>
                <td id="tel" name="tel"></td>
                <td id="e_mail" name="e_mail"></td>
            </tr>
        </table>
        <div style="margin-left: 750px;margin-top:300px;"></div>
    </form>
</div>
</body>
</html>
