<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/header.jsp" %>
<%@include file="/recommen/menu_recommen.jsp" %>
<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>
<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

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
    var linkSourceMap = new Map();
    layui.use(['form', 'laydate', 'upload', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate //日期
            , layer = layui.layer //弹层
            , table = layui.table //表格
            , upload = layui.upload
            , element = layui.element; //元素操作
        var form = layui.form;

        //日期时间选择器
        laydate.render({
            elem: '#start_usefultime'
            , type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#end_usefultime'
            , type: 'datetime'
        });
        // 商品推荐编辑使用
        laydate.render({
            elem: '#begintime'
            , type: 'datetime'
        });
        laydate.render({
            elem: '#endtime'
            , type: 'datetime'
        });

        //列表加载
        table.render({
            elem: '#columnList'
            , url: '${ctx}/recommen?method=getColumnList'
            , limit: 100
            , limits: [50, 100, 500, 1000]
            , height: 690
            , cols: [[
                {field: 'cposition', width: 120, title: '栏目位置', align: 'center'}
                , {
                    field: 'cstatus', width: 120, title: '栏目状态', align: 'center', templet: function (d) {
                        switch (d.cstatus) {
                            case "1":
                                return "<font color='00CC00'>正常</font>";
                            case "0":
                                return "<font color='red'>禁用</font>";
                            default:
                                return "状态未表明";
                        }
                    }
                }
                , {
                    field: 'cname', width: 150, title: '栏目名称', align: 'center', templet: function (d) {
                        return d.cname;
                    }
                }
                , {
                    field: 'cpicture', width: 150, title: '栏目图片', align: 'center', templet: function (d) {
                        return d.cpicture;
                    }
                }
                , {field: 'shape_size', width: 100, title: '图片尺寸', align: 'center'}
                , {
                    field: 'column_lid', width: 150, title: '栏目外链接', align: 'center', templet: function (d) {
                        if (d.column_lid == "") {
                            return "无连接"
                        } else {
                            return d.column_lid;
                        }
                    }
                }
                , {
                    field: 'cproduct_link_flag', width: 150, title: '商品链接', align: 'center', templet: function (d) {
                        if (d.cproduct_link_flag == "1") {
                            return "开"
                        } else {
                            return "关";
                        }
                    }
                }
                , {
                    field: 'column_limits_products',
                    width: 200,
                    title: '栏目商品数量',
                    align: 'center',
                    templet: function (d) {
                        return d.columnProductSum + "/" + d.column_limits_products;
                    }
                }
                , {
                    field: 'start_usefultime', width: 170, title: '投放开始时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.start_usefultime == "") {
                            index = "----";
                        } else {
                            index = "20" + d.start_usefultime.substr(0, 2) + "-" + d.start_usefultime.substr(2, 2) + "-" + d.start_usefultime.substr(4, 2) + " " + d.start_usefultime.substr(6, 2) + ":" + d.start_usefultime.substr(8, 2) + ":" + d.start_usefultime.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {
                    field: 'end_usefultime', width: 170, title: '投放结束时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.end_usefultime == "999999999999") {
                            index = "投放截止时间未设置";
                        } else {
                            index = "20" + d.end_usefultime.substr(0, 2) + "-" + d.end_usefultime.substr(2, 2) + "-" + d.end_usefultime.substr(4, 2) + " " + d.end_usefultime.substr(6, 2) + ":" + d.end_usefultime.substr(8, 2) + ":" + d.end_usefultime.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {
                    field: 'last_usefultime', width: 170, title: '投放剩余时间', align: 'center', templet: function (d) {
                        var index = "";
                        if (d.last_usefultime == "") {
                            index = "----";
                        } else {
                            index = "20" + d.last_usefultime.substr(0, 2) + "-" + d.last_usefultime.substr(2, 2) + "-" + d.last_usefultime.substr(4, 2) + " " + d.last_usefultime.substr(6, 2) + ":" + d.last_usefultime.substr(8, 2) + ":" + d.last_usefultime.substr(10, 2);
                        }
                        return index;
                    }
                }
                , {field: 'column_useful_area', width: 100, title: '投放地区', align: 'center'}
                , {
                    field: 'clicks', width: 100, title: '点击量', align: 'center', templet: function (d) {
                        return d.clicks + "次";
                    }
                }
                , {field: 'successful_pay', width: 180, title: '成功支付订单量', align: 'center'}
                , {field: 'turnVolume', width: 100, title: '成交额', align: 'center'}
                , {field: 'edit_time', width: 170, title: '最后操作时间', align: 'center', templet: '#create_timeTpl'}
                , {field: 'edit_user', width: 100, title: '操作人', align: 'center'}

                , {fixed: 'right', title: '操作', width: 450, align: 'center', toolbar: "#recommenColumnStatusManage"}
            ]]
            , page: true//关闭自动分页
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , id: 'ColumnListInfoReload'
        });

        table.on('tool(columnListFilter)', function (obj) {
            if (obj.event === 'recommenColumnStatus') {
                var columnStatus = obj.data.cstatus;
                if (columnStatus == 1) {
                    // 说明此栏目开启中 询问是否关闭
                    layer.msg('确定要关闭该栏目吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        , closeBtn: 1    // 是否显示关闭按钮
                        , anim: 1 //动画类型
                        , btn: ['确定', '取消'] //按钮
                        , icon: 5    // icon
                        , yes: function () {
                            console.log();
                            obj.update({
                                cid: obj.data.cid
                            });
                            setTimeout(sendMsg(obj, obj.data.cid, 0), 60000);//60秒内不可以重复点击，一秒等于1000毫秒
                            //   table.reload("columnList");
                        }
                        , btn2: function () {
                            layer.closeAll();
                        }
                    });
                }
                else {
                    // 说明栏目是关闭状态 准备开启
                    layer.msg('确定要开启该栏目吗?', {
                        skin: 'layui-layer-molv' //样式类名  自定义样式
                        , closeBtn: 1    // 是否显示关闭按钮
                        , anim: 1 //动画类型
                        , btn: ['确定', '取消'] //按钮
                        , icon: 6    // icon
                        , yes: function () {
                            setTimeout(sendMsg(obj, obj.data.cid, 1), 60000);//60秒内不可以重复点击，一秒等于1000毫秒
                            //    table.reload("columnList");
                        }
                        , btn2: function () {
                            layer.closeAll();
                        }
                    });
                }
            }

            if (obj.event === 'edit') {
                console.log("   obj   " + obj.data.cid);
                var title = "<h3>修改【" + obj.data.cname + "】栏目的信息</h3>";
                columnListIndex = layer.open({  // 打开
                    type: 1
                    , title: title
                    , offset: 'auto'
                    , id: 'addPlanOpen'
                    //,area: ['800px', '550px']
                    , area: ['80%', '90%']
                    , content: $('#updateColumnListDiv')
                    //,btn: '关闭'
                    , btnAlign: 'c' // 按钮居中
                    , shade: 0 // 遮罩
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调

                    }
                });

                // 拉取数据
                selectColumnLinkInfo(obj.data.cid);
                return false;
            }

            if (obj.event === 'setting') {
                console.log("   obj   " + obj.data.cid);
                var columnId = obj.data.cid;
                if (columnId == 1) {
                    // 栏目ID
                    window.location.href = "${ctx}/recommen/seckill_product.jsp?columnId=" + columnId;
                } else if (columnId == 2) {
                    window.location.href = "${ctx}/recommen/normal_product.jsp?columnId=" + columnId;
                }

            }
        });

        // 栏目外链接
        function getLinksList() {
            //获取商品来源
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${ctx}/recommen",
                data: "method=getLinksList",
                dataType: "json",
                success: function (data) {
                    var array = data.rs;
                    if (array.length > 0) {
                        for (var obj in array) {
                            $("#columnLinkId").append("<option value='" + array[obj].id + "'>" + array[obj].column_link + "</option>");
                            linkSourceMap.put(array[obj].id, array[obj].column_link);
                        }
                    }
                },
                error: function () {
                    layer.msg("错误");
                }
            });
            form.render('select');
        }

        // 更新栏目状态
        function sendMsg(obj, cid, cstatus) {
            $.ajax({
                type: "get",
                url: "${ctx}/recommen?method=updateColumnStatus",
                data: {"cid": cid, "cstatus": cstatus},   //status=2 移入回收站
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('栏目状态变更成功!', {time: 2000}, function () {
                            //do something
                            console.log("  successful columnList   ");
                            table.reload("columnList");
                            window.location.href = "${ctx}/recommen/column_lists.jsp";
                        });
                    } else {
                        layer.msg("  变更状态失败  ");
                    }
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }

            });

        }

        //监听"checkbox"操作
        form.on('checkbox(checkboxFilter)', function (obj) {
            //处理时间
            if (this.name == 'hasPreTimeEnd' && obj.elem.checked) {
                $("#endtime").val('');
                $("#endtimeDiv").hide();
                //obj.val('no');
            } else if (this.name == 'hasPreTimeEnd' && !obj.elem.checked) {
                $("#endtimeDiv").show();
                //obj.val('yes');
            }
            form.render('checkbox');
            form.render('select');
        });


        // 栏目外链接-开
        form.on('checkbox(linkStartFilter)', function (obj) {
            if (this.name == 'linkStart' && obj.elem.checked) {
                $("#chooseColumnLinkDIV").show();
                // 商品链接 与栏目外链接二者互斥 必须有一个开启
                $("#linkf").html("<font color='red'>已开启</font>");
                $("#columnLinkIdFlag").val("1");
            } else {
                $("#chooseColumnLinkDIV").hide();
                $("#linkf").html("<font color='blue'>已关闭</font>");
                $("#columnLinkIdFlag").val("0");
            }
        });
        // 商品链接
        form.on('checkbox(productStartFilter)', function (obj) {
            if (this.name == 'productStart' && obj.elem.checked) {
                $("#productLinkFlag").val(1);
                $("#prof").html("<font color='red'>已开启</font>");
                // 商品链接开启
            } else {
                $("#productLinkFlag").val(0);
                $("#prof").html("<font color='blue'>已关闭</font>");
            }
        });


        var $ = layui.jquery
            , upload = layui.upload;

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

        // 编辑栏目链接库查看信息
        function selectColumnLinkInfo(id) {
            var clink = document.getElementById("columnLinkId");
            clink.options.length = 0;

            // 加载栏目外链接
            getLinksList();

            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: false,// 不使用ajax缓存
                url: "${ctx}/recommen?method=selectColumuLinkInfo&id=" + id,
                dataType: "json",//表示后台返回的数据是json对象
                async: true,
                success: function (data) {
                    $("#_cid").val(data.rs[0].cid);
                    $("#_cname").val(data.rs[0].cname);
                    // 时间显示
                    $('#begintime').val(Utils.FormatDate(data.rs[0].start_usefultime));
                    if (data.rs[0].end_usefultime != '999999999999') {
                        $('#endtime').val(Utils.FormatDate(data.rs[0].end_usefultime));
                    } else {
                        $("#endtime").val('');
                        $("#endtimeDiv").hide();
                        $("#hasPreTimeEnd").attr('checked', true);
                    }
                    // 上传图片预览地址
                    $('#demo1').attr('src', data.rs[0].imgPath);
                    $("#showImgIds").val(data.rs[0].imgid);
                    console.log("  data.rs[0].column_link  " + data.rs[0].column_link);
                    // 栏目外链接
                    var columnLinkId = data.rs[0].column_lid;
                    if (columnLinkId && (linkSourceMap.size() > 0)) {
                        $("#columnLinkId").empty();
                        linkSourceMap.each(function (value, key) {
                            console.log(" key " + key + " value " + value);
                            if (value == columnLinkId) {
                                $("#columnLinkId").append("<option value='" + value + "' selected>" + value + " " + key + " " + "</option>");
                            } else {
                                $("#columnLinkId").append("<option value='" + value + "'>" + value + " " + key + "" + "</option>");
                            }
                        });

                        $("#columnLinkIdFlag").val("1");

                    } else {
                        $("#columnLinkIdFlag").val("0");

                    }

                    if (data.rs[0].column_lid != "0") {
                        $("#linkStart").attr("checked", true);
                        $("#chooseColumnLinkDIV").show();
                        // 商品链接 与栏目外链接
                        $("#linkf").html("<font color='red'>已开启</font>");
                        // $("#linkNames").html(data.rs[0].column_link);
                    } else {
                        $("#linkStart").attr("checked", false);
                        $("#chooseColumnLinkDIV").hide();
                        $("#linkf").html("<font color='blue'>已关闭</font>");
                    }
                    form.render("select");

                    if (data.rs[0].cproduct_link_flag == 1) {
                        // 商品链接
                        $("#productLinkFlag").val(1);
                        $("#productStart").attr("checked", true);
                    } else {
                        $("#productLinkFlag").val(0);
                        $("#prof").html("<font color='blue'>已关闭</font>");
                    }

                    //(注意：需要重新渲染)
                    form.render('select');
                    form.render('checkbox');

                },
                error: function () {
                    layer.msg('栏目链接查询失败');
                }
            })
        }

        $("#saveColumnLinkBtn").on('click', function () {
            console.log("   saveColumnLinkBtn   ");
            var cid = $("#_cid").val();
            var cname = $("#_cname").val();
            if (cname == '') {
                layer.msg("  栏目名称不能为空  ");
                return false;
            }

            var begintime = $("#begintime").val();
            var endtime = $("#endtime").val();

            if (begintime == '') {
                layer.msg(" 开始时间不能为空  ");
                return false;
            } else if (!$('#hasPreTimeEnd').is(':checked') && endtime == "") {
                layer.msg(" 结束时间不能为空  ");
                return false;
            }

            var showImgIds = $("#showImgIds").val();
            // if (showImgIds == '') {
            //     layer.msg(" 上传图片不能为空  ");
            //     return false;
            // }
            var columnLinkIdFlag = $("#columnLinkIdFlag").val();
            var columnLid = "0";
            if (columnLinkIdFlag == "1") {
                columnLid = $("#columnLinkId").val();
            }

            var productLinkFlag = $("#productLinkFlag").val();

            updateColumnInfo(cid, cname, begintime, endtime, showImgIds, columnLid, productLinkFlag)

            // 刷新过快
        });

        //取消
        $("#cannelBtn").on('click', function () {
            layer.close(columnListIndex);
            return false;
        });

        function updateColumnInfo(cid, cname, begintime, endtime, showImgIds, columnLid, productLinkFlag) {
            $.ajax({
                type: "get",
                url: "${ctx}/recommen?method=updateColumnInfo",
                data: {
                    "cid": cid,
                    "cname": cname,
                    "startTime": begintime,
                    "endTime": endtime,
                    "imgId": showImgIds,
                    "columnLid": columnLid,
                    "cproductLinkFlag": productLinkFlag
                },
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    console.log("  success  " + data);
                    layer.msg(' 栏目信息更新成功 ', {time: 5 * 1000}, function () {
                        layer.close(columnListIndex);
                    })
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }

            });
        }
    });

</script>

<script id="create_timeTpl" type="text/html">
    {{#  if(d.edit_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.edit_time.substr(0,2) }}-{{ d.edit_time.substr(2,2) }}-{{ d.edit_time.substr(4,2) }} {{ d.edit_time.substr(6,2) }}:{{ d.edit_time.substr(8,2) }}:{{ d.edit_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>
<style>
    .column-lists-btn-start{
        background-color: #00CC00;
    }
    .column-lists-btn-end{
        background-color: #999999;
    }
</style>
<script type="text/html" id="recommenColumnStatusManage">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="setting">设置商品列表</a>
    &nbsp;&nbsp;&nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">&nbsp;&nbsp;编辑&nbsp;&nbsp;</a>
    &nbsp;&nbsp;&nbsp;
    {{#  if(d.cstatus == 1){ }}
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
    <a class="layui-btn layui-btn-xs column-lists-btn-start layui-btn-radius">&nbsp;&nbsp;开启中&nbsp;&nbsp;</a>
        <%--<i class="start" ><font color="red">开启中</font></i></a>--%>
    <!-- style="opacity: 0.2"-->
    &nbsp;
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="recommenColumnStatus">&nbsp;&nbsp;&nbsp;禁用&nbsp;&nbsp;&nbsp;&nbsp;</a>
    {{#  } else if(d.cstatus == 0) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="recommenColumnStatus">&nbsp;&nbsp;&nbsp;开启&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
    &nbsp;
    <a class="layui-btn layui-btn-xs column-lists-btn-end layui-btn-radius">&nbsp;&nbsp;禁用中&nbsp;&nbsp;</a>
    <%--<a href="javascript:return false;" onclick="return false;" style="cursor: default;">--%>
        <%--<i class="end" ><font color="blue">禁用中</font></i></a>--%>
    <%--<a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">去处理</a>--%>
    <%--<a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" style="color: gray">去处理</a>--%>
    <%----%>
    {{#  } }}
</script>

<div class="layui-body">
    <div id="updateColumnListDiv" style="display: none;">

        <form id="messageForm" class="layui-form" style="padding: 15px;">
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px">栏目名称</label>
                    <div class="layui-input-inline">
                        <input id="_cname" name="_cname" autocomplete="off" placeholder="" class="layui-input"
                               type="text">
                        <input id="_cid" name="_cid" type="hidden">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>开始时间:</label>
                    <div class="layui-input-inline">
                        <input class="layui-input" id="begintime" name="begintime"
                               placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline" id="endtimeDiv">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>结束时间:</label>
                    <div class="layui-input-inline">
                        <input class="layui-input" id="endtime" name="endtime"
                               placeholder="yyyy-MM-dd HH:mm:ss" type="text">
                    </div>
                </div>
            </div>
            <div class="layui-form-item" pane="">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px">&nbsp;&nbsp;</label>
                    <input id="hasPreTimeEnd" name="hasPreTimeEnd" lay-skin="primary" title="时间不限"
                           type="checkbox" lay-filter="checkboxFilter">
                </div>
            </div>

            <h4>上传图片:</h4>
            <hr class="layui-bg-blue">
            <div class="layui-upload" style="margin-left: 150px;">
                <div class="layui-upload-list">
                    <img class="layui-upload-img" id="demo1">
                    <p id="demoText"></p>
                </div>
                <input type="hidden" id="showImgIds" name="showImgIds" value="" lay-verify="required"
                       autocomplete="off">
                <button type="button" class="layui-btn" id="test1">选择图片</button>
                <button type="button" class="layui-btn" id="dele" onclick="deleteFun()">删除</button>
                <script type="application/javascript">
                    function deleteFun() {
                        $("#showImgIds").val("");
                        $('#demo1').attr('src', "");
                    }
                </script>
            </div>

            <h4>栏目外链接设置:<p id="linkf"></p></h4>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <label class="layui-form-label" style="width: 150px"><label style="color: #ff3025">*</label>栏目外链接:
                </label>

                <div class="layui-input-inline layui-form" id="chooseColumnLinkDIV">
                    <select id="columnLinkId" name="columnLinkId" lay-filter="colFilter">
                        <option value="">请选择</option>
                    </select>
                </div>

            </div>

            <div class="layui-inline" style="margin-left: 150px;">
                <input id="linkStart" name="linkStart" lay-skin="primary" title="开"
                       type="checkbox" lay-filter="linkStartFilter">
                <input type="hidden" id="columnLinkIdFlag" name="columnLinkIdFlag">
                <%--<input id="linkEnd" name="linkEnd" lay-skin="primary" title="关"
                   type="checkbox" lay-filter="linkEndFilter">--%>
                <div class="layui-inline style=" display:none;">
                <span id="linkNames"></span>
            </div>


        </form>
    </div>
    <!-- -->
    <h4>商品链接:<p id="prof"></p></h4>
    <hr class="layui-bg-blue">
    <div class="layui-inline" style="margin-left: 150px;margin-top: 10px;">
        <input id="productStart" name="productStart" lay-skin="primary" title="开"
               type="checkbox" lay-filter="productStartFilter">
        <input type="hidden" id="productLinkFlag" name="productLinkFlag">
        <div class="layui-form-item" style="margin-top: 20px;margin-left: 80px;">
            <div class="layui-input-block" align="center">
                <button class="layui-btn" id="saveColumnLinkBtn" lay-submit="" lay-filter="saveColumnLinkBtn">
                    保存
                </button>
                <button class="layui-btn" id="cannelBtn" lay-filter="cannelBtn">
                    取消
                </button>
            </div>
        </div>
    </div>
    </form>
</div>

<div style="padding:5px 5px 0px 5px" style="display: none;">
    <div class="layui-elem-quote">栏目列表</div>
    <%--  <form class="layui-form layui-form-pane">
          <div style="background-color: #f2f2f2;padding:5px 0">
              <div class="layui-form-item" style="margin-bottom:5px">
                  <label class="layui-form-label">栏目名称</label>
                  <div class="layui-input-inline" style="width: 150px">
                      <input class="layui-input" autocomplete="off" name="cname" id="cname">
                  </div>

                  <label class="layui-form-label">状态</label>
                  <div class="layui-input-inline" style="width: 150px">
                      <select id="cstatus" name="cstatus">
                          <option value=""></option>
                          <option value="1">正常</option>
                          <option value="0">停用</option>
                      </select>
                  </div>

                  <label class="layui-form-label">商品销售量</label>
                  <div class="layui-input-inline">
                      <select id="sales" name="sales">
                          <option value=""></option>
                          <option value="1">正序</option>
                          <option value="0">倒叙</option>
                      </select>
                  </div>

                  <label class="layui-form-label">投放时间</label>
                  <div class="layui-input-inline" style="width: 150px">
                      <input name="start_usefultime" id="start_usefultime" placeholder="开始日期" autocomplete="off"
                             class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                  </div>
                  <div class="layui-form-mid">-</div>
                  <div class="layui-input-inline" style="width: 150px">
                      <input name="end_usefultime" id="end_usefultime" placeholder="结束日期" autocomplete="off"
                             class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                  </div>
                  <div class="layui-input-inline" style="width: 200px">
                      <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="sreach"><i
                              class="layui-icon">&#xe615;</i>搜索
                      </button>
                      <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="reset"><i class="layui-icon">&#x2746;</i>重置
                      </button>
                  </div>
              </div>
          </div>
      </form>--%>
    <table class="layui-hide" id="columnList" lay-filter="columnListFilter"></table>
</div>
</div>

<div class="layui-footer">
    <%@ include file="/common/footer.jsp" %>
</div>






