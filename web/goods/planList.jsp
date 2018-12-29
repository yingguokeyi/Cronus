<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>
<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>


<script>

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });


    //JavaScript代码区域
    layui.use(['laydate', 'layer','table', 'element'], function(){
        var element = layui.element;

        var laydate = layui.laydate //日期
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作
        var form = layui.form;


        //执行一个 table 实例
        table.render({
            elem: '#test'
            	,height: 'full-247'
            ,cellMinWidth: 190
            ,url: '${ctx}/plan?method=getPlanList' //数据接口
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1  //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , limit: 20 //每页显示的条数
            , limits: [20, 50, 100]
            ,id:'listTable'
            ,page: true //开启分页
            ,cols: [[ //表头
                {type: 'checkbox', fixed: 'left', field: "ids"}
                ,{field:'sort', title: '排序号',edit:true}
                ,{field:'title', title: '标题'}
                ,{field:'category', title: '类型',templet:'#categoryTpl'}
                ,{field:'uri',templet: '#Tp1',title: '参数'}
                ,{field:'goods_name',width:420,title: '商品名称'}
                ,{field:'plan_group',templet: '#Tp2', title: '栏位',templet: '#planGroupTpl',}
                ,{field:'promote', title: '推荐语'}
                ,{field:'memo', title: '备注'}
                ,{field:'hahaha', width:220, fixed: 'right', align:'center',title: '操作',toolbar:"#barDemo"}
            ]]

        });

        // $('.demoTableReload .layui-btn').on('click', function(){
        //     var type = $(this).data('type');
        //     active[type] ? active[type].call(this) : '';
        // });


        //监听工具条
        table.on('tool(tableFilter)', function(obj){
            //var id = this.value;
            //var value = this.data;
            //layer.alert('编辑行：<br>'+ JSON.stringify(data) + '<br>');

            var othis = $(this);
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('确认删除?', function(index){
                    //layer.msg(data.id);
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存

                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/plan",
                        data: "method=deleleGoodsPlanInfo&ids="+data.id,
                        cache: false,
                        async : false,
                        dataType: "json",
                        success:function(data) {
                            if(data.success){
                                layer.msg('删除成功',{time:2000}, function(){
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
                var spu_id = data.uri.split("=")[1];
                if(data.category == '1'){
                    $('#ad_spu_id').val(spu_id);//放入spu_id

                    var title = "修改【"+data.title+"】的首页推荐数据" ;
                    addPlanIndex =layer.open({  //打开添加推荐页
                        type: 1
                        ,title: title
                        ,offset: 'auto'
                        ,id: 'addPlanOpen'
                        //,area: ['800px', '550px']
                        ,area: ['60%','60%']
                        ,content: $('#addPlanDiv')
                        //,btn: '关闭'
                        ,btnAlign: 'c' //按钮居中
                        ,shade: 0 //遮罩
                        ,yes: function(){
                            layer.closeAll();
                        }
                        ,end: function () {   //层销毁后触发的回调
                            //将所有的表单数据置为空
                            $(':input','#planForm')
                                .not(':button, :submit, :reset')
                                .val('')
                                .removeAttr('checked')
                                .removeAttr('selected');
                            $('#plan_img').attr('src','');
                        }
                    });

                    //获取首页推荐数据
                    getGoodsPlanInfo(spu_id);

                }else{

                    //TODO
                }



            }
        });


        //监听单元格编辑(排序)
        table.on('edit(tableFilter)', function(obj){
            var value = obj.value //得到修改后的值
                ,data = obj.data //得到所在行所有键值
                ,field = obj.field; //得到字段
            var othis = $(this);

            if(!(/^\d+$/.test(value))){
                othis.val(0);
                layer.tips('[名称:'+data.spu_name+ ']的排序号请输入正整数，已归置为0，请重新输入！', othis);
                return false;
            }
            var that = othis;
            $.ajax({
                type: "get",
                url: "${ctx}/plan",
                data: "method=updatePlanSort&sort=" + value +"&id="+data.id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('[标题:'+ obj.data.title +']的排序号，更改成功!');
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




        //点击按钮 搜索推荐记录
        $('#planSearchBtn').on('click', function(){
            var title = $("#title");
            var category = $ ("#s_category");
            var plan_group =  $("#s_plan_group");
            var promote =  $("#s_promote");

            //执行重载
            table.reload('listTable', {
                page: {
                    curr: 1
                }
                , where: {
                    title: title.val(),
                    category:category.val(),
                    plan_group:plan_group.val(),
                    promote:promote.val()
                }
            });

            return false;
        });


        //点击按钮 商品搜索
        $('#g_searchBtn').on('click', function () {

            //执行重载
            var stopSale = "";
            table.reload('listGoods', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    spu_name: $('#g_spu_name').val(),
                    goods_source: $('#g_goods_source').val(),
                    spu_code: $('#g_spu_code').val(),
                    cateName: $('#g_cateName').val(),
                    goodsTypeName: $('#g_goodsTypeName').val(),
                    status: $('#g_status').val(),
                    //spu_code: $('#spu_code').val(),
                    stopSale: stopSale
                }
            });
            return false;
        });

        //点击按钮 批量删除
        $('#bashDeleteBtn').on('click', function(){

            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('真的要将选中项删除吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/plan",
                        data: "method=deleleGoodsPlanInfo&ids=" + ids,   //批量删除
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
        //点击按钮 增加推荐
        var listGoodsIndex;
        $('#addPlanBtn').on('click', function(){

            listGoodsIndex =layer.open({
                type: 1
                ,title: '提示：请选定一个商品进行首页推荐'
                ,offset: 'auto'
                ,id: 'listGoodsOpen'
                //,area: ['800px', '550px']
                ,area: ['75%','80%']
                ,content: $('#listGoodsDiv')
                //,btn: '关闭'
                ,btnAlign: 'c' //按钮居中
                ,shade: 0 //遮罩
                ,yes: function(){
                    //layer.closeAll();
                }
                ,end: function () {   //层销毁后触发的回调

                }
            });

            //获取商品来源
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/goods",
                data: "method=getValidGoodsSourceList",
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        var array = data.result.rs;
                        if (array.length > 0) {
                            for (var obj in array) {
                                $("#g_goods_source").append("<option value='" + array[obj].goodsSource_Code + "'>" + array[obj].goodsSource_Name + " [" + array[obj].goodsSource_Code + "]" + "</option>");
                            }
                        }
                        //(注意：需要重新渲染)
                        form.render('select');
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });


            //执行一个 table 实例
            table.render({
                elem: '#listGoods'
                	,height: 'full-247'
                ,cellMinWidth: 190
                , url: '${ctx}/plan?method=getExcGoodsList&online=1'
                , response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    , statusCode: 1  //成功的状态码，默认：0
                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    , countName: 'total' //数据总数的字段名称，默认：count
                    , dataName: 'rs' //数据列表的字段名称，默认：data
                }
                , id: 'listGoods'
                , limit: 10 //每页显示的条数
                , limits: [10, 50, 100]
                , page: true //开启分页
                , cols: [[ //表头
                    {field: 'spu_name',width: 450, title: 'SPU-商品名称'}
                    , {field: 'spu_code', title: '商品编码'}
                    ,{field:'sourceName', title: '商品来源'}
                    ,{field:'brandName', title: '品牌'}
                    , {field: 'cateName', title: '商品分类'}
                    , {field: 'goodsTypeName', title: '商品类型'}
                    , {field: 'editTime', title: '编辑时间'}
                    , {field: 'nick_name', title: '操作者'}
                    , {field: 'status', title: '状态',templet: '#goodsStatusTpl',}
                    , {field: 'memo', title: '备注'}
                    , {field: 'wealth', width: 230, fixed: 'right', align: 'center', title: '操作', toolbar: "#listGoodsBar"}
                ]]
            });

            return false;
        });

        //监听listGoods工具条
        var addPlanIndex;
        table.on('tool(listGoodsFilter)', function(obj){
            var data = obj.data;
            if(obj.event === 'selected'){
                var spu_id = data.id;
                $('#ad_spu_id').val(spu_id);//放入spu_id
                var title = "将【"+data.spu_name+"】加入首页推荐" ;
                addPlanIndex =layer.open({  //打开添加推荐页
                    type: 1
                    ,title: title
                    ,id: 'addPlanOpen'
                    ,area: ['60%','60%']
                    ,content: $('#addPlanDiv')
                    ,btnAlign: 'c' //按钮居中
                    ,shade: 0 //遮罩
                    ,yes: function(){
                        layer.closeAll();
                    }
                    ,end: function () {   //层销毁后触发的回调
                        //将所有的表单数据置为空
                        $(':input','#planForm')
                            .not(':button, :submit, :reset')
                            .val('')
                            .removeAttr('checked')
                            .removeAttr('selected');
                        $('#plan_img').attr('src','');
                    }
                });
                $('#planImgDiv').hide();
            }
        });

        function getGoodsPlanInfo(spu_id){
            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=getGoodsPlanInfo&spuId="+spu_id,
                dataType: "json",
                async:true,
                success: function (data) {
                    if (data.success) {
                        if(data.rs[0].id){
                            $('#ad_title').val(data.rs[0].title);
                            $('#plan_group').val(data.rs[0].plan_group);
                            $('#ad_sort').val(data.rs[0].sort);
                            $('#ad_memo').val(data.rs[0].memo);
                            $('#ad_promote').val(data.rs[0].promote);
                            $('#ad_id').val(data.rs[0].id);

                            if(data.rs[0].img_id!=""){
                                $('#plan_img').attr('src',data.rs[0].img_path);
                                $('#imgDiv').show();
                                $('#imgId').val(data.rs[0].img_id);
                                $('#planImgDiv').show();
                            }else{
                                $('#planImgDiv').hide();
                            }
                            form.render('checkbox');
                            form.render('select');
                        }
                    }
                },
                error: function (error) {
                    console.log("error=" + error);
                }
            });
        };

        //点击按钮 保存加入到首页推荐
        $('#savePlanBtn').on('click', function(){
            var ad_title = $("#ad_title").val();
            var imgId = $('#imgId').val();
            if(ad_title.length < 2){
                layer.msg('首页推荐标题至少输入2个字符！');
                $("#ad_title").focus();
                return false;
            }
            if($("#plan_group").val()==""){
                layer.msg('请选择首页显示位置');
                return false;
            }
            var ad_sort = $("#ad_sort").val();
            if(!(/^\d+$/.test(ad_sort)) && ad_sort!=""){
                layer.msg('排序号请输入正整数！');
                $("#ad_sort").focus();
                return false;
            }

            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=saveGoodsPlan",
                data: {jsonString:JSON.stringify($('#planForm').serializeObject())},
                contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                cache: false,
                async : false,
                dataType: "json",
                success:function(data) {
                    console.log("   data   is   "+data.success);
                    if(data.success){
                        layer.msg('保存成功!',{time:1000}, function(){
                            layer.close(addPlanIndex);
                            table.reload('listTable')
                        });
                    }else{
                        layer.msg("异常");
                    }
                },
                error : function() {
                    layer.alert("错误");
                }
            });
            return false;
        });
    });

</script>

<script type="text/html" id="categoryTpl">
    {{d.category=='1'?'类型一':'类型二'}}
</script>

<script type="text/html" id="planGroupTpl">
    {{#  if(d.plan_group === '1'){ }}
    <span>首页banner</span>
    {{#  } else if(d.plan_group === '2'){ }}
    <span>产品推荐</span>
    {{#  } else if(d.plan_group === '3'){ }}
    <span>超值爆款</span>
    {{#  } else if(d.plan_group === '4'){ }}
    <span>底价打折</span>
    {{#  } else if(d.plan_group === '5'){ }}
    <span>推荐商品</span>
    {{#  } else if(d.plan_group === '6'){ }}
    <span>活动商品</span>
    {{#  } else if(d.plan_group === '7'){ }}
    <span>自营秒杀</span>
    {{#  } else if(d.plan_group === '8'){ }}
    <span>特惠专区</span>
    {{#  } else if(d.plan_group === '9'){ }}
    <span>免费领</span>
    {{#  } else if(d.plan_group === '10'){ }}
    <span>超市精选定期送</span>
    {{#  } else if(d.plan_group === '11'){ }}
    <span>自命命专区</span>
    {{#  } else if(d.plan_group === '12'){ }}
    <span>足迹推荐</span>
    {{#  } }}
</script>

<script type="text/html" id="goodsStatusTpl">
    {{#  if(d.status === '1'){ }}
    <span>上架</span>
    {{#  } else if(d.status === '0'){ }}
    <span>下架</span>
    {{#  } }}
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            首页推荐管理
        </div>
        <form class="layui-form layui-form-pane">
            <div style="background-color:#f2f2f2;padding:5px 0;">
                <div class="layui-form-item" style="padding: 0;margin: 0">
                    <label class="layui-form-label">标题</label>
                    <div class="layui-input-inline">
                        <input type="text" id="title" name="title" class="layui-input">
                    </div>
                    <label class="layui-form-label">类型</label>
                    <div class="layui-input-inline">
                        <select id="s_category" name="s_category">
                            <option value="">请选择</option>
                            <option value="1">类型一</option>
                            <option value="2">类型二</option>
                        </select>
                    </div>
                    <label class="layui-form-label">栏位</label>
                    <div class="layui-input-inline">
                        <select id="s_plan_group" name="s_plan_group">
                            <option value="">请选择</option>
                            <option value="1">首页banner区</option>
                            <option value="2">产品推荐</option>
                            <option value="3">超值爆款</option>
                            <option value="4">底价打折</option>
                            <option value="5">推荐商品</option>
                            <option value="6">活动商品</option>
                            <option value="7">自营秒杀</option>
                            <option value="8">特惠专区</option>
                            <option value="9">免费领</option>
                            <option value="10">超市精选定期送</option>
                            <option value="11">自命题专区</option>
                            <option value="12">足迹推荐</option>

                        </select>
                    </div>
                    <label class="layui-form-label">推荐语</label>
                    <div class="layui-input-inline">
                        <input type="text" id="s_promote" name="s_promote" class="layui-input">
                    </div>
                    <button id="planSearchBtn" data-type="sreach" class="layui-btn layui-btn-sm"  style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button type="reset" class="layui-btn layui-btn-sm"  style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </div>

            <div>
                <button id="bashDeleteBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe640;</i>批量删除</button>
                <button id="addPlanBtn" data-type="auto" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe61f;</i>添加推荐</button>
            </div>

        </form>

        <table class="layui-hide" id="test" lay-filter="tableFilter"></table>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius"  lay-event="del">删除</a>
        </script>

    </div>
</div>
<!-- 罗列商品 start -->
<div id="listGoodsDiv" style="display: none;padding: 15px;">

    <form class="layui-form" id="listGoodsForm" >
        <div style="background-color:#f2f2f2;">

            <div class="layui-form-item" style="padding: 15px;">

                <label class="layui-label">商品名称</label>
                <div class="layui-inline">
                    <input type="text" id="g_spu_name" name="g_spu_name" lay-verify="title" autocomplete="off" placeholder="" class="layui-input">
                </div>
                <label class="layui-label">商品来源</label>
                <div class="layui-inline">
                    <select id="g_goods_source" name="g_goods_source">
                        <option value="">请选择</option>
                    </select>
                </div>
                <%--<label class="layui-label">状态</label>
                <div class="layui-inline">
                    <select id="g_status" name="g_status" lay-filter="aihao">
                        <option value=""></option>
                        <option value="1">上架</option>
                        <option value="0">下架</option>
                    </select>
                </div>--%>
                <label class="layui-label">商品分类</label>
                <div class="layui-inline">
                    <input type="text" id="g_cateName" name="g_cateName" class="layui-input">
                </div>
                <label class="layui-label">商品类型</label>
                <div class="layui-inline">
                    <input type="text" id="g_goodsTypeName" name="g_goodsTypeName" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button id="g_searchBtn" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </div>
        </div>

    </form>
    <table class="layui-hide" id="listGoods" lay-filter="listGoodsFilter"></table>
    <script type="text/html" id="listGoodsBar">
        <%--<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>--%>
        <a class="layui-btn layui-btn-sm layui-btn-normal"  lay-event="selected">选定</a>
    </script>

</div>
<!-- 罗列商品 end -->



<!-- 加入首页推荐 start -->
<div id="addPlanDiv" style="display: none;">
    <form id="planForm" class="layui-form" style="padding: 15px;">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px">标题</label>
            <div class="layui-input-inline">
                <input id="ad_title" name="ad_title" lay-verify="ad_title" autocomplete="off" placeholder="" class="layui-input" type="text">

                <input id="ad_spu_id" name="ad_spu_id" type="hidden">
                <input id="ad_id" name="ad_id"  type="hidden">
            </div>
        </div>


        <div class="layui-form-item" id="planImgDiv">
            <label class="layui-form-label" style="width: 150px">图片</label>
            <div class="layui-input-inline">

                <%--<button type="button" class="layui-btn" id="uploadImg">--%>
                    <%--<i class="layui-icon">&#xe67c;</i>上传推荐图--%>
                <%--</button>--%>

                <div class="layui-upload-list" id="imgDiv">
                    <img class="layui-upload-img" id="plan_img">
                    <input type="hidden" id="imgId" name="imgId" value="" lay-verify="required" autocomplete="off">
                    <p id="imgP"></p>
                </div>


            </div>
        </div>



        <div class="layui-form-item">
            <div class="layui-inline" >
                <label class="layui-form-label" style="width: 150px">首页显示位置: </label>
                <div class="layui-input-inline" >
                    <select id="plan_group" name="plan_group">
                        <option value="">请选择</option>
                        <option value="1">首页banner区</option>
                        <option value="2">产品推荐</option>
                        <option value="3">超值爆款</option>
                        <option value="4">底价打折</option>
                        <option value="5">推荐商品</option>
                        <option value="6">活动商品</option>
                        <option value="7">自营秒杀</option>
                        <option value="8">特惠专区</option>
                        <option value="9">免费领</option>
                        <option value="10">超市精选定期送</option>
                        <option value="11">自命名专区</option>
                        <option value="12">足迹推荐</option>
                    </select>
                </div>
            </div>
        </div>


        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px">备注 : </label>
            <div class="layui-input-inline">
                <input style="width: 500px;" id="ad_memo"  name="ad_memo" lay-verify="ad_memo" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px">促销语(promote) : </label>
            <div class="layui-input-inline">
                <input style="width: 500px;" id="ad_promote"  name="ad_promote" lay-verify="ad_promote" autocomplete="off" placeholder="" class="layui-input" type="text">
            </div>
        </div>


        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px">排序号 : </label>
            <div class="layui-input-inline">
                <input style="width: 500px;" id="ad_sort" name="ad_sort" lay-verify="ad_sort" autocomplete="off" placeholder="" class="layui-input" type="text">
            </div>
        </div>




        <div class="layui-form-item">
            <div class="layui-input-block" align="center">
                <button class="layui-btn" id="savePlanBtn" lay-submit="" lay-filter="demo1"><i class="layui-icon">&#xe615;</i>保存</button>
                <button type="reset" class="layui-btn"><i class="layui-icon">&#x2746;</i>重置</button>
            </div>
        </div>



    </form>
</div>
<!-- 加入首页推荐 end -->


<%@ include file="/common/footer.jsp"%>