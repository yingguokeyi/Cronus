<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>
<script>
    //JavaScript代码区域
    layui.use(['laydate', 'upload', 'layer', 'table', 'element', 'laypage'], function () {
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table //表格
            , upload = layui.upload
            , laypage = layui.laypage
            , element = layui.element; //元素操作
        var form = layui.form;
        //执行一个 table 实例
        table.render({
            elem: '#goodsList'
            , height: 'full-290'
            , url: '${ctx}/pddGoods?method=getPddGoodsList'
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            // ,curr:{curr}
            , id: 'listTable'
            , limit: 100 //每页显示的条数
            , limits: [50, 100, 500, 1000]
            , page: {
                curr: 1
            } //开启分页
            , cols: [[ //表头
                {type:'numbers',fixed: 'true',align:'center'}
                ,{type: 'checkbox', fixed: 'left'}
                , {field: 'goods_name', width: 300, title: 'SKU-商品名称', align: 'center'}
                , {field: 'goods_thumbnail_url', width: 200, title: '缩略图',align:'center',templet: '#imgPath'}
                , {field: 'status', width: 90, title: '销售状态', align: 'center', templet: '#statusId'}
                , {field: 'goods_id', width: 130, title: 'SKU商品编码', align: 'center'}
                , {field: 'opt_name', width: 90, title: '商品类目', align: 'center'}
                /*, {field: 'goods_type', width: 90, title: '商品类型', align: 'center', }*/
                , {field: 'promotion_rate', width: 100, title: '佣金比',align:'center',templet: function (d) {
                        var index="";
                        if(d.promotion_rate==""){
                            index="--";
                        }else {
                            var index = d.promotion_rate/10 + "%";
                        }
                        return index;
                    }
                }
                , {field: 'sold_quantity', width: 100, title: '已售卖件数', align: 'center',}
                , {field: 'coupon_total_quantity', width: 130, title: '优惠券总量', align: 'center', }
                , {field: 'coupon_remain_quantity', width: 130, title: '优惠券剩余量', align: 'center', }
                /*, {field: 'cat_id', width: 90, title: '包装数量', align: 'center', }*/
                , {field: 'min_group_price', width: 130, title: '拼团价格（元）', align: 'center',templet:function (d) {
                        return '￥'+(d.min_group_price / 100).toFixed(2);
                    }}
                , {field: 'min_normal_price', width: 130, title: '单买价格（元）', align: 'center',templet:function (d) {
                        return '￥'+(d.min_normal_price / 100).toFixed(2);
                    }}
                //, {field: 'create_date', width: 300, title: '录入时间',align:'center',templet: '#editTimeTmpl'}
                //, {field: 'edit_date', width: 300, title: '最后编辑时间', sort: true, align: 'center', templet: '#editTimeTmp2'}
                //, {field: 'user_name', width: 160, title: '最后操作者', align: 'center'}
                , {field: 'wealth', width: 190, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
            ]]
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });

//开启location.hash的记录
        laypage.render({
            elem: 'goodsList'
            , count: 70 //数据总数，从服务端得到
            , jump: function (obj, first) {
                //obj包含了当前分页的所有参数，比如：
                console.log("1111" + obj.curr); //得到当前页，以便向服务端请求对应页的数据。
                console.log(obj.limit); //得到每页显示的条数
                //首次不执行
                if (!first) {
                    alert(222)
                }
            }
        });

//点击按钮 搜索商品
        $('#searchBtn').on('click', function () {
            var isChecked = $('#showStopSale').prop('checked');
            var stopSale = "";
            if (isChecked) {
                stopSale = "show";
            }
            var spu_name = $('#spu_name');
            var spu_code = $('#spu_code');
            var status = $('#status');
            var goods_source = $('#goods_source');
            var promotion_rate = $('#promotion_rate');
            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    spuName: spu_name.val(),
                    state: status.val(),
                    spuCode: spu_code.val(),
                    goods_source:goods_source.val(),
                    promotionRate:promotion_rate.val(),
                    stopSale: stopSale
                }
            });
            return false;
        });


//监听"checkbox"操作
        form.on('checkbox(checkboxFilter)', function (obj) {
            $('#searchBtn').click();
        });
        //监听上架下架操作
        form.on('switch(statusFilter)', function (obj) {
            var othis = $(this), id = othis.data('value');
            //var status = ((this.value)?0:1); //值反转
            var status = (($('#' + "switch" + id).val() == "1") ? 0 : 1);//值反转
            //layer.tips(this.value + ' ' + this.name + '：'+ obj.elem.checked + status, obj.othis);
            var that = obj.othis;
            othis.prop("checked", true); //还原
            form.render('checkbox');
            if (status) {
                // 等于1 是否要上架
                layer.msg('确定要上架商品吗?', {
                    skin: 'layui-layer-molv' //样式类名  自定义样式
                    , closeBtn: 1    // 是否显示关闭按钮
                    , anim: 1 //动画类型
                    , btn: ['确定', '取消'] //按钮
                    , icon: 6    // icon
                    , yes: function () {
                        SendPost(status, id, othis);
                    }
                    , btn2: function () {
                        table.reload('listTable');
                    }
                });

            } else {
                //等于0 是否要下架
                layer.msg('确定要下架改商品吗?', {
                    skin: 'layui-layer-molv' //样式类名  自定义样式
                    , closeBtn: 1    // 是否显示关闭按钮
                    , anim: 1 //动画类型
                    , btn: ['确定', '取消'] //按钮
                    , icon: 6    // icon
                    , yes: function () {
                        SendPost(status, id, othis);
                    }
                    , btn2: function () {
                         table.reload('listTable');
                    }
                });
            }


        });
//点击"添加商品"按钮
        $('#btnGoodImport').on('click', function () {
            var text = "Demo Demo";
            layer.open({
                type: 1
                , title: '添加商品'
                //,offset: 'auto'
                , id: 'goodImportOpen'
                , area: ['700px', '500px']
                , content:
                '<label style="margin-left: 110px;margin-top: 100px;font-size:18px" >商品名称<span style="color: red">*</span></label> ' +
                '<input type="text" name="spuName" id="spuId" style="margin-top: 100px;width: 200px;height: 35px;"/>' +
                '<br><label style="margin-left: 110px;margin-top: 100px;font-size:18px" >奖励金<span style="color: red">*</span></label> ' +
                '<input type="text" name="bounty" id="bountyId" onkeyup="clearNoNum(this)" style="margin-top: 100px;margin-left: 15px; width: 200px;height: 35px;"/>' +
                '<button style="width:50px;float:left;margin-left: 300px;margin-top: 80px" type="button" id="buttonId0" onclick="addGoods()">确定</button>' +
                '<button style="width:50px;float:right;margin-right: 220px;margin-top: 80px"type="button" id="buttonId1" onclick="closes()">取消</button>'
                , shade: 0 //不显示遮罩
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , yes: function () {
                    layer.closeAll();
                }
            });
            return false;
        });


 //监听工具条
        table.on('tool(tableFilter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'del') {
                layer.confirm('确定要下架选中的商品吗？',function(index){
                    layer.close(index);
                    var status = 0;
                    var ids = data.id;
                        if(data.state == 0){
                            layer.msg("已经是下架状态了！");
                            return false;
                        }
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${pageContext.request.contextPath}/pddGoods",
                        data : "method=updateGoodsState&state=" + status +"&id="+ids,
                        dataType : "json",
                        success : function(data){
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("goodsList")
                            } else {
                                layer.msg("异常");
                            }
                        }
                    })
                });
            }else if (obj.event === 'add') {
                layer.confirm('确定要上架选中的商品吗？',function(index){
                    layer.close(index);
                    var status = 1;
                    var ids = data.id;
                    if(data.state == 1){
                        layer.msg("已经是上架状态了！");
                        return false;
                    }
                    $.ajax({
                        type: "get",
                        async : false, // 同步请求
                        cache :true,// 不使用ajax缓存
                        contentType : "application/json",
                        url : "${pageContext.request.contextPath}/pddGoods",
                        data : "method=updateGoodsState&state=" + status +"&id="+ids,
                        dataType : "json",
                        success : function(data){
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("goodsList")
                            } else {
                                layer.msg("异常");
                            }
                        }
                    })
                })

            }else if (obj.event === 'edit') {
                var data = obj.data;
                var v = data.goods_name;
                var ids = data.id;
                var b = data.bounty;
                var text = "Demo Demo";
                layer.open({
                    type: 1
                    , title: '修改商品'
                    //,offset: 'auto'
                    , id: 'goodImportOpen'
                    , area: ['700px', '500px']
                    , content:
                    '<label style="margin-left: 110px;margin-top: 100px;font-size:18px" >商品名称<span style="color: red">*</span></label> ' +
                    '<input type="text" name="spuName" value ="" id="spuId" style="margin-top: 100px;width: 200px;height: 35px;"/>' +
                    '<input type="hidden" name="spuIds" value ="" id="spuIds" style="margin-top: 100px;width: 200px;height: 35px;"/>' +
                    '<br><label style="margin-left: 110px;margin-top: 100px;font-size:18px" >奖励金<span style="color: red">*</span></label> ' +
                    '<input type="text" name="bounty" id="bountyId" onkeyup="clearNoNum(this)" style="margin-top: 100px;margin-left: 15px; width: 200px;height: 35px;"/>' +
                    '<button style="width:50px;float:left;margin-left: 340px;margin-top: 80px" type="button" id="buttonId0" onclick="addGoods()">确定</button>' +
                    '<button style="width:50px;float:right;margin-right: 220px;margin-top: 80px"type="button" id="buttonId1" onclick="closes()">取消</button>'
                    , shade: 0 //不显示遮罩
                    //,btn: '关闭'
                    , btnAlign: 'c' //按钮居中
                    , yes: function () {
                        layer.closeAll();
                    }
                });
                $("#spuId").val(v);
                $("#spuIds").val(ids);
                b = (b / 100).toFixed(2);
                $("#bountyId").val(b);
                return false;
            }
        });
    });
    //调用启用
    function enable(){
        var table = layui.table;
        var checkStatus = table.checkStatus('listTable');
        var selectCount = checkStatus.data.length;
        if(selectCount==0){
            layer.msg("请选择一条数据！");
            return false;
        };
        layer.confirm('确定要上架选中的商品吗？',function(index){
            layer.close(index);
            var status = 1;
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].id;
                if(checkStatus.data[i].status == 1){
                    layer.msg("已经是上架状态了！");
                    return false;
                }
            }
            $.ajax({
                type: "get",
                async : false, // 同步请求
                cache :true,// 不使用ajax缓存
                contentType : "application/json",
                url : "${pageContext.request.contextPath}/pddGoods",
                data : "method=updateGoodsState&state=" + status +"&id="+ids,
                dataType : "json",
                success : function(data){
                    if (data.success) {
                        layer.msg("操作成功");
                        table.reload("listTable")
                    } else {
                        layer.msg("异常");
                    }
                }
            })
        })
    };
    //调用禁用
    function disable(){
        var table = layui.table;
        var checkStatus = table.checkStatus('listTable');
        var selectCount = checkStatus.data.length;
        if(selectCount==0){
            layer.msg("请选择一条数据！");
            return false;
        };
        layer.confirm('确定要下架选中的商品吗？',function(index){
            layer.close(index);
            var status = 0;
            var ids = new Array(selectCount);
            for(var i=0; i<selectCount; i++){
                ids[i]=checkStatus.data[i].id;
                if(checkStatus.data[i].status == 0){
                    layer.msg("已经是下架状态了！");
                    return false;
                }
            }
            $.ajax({
                type: "get",
                async : false, // 同步请求
                cache :true,// 不使用ajax缓存
                contentType : "application/json",
                url : "${pageContext.request.contextPath}/pddGoods",
                data : "method=updateGoodsState&state=" + status +"&id="+ids,
                dataType : "json",
                success : function(data){
                    if (data.success) {
                        layer.msg("操作成功");
                        table.reload("listTable")
                    } else {
                        layer.msg("异常");
                    }
                }
            })
        })
    };
    function SendPost(status, id, othis) {
        $.ajax({
            type: "get",
            url: "${ctx}/pddGoods",
            data: "method=updateGoodsState&state=" + status + "&id=" + id,
            cache: true,
            async: false,
            dataType: "json",
            success: function (data) {
                if (status == 1) {  //上架时，判断是否有起售的SKU
                        if (data.success) {
                            layer.msg('上架操作成功');
                            table.reload('listTable');
                        } else {
                            layer.msg("异常");
                        }

                } else {
                    if (data.success) {
                        layer.msg('下架操作成功');
                        table.reload('listTable');
                    } else {
                        layer.msg("异常");
                    }
                }
            },
            error: function () {
                layer.alert("错误");
            }
        });
    }
</script>
<!-- 时间格式化 -->
<script type="text/html" id="editTimeTmpl">
    {{# if(d.create_date ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.create_date.substr(0,2) }}-{{ d.create_date.substr(2,2) }}-{{ d.create_date.substr(4,2) }} {{ d.create_date.substr(6,2) }}:{{ d.create_date.substr(8,2) }}:{{ d.create_date.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="editTimeTmp2">
    {{# if(d.edit_date ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.edit_date.substr(0,2) }}-{{ d.edit_date.substr(2,2) }}-{{ d.edit_date.substr(4,2) }} {{ d.edit_date.substr(6,2) }}:{{ d.edit_date.substr(8,2) }}:{{ d.edit_date.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="imgPath">
    {{# if(d.goods_thumbnail_url ==''){}}
    无缩略图
    {{# }else if(d.goods_thumbnail_url !=''){ }}
    <img src={{d.goods_thumbnail_url}} height="50" width="80">
    {{# } }}
</script>

<!-- 操作 -->
<script type="text/html" id="barDemo">
    <%--<a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">编辑</a>--%>
    <%--{{#  if(d.status == 1){ }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="del">下架</a>
    {{#  } else if(d.status == 0) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="add">上架</a>
    {{#  } }}--%>
    <input id="switch{{d.id}}" type="checkbox" name="status{{d.id}}" value="{{d.status}}" lay-skin="switch"
           lay-text="上架|下架"
           data-value="{{d.id}}"
           lay-filter="statusFilter" {{ d.status==1 ? 'checked' : '' }} >
</script>

<script type="text/html" id="statusId">
    {{d.status == 0 ? '下架':'<font color="red">上架</font>' }}
</script>

<script>
    //添加商品
    function addGoods() {
        //$("#buttonId0").setAttribute("disabled", true);
        document.getElementById("buttonId0").setAttribute("disabled", true);
        var spuName = $('#spuId').val();
        var spuId = $('#spuIds').val();
        var bountyId = $("#bountyId").val();
        if(spuId == undefined){
            spuId = "";
        }
        if(spuName == " " || spuName == ""){
            layer.alert("商品名称不能为空");
            return;
        }
        $.ajax({
            type: "post",
            async: false, // 同步请求
            cache: true,// 不使用ajax缓存
            contentType: "application/json",
            url: "${ctx}/goods?method=addZhangDZGoods&spuName="+spuName+"&spuId="+spuId+"&bounty="+bountyId,

            dataType: "json",
            success: function (data) {
                //layer.alert("成功");
                window.location.reload();
            },
            error: function () {
                layer.alert("错误");
            }
        })
    };
    //取消按钮
    function closes() {
        window.location.reload();
    }

    //点击"编辑商品"按钮
    function edite(){
        var table = layui.table;
        var checkStatus = table.checkStatus('goodsList');
        var selectCount = checkStatus.data.length;
        if(selectCount !=1){
            layer.msg("请选择一条数据！");
            return false;
        };
        var v = checkStatus.data[0].goods_name;
        var ids = checkStatus.data[0].id;
        var text = "Demo Demo";
        layer.open({
            type: 1
            , title: '修改商品'
            //,offset: 'auto'
            , id: 'goodImportOpen'
            , area: ['500px', '300px']
            , content:
            '<label style="margin-left: 110px;margin-top: 100px;font-size:18px" >商品名称<span style="color: red">*</span></label> ' +
            '<input type="text" name="spuName" value ="" id="spuId" style="margin-top: 100px;width: 200px;height: 35px;"/>' +
            '<input type="hidden" name="spuIds" value ="" id="spuIds" style="margin-top: 100px;width: 200px;height: 35px;"/>' +

            '<button style="width:50px;float:left;margin-left: 340px;margin-top: 80px" type="button" id="buttonId0" onclick="addGoods()">确定</button>' +
            '<button style="width:50px;float:right;margin-right: 25px;margin-top: 80px"type="button" id="buttonId1" onclick="closes()">取消</button>'
            , shade: 0 //不显示遮罩
            //,btn: '关闭'
            , btnAlign: 'c' //按钮居中
            , yes: function () {
                layer.closeAll();
            }
        });
        $("#spuId").val(v);
        $("#spuIds").val(ids);
        return false;
    };

    function clearNoNum(obj){
        obj.value = obj.value.replace(/[^\d.]/g,"");  //清除“数字”和“.”以外的字符
        obj.value = obj.value.replace(/\.{2,}/g,"."); //只保留第一个. 清除多余的
        obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
        obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//只能输入两个小数
        if(obj.value.indexOf(".")< 0 && obj.value !=""){//以上已经过滤，此处控制的是如果没有小数点，首位不能为类似于 01、02的金额
            obj.value= parseFloat(obj.value);
        }
    }

</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            拼多多商品管理
        </div>
        <input type="hidden" value="" id="currPage" name="currPage">
        <!-- 表单集合-->
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">
                    <label class="layui-form-label">商品名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="spu_name" name="spu_name" placeholder="请输入名称"
                               autocomplete="off" class="layui-input">
                    </div>

                    <label class="layui-form-label">商品编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="spu_code" name="spu_code" placeholder="请输入商品编码"
                               autocomplete="off" class="layui-input">
                    </div>

                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select id="status" name="status">
                            <option value=""></option>
                            <option value="1">上架</option>
                            <option value="0">下架</option>
                        </select>
                    </div>

                    <label class="layui-form-label">商品类目</label>
                    <div class="layui-input-inline">
                        <select id="goods_source" name="goods_source">
                            <option value=""></option>
                            <option value="1">美食</option>
                            <option value="4">母婴</option>
                            <option value="13">水果</option>
                            <option value="14">服饰</option>
                            <option value="15">百货</option>
                            <option value="16">美妆</option>
                            <option value="743">男装</option>
                            <option value="818">家纺</option>
                            <option value="1451">运动</option>
                            <option value="1281">鞋包</option>

                        </select>
                    </div>

                    <label class="layui-form-label">佣金比</label>
                    <div class="layui-input-inline">
                        <select id="promotion_rate" name="promotion_rate_name">
                            <option value="">全部</option>
                            <option value="1">0%-5%</option>
                            <option value="2">5.1%-10%</option>
                            <option value="3">10.1%-20%</option>
                            <option value="4">20.1%-30%</option>
                            <option value="5">30.1%-50%</option>
                            <option value="6">50.1%-100%</option>
                        </select>
                    </div>

                    <%--<label class="layui-form-label">商品类型</label>
                    <div class="layui-input-inline">
                        <input type="text" id="spu_type" name="spu_type" placeholder="请输入商品类型"
                               autocomplete="off" class="layui-input">
                    </div>--%>

                    <%--<label class="layui-form-label">添加时间</label>
                                        <div class="layui-input-inline" style="width: 150px" >
                                            <input name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                                        </div>
                                        <div class="layui-form-mid">-</div>
                                        <div class="layui-input-inline" style="width: 150px" >
                                            <input name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                                        </div>--%>
                    <button id="searchBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索
                    </button>

                    <button type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置
                    </button>
                </div>
                <div class="layui-form-item" style="margin-bottom: 0">

                    <%--<label class="layui-form-label">商品编码</label>
                    <div class="layui-input-inline">
                        <input id="spu_code" name="spu_code" type="text" autocomplete="off" class="layui-input">
                    </div>--%>
                </div>

            </div>
        </form>
        <div style="margin-top: 5px">
            <button class="layui-btn layui-btn-sm" onclick="disable()"><i class="layui-icon">&#x1007;</i>下架</button>
            <button class="layui-btn layui-btn-sm" onclick="enable()"><i class="layui-icon">&#xe610;</i>上架</button>
            <%--<button class="layui-btn layui-btn-sm" id="btnGoodImport" target="_self"><i class="layui-icon">&#xe61f;</i>添加商品</button>--%>
            <%--<button class="layui-btn layui-btn-sm" id="editId" onclick="edite()"><i class="layui-icon">&#xe642;</i>编辑</button>--%>
        </div>
        <table class="layui-hide" id="goodsList" lay-filter="tableFilter"></table>
    </div>
</div>
    <%@ include file="/common/footer.jsp" %>


