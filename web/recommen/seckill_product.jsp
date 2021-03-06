<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@include file="/recommen/menu_recommen.jsp" %>
<%
    String columnId = request.getParameter("columnId");
%>
<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>
<script>
    function Map() {
        this.mapArr = {};
        this.arrlength = 0;

        //假如有重复key，则不存入
        this.put = function (key, value) {
            if (!this.containsKey(key)) {
                this.mapArr[key] = value;
                this.arrlength = this.arrlength + 1;
            }
        }
        this.get = function (key) {
            return this.mapArr[key];
        }

        //传入的参数必须为Map结构
        this.putAll = function (map) {
            if (Map.isMap(map)) {
                var innermap = this;
                map.each(function (key, value) {
                    innermap.put(key, value);
                })
            } else {
                alert("传入的非Map结构");
            }
        }
        this.remove = function (key) {
            delete this.mapArr[key];
            this.arrlength = this.arrlength - 1;
        }
        this.size = function () {
            return this.arrlength;
        }

        //判断是否包含key
        this.containsKey = function (key) {
            return (key in this.mapArr);
        }
        //判断是否包含value
        this.containsValue = function (value) {
            for (var p in this.mapArr) {
                if (this.mapArr[p] == value) {
                    return true;
                }
            }
            return false;
        }
        //得到所有key 返回数组
        this.keys = function () {
            var keysArr = [];
            for (var p in this.mapArr) {
                keysArr[keysArr.length] = p;
            }
            return keysArr;
        }
        //得到所有value 返回数组
        this.values = function () {
            var valuesArr = [];
            for (var p in this.mapArr) {
                valuesArr[valuesArr.length] = this.mapArr[p];
            }
            return valuesArr;
        }

        this.isEmpty = function () {
            if (this.size() == 0) {
                return false;
            }
            return true;
        }
        this.clear = function () {
            this.mapArr = {};
            this.arrlength = 0;
        }
        //循环
        this.each = function (callback) {
            for (var p in this.mapArr) {
                callback(p, this.mapArr[p]);
            }
        }
    };
    var seckillSourceMap = new Map();
    var columnId = '<%=columnId%>';
    console.log("  columnId  " + columnId);
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });
    //JavaScript代码区域
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var element = layui.element;
        var laydate = layui.laydate // 日期
            , layer = layui.layer // 弹层
            , table = layui.table // 表格
            , element = layui.element; //元素操作
        var form = layui.form;
        var secTable = layui.table;
        var recommenTable = layui.table;
        var seckillSkuTable = layui.table;
        var seckillSourceMap = new Map();
        //执行一个laydate实例
        laydate.render({
            elem: '#presell_begintime', type: 'datetime'
        });
        laydate.render({
            elem: '#presell_endtime', type: 'datetime'
        });
// 更新秒杀时段
        laydate.render({
            elem: '#u_secStartTime', type: 'datetime'
        });
        laydate.render({
            elem: '#u_secEndtime', type: 'datetime'
        });
// 秒杀时段新增
        laydate.render({
            elem: '#i_secStartTime', type: 'datetime'
        });
        laydate.render({
            elem: '#i_secEndtime', type: 'datetime'
        });
// 秒杀栏目商品上架设定时间使用
        laydate.render({
            elem: '#s_begintime', type: 'datetime'
        });
        laydate.render({
            elem: '#s_endtime', type: 'datetime'
        });

        //执行一个 table 实例
        table.render({
            elem: '#tablelist'
            , height: 'full-247'
            , cellMinWidth: 190
            , url: '${ctx}/plan?method=getColumnProductList' //数据接口
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , where: {
                plan_group: columnId
            }
            , limit: 100 //每页显示的条数
            , limits: [100, 200]
            , id: 'listTable'
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left', field: "ids"}
                , {field: 'seckill_name', width: 200, title: '秒杀时段名称'}
                , {field: 'start_time', width: 180, title: '秒杀开始时间', templet: '#startTimeTpl'}
                , {field: 'end_time', width: 180, title: '秒杀结束时间', templet: '#endTimeTpl'}
                , {field: 'spu_name', width: 300, title: '商品名称'}
                , {field: 'product_status', width: 100, title: '商品状态', templet: '#cStatusTpl'}
                , {
                    field: 'product_price', templet: function (d) {
                        return "￥" + (d.product_price / 100).toFixed(2);
                    }, width: 150, title: '商品金额(元)', align: 'center'
                }
                , {
                    field: 'seckillSukNum', width: 120, title: '参与秒杀规格', templet: function (d) {
                        return d.seckillSukNum + " 个";
                    }
                }
                , {
                    field: 'skuNum', width: 100, title: '规格数量', templet: function (d) {
                        return d.skuNum + " 个";
                    }
                }
                // , {
                //     field: 'original_price', event: 'setSign', title: "商品原价需大于商品金额", templet: function (d) {
                //         return "￥" + (d.original_price / 100).toFixed(2);
                //     }, width: 150, title: '<font color="red">商品原价</font>', align: 'center'
                // }
                , {field: 'sourceName', width: 100, title: '商品来源'}
                , {field: 'bstarttime', width: 180, title: '商品上架时间', templet: '#productUpTimeTmpl'}
                , {field: 'bendtime', width: 180, title: '商品下架时间', templet: '#productDownTimeTmpl'}
                , {field: 'spu_code', width: 180, title: '商品编码'}
                , {field: 'brandName', width: 100, title: '商品品牌'}
                , {field: 'cateName', width: 100, title: '商品分类'}
                , {field: 'goodsTypeName', width: 120, title: '商品类型'}
                , {field: 'hahaha', width: 320, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
            ]]

        });

        //监听 秒杀时段管理
        table.on('tool(listSecKillFlter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'dele') {
                console.log("  del  " + obj.data.id + "  seckillId   " + obj.data.seckillId);
                if (obj.data.status == '1') {
                    layer.msg("  秒杀时段在启用中 不能删除 ");
                    return false;
                }
                layer.confirm('确认删除?', function (index) {
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/plan",
                        data: "method=delSeckillUse&id=" + obj.data.id,
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg('删除成功', {time: 2000}, function () {
                                    //do something
                                });
                                //secTable.reload("listSecKill");

                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.msg("错误");
                        }
                    });
                });

            } else if (obj.event === 'edit') {
                // 秒杀
                console.log("秒杀   edit  " + obj.data.id);
                $('#secId').val(obj.data.id);//放入spu_id
                var title = "秒杀管理-修改【" + obj.data.seckill_name + "】的信息";
                addPlanIndex = layer.open({
                    type: 1
                    , title: title
                    , offset: 'auto'
                    , id: 'updateSeckillOpen'
                    , area: ['40%', '60%']
                    , content: $('#updateSeckillDiv')
                    //,btn: '关闭'
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //遮罩
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调

                    }
                });
                // 获取秒杀时段信息
                getSecKillInfo(obj.data.id);

            } else if (obj.event === 'StatusDown') {
                console.log("  StatusDown    " + data.id);
                // 该秒杀时段对应商品是否下架
                var num = isExistSeckillProduct(data.id);
                if (num != 0) {
                    layer.msg("有上架商品正在使用该秒杀时段 不能删除！");
                    return false;
                }
                seckKillStatusChange(0, data.id);
                secTable.reload("listSecKill");
            } else if (obj.event === 'StatusUp') {
                // 原有下架 准备上架
                console.log("  StatusUp  " + data.id);
                seckKillStatusChange(1, data.id);
                secTable.reload("listSecKill");
            }

        });

        // 检验是否存在对应秒杀时段上架商品使用该时段
        function isExistSeckillProduct(seckillId) {
            console.log("  seckillId  " + seckillId)
            var num = 0;
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/plan",
                data: "method=isExistSeckillProduct&seckillId=" + seckillId,
                dataType: "json",
                success: function (data) {
                    console.log(data.rs[0].num)
                    num = data.rs[0].num;
                },
                error: function () {
                    layer.msg("错误");
                }
            });
            return num;
        }

        onLoadSeckillSource();

        // 秒杀时段搜索查询
        function onLoadSeckillSource() {
            //获取商品来源
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/plan",
                data: "method=selectSeckillTimeList2",
                dataType: "json",
                success: function (data) {
                    var array = data.rs;
                    if (array.length > 0) {
                        for (var obj in array) {
                            $("#seckill_source").append("<option value='" + array[obj].id + "'>" + array[obj].seckill_name + "</option>");
                        }
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });
            form.render('select');
        }

        // 栏目商品上架时间设定 保存
        $("#updatePlanProductBtn").on('click', function () {

             var s_seckillSukNum = $("#s_seckillSukNum").val();
             if (s_seckillSukNum == 0) {
                 layer.msg(" 没有秒杀sku参与不可上架 ");
                 return false;
             }

            var s_begintime = $("#s_begintime").val();
            console.log("  s_begintime   " + s_begintime);
            // 秒杀开始时间
            var s_endtime = $("#s_endtime").val();
            console.log("   s_endtime   " + s_endtime);
            // 秒杀结束时间
            if (s_begintime == '') {
                layer.msg("上架时间未确定");
                return false;
            } else if (!$('#hasPreTimeEnd').is(':checked') && s_endtime == '') {
                layer.msg("下架时间未确定");
                return false;
            }
            var s_secid = $("#s_secid").val();
            // 修改栏目上架商品的ID
            productStatusUp(s_begintime, s_endtime, 1, s_secid);
            // 商品上架
            return false;
        });

        // 栏目商品上下架状态的改变
        function productStatusUp(s_begintime, s_endtime, status, id) {

            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/plan",
                data: "method=productStatusUp&begintime=" + s_begintime + "&endtime=" + s_endtime + "&status=" + status + "&id=" + id,   //批量删除
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg("  商品上架成功  ");
                        layer.close(productPlanIndex);
                        table.reload("listTable");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });
        }

        //监听 栏目商品上下架
        table.on('tool(tableFilter)', function (obj) {
            var data = obj.data;

            if (obj.event === 'dele') {
                console.log(obj.data.plan_group)
                if (obj.data.product_status == '1') {
                    layer.msg("  商品在上架状态中在启用中 不能删除 ");
                    return false;
                }
                layer.confirm('确认删除?', function (index) {
                    //layer.msg(data.id);
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/plan",
                        data: "method=deleColumnProduct&id=" + obj.data.id + "&plan_group=" + obj.data.plan_group,
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg('删除成功', {time: 2000}, function () {
                                    //do something
                                });
                                table.reload("listTable");
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.msg("错误");
                        }
                    });
                });

            } else if (obj.event === 'edit') {
                // 栏目商品的添加
                var spu_id = data.uri.split("=")[1];
                $('#u_spu_id').val(spu_id);//放入spu_id
                var title = "栏目商品管理-修改【" + data.spu_name + "】的信息";
                addPlanIndex = layer.open({
                    type: 1
                    , title: title
                    , offset: 'auto'
                    , id: 'ProductStatus'
                    , area: ['90%', '95%']
                    , content: $('#addProductDiv')
                    //,btn: '关闭'
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //遮罩
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调

                    }
                });

                // 获取信息
                getColumnProductOneInfo(spu_id);

                seckillSkuTable.render({
                    elem: '#skuGoodsList'
                    // , width: '120%'
                    , cellMinWidth: 420
                    , url: '${ctx}/goods?method=getGoodsSKUList' //数据接口
                    , response: {
                        statusName: 'success' //数据状态的字段名称，默认：code
                        , statusCode: 1  //成功的状态码，默认：0
                        , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                        , countName: 'total' //数据总数的字段名称，默认：count
                        , dataName: 'rs' //数据列表的字段名称，默认：data
                    }
                    , where: {
                        goodsSPUId: spu_id
                    }
                    , limit: 100 //每页显示的条数
                    , limits: [100, 200]
                    , id: 'skuGoodsList'
                    , page: true //开启分页
                    , cols: [[ //表头
                        // {type: 'checkbox', fixed: 'left', field: "ids"}
                        {
                            field: 'sku_name',
                            fixed: 'center',
                            width: 400,
                            title: 'SKU-规格名称',
                            align: 'center',
                            fixed: 'left'
                        }
                        , {
                            field: 'sku_status',
                            width: 100,
                            fixed: 'center',
                            title: '状态',
                            align: 'center',
                            templet: '#sku_statusTpl',
                            unresize: true
                        }
                        , {
                            field: 'first_attribute_value',
                            width: 270,
                            fixed: 'center',
                            fixed: 'center',
                            title: '销售属性值',
                            align: 'center',
                            templet: '#attributeTpl',
                            unresize: true
                        }
                        , {field: 'stock', width: 100, fixed: 'center', title: '库存数', align: 'center'}
                        , {field: 'buyconfine', width: 100, fixed: 'center', title: '限购数量', align: 'center'}
                        , {
                            field: 'original_price',
                            fixed: 'center',
                            width: 140,
                            title: '原价/成本价(元)',
                            align: 'center',
                            templet: function (d) {
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
                            field: 'market_price',
                            fixed: 'center',
                            width: 120,
                            title: '销售价(元)',
                            align: 'center',
                            templet: function (d) {
                                var num = "";
                                if (d.market_price == "") {
                                    num = "----"
                                } else {
                                    num = (d.market_price / 100).toFixed(2)
                                }
                                return num;
                            }
                        }, {
                            field: 'seckill_price',
                            event: "getUpdate",
                            fixed: 'center',
                            width: 120,
                            title: '秒杀价(元)',
                            align: 'center',
                            templet: function (d) {
                                var num = "";
                                if (d.seckill_price == "") {
                                    num = "";
                                } else {
                                    num = (d.seckill_price / 100).toFixed(2);
                                }
                                return num;
                            }
                        }

                        , {
                            fixed: 'left',
                            title: '操作',
                            width: 250,
                            align: 'center',
                            toolbar: "#seckillSkuGoodsManage"
                        }

                    ]]
                });

                <!-- 添加秒杀SKU  -->
            } else if (obj.event === 'StatusDown') {
                var spu_id = data.uri.split("=")[1];
                productStatusChange(0, spu_id);
                table.reload("listTable");
            } else if (obj.event === 'StatusUp') {
                console.log(" spu_key   " + obj.data.spu_key);
                // 上架时候 必须保证至少有一个秒杀价格启用
                var flag = IsCheckSeckillPriceUp(obj.data.spu_key);
                console.log(" flag "+flag)
                if (flag == false) {
                    layer.msg("  请至少启用一个秒杀价格. ");
                    return false;
                }
                console.log("  original_price " + obj.data.original_price);
                console.log("  seckillSkuNum is "+obj.data.seckillSukNum);
                var s_original_price = obj.data.original_price;
                var seckillSukNum = obj.data.seckillSukNum;
                $("#s_original_price").val(s_original_price);
                $("#s_seckillSukNum").val(seckillSukNum);
                var spu_id = data.uri.split("=")[1];
                // 原有下架 准备上架 需要设定商品上架时间
                var title = "处理【" + data.spu_name + "】的信息";
                console.log("   start up  ");
                productPlanIndex = layer.open({
                    type: 1
                    , title: title
                    , offset: 'auto'
                    , id: 'productPlanOpen'
                    , area: ['40%', '60%']
                    , content: $('#productPlanDiv')
                    //,btn: '关闭'
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //遮罩
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调

                    }
                });
                $("#s_spu_name").val(data.spu_name);
                $("#s_secid").val(data.id);
                // 商品名称
                $('#s_begintime').val(Utils.FormatDate(data.start_time));
                // 秒杀开始时间
                if (data.end_time != '999999999999') {
                    $('#s_endtime').val(Utils.FormatDate(data.end_time));
                    // 秒杀结束时间
                } else {
                    $("#s_endtime").val('');
                    $("#s_endtimeDiv").hide();
                    $("#hasPreTimeEnd").attr('checked', true);
                }
                return false;
            } else if (obj.event === 'setSign') {
                layer.prompt({
                    formType: 2
                    , title: ' ' + data.spu_name + ' 的信息'
                    // ,value: data.original_price
                    , value: '商品原价需大于商品金额'
                }, function (value, index) {
                    layer.close(index);

                    // 这里一般是发送修改的Ajax请求

                    // 同步更新表格和缓存对应的值
                    // obj.update({
                    //     original_price: value
                    // });
                });
            }
        });

        // 验证上架商品必须有一个秒杀价格启用中
        function IsCheckSeckillPriceUp(spu_key) {
            var flag = true;
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/plan",
                data: "method=IsCheckSeckillPriceUp&spuKey=" + spu_key,   //批量删除
                dataType: "json",
                success: function (data) {
                    var num = data.rs[0].seckillSpecNum;
                    console.log(" num  is  "+num);
                    if (num != 0) {
                        flag = true;
                    } else {
                        flag = false;
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            })
                return flag;
        }

        // 秒杀时段使用状态的改变
        function seckKillStatusChange(status, id) {
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/plan",
                data: "method=changeSeckillUse&is_default=" + status + "&id=" + id,   //批量删除
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg("  操作成功  ");
                        table.reload("listTable");
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            })
            return false;
        }

        // 栏目商品下架状态的改变
        function productStatusChange(status, id) {
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/plan",
                data: "method=productStatusChange&status=" + status + "&spu_key=" + id,   //批量删除
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg("  操作成功  ");
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            })
            return false;
        }

        //点击按钮 搜索推荐记录
        $('#planSearchBtn').on('click', function () {
            var title = $("#title");
            var plan_group = $("#s_plan_group");
            var seckillSource = $("#seckill_source");
            var productStatus = $("#productStatus");

            //执行重载
            table.reload('listTable', {
                page: {
                    curr: 1
                }
                , where: {
                    title: title.val(),//
                    plan_group: plan_group.val(), //
                    seckillSource: seckillSource.val(), //
                    productStatus: productStatus.val()
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

        //点击按钮 增加推荐
        var listGoodsIndex;
        $('#addPlanBtn').on('click', function () {

            listGoodsIndex = layer.open({
                type: 1
                , title: '提示：请选定一个商品进行首页推荐'
                , offset: 'auto'
                , id: 'listGoodsOpen'
                //,area: ['800px', '550px']
                , area: ['75%', '80%']
                , content: $('#listGoodsDiv')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , shade: 0 //遮罩
                , yes: function () {
                    //layer.closeAll();
                }
                , end: function () {   //层销毁后触发的回调

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
            recommenTable.render({
                elem: '#listGoods'
                , height: 'full-247'
                , cellMinWidth: 190
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
                    {field: 'spu_name', width: 450, title: 'SPU-商品名称'}
                    , {field: 'spu_code', title: '商品编码'}
                    , {field: 'sourceName', title: '商品来源'}
                    , {field: 'brandName', title: '品牌'}
                    , {field: 'cateName', title: '商品分类'}
                    , {field: 'goodsTypeName', title: '商品类型'}
                    , {field: 'editTime', title: '编辑时间'}
                    , {field: 'nick_name', title: '操作者'}
                    , {field: 'status', title: '状态', templet: '#goodsStatusTpl'}
                    , {
                        field: 'wealth',
                        width: 230,
                        fixed: 'right',
                        align: 'center',
                        title: '操作',
                        toolbar: "#listGoodsBar"
                    }
                ]]
            });

            return false;
        });

        // 秒杀时段管理
        var seckillIndex;
        $('#seckillBtn').on('click', function () {
            seckillIndex = layer.open({
                type: 1
                , title: ' 秒杀时段管理 '
                , offset: 'auto'
                , id: 'listGoodsOpen'
                , area: ['75%', '80%']
                , content: $('#seckillDiv')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , shade: 0 //遮罩
                , yes: function () {

                }
                , end: function () {   //层销毁后触发的回调

                }
            });
            //执行一个 table 实例
            secTable.render({
                elem: '#listSecKill'
                , height: 'full-247'
                , cellMinWidth: 190
                , url: '${ctx}/plan?method=selectSeckillTimeList'
                , response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    , statusCode: 1  //成功的状态码，默认：0
                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    , countName: 'total' //数据总数的字段名称，默认：count
                    , dataName: 'rs' //数据列表的字段名称，默认：data
                }
                , id: 'listSecKill'
                // , limit: 10 // 每页显示的条数
                // , limits: [10, 50, 100]
                // , page: true // 开启分页
                , cols: [[ // 表头
                    {type: 'checkbox', fixed: 'left', field: "ids"}
                    , {field: 'seckill_name', width: 200, title: '秒杀时段名称'}
                    // , {field: 'seckill_time', title: '秒杀时间', templet: '#seckillTimeTmpl'}
                    , {field: 'start_time', width: 200, title: '秒杀开始时间', templet: '#startTimeTmpl'}
                    , {field: 'end_time', width: 200, title: '秒杀结束时间', templet: '#endTimeTmpl'}
                    , {
                        field: 'running_status', width: 120, title: '秒杀时段状态', templet: function (d) {
                            if (d.runing_status == 1) {
                                return "<font color='#228b22'>未到时间</font>";
                            } else if (d.runing_status == 2) {
                                return "<font color='red'>开始抢购</font>";
                            } else if (d.runing_status == 3) {
                                return "<font color='purple'>已结束</font>";
                            }
                        }
                    }
                    , {field: 'status', width: 120, title: '状态', templet: '#StatusTpl'}
                    , {
                        field: 'hahaha',
                        fixed: 'right',
                        align: 'center',
                        title: '操作',
                        toolbar: "#seckillBar"
                    }
                ]]
            });
            return false;
        });

        //监听 商品
        var addPlanIndex;
        var productPlanIndex;
        table.on('tool(listGoodsFilter)', function (obj) {
            var data = obj.data;
            console.log("   selected  plan_group   " + columnId)
            if (obj.event === 'selected') {
                var spu_id = data.id;
                console.log("   select   select   " + spu_id);
                $('#p_spu_id').val(spu_id);//放入spu_id

                var title = "将【" + data.spu_name + "】加入栏目推荐";
                addPlanIndex = layer.open({  //打开添加推荐页
                    type: 1
                    , title: title
                    , id: 'addProductOpen'
                    , area: ['60%', '60%']
                    , content: $('#productRecommonDiv')
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //遮罩
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调

                    }
                });

                $("#p_spu_name").val(data.spu_name);
                $("#seckill_id").empty();
                //获取准备数据
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/plan",
                    data: "method=selectSeckillTimeList2",
                    dataType: "json",
                    success: function (data) {
                        if (data.success == 1) {
                            //获取商品来源
                            var array = data.rs;
                            console.log(array.length);
                            if (array.length > 0) {
                                for (var obj in array) {
                                    var flags;
                                    if (array[obj].status == 1) {
                                        flags = '<font color="red">启用</font>';
                                    } else if (array[obj].status == 0) {
                                        flags = '<font color="blue">禁用</font>';
                                    }
                                    $("#seckill_id").append("<option value='" + array[obj].id + "'>" + array[obj].seckill_name + " [" + flags + "]" + "</option>");
                                    seckillSourceMap.put(array[obj].id, array[obj].seckill_name);
                                }
                            }
                            //(注意：需要重新渲染)
                            form.render('select');
                        }
                    },
                    error: function () {
                        layer.msg("error");
                    }
                });

            }
        });

        //监听"checkbox"操作
        form.on('checkbox(checkboxFilter)', function (obj) {
            //处理时间
            if (this.name == 'hasPreSaleTimeEnd' && obj.elem.checked) {
                $("#presell_endtime").val('');
                $("#presell_endtimeDiv").hide();
                //obj.val('no');
            } else if (this.name == 'hasPreSaleTimeEnd' && !obj.elem.checked) {
                $("#presell_endtimeDiv").show();
                //obj.val('yes');
            }
            form.render('checkbox');
            form.render('select');
        });

        // 查看秒杀时段信息
        function getSecKillInfo(id) {
            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=getSecKillInfo&id=" + id,
                dataType: "json",
                async: true,
                success: function (data) {
                    if (data.success) {
                        $('#u_secKillName').val(data.rs[0].seckill_name);
                        $('#u_secStartTime').val(Utils.FormatDate(data.rs[0].start_time));
                        $('#u_secEndtime').val(Utils.FormatDate(data.rs[0].end_time));
                        form.render('checkbox');
                        form.render('select');
                    }
                },
                error: function (error) {
                    console.log("error=" + error);
                }
            });
        }

        /**
         * 查看栏目商品信息
         * @param spu_id
         */
        function getColumnProductOneInfo(spu_id) {
            // var cTime = document.getElementById("u_seckill_id");
            // cTime.options.length = 0;
            // $("#u_seckill_id").find("option").remove();
            $("#u_seckill_id").empty();

            // 获取秒杀时段数据
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                url: "${ctx}/plan",
                data: "method=selectSeckillTimeList2",
                dataType: "json",
                success: function (data) {
                    // 获取商品来源
                    var array = data.rs;
                    if (array.length > 0) {
                        for (var obj = 0; obj < array.length; obj++) {
                            $("#u_seckill_id").append("<option value='" + array[obj].id + "'>" + array[obj].seckill_name + "</option>");
                            seckillSourceMap.put(array[obj].id, array[obj].seckill_name);
                        }
                    }
                    //(注意：需要重新渲染)
                    form.render('select');
                },
                error: function () {
                    layer.msg("  错误  ");
                }
            });

            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=getColumnProductOneInfo&spu_id=" + spu_id,
                dataType: "json",
                async: true,
                success: function (data) {
                    if (data.success) {
                        $('#u_spu_name').val(data.rs[0].spu_name);
                        $('#u_product_price').val((data.rs[0].product_price / 100).toFixed(2));
                        $('#tmp_product_price').val(data.rs[0].product_price);
                        // $('#u_original_price').val((data.rs[0].original_price / 100).toFixed(2));
                        $('#u_spu_id').val(data.rs[0].spu_key);
                        $('#u_sort').val(data.rs[0].sort);
                        $('#presell_begintime').val(Utils.FormatDate(data.rs[0].bstarttime));
                        console.log("   data.rs[0].bendtime  " + data.rs[0].bendtime);
                        // 十位 区分正常十二位 数字
                        if (data.rs[0].bendtime != '999999999999') {
                            $("#presell_endtimeDiv").show();
                            $("#hasPreSaleTimeEnd").attr('checked', false);
                            $('#presell_endtime').val(Utils.FormatDate(data.rs[0].bendtime));
                        } else {
                            $("#presell_endtime").val('');
                            $("#presell_endtimeDiv").hide();
                            $("#hasPreSaleTimeEnd").attr('checked', true);
                        }

                        var seckillCode = data.rs[0].seckillId;
                        console.log("  seckillCode  " + seckillCode + " mapSize " + seckillSourceMap.size());
                        if (seckillCode && (seckillSourceMap.size() > 0)) {
                            $("#u_seckill_id").empty();
                            seckillSourceMap.each(function (value, key) {
                                console.log(" key " + key + " value " + value);
                                console.log(value == seckillCode);
                                if (value == seckillCode) {
                                    $("#u_seckill_id").append("<option value='" + value + "' selected>" + value + " [" + key + "]" + "</option>");
                                } else {
                                    $("#u_seckill_id").append("<option value='" + value + "'>" + value + " [" + key + "]" + "</option>");
                                }
                            });
                        } else {

                        }
                        form.render('select');
                        form.render('checkbox');
                    }
                },
                error: function (error) {
                    console.log("error=" + error);
                }
            });

        }

        // 更新秒杀时段信息
        $('#updateSeckillBtn').on('click', function () {
            var secKillName = $("#u_secKillName").val();
            var secStartTime = $("#u_secStartTime").val();
            var secEndTime = $("#u_secEndtime").val();

            var secId = $("#secId").val();
            console.log("  obj.id " + secId);
            if (secKillName == "" || secKillName == undefined) {
                layer.msg(" 秒杀时段名称不能为空 ");
                return false;
            } else if (secStartTime == "" || secStartTime == undefined) {
                layer.msg(" 秒杀开始时间不能为空 ");
                return false;
            } else if (secEndTime == "" || secEndTime == undefined) {
                layer.msg(" 秒杀结束时间不能为空 ");
                return false;
            }

            // 更新秒杀时段
            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=updateSeckillTimeSetting&secKillName=" + secKillName + "&secStartTime=" + secStartTime + "&secEndTime=" + secEndTime + "&id=" + secId,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        layer.msg(' 修改成功! ', {time: 4000}, function () {
                            secTable.reload('listSecKill');
                        });
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });

            return false;
        });

        var secKillInsert;
        // 点击按钮 新增秒杀时段
        $('#s_insert').on('click', function () {
            secKillInsert = layer.open({
                type: 1
                , title: '提示：请输入秒杀时段和名称'
                , offset: 'auto'
                , id: 'insertSeckillOpen'
                //,area: ['800px', '550px']
                , area: ['65%', '60%']
                , content: $('#insertSeckillDiv')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , shade: 0 //遮罩
                , yes: function () {

                }
                , end: function () {   //层销毁后触发的回调

                }
            });
            return false;
        });

        // 新增秒杀时段
        $("#insertSeckillBtn").on('click', function () {
            var secKillName = $("#i_secKillName").val();
            var secStartTime = $("#i_secStartTime").val();
            var secEndTime = $("#i_secEndtime").val();
            console.log("  obj.id " + secId);
            if (secKillName == "" || secKillName == undefined) {
                layer.msg(" 秒杀时段名称不能为空 ");
                return false;
            } else if (secStartTime == "" || secStartTime == undefined) {
                layer.msg(" 秒杀开始时间不能为空 ");
                return false;
            } else if (secEndTime == "" || secEndTime == undefined) {
                layer.msg(" 秒杀结束时间不能为空 ");
                return false;
            }
            // 新增秒杀时段方法
            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=insertSeckillTimeSetting&secKillName=" + secKillName + "&secStartTime=" + secStartTime + "&secEndTime=" + secEndTime,
                // data: {jsonString: JSON.stringify($('#seckillForm').serializeObject())},
                // contentType: "application/json",  //缺失会出现URL编码，无法转成json对象
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg(' 新增成功! ', {time: 2000}, function () {
                            secTable.reload('listSecKill');
                            layer.close(secKillInsert);
                        });
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });
            return false;
        });

        // 保存添加商品到秒杀栏目中
        $("#savePlanProductBtn").on('click', function () {
            console.log("  savePlanProductBtn  ");
            var p_spu_name = $("#p_spu_name").val();

            var seckill_id = $("#seckill_id").val();
            if (seckill_id == '') {
                layer.msg(" 请选择秒杀场次 ");
                return false;
            }
            console.log(" p_spu_name  " + p_spu_name + "   seckill_id    " + seckill_id);
            // 新增商品到秒杀栏目区域
            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=saveGoodsForSeckillColumn",
                data: {jsonString: JSON.stringify($('#productSeckillRecommonForm').serializeObject())},
                contentType: "application/json",  //缺失会出现URL编码，无法转成json对象
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg(' 新增成功! ', {time: 2000}, function () {
                            layer.close(addPlanIndex);
                            recommenTable.reload('listGoods');
                            table.reload('listTable');
                        });
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });
            return false;
        });
        //
        $("#saveColumnProductBtn").on('click', function () {
            console.log("  saveColumnProductBtn   ");
            // 商品原价
            /* var u_original_price = $('#u_original_price').val();
             var isNum = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
             if (!(isNum.test(u_original_price))) {
                 layer.msg("  请输入正确的商品原价格式数据  ");
                 return false;
             } else if (u_original_price == 0) {
                 layer.msg(" 商品原价 不能为0  ");
                 return false;
             }
 */
            // var tmp_product_price = $("#tmp_product_price").val();
            // if (tmp_product_price >= u_original_price*100) {
            //     layer.msg(" 商品原价必须大于商品金额 ");
            //     return false;
            // }

            var u_spu_id = $('#u_spu_id').val();
            // 排序
            var u_sort = $('#u_sort').val();
            u_sort == '' ? 0 : u_sort;

            // 秒杀场次必填
            var u_seckill_id = $("#u_seckill_id").val();
            if (u_seckill_id == "") {
                layer.msg(" 秒杀场次必填 ");
                return false;
            }
            // 商品上架时间
            var presell_begintime = $('#presell_begintime').val();
            // 商品下架时间
            var presell_endtime = $('#presell_endtime').val();
            if (presell_begintime == '') {
                layer.msg(" 商品上架时间不能为空 ");
                return false;
            } else if (!$('#hasPreSaleTimeEnd').is(':checked') && presell_endtime == "") {
                layer.msg(" 商品下架结束时间不能为空 ");
                return false;
            }
            // if (!(isNum.test(u_sort))) {
            //     layer.msg(" 是否是顺序执行 ");
            //     return false;
            // }
            // 10是商品原价字段 弃用 sql未改 所以0占用
            updateColumnGoods(10, presell_begintime, presell_endtime, u_seckill_id, u_sort, u_spu_id);
            return false;
        });
        // 栏目商品上架时间确定
        form.on('checkbox(updatePlanProductFilter)', function (obj) {
            // 处理时间
            if (this.name == 'hasPreTimeEnd' && obj.elem.checked) {
                $("#s_endtime").val('');
                $("#s_endtimeDiv").hide();
            } else if (this.name == 'hasPreTimeEnd' && !obj.elem.checked) {
                $("#s_endtimeDiv").show();
            }

            form.render('checkbox');
            form.render('select');
        });

        //点击栏目商品编辑 监听 秒杀价格 变动
        seckillSkuTable.on('tool(skuGoodsListFilter)', function (obj) {

            var value = obj.value //得到修改后的值
                , data = obj.data //得到所在行所有键值
                , field = obj.field; //得到字段
            var skuId = data.id;
            var isNum = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
            // if (count == 1) {
            //     // 第一次访问显示这个变量
            //     var skuSeckillPrice = (data.seckill_price / 100).toFixed(2);
            // } else{
            //     // 第二次以后访问显示这个
            //     var skuSeckillPrice = data.seckill_price;
            // }

            if (obj.event === 'getUpdate') {
                layer.prompt({
                    formType: 0
                    , title: '填写 [ <font color="blue"> ' + data.sku_name + '</font> 的<font color="red">秒杀价格</font>'
                    , value: ""
                }, function (value, index) {
                    if (!(isNum.test(value))) {
                        layer.msg(" 秒杀价格数值填写不正确,请重新填写 ");
                        return false;
                    } else if (value == "") {
                        layer.msg(" 填写数值不能为空 ");
                        return false;
                    }
                    layer.close(index);
                    //这里一般是发送修改的Ajax请求
                    var seckillPrice = value * 100;
                    console.log("   seckillPrice  " + seckillPrice + " skuId   " + skuId);
                    updateSkuSeckillPrice(skuId, seckillPrice);
                    //同步更新表格和缓存对应的值
                    obj.update({
                        seckill_price: (seckillPrice / 100).toFixed(2)
                    });

                });
            }

            // 启用停用 sku秒杀
            if (obj.event === 'seckillSkuGoodsStatus') {
                // seckillSkuGoodsStatus
                var seckillskuGoodsStatus = obj.data.enabled;
                var seckillSkuPrice = obj.data.seckill_price;

                if (seckillSkuPrice == "") {
                    layer.msg(obj.data.first_attribute_value+"的秒杀价格未设置! ");
                    return false;
                }
                if (seckillskuGoodsStatus == 1) {
                    // 说明此栏目开启中 询问是否关闭
                    layer.msg('确定要停用该SKU秒杀商品价格吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        , closeBtn: 1    // 是否显示关闭按钮
                        , anim: 1 //动画类型
                        , btn: ['确定', '取消'] //按钮
                        , icon: 5    // icon
                        , yes: function () {
                            setTimeout(upOrDownSkuSekillPrice(obj.data.id, 0), 60000);//60秒内不可以重复点击，一秒等于1000毫秒
                            seckillSkuTable.reload("skuGoodsList");
                            table.reload("listTable");
                        }
                        , btn2: function () {
                            layer.closeAll();
                        }
                    });
                } else {
                    // 准备启用
                    // 说明栏目是关闭状态 准备开启
                    layer.msg('确定要启用该SKU秒杀商品价格吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        , closeBtn: 1    // 是否显示关闭按钮
                        , anim: 1 //动画类型
                        , btn: ['确定', '取消'] //按钮
                        , icon: 6    // icon
                        , yes: function () {
                            setTimeout(upOrDownSkuSekillPrice( obj.data.id, 1), 60000);//60秒内不可以重复点击，一秒等于1000毫秒
                            seckillSkuTable.reload("skuGoodsList");
                        }
                        , btn2: function () {
                            layer.closeAll();
                        }
                    });

                }

            }
            return false;
        });

        /**
         * 启用或者停用SKU秒杀商品
         **/
        function upOrDownSkuSekillPrice(skuId, status) {
            $.ajax({
                type:"post"
                ,url:"${ctx}/plan?method=upOrDownSkuSekillPrice"
                ,data:{
                    skuId:skuId,
                    status:status
                }
                ,dataType:"json"
                ,success:function (data) {
                    console.log(data.success);
                    layer.msg(" 操作成功  ");
                }
                ,error:function () {
                    layer.msg(" 更新状态失败 请重试或联系管理员 ");
                }
            });
            return false;
        }

        /**
         * 添加或更新 SKU秒杀价格
         * @param skuId
         * @param seckillPrice
         */
        function updateSkuSeckillPrice(skuId, seckillPrice) {
            $.ajax({
                type: "post",
                url: "${ctx}/plan?method=updateSKUGoodsSeckillPrice",
                data: {
                    skuId: skuId,
                    seckillPrice: seckillPrice
                },
                dataType: "json",
                success: function (data) {
                    console.log(data.success);
                    if (data.success == 1) {
                        layer.msg(" 该SKU商品秒杀价格设定成功 ");
                    }
                },
                error: function () {
                    layer.msg(" 填写失败,请重试或者联系管理员 ");
                }
            });
            return false;
        }

        // 栏目商品更新上架时间处理 添加商品原价
        function updateColumnGoods(original_price, bstarttime, bendtime, u_seckill_id, sort, spuId) {
            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=updateColumnGoods&original_price=" + original_price
                + "&sort=" + sort + "&bstarttime=" + bstarttime
                + "&bendtime=" + bendtime + "&spuId=" + spuId + "&seckillId=" + u_seckill_id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg(' 修改成功! ', {time: 2000}, function () {
                            layer.close(addPlanIndex);
                            table.reload('listTable');

                        });
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });
        }
    });

</script>
<!-- 参与秒杀SKU列表的设置-->
<script type="text/html" id="seckillSkuGoodsManage">
    {{#  if(d.enabled == 1){ }}
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">
        <i class="start"><font color="red">开启中</font></i></a>--%>
    <a class="layui-btn layui-btn-xs seckill-status-Up layui-btn-radius" lay-event="seckillSkuGoodsStatus">开启中</a>
    &nbsp;&nbsp;&nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="seckillSkuGoodsStatus">&nbsp;&nbsp;禁用&nbsp;&nbsp;</a>
    &nbsp;&nbsp;&nbsp;
    {{#  } else if(d.enabled == 0) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="seckillSkuGoodsStatus">&nbsp;&nbsp;启动&nbsp;&nbsp;</a>
    &nbsp;&nbsp;&nbsp;
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
        <%--<i class="stop"><font color="blue">禁用中</font></i></a>--%>
    <a class="layui-btn layui-btn-xs seckill-status-Down layui-btn-radius">禁用中</a>
    <!-- style="opacity: 0.2"-->
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {{#  } }}
</script>
<!--栏目商品 -->
<script type="text/html" id="barDemo">

    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">&nbsp;&nbsp;编辑&nbsp;&nbsp;</a>
    &nbsp;
    {{#  if(d.product_status == '1'){ }}
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
        <%--<i class="start" ><font color="red">上架中</font></i></a>--%>
    <a class="layui-btn layui-btn-xs seckill-status-Up layui-btn-radius">上架中</a>
    <!--style="opacity: 0.2" -->
    &nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="StatusDown">&nbsp;&nbsp;下架&nbsp;&nbsp;</a>
    {{#  } else if(d.product_status == '0') { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="StatusUp">&nbsp;&nbsp;上架&nbsp;&nbsp;</a>
    &nbsp;
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
        <%--<i class="end"><font color="blue">下架中</font></i></a>--%>
    <a class="layui-btn layui-btn-xs seckill-status-Down layui-btn-radius">下架中</a>
    {{#  } }}
    &nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="dele">&nbsp;&nbsp;删除&nbsp;&nbsp;</a>
</script>
<style>
    .seckill-status-Up{
        background-color: #00CC00;
    }
    .seckill-status-Down{
        background-color: #999999;
    }
</style>
<!--秒杀时段管理 -->
<script type="text/html" id="seckillBar">

    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">&nbsp;&nbsp;编辑&nbsp;&nbsp;</a>
    &nbsp;&nbsp;&nbsp;
    {{#  if(d.status == '1'){ }}
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
        <%--<i class="start"><font color="red">启用中</font></i></a>--%>
    <a class="layui-btn layui-btn-xs seckill-status-Up layui-btn-radius">&nbsp;&nbsp;开启中&nbsp;</a>
    &nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="StatusDown">&nbsp;&nbsp;&nbsp;&nbsp;禁用&nbsp;&nbsp;&nbsp;&nbsp;</a>
    {{#  } else if(d.status == '0') { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="StatusUp">&nbsp;&nbsp;&nbsp;开启&nbsp;&nbsp;&nbsp;</a>
    &nbsp;
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
        <%--<i class="end"><font color="blue">禁用中</font></i></a>--%>
    <a class="layui-btn layui-btn-xs seckill-status-Down layui-btn-radius">&nbsp;&nbsp;禁用中&nbsp;&nbsp;</a>
    {{#  } }}
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%--<a lay-event="dele">删除</a> style="opacity: 0.2" --%>

</script>
<script type="text/html" id="seckillTimeTmpl">
    {{# if(d.seckill_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.seckill_time.substr(0,2) }}-{{ d.seckill_time.substr(2,2) }}-{{ d.seckill_time.substr(4,2) }} {{ d.seckill_time.substr(6,2) }}:{{ d.seckill_time.substr(8,2) }}:{{ d.seckill_time.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="startTimeTmpl">
    {{# if(d.start_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.start_time.substr(0,2) }}-{{ d.start_time.substr(2,2) }}-{{ d.start_time.substr(4,2) }} {{ d.start_time.substr(6,2) }}:{{ d.start_time.substr(8,2) }}:{{ d.start_time.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="endTimeTmpl">
    {{# if(d.end_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.end_time.substr(0,2) }}-{{ d.end_time.substr(2,2) }}-{{ d.end_time.substr(4,2) }} {{ d.end_time.substr(6,2) }}:{{ d.end_time.substr(8,2) }}:{{ d.end_time.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="cStatusTpl">
    {{#  if(d.product_status === '1'){ }}
    <font color="00CC00">上架</font>
    {{#  } else if(d.product_status === '0'){ }}
    <font color="red">下架</font>
    {{#  } }}
</script>
<script type="text/html" id="startTimeTmpl">
    {{# if(d.edit_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.edit_time.substr(0,2) }}-{{ d.edit_time.substr(2,2) }}-{{ d.edit_time.substr(4,2) }} {{ d.edit_time.substr(6,2) }}:{{ d.edit_time.substr(8,2) }}:{{ d.edit_time.substr(10,2) }}
    {{# } }}
</script>
<script type="text/html" id="endTimeTmpl">
    {{# if(d.edit_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.edit_time.substr(0,2) }}-{{ d.edit_time.substr(2,2) }}-{{ d.edit_time.substr(4,2) }} {{ d.edit_time.substr(6,2) }}:{{ d.edit_time.substr(8,2) }}:{{ d.edit_time.substr(10,2) }}
    {{# } }}
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
<script type="text/html" id="StatusTpl">
    {{#  if(d.status === '1'){ }}
    <span><font color="#228b22">启用</font></span>
    {{#  } else if(d.status === '0'){ }}
    <span><font color="red">禁用</font></span>
    {{#  } }}
</script>
<!-- 停售 起售 -->
<script type="text/html" id="sku_statusTpl">
    {{#  if(d.sku_status === '0'){ }}
    <span>停售</span>
    {{#  } else { }}
    <span>起售</span>
    {{#  } }}
</script>
<!-- 销售属性 -->
<script type="text/html" id="attributeTpl">
    {{d.first_attribute_value}}/{{d.second_attribute_value}}
</script>
<!-- -->
<script type="text/html" id="startTimeTpl">
    {{# if(d.start_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.start_time.substr(0,2) }}-{{ d.start_time.substr(2,2) }}-{{ d.start_time.substr(4,2) }} {{ d.start_time.substr(6,2) }}:{{ d.start_time.substr(8,2) }}:{{ d.start_time.substr(10,2) }}
    {{# } }}
</script>
<!-- -->
<script type="text/html" id="endTimeTpl">
    {{# if(d.end_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.end_time.substr(0,2) }}-{{ d.end_time.substr(2,2) }}-{{ d.end_time.substr(4,2) }} {{ d.end_time.substr(6,2) }}:{{ d.end_time.substr(8,2) }}:{{ d.end_time.substr(10,2) }}
    {{# } }}
</script>

<!--商品上架时间 -->
<script type="text/html" id="productUpTimeTmpl">
    {{# if(d.bstarttime ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.bstarttime.substr(0,2) }}-{{ d.bstarttime.substr(2,2) }}-{{ d.bstarttime.substr(4,2) }} {{ d.bstarttime.substr(6,2) }}:{{ d.bstarttime.substr(8,2) }}:{{ d.bstarttime.substr(10,2) }}
    {{# } }}
</script>
<!--商品下架时间 -->
<script type="text/html" id="productDownTimeTmpl">
    {{#    if(d.bendtime == ''){                           }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>

    {{#    }else if(d.bendtime != "999999999999") {        }}

    20{{ d.bendtime.substr(0,2) }}-{{ d.bendtime.substr(2,2) }}-{{ d.bendtime.substr(4,2) }} {{ d.bendtime.substr(6,2) }}:{{ d.bendtime.substr(8,2) }}:{{ d.bendtime.substr(10,2) }}

    {{#    }if(d.bendtime == "999999999999"){                }}

    <font color="red">下架时间未定</font>
    {{#    }                                                 }}


    {{#  }}
</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            栏目列表>>自营秒杀区栏目 商品列表
            <button id="return" class="layui-btn layui-btn-sm" onclick="javascript:history.go(-1);"
                    style="margin-left: 1200px;"><i class="layui-icon">&#xe615;</i>返回
            </button>
        </div>
        <form class="layui-form layui-form-pane">
            <div style="background-color:#f2f2f2;padding:5px 0;">
                <div class="layui-form-item" style="padding: 0;margin: 0">
                    <label class="layui-form-label">商品名称</label>
                    <div class="layui-input-inline">
                        <input type="text" autocomplete="off" id="title" name="title" class="layui-input">
                    </div>
                    <label class="layui-form-label">秒杀时段</label>
                    <div class="layui-input-inline">
                        <%--lay-filter="goodsSource"--%>
                        <select id="seckill_source" name="seckill_source">
                            <option value="">请选择</option>
                        </select>
                    </div>
                    <label class="layui-form-label">上下架状态</label>
                    <div class="layui-input-inline">
                        <select id="productStatus" name="productStatus">
                            <option value="">请选择</option>
                            <option value="1">上架</option>
                            <option value="0">下架</option>
                        </select>
                    </div>
                    <button id="planSearchBtn" data-type="sreach" class="layui-btn layui-btn-sm"
                            style="margin-top: 5px"><i class="layui-icon">&#xe615;</i>搜索
                    </button>
                    <button type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置
                    </button>
                </div>
            </div>

            <div>
                <%--<button id="bashDeleteBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe640;</i>批量删除
                </button>--%>
                <button id="addPlanBtn" data-type="auto" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i
                        class="layui-icon">&#xe61f;</i>添加推荐
                </button>
                <button id="seckillBtn" data-type="auto" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i
                        class="layui-icon">&#xe61f;</i>秒杀时段管理
                </button>
            </div>

        </form>

        <table class="layui-hide" id="tablelist" lay-filter="tableFilter"></table>

    </div>
</div>

<!-- 罗列商品 start -->
<div id="listGoodsDiv" style="display: none;padding: 15px;">
    <form class="layui-form" id="listGoodsForm">
        <div style="background-color:#f2f2f2;">
            <div class="layui-form-item" style="padding: 15px;">
                <label class="layui-label">商品名称</label>
                <div class="layui-inline">
                    <input type="text" id="g_spu_name" name="g_spu_name" lay-verify="title" autocomplete="off"
                           placeholder="" class="layui-input">
                </div>
                <label class="layui-label">商品来源</label>
                <div class="layui-inline">
                    <select id="g_goods_source" name="g_goods_source">
                        <option value="">请选择</option>
                    </select>
                </div>
                <label class="layui-label">商品分类</label>
                <div class="layui-inline">
                    <input type="text" id="g_cateName" name="g_cateName" class="layui-input">
                </div>
                <label class="layui-label">商品类型</label>
                <div class="layui-inline">
                    <input type="text" id="g_goodsTypeName" name="g_goodsTypeName" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button id="g_searchBtn" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe615;</i>搜索
                    </button>
                    <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </div>
        </div>
    </form>
    <table class="layui-hide" id="listGoods" lay-filter="listGoodsFilter"></table>
    <script type="text/html" id="listGoodsBar">
        <%--<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>--%>
        <a class="layui-btn layui-btn-sm layui-btn-normal" lay-event="selected">选定</a>
    </script>
</div>
<!-- 罗列商品 end -->

<!-- 秒杀时段 start -->
<div id="seckillDiv" style="display: none;padding: 15px;">
    <form class="layui-form" id="listSeckillForm">
        <div style="background-color:#f2f2f2;">
            <div class="layui-form-item" style="padding: 15px;">
                <div class="layui-inline">
                    <%--<button id="g_searchBtn" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe615;</i>搜索
                    </button>--%>
                    <%-- <button id="s_insert" class="layui-btn layui-btn-sm">新增
                     </button>--%>
                </div>
            </div>
        </div>
        <table class="layui-hide" id="listSecKill" lay-filter="listSecKillFlter"></table>
    </form>
</div>
<!-- 秒杀时段 end -->

<!-- 编辑秒杀时段 -->
<div id="updateSeckillDiv" style="display: none;">
    <form id="seckillForm" class="layui-form" style="padding: 15px;">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><font color="red">*</font>秒杀时段名称</label>
            <div class="layui-input-inline">
                <input style="width:400px;" id="u_secKillName" name="u_seckillName" autocomplete="off"
                       placeholder=""
                       class="layui-input" type="text">
                <input type="hidden" id="secId" name="secId"/>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>秒杀开始时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="u_secStartTime" name="u_secStartTime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" id="secendtimeDiv">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>秒杀结束时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="u_secEndtime" name="u_secEndTime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" align="center">
                <button class="layui-btn" id="updateSeckillBtn">更新
                </button>
            </div>
        </div>

    </form>
</div>
<!-- 编辑秒杀时段结束 -->

<!-- 新增秒杀时段 -->
<div id="insertSeckillDiv" style="display: none;">
    <form id="insertSeckillForm" class="layui-form" style="padding: 15px;">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><font color="red">*</font>秒杀时段名称</label>
            <div class="layui-input-inline">
                <input style="width:400px;" id="i_secKillName" name="i_seckillName" autocomplete="off"
                       placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>秒杀开始时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="i_secStartTime" name="i_secStartTime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline" id="isecendtimeDiv">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>秒杀结束时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="i_secEndtime" name="i_secEndTime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" align="center">
                <button class="layui-btn" id="insertSeckillBtn">保存
                </button>
            </div>
        </div>

    </form>
</div>
<!-- 编辑秒杀时段结束 -->

<!-- 栏目商品修改 start -->
<div id="addProductDiv" style="display: none;">
    <form id="planForm" class="layui-form" style="padding: 15px;">
        <div style="float: left" width="300px">
            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px"><font color="red">*</font>商品名称</label>
                <div class="layui-input-inline">
                    <input style="width:400px;" id="u_spu_name" name="u_spu_name" autocomplete="off"
                           placeholder=""
                           class="layui-input" type="text" readonly="readonly">
                    <input id="u_spu_id" name="u_spu_id" type="hidden">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px">商品金额</label>
                <div class="layui-input-inline">
                    <input style="width:400px;" readonly="readonly" id="u_product_price" name="u_product_price"
                           autocomplete="off"
                           placeholder=""
                           class="layui-input" type="text">商品默认SKU商品价格
                    <input id="tmp_product_price" name="tmp_product_price" autocomplete="off" placeholder=""
                           type="hidden">
                </div>
            </div>

            <%--  <div class="layui-form-item">
                  <label class="layui-form-label" style="width: 150px"><font color="red"></font>商品原价 </label>
                  <div class="layui-input-inline">
                      <input style="width:400px;" id="u_original_price" name="u_original_price"
                             autocomplete="off" placeholder="" class="layui-input" type="text">
                  </div>
              </div>--%>
        </div>
        <div style="float: right;margin-right: 300px;" width="100%">

            <!--商品编辑所属秒杀时段信息 管理 -->
            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px"><label style="color: #ff3025">*</label>秒杀场次:
                </label>
                <div class="layui-input-inline layui-form">
                    <select id="u_seckill_id" name="u_seckill_id" lay-filter="selFilter">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <!-- 商品编辑所属秒杀时段信息 管理end -->

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>上架开始时间:</label>
                    <div class="layui-input-inline">
                        <input class="layui-input" id="presell_begintime" name="presell_begintime"
                               placeholder="yyyy-MM-dd HH:mm:ss" autocomplete="off" type="text">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline" id="presell_endtimeDiv">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>下架结束时间:</label>
                    <div class="layui-input-inline">
                        <input class="layui-input" id="presell_endtime" name="presell_endtime"
                               placeholder="yyyy-MM-dd HH:mm:ss" autocomplete="off" type="text">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px">&nbsp;&nbsp;</label>
                    <input id="hasPreSaleTimeEnd" name="hasPreSaleTimeEnd" lay-skin="primary" title="结束时间不限"
                           type="checkbox" lay-filter="checkboxFilter">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px">排序号: </label>
                <div class="layui-input-inline">
                    <input id="u_sort" name="u_sort" autocomplete="off"
                           placeholder="" class="layui-input" type="text">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" align="right">
                <button class="layui-btn" id="saveColumnProductBtn" lay-submit="">确定
                </button>
            </div>
        </div>
    </form>
    <h3 style="margin-left: 10px;"><font color="#dc143c">填写下列SKU商品的秒杀价格</font></h3>
    <br>
    <table style="margin-left: 10px" class="layui-hide" id="skuGoodsList" lay-filter="skuGoodsListFilter"></table>
</div>
<!-- 加入商品推荐 end -->

<!-- 加入 start -->
<div id="productRecommonDiv" style="display: none;">
    <form id="productSeckillRecommonForm" class="layui-form" style="padding: 15px;">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><font color="red">*</font>商品名称</label>
            <div class="layui-input-inline">
                <input style="width:400px;" id="p_spu_name" name="p_spu_name" autocomplete="off"
                       placeholder=""
                       class="layui-input" type="text" readonly="readonly">
                <input id="p_spu_id" name="p_spu_id" type="hidden" readonly="readonly">
                <input id="plan_group" name="plan_group" value="<%=columnId%>" type="hidden">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><label style="color: #ff3025">*</label>秒杀场次: </label>
            <div class="layui-input-inline layui-form">
                <select id="seckill_id" name="seckill_id" lay-filter="selFilter">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block" align="center">
                <button class="layui-btn" id="savePlanProductBtn" name="">保存
                </button>
            </div>
        </div>

    </form>
</div>
<!-- 加入商品推荐 end -->

<!-- 商品上架时间设定 -->
<div id="productPlanDiv" style="display: none;">
    <form id="productPlanForm" class="layui-form" style="padding: 15px;">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><font color="red">*</font>商品名称</label>
            <div class="layui-input-inline">
                <input style="width:400px;" id="s_spu_name" name="s_spu_name" autocomplete="off"
                       placeholder=""
                       class="layui-input" type="text" readonly="readonly">
                <input type="hidden" id="s_secid" name="s_secid">
                <input type="hidden" id="s_original_price" name="s_original_price">
                <input type="hidden" id="s_seckillSukNum" name="s_seckillSukNum">
            </div>
        </div>

        <h3>上架时间:</h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>开始时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="s_begintime" name="s_begintime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline" id="s_endtimeDiv">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>结束时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="s_endtime" name="s_endtime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>

        <div class="layui-form-item" pane="">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px">&nbsp;&nbsp;</label>
                <input id="hasPreTimeEnd" name="hasPreTimeEnd" lay-skin="primary" title="预售结束时间不限"
                       type="checkbox" lay-filter="updatePlanProductFilter">
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block" align="center">
                <button class="layui-btn" id="updatePlanProductBtn" name="updatePlanProductBtn">上架
                </button>
            </div>
        </div>

    </form>
</div>
<!-- 商品上架时间设定 end -->


<%@ include file="/common/footer.jsp" %>