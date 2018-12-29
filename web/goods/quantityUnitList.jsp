<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<script>

    layui.config({
        version: '1515376178738'
    });

    layui.use(['laydate','layer','table', 'element'], function(){
        var $ = layui.jquery;
        var form = layui.form;
        var layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作

        //执行一个 table 实例
        table.render({
            elem: '#listTable'
            	,height: 'full-247'
            ,cellMinWidth: 190
            ,url: '${ctx}/goods?method=getQuantityUnitList'
            //,url: './data/user.json' //数据接口
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            ,id:'listReload'
            ,page: true //开启分页
            ,cols: [[ //表头
                {type:'checkbox', fixed: 'left',field:"ids"}
                ,{field:'sort', title: '排序号',edit:'text'}
                ,{field:'dict_data_name',title: '单位名称'}
                ,{field:'memo', title: '备注'}
                ,{field:'wealth', width:240, align:'center',title: '操作',toolbar:"#barDemo"}
            ]]
        });

        var addUnitIndex;
        table.on('tool(tableFilter)', function(obj){
            //var id = this.value;
            //var value = this.data;
            //layer.alert('编辑行：<br>'+ JSON.stringify(data) + '<br>');
            var othis = $(this);
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('确认删除?', function(index){
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goods",
                        data: "method=deteleQuantityUnit&unitId="+data.id,
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
                var title = "修改【"+data.dict_data_name+"】的数据" ;
                addUnitIndex =layer.open({  //打开修改
                    type: 1
                    ,title: title
                    ,offset: 'auto'
                    ,id: 'editUnitOpen'
                    //,area: ['800px', '550px']
                    ,area: ['40%', '30%']
                    ,content: $('#openDemo')
                    //,btn: '关闭'
                    ,btnAlign: 'c' //按钮居中
                    ,shade: 0 //遮罩
                    ,yes: function(){
                        layer.closeAll();
                    }
                    ,end: function () {   //层销毁后触发的回调
                        //将所有的表单数据置为空
                        $(':input','#unitForm').not(':button, :submit, :reset').val('');
                    }
                });

                //获取数量单位数据
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods?method=getQuantityUnit&unitId="+data.id,
                    dataType: "json",
                    async:true,
                    success: function (data) {
                        if (data.success) {
                            if(data.rs[0].id){
                                $('#unitName').val(data.rs[0].dict_data_name);
                                $('#memo').val(data.rs[0].memo);
                                $('#unitId').val(data.rs[0].id);

                            }
                        }
                    },
                    error: function (error) {
                        console.log("error=" + error);
                    }
                });

            }
        });

        //监听启用禁用操作
        form.on('switch(fixedFilter)', function (obj) {
            var othis = $(this)
                , status = (othis.data('method') ? 0 : 1)
                , id = this.value;

            var that = obj.othis;
            $.ajax({
                type: "get",
                url: "${ctx}/goods",
                data: "method=updateQuantityUnitStatus&status=" + status + "&id=" + id,
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

        //监听单元格编辑(排序)
        table.on('edit(tableFilter)', function(obj){
            var value = obj.value //得到修改后的值
                ,data = obj.data //得到所在行所有键值
                ,field = obj.field; //得到字段
            var othis = $(this);

            if(!(/^\d+$/.test(value))){
                othis.val(0);
                layer.tips('[名称:'+data.dict_data_name+ ']的排序号请输入正整数，已归置为0，请重新输入！', othis);
                return false;
            }
            var that = othis;
            $.ajax({
                type: "get",
                url: "${ctx}/goods",
                data: "method=updateQuantityUnitSort&sort=" + value +"&id="+data.id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('名称为"'+ obj.data.dict_data_name +'"的排序号，更改成功!', {time: 2000}, function () {
                            //执行重载
                            table.reload('listReload', {
                                page: {
                                    curr: 1 //重新从第 1 页开始
                                }
                                , where: {
                                    searchName: $("#searchName").val()
                                }
                            });
                        });



                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    //that.val(0);
                    layer.alert("错误");
                }
            });
        });

        //点击按钮 搜索
        $('#searchBtn').on('click', function () {
            var searchName = $("#searchName").val();

            //执行重载
            table.reload('listReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    searchName: $("#searchName").val()
                }
            });

        });


        //点击按钮
        $('#addUnitBtn').on('click', function () {
            addUnitIndex = layer.open({
                type: 1
                , title: '添加数量单位'
                ,offset: 'auto'
                , id: 'layerDemo'
                , area: ['40%', '30%']
                , content: $('#openDemo')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                , yes: function () {
                    layer.closeAll();
                }
                ,end: function () {   //层销毁后触发的回调
                    //将所有的表单数据置为空
                    $(':input','#unitForm').not(':button, :submit, :reset').val('');
                }
            });
        });

        //点击按钮 保存单位数量
        $('#saveUnitBtn').on('click', function () {
            var unitName = $("#unitName").val();
            var memo = $("#memo").val();
            var unitId =  $("#unitId").val();
            //校验
            if (unitName.length < 1) {
                layer.msg('来源名称至少得1个字符');
            } else {
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods",
                    data: "method=addQuantityUnit&unitName=" + encodeURI(unitName)  + "&memo=" + encodeURI(memo)+"&unitId=" + unitId ,
                    cache: false,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        var str = "添加";
                        if(unitId){
                            str = "修改";
                        }
                        if (data.result == "fail") {
                            layer.msg(str+"失败，可能存在重复的数量单位，请检查！");
                        } else {
                            layer.close(addUnitIndex);
                            layer.msg(str+'数量单位成功！', {time: 2000}, function () {
                                //执行重载
                                table.reload('listReload', {
                                    page: {
                                        curr: 1 //重新从第 1 页开始
                                    }
                                    , where: {
                                        searchName: $("#searchName").val()
                                    }
                                });
                            });
                        }

                    },
                    error: function () {
                        layer.msg('添加失败', {time: 2000}, function () {

                        });
                    }
                });

            }
            return false;
        });

    });


</script>

<script id="urlTpl" type="text/html">
    <a href="http://{{d.url}}" target="_blank">{{d.url}}</a>
</script>

<script type="text/html" id="barDemo">
    <input type="checkbox" name="is_fixed" value="{{d.id}}" lay-skin="switch" lay-text="常用|少用"
           data-method="{{d.is_fixed}}" lay-filter="fixedFilter" {{ d.is_fixed== 1 ? 'checked' : '' }}>
    &nbsp;&nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit"><i class="layui-icon">&#xe642;</i>编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="del"><i class="layui-icon">&#xe640;</i>删除</a>
</script>



<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            单位名称列表
        </div>
        <form class="layui-form layui-form-pane">
        <div style="background-color:#f2f2f2;padding:5px 0;">
            <div class="layui-form-item" style="padding: 0;margin: 0">
                <label class="layui-form-label" style="width:180px">单位名称</label>
                <div class="layui-input-inline">
                    <input type="text" id="searchName" name="searchName" class="layui-input">
                </div>
				<button id="searchBtn" class="layui-btn  layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索</button>
            </div>
        </div>
        <div>
            <button id="addUnitBtn" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe61f;</i>添加单位名称</button>
        </div>
 		</form>
        <table class="layui-hide" id="listTable" lay-filter="tableFilter"></table>
    </div>
</div>

    <!-- 保存数据区域-->
    <div id="openDemo" style="display: none;padding: 15px;">
        <form id="unitForm" class="layui-form" action="">

            <div class="layui-form-item">
                <label class="layui-form-label" style="width:120px">数量单位名称:</label>
                <div class="layui-input-inline" style="width: 400px">
                    <input type="text" id="unitName" name="unitName" lay-verify="required" class="layui-input" autocomplete="off"
                           placeholder="请输入名称，如果有多个用英文逗号“,”分隔,例如:张,个,只,箱" >
                    <input type="hidden" id="unitId" name="unitId">

                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label" style="width:120px">备注:</label>
                <div class="layui-input-inline" style="width: 400px">
                    <input id="memo" name="memo" lay-verify="title1" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>



            <div class="layui-form-item">
                <label class="layui-form-label" style="width:120px">&nbsp;&nbsp;</label>
                <div class="layui-input-inline">
                    <button id="saveUnitBtn" class="layui-btn" lay-filter="saveFilter">保存</button>
                </div>
            </div>

        </form>
    </div>


<%@ include file="/common/footer.jsp" %>