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
            , url: '${ctx}/goods?method=getGoodsList'
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
                {
                    type: 'checkbox', fixed: 'left', field: "ids"

                }
                , {field: 'sort', width: 80, title: '排序号', align: 'center', edit: 'text'}
                , {field: 'spu_name', width: 500, title: 'SPU-商品名称', align: 'center'}
                , {field: 'spu_code', width: 150, title: '商品编码', align: 'center'}
                , {field: 'status', width: 90, title: '商品状态', align: 'center', templet: '#statusId'}
                // , {field: 'first_attribute', templet: '#Tp1', width: 120, title: '属性一[数量]', align:'center'}
                // , {field: 'second_attribute', templet: '#Tp2', width: 120, title: '属性二[数量]', align:'center'}
                , {field: 'skuNum', width: 120, title: '规格数量', align: 'center'}
                , {
                    field: 'priceDistrict', templet: function (d) {
                        if (d.highestPrice == d.lowestPrice) {
                            // 一样 显示一个即可
                            return "￥" + d.highestPrice/100;
                        }
                        else {
                            return "￥" + d.highestPrice/100 + " - " + "￥" + d.lowestPrice/100;
                        }
                    }, width: 200, title: '商品金额(元)', align: 'center'
                }
                , {
                    field: 'bountyDistrict', templet: function (d) {
                        if (d.lowestBounty == d.bountyPrice) {
                            // 一样 显示一个即可
                            return "￥" + d.highestBounty/100;
                        }
                        else {
                            return "￥" + d.highestBounty/100 + " - " + "￥" + d.lowestBounty/100;
                        }
                    }, width: 200, title: '奖励金(元)', align: 'center'
                }
                , {field: 'sourceName', width: 100, title: '商品来源', align: 'center'}
                , {field: 'brandName', width: 80, title: '品牌', align: 'center'}
                , {field: 'cateName', width: 90, title: '商品分类', align: 'center'}
                , {field: 'goodsTypeName', width: 90, title: '商品类型', align: 'center'}
                , {field: 'editTime', width: 220, title: '编辑时间', sort: true, align: 'center', templet: '#editTimeTmpl'}
                , {field: 'nick_name', width: 140, title: '操作者', align: 'center'}
                , {field: 'memo', width: 115, title: '商品备注', align: 'center'}
                , {field: 'wealth', width: 230, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
            ]]
        });
        //日期
        laydate.render({
            elem: '#dateStart'
        });
        laydate.render({
            elem: '#dateEnd'
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


        function onLoadData() {
            //获取商品来源
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/goods",
                data: "method=getAllNormalGoodsSourceList",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        var array = data.result.rs;
                        if (array.length > 0) {
                            for (var obj in array) {
                                $("#goods_source").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</option>");
                                $("#s_goods_source").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</option>");
                                //goodsSourceMap.set(array[obj].dict_data_value, array[obj].dict_data_name);
                            }
                        }
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });

            form.render('select');


            return false;
        };

        onLoadData();

        //点击按钮 搜索商品
        $('#searchBtn').on('click', function () {

            var isChecked = $('#showStopSale').prop('checked');
            var stopSale = "";

            if (isChecked) {
                stopSale = "show";
            }

            var spu_name = $('#spu_name');
            var goods_source = $('#goods_source');
            var spu_code = $('#spu_code');
            var cateName = $('#cateName');
            var goodsTypeName = $('#goodsTypeName');
            var status = $('#status');
            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    spu_name: spu_name.val(),
                    goods_source: goods_source.val(),
                    spu_code: spu_code.val(),
                    cateName: cateName.val(),
                    goodsTypeName: goodsTypeName.val(),
                    status: status.val(),
                    stopSale: stopSale
                }
            });
            return false;
        });

        //点击按钮 高级搜索商品
        $('#superSearchBtn').on('click', function () {
            var stopSale = "";
            var spu_name = $('#s_spu_name');
            var goods_source = $('#s_goods_source');
            var spu_code = $('#s_spu_code');
            var cateName = $('#s_cateName');
            var goodsTypeName = $('#s_goodsTypeName');
            var status = $('#s_status');
            table.reload('listTable', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    spu_name: spu_name.val(),
                    goods_source: goods_source.val(),
                    spu_code: spu_code.val(),
                    cateName: cateName.val(),
                    goodsTypeName: goodsTypeName.val(),
                    status: status.val(),
                    stopSale: stopSale
                }
            });
            layer.close(openIndex);
            return false;
        });

        //监听"checkbox"操作
        form.on('checkbox(checkboxFilter)', function (obj) {
            $('#searchBtn').click();
        });


        //点击"商品导入"按钮
        $('#btnGoodImport').on('click', function () {
            var text = "Demo Demo";
            layer.open({
                type: 1
                , title: '导入商品'
                //,offset: 'auto'
                , id: 'goodImportOpen'
                , area: ['500px', '300px']
                , content: $('#goodImportDiv')
                , shade: 0 //不显示遮罩
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , yes: function () {
                    layer.closeAll();
                }
            });
            return false;
        });

        //点击"商品上架"按钮
        $('#btnGoodUp').on('click', function () {

            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;

            var ids = new Array(selectCount);
            for (var i = 0; i < selectCount; i++) {
                if (checkStatus.data[i].status == 1) {
                    // 当前商品已经上架
                    layer.msg(checkStatus.data[i].spu_name + "    已经上架   请取消选择 ")
                    return false;
                }
                ids[i] = checkStatus.data[i].id;
                // 可以添加商品参数 传送后台
            }
            ;

            if (selectCount == 0) {
                layer.msg(" 请选择一条数据！ ");
                return false;
            }
            layer.msg("  功能尚未完成 请勿使用 ");
            return false;
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/goods",
                data: "method=updateSpuAndSubSkuStatus?ids=" + ids + "&status=1" + "&spu_id=" + spu_id,
                dataType: "json",
                success: function (data) {
                    layer.alert("成功");

                },
                error: function () {
                    layer.alert("错误");
                }
            });


            return false;
        });

        //点击"商品下架"按钮
        $('#btnGoodDown').on('click', function () {

            layer.msg("   功能尚未完成 请勿使用 ");
            return false;
        });

        //点击"导出"
        $('#exportGoods').on('click', function () {
            //layer.msg("   功能尚未完成 请勿使用 ");
            var exportData = "";
            var spuName = $('#spu_name').val();
            var goodsSource = $('#goods_source').val();
            var status = $('#status').val();
            var cateName = $('#cateName').val();
            var goodsTypeName = $('#goodsTypeName').val();
            var spuCode = $('#spu_code').val();

            if (spuName != "") {
                exportData = "&spuName=" + spuName
            }
            if (goodsSource != "") {
                exportData = "&goodsSource=" + goodsSource
            }
            if (status != "") {
                exportData = exportData + "&status=" + status
            }
            if (cateName != "") {
                exportData = exportData + "&cateName=" + cateName
            }
            if (goodsTypeName != "") {
                exportData = exportData + "&goodsTypeName=" + goodsTypeName
            }
            if (spuCode != "") {
                exportData = exportData + "&spuCode=" + spuCode
            }

            var url = "${ctx}/createSimpleExcelToDisk?method=exportGoodsExcel";
            if (exportData != "")
                url = url + exportData;
            //var fileName = "testAjaxDownload.txt";
            console.log("     url    " + url);
            window.location.href = url;
            return false;
        });

        //点击"商级搜索"按钮
        var openIndex;
        $('#btnSearchMore').on('click', function () {
            var text = "Demo Demo";
            openIndex = layer.open({
                type: 1
                , title: '高级搜索'
                //,offset: 'auto'
                , id: 'searchMoreOpen'
                , area: ['600px', '650px']
                , content: $('#searchMoreDiv')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , yes: function () {
                    layer.closeAll();
                }
            });
            return false;
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
                        // table.reload('listTable');
                    }
                });
            }


        });

        function SendPost(status, id, othis) {
            $.ajax({
                type: "get",
                url: "${ctx}/goods",
                data: "method=updateGoodsSPUStatus&status=" + status + "&id=" + id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {

                    if (status == 1) {  //上架时，判断是否有起售的SKU
                        if (data.CNT == 'NO') {  //如果没有，不能上架
                            $('#' + "switch" + id).val(0);
                            othis.prop("checked", false); //不能上架
                            form.render('checkbox');
                            layer.msg('没有起售状态的SKU，不能上架');
                        } else {
                            if (data.success) {
                                $('#' + "switch" + id).val(1);
                                form.render('checkbox');
                                layer.msg('上架操作成功', {time: 2000}, function () {
                                    //do something
                                    //table.reload('listTable');
                                });
                            } else {
                                layer.msg("异常");
                            }
                        }
                    } else {
                        if (data.success) {
                            $('#' + "switch" + id).val(0);
                            //layui.form.render();
                            form.render('checkbox');
                            layer.msg('下架操作成功', {time: 2000}, function () {
                                table.reload('listTable');
                            });
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

        //监听工具条
        table.on('tool(tableFilter)', function (obj) {
            var othis = $(this);
            var pCateName = othis.data('method');
            var pCateCode = othis.data('value');//此为工具条里的父级编码，区别于全局变量中的父级编码

            var data = obj.data;

            if (obj.event === 'detail') {
                layer.msg('ID：' + data.id + ' 的查看操作');
            } else if (obj.event === 'del') {
                layer.confirm('确认移入回收站?', function (index) {
                    //layer.msg(data.id);
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存

                    layer.close(index);
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goods",
                        data: "method=updateGoodsStatus&status=2&id=" + data.id,   //status=2 移入回收站
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg('移入回收站成功', {time: 2000}, function () {
                                    //do something

                                });
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    });
                });
            } else if (obj.event === 'edit') {
                //layer.alert('编辑行：<br>'+ JSON.stringify(data))
                window.location.href = "${ctx}/goods/goodsAdd_B.jsp?spu_id=" + data.id
                    + "&minCateCode=" + data.category_id
                    + "&goodsTypeCode=" + data.goods_type_id + "";

            }
        });


        //监听单元格编辑(排序)
        table.on('edit(tableFilter)', function (obj) {
            var value = obj.value //得到修改后的值
                , data = obj.data //得到所在行所有键值
                , field = obj.field; //得到字段
            var othis = $(this);

            if (!(/^\d+$/.test(value))) {
                othis.val(0);
                //layer.msg('[名称:'+data.dict_data_name+']的排序号请输入正整数，已归置为0，请重新输入！');
                layer.tips('[名称:' + data.spu_name + ']的排序号请输入正整数，已归置为0，请重新输入！', othis);
                return false;
            }
            var that = othis;
            $.ajax({
                type: "get",
                url: "${ctx}/goods",
                data: "method=updateSPUSort&sort=" + value + "&id=" + data.id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('[名称:' + obj.data.spu_name + ']的排序号，更改成功!');
                    } else {
                        //that.val(0);
                        layer.msg("异常");
                    }
                },
                error: function () {
                    //that.val(0);
                    layer.alert("错误");
                }
            });
        });


        //刷新排序
        $('#freshSortBtn').on('click', function () {
            //table.reload('listTable');
            $('#searchBtn').click();
            return false;
        });


        //点击按钮 批量移入回收站
        $('#pushToTrash').on('click', function () {
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;
            if (selectCount == 0) {
                layer.msg("请选择一条数据！");
                return false;
            }
            ;

            if (selectCount > 1) {

                layer.confirm('真的要将选中的商品移入回收站吗？', function (index) {
                    layer.close(index);
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
                        url: "${ctx}/goods",
                        data: "method=updateGoodsStatusBatch&status=2&ids=" + ids,   //批量处理 status=2 移入回收站
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


        //点击按钮 规格管理
        $('#toSKUListBtn').on('click', function () {
            //debugger
            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;

            var selectCount = data.length;
            if (selectCount == 0) {
                layer.msg("请选择一条数据！");
                return false;
            }
            ;
            if (selectCount > 1) {
                layer.msg("只能选择一条数据！");
                return false;
            }

            if (selectCount === 1) {
                //alert(JSON.stringify(checkStatus.data))
                var goodsSPUId = checkStatus.data[0].id;
                //   alert("  checkStatus.data[0].id     " + checkStatus.data[0].id);
                var goodsSPUName = checkStatus.data[0].spu_name;
                //encodeURI(encodeURI(goodsSPUName))
                window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId=" + goodsSPUId + "&goodsSPUName=" + goodsSPUName;
            }
            return false;
        });


        //点击按钮 加入首页推荐
        var addPlanIndex = 0;
        $('#addPlanBtn').on('click', function () {

            var checkStatus = table.checkStatus('listTable');
            var data = checkStatus.data;
            var selectCount = data.length;

            if (selectCount == 0) {
                layer.msg("请选择一条数据！");
                return false;
            }
            ;
            if (selectCount > 1) {
                layer.msg("只能选择一条数据！");
                return false;
            }
            if (selectCount === 1) {

                var spu_id = checkStatus.data[0].id;

                $('#ad_spu_id').val(spu_id);//放入spu_id

                addPlanIndex = layer.open({
                    type: 1
                    , title: '加入到首页推荐'
                    , offset: 'auto'
                    , id: 'addPlanOpen'
                    //,area: ['800px', '550px']
                    , area: ['60%', '60%']
                    , content: $('#addPlanDiv')
                    //,btn: '关闭'
                    , shade: 0 //不显示遮罩
                    , btnAlign: 'c' //按钮居中
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调

                        //将所有的表单数据置为空
                        $(':input', '#planForm')
                            .not(':button, :submit, :reset')
                            .val('')
                            .removeAttr('checked')
                            .removeAttr('selected');
                        $('#plan_img').attr('src', '');
                    }

                });

                //获取首页推荐数据
                $.ajax({
                    type: "get",
                    url: "${ctx}/plan?method=getGoodsPlanInfo&spuId=" + spu_id,
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        if (data.success) {
                            if (data.rs[0].id) {
                                $('#ad_title').val(data.rs[0].title);
                                $('#plan_group').val(data.rs[0].plan_group);
                                $('#ad_sort').val(data.rs[0].sort);
                                $('#ad_memo').val(data.rs[0].memo);
                                $('#ad_promote').val(data.rs[0].promote);
                                $('#ad_id').val(data.rs[0].id);


                                if (data.rs[0].img_id != "") {
                                    $('#plan_img').attr('src', data.rs[0].img_path);
                                    $('#imgDiv').show();
                                    $('#imgId').val(data.rs[0].img_id);
                                    $('#planImgDiv').show();
                                } else {
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
            }
            return false;
        });

        //点击按钮 保存加入到首页推荐
        $('#savePlanBtn').on('click', function () {
            var ad_title = $("#ad_title").val();
            var imgId = $('#imgId').val();
            if (ad_title.length < 2) {
                layer.msg('广告位标题至少输入2个字符！');
                $("#ad_title").focus();
                return false;
            }
            // if(!imgId){
            //     layer.msg('请上传推荐图片！');
            //     return false;
            // }
            if ($("#plan_group").val() == "") {
                layer.msg('请选择首页显示位置');
                return false;
            }
            var ad_sort = $("#ad_sort").val();
            if (!(/^\d+$/.test(ad_sort)) && ad_sort != "") {
                layer.msg('广告位序号请输入正整数！');
                $("#ad_sort").focus();
                return false;
            }

            $.ajax({
                type: "get",
                url: "${ctx}/plan?method=saveGoodsPlan",
                //data: "method=addSKU&jsonString="+JSON.stringify($('form').serializeObject()),
                data: {jsonString: JSON.stringify($('#planForm').serializeObject())},
                contentType: "application/json",  //缺失会出现URL编码，无法转成json对象
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        var id;
                        layer.msg('保存成功!', {time: 1000}, function () {

                            // $('#planForm').reset();//jquery没有reset方法
                            //$('#planForm')[0].reset();//调用 DOM 中的reset方法来重置表单

                            layer.close(addPlanIndex);
                        });
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });
            return false;
        });

        form.on('select(productSource)', function (data) {

            $.ajax({
                type: "get",
                //       async: false, // 同步请求
                //       cache: false,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/goods",
                data: "method=getAllNormalGoodsSourceList",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        var array = data.result.rs;
                        if (array.length > 0) {
                            for (var obj in array) {
                                $("#goods_source").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</option>");
                                $("#s_goods_source").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + " [" + array[obj].dict_data_value + "]" + "</option>");
                                //goodsSourceMap.set(array[obj].dict_data_value, array[obj].dict_data_name);
                            }
                        }
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });

            form.render('select');
            return false;

        });

    });


</script>


<!-- 属性一(数量) -->
<script id="Tp1" type="text/html">
    {{d.first_attribute}} [{{ d.cnt1==''?'0':d.cnt1 }}]
</script>
<!-- 属性二(数量) -->
<script id="Tp2" type="text/html">
    {{d.second_attribute}}[{{d.cnt2==''?'0':d.cnt2}}]
</script>
<!-- 时间格式化 -->
<script type="text/html" id="editTimeTmpl">
    {{# if(d.edit_time ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    20{{ d.edit_time.substr(0,2) }}-{{ d.edit_time.substr(2,2) }}-{{ d.edit_time.substr(4,2) }} {{ d.edit_time.substr(6,2) }}:{{ d.edit_time.substr(8,2) }}:{{ d.edit_time.substr(10,2) }}
    {{# } }}
</script>

<!-- 操作 -->
<script type="text/html" id="barDemo">
    <input id="switch{{d.id}}" type="checkbox" name="status{{d.id}}" value="{{d.status}}" lay-skin="switch"
           lay-text="上架|下架"
           data-value="{{d.id}}"
           lay-filter="statusFilter" {{ d.status==1 ? 'checked' : '' }} >
    &nbsp;&nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="del">移入回收站</a>
</script>

<script type="text/html" id="statusId">
    {{d.status=='1'? '<font color="red">上架</font>':'下架' }}
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">
            商品列表
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

                    <label class="layui-form-label">商品来源</label>
                    <div class="layui-input-inline">
                        <%--lay-filter="productSource"--%>
                        <select id="goods_source" name="goods_source">
                            <option value="">请选择</option>
                        </select>
                    </div>

                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select id="status" name="status">
                            <option value=""></option>
                            <option value="1">上架</option>
                            <option value="0">下架</option>
                        </select>
                    </div>
                    <div class="layui-input-inline">
                        <input type="checkbox" id="showStopSale" name="showStopSale" value="" title="有停售规格">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom: 0">
                    <label class="layui-form-label">商品分类</label>
                    <div class="layui-input-inline">
                        <input id="cateName" name="cateName" type="text" autocomplete="off" class="layui-input">
                    </div>
                    <label class="layui-form-label">商品类型</label>
                    <div class="layui-input-inline">
                        <input id="goodsTypeName" name="goodsTypeName" type="text" autocomplete="off"
                               class="layui-input">
                    </div>
                    <label class="layui-form-label">商品编码</label>
                    <div class="layui-input-inline">
                        <input id="spu_code" name="spu_code" type="text" autocomplete="off" class="layui-input">
                    </div>
                    <button id="searchBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i
                            class="layui-icon">&#xe615;</i>搜索
                    </button>
                    <button id="btnSearchMore" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i
                            class="layui-icon">&#xe615;</i>高级搜索
                    </button>
                    <button type="reset" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#x2746;</i>重置
                    </button>
                </div>

            </div>

            <div style="margin-top: 5px">
                <button data-method="offset" id="toSKUListBtn" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe62d;</i>规格管理
                </button>
                <button id="freshSortBtn" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe60a;</i>刷新排序
                </button>
                <button data-method="offset" id="addPlanBtn" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe61f;</i>加入首页推荐
                </button>
                <a class="layui-btn layui-btn-sm" href="./goodsAdd_A.jsp" target="_self"><i
                        class="layui-icon">&#xe61f;</i>添加商品</a>
                <button id="pushToTrash" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe640;</i>移入回收站</button>
                <button id="btnGoodImport" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe63c;</i>商品导入
                </button>

                <button id="btnGoodUp" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe63c;</i>商品上架
                </button>
                <button id="btnGoodDown" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe63c;</i>商品下架
                </button>
                <button id="exportGoods" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i
                        class="layui-icon">&#xe63c;</i>导出
                </button>
                <script type="application/javascript">
                    //提交
                    function exportGoods() {

                        var exportData = "";
                        var spuName = $('#spu_name').val();
                        var goodsSource = $('#goods_source').val();
                        var status = $('#status').val();
                        var cateName = $('#cateName').val();
                        var goodsTypeName = $('#goodsTypeName').val();
                        var spuCode = $('#spu_code').val();


                        if (spuName != "") {
                            exportData = "&spuName=" + spuName
                        }
                        if (goodsSource != "") {
                            exportData = "&goodsSource=" + goodsSource
                        }
                        if (status != "") {
                            exportData = exportData + "&status=" + status
                        }
                        if (cateName != "") {
                            exportData = exportData + "&cateName=" + cateName
                        }
                        if (goodsTypeName != "") {
                            exportData = exportData + "&goodsTypeName=" + goodsTypeName
                        }
                        if (spuCode != "") {
                            exportData = exportData + "&spuCode=" + spuCode
                        }

                        var url = "${ctx}/createSimpleExcelToDisk?method=exportGoodsExcel";
                        if (exportData != "")
                            url = url + exportData;
                        //var fileName = "testAjaxDownload.txt";
                        console.log("     url    " + url);
                        window.location.href = url;
                        return false;
                    }
                </script>

            </div>
        </form>

        <table class="layui-hide" id="goodsList" lay-filter="tableFilter">


        </table>

        <!-- render-- >
    </div>


    <!-- 商品导入-->
        <div id="goodImportDiv" style="display: none;">
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <a class="layui-btn layui-btn-normal">下载模板</a>
                </div>
            </div>

            <div class="layui-upload">
                <label class="layui-form-label">选择文件</label>
                <div class="layui-input-inline">
                    <input name="file" id="test20" type="file">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn">保存</button>
                </div>
            </div>
        </div>


        <!-- 高级搜索 -->
        <div id="searchMoreDiv" style="display: none;">
            <form class="layui-form" style="padding: 15px;">

                <div class="layui-form-item">
                    <label class="layui-form-label">商品名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="s_spu_name" name="s_spu_name" lay-verify="required"
                               autocomplete="off"
                               placeholder="" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">商品编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="s_spu_code" name="s_spu_code" lay-verify="required"
                               autocomplete="off"
                               placeholder="" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">商品分类</label>
                    <div class="layui-input-inline">
                        <input id="s_cateName" name="s_cateName" type="text" autocomplete="off" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">商品类型</label>
                    <div class="layui-input-inline">
                        <input id="s_goodsTypeName" name="s_goodsTypeName" type="text" autocomplete="off"
                               class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">商品来源</label>
                    <div class="layui-input-inline">
                        <select id="s_goods_source" name="s_goods_source" lay-filter="aihao" lay-verify="required">
                            <option value="">请选择</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">库存</label>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                               placeholder="最低库存" class="layui-input">
                    </div>
                    <div class="layui-input-inline" style="width: 20px;">
                        --
                    </div>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                               placeholder="最高库存" class="layui-input">
                    </div>
                </div>


                <div class="layui-form-item">
                    <label class="layui-form-label">商品状态</label>
                    <div class="layui-input-inline">
                        <select id="s_status" name="s_status" lay-filter="aihao">
                            <option value=""></option>
                            <option value="1">上架</option>
                            <option value="0">下架</option>
                        </select>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">销售价格</label>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                               placeholder="最低价格" class="layui-input">
                    </div>
                    <div class="layui-input-inline" style="width: 20px;">
                        --
                    </div>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                               placeholder="最高价格" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" id="superSearchBtn" lay-submit="" lay-filter="demo1"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button type="reset" class="layui-btn"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <%@ include file="/common/footer.jsp" %>

    <!-- 加入首页推荐 -->
    <div id="addPlanDiv" style="display: none;">
        <form id="planForm" class="layui-form" style="padding: 15px;">
            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px">标题</label>

                <div class="layui-input-inline">
                    <input id="ad_title" name="ad_title" autocomplete="off" placeholder=""
                           class="layui-input" type="text">

                    <input id="ad_spu_id" name="ad_spu_id" type="hidden">
                    <input id="ad_id" name="ad_id" type="hidden">
                </div>

            </div>

            <div class="layui-form-item" id="planImgDiv">
                <label class="layui-form-label" style="width: 150px">图片</label>
                <div class="layui-input-inline">
                    <div class="layui-upload-list" id="imgDiv">
                        <img class="layui-upload-img" id="plan_img">
                        <input type="hidden" id="imgId" name="imgId" value="" lay-verify="required" autocomplete="off">
                        <p id="imgP"></p>
                    </div>

                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px">首页显示位置: </label>
                    <div class="layui-input-inline">
                        <select id="plan_group" name="plan_group" lay-filter="selFilter">
                            <option value="">请选择</option>
                            <option value="1">首页banner</option>
                            <option value="2">产品推荐</option>
                            <option value="3">超值爆款</option>
                            <option value="4">底价打折</option>
                            <option value="5">推荐商品</option>
                            <option value="6">活动商品</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px">备注 : </label>
                <div class="layui-input-inline">
                    <input style="width: 500px;" id="ad_memo" name="ad_memo" lay-verify="ad_memo" autocomplete="off"
                           placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px">促销语(promote) : </label>
                <div class="layui-input-inline">
                    <input style="width: 500px;" id="ad_promote" name="ad_promote" lay-verify="ad_promote"
                           autocomplete="off" placeholder="" class="layui-input" type="text">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px">排序号 : </label>
                <div class="layui-input-inline">
                    <input style="width: 500px;" id="ad_sort" name="ad_sort" lay-verify="ad_sort" autocomplete="off"
                           placeholder="" class="layui-input" type="text">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block" align="center">
                    <button class="layui-btn" id="savePlanBtn" lay-submit="" lay-filter="demo1"><i class="layui-icon">&#xe615;</i>保存
                    </button>
                    <button type="reset" class="layui-btn"><i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </div>

        </form>
    </div>


