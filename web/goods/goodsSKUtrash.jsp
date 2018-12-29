<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>

<% String id = request.getParameter("id"); %>
<% String spu_name = request.getParameter("spu_name"); %>



<script>

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','table', 'element'], function(){
        var element = layui.element;
        var $ = layui.jquery;
        var laydate = layui.laydate //日期
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作

        //监听Tab切换
        element.on('tab(demo)', function(data){
            layer.msg('切换了：'+ this.innerHTML);
            console.log(data);
        });

        //执行一个 table 实例
        table.render({
            elem: '#test'
            ,height: 730
            ,url: '${pageContext.request.contextPath}/goodstrash?method=SKUGoodsTrash' //数据接口
            ,where:{'id':<%=request.getParameter("id") %>}
            ,page: true //开启分页
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,cols: [[ //表头
                {type:'checkbox', fixed: 'left',field:"ids"}
                ,{field:'id', width:80, title: 'ID',  fixed: 'left',align:'center'}
                ,{field:'sku_name', width:200, title: 'SKU-规格名称',align:'center'}
                // ,{field:'sex', width:120, title: '推广地区',align:'center',fixed: 'left'}
                ,{field:'sku_status', width:120, title: '状态',align:'center',templet: '#sku_statusTpl', unresize: true}
                ,{field:'stock', width:120, title: '限售数量',align:'center'}
                ,{field:'market_price', width:120, title: '销售价(元)',align:'center', unresize: true}
                ,{field:'original_price', width:120, title: '原价(元)',align:'center'}
                ,{field:'first_attribute', width:120, title: '扩展属性1',align:'center'}
                ,{field:'second_attribute', width:120, title: '扩展属性2',align:'center'}
                // ,{field:'create_user', width:120, title: '创建人',align:'center'}
                // ,{field:'create_time', width:120, title: '创建时间',align:'center'}
                ,{field:'edit_user', width:120, title: '操作人',align:'center',fixed: 'right'}
                ,{field:'edit_time', width:120, title: '操作时间',align:'center',fixed: 'right'
                    // ,templet:function (d) {
                    //     var unixTimestamp = new Date( d.edit_time ) ;
                    //     commonTime = unixTimestamp.toLocaleString();
                    //     return commonTime;
                    //     // return this.getFullYear() + "/" + (this.getMonth() + 1) + "/" + this.getDate() + "/ " + this.getHours() + ":" + this.getMinutes() + ":" + this.getSeconds();
                    // }
                    }
                ,{field:'wealth', width:180, fixed: 'right', align:'center',title: '操作',toolbar:"#barDemo"}
            ]]
        });


    });
</script>





<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding: 15px;">
        <blockquote class="layui-elem-quote">
            <%=spu_name%>SKU列表
            <a class="layui-btn layui-btn-normal" href="./goodsTrash.jsp" target="_self"  style="margin-left: 85%;">返回</a>
        </blockquote>


        <div style="margin-top: 5px">
            <button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">删除</button>
        </div>

        <table class="layui-hide" id="test" lay-filter="demo"></table>

        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
        </script>

    </div>

</div>



<%@ include file="/common/footer.jsp"%>
