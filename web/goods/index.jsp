<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>


    <script>

        layui.config({
            version: '1515376178738' //为了更新 js 缓存，可忽略
        });

        //JavaScript代码区域
        layui.use(['laydate','layer','table','element'], function(){

            var laydate = layui.laydate //日期
                ,layer = layui.layer //弹层
                ,table = layui.table //表格
                ,element = layui.element; //元素操作

            //监听Tab切换
            element.on('tab(demo)', function(data){
                layer.msg('切换了：'+ this.innerHTML);
                console.log(data);
            });


        });
    </script>



    <%@ include file="/goods/indexContext.jsp"%>



<%@ include file="/common/footer.jsp"%>

