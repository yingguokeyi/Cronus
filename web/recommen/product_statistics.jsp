<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/recommen/menu_recommen.jsp" %>



<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });
    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','table', 'element'], function(){
        var element = layui.element;

        var laydate = layui.laydate //日期
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作

        //监听Tab切换
        // element.on('tab(demo)', function(data){
        //     layer.msg('切换了：'+ this.innerHTML);
        //     console.log(data);
        // });
        function onload(){
            $.ajax({
                //几个参数需要注意一下
                type: "get",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "index?method=Selectpending",//url
                async: false,
                data: {status: 103},
                success: function (res1) {
                    var obj = res1.rs[0].count;
                    document.getElementById("Selectpending").innerHTML = (obj);
                    document.getElementById("Selectpending2").innerHTML = (obj);

                },
            });
            $.ajax({
                //几个参数需要注意一下
                type: "get",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "index?method=Selectpending",//url
                async: false,
                data: {status: 104},
                success: function (res1) {
                    var obj = res1.rs[0].count;

                    document.getElementById("Selectpending1").innerHTML = (obj);
                },
            });
        }

        onload();

        //日期时间选择器
        laydate.render({
            elem: '#start'
            ,type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#end'
            ,type: 'datetime'
        });





    });
</script>

<!-- 内容主体区域 -->


<div class="layui-body" style="padding: 30px;">
    <blockquote class="layui-elem-quote"> 栏目管理</blockquote>
    <blockquote class="layui-elem-quote"> 重要提醒：<span style="color: red; ">有<td><span style="color: red; " id="Selectpending2"></span></td>个栏目的商品在首页展示位达到预警状态</span></blockquote>
    <table class="layui-table">
        <colgroup>
            <col width="25%">
            <col width="25%">
            <col width="25%">
            <col width="25%">
        </colgroup>
        <thead>
        <tr>
            <th>栏目数据统计</th>
            <th style="float: right;">
                检索统计:
                <div class="layui-input-inline" style="width: 150px" >
                    <input lay-verify="date" name="start" id="start" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                </div>
                <div class="layui-input-inline" style="width: 150px" >
                    <input lay-verify="date" name="end" id="end" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                </div>

            </th>

        </tr>
        </thead>
        <tbody>
        <tr>
            <td><span style="color: red; ">成交总额:</span></td>
            <td><span style="color: red; " id="Selectpending">6379元</span></td>
        </tr>
        <tr>
            <td>已成交订单总量:</td>
            <td>520单</td>
        </tr>
        <tr>
            <td>下单量:</td>
            <td>770次</td>
        </tr>
        </tbody>
    </table>

    <table class="layui-table" id="columns" style="margin-top: 50px;">

        <thead>
        <tr>
            <th>栏目数据统计</th>
            <th></th>
            <th></th>
            <th></th>
            <th></th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td><span>栏目位置</span></td>
            <td><span id="Selectpending">栏目名称</span></td>
            <td>点击量</td>
            <td>下单量</td>
            <td>支付成功订单量</td>
            <td>成交总额</td>
        </tr>
        <tr>
            <td>101</td>
            <td>自营秒杀</td>
            <td>999</td>
            <td>250次</td>
            <td>158次</td>
            <td>3233元</td>
        </tr>
        <tr>
            <td>102</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        </tbody>
    </table>


<%@ include file="/common/footer.jsp" %>