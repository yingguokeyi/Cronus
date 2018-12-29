<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>
<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>
<%
    String first_attribute = request.getParameter("first_attribute");
    String second_attribute = request.getParameter("second_attribute");
    String spu_name = request.getParameter("spu_name");
    String spu_id = request.getParameter("spu_id");
    String sku_id = request.getParameter("sku_id");

%>

<script>
    var spu_id = <%=spu_id%>;
    // var sku_id = "";
    var sku_id = "<%=sku_id%>";

    var firstAttributeMap = new Map();
    var secondAttributeMap = new Map();
    $(function () {
        //监听返佣规则数值填写
        $("#T_A").blur(function () {
            var market_price = Number($("#market_price").val());
            var original_price = Number($("#original_price").val());
            if (market_price > 0) {
                if (Number($('#T_A').val()) >= 0) {
                    $('#S_A').text(getDistriMoney(market_price, original_price, $('#T_A').val()));
                    document.getElementById('Z_A').value = getDistriMoney(market_price, original_price, $('#T_A').val());
                } else {
                    $('#S_A').text("");
                }
            }
        });
        $("#T_B").blur(function () {
            var market_price = Number($("#market_price").val());
            var original_price = Number($("#original_price").val());
            if (market_price > 0) {
                if (Number($('#T_B').val()) >= 0) {
                    $('#S_B').html(getDistriMoney(market_price, original_price, $('#T_B').val()));
                    document.getElementById('Z_B').value = getDistriMoney(market_price, original_price, $('#T_B').val());
                } else {
                    $('#S_B').html("");
                }
            }
        });
        $("#T_C").blur(function () {
            var market_price = Number($("#market_price").val());
            var original_price = Number($("#original_price").val());
            if (market_price > 0) {
                if (Number($('#T_C').val()) >= 0) {
                    $('#S_C').html(getDistriMoney(market_price, original_price, $('#T_C').val()));
                    document.getElementById('Z_C').value = getDistriMoney(market_price, original_price, $('#T_C').val());
                } else {
                    $('#S_C').html("");
                }
            }
        });
        $("#T_D").blur(function () {
            var market_price = Number($("#market_price").val());
            var original_price = Number($("#original_price").val());
            if (market_price > 0) {
                if (Number($('#T_D').val()) >= 0) {
                    $('#S_D').html(getDistriMoney(market_price, original_price, $('#T_D').val()));
                    document.getElementById('Z_D').value = getDistriMoney(market_price, original_price, $('#T_D').val());
                } else {
                    $('#S_D').html("");
                }
            }
        });
        $("#T_E").blur(function () {
            var market_price = Number($("#market_price").val());
            var original_price = Number($("#original_price").val());
            if (market_price > 0) {
                if (Number($('#T_E').val()) >= 0) {
                    $('#S_E').html(getDistriMoney(market_price, original_price, $('#T_E').val()));
                    document.getElementById('Z_E').value = getDistriMoney(market_price, original_price, $('#T_E').val());
                } else {
                    $('#S_E').html("");
                }
            }
        });
        $("#T_F").blur(function () {
            var market_price = Number($("#market_price").val());
            var original_price = Number($("#original_price").val());
            if (market_price > 0) {
                if (Number($('#T_F').val()) >= 0) {
                    $('#S_F').html(getDistriMoney(market_price, original_price, $('#T_F').val()));
                    document.getElementById('Z_F').value = getDistriMoney(market_price, original_price, $('#T_F').val());
                } else {
                    $('#S_F').html("");
                }
            }
        });
        //监听销售价格填写
        $("#market_price").blur(function () {
            var market_price = $("#market_price").val();
            var original_price = $("#original_price").val();
            var T_A = $("#T_A").val(), T_B = $("#T_B").val(), T_C = $("#T_C").val(), T_D = $("#T_D").val(),
                T_E = $("#T_E").val(), T_F = $("#T_F").val();
            if (Number(market_price) > 0) {
                if (Number(T_A.trim()) > 0) {
                    $('#S_A').html(getDistriMoney(market_price, original_price, T_A));
                }
                if (Number(T_B.trim()) > 0) {
                    $('#S_B').html(getDistriMoney(market_price, original_price, T_B));
                }
                if (Number(T_C.trim()) > 0) {
                    $('#S_C').html(getDistriMoney(market_price, original_price, T_C));
                }
                if (Number(T_D.trim()) > 0) {
                    $('#S_D').html(getDistriMoney(market_price, original_price, T_D));
                }
                if (Number(T_E.trim()) > 0) {
                    $('#S_E').html(getDistriMoney(market_price, original_price, T_E));
                }
                if (Number(T_F.trim()) > 0) {
                    $('#S_F').html(getDistriMoney(market_price, original_price, T_F));
                }
            } else {
                $('#S_A').html("");
                $('#S_B').html("");
                $('#S_C').html("");
                $('#S_D').html("");
                $('#S_E').html("");
                $('#S_F').html("");
            }
        });

        //返佣规则数值计算公式
        function getDistriMoney(market_price, original_price, num) {
            if (Number(market_price) > Number(original_price)) {
                return ((Number(market_price) - Number(original_price)) * Number(num) * 0.01).toFixed(2) + "元";
            }

        }
    });

    layui.use(['form', 'element', 'laydate'], function () {
        var form = layui.form;
        var laydate = layui.laydate
            //,upload = layui.upload
            , element = layui.element;


//返佣规则数值计算公式
        function getDistriMoney(market_price, original_price, num) {
            if (Number(market_price) > Number(original_price)) {
                return ((Number(market_price) - Number(original_price)) * Number(num) * 0.01).toFixed(2) + "元";
            }
        }

        //执行一个laydate实例
        laydate.render({
            elem: '#presell_begintime', type: 'datetime'
        });
        laydate.render({
            elem: '#presell_endtime', type: 'datetime'
        });
        var first_attribute = $("#first_attribute").val();
        var second_attribute = $("#second_attribute").val();
        var spu_name = $("#spu_name").val();
        onLoadData();

        function onLoadData() {
            $('#AD_Div').hide();
            $('#sku_name').val("<%=spu_name%>");
            if (spu_id) {
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods",
                    data: "method=getSPUInfo&spu_id=" + spu_id,
                    dataType: "json",//表示后台返回的数据是json对象
                    async: true,
                    success: function (data) {
                        if (data.success == 1) {
                            $('#spu_name').val(data.rs[0].spu_name);
                            $('#spuNameSpan').html("[" + data.rs[0].spu_name + "]");
                            $('#first_attribute').val(data.rs[0].first_attribute);
                            $('#first_attribute_span').html(data.rs[0].first_attribute);
                            if (data.rs[0].second_attribute == "") {
                                $("#second_attribute_total").hide();
                            }
                            $('#second_attribute').val(data.rs[0].second_attribute);
                            $('#second_attribute_span').html(data.rs[0].second_attribute);
                        }
                        //(注意：需要重新渲染)
                        form.render('select');
                    },
                    error: function (error) {
                        console.log("error=" + error);
                    }
                });
            }
            //加载商品属性信息
            onLoadAttributeData();
            //加载分销规则
            onLoadDistributionData();
            //加载SKU数据(编辑时)
            onLoadSKUData();
        }

        function onLoadAttributeData() {

            $.ajax({
                type: "get",
                url: "${ctx}/goodsAttribute?method=getGoodsAttributeInfo&spuId=" + spu_id,
                dataType: "json",//表示后台返回的数据是json对象
                async: true,
                success: function (data) {
                    if (data.success == 1) {
                        var array = data.result.rs;
                        // console.log("getGoodsAttributeInfo   array   size "+array.length);
                        if (array.length > 0) {
                            for (var obj in array) {
                                if (array[obj].position == 1) {
                                    $("#selectFirst").append("<option value='" + array[obj].id + "'>" + array[obj].attribute_value + "</option>");
                                    firstAttributeMap.set(array[obj].id, array[obj].attribute_value);
                                }

                                if (array[obj].position == 2) {
                                    $("#selectSecond").append("<option value='" + array[obj].id + "'>" + array[obj].attribute_value + "</option>");
                                    secondAttributeMap.set(array[obj].id, array[obj].attribute_value);
                                }
                            }

                            if (firstAttributeMap.size > 0) {
                                $("#checkFirst").attr("checked", false);
                                $("#checkFirst").val('NO');
                                $("#txtFirstDiv").hide();
                            } else {
                                $("#selectFirstDiv").hide();
                            }

                            if (secondAttributeMap.size > 0) {
                                $("#checkSecond").attr("checked", false);
                                $("#checkSecond").val('NO');
                                $("#txtSecondDiv").hide();
                            } else {
                                $("#selectSecondDiv").hide();
                            }
                        } else {

                            $("#selectFirstDiv").hide();
                            $("#checkFirstDiv").hide();

                            $("#selectSecondDiv").hide();
                            $("#checkSecondDiv").hide();
                        }

                        //(注意：需要重新渲染)
                        form.render('select');
                        form.render('checkbox');

                    }
                },
                error: function (error) {
                    console.log("error=" + error);
                }
            });

        };


        var member_Distri_Map = new Map();
        var outsider_Distri_Map = new Map();

        //返佣规则
        function onLoadDistributionData() {

            //会员返佣规则
            $.ajax({
                type: "get",
                url: "${ctx}/goods?method=getDistributionList&type=member",
                dataType: "json",//表示后台返回的数据是json对象
                async: true,
                success: function (data) {
                    if (data.success == 1) {
                        var array = data.result.rs;

                        if (array.length > 0) {
                            // $("#selectMemberDistri").append("<option value='0'>[填写自定义会员返佣规则]</option>");
                            for (var obj in array) {
                                if ("1" == array[obj].is_default) {
                                    $("#selectMemberDistri").append("<option value='" + array[obj].id + "' selected>" + array[obj].dis_name + "</option>");
                                    member_Distri_Map.set(array[obj].id, array[obj].dis_name);
                                } else {
                                    $("#selectMemberDistri").append("<option value='" + array[obj].id + "'>" + array[obj].dis_name + "</option>");
                                    member_Distri_Map.set(array[obj].id, array[obj].dis_name);
                                }
                            }
                        } else {
                            $("#selectMemberDistriDiv").hide();
                        }

                    }
                    //(注意：需要重新渲染)
                    form.render('select');
                },
                error: function (error) {
                    console.log("error=" + error);
                }
            });


            //非会员返佣规则
            $.ajax({
                type: "get",
                url: "${ctx}/goods?method=getDistributionList&type=outsider",
                dataType: "json",//表示后台返回的数据是json对象
                async: true,
                success: function (data) {
                    if (data.success == 1) {
                        var array = data.result.rs;

                        if (array.length > 0) {
                            // $("#selectOutsiderDistri").append("<option value='0'>[填写自定义非会员返佣规则]</option>");
                            for (var obj in array) {
                                if ("1" == array[obj].is_default) {
                                    $("#selectOutsiderDistri").append("<option value='" + array[obj].id + "' selected>" + array[obj].dis_name + "</option>");
                                    outsider_Distri_Map.set(array[obj].id, array[obj].dis_name);
                                } else {
                                    $("#selectOutsiderDistri").append("<option value='" + array[obj].id + "'>" + array[obj].dis_name + "</option>");
                                    outsider_Distri_Map.set(array[obj].id, array[obj].dis_name);
                                }
                            }
                        } else {
                            $("#selectOutsiderDistriDiv").hide();
                        }
                        //(注意：需要重新渲染)
                        form.render('select');
                    }
                },
                error: function (error) {
                    console.log("error=" + error);
                }
            });

        };

        //编辑SKU信息
        function onLoadSKUData() {
            console.log(sku_id == "null")
            if (sku_id != "null") {
                // 存在sku_id 则使用
            } else {
                sku_id = 0;
            }
            console.log(" lastest value  sku_id =  " + sku_id);

            if (sku_id != 0) {
                $("#newOrEditSpan").html("修改");
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/goods",
                    data: "method=getSKUInfo&sku_id=" + sku_id,
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            //  var sku_code = data.rs[0].sku_code;
                            var sku_name = data.rs[0].sku_name;
                            var spu_name = data.rs[0].spu_name;

                            $('#sku_id').val(data.rs[0].id);
                            //   $('#sku_code').val(sku_code);
                            $('#sku_name').val(sku_name);
                            $('#spu_name').val(spu_name);
                            $('#memo').val(data.rs[0].memo);
                            var  bv = data.rs[0].bounty;
                            $("#bounty").val((bv/100).toFixed(2));
                            var first_attribute_id = data.rs[0].first_attribute_id;
                            var second_attribute_id = data.rs[0].second_attribute_id;

                            $.ajax({
                                type: "get",
                                url: "${ctx}/goodsAttribute?method=getGoodsAttributeInfo&spuId=" + spu_id,
                                dataType: "json",//表示后台返回的数据是json对象
                                async: true,
                                success: function (data) {
                                    if (data.success == 1) {
                                        var array = data.result.rs;
                                        if (array.length > 0) {


                                            $("#selectFirst").empty();
                                            $("#selectSecond").empty();


                                            for (var obj in array) {
                                                if (array[obj].position == 1) {
                                                    if (first_attribute_id == array[obj].id) {
                                                        $("#selectFirst").append("<option value='" + array[obj].id + "' selected>" + array[obj].attribute_value + "</option>");
                                                    } else {
                                                        $("#selectFirst").append("<option value='" + array[obj].id + "'>" + array[obj].attribute_value + "</option>");
                                                    }
                                                }
                                                if (array[obj].position == 2) {
                                                    if (second_attribute_id == array[obj].id) {
                                                        $("#selectSecond").append("<option value='" + array[obj].id + "' selected>" + array[obj].attribute_value + "</option>");
                                                    } else {
                                                        $("#selectSecond").append("<option value='" + array[obj].id + "'>" + array[obj].attribute_value + "</option>");
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    //(注意：需要重新渲染)
                                    form.render('select');
                                },
                                error: function (error) {
                                    console.log("error=" + error);
                                }
                            });

                            var member_distribution_id = data.rs[0].member_distribution_id;
                            var outsider_distribution_id = data.rs[0].outsider_distribution_id;


                            var mp = Fen2Yuan(Number(data.rs[0].market_price));
                            var op = Fen2Yuan(Number(data.rs[0].original_price));
                            var T_A = Number(data.rs[0].member_top);
                            $("#T_A").val(T_A);
                            if ((mp > 0) && (op > 0)) {
                                if (T_A >= 0) {
                                    $('#S_A').html(getDistriMoney(mp, op, T_A));
                                } else {
                                    $('#S_A').html("");
                                }
                            }
                            if ((mp > 0) && (op > 0)) {
                                if (T_A >= 0) {
                                    $('#Z_A').val(getDistriMoney(mp, op, T_A));
                                } else {
                                    $('#Z_A').val("");
                                }
                            }
                            var T_B = Number(data.rs[0].member_parent);
                            $("#T_B").val(T_B);
                            if ((mp > 0) && (op > 0)) {
                                if (T_B >= 0) {
                                    $('#S_B').html(getDistriMoney(mp, op, T_B));
                                } else {
                                    $('#S_B').html("");
                                }
                            }
                            if ((mp > 0) && (op > 0)) {
                                if (T_B >= 0) {
                                    $('#Z_B').val(getDistriMoney(mp, op, T_B));
                                } else {
                                    $('#Z_B').val("");
                                }
                            }
                            var T_C = Number(data.rs[0].member_self);
                            $("#T_C").val(T_C);
                            if ((mp > 0) && (op > 0)) {
                                if (T_C >= 0) {
                                    $('#S_C').html(getDistriMoney(mp, op, T_C));
                                } else {
                                    $('#S_C').html("");
                                }
                            }
                            if ((mp > 0) && (op > 0)) {
                                if (T_C >= 0) {
                                    $('#Z_C').val(getDistriMoney(mp, op, T_C));
                                } else {
                                    $('#Z_C').val("");
                                }
                            }
                            var T_D = Number(data.rs[0].outsider_top);
                            $("#T_D").val(T_D);
                            if ((mp > 0) && (op > 0)) {
                                if (T_D >= 0) {
                                    $('#S_D').html(getDistriMoney(mp, op, T_D));
                                } else {
                                    $('#S_D').html("");
                                }
                            }
                            if ((mp > 0) && (op > 0)) {
                                if (T_D >= 0) {
                                    $('#Z_D').val(getDistriMoney(mp, op, T_D));
                                } else {
                                    $('#Z_D').val("");
                                }
                            }
                            var T_E = Number(data.rs[0].outsider_parent);
                            $("#T_E").val(T_E);
                            if ((mp > 0) && (op > 0)) {
                                if (T_E >= 0) {
                                    $('#S_E').html(getDistriMoney(mp, op, T_E));
                                } else {
                                    $('#S_E').html("");
                                }
                            }
                            if ((mp > 0) && (op > 0)) {
                                if (T_E >= 0) {
                                    $('#Z_E').val(getDistriMoney(mp, op, T_E));
                                } else {
                                    $('#Z_E').val("");
                                }
                            }
                            var T_F = Number(data.rs[0].outsider_self);
                            $("#T_F").val(T_F);
                            if ((mp > 0) && (op > 0)) {
                                if (T_F >= 0) {
                                    $('#S_F').html(getDistriMoney(mp, op, T_F));
                                } else {
                                    $('#S_F').html("");
                                }
                            }
                            if ((mp > 0) && (op > 0)) {
                                if (T_F >= 0) {
                                    $('#Z_F').val(getDistriMoney(mp, op, T_F));
                                } else {
                                    $('#Z_F').val("");
                                }
                            }

                            //获取返佣规则
                            $.ajax({
                                type: "get",
                                url: "${ctx}/goods?method=getAllValidDistributionList",
                                dataType: "json",//表示后台返回的数据是json对象
                                async: true,
                                success: function (data) {
                                    if (data.success == 1) {
                                        var array = data.result.rs;

                                        if (array.length > 0) {


                                            $("#selectMemberDistri").empty();
                                            $("#selectOutsiderDistri").empty();

                                            // $("#selectMemberDistri").append("<option value='0'>[填写自定义会员返佣规则]</option>");
                                            // $("#selectOutsiderDistri").append("<option value='0'>[填写自定义非会员返佣规则]</option>");


                                            for (var obj in array) {

                                                if ("1" == array[obj].dis_type) {  //会员
                                                    if (member_distribution_id == array[obj].id) {
                                                        $("#selectMemberDistri").append("<option value='" + array[obj].id + "' selected>" + array[obj].dis_name + "</option>");
                                                    } else {
                                                        $("#selectMemberDistri").append("<option value='" + array[obj].id + "'>" + array[obj].dis_name + "</option>");
                                                    }
                                                }

                                                if ("2" == array[obj].dis_type) {  //非会员
                                                    if (outsider_distribution_id == array[obj].id) {
                                                        $("#selectOutsiderDistri").append("<option value='" + array[obj].id + "' selected>" + array[obj].dis_name + "</option>");
                                                    } else {
                                                        $("#selectOutsiderDistri").append("<option value='" + array[obj].id + "'>" + array[obj].dis_name + "</option>");
                                                    }
                                                }

                                            }
                                        }
                                        //(注意：需要重新渲染)

                                        form.render('select');
                                    }
                                },
                                error: function (error) {
                                    console.log("error=" + error);
                                }
                            });

                            $('#first_attribute_span').html(data.rs[0].first_attribute);
                            $('#second_attribute_span').html(data.rs[0].second_attribute);
                            $('#first_attribute').val(data.rs[0].first_attribute);
                            $('#second_attribute').val(data.rs[0].second_attribute);

                            $('#market_price').val(Fen2Yuan(Number(data.rs[0].market_price)));//人民币单位分转元
                            $('#original_price').val(Fen2Yuan(Number(data.rs[0].original_price)));//人民币单位分转元
                            $('#stock').val(data.rs[0].stock);

                            //时间
                            $('#presell_begintime').val(Utils.FormatDate(data.rs[0].presell_begintime));
                            if (data.rs[0].presell_endtime != '999999999999') {
                                $('#presell_endtime').val(Utils.FormatDate(data.rs[0].presell_endtime));
                            } else {
                                $("#presell_endtime").val('');
                                $("#presell_endtimeDiv").hide();
                                $("#hasPreSaleTimeEnd").attr('checked', true);
                            }


                            $('#distribution_begintime').val(Utils.FormatDate(data.rs[0].distribution_begintime));
                            if (data.rs[0].distribution_endtime != '0') {
                                $('#distribution_endtime').val(Utils.FormatDate(data.rs[0].distribution_endtime));
                            } else {
                                $("#distribution_endtime").val('');
                                $("#distribution_endtimeDiv").hide();
                                $("#hasDistributionTimeEnd").attr('checked', true);
                            }
                            var buyconfine = data.rs[0].buyconfine;

                            if (buyconfine != "0" && buyconfine != "") {
                                $("#buyconfine").attr("checked", true);
                                $("#buyconfine_Num_Div").show();
                                $("#buyconfine_Num").val(buyconfine);
                            } else {
                                $("#buyconfine").attr("checked", false);
                            }
                            //(注意：需要重新渲染)
                            form.render('select');
                            form.render('checkbox');
                        } else {
                            layer.msg("异常");
                        }
                    },
                    error: function () {
                        layer.msg("错误");
                    }
                })

            }
        };

        //点击按钮 保存商品
        form.on('submit(saveBtn)', function (data) {
            console.log("     saveBtn    ");
            $('#sku_status').val("0");
            $('#saveBtn').attr('disabled', "true");

            var btn = document.getElementById('saveBtn');//首先需要获取的是哪一个按钮的id
            btn.disabled = 'disabled';//只要点击就将按钮的可点击的状态更改为不可以点击的状态
            setTimeout(submitData('save'), 60000);//6秒内不可以重复点击，一秒等于1000毫秒

            return false;
        });

        form.on('submit(saveAndAddNewBtn)', function (data) {

            layer.confirm('确定要添加新的规格商品吗 ?', {
                btn: ['添加', '取消']
            }, function (index) {
                layer.close(index);
                $('#saveAndAddNewBtn').removeAttr("disabled");

                submitData('addNew');
                // layer.msg('添加新的规格!',{time:2000}, function(){});
            }, function (index) {
                layer.close(index);
                // window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId="+spu_id+"&goodsSPUName="+spu_name;
            });

            return false;
        });


        //保存而且发布
        // $('#saveAndPublishBtn').on('click', function(){
        //     $('#sku_status').val("1");
        //     $('#buyconfine_Num').val("0");
        //     submitData('publish');
        //     return false;
        // });


        /**
         *
         按钮需求说明：
         【保存/关闭】按钮：
         1.保存当前页面数据，SKU为停售状态，且它的上级SPU状态保持现有状态；

         【保存/添加新规格型】按钮：
         1.保存当前页面的数据，SKU为停售状态，且它的上级SPU状态保持现有状态；
         2.在现有的页面，重新给出新的空数据页，录入数值；

         【发布】按钮：
         1.保存当前页面数据，SKU为起售状态，且它的上级SPU为上架状态，直接发布到线上；
         */

        //提交
        function submitData(method) {
            //校验
            if (validate(method)) {
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods?method=addSKU",
                    //data: "method=addSKU&jsonString="+JSON.stringify($('form').serializeObject()),
                    data: {jsonString: JSON.stringify($('form').serializeObject())},
                    contentType: "application/json",  //缺失会出现URL编码，无法转成json对象
                    cache: false,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data.success == 1) {
                            var id;
                            layer.msg('保存成功!', {time: 1000}, function () {
                                var spu_name = $('#spu_name').val();
                                if (method === 'save') {
                                    window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId=" + spu_id + "&goodsSPUName=" + spu_name;
                                } else if (method === 'addNew') {
                                    while (data.success == 2) {
                                        // 说明此销售规格组合 已经存在
                                        layer.confirm('SKU 规格已重复 请修改销售属性值 ', {
                                            btn: ['返回查看', '取消']
                                        }, function (index) {
                                            layer.close(index);
                                            window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId=" + spu_id + "&goodsSPUName=" + spu_name;
                                        }, function (index) {
                                            layer.close(index);
                                        });
                                        return false;
                                    }
                                    // 可以继续执行
                                    layer.confirm('是否继续添加新的规格!!？', {
                                        btn: ['添加', '取消']
                                    }, function (index) {
                                        layer.close(index);
                                        $('#saveAndAddNewBtn').removeAttr("disabled");
                                        // layer.msg('添加新的规格!',{time:2000}, function(){});
                                        window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_id=" + spu_id + "&&spu_name=" + spu_name;
                                    }, function (index) {
                                        layer.close(index);
                                        window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId=" + spu_id + "&goodsSPUName=" + spu_name;
                                    });

                                } else if (method === 'publish') {

                                    alert(id);
                                    id = data.result.ids[0];

                                    //发布商品f
                                    $.ajax({
                                        type: "get",
                                        async: false, // 同步请求
                                        cache: false,
                                        url: "${ctx}/goods?method=publishGoods&spuId=" + spu_id + "&skuId=" + id,
                                        //data: ids,
                                        dataType: "json",
                                        success: function (data) {
                                            if (data.success) {
                                                //layer.closeAll('loading');
                                                layer.msg('发布成功!', {time: 2000}, function () {
                                                    //do something
                                                    window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId=" + spu_id + "&goodsSPUName=" + spu_name;
                                                });
                                            } else {
                                                layer.msg("异常");
                                            }
                                        },
                                        error: function () {
                                            layer.alert("错误");
                                        }
                                    })
                                }
                            });
                        } else if (data.success == 2) {
                            layer.confirm('SKU 规格已重复 请修改销售属性值 ', {
                                btn: ['返回查看', '取消']
                            }, function (index) {
                                layer.close(index);
                                window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId=" + spu_id + "&goodsSPUName=" + spu_name;
                            }, function (index) {
                                layer.close(index);
                                //   window.location.href = "${ctx}/goods/goodsSKUList.jsp?goodsSPUId="+spu_id+"&goodsSPUName="+spu_name;
                            });
                            // layer.msg(" 对不起 您已经添加过该销售规格组合的SKU商品！ ");
                        } else {
                            layer.msg("异常");
                        }
                    },
                    error: function () {
                        layer.alert("错误");
                    }
                });
            }
        }

        function validate(obj) {
            var sku_name = $("#sku_name").val();

            var market_price = $("#market_price").val();
            var original_price = $("#original_price").val();
            var stock = $("#stock").val();

            var distribution_begintime = $("#distribution_begintime").val();
            var distribution_endtime = $("#distribution_endtime").val();

            var presell_begintime = $("#presell_begintime").val();
            var presell_endtime = $("#presell_endtime").val();

            if (sku_name.length < 2) {
                layer.msg('规格名称至少得2个字符！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }

                $("#sku_name").focus();
                return false;
            }

            var isNum = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
            if (market_price != "") {
                if (!(isNum.test(market_price))) {
                    layer.msg('请输入正确的销售价格！');
                    if (obj == "addNew") {
                        $('#saveAndAddNewBtn').removeAttr("disabled");
                    } else {
                        $('#saveBtn').removeAttr("disabled");
                    }
                    $("#market_price").focus();
                    return false;
                }
            } else {
                layer.msg('请填写销售价格！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#market_price").focus();
                return false;
            }
            if (original_price != "") {
                if (!(isNum.test(original_price))) {
                    $("#original_price").focus();
                    layer.msg('请输入正确的原价/成本价！');
                    if (obj == "addNew") {
                        $('#saveAndAddNewBtn').removeAttr("disabled");
                    } else {
                        $('#saveBtn').removeAttr("disabled");
                    }
                    return false;
                }
            } else {
                layer.msg('请填写原价/成本价！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#original_price").focus();
                return false;
            }
            if (stock != "") {
                if (!(/^\d+$/.test(stock))) {
                    layer.msg('库存数量请输入正整数！');
                    if (obj == "addNew") {
                        $('#saveAndAddNewBtn').removeAttr("disabled");
                    } else {
                        $('#saveBtn').removeAttr("disabled");
                    }
                    $("#stock").focus();
                    return false;
                }
            } else {
                layer.msg('请填写库存数量！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#stock").focus();
                return false;
            }
            // 奖励金存在 则需要验证 是否填写
            var f = $("#bflag").val();
            console.log("   是否是掌小龙来源  " + f);
            if (f == 1) {
                console.log(" 是掌小龙商品 ");
                var bVal = $("#bounty").val();
                // 奖励金必须为数字 整数保留两位小数
                if (!(isNum.test((bVal/1).toFixed(2)))) {
                    //
                    layer.msg(" 请填写正确的奖励金数值 ");
                    $('#saveBtn').removeAttr("disabled");
                    return false;
                }
            } else {
                console.log("  非长大赚商品  ");
            }

            var T_A = $("#T_A").val(), T_B = $("#T_B").val(), T_C = $("#T_C").val();
            var T_D = $("#T_D").val(), T_E = $("#T_E").val(), T_F = $("#T_F").val();

            //^(\d{1,2}|100)$    0-100
            if (!(/^(\d{1,2}|100)$/.test(T_A))) {
                layer.msg('请正确输入自定义会员返佣规则的顶级的返佣比！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_A").focus();
                return false;
            }
            if (!(/^(\d{1,2}|100)$/.test(T_B))) {
                layer.msg('请正确输入自定义会员返佣规则的父级的返佣比！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_B").focus();
                return false;
            }
            if (!(/^(\d{1,2}|100)$/.test(T_C))) {
                layer.msg('请正确输入自定义会员返佣规则的子级的返佣比！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_C").focus();
                return false;
            }
            if (!(/^(\d{1,2}|100)$/.test(T_D))) {
                layer.msg('请正确输入自定义非会员返佣规则的顶级的返佣比！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_D").focus();
                return false;
            }
            if (!(/^(\d{1,2}|100)$/.test(T_E))) {
                layer.msg('请正确输入自定义非会员返佣规则的父级的返佣比！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_E").focus();
                return false;
            }
            if (!(/^(\d{1,2}|100)$/.test(T_F))) {
                layer.msg('请输入正确自定义非会员返佣规则的子级的返佣比！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_F").focus();
                return false;
            }


            if ((Number(T_A) + Number(T_B) + Number(T_C) > 100)) {
                layer.msg('自定义会员返佣规则返佣比总数大于100，请输入输入！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_A").focus();
                return false;
            }

            if ((Number(T_D) + Number(T_E) + Number(T_F) > 100)) {
                layer.msg('自定义非会员返佣规则返佣比总数大于100，请输入输入！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#T_D").focus();
                return false;
            }
            // if(distribution_begintime==""){
            //     layer.msg('请输入自定义返佣规则的开始时间！');
            //     $("#distribution_begintime").focus();
            //     return false;
            // }
            // if(!$('#hasDistributionTimeEnd').is(':checked') && distribution_endtime=="" ) {
            //     layer.msg('请输入自定义返佣规则的结束时间！');
            //     $('#saveBtn').removeAttr("disabled");
            //     $("#distribution_endtime").focus();
            //     return false;
            // }

            if (presell_begintime == "") {
                layer.msg('请输入预售的开始时间！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#presell_begintime").focus();
                return false;
            }
            if (!$('#hasPreSaleTimeEnd').is(':checked') && presell_endtime == "") {
                layer.msg('请输入预售的结束时间！');
                if (obj == "addNew") {
                    $('#saveAndAddNewBtn').removeAttr("disabled");
                } else {
                    $('#saveBtn').removeAttr("disabled");
                }
                $("#presell_endtime").focus();
                return false;
            }

            var first_attribute = $("#first_attribute").val();
            var second_attribute = $("#second_attribute").val();

            if ($('#checkFirst').is(':checked')) {
                if ($("#txtFirst").val().length == 0) {
                    layer.msg('请填写[' + first_attribute + ']的属性值');
                    if (obj == "addNew") {
                        $('#saveAndAddNewBtn').removeAttr("disabled");
                    } else {
                        $('#saveBtn').removeAttr("disabled");
                    }
                    $("#txtFirst").focus();
                    return false;
                }
            } else {
                if ($("#selectFirst").val() == "") {
                    layer.msg('请选择[' + first_attribute + ']的值');
                    if (obj == "addNew") {
                        $('#saveAndAddNewBtn').removeAttr("disabled");
                    } else {
                        $('#saveBtn').removeAttr("disabled");
                    }
                    $("#selectFirst").focus();
                    return false;
                }
            }

            // if($('#checkSecond').is(':checked')) {
            //     if($("#txtSecond").val().length == 0){
            //         layer.msg('请填写['+second_attribute+']的属性值');
            //         if(obj=="addNew"){
            //             $('#saveAndAddNewBtn').removeAttr("disabled");
            //         }else{
            //             $('#saveBtn').removeAttr("disabled");
            //         }
            //         $("#txtSecond").focus();
            //         return false;
            //     }
            // }else{
            //     if($("#selectSecond").val()==""){
            //         layer.msg('请选择['+second_attribute+']的值');
            //         if(obj=="addNew"){
            //             $('#saveAndAddNewBtn').removeAttr("disabled");
            //         }else{
            //             $('#saveBtn').removeAttr("disabled");
            //         }
            //         $("#selectSecond").focus();
            //         return false;
            //     }
            // }
            return true;
        };


        //监听"checkbox"操作
        form.on('checkbox(checkboxFilter)', function (obj) {
            var othis = $(this);
            id = this.value;

            var first = $("#first_attribute").val();
            var second = $("#second_attribute").val();

            if (this.name == 'checkFirst' && obj.elem.checked) {
                $("#txtFirstDiv").show();
                $("#selectFirstDiv").hide();
                $("#checkFirst").val('NEED');
                layer.tips("请填写[" + first + "]的属性值", $("#txtFirstDiv"));
            } else if (this.name == 'checkFirst' && !obj.elem.checked) {
                $("#txtFirstDiv").hide();
                $("#selectFirstDiv").show();
                $("#checkFirst").val('NO');
                layer.tips("请选择[" + first + "]的属性值", $("#selectFirstDiv"));
            } else if (this.name == 'checkSecond' && obj.elem.checked) {
                $("#txtSecondDiv").show();
                $("#selectSecondDiv").hide();
                $("#checkSecond").val('NEED');
                layer.tips("请填写[" + second + "]的属性值", $("#txtSecondDiv"));
            } else if (this.name == 'checkSecond' && !obj.elem.checked) {
                $("#txtSecondDiv").hide();
                $("#selectSecondDiv").show();
                $("#checkSecond").val('NO');
                layer.tips("请选择[" + second + "]的属性值", $("#selectSecondDiv"));
            }

            //处理时间
            else if (this.name == 'hasPreSaleTimeEnd' && obj.elem.checked) {
                $("#presell_endtime").val('');
                $("#presell_endtimeDiv").hide();
                //obj.val('no');
            } else if (this.name == 'hasPreSaleTimeEnd' && !obj.elem.checked) {
                $("#presell_endtimeDiv").show();
                //obj.val('yes');
            } else if (this.name == 'hasDistributionTimeEnd' && obj.elem.checked) {
                $("#distribution_endtime").val('');
                $("#distribution_endtimeDiv").hide();
                //obj.val('no');
            } else if (this.name == 'hasDistributionTimeEnd' && !obj.elem.checked) {
                $("#distribution_endtimeDiv").show();
                //obj.val('yes');
            } else if (this.name == 'hasActiveTimeEnd' && obj.elem.checked) {
                $("#activeTimeEnd").val('');
                $("#activeTimeEndDiv").hide();
                //obj.val('no');
            } else if (this.name == 'hasActiveTimeEnd' && !obj.elem.checked) {
                $("#activeTimeEndDiv").show();
                //obj.val('yes');
            }

            form.render('checkbox');
            form.render('select');
        });

        form.on('checkbox(buyconfineFilter)', function (obj) {
            if (this.name == 'buyconfine' && obj.elem.checked == false) {
                $("#buyconfine_Num_Div").hide();
            } else if (this.name == 'buyconfine' && obj.elem.checked == true) {
                $("#buyconfine_Num_Div").show();
            }
        });

        form.on('select(selFilter)', function (data) {
            var id = data.value;
            console.log("   id   " + id)
            layer.msg('确定要起用该规格型号吗?', {
                skin: 'layui-layer-molv' //样式类名  自定义样式
                , closeBtn: 1    // 是否显示关闭按钮
                , time: 1000000
                , anim: 1 //动画类型
                , btn: ['确定', '删除'] //按钮
                , icon: 6    // icon
                , yes: function () {
                    layer.closeAll();
                }
                , btn2: function () {
                    layer.closeAll();
                    // 确定删除
                    $.ajax({
                        type: "get",
                        url: "${ctx}/goods?method=delGoodsSpuAttribute&id=" + id,
                        // data:{'id':id,'style':'beginSell'} ,
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.closeAll();
                                // table.reload("goodsSKUInfoTab")
                                layer.msg(' 商品SKU规格删除成功 ');
                                window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_id=" + spu_id + "&sku_id=" + sku_id + "&&spu_name=" + spu_name;
                                return false;
                            }
                        },
                        error: function () {
                            layer.msg('  商品SKU规格删除失败  ');
                            return false;
                        }
                    })
                }
            });

        });
    });


    function Fen2Yuan(num) {
        if (typeof num !== "number" || isNaN(num)) return null;
        return (num / 100).toFixed(2);
    }

</script>


<!-- 内容主体区域 -->
<div class="layui-body" style="padding: 15px">
    <div class="layui-elem-quote">
        <span>
                <a>1.选择类型</a>&nbsp;&nbsp;
                <a>2.商品信息</a>&nbsp;&nbsp;
                <a><b>3.<span id="newOrEditSpan">添加</span>商品<span
                        id="spuNameSpan">[<%=spu_name%>]</span>的规格(SKU)</b></a>
        </span>
        <span class="layui-breadcrumb" style="visibility: visible;">
              <a href="./goodsSKUList.jsp?goodsSPUId=<%=spu_id%>&goodsSPUName=<%=spu_name%>" target="_self">[规格管理]</a>
        </span>
        <a class="layui-btn  layui-btn-sm" style="margin-left: 50%" href="./goodsAdd_B.jsp?spu_id=<%=spu_id%>">返回</a>
    </div>
    <form class="layui-form" action="">
        <!-- 存放页面参数 -->
        <input type="hidden" id="spu_name" name="spu_name" value="<%=spu_name%>" lay-verify="required"
               autocomplete="off">
        <input type="hidden" id="first_attribute" name="first_attribute" value="<%=first_attribute%>"
               lay-verify="required" autocomplete="off">
        <%--<input type="hidden" id="second_attribute" name="second_attribute" value="<%=second_attribute%>" lay-verify="required" autocomplete="off">--%>
        <input type="hidden" id="spu_id" name="spu_id" value="<%=spu_id%>" lay-verify="required" autocomplete="off">
        <h3 style="margin-top: 40px;">规格信息 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>规格名称: </label>
            <div class="layui-input-inline">
                <input style="width: 500px;" id="sku_name" name="sku_name" lay-verify="sku_name"
                       placeholder="请与商品名称保持一致"
                       class="layui-input" type="text">

                <input type="hidden" id="sku_id" name="sku_id" value="">

            </div>
        </div>

        <%-- <div class="layui-form-item">
             <label class="layui-form-label" style="width: 150px">编码: </label>
             <div class="layui-input-inline">
                 <input style="width: 500px;" id="sku_code" name="sku_code" lay-verify="sku_code" autocomplete="off" placeholder=""
                        class="layui-input" type="text">
             </div>
         </div>--%>

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px">备注 : </label>
            <div class="layui-input-inline">
                <input style="width: 500px;" id="memo" name="memo" lay-verify="memo" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <h3>销售信息 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>销售价格(￥)</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="market_price" name="market_price" lay-verify="market_price"
                       autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>原价/成本价(￥)</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="original_price" name="original_price" lay-verify="title"
                       autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>库存数量:</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="stock" name="stock" lay-verify="title" autocomplete="off"
                       placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item" id="bountyMoney" style="display:none;">
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>奖励金:</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="bounty" name="bounty" autocomplete="off"
                       placeholder=""
                       class="layui-input" type="text">
                <input type="hidden" value="0" id="bflag" name="bflag">
            </div>
        </div>
        <script type="application/javascript">
            // 查看是否是掌小龙商品 是 则显示奖励金字段填写
            $(document).ready(function () {
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods",
                    data: "method=checkIsBounty&spu_id=" + spu_id,
                    cache: false,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        console.log("   source_code   is   " + data.rs[0].source_code);
                        if (data.rs[0].source_code == 'ZDZ') {
                            // 商品来源是掌小龙 则奖励金必填
                            $("#bflag").val(1);
                            $("#bountyMoney").attr("style", "display:block;");//显示div
                        }
                    },
                    error: function () {
                        console.log("  error ")
                    }
                });

            });
        </script>
        <h3>返佣规则: </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item" style="display: none">
            <div class="layui-inline" id="selectMemberDistriDiv">
                <label class="layui-form-label" style="width: 150px">会员佣金规则: </label>
                <div class="layui-input-inline" style="width: 240px">
                    <select id="selectMemberDistri" name="selectMemberDistri" lay-filter="selFilter"
                            style="width: 240px">

                    </select>
                </div>
            </div>

            <div class="layui-inline" id="selectOutsiderDistriDiv">
                <label class="layui-form-label" style="width: 150px">非会员佣金规则: </label>
                <div class="layui-input-inline" style="width: 240px">
                    <select id="selectOutsiderDistri" name="selectOutsiderDistri" lay-filter="selFilter"
                            style="width: 240px">

                    </select>
                </div>
            </div>
        </div>
        <div id="tableDistributionDiv" class="layui-form-item">
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>自定义会员返佣规则: </label>
            <div class="layui-input-inline" style="width: 350px">
                <table class="layui-table">
                    <colgroup>
                        <col width="30%">
                        <col width="30%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>分销等级</th>
                        <th>返佣比</th>
                        <th>返佣金额</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <div style="float:left">顶级</div>
                        </td>
                        <td>
                            <div style="display:flex;">
                                <input id="T_A" name="T_A" class="layui-input" style="width: 50px;" type="text"
                                       value="">%
                            </div>
                        </td>
                        <td><span id="S_A"></span> <input type="hidden" id="Z_A" name="Z_A" value=""/></td>
                    </tr>
                    <tr>
                        <td>
                            <div style="float:left">父级</div>
                        </td>
                        <td>
                            <div style="display: flex;">
                                <input id="T_B" name="T_B" class="layui-input" style="width: 50px;" type="text"
                                       value="">%
                            </div>
                        </td>
                        <td><span id="S_B" name="S_B"></span><input type="hidden" id="Z_B" name="Z_B" value=""/></td>
                    </tr>
                    <tr>
                        <td>
                            <div style="float:left">子级</div>
                        </td>
                        <td>
                            <div style="display:flex;">
                                <input id="T_C" name="T_C" class="layui-input" style="width: 50px;" type="text"
                                       value="">%
                            </div>
                        </td>
                        <td><span id="S_C" name="S_C"></span><input type="hidden" id="Z_C" name="Z_C" value=""/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>自定义非会员返佣规则: </label>
            <div class="layui-input-inline" style="width: 350px">

                <table class="layui-table">
                    <colgroup>
                        <col width="30%">
                        <col width="30%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>分销等级</th>
                        <th>返佣比</th>
                        <th>返佣金额</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <div style="float:left">顶级</div>
                        </td>
                        <td>
                            <div style="display:flex;">
                                <input id="T_D" name="T_D" class="layui-input" style="width: 50px;" type="text"
                                       value="">%
                            </div>
                        </td>
                        <td><span id="S_D" name="S_D"></span><input type="hidden" id="Z_D" name="Z_D" value=""/></td>
                    </tr>
                    <tr>
                        <td>
                            <div style="float:left">父级</div>
                        </td>
                        <td>
                            <div style="display: flex;">
                                <input id="T_E" name="T_E" class="layui-input" style="width: 50px;" type="text"
                                       value="">%
                            </div>
                        </td>
                        <td><span id="S_E" name="S_E"></span><input type="hidden" id="Z_E" name="Z_E" value=""/></td>
                    </tr>
                    <tr>
                        <td>
                            <div style="float:left">子级</div>
                        </td>
                        <td>
                            <div style="display:flex;">
                                <input id="T_F" name="T_F" class="layui-input" style="width: 50px;" type="text"
                                       value="">%
                            </div>
                        </td>
                        <td><span id="S_F" name="S_F"></span><input type="hidden" id="Z_F" name="Z_F" value=""/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>


        <h3>销售时间:</h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>开始时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="presell_begintime" name="presell_begintime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline" id="presell_endtimeDiv">
                <label class="layui-form-label" style="width: 150px"><label style="color: red">*</label>结束时间:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="presell_endtime" name="presell_endtime"
                           placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                </div>
            </div>
        </div>

        <div class="layui-form-item" pane="">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px">&nbsp;&nbsp;</label>
                <input id="hasPreSaleTimeEnd" name="hasPreSaleTimeEnd" lay-skin="primary" title="预售结束时间不限"
                       type="checkbox" lay-filter="checkboxFilter">
            </div>
        </div>

        <h3>销售属性 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px">
                    <span id="first_attribute_span"><%=first_attribute%></span>:
                </label>
                <div id="selectFirstDiv" class="layui-input-inline layui-form" style="width: 150px;">
                    <select id="selectFirst" name="selectFirst" lay-filter="selFilter" lay-verify="required">
                    </select>
                </div>

                <div id="txtFirstDiv" class="layui-input-inline">
                    <input style="width: 150px;" id="txtFirst" name="txtFirst" lay-verify="title" autocomplete="off"
                           placeholder="" class="layui-input" type="text">
                </div>

                <div id="checkFirstDiv" class="layui-input-inline">
                    <input name="checkFirst" id="checkFirst" lay-skin="primary" value="NEED" checked title="自填值"
                           type="checkbox" lay-filter="checkboxFilter">
                </div>

            </div>
        </div>
        <div class="layui-form-item" id='second_attribute_total'>
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px"><span
                        id="second_attribute_span"><%=second_attribute%></span>:</label>
                <div id="selectSecondDiv" class="layui-input-inline layui-form" style="width: 150px;">
                    <select id="selectSecond" name="selectSecond" lay-filter="selFilter">
                        <%--<option value="">请选择</option>--%>
                    </select>
                </div>
                <div id="txtSecondDiv" class="layui-input-inline">
                    <input style="width: 150px;" id="txtSecond" name="txtSecond" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
                <div id="checkSecondDiv" class="layui-input-inline">
                    <input name="checkSecond" id="checkSecond" lay-skin="primary" value="NEED" checked title="自填值"
                           type="checkbox" lay-filter="checkboxFilter">
                </div>
            </div>
        </div>
        <div class="layui-form-item" pane="">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px">&nbsp;&nbsp;</label>
                <input id="buyconfine" name="buyconfine" lay-skin="primary" title="是否限购数量" type="checkbox"
                       lay-filter="buyconfineFilter">
            </div>
            <div class="layui-inline" id="buyconfine_Num_Div" style="display: none">
                <label class="layui-form-label" style="width: 150px">限购数量:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" id="buyconfine_Num" name="buyconfine_Num" placeholder="" value="1"
                           type="text">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button id="saveBtn" lay-filter="saveBtn" lay-submit="saveBtn" class="layui-btn layui-btn-normal">保存/关闭
                </button>

                <button id="saveAndAddNewBtn" lay-submit="saveAndAddNewBtn" lay-filter="saveAndAddNewBtn"
                        class="layui-btn layui-btn-normal">保存/添加新规格
                </button>

                <%--<button id="saveAndPublishBtn" class="layui-btn layui-btn-normal">发布</button>--%>

                <!-- 起/停售状态 -->
                <input type="hidden" id="sku_status" name="sku_status" value="0" lay-verify="required"
                       autocomplete="off">

            </div>
        </div>
    </form>

<%@ include file="/common/footer.jsp" %>