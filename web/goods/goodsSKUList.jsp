<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>
<%
    String goodsSPUId = request.getParameter("goodsSPUId");
    String goodsSPUName = request.getParameter("goodsSPUName");
    System.out.println(goodsSPUId);
    System.out.print(goodsSPUName);
%>
<script>
    var goodsSPUId = "<%=goodsSPUId%>";
    var goodsSPUName = "<%=goodsSPUName%>";
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    //JavaScript代码区域
    layui.use(['table', 'laydate'], function () {
        var table = layui.table //表格
            , laydate = layui.laydate;
        var form = layui.form;

        //执行一个 table 实例
        table.render({
            elem: '#goodsSKUInfoTab'
            , height: 745
            , limit: 20
            , limits: [20, 50, 100]
            //,id: 'listTable'
            , url: '${ctx}/goods?method=getGoodsSKUList' //数据接口
            , page: true //开启分页
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left', field: "ids"}
                // ,{field:'id', width:50, title: 'ID', fixed: 'left'}
                , {field: 'sku_name', width: 250, title: 'SKU-规格名称', align: 'center', fixed: 'left'}
                // ,{field:'sex', width:120, title: '推广地区',align:'center',fixed: 'left'}
                , {
                    field: 'sku_status',
                    width: 70,
                    title: '状态',
                    align: 'center',
                    templet: '#sku_statusTpl',
                    unresize: true
                }
                , {
                    field: 'first_attribute_value',
                    width: 200,
                    title: '销售属性值',
                    align: 'center',
                    templet: '#attributeTpl',
                    unresize: true
                }
                // ,{field:'is_default', width:120, title: '是否默认',align:'center',templet: '#is_defaultTpl', unresize: true}
                , {field: 'stock', width: 100, title: '库存数', align: 'center'}
                , {field: 'buyconfine', width: 100, title: '限购数量', align: 'center'}
                // ,{field:'sign', width:120, title: '单位',align:'center'}
                // ,{field:'sign', width:120, title: '包装数量',align:'center'}
                , {
                    field: 'original_price', width: 90, title: '原价/成本价(元)', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.original_price == "") {
                            num = "----"
                        } else {
                            //num="￥"+Number(d.original_price*0.01);
                            num = (d.original_price / 100).toFixed(2);
                        }
                        return num;
                    }
                }
                , {
                    field: 'bounty', width: 90, title: '奖励金', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.bounty == "") {
                            num = "----"
                        } else {
                            //num="￥"+Number(d.original_price*0.01);
                            num = (d.bounty / 100).toFixed(2);
                        }
                        return num;
                    }
                }
                , {
                    field: 'market_price', width: 160, title: '销售价(元)', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.market_price == "") {
                            num = "----"
                        } else {
                            num = (d.market_price / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                , {
                    field: 'member_top_money', width: 160, title: '会员顶级奖励(元)', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.member_top_money == "") {
                            num = "----"
                        } else {
                            num = (d.member_top_money / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                , {
                    field: 'member_parent_money', width: 160, title: '会员父级返佣(元)', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.member_parent_money == "") {
                            num = "----"
                        } else {
                            num = (d.member_parent_money / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                , {
                    field: 'member_self_money', width: 160, title: '会员子级返现(元)', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.member_self_money == "") {
                            num = "----"
                        } else {
                            num = (d.member_self_money / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                , {
                    field: 'outsider_top_money', width: 160, title: '<font color="red">非会员顶级奖励(元)</font>', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.outsider_top_money == "") {
                            num = "----"
                        } else {
                            num = (d.outsider_top_money / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                , {
                    field: 'outsider_parent_money', width: 160, title: '<font color="red">非会员父级返佣(元)</font>', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.outsider_parent_money == "") {
                            num = "----"
                        } else {
                            num = (d.outsider_parent_money / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                , {
                    field: 'outsider_self_money', width: 160, title: '<font color="red">非会员子级返现(元)</font>', align: 'center', templet: function (d) {
                        var num = "";
                        if (d.outsider_self_money == "") {
                            num = "----"
                        } else {
                            num = (d.outsider_self_money / 100).toFixed(2)
                        }
                        return num;
                    }
                }
                ,{
                    field: 'presell_beginEndtime',
                    width: 350,
                    title: '预售时间',
                    align: 'center',
                    templet: '#timeTpl',
                    unresize: true
                }
                // ,{field:'sign', width:120, title: '体积',align:'center'}
                // ,{field:'sign', width:120, title: '重量',align:'center'}
                // ,{field:'first_attribute', width:120, title: '扩展属性1',align:'center'}
                // ,{field:'second_attribute', width:120, title: '扩展属性2',align:'center'}
                // ,{field:'create_user', width:120, title: '创建人',align:'center'}
                // ,{field:'create_time', width:120, title: '创建时间',align:'center'}
                , {field: 'edit_user', width: 120, title: '操作者', align: 'center'}
                , {field: 'edit_time', width: 150, title: '编辑时间', align: 'center'}
                , {field: 'operate', width: 170, align: 'center', title: '是否设为默认', toolbar: "#barDemo", fixed: 'right'}
            ]]
            , where: {goodsSPUId: goodsSPUId}
        });

        var $ = layui.$, active = {
            //起售
            goodsSKU_BeginSell: function () {
                var checkStatus = table.checkStatus('goodsSKUInfoTab'),
                    data = checkStatus.data;
                var selectCount = checkStatus.data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条商品信息！");
                    return false;
                }
                var id = new Array(selectCount);
                var presell_endtime = new Array(selectCount);
                for (var i = 0; i < selectCount; i++) {
                    if (checkStatus.data[i].sku_status == "2") {
                        layer.msg("请选择停售商品信息！");
                        return false;
                    } else {
                        presell_endtime[i] = checkStatus.data[i].presell_endtime;
                        id[i] = checkStatus.data[i].id;
                    }
                }
                for (var obj in presell_endtime) {
                    <%--var presell_endtimeDate = new Date(presell_endtime[obj].replace(/-/g,"/"));--%>
                    <%--if(presell_endtimeDate < new Date()){--%>
                    <%--layer.open({--%>
                    <%--type: 1--%>
                    <%--,title: '提示'--%>
                    <%--,area: ['390px', '260px']--%>
                    <%--,id: 'goodsBeginSellTimeTips'--%>
                    <%--,content: '<br><div class="layui-inline" style="margin-left: 10%"><label class="layui-label">预售结束时间:</label>' +--%>
                    <%--'      <div class="layui-input-inline">' +--%>
                    <%--'        <input type="text" class="layui-input" id="presell_newEndtime" placeholder="yyyy-MM-dd HH:mm:ss">' +--%>
                    <%--'      </div></div>'--%>
                    <%--,btn: ['确认','取消']--%>
                    <%--,btnAlign: 'c' //按钮居中--%>
                    <%--,yes: function(){--%>
                    <%--if($("presell_newEndtime").val()< new Date()){--%>
                    <%--layer.msg("不能小于当前时间，请重新输入！");--%>
                    <%--return false;--%>
                    <%--}--%>
                    <%--$.ajax({--%>
                    <%--type: "get",--%>
                    <%--url : "${ctx}/goods?method=upSKUGoodsStatus&id="+id+"&presell_newEndtime="+$("#presell_newEndtime").val()+"&style=beginSell",--%>
                    <%--// data:{'id':id,'presell_newEndtime':$("#presell_newEndtime").val(),'style':'beginSell'} ,--%>
                    <%--cache: false,--%>
                    <%--async: false,--%>
                    <%--dataType: "json",--%>
                    <%--success : function(data){--%>
                    <%--if (data.success) {--%>
                    <%--layer.closeAll();--%>
                    <%--table.reload("goodsSKUInfoTab")--%>
                    <%--layer.msg('商品起售成功');--%>
                    <%--return false;--%>
                    <%--}--%>
                    <%--},--%>
                    <%--error:function () {--%>
                    <%--layer.msg('商品起售失败');--%>
                    <%--return false;--%>
                    <%--}--%>
                    <%--})--%>
                    <%--}--%>
                    <%--,btn2:function () {--%>
                    <%--layer.closeAll();--%>
                    <%--}--%>
                    <%--,success:function () {--%>
                    <%--//时间选择器--%>
                    <%--laydate.render({--%>
                    <%--elem: '#presell_newEndtime'--%>
                    <%--,type: 'datetime'--%>
                    <%--});--%>
                    <%--}--%>
                    <%--});--%>
                    <%--}else{--%>
                    layer.msg('确定要起售该规格型号吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        ,closeBtn: 1    // 是否显示关闭按钮
                        ,anim: 1 //动画类型
                        ,btn: ['确定','取消'] //按钮
                        ,icon: 6    // icon
                        ,yes:function(){
                            $.ajax({
                                type: "get",
                                url: "${ctx}/goods?method=upSKUGoodsStatus&id=" + id + "&style=beginSell",
                                // data:{'id':id,'style':'beginSell'} ,
                                cache: false,
                                async: false,
                                dataType: "json",
                                success: function (data) {
                                    if (data.success) {
                                        layer.closeAll();
                                        table.reload("goodsSKUInfoTab")
                                        layer.msg('商品起售成功');
                                        return false;
                                    }
                                },
                                error: function () {
                                    layer.msg('商品起售失败');
                                    return false;
                                }
                            })
                        }
                        ,btn2:function(){
                            layer.closeAll();
                        }});

                    <%--layer.open({--%>
                        <%--type: 1--%>
                        <%--, title: '提示'--%>
                        <%--, id: 'goodsBeginSellTips'--%>
                        <%--, content: '确定要起售该规格型号吗？'--%>
                        <%--, btn: ['确认', '取消']--%>
                        <%--, btnAlign: 'c' //按钮居中--%>
                        <%--, yes: function () {--%>
                            <%--$.ajax({--%>
                                <%--type: "get",--%>
                                <%--url: "${ctx}/goods?method=upSKUGoodsStatus&id=" + id + "&style=beginSell",--%>
                                <%--// data:{'id':id,'style':'beginSell'} ,--%>
                                <%--cache: false,--%>
                                <%--async: false,--%>
                                <%--dataType: "json",--%>
                                <%--success: function (data) {--%>
                                    <%--if (data.success) {--%>
                                        <%--layer.closeAll();--%>
                                        <%--table.reload("goodsSKUInfoTab")--%>
                                        <%--layer.msg('商品起售成功');--%>
                                        <%--return false;--%>
                                    <%--}--%>
                                <%--},--%>
                                <%--error: function () {--%>
                                    <%--layer.msg('商品起售失败');--%>
                                    <%--return false;--%>
                                <%--}--%>
                            <%--})--%>
                        <%--}--%>
                        <%--, btn2: function () {--%>
                            <%--layer.closeAll();--%>
                        <%--}--%>
                    <%--});--%>
                    // }
                }


            },
            //商品停售
            goodsSKU_EndSell: function () {
                var checkStatus = table.checkStatus('goodsSKUInfoTab'),
                    data = checkStatus.data;
                var selectCount = checkStatus.data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条商品信息！");
                    return false;
                }
                var id = new Array(selectCount);
                for (var i = 0; i < selectCount; i++) {
                    if (checkStatus.data[i].sku_status == "0") {
                        layer.msg("请选择停售商品信息！");
                        return false;
                    } else {
                        id[i] = checkStatus.data[i].id;
                    }
                }

                layer.msg('确定要停售该规格型号吗?', {
                    skin: 'layui-layer-molv' //样式类名  自定义样式
                    ,closeBtn: 1    // 是否显示关闭按钮
                    ,anim: 1 //动画类型
                    ,btn: ['确定','取消'] //按钮
                    ,icon: 6    // icon
                    ,yes:function(){
                        setTimeout(sendMsg(id, goodsSPUId),60000);//60秒内不可以重复点击，一秒等于1000毫秒
                    }
                    ,btn2:function(){
                        layer.closeAll();
                    }});

                // layer.open({
                //     type: 1
                //     , title: '提示'
                //     , id: 'goodsSKU_BeginEndSell'
                //     , content: '确定要停售该规格型号吗？'
                //     , btn: ['确认', '取消']
                //     , btnAlign: 'c' //按钮居中
                //     , yes: function () {
                //
                //     }
                //     , btn2: function () {
                //         layer.closeAll();
                //     }
                // });
            },
            //商品删除
            goodsSKU_DEL: function () {
                console.log("    del  spuId   "+goodsSPUId);
                var checkStatus = table.checkStatus('goodsSKUInfoTab'),
                    data = checkStatus.data;
                var selectCount = checkStatus.data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条商品信息！");
                    return false;
                }
                var id = new Array(selectCount);

                for (var i = 0; i < selectCount; i++) {
                    id[i] = checkStatus.data[i].id;
                    console.log("  skuId   "+id);
                }
                ;
                layer.open({
                    type: 1
                    , title: '提示'
                    , id: 'layerTips'
                    , content: '确定删除？'
                    , btn: ['确认', '取消']
                    , btnAlign: 'c' //按钮居中
                    , yes: function () {
                        $.ajax({
                            async: false, // 同步请求
                            cache: true,// 不使用ajax缓存
                            url: "${ctx}/goods?method=delGoodsSKU&id=" + id+"&spuId="+goodsSPUId,
                            // data:{'id':id} ,
                            // traditional: true,
                            success: function (data) {
                                layer.closeAll();
                                layer.msg('商品删除成功');
                                table.reload("goodsSKUInfoTab")
                            },
                            error: function () {
                                layer.msg('商品删除失败');
                            }
                        })
                    }
                    , btn2: function () {
                        layer.closeAll();
                    }
                });
            },
            //编辑
            goodsSKU_Edit: function () {
                var checkStatus = table.checkStatus('goodsSKUInfoTab'),
                    data = checkStatus.data;
                var selectCount = checkStatus.data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条商品信息！");
                    return false;
                }
                ;
                if (selectCount.length > 1) {
                    layer.msg("只能选择一条商品信息！");
                    return false;
                }
                ;

                var id = "";
                for (var i = 0; i < selectCount; i++) {
                    id = checkStatus.data[i].id;
                }
                ;
                window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_id=" + goodsSPUId + "&sku_id=" + id + "&spu_name=" + goodsSPUName;
            },
            //推送地址
            goodsSKU_PushArea: function () {

            },

            //添加规格
            goodsSKU_ADD: function () {
              //  var newSku = "newSku";
                var checkStatus = table.checkStatus('goodsSKUInfoTab'),
                    data = checkStatus.data;
                var selectCount = checkStatus.data.length;

                if (selectCount == 0) {
                    window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_id=" + goodsSPUId + "&spu_name=" + goodsSPUName +"&sku_id="+0;
                    // sku_id = 0  表示新增商品 不取此值 新增规格 无法得到销售属性
                  //  layer.msg("    请勾选一个规格   ");
                    return false;
                }
                if (selectCount > 1) {
                    layer.msg("    只能选择一个  ");
                    return false;
                }
                if(checkStatus.data[0] == undefined){
                    // 添加新规格
                    window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_id=" + goodsSPUId + "&spu_name=" + goodsSPUName +"&sku_id="+'';
                }else{
                    window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_id=" + goodsSPUId + "&spu_name=" + goodsSPUName + "&sku_id="+ checkStatus.data[0].id ;
                }

            },
            //添加属性
            goodsSKUAttribute_ADD: function () {
                var checkStatus = table.checkStatus('goodsSKUInfoTab'),
                    data = checkStatus.data;
                var selectCount = checkStatus.data.length;
                if (selectCount == 0) {
                    layer.msg("请选择一条商品信息！");
                    return false;
                }
                var id = "";
                var first_attribute = "";
                var second_attribute = "";
                for (var i = 0; i < selectCount; i++) {
                    id = checkStatus.data[i].id;
                    first_attribute = checkStatus.data[i].first_attribute;
                    second_attribute = checkStatus.data[i].second_attribute;
                }
                ;
                layer.open({
                    type: 1
                    , title: '规格属性管理'
                    , id: 'goodsSKUAttributeManage'
                    , content: $('#goodsSKUAttributeManage_Div')
                    , area: ['800px', '600px']
                    , btn: ['确认', '取消']
                    , btnAlign: 'r'
                    , yes: function () {
                        $.ajax({
                            async: false, // 同步请求
                            cache: true,// 不使用ajax缓存
                            url: "${ctx}/goods?method=delGoodsSKU",
                            data: {'id': id},
                            traditional: true,
                            success: function (data) {
                                if (data.success) {
                                    layer.closeAll('loading');
                                    $(".layui-laypage-btn")[0].click(); // 当前页刷新.思路是模拟点击分页按钮
                                    layer.msg('商品删除成功');
                                }
                            },
                            error: function () {
                                layer.msg('商品删除失败');
                            }
                        })
                    }
                    , btn2: function () {
                        layer.closeAll('loading');
                    },
                    success: function () {
                        $("#goodsSKUAttributeFrist_A").text(first_attribute);
                        $("#goodsSKUAttributeSecond_A").text(second_attribute);
                        table.render({
                            elem: '#goodsSKUAttributeManageTab'
                            , width: 600
                            , url: '${ctx}/goods?method=getGoodsSKUAttributeList' //数据接口
                            , page: true //开启分页
                            , response: {
                                statusName: 'success' //数据状态的字段名称，默认：code
                                , statusCode: 1  //成功的状态码，默认：0
                                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                                , countName: 'total' //数据总数的字段名称，默认：count
                                , dataName: 'rs' //数据列表的字段名称，默认：data
                            }
                            , cols: [[ //表头
                                {field: 'id', width: 100, title: 'ID', fixed: 'left', align: 'center'}
                                , {field: 'sku_name', width: 150, title: '属性名称', align: 'center'}
                                , {field: 'sex', width: 150, title: '属性值', align: 'center'}
                                , {
                                    field: 'goodsSKUAttributeManageOperation',
                                    width: 200,
                                    fixed: 'right',
                                    align: 'center',
                                    title: '操作',
                                    toolbar: "#goodsSKUAttributeManageOperation"
                                }
                            ]]
                            , where: {id: id}
                        });
                    }
                });
            }

        };

        function sendMsg(id,goodsSPUId) {
            $.ajax({
                type: "get",
                url: "${ctx}/goods?method=upSKUGoodsStatus&id=" + id + "&style=endSell&goodsSPUId=" + goodsSPUId,
                // data:{'id':id,'style':'endSell'} ,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.closeAll();
                        table.reload("goodsSKUInfoTab")
                        layer.msg('商品停售成功');
                    }
                },
                error: function () {
                    layer.msg('商品停售失败');
                }
            })
        }

        $('.GoodsSKUMangeDiv .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });


        //监听是否默认操作
        form.on('switch(switchFilter)', function (obj) {
            var othis = $(this);
            var skuId = othis.data('value');
            //,status = (othis.data('method')?0:1)
            var status = (($('#' + "switch" + skuId).val() == "1") ? 0 : 1);//值反转
            var that = obj.othis;


            if (status == "0") {  //设置非默认，这种操作不能进行，还原
                $('#' + "switch" + skuId).val(0);
                othis.prop("checked", true); //还原
                form.render('checkbox');
                //layer.msg('已经为默认的SKU不能设为非默认，请操作其他的SKU');

                layer.msg('已经为默认的SKU不能设为非默认，请操作其他的SKU', {time: 2000}, function () {
                    //do something
                    table.reload('goodsSKUInfoTab');
                });


            } else {
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods",
                    data: "method=updateSkuDefault&status=" + status + "&spuId=" + goodsSPUId + "&id=" + skuId,
                    cache: false,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            layer.msg('设置默认成功', {time: 2000}, function () {
                                //do something
                                table.reload('goodsSKUInfoTab');
                            });
                        } else {
                            layer.msg("异常");
                        }
                    },
                    error: function () {
                        layer.alert("错误");
                    }
                });
            }
        });


    });
</script>
<script>

    $(document).ready(function () {
        $("#spuGoodsNameSpan").text("[" + goodsSPUName + "]");
    })

</script>


<script type="text/html" id="sku_statusTpl">
    {{#  if(d.sku_status === '0'){ }}
    <span>停售</span>
    {{#  } else { }}
    <span>起售</span>
    {{#  } }}
</script>

<script type="text/html" id="attributeTpl">
    {{d.first_attribute_value}}/{{d.second_attribute_value}}
</script>


<!--
<script type="text/html" id="is_defaultTpl">
{{# if(d.is_default === '0'){ }}
<span style="color: #0C0C0C;">非默认</span>
{{# } else { }}
<span style="color: #0C0C0C;">默认</span>
{{# } }}
</script>
-->


<script type="text/html" id="barDemo">
    <input id="switch{{d.id}}" type="checkbox" name="is_default{{d.id}}" value="{{d.is_default}}" lay-skin="switch"
           lay-text="是|否"
           data-value="{{d.id}}" lay-filter="switchFilter" {{ d.is_default== 1 ? 'checked' : '' }} >
</script>

<script type="text/html" id="timeTpl">

    {{Utils.FormatDateShort(d.presell_begintime)}}
    —
    {{#  if(d.presell_endtime === '999999999999'){ }}
    &nbsp;预售截至时间不限
    {{#  } else { }}
    {{Utils.FormatDateShort(d.presell_endtime)}}
    {{#  } }}


    <!--
    {{#  if( d.presell_begintime !== '1970-01-01 08:00:00.0' && d.presell_endtime !== '1970-01-01 08:00:00.0'){ }}
    <span style="color: #0C0C0C;">{{ d.presell_begintime }} — {{ d.presell_endtime }}</span>
    {{#  } else if( d.presell_begintime !== '1970-01-01 08:00:00.0' && d.presell_endtime === '1970-01-01 08:00:00.0'){ }}
    <span style="color: #0C0C0C;">{{ d.presell_begintime }} —</span>
    {{#  } else { }}
    <span style="color: #0C0C0C;">----</span>
    {{#  } }}
    -->
</script>

<script type="text/html" id="editTimeTpl">

    {{Utils.FormatDateShort(d.presell_begintime)}}
    —
    {{#  if(d.presell_endtime === '999999999999'){ }}
    &nbsp;预售截至时间不限
    {{#  } else { }}
    {{Utils.FormatDateShort(d.presell_endtime)}}
    {{#  } }}
</script>


<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding: 15px;">
        <div class="layui-elem-quote">
            <label id="spuGoodsNameSpan"></label><label>规格管理列表</label>
            <button class="layui-btn  layui-btn-sm" style="margin-left: 70%" onclick="history.go(-1)">返回</button>
        </div>


        <div style="margin-top: 5px" class="GoodsSKUMangeDiv">
            <button class="layui-btn layui-btn-sm" data-type="goodsSKU_BeginSell"><i class="layui-icon">&#xe63c;</i>起售
            </button>
            <button class="layui-btn layui-btn-sm" data-type="goodsSKU_EndSell"><i class="layui-icon">&#xe63c;</i>停售
            </button>
            <button class="layui-btn layui-btn-sm" data-type="goodsSKU_DEL"><i class="layui-icon">&#xe640;</i>删除
            </button>
            <button class="layui-btn layui-btn-sm" data-type="goodsSKU_Edit"><i class="layui-icon">&#xe63c;</i>编辑
            </button>
            <button class="layui-btn layui-btn-sm" data-type="goodsSKU_PushArea"><i class="layui-icon">&#xe62d;</i>推送地区
            </button>
            <button class="layui-btn layui-btn-sm" data-type="goodsSKU_ADD"><i class="layui-icon">&#xe61f;</i>添加规格
            </button>
            <%--<button class="layui-btn layui-btn-sm" data-type="goodsSKUAttribute_ADD"><i class="layui-icon">&#xe63c;</i>添加属性</button>--%>
            <table class="layui-hide" id="goodsSKUInfoTab" lay-filter="goodsSKUInfoTab"></table>
        </div>

    </div>

</div>

<!-- 推送地区 -->
<div id="goodsSKU_PushAreaDiv" style="display: none;">

    <div class="layui-item">
        <label class="layui-label">选择推送地区</label>
        <div class="layui-input-inline">
            <select name="quiz1">
                <option value="">请选择省</option>
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="quiz2">
                <option value="">请选择市</option>
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="quiz3">
                <option value="">请选择县/区</option>
            </select>
        </div>
    </div>

    <div class="layui-item">
        <label class="layui-form-label">详细地址</label>
        <div class="layui-input-block">
            <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                   placeholder="请输入名称">
        </div>
    </div>


    <div class="layui-input-block">
        <input type="checkbox" name="like[write]" title="是否推送商品" checked="">
        是否推送商品
    </div>

    <div class="layui-form-mid layui-word-aux">注：勾选了推送商品后，商品即可上架，并在所选地区开始销售；</div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="demo1">保存</button>
        </div>
    </div>
</div>
<!-- 规格属性管理页面 -->
<div id="goodsSKUAttributeManage_Div"
     style="width: 100%;height: 100%;overflow:-Scroll;overflow-x:hidden;display: none;">
    <div class="layui-item" style="margin-left: 100px;margin-top: 10px">
        <label class="layui-label"><a id="goodsSKUAttributeFrist_A"></a></label>
        <div class="layui-input-inline">
            <input type="tel" name="attributeValue_Frist" lay-verify="title" autocomplete="off" class="layui-input">
        </div>
        <br>
        <br>
        <label class="layui-label"><a id="goodsSKUAttributeSecond_A"></a></label>
        <div class="layui-input-inline">
            <input type="tel" name="attributeValue_Second" lay-verify="title" autocomplete="off" class="layui-input">
        </div>
        <div class="goodsSKUAttribute_SaveDiv" style="margin-left: 80%">
            <button class="layui-btn" data-type="goodsSKUAttribute_Save">保存</button>
        </div>
        <table class="layui-table" style="margin-left: 200%;margin-top: 5px" id="goodsSKUAttributeManageTab"
               lay-filter="goodsSKUAttributeManageTab">

        </table>
    </div>

    <script type="text/html" id="goodsSKUAttributeManageOperation">
        <a class="layui-btn layui-btn-xs" lay-event="goodsSKUAttributeManage_Edit">编辑</a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="goodsSKUAttributeManage_Del">删除</a>
    </script>
</div>

<%@ include file="/common/footer.jsp" %>