<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>


<link rel="stylesheet" type="text/css" href="${ctx}/common/css/goodsCateSelect.css"/>
<script>

    //一些全局变量
    var topCateName, topCateCode, subCateName, subCateCode, minCateName, minCateCode, goodsTypeName, goodsTypeCode;

    layui.use(['layer','element','form'], function () {
        var $ = layui.jquery
            , element = layui.element
            , form = layui.form
            , layer = layui.layer //弹层

        //点击按钮 添加分类
        $('#goNextBtn').on('click', function () {

            var value = $("#goodsTypeSel option:selected").attr("value");
            if (value == undefined) {
                layer.alert("请选择商品类型");
                return false;
            }
            var str = "topCateName=" + topCateName + "&topCateCode=" + topCateCode
                + "&subCateName=" + subCateName + "&subCateCode=" + subCateCode
                + "&minCateName=" + minCateName + "&minCateCode=" + minCateCode
                + "&goodsTypeName=" + goodsTypeName + "&goodsTypeCode=" + goodsTypeCode;
            //alert(str);
            window.location.href = "${ctx}/goods/goodsAdd_B.jsp?" + str;
        });


    });
    // end layui.use


    // var subCateMap = new Map();
    // var minCateMap = new Map();
    var dict_data_value = "";
    var id = "";
    $(document).ready(function () {
        $.ajax({
            type: "get",
            url: "${ctx}/goodsCategory?method=getTopCateInfo",
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        if (array[obj].dict_data_value.substr(3, 9) < 1) {

                            $("#topCateSel").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + "</option>")

                        }
                    }
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });

        // var url = location.search;
        // var theRequest = new Object();
        // if ( url.indexOf( "?" ) != -1 ) {
        //     var str = url.substr( 1 ); //substr()方法返回从参数值开始到结束的字符串；
        //     var strs = str.split( "&" );
        //     for ( var i = 0; i < strs.length; i++ ) {
        //         theRequest[ strs[ i ].split( "=" )[ 0 ] ] = ( strs[ i ].split( "=" )[ 1 ] );
        //     }
        //     $('#goodsStyleName').val(theRequest.styleName);
        //     dict_data_value=theRequest.dict_data_value;
        //     id=theRequest.ids;
        //     $('#id').val(theRequest.ids);
        // }
    });


    function topCateChange(code) {
        $("select#subCateSel").empty();
        $("select#minCateSel").empty();
        $("select#goodsTypeSel").empty();
        topCateCode = code;
        topCateName = $("#topCateSel").find("option:selected").text();

        $.ajax({
            type: "get",
            url: "${ctx}/goodsCategory?method=getSubCateInfoByPCode&pCateCode=" + code,
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        $("#subCateSel").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + "</option>")
                    }
                    $("select#subCateSel").show();
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });
    }

    function subCateChange(code) {
        $("select#minCateSel").empty();
        $("select#goodsTypeSel").empty();
        subCateCode = code;
        subCateName = $("#subCateSel").find("option:selected").text();

        $.ajax({
            type: "get",
            url: "${ctx}/goodsCategory?method=getMinCateInfoByPCode&pCateCode=" + code,
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        $("#minCateSel").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + "</option>")
                    }
                    $("select#minCateSel").show();
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });
    }


    function minCateChange(code) {
        $("select#goodsTypeSel").empty();
        minCateCode = code;
        minCateName = $("#minCateSel").find("option:selected").text();


        $.ajax({
            type: "get",
            url: "${ctx}/goodsCategory?method=getGoodsTypeInfoByPCode&pCateCode=" + code,
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        $("#goodsTypeSel").append("<option value='" + array[obj].dict_data_value + "'>" + array[obj].dict_data_name + "</option>")
                    }
                    $("select#goodsTypeSel").show();
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });
    }


    function goodsTypeChange(code) {
        goodsTypeCode = code;
        goodsTypeName = $("#goodsTypeSel").find("option:selected").text();  //获取Select选择的Text
        //alert(goodsTypeCode+goodsTypeName);

    }

</script>


<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding: 15px;">

        <div class="layui-elem-quote">

            <span>
                <a><b>1.选择类型</b></a>&nbsp;&nbsp;
                <a>2.填写商品信息</a>&nbsp;&nbsp;
                <a>3.添加规格</a>
            </span>

        </div>


        <!--  这里的搜索功能以后做
        <div class="layui-form-item" style="width: 650px;margin:40px auto;">
            <label class="layui-form-label">查找类型</label>
            <div class="layui-input-block">
                <input style="width: 400px;" name="title" lay-verify="title" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
                <input type="hidden" name="id" id="id">
            </div>
            <button class="layui-btn layui-btn-normal" style="position: relative;left: 520px;bottom: 37px;">搜索</button>
        </div>
        -->

        <div style="height: 400px;background-color: #f2f2f2;margin: 0 auto;">
            <div style="width: 1200px;height: 350px;position: relative;left: 100px;top: 25px;background-color: #f2f2f2">

                <div id="topCateDiv" class="ax_default">
                    <select id="topCateSel" class="cateSel" size="2" tabindex="0" onchange="topCateChange(this.value)">
                    </select>
                </div>

                <div id="subCateDiv" class="ax_default">
                    <select id="subCateSel" class="cateSel" size="2" tabindex="0" hidden="hidden"
                            onchange="subCateChange(this.value)">
                    </select>
                </div>

                <div id="minCateDiv" class="ax_default">
                    <select id="minCateSel" class="cateSel" name="classifyValue" hidden="hidden"
                            onchange="minCateChange(this.value)" autocomplete="off" size="2" tabindex="0">
                    </select>
                </div>

                <div id="goodsTypeDiv" class="ax_default">
                    <select id="goodsTypeSel" class="cateSel" name="goodsTypeValue" hidden="hidden"
                            onchange="goodsTypeChange(this.value)" autocomplete="off" size="2" tabindex="0">
                    </select>
                </div>

            </div>
        </div>

        <div align="center"  style="margin-top: 5px;">
            <button class="layui-btn" id="goNextBtn"  >下一步:
                填写商品信息
            </button>
        </div>
        <!--onclick="window.location.href='goodsAdd_B.jsp'"-->

    </div>


<%@ include file="/common/footer.jsp" %>