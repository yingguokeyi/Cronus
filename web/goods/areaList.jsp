<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<%--<link rel="stylesheet" type="text/css" href="${ctx}/common/css/goodsCateSelect.css"/>--%>

<style type="text/css">
    #shengDiv {
        position: absolute;
        left: 50px;
        top: 10px;
        width: 160px;
        height: 341px;
    }
    #diDiv {
        position: absolute;
        left: 300px;
        top: 10px;
        width: 160px;
        height: 341px;
    }
    #xianDiv {
        position: absolute;
        left:600px;
        top: 10px;
        width: 160px;
        height: 341px;
    }

    #goodsTypeDiv{
        position: absolute;
        left: 900px;
        top: 10px;
        width: 160px;
        height: 341px;
    }


    .districtSel {
        position: absolute;
        left: 0px;
        top: 0px;
        width: 160px;
        height: 341px;
        font-family: 'PingFangSC-Thin', 'PingFang SC Thin', 'PingFang SC';
        font-weight: 200;
        font-style: normal;
        font-size: 16px;
        text-decoration: none;
        color: #000000;
    }



    .ax_default {
        font-family: 'PingFangSC-Thin', 'PingFang SC Thin', 'PingFang SC';
        font-weight: 200;
        font-style: normal;
        font-size: 16px;
        line-height: normal;
        color: #000000;
        text-align: left;
    }
</style>




<script>

    //一些全局变量
    var shengName, shengCode, diName, diCode, xianName, xianCode, goodsTypeName, goodsTypeCode;


    layui.use(['layer','element','form'], function () {
        var $ = layui.jquery
            , element = layui.element
            , form = layui.form
            , layer = layui.layer //弹层

        //点击按钮 添加分类
        $('#goNextBtn').on('click', function () {

            // var value = $("#goodsTypeSel option:selected").attr("value");
            // if (value == undefined) {
            //     layer.alert("请选择商品类型");
            //     return false;
            // }
            var str = "shengName=" + topCateName + "&shengCode=" + topCateCode
                + "&diName=" + subCateName + "&diCode=" + subCateCode
                + "&xianName=" + xianName + "&xianCode=" + xianCode
                + "&goodsTypeName=" + goodsTypeName + "&goodsTypeCode=" + goodsTypeCode;
            alert(str);
            //window.location.href = "${ctx}/goods/goodsAdd_B.jsp?" + str;
        });


    });
    // end layui.use


    $(document).ready(function () {
        $.ajax({
            type: "get",
            url: "${ctx}/district?method=getShengList",
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        if (array[obj].code.substr(2, 6) < 1) {
                            $("#shengSel").append("<option value='" + array[obj].code + "'>" + array[obj].name + "</option>")
                        }
                    }
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });

    });


    function shengChange(code) {
        $("select#diSel").empty();
        $("select#xianSel").empty();
        $("select#goodsTypeSel").empty();
        shengCode = code;
        shengName = $("#shengSel").find("option:selected").text();

        $.ajax({
            type: "get",
            url: "${ctx}/district?method=getDiListByPCode&pCode=" + code,
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        $("#diSel").append("<option value='" + array[obj].code + "'>" + array[obj].name + "</option>")
                    }
                    $("select#diSel").show();
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });
    }

    function diChange(code) {
        $("select#xianSel").empty();
        //$("select#goodsTypeSel").empty();
        subCateCode = code;
        diName = $("#diSel").find("option:selected").text();

        $.ajax({
            type: "get",
            url: "${ctx}/district?method=getXianListByPCode&pCode=" + code,
            dataType: "json",//表示后台返回的数据是json对象
            async: true,
            success: function (data) {
                if (data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        $("#xianSel").append("<option value='" + array[obj].code + "'>" + array[obj].name + "</option>")
                    }
                    $("select#xianSel").show();
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });
    }


    function xianChange(code) {
        //$("select#goodsTypeSel").empty();
        xianCode = code;
        xianName = $("#xianSel").find("option:selected").text();


        $.ajax({
            type: "get",
            url: "${ctx}/district?method=getGoodsTypeInfoByPCode&pCateCode=" + code,
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

<script>
    //点击按钮
    $('#addProvince').on('click', function () {
        layer.open({
            type: 1
            , title: '添加省'
            , content: $('#addProvince-box')
            , area: '300px'
            , btn: '确定'
            , btnAlign: 'c' //按钮居中
            , shade: 0 //不显示遮罩
            , yes: function () {
                layer.closeAll();
            }
        });
    });
</script>


<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="detail">添加</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">详情</a>
</script>


<!-- 内容主体区域 -->


<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding: 15px;">

        <div class="layui-elem-quote">
            地区管理
        </div>


        <div style="height: 600px;background-color: #f2f2f2;margin: 0 auto;">
            <div style="width: 1200px;height: 480px;position: relative;left: 100px;top: 25px;background-color: #f2f2f2">

                <div id="shengDiv" class="ax_default">
                    <select id="shengSel" class="districtSel" size="2" tabindex="0" onchange="shengChange(this.value)">
                    </select>
                </div>
                <div id="diDiv" class="ax_default">
                    <select id="diSel" class="districtSel" size="2" tabindex="0" hidden="hidden"
                            onchange="diChange(this.value)">
                    </select>
                </div>
                <div id="xianDiv" class="ax_default">
                    <select id="xianSel" class="districtSel" name="classifyValue" hidden="hidden" autocomplete="off" size="2" tabindex="0">
                    </select>
                </div>

                <!--
                <div id="goodsTypeDiv" class="ax_default">
                    <select id="goodsTypeSel" class="districtSel" name="goodsTypeValue" hidden="hidden"
                          onchange="goodsTypeChange(this.value)"
                            autocomplete="off" size="2" tabindex="0">
                    </select>
                </div>
                -->

            </div>
        </div>



        <!--<button class="layui-btn layui-btn-normal" id="goNextBtn" style="position: relative;left: 740px;top: 30px;">下一步:填写商品信息
      </button>-->

    </div>


    <div id="addProvince-box" style="display: none">
        <div class="layui-inline" style="margin-top: 15px">
            <label class="layui-form-label">省名称</label>
            <div class="layui-input-inline">
                <input name="email" lay-verify="required" autocomplete="off" class="layui-input" type="text">
            </div>
        </div>
    </div>


<%@ include file="/common/footer.jsp" %>
