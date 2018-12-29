<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>
<script>
    //JavaScript代码区域
    layui.use(['laydate', 'layer','table', 'element'], function(){
        var element = layui.element;
        var laydate = layui.laydate //日期
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作
        //执行一个 table 实例
        table.render({
            elem: '#goodsTrash'
            ,height: 'full-248'
            	, cellMinWidth: 190
            ,url: '${pageContext.request.contextPath}/goodstrash?method=GoodsTrash' //数据接口
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,id:'listTable'
            ,page: true //开启分页
            ,cols: [[ //表头
                {type:'numbers',fixed: 'true',align:'center'}
                ,{type:'checkbox', fixed: 'left'}
                ,{field:'spu_name',width: 400, title: 'SPU-商品名称',align:'center'}
                ,{field:'spu_code', title: '商品编码',align:'center'}
                ,{field:'first_attribute',templet: '#Tp1',width:120, title: '属性一[数量]',align:'center'}
                ,{field:'second_attribute',templet: '#Tp2', width:120, title: '属性二[数量]',align:'center'}
                ,{field:'brandName', width:120,title: '品牌',align:'center'}
                ,{field:'cateName', title: '商品分类',align:'center'}
                ,{field:'goodsTypeName', title: '商品类型',align:'center'}
                ,{field:'editTime', title: '最后编辑时间',align:'center'}
                ,{field:'sign', title: '最后操作者',align:'center'}
                ,{field:'wealth', width:150, fixed: 'right', align:'center',title: '操作',toolbar:"#barDemo"}
            ]]

        });

        //监听工具条
        table.on('tool(tableFilter)', function(obj){

            var othis = $(this);
            var data = obj.data;

            if(obj.event === 'del'){
                layer.confirm('确认彻底删除?', function(index){
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goodstrash",
                        data: "method=DeleteTrash&ids="+data.id,
                        cache: false,
                        async : false,
                        dataType: "json",
                        success:function(data) {
                            if(data.success){
                                layer.msg('彻底删除成功',{time:2000}, function(){
                                    //do something
                                });
                            }else{
                                layer.msg("异常");
                            }
                        },
                        error : function() {
                            layer.alert("错误");
                        }
                    });
                });
            } else if(obj.event === 'edit'){
                window.location.href = "${ctx}/goods/goodsAdd_B.jsp?spu_id="+data.id
                    +"&minCateCode="+data.category_id+"&minCateName="+data.cateName
                    +"&goodsTypeCode="+data.goods_type_id+"&goodsTypeName="+data.goodsTypeName;

            }else if(obj.event === 'restore'){
                layer.confirm('确认还原?', function(index){
                    //layer.msg(data.id);
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goods",
                        data: "method=updateGoodsStatus&status=0&id="+data.id,   //status=0 移出回收站，并为下架状态
                        cache: false,
                        async : false,
                        dataType: "json",
                        success:function(data) {
                            if(data.success){
                                layer.msg('还原成功',{time:2000}, function(){
                                    //do something
                                });
                            }else{
                                layer.msg("异常");
                            }
                        },
                        error : function() {
                            layer.alert("错误");
                        }
                    });
                });
            }
        });

        //点击按钮 批量删除
        $('#deleteGoods').on('click', function(){

            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if (selectCount > 1) {
                layer.confirm('真的要彻底删除选中的商品吗？', function (index) {

                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        ids[i] = checkStatus.data[i].id;
                    }
                    var jsonIds = JSON.stringify(ids);

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/goodstrash?method=DeleteTrash&ids=" + ids,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("listTable");
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    })

                });

            }
            return false;
        });

        //点击按钮 搜索
        $('#searchBtn').on('click', function(){

                //执行重载
                table.reload('listTable', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: {
                        spu_name: $('#spu_name').val(),
                        supplier_name: $('#supplier_name').val(),
                        brand_name: $('#brand_name').val(),
                        dict_data_name: $('#dict_data_name').val(),
                        spu_code: $('#spu_code').val(),
                    }
                });

                return false;
        });

        $('#toSkuListBtn').on('click', function(){

            var table =layui.table;
            var checkStatus = table.checkStatus('listTable'),
                data = checkStatus.data;
            var selectCount = checkStatus.data.length;
            //alert(selectCount);
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount>1){
                layer.msg("只能选择一条数据！");
                return false;
            };

            if(selectCount==1){
                var id = checkStatus.data[0].id;
                var spu_name = checkStatus.data[0].spu_name;
                document.location.href="goodsSKUtrash.jsp?id="+id+"&spu_name="+spu_name;
            }
            return false;
        });
    });

    function restore(){
        var table =layui.table;
        var checkStatus = table.checkStatus('listTable'),
            data = checkStatus.data;
        var selectCount = checkStatus.data.length;
        if(selectCount==0){
            layer.msg("请选择一条数据！");
            return false;
        };
        layer.confirm('真的要还原选中的商品吗？',function(index){
            //obj.del();//删除对应行（tr）的DOM结构，并更新缓存
            layer.close(index);
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].id;
            };
            $.ajax({
                async : false, // 同步请求
                cache : true,// 不使用ajax缓存
                url : "${pageContext.request.contextPath}/goodstrash?method=restore&ids="+ids,
                /*  data:{'ids':ids} ,*/
                traditional: true,
                success : function(data){
                    if (data.success = 1) {
                        layer.msg('还原成功');
                        table.reload("listTable")
                    }
                }
            })
        });
    }

</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            商品回收站
        </div>
        <form class="layui-form layui-form-pane">
            <div style="background-color:#f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="padding: 0;margin: 0">
                    <label class="layui-form-label">商品名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="spu_name" name="spu_name" placeholder="请输入商品名称" class="layui-input">
                    </div>
                    <label class="layui-form-label">商品品牌</label>
                    <div class="layui-input-inline">
                        <input type="text" id="brand_name" name="brand_name" placeholder="请输入商品品牌" class="layui-input">
                    </div>
                    <label class="layui-form-label">商品类目</label>
                    <div class="layui-input-inline">
                        <input type="text" id="dict_data_name" name="dict_data_name" placeholder="请输入商品类目" class="layui-input">
                    </div>
                    <label class="layui-form-label">商品编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="spu_code" name="spu_code" placeholder="请输入商品编码" class="layui-input">
                    </div>
                    <label class="layui-label">&nbsp;&nbsp;</label>
                    <div class="layui-inline">
                        <button id="searchBtn" data-type="sreach" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
            </div>
        </form>
        <button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm" id="toSkuListBtn" style="margin-top: 5px"><i class="layui-icon">&#xe62d;</i>SKU信息</button>
        <table class="layui-hide" id="goodsTrash" lay-filter="tableFilter"></table>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"  lay-event="restore">还原</a>
            <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"  lay-event="del">彻底删除</a>
        </script>
    </div>
</div>
<%@ include file="/common/footer.jsp"%>