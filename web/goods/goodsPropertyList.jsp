<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>
<%
    String styleName = request.getParameter("styleName");
    String goodsTypeId = request.getParameter("id");
%>
<style>
    .layui-form-switch {
        width: 80px;
    }
    .layui-form-onswitch i {
        left: 65px;
    }
    .layui-form-switch em {
        right: 28px;
    }
</style>
<script>
    var goodsTypeId="";
    <%--var styleName=<%=styleName%>;--%>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','table', 'element'], function(){
        //
        var laydate = layui.laydate //日期
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作
        var form = layui.form;
        // var table=layui.table; //表格


        //执行一个 table 实例
        table.render({
            elem: '#goodsPropertyTable'
            // ,height: 332
            ,url: '${ctx}/goodsProperty?method=getGoodsPropertyList' //数据接口
            ,page: true //开启分页
            ,limit:20
            ,limits:[20,50,100]
            ,height: 730
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,cols: [[ //表头
                {type:'checkbox', fixed: 'left'}
                ,{LAY_CHECKED : true,field:'id', width:50, title: 'ID',  fixed: 'left'}
                ,{field:'order_num', type:'text', width:150, title: '排序',align:'center',fixed: 'left', templet: '#order_numTpl'}
                ,{field:'attribute_name', width:120, title: '属性名称',align:'center',fixed: 'left'}
                ,{field:'entry_mode', width:150, title: '属性值录入方式',align:'center', templet: '#entry_modeTpl'}
                ,{field:'retrieval_style', width:120, title: '能否检索',align:'center', templet: '#retrieval_styleTpl'}
                ,{field:'attribute_type', width:120, title: '属性类型',align:'center', templet: '#attribute_typeTpl'}
                ,{field:'screening_project', width:120, title: '是否筛选项目',align:'center', templet: '#screening_projectTpl'}
                ,{field:'commonattrbuteisnorelation', width:150, title: '同属性是否关联',align:'center',templet: '#commonattrbuteisnorelationTpl'}
                ,{field:'isnospu', width:120, title: '是否关联商品',align:'center'}
                ,{field:'create_userName', width:120, title: '创建人',align:'center'}
                ,{field:'create_time', width:200, title: '创建时间',align:'center'}
                ,{field:'edit_userName', width:120, title: '操作人',align:'center'}
                ,{field:'edit_time', width:200, title: '操作时间',align:'center'}
            ]]
            ,where: {goodsTypeId: <%=goodsTypeId%>}
        });


        //监听checkbox操作
        form.on('switch(attribute_typeFilter)', function(obj){
            var othis = $(this)
                ,status = (obj.elem.checked?1:2)
                ,id = this.value;
            layer.open({
                type: 1
                ,content: '确认变更属性类型？'
                ,btn: ['确认','取消']
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                ,yes: function(index){
                    $.ajax({
                        type: "get",
                        url : "${ctx}/goodsProperty?method=upGoodsPropertyAttributeType",
                        data:{'id':id,'status':status} ,
                        cache: false,
                        async: false,
                        dataType: "json",
                        success : function(data){
                            if (data.success==1) {
                                layer.closeAll();
                                layer.msg('变更属性类型成功');
                                return false;
                            }
                        },
                        error:function () {
                            layer.closeAll();
                            layer.msg('变更属性类型失败');
                        }
                    })
                }
                // ,btn2:function () {
                //     if ((checkedBool && !switchElement.isChecked()) || (!checkedBool && switchElement.isChecked())) {
                //         switchElement.setPosition(true);
                //         switchElement.handleOnchange(true);
                //     }
                // }
            });

            // layer.tips(this.value + ' ' + this.name + '：'+ obj.elem.checked + obj.elem.title, obj.othis);
        });

        var $ = layui.$, active = {
            GoodsProperty_Add:function () {
                window.location.href="goodsPropertyAdd.jsp?goodsTypeId=<%=goodsTypeId%>&styleName=<%=styleName%>";
            },
            GoodsPropertyValManage:function () {
                var checkStatus = table.checkStatus('goodsPropertyTable');
                var data = checkStatus.data;
                var selectCount = data.length;
                // alert(data.order_num)
                // alert(selectCount)
                if(selectCount==0){
                    layer.msg("请选择一条数据！");
                    return false;
                };
                var ids = "";
                for(var i=0; i<selectCount; i++){
                    ids=checkStatus.data[i].id;
                };
                layer.open({
                    type: 1
                    ,title: ['属性值管理','font-size:18px;']
                    //,offset: 'auto'
                    ,id: 'GoodsPropertyValManageOpen'
                    ,area: ['910px', '450px']
                    ,content: $('#GoodsPropertyValManageDiv')
                    ,moveType: 1 //拖拽模式，0或者1
                    ,btnAlign: 'c' //按钮居中
                    ,resize:false
                    ,yes: function(){
                        layer.closeAll();
                    }
                    ,success:function () {
                        //执行一个 table 实例
                        table.render({
                            elem: '#GoodsPropertyValTable'
                            ,url: '${ctx}/goodsProperty?method=getGoodsPropertyValList' //数据接口
                            ,page: true //开启分页
                            ,limit:10
                            ,limits:[10,20,50]
                            ,height: 340
                            ,response: {
                                statusName: 'success' //数据状态的字段名称，默认：code
                                ,statusCode: 1  //成功的状态码，默认：0
                                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                                ,countName: 'total' //数据总数的字段名称，默认：count
                                ,dataName: 'rs' //数据列表的字段名称，默认：data
                            }
                            ,cols: [[ //表头
                                {type:'checkbox', fixed: 'left'}
                                ,{field:'id', width:80, title: 'ID',  fixed: 'left',align:'center'}
                                ,{field:'attribute_value', width:120, title: '属性值名称',align:'center'}
                                ,{field:'create_user', width:120, title: '创建人',align:'center'}
                                ,{field:'create_time', width:200, title: '创建时间',align:'center'}
                                ,{field:'edit_user', width:120, title: '操作人',align:'center'}
                                ,{field:'edit_time', width:200, title: '操作时间',align:'center'}
                            ]]
                            ,where: {goodsPropertyId: ids}
                        });
                    }
                });
            },
            //属性值列表_删除
            GoodsPropertyVal_Del:function () {
                var checkStatus = table.checkStatus('GoodsPropertyValTable');
                var data = checkStatus.data;
                var selectCount = data.length;
                // alert(data.order_num)
                // alert(selectCount)
                if(selectCount==0){
                    layer.msg("请选择一条数据！");
                    return false;
                };
                var ids = "";
                for(var i=0; i<selectCount; i++){
                    ids=checkStatus.data[i].id;
                };
                layer.open({
                    type: 1
                    ,content: '确认删除？'
                    ,btn: ['确认','取消']
                    ,btnAlign: 'c' //按钮居中
                    ,yes: function(){
                        $.ajax({
                            type: "get",
                            url : "${ctx}/goodsProperty?method=delGoodsPropertyValueInfo",
                            data:{'ids':ids} ,
                            cache: false,
                            async: false,
                            dataType: "json",
                            success : function(data){
                                if (data.success==1) {
                                    layer.closeAll();
                                    layer.msg('删除成功');
                                    return false;
                                }
                            },
                            error:function () {
                                layer.closeAll();
                                layer.msg('删除失败');
                            }
                        })
                    },
                    btn2:function () {
                        layer.closeAll();
                    }
                });
            },
            //属性值列表_添加
            GoodsPropertyVal_Add:function () {
                var checkStatus = table.checkStatus('goodsPropertyTable');
                var data = checkStatus.data;
                var selectCount = data.length;
                var ids = "";
                for(var i=0; i<selectCount; i++){
                    ids=checkStatus.data[i].id;
                };
                $("#GoodsPropertyVal").val("");
                layer.open({
                    type: 1
                    ,title: ['添加属性值']
                    //,offset: 'auto'
                    ,id: 'searchMoreOpen'
                    ,area: ['500px', '250px']
                    ,content: $('#GoodsPropertyValAddDiv')
                    ,btn: ['确认','取消']
                    ,btnAlign: 'r' //按钮居中
                    ,yes: function(){
                        $.ajax({
                            type: "get",
                            url : "${ctx}/goodsProperty?method=addGoodsPropertyValueInfo",
                            data:{'goodsProperty_id':ids,'goodsPropertyVal':$("#GoodsPropertyVal").val()} ,
                            cache: false,
                            async: false,
                            dataType: "json",
                            success : function(data){
                                if (data.success==1) {
                                    layer.closeAll();
                                    layer.msg('添加成功');
                                    return false;
                                }
                            },
                            error:function () {
                                layer.closeAll();
                                layer.msg('添加失败');
                            }
                        })
                    },
                    btn2:function () {
                        layer.closeAll();
                    }
                });
            },
            //属性值列表_编辑
            GoodsPropertyVal_Edit:function () {
                var checkStatus = table.checkStatus('GoodsPropertyValTable');
                var data = checkStatus.data;
                var selectCount = data.length;
                // alert(data.order_num)
                // alert(selectCount)
                if(selectCount==0){
                    layer.msg("请选择一条数据！");
                    return false;
                };
                var ids = "";
                var attribute_value="";
                for(var i=0; i<selectCount; i++){
                    ids=checkStatus.data[i].id;
                    attribute_value=checkStatus.data[i].attribute_value;
                };
                $("#GoodsPropertyVal").val(attribute_value);
                layer.open({
                    type: 1
                    ,title: ['编辑属性值']
                    //,offset: 'auto'
                    ,id: 'searchMoreOpen'
                    ,area: ['500px', '250px']
                    ,content: $('#GoodsPropertyValAddDiv')
                    ,btn: ['确认','取消']
                    ,btnAlign: 'r' //按钮居中
                    ,yes: function(){
                        $.ajax({
                            type: "get",
                            url : "${ctx}/goodsProperty?method=editGoodsPropertyValueInfo",
                            data:{'id':ids,'goodsPropertyVal':$("#GoodsPropertyVal").val()} ,
                            cache: false,
                            async: false,
                            dataType: "json",
                            success : function(data){
                                if (data.success==1) {
                                    layer.closeAll();
                                    layer.msg('编辑成功');
                                    return false;
                                }
                            },
                            error:function () {
                                layer.closeAll();
                                layer.msg('编辑失败');
                            }
                        })
                    },
                    btn2:function () {
                        layer.closeAll();
                    }
                });
            },

        }

        table.on('checkbox(goodsPropertyTableFilter)', function(obj){

            console.log(obj.length)
            var checkStatus = table.checkStatus('goodsPropertyTable');
            var data = checkStatus.data;
            var selectCount = checkStatus.data.length;
        });


        $('.GoodsPropertyManageBut .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        $('.GoodsPropertyValManageBtn .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

    });


    // $(document).ready(function(){
    //
    //     var url = location.search;
    //     var theRequest = new Object();
    //     if ( url.indexOf( "?" ) != -1 ) {
    //         var str = url.substr( 1 ); //substr()方法返回从参数值开始到结束的字符串；
    //         var strs = str.split( "&" );
    //         for ( var i = 0; i < strs.length; i++ ) {
    //             theRequest[ strs[ i ].split( "=" )[ 0 ] ] = ( strs[ i ].split( "=" )[ 1 ] );
    //         }
    //         goodsTypeId=theRequest.id;
    //         $('#styleName').text(decodeURI(decodeURI(theRequest.styleName)));
    //     }
    // });
</script>

<!-- 排序 -->
<script id="order_numTpl" type="text/html">
    <input type="text" style="width: 100px;" name="order_num" value="{{d.order_num}}"  >
</script>
<!-- 属性值录入方式 -->
<script id="entry_modeTpl"  type="text/html">
    <input  type="checkbox" name="entry_modeTplLock" style="lay" value="{{d.entry_modeTpl}}" title="" lay-skin="switch" lay-text="选择录入|手动录入" lay-filter="entry_modeTplFilter" {{ d.entry_modeTpl == 1 ? 'checked' : '' }}>
</script>
<!-- 能否检索 -->
<script id="retrieval_styleTpl" type="text/html">
    <input  type="checkbox" name="lock" value="{{d.retrieval_style}}" title="" lay-skin="switch" lay-text="是|否" lay-filter="retrieval_styleFilter" {{ d.retrieval_style == 1 ? 'checked' : '' }}>
</script>
<!-- 属性类型 -->
<script type="text/html" id="attribute_typeTpl">
    <input  type="checkbox" name="attribute_typeLock" value="{{d.id}}" title="属性类型" lay-skin="switch" lay-text="商品属性|销售属性" lay-filter="attribute_typeFilter" {{ d.attribute_type == 1 ? 'checked' : '' }}>
</script>
<!-- 是否筛选项目 -->
<script type="text/html" id="screening_projectTpl">
    <input  type="checkbox" name="lock" value="{{d.screening_project}}" title="启用" lay-skin="switch" lay-text="是|否" lay-filter="screening_projectFilter" {{ d.screening_project == 1 ? 'checked' : '' }}>
</script>
<!-- 同属性是否关联 -->
<script type="text/html" id="commonattrbuteisnorelationTpl">
    <input  type="checkbox" name="lock" value="{{d.commonattrbuteisnorelation}}" title="启用" lay-skin="switch" lay-text="是|否" lay-filter="commonattrbuteisnorelationFilter" {{ d.commonattrbuteisnorelation == 1 ? 'checked' : '' }}>
</script>


<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding: 15px;">
        <blockquote class="layui-elem-quote"style="margin-top: -10px">
            <label id="styleName"><%=styleName%></label> 属性列表
        </blockquote>
        <blockquote class=" GoodsPropertyManageBut">
            <button class="layui-btn layui-btn-sm" data-type="GoodsProperty_Add" id="GoodsProperty_Add"><i class="layui-icon">&#xe654;</i>添加属性</button>
            <button class="layui-btn layui-btn-sm" data-type="GoodsPropertyValManage" id="GoodsPropertyValManage"><i class="layui-icon">&#xe614;</i>属性值管理</button>
            <%--<button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">确认排序</button>--%>
            <%--<button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">禁止检索</button>--%>
            <%--<button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">允许检索</button>--%>
            <%--<button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">删除</button>--%>
            <%--<button data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">编辑</button>--%>
            <%--<a id="btnSelectValue" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm">可选值</a>--%>

        </blockquote>
        <table class="layui-hide" id="goodsPropertyTable" lay-filter="goodsPropertyTableFilter"></table>
    </div>
</div>




<!-- 可选值 表格-->
<div id="GoodsPropertyValManageDiv" style="display: none; margin-left: 10px">
    <div class="GoodsPropertyValManageBtn" style="margin-top: 10px">
        <button class="layui-btn  layui-btn-sm" data-type="GoodsPropertyVal_Del" ><i class="layui-icon">&#xe640;</i>删除</button>
        <button class="layui-btn  layui-btn-sm" data-type="GoodsPropertyVal_Add" ><i class="layui-icon">&#xe654;</i>添加属性值</button>
        <button class="layui-btn  layui-btn-sm" data-type="GoodsPropertyVal_Edit" ><i class="layui-icon">&#xe642;</i>编辑属性值</button>
    </div>
    <table class="layui-hide" id="GoodsPropertyValTable" lay-filter="GoodsPropertyValFilter"></table>
</div>




<!-- 添加可选值 -->
<div id="GoodsPropertyValAddDiv" style="display: none; margin-top: 30px;margin-left: 30px">
    <label class="layui-label">属性值名称:</label>
    <div class="layui-input-inline">
            <input type="layui-input" name="GoodsPropertyVal" id="GoodsPropertyVal" lay-verify="title"  placeholder="请输入名称">
    </div>
</div>






<%@ include file="/common/footer.jsp"%>