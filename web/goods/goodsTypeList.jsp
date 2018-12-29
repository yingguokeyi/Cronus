<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>
<script>
    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','table', 'element'], function(){
        var laydate = layui.laydate //日期
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作
        var form = layui.form;
        var checkStatus="";
        var data="";
        var selectCount="";
        table.on('checkbox(goodsStyleTabFilter)', function(obj){
            console.log(obj.length)
            checkStatus = table.checkStatus('goodsStyleTab');
            data = checkStatus.data;
            selectCount = checkStatus.data.length;
        });
        //执行一个 table 实例
        table.render({
            elem: '#goodsStyleTab'
            ,height: 600
            ,cellMinWidth: 190
            ,url: '${ctx}/goodsStyle?method=getGoodsStyleList' //数据接口
            ,limit:20
            ,limits:[20,50,100]
            ,cols: [[ //表头
                {type:'checkbox', fixed: true}
                ,{field:'Id', width:80, title: 'ID', align:'center', sort: true, fixed: true}
                ,{field:'styleName', title: '类型名称', align:'center'}
                ,{field:'is_fixed', title: '状态', align:'center', templet: '#is_fixedTpl'}
                ,{field:'attribute_Num', title: '属性数', align:'center'}
                ,{field:'spu_num', title: '是否关联商品', align:'center', templet:function (d) {
                        if(d.spu_num>0){
                            return "已关联"+d.spu_num+"个商品";
                        }else{
                            return "未关联商品";
                        }
                    }}
                ,{field:'classifyAtairName', width:320, title: '所在类目', align:'center',templet: '#classifyNameTpl'}
            ]]
            ,page: true //开启分页
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,id:'goodsStyleInfoReload'
        });

        var $ = layui.$, active = {

        };

        $("#goodsStyle_Sreach").on('click',function () {
            table.reload('goodsStyleInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    goodsStyleName: $('#styleName').val(),
                    goodsClassify: $('#classifyName').val()
                }
            });
            return false;
        });
        $("#goodsStyle_Reset").on('click',function () {
            $('#styleName').val("");
            $('#classifyName').val("");
            //执行重载
            table.reload('goodsStyleInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    goodsStyleName: $('#styleName').val(),
                    goodsClassify: $('#classifyName').val()
                }
            });
            return false;
        });

        //添加商品类型
        $("#GoodsTypeInfo_Add").on('click',function () {
            window.location.href="${ctx}/goods/goodsTypeAdd.jsp"
        });
        //删除
        $("#GoodsTypeInfo_Del").on('click',function () {
            var checkStatus = table.checkStatus('goodsStyleInfoReload');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].Id;
            }
            layer.open({
                type: 1
                ,content: '确认删除？'
                ,btn: ['确认','取消']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(index){
                    layer.close(index);
                    layer.load(2);
                    $.ajax({
                        type: "get",
                        url : "${ctx}/goodsStyle?method=delGoodsStyleInfo&ids="+ids,
                        // data:{'ids':ids} ,
                        cache: false,
                        async: false,
                        dataType: "json",
                        success : function(data){
                            if (data.success) {
                                layer.closeAll();
                                table.reload("goodsStyleInfoReload")
                                layer.msg('删除成功');
                            }
                        }
                    })
                }
                ,btn2: function(){
                    layer.closeAll();
                }

                ,zIndex: layer.zIndex //重点1
                ,success: function(layero){
                    layer.setTop(layero); //重点2
                }
            });
        });
        //编辑
        $("#GoodsTypeInfo_Edit").on('click',function (){
            var checkStatus = table.checkStatus('goodsStyleInfoReload'),
                data = checkStatus.data;
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            var ids ="";
            var styleName = "";
            var dict_data_value ="";
            for(var i=0; i<selectCount; i++){
                ids=checkStatus.data[i].Id;
                styleName=checkStatus.data[i].styleName;
                dict_data_value=checkStatus.data[i].dict_data_value;
            };
            window.location.href="${ctx}/goods/goodsTypeAdd.jsp?ids="+ids+"&styleName="+styleName+"&dict_data_value="+dict_data_value

        });
        //启用
        $("#GoodsTypeInfo_Enable").on('click',function () {
            var checkStatus = table.checkStatus('goodsStyleInfoReload'),
                data = checkStatus.data,
                selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            layer.confirm('确定要启用选中的项吗？',function(index){
                layer.close(index);
                var status = 1;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].Id;
                    if(checkStatus.data[i].is_fixed == 1){
                        layer.msg("已经是启用了！");
                        return false;
                    }
                }
                layer.open({
                    type: 1
                    ,content: '确认启用？'
                    ,btn: ['确认','取消']
                    ,btnAlign: 'c' //按钮居中
                    ,shade: 0 //不显示遮罩
                    ,yes: function(index){
                        $.ajax({
                            type: "get",
                            contentType : "application/json",
                            url : "${ctx}/goodsStyle?method=upGoodsStyleFixed&ids="+ids+"&state=enable",
                            // data:{'ids':ids,'state':'enable'} ,
                            cache: false,
                            async: false,
                            dataType: "json",
                            success : function(data){
                                if (data.success) {
                                    layer.closeAll();
                                    layer.msg('启用成功');
                                    table.reload("goodsStyleInfoReload")
                                    return false;
                                }else{
                                    layer.closeAll();
                                    table.reload("goodsStyleInfoReload")
                                    layer.msg('启用失败');
                                    return false;
                                }
                            }
                            ,error:function () {
                                layer.closeAll();
                                table.reload("goodsStyleInfoReload")
                                layer.msg('启用失败');
                                return false;
                            }
                        })
                    }
                    ,btn2: function(){
                        layer.closeAll();
                    }
                });
            });

        });
        //禁用
        $("#GoodsTypeInfo_Disable").on('click',function (){
            var checkStatus = table.checkStatus('goodsStyleInfoReload'),
                data = checkStatus.data;
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };

            layer.confirm('确定要禁用选中的项吗？',function(index){
                layer.close(index);
                var status = 1;
                var ids = new Array(selectCount);
                for(var i=0; i<selectCount; i++){
                    ids[i]=checkStatus.data[i].Id;
                    if(checkStatus.data[i].is_fixed == 0){
                        layer.msg("已经是禁用了！");
                        return false;
                    }
                }
                layer.open({
                    type: 1
                    ,content: '确认禁用？'
                    ,btn: ['确认','取消']
                    ,btnAlign: 'c' //按钮居中
                    ,shade: 0 //不显示遮罩
                    ,yes: function(index){
                        $.ajax({
                            type: "get",
                            url : "${ctx}/goodsStyle?method=upGoodsStyleFixed&ids="+ids+"&state=disable",
                            // data:{'ids':ids,'state':'disable'} ,
                            cache: false,
                            async: false,
                            dataType: "json",
                            success : function(data){
                                if (data.success) {
                                    layer.closeAll();
                                    table.reload("goodsStyleInfoReload")
                                    layer.msg('禁用成功');
                                }else{
                                    layer.closeAll();
                                    table.reload("goodsStyleInfoReload")
                                    layer.msg('禁用失败');
                                    return false;
                                }
                            }
                            ,error:function () {
                                    layer.closeAll();
                                    table.reload("goodsStyleInfoReload")
                                    layer.msg('禁用失败');
                                    return false;
                            }
                        })
                    }
                    ,btn2: function(){
                        layer.closeAll();
                    }
                });
            });
        });
        //属性列表
        $("#attributeList").on('click',function () {
            var checkStatus = table.checkStatus('goodsStyleInfoReload'),
                data = checkStatus.data;
            var selectCount = checkStatus.data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            }else{
                var id = "";
                var styleName = "";
                for(var i=0; i<selectCount; i++){
                    id =checkStatus.data[i].Id;
                    styleName =checkStatus.data[i].styleName;
                };
                window.location.href="${ctx}/goods/goodsPropertyList.jsp?id="+id+"&styleName="+styleName
            }

        });

        $('.GoodsTypeInfoTableReload .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        $('.GoodsTypeInfoManage_Div .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });
</script>

<script type="text/html" id="is_fixedTpl">
    {{#  if(d.is_fixed === '0'){ }}
    <span style="color: #0C0C0C;">禁用</span>
    {{#  } else { }}
    <span style="color: #0C0C0C;">启用</span>
    {{#  } }}
</script>

<script id="classifyNameTpl" type="text/html">
    {{#  if(d.classifyAtairName !== '' && d.classifySecondName !== '' && d.classifyThreeName !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">{{ d.classifyAtairName }}>{{ d.classifySecondName }}>{{ d.classifyThreeName }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">未设置</span>
    {{#  } }}
</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <blockquote class="layui-elem-quote">
            商品类型列表
        </blockquote>
        <%--搜索--%>
        <form class="layui-form layui-form-pane">
           <div class="GoodsTypeInfoTableReload" style="background-color:#f2f2f2;padding:5px 0;">
             <div class="layui-form-item" style="padding: 0;margin: 0">
	            <label class="layui-form-label">类型名称</label>
	            <div class="layui-input-inline">
	                <input class="layui-input" name="styleName" id="styleName">
	            </div>
	            <label class="layui-form-label">分类名称</label>
	            <div class="layui-input-inline">
	                <input class="layui-input" name="classifyName" id="classifyName">
	            </div>
	            <button class="layui-btn layui-btn-sm" data-type="goodsStyle_Sreach" id="goodsStyle_Sreach" style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索</button>
	            <button class="layui-btn layui-btn-sm" data-type="goodsStyle_Reset" id="goodsStyle_Reset" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置</button>
             </div>
           </div>
		</form>
        <div class="layui-inline GoodsTypeInfoManage_Div" style="margin-top: 5px">
            <button class="layui-btn  layui-btn-sm" data-type="GoodsTypeInfo_Del" id="GoodsTypeInfo_Del" ><i class="layui-icon">&#xe640;</i>删除</button>
            <button class="layui-btn  layui-btn-sm" data-type="GoodsTypeInfo_Edit" id="GoodsTypeInfo_Edit" ><i class="layui-icon">&#xe642;</i>编辑</button>
            <button class="layui-btn  layui-btn-sm" data-type="GoodsTypeInfo_Enable" id="GoodsTypeInfo_Enable" ><i class="layui-icon">&#xe617;</i>启用</button>
            <button class="layui-btn  layui-btn-sm" data-type="GoodsTypeInfo_Disable" id="GoodsTypeInfo_Disable" ><i class="layui-icon">&#xe63f;</i>禁用</button>
            <button class="layui-btn  layui-btn-sm" data-type="GoodsTypeInfo_Add" id="GoodsTypeInfo_Add"><i class="layui-icon">&#xe654;</i>添加类型</button>
            <button class="layui-btn  layui-btn-sm" data-type="attributeList" id="attributeList" ><i class="layui-icon">&#xe62d;</i>属性列表</button>
        </div>
        <table class="layui-hide" id="goodsStyleTab" lay-filter="goodsStyleTabFilter"></table>
    </div>
</div>
<%@ include file="/common/footer.jsp"%>
