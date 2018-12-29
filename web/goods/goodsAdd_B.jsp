<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>
<%@ page import="common.PropertiesConf" %>
<link rel="stylesheet" type="text/css" href="${ctx}/common/css/goodsCateSelect.css"/>

<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>

<%
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
    System.out.println(imgUrlPrefix);
    String topCateName = request.getParameter("topCateName");
    String topCateCode = request.getParameter("topCateCode");
    String subCateName = request.getParameter("subCateName");
    String subCateCode = request.getParameter("subCateCode");
    String minCateName = request.getParameter("minCateName");
    String minCateCode = request.getParameter("minCateCode");
    String goodsTypeCode = request.getParameter("goodsTypeCode");
    String spu_id = request.getParameter("spu_id");
    String goodsTypeName = request.getParameter("goodsTypeName");
%>

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
    var imgUrlPrefix = "<%=imgUrlPrefix%>";
    var spu_id = <%=spu_id%>;
    var goodsTypeName = "<%=goodsTypeName%>";
    var minCateCode = <%=minCateCode%>;
    var goodsTypeCode = <%=goodsTypeCode%>;
    var isSuccess_Upload = 1;//是否有图片上传失败
    var count = 1;
    //图片参数
    var showImgIds = "";
    var showImgCount = 0;
    var detailImgIds = "";
    var detailImgCount = 0;
    var goodsSourceMap = new Map();
    var brandMap = new Map();
    layui.use(['upload', 'element', 'form'], function () {
        var $ = layui.jquery
            , upload = layui.upload
            , element = layui.element;
        var form = layui.form;

        function onLoadData() {
            if (spu_id) {
                $('#topCateNameLabel').html("");
                $('#subCateNameLabel').html("");
                $('#minCateNameLabel').html("");
                $('#goodsTypeNameLabel').html("");
            }
            //获取准备数据
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/goods",
                data: "method=prepareDataForSpuHandle",
                dataType: "json",
                success: function (data) {
                    if (data.result == 'success') {
                        //获取商品来源
                        var array = data.goodsSourceList;
                        if (array.length > 0) {

                            for (var obj in array) {
                                console.log(1)
                                $("#source_code").append("<option value='" + array[obj].goodsSource_Code + "'>" + array[obj].goodsSource_Name + " [" + array[obj].goodsSource_Code + "]" + "</option>");
                                goodsSourceMap.put(array[obj].goodsSource_Code, array[obj].goodsSource_Name);
                            }
                        }
                        //商品品牌
                        var brandList = data.brandList;
                        if (brandList.length > 0) {
                            for (var obj in brandList) {
                                $("#brand_id").append("<option value='" + brandList[obj].id + "'>" + brandList[obj].brand_name + "</option>");
                                brandMap.put(brandList[obj].id, brandList[obj].brand_name);
                            }
                        }
                        //(注意：需要重新渲染)
                        form.render('select');
                    } else {
                        layer.msg("异常3333");
                    }
                },
                error: function () {
                    layer.msg("错误brand");
                }
            });

            if (spu_id) {
                $("#newOrEditSpan").html("修改");
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/goods",
                    data: "method=getSPUInfo&spu_id=" + spu_id,
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            //layer.msg("查询成功");
                            var spu_code = data.rs[0].spu_code;
                            var spu_name = data.rs[0].spu_name;
                            var source_code = data.rs[0].source_code;
                            console.log("    source_code    " + source_code)
                            var brand_id = data.rs[0].brand_id;
                            //加载商品来源
                            if (source_code && (goodsSourceMap.size() > 0)) {
                                $("#source_code").empty();
                                goodsSourceMap.each(function (value, key) {
                                    console.log(" key "+key + " value "+value);
                                    if (value == source_code) {
                                        $("#source_code").append("<option value='" + value + "' selected>" + value + " [" + key + "]" + "</option>");
                                    } else {
                                        $("#source_code").append("<option value='" + value + "'>" + value + " [" + key + "]" + "</option>");
                                    }
                                });


                            }
                            //加载商品品牌
                            if (brand_id && (brandMap.size() > 0)) {
                                $("#brand_id").empty();
                                $("#brand_id").append("<option value=''>请选择</option>");
                                brandMap.each(function (value, key) {
                                    if (key == brand_id) {
                                        $("#brand_id").append("<option value='" + key + "' selected>" + value + "</option>");
                                    } else {
                                        $("#brand_id").append("<option value='" + key + "'>" + value + "</option>");
                                    }
                                });
                            }
                            $('#spu_id').val(data.rs[0].id);
                            $('#spu_code').val(spu_code);
                            $('#spu_name').val(spu_name);
                            var goods_url = data.rs[0].goods_url.split(',');

                            $('#goods_url_hidden').val(data.rs[0].goods_url);
                            if (goods_url.length == 1) {
                                $('#goods_url').val(data.rs[0].goods_url);
                            } else {
                                for (var i = 0; i < goods_url.length; i++) {
                                    $('#goods_url').val(goods_url[0]);
                                    if (i > 0) {
                                        count += 1;
                                        $("#goods_url_div").append('<div class="layui-form-item" id="add_goods_url_div' + count + '"><label class="layui-form-label">商品链接: </label><div class="layui-input-block"><input style="width: 500px;display: inline-block;" id="goods_url" name="goods_url" lay-verify="goods_url" value="' + goods_url[i] + '" autocomplete="off" placeholder=""\n' +
                                            'class="layui-input" type="text">' +
                                            '<label style="width: 100px; color: red" class="layui-icon" id="del_goods_url" onclick="del_goods_url(' + count + ')">&#xe640;</label></div>')
                                    }
                                }
                            }
                            $('#detail').val(data.rs[0].detail);
                            $('#first_attribute').val(data.rs[0].first_attribute);
                            $('#second_attribute').val(data.rs[0].second_attribute);
                            $('#sort').val(data.rs[0].sort);
                            $('#memo').val(data.rs[0].memo);
                            $('#distribution').val(data.rs[0].distribution);

                            $('#topCateNameLabel').html(data.rs[0].topCateName + ">");
                            $('#subCateNameLabel').html(data.rs[0].subCateName + ">");
                            $('#minCateNameLabel').html(data.rs[0].minCateName);
                            $('#goodsTypeNameLabel').html(data.rs[0].goodTypeName);
                            minCateCode = data.rs[0].minCateCode;
                            goodsTypeCode = data.rs[0].goods_type_id;
                            var show_img_ids = "";
                            var detail_img_ids = "";
                            if (data.rs[0].show_img_ids != "") {
                                show_img_ids = data.rs[0].show_img_ids.split(',');
                                $("#showImgIds").val(data.rs[0].show_img_ids);
                            }
                            if (data.rs[0].detail_img_ids != "") {
                                detail_img_ids = data.rs[0].detail_img_ids.split(',');
                                $("#detailImgIds").val(data.rs[0].detail_img_ids);
                            }
                            if (data.rs[0].http_path != "") {
                                var http_path = data.rs[0].http_path.split(',');
                                for (var obj in http_path, show_img_ids) {
                                    $('#showUploadDiv').append('<div id="divShowImg' + obj + '" style="height: 220px;width: 200px;margin-left: 30px"><img src="' + http_path[obj] + '" alt="' + data.rs[0].image_name +
                                        '" class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px" id="showImg' + obj +
                                        '" name="showImg' + obj + '"><p style="width:20px;height: 20px" onclick="showImgClick(' + obj + "," + show_img_ids[obj] + ')" id="showImgP' + obj + 'id' + show_img_ids[obj] + '"><img src="${ctx}/image/delete.png" style="height: 10px;width: 10px;margin-left: 30px"/></p></div>');
                                }
                            } else {
                                var image_path = data.rs[0].image_path.split(',');
                                for (var obj in image_path, show_img_ids) {

                                    $('#showUploadDiv').append('<div id="divShowImg' + obj + '" style="height: 220px;width: 200px;margin-left: 30px"><img src="' + image_path[obj] + '" alt="' + image_path[obj] +
                                        '" class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px" id="showImg' + obj +
                                        '" name="showImg' + obj + '"><p style="width:20px;height: 20px" onclick="showImgClick(' + obj + "," + show_img_ids[obj] + ')" id="showImgP' + obj + 'id' + show_img_ids[obj] + '"><img src="${ctx}/image/delete.png" style="height: 10px;width: 10px;margin-left: 30px"/></p></div>');
                                }
                            }
                            var detail_image_path = data.rs[0].detail_image_path.split(',');
                            for (var obj in detail_image_path, detail_img_ids) {

                                $('#detailUploadDiv').append('<div id="divShowImg' + obj + '" style="height: 200px;width: 300px;margin-left: 30px"><img src="' + detail_image_path[obj] + '" alt="' + detail_image_path[obj] +
                                    '" class="layui-upload-img" style="height: 200px;width: 200px;margin-left: 30px" id="showImg' + obj +
                                    '" name="showImg' + obj + '"><p style="width:20px;height: 20px" onclick="showImgClick(' + obj + "," + detail_img_ids[obj] + ')" id="showImgP' + obj + 'id' + detail_img_ids[obj] + '"><img src="${ctx}/image/delete.png" style="height: 10px;width: 10px;margin-left: 30px"/></p></div>');
                            }
                            //加载图片
                            // onLoadImgs(data.rs[0].show_img_ids,"showImg");
                            // onLoadImgs(data.rs[0].detail_img_ids,"detailImg");
                            form.render('select');
                            //table.reload("listTable")
                        } else {
                            layer.msg("异常");
                        }
                    },
                    error: function () {
                        layer.alert("错误main");
                    }
                })
            }

        };

        onLoadData();

        function onLoadImgs(ids, type) {
            if (ids) {
                var arr = ids.split(',');
                //var that = this;
                for (var i = 0; i < arr.length; i++) {
                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/upload",
                        data: "method=getIMGInfo&id=" + arr[i],
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                if (data.rs[0]) {
                                    if (type === "showImg") {
                                        showImgCount++;
                                        $('#showUploadDiv').append('<div id="divShowImg' + showImgCount + '"><img src="' + data.rs[0].image_path + '" alt="' + data.rs[0].image_name +
                                            '" class="layui-upload-img" id="showImg' + showImgCount +
                                            '" name="showImg' + showImgCount + '"><p style="width:20px" onclick="showImgClick(' + showImgCount + "," + arr[i] + ')" id="showImgP' + showImgCount + 'id' + arr[i] + '"><img src="${ctx}/image/delete.png" /></p></div>');
                                    } else if (type === "detailImg") {
                                        detailImgCount++;
                                        $('#detailUploadDiv').append('<div id="divDetailImg' + detailImgCount + '"><img src="' + data.rs[0].image_path + '" alt="' + data.rs[0].image_name +
                                            '" class="layui-upload-img" id="detailImg' + detailImgCount +
                                            '" name="detailImg' + detailImgCount + '"><p style="width:20px" onclick="detailImgClick(' + detailImgCount + "," + arr[i] + ')" id="detailImgP' + detailImgCount + 'id' + arr[i] + '"><img src="${ctx}/image/delete.png" /></p></div>');
                                    }
                                }
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误img");
                        }
                    })
                }
                if (type === "showImg") {
                    $('#showImgIds').val(ids);
                    showImgIds = ids + ",";
                } else if (type === "detailImg") {
                    $('#detailImgIds').val(ids);
                    detailImgIds = ids + ",";
                }
            }
        };
        var arry = new Array();
        var arry1 = new Array();
        //普通图片上传 show
        var uploadShowInst = upload.render({
            elem: '#showUpload',
            url: '${ctx}/upload?method=uploadGoodsImg&uploadType=loadShowImg&minCateCode=<%=minCateCode%>&goodsTypeCode=<%=goodsTypeCode%>'
            ,
            before: function (obj) {
                obj.preview(function (index, file, result) {
                    console.log("    obj.preview   ");
                    //$('#showUploadDiv').empty();
                    showImgCount++;
                    for (var i = 0; i < arry.length; i++) {
                        if (arry[i].indexOf(file.name) > -1) {
                            layer.msg('不能重复添加同一张图片！');
                            return;
                        }
                    }
                    arry.push(file.name);
                    if (showImgCount > 15) {
                        layer.msg('添加的图片不能大于15张！');
                        return;
                    }
                    var ss = "#showImg" + showImgCount;
                    $('#showUploadDiv').append('<div id="divShowImg' + showImgCount + '"><img src="' + result + '" alt="' + file.name +
                        '" class="layui-upload-img" id="showImg' + showImgCount +
                        '" name="showImg' + showImgCount + '">');
                });
            }
            ,
            done: function (res) {
                //上传完毕
                if (res.success) {
                    //上传成功
                    //layer.msg('上传成功');
                    var imgId = res.result.ids[0];
                    var idsTemp = $('#showImgIds').val();
                    // if(idsTemp.length > 0){
                    showImgIds = showImgIds + imgId + ",";
                    // }else{
                    //     showImgIds = imgId+",";
                    // }

                    if (showImgIds != "") {
                        $('#showImgIds').val(showImgIds.substring(0, showImgIds.length - 1));
                    }
                    $('#divShowImg' + showImgCount).append('<p style="width:20px" onclick="showImgClick(' + showImgCount + "," + imgId + ')" id="showImgP' + showImgCount + 'id' + imgId + '"><img src="${ctx}/image/delete.png" /></p>');
                    //var p = "showImgP"+showImgCount;
                } else {
                    //如果上传失败
                    layer.msg("异常");
                }
            }
            ,
            error: function () {
                //演示失败状态，并实现重传
                // var p = "showImgP"+showImgCount;
                // var showImgPText = $("'#"+p+"'");
                // showImgPText.html('<span style="color: #FF5722;">上传失败</span><a class="layui-btn layui-btn-mini showImg-reload">重试</a>');
                // showImgPText.find('.showImg-reload').on('click', function(){
                //     uploadShowInst.upload();
                // });

                layer.msg('浏览器兼容问题 请清除缓存 重新上传!   ');
                isSuccess_Upload = 0;
            }
        });
        //普通图片上传 detail
        var uploadDetailInst = upload.render({
            elem: '#detailUpload'
            ,
            url: '${ctx}/upload?method=uploadGoodsImg&uploadType=loadDetailImg&minCateCode=<%=minCateCode%>&goodsTypeCode=<%=goodsTypeCode%>'
            ,
            before: function (obj) {
                obj.preview(function (index, file, result) {
                    //$('#showUploadDiv').empty();
                    detailImgCount++;
                    for (var i = 0; i < arry1.length; i++) {
                        if (arry1[i].indexOf(file.name) > -1) {
                            layer.msg('不能重复添加同一张图片！');
                            return;
                        }
                    }
                    arry1.push(file.name);
                    if (detailImgCount > 15) {
                        layer.msg('添加的图片不能大于15张！');
                        return;
                    }
                    var ss = "#detailImg" + detailImgCount;
                    $('#detailUploadDiv').append('<div id="divDetailImg' + detailImgCount + '"><img src="' + result + '" alt="' + file.name +
                        '" class="layui-upload-img" id="detailImg' + detailImgCount +
                        '" name="detailImg' + detailImgCount + '">');


                    // '"><a class="layui-btn layui-btn-sm showImg-delete" onclick="deleteShowImg("'+ss+'")>删除</a></p></div>');


                    // $('#showUploadDiv').find('.showImg-delete').on('click', function(){
                    //     alert("功能待开发!"+"showImg"+showImgCount);
                    //     var ss = "#showImg"+showImgCount;
                    //     var sp = "#showImgP"+showImgCount;
                    //     alert($('+ss+'));
                    //     alert($('+sp+').html());
                    // });

                });
            }
            ,
            done: function (res) {
                //上传完毕
                if (res.success) {
                    //上传成功
                    //layer.msg('上传成功');
                    var imgId = res.result.ids[0];
                    var idsTemp = $('#detailImgIds').val();
                    // if(idsTemp.length > 0){
                    detailImgIds = detailImgIds + imgId + ",";
                    // }else{
                    //     detailImgIds = imgId+",";
                    // }
                    if (detailImgIds != "") {
                        $('#detailImgIds').val(detailImgIds.substring(0, detailImgIds.length - 1));
                    }
                    $('#divDetailImg' + detailImgCount).append('<p style="width:20px" onclick="detailImgClick(' + detailImgCount + "," + imgId + ')" id="detailImgP' + detailImgCount + 'id' + imgId + '"><img src="${ctx}/image/delete.png" /></p>');

                    //var p = "detailImgP"+detailImgCount;

                } else {
                    //如果上传失败
                    layer.msg("异常");
                }
            }
            ,
            error: function () {
                //演示失败状态，并实现重传
                // var p = "detailImgP"+detailImgCount;
                // var detailImgPText = $("'#"+p+"'");
                // detailImgPText.html('<span style="color: #FF5722;">上传失败</span><a class="layui-btn layui-btn-mini detailImg-reload">重试</a>');
                // detailImgPText.find('.detailImg-reload').on('click', function(){
                //     uploadDetailInst.upload();
                // });

                layer.msg('上传失败!');
                isSuccess_Upload = 0;
            }
        });


        //点击按钮 保存商品
        $('#saveSPU').on('click', function () {
            if (spu_id) {
                var btn = document.getElementById('saveSPU');//首先需要获取的是哪一个按钮的id
                btn.disabled = 'disabled';//只要点击就将按钮的可点击的状态更改为不可以点击的状态
                setTimeout(submitData('saveSPU', btn), 60000);//6秒内不可以重复点击，一秒等于1000毫秒
                // submitData('saveSPU');
            } else {
                var btn = document.getElementById('addSPU');//首先需要获取的是哪一个按钮的id
                btn.disabled = 'disabled';//只要点击就将按钮的可点击的状态更改为不可以点击的状态
                setTimeout(submitData('addSPU', btn), 60000);//6秒内不可以重复点击，一秒等于1000毫秒
                // submitData('addSPU');
            }
            return false;
        });


        //保存然后去添加规格
        $('#saveAndToSKU').on('click', function () {
            if (spu_id) {
                var btn = document.getElementById('saveAndToSKU');//首先需要获取的是哪一个按钮的id
                btn.disabled = 'disabled';//只要点击就将按钮的可点击的状态更改为不可以点击的状态
                setTimeout(submitData('saveAndToSKU', btn), 60000);//6秒内不可以重复点击，一秒等于1000毫秒
            } else {
                var btn = document.getElementById('saveAndToSKU');//首先需要获取的是哪一个按钮的id
                btn.disabled = 'disabled';//只要点击就将按钮的可点击的状态更改为不可以点击的状态
                setTimeout(submitData('addAndToSKU', btn), 60000);//6秒内不可以重复点击，一秒等于1000毫秒
            }
            return false;
        });
        // var count=1;
        $("#add_goods_url").on('click', function () {
            count += 1;
            $("#goods_url_div").append('<div class="layui-form-item" id="add_goods_url_div' + count + '"><label class="layui-form-label">商品链接: </label><div class="layui-input-block"><input style="width: 500px;display: inline-block;" onblur="add_goods_url_hidden(' + count + ')" id="goods_url' + count + '" name="goods_url' + count + '" lay-verify="goods_url" autocomplete="off" placeholder=""\n' +
                'class="layui-input" type="text">' +
                '<label style="width: 100px; color: red" class="layui-icon"   id="del_goods_url" onclick="del_goods_url(' + count + ')">&#xe640;</label></div>')
            // alert($("[name='goods_url']").val())

            //alert($("#goods_url_hidden").val());
            // alert(111)
        });

        //普通图片上传
        var uploadInst = upload.render({
            elem: '#test1'
            , url: '${ctx}/upload?method=uploadGoodsImg&uploadType=loadRecommonImg'
            , size: 1024 //限制文件大小，单位 KB
            , before: function (obj) {
                //预读本地文件示例，不支持ie8
                obj.preview(function (index, file, result) {
                    $('#demo1').attr('src', result); //图片链接（base64）
                });
            }
            , done: function (res) {
                //如果上传失败
                if (res.code > 0) {
                    return layer.msg('上传失败');
                }
                //上传成功
                var imgId = res.result.ids[0];
                // if(idsTemp.length > 0){
                console.log(" showImgIds " + showImgIds + " imgId  " + imgId);
                showImgIds = imgId + ",";
                // }else{
                //     showImgIds = imgId+",";
                // }

                if (showImgIds != "") {
                    $('#showImgIds').val(showImgIds.substring(0, showImgIds.length - 1));
                }
            }
            , error: function () {
                //演示失败状态，并实现重传
                var demoText = $('#demoText');
                demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
                demoText.find('.demo-reload').on('click', function () {
                    uploadInst.upload();
                });
            }
        })
    });

    function del_goods_url(count) {
        $("#add_goods_url_div" + count).remove();
    }

    function add_goods_url_hidden(count) {
        if (count > 1) {
            var value = $("#goods_url" + count).val();
            var hidden_data = $("#goods_url_hidden").val();
            hidden_data += ',' + value;
            $("#goods_url_hidden").val(hidden_data);
        } else {
            $("#goods_url_hidden").val($("#goods_url").val());
        }
        // alert($("#goods_url_hidden").val())

    };


    // function deleteShowImg(showImgId){
    //     // var sp = "#showImgP"+showImgCount;
    //     // alert($('+ss+'));
    //     alert(showImgId);
    //     alert($('+showImgId+').html());
    // }


    //提交
    function submitData(urltype, btn) {

        var first_attribute = $("#first_attribute").val();
        var second_attribute = $("#second_attribute").val();
        var spu_name = $("#spu_name").val();


        //校验
        if (validate(btn)) {

            $.ajax({
                type: "get",
                url: "${ctx}/goods?method=addSPU",
                //data: "method=addSPU&jsonString="+JSON.stringify($('form').serializeObject()),
                data: {jsonString: JSON.stringify($('form').serializeObject())},
                contentType: "application/json",  //缺失会出现URL编码，无法转成json对象
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    var id;
                    if (data.success) {
                        layer.msg('成功保存商品!', {time: 2000}, function () {


                            if (urltype === 'addSPU') {
                                id = data.result.ids[0];
                                window.location.href = "${ctx}/goods/goodsList.jsp?spu_name=" + spu_name + "&first_attribute="
                                    + first_attribute + "&second_attribute=" + second_attribute + "&spu_id=" + id;
                            } else if (urltype === 'saveSPU') {
                                window.location.href = "${ctx}/goods/goodsList.jsp?spu_name=" + spu_name + "&first_attribute="
                                    + first_attribute + "&second_attribute=" + second_attribute + "&spu_id=" + spu_id;
                            } else if (urltype === 'addAndToSKU') {
                                id = data.result.ids[0];
                                window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_name=" + spu_name + "&first_attribute="
                                    + first_attribute + "&second_attribute=" + second_attribute + "&spu_id=" + id;
                            } else if (urltype === 'saveAndToSKU') {
                                window.location.href = "${ctx}/goods/goodsAdd_C.jsp?spu_name=" + spu_name + "&first_attribute="
                                    + first_attribute + "&second_attribute=" + second_attribute + "&spu_id=" + spu_id;
                            }


                        });
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function (error) {
                    if (error.responseText != "") {
                        layer.msg(error.responseText);
                        btn.disabled = '';
                        return false;
                    } else {
                        btn.disabled = '';
                        layer.closeAll();
                        layer.msg('添加失败');
                        return false;
                    }
                }
            });
        }
        //return false;
    }


    //字段验证
    function validate(btn) {
        var spu_name = $("#spu_name").val();
        var first_attribute = $("#first_attribute").val();
        var second_attribute = $("#second_attribute").val();
        var sort = $("#sort").val();

        if (!isSuccess_Upload) {
            layer.msg('有图片上传失败，请联系开发人员！');
            btn.disabled = '';
            return false;
        }


        if (spu_name.length < 2) {
            layer.msg('商品名称至少得2个字符！');
            $("#spu_name").focus();
            btn.disabled = '';
            return false;
        } else if (spu_name.length > 32) {
            layer.msg('商品名称不得大于32个字符！');
            $("#spu_name").focus();
            btn.disabled = '';
            return false;
        }


        if ($("#source_code").val() == "") {
            layer.msg('请选择商品来源');
            btn.disabled = '';
            return false;
        }

        // if($("#brand_id").val()==""){
        //     layer.msg('请选择商品品牌');
        //     return false;
        // }

        if (Utils.GetLength($("#detail").val()) > 2000) {
            layer.msg('商品属性输入过长！已大于2000个字符(一个汉字折算2个字符)');
            $("#detail").focus();
            btn.disabled = '';
            return false;
        }


        if (!(/^\d+$/.test(sort)) && sort != "") {
            layer.msg('序号请输入正整数！');
            $("#sort").focus();
            btn.disabled = '';
            return false;
        }
        return true;
    }

    function showImgClick(index, imgId) {
        //删除图片的时候有，删除图片还没有保存的情况下，中途打断导致spu图片地址帐脏数据
        var divShowImg = $('#divShowImg' + index);
        layer.confirm('确认删除?', function (indexConfirm) {
            layer.close(indexConfirm);
            var showImgIds = $('#showImgIds').val() + ",";
            var idTemp = imgId + ",";
            var idsStr = showImgIds.replace(idTemp, "");
            $('#showImgIds').val(idsStr.substr(0, idsStr.length - 1));
            divShowImg.remove();
        });
    }

    function detailImgClick(index, imgId) {
        //删除图片的时候有，删除图片还没有保存的情况下，中途打断导致spu图片地址帐脏数据
        var divDetailImg = $('#divDetailImg' + index);
        layer.confirm('确认删除?', function (indexConfirm) {
            layer.close(indexConfirm);
            layer.msg('删除成功');
            var detailImgIds = $('#detailImgIds').val() + ",";
            var idTemp = imgId + ",";
            var idsStr = detailImgIds.replace(idTemp, "");
            $('#detailImgIds').val(idsStr.substr(0, idsStr.length - 1));
            divDetailImg.remove();
        });
    }

    function checkSPUNameISNOExist(spu_name) {
        $.ajax({
            type: "get",
            async: false, // 同步请求
            cache: false,// 不使用ajax缓存
            contentType: "application/json",
            url: "${ctx}/goods",
            data: "method=checkSPUNameISNOExist&spu_name=" + spu_name,
            dataType: "json",
            success: function (data) {

                if (data.rs[0].spu_num != 0) {
                    $("#spuName_error").text("已存在");
                }
            },
            error: function () {
                layer.alert("错误spu");
            }
        });
        return false;
    }

</script>


<!-- 内容主体区域 -->
<div class="layui-body" style="padding: 15px">

    <div class="layui-elem-quote">
            <span>
                <a>1.选择类型</a>&nbsp;&nbsp;
                <a><b>2.<span id="newOrEditSpan">添加</span>商品信息</b></a>&nbsp;&nbsp;
                <a>3.添加规格</a>
            </span>

        <span class="layui-breadcrumb" style="visibility: visible;">
            您选择的商品分类：<label id="topCateNameLabel"><%=topCateName%></label>
            <label id="subCateNameLabel"><%=subCateName%></label>
            <label id="minCateNameLabel"><%=minCateName%></label>
        </span>
        <button class="layui-btn  layui-btn-sm" style="margin-left: 50%" onclick="history.go(-1)">返回</button>
    </div>

    <div style="padding: 15px;display:none;" id="menus">

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

        <div align="center" style="margin-top: 5px;">
            <button class="layui-btn" id="goNextBtn">
                确认商品类型
            </button>
        </div>
        <!--onclick="window.location.href='goodsAdd_B.jsp'"-->

    </div>

    <form enctype="multipart/form-data">
        <%--<form>--%>

        <h3>商品属性 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <label class="layui-form-label">类型 : </label>
            <div class="layui-input-block">
                <label class="layui-btn layui-btn-primary" id="goodsTypeNameLabel"
                       onclick="changeGoodsTypeNameId()"><%=goodsTypeName%>
                </label>
                <!-- 存放 分类和类型 id-->
                <input type="hidden" id="spu_id" name="spu_id" value="" lay-verify="required">
                <input type="hidden" id="goodsTypeCode" name="goodsTypeCode" value="<%=goodsTypeCode%>"
                       lay-verify="required">
                <input type="hidden" id="minCateCode" name="minCateCode" value="<%=minCateCode%>" lay-verify="required">
            </div>
        </div>
        <input type="hidden" value="1" id="standard">
        <script type="application/javascript">
            function changeGoodsTypeNameId() {
                var standard = $("#standard").val();
                if (standard == 1) {
                    $("#standard").val(2);
                    $('#menus').show();
                } else {
                    $("#standard").val(1);
                    $('#menus').hide();
                }

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
            }

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

            // 商品类型 商品分类改变
            function goodsTypeChange(code) {
                goodsTypeCode = code;
                goodsTypeName = $("#goodsTypeSel").find("option:selected").text();  //获取Select选择的Text
                console.log("    minCateSel    " + $("#minCateSel").val())
                $("#minCateCode").val($("#minCateSel").val());
                // alert(goodsTypeCode+goodsTypeName);

            }

            //点击按钮 添加分类
            $('#goNextBtn').on('click', function () {

                var value = $("#goodsTypeSel option:selected").attr("value");
                if (value == undefined) {
                    layer.alert("请选择商品类型");
                    return false;
                }
                $('#goodsTypeNameLabel').html($("#goodsTypeSel").find("option:selected").text());
                $("#goodsTypeCode").val(goodsTypeCode);
            });
        </script>
        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">*</label>属性名称1: </label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="first_attribute" name="first_attribute" lay-verify="attribute"
                       autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">&nbsp;</label>属性名称2: </label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="second_attribute" name="second_attribute" lay-verify="attribute"
                       autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        <!--
        <div class="layui-form-item">
            <label class="layui-form-label">属性名称3(可选)：</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="third_attribute" name="third_attribute" lay-verify="title1" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        -->

        <h3>基本信息 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">*</label>商品名称：</label>
            <div class="layui-input-block" style="width: 70%;">
                <input style="width: 500px;display: inline-block;" id="spu_name" name="spu_name" lay-verify="spu_name"
                       autocomplete="off" placeholder="请输入0-32个汉字"
                       class="layui-input" type="text" onblur="checkSPUNameISNOExist(this.value);">&nbsp;&nbsp;&nbsp;
                <label id="spuName_error" style="width: 100px; color: #FF0000;"></label>
            </div>

        </div>
        <%--<div class="layui-form-item">
            <label class="layui-form-label">商品编码：</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="spu_code" name="spu_code" lay-verify="spu_code" autocomplete="off" placeholder="请填写商品编码"
                       class="layui-input" type="text">
            </div>
        </div>--%>
        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">*</label>商品来源: </label>
            <div class="layui-input-inline layui-form">
                <select id="source_code" name="source_code" lay-filter="selFilter">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">商品品牌: </label>
            <div class="layui-input-inline layui-form">
                <select id="brand_id" name="brand_id" lay-filter="selFilter">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item" id="goods_url_div">
            <label class="layui-form-label">商品链接: </label>
            <div class="layui-input-block">
                <input style="width: 500px;display: inline-block;" id="goods_url" name="goods_url"
                       lay-verify="goods_url" autocomplete="off" placeholder=""
                       class="layui-input" type="text" onblur="add_goods_url_hidden(0)">
                <input type="hidden" id="goods_url_hidden" name="goods_url_hidden" lay-verify="required" type="text">
                <label style="width: 100px; color: red" class="layui-icon" id="add_goods_url">&#xe654;</label>
            </div>
        </div>
            <div class="layui-form-item" id="">
                <label class="layui-form-label"><font color="red">*</font>配送说明</label>
                <div class="layui-input-block">
                    <input style="width: 500px;display: inline-block;" id="distribution" name="distribution"
                           lay-verify="goods_url" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>
<script type="application/javascript">
    (function ($) {
        $.fn.limitTextarea = function (opts) {
            var defaults = {
                maxNumber: 60, //允许输入的最大字数
                position: 'top', //提示文字的位置，top：文本框上方，bottom：文本框下方
                onOk: function () { }, //输入后，字数未超出时调用的函数
                onOver: function () {
                    $('#distribution').disabled;
                } //输入后，字数超出时调用的函数
            }
            var option = $.extend(defaults, opts);
            this.each(function () {
                var _this = $(this);
                var info = '<div id="info' + option.maxNumber + '">还可以输入<b>' + (option.maxNumber - getByteLen(_this.val())) + '</b>字符</div>';
                var fn = function () {
                    var $info = $('#info' + option.maxNumber + '');
                    var extraNumber = option.maxNumber - getByteLen(_this.val());

                    if (extraNumber >= 0) {
                        $info.html('还可以输入<b>' + extraNumber + '</b>个字符');
                        option.onOk();
                    } else {
                        $info.html('还可以输入<b>0</b>个字符');
                        option.onOver();
                    }
                };
                switch (option.position) {
                    case 'top':
                        _this.before(info);
                        break;
                    case 'bottom':
                    default:
                        _this.after(info);
                }
                //绑定输入事件监听器
                if (window.addEventListener) { //先执行W3C
                    _this.get(0).addEventListener("input", fn, false);
                } else {
                    _this.get(0).attachEvent("onpropertychange", fn);
                }
                if (window.VBArray && window.addEventListener) { //IE9
                    _this.get(0).addEventListener("onkeydown", function () {
                        var key = window.event.keyCode;
                        (key == 8 || key == 46) && fn(); //处理回退与删除
                    });
                    _this.get(0).addEventListener("oncut", fn); //处理粘贴
                }
            });
        }


    })(jQuery)

    this.getByteLen= function(val) {
        var len = 0;
        for (var i = 0; i < val.length; i++) {
            if (val[i].match(/[^\x00-\xff]/ig) != null) //全角
                len += 2;
            else
                len += 1;
        }
        return len;
    }

    function getByteVal(val, max) {
        var returnValue = '';
        var byteValLen = 0;
        for (var i = 0; i < val.length; i++) {
            if (val[i].match(/[^\x00-\xff]/ig) != null)
                byteValLen += 2;
            else
                byteValLen += 1;
            if (byteValLen > max)
                break;
            returnValue += val[i];
        }
        return returnValue;
    }

    $('#distribution').limitTextarea({
        maxNumber: 60, //最大字数
        position: 'bottom', //提示文字的位置，top：文本框上方，bottom：文本框下方
        onOk: function () {
            $('#distribution').css('background-color', 'white');
        }, //输入后，字数未超出时调用的函数
        onOver: function () {
            var value = $('#distribution').val();

            $('#distribution').val(getByteVal(value, 60));
            $('#distribution').disabled;
        }
    });
</script>
        <!--


        <div class="layui-form-item">
            <label class="layui-form-label">供应商：</label>
            <div class="layui-input-block">
                <input style="width: 500px;" name="title" lay-verify="title" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>


        <div class="layui-form-item">
            <label class="layui-form-label">产地：</label>
            <div class="layui-input-block">
                <input style="width: 500px;" name="district_id" lay-verify="title1" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>
        1-->

        <h3>图片和详细说明 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label"><label style="color: red">*</label>商品属性：</label>
            <div class="layui-input-block">
                <textarea id="detail" name="detail" style="width: 100%;height: 200px" placeholder="一行只能填写一条商品参数"
                          class="layui-textarea"></textarea>
            </div>
        </div>
        <label class="layui-form-label"><label style="color: red">*</label>轮播图：</label>
        <div class="layui-upload" style="margin-left: 110px;">
            <button type="button" class="layui-btn" id="showUpload">
                上传轮播/主图
            </button>
            <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                预览图：
                <input type="hidden" id="showImgIds" name="showImgIds" value="" lay-verify="required"
                       autocomplete="off">
                <div class="layui-upload-list" id="showUploadDiv"></div>
            </blockquote>
        </div>
        <label class="layui-form-label"><label style="color: red">*</label>详细图：</label>
        <div class="layui-upload" style="margin-left: 110px;">
            <button type="button" class="layui-btn" id="detailUpload">
                上传详细图片
            </button>
            <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                预览图：
                <input type="hidden" id="detailImgIds" name="detailImgIds" value="" lay-verify="required"
                       autocomplete="off">
                <div class="layui-list" id="detailUploadDiv"></div>
            </blockquote>
        </div>


        <h3>其他信息 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <label class="layui-form-label">排序号：</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="sort" name="sort" lay-verify="sort" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">商品备注：</label>
            <div class="layui-input-block">
                <input style="width: 500px;" id="memo" name="memo" lay-verify="title1" autocomplete="off" placeholder=""
                       class="layui-input" type="text">
            </div>
        </div>

        <!--
        <h3>SEO信息 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-form-item">
            <label class="layui-form-label">META Keywords</label>
            <div class="layui-input-block">
                <input style="width: 500px;" name="title" lay-verify="title" autocomplete="off"
                       placeholder="关键词之间请用 , 隔开" class="layui-input" type="text">
            </div>
        </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">META Description</label>
            <div class="layui-input-block">
                <textarea style="width: 500px;" placeholder="请输入内容" class="layui-textarea"></textarea>
            </div>
        </div>
        -->

        <div class="layui-form-item">
            <div class="layui-input-block">

                <%--<button id="saveSPU" class="layui-btn layui-btn-normal">保存</button>--%>
                <button id="saveAndToSKU" class="layui-btn layui-btn-normal">保存/添加规格</button>
            </div>
        </div>
    </form>

<%@ include file="/common/footer.jsp" %>