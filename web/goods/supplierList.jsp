<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<script>


    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use(['laydate','layer','table', 'element'], function(){
        var $ = layui.jquery;

        var form = layui.form;
        var laydate = layui.laydate //日期
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作


        //执行一个 table 实例
        table.render({
            elem: '#test'
            	,height: 'full-247'
            ,cellMinWidth: 190
            ,url: '${ctx}/goods?method=getSupplierList' //数据接口
            //,url: './data/user.json' //数据接口
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,id:'testReload'
            ,page: true //开启分页
            ,cols: [[ //表头
                {type:'checkbox', fixed: 'left',field:"ids"}
                ,{field:'supplier_name', title: '供应商名称'}
                ,{field:'tel',  title: '电话'}
                ,{field:'address',  title: '地址'}
                ,{field:'memo', title: '备注'}
                ,{field:'wealth', width:240, align:'center',title: '操作',toolbar:"#barDemo"}
            ]]
        });

        table.on('tool(tableFilter)', function(obj){
            var othis = $(this);
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('确认删除?', function(index){
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goods",
                        data: "method=deteleSupplier&supplierId="+data.id,
                        cache: false,
                        async : false,
                        dataType: "json",
                        success:function(data) {
                            layer.msg("删除成功");
                        },
                        error : function() {
                            layer.alert("错误");
                        }
                    });
                });
            } else if(obj.event === 'edit'){
                window.location.href = "${ctx}/goods/supplierAdd.jsp?supplierId="+data.id;
            }
        });

        //监听启用禁用操作
        form.on('switch(fixedFilter)', function(obj){
            var othis = $(this)
                ,status = (othis.data('method')?0:1)
                ,id = this.value;

            var that = obj.othis;
            $.ajax({
                type: "get",
                url: "${ctx}/goods",
                data: "method=updateBrandStatus&status=" + status +"&id="+id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.tips('操作成功', that);
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });

        });

        //点击按钮 搜索
        $('#searchBtn').on('click', function () {
            var searchName = $("#searchName").val();
            //layer.msg(encodeURI($("#searchName").val()))

            //执行重载
            table.reload('testReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    searchName: $("#searchName").val()
                }
            });

        });
    });
</script>

<script id="urlTpl" type="text/html">
    <a href="http://{{d.url}}" target="_blank">{{d.url}}</a>
</script>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit"><i class="layui-icon">&#xe642;</i>编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="del"><i class="layui-icon">&#xe640;</i>删除</a>
</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            供应商列表
        </div>
        <form class="layui-form layui-form-pane">
	        <div style="background-color:#f2f2f2;padding:5px 0;">
	            <div class="layui-form-item" style="padding: 0;margin: 0">
                    <label class="layui-form-label">搜索词</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchName" name="searchName" class="layui-input">
                    </div>
                    <button id="searchBtn" class="layui-btn  layui-btn-sm"  style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索</button>
	            </div>
	        </div>
		</form>
        <div>
            <a class="layui-btn layui-btn-sm" href="${ctx}/goods/supplierAdd.jsp" style="margin-top: 5px"><i class="layui-icon">&#xe61f;</i>添加供应商</a>
        </div>
        <table class="layui-hide" id="test" lay-filter="tableFilter"></table>
    </div>
</div>
<%@ include file="/common/footer.jsp" %>