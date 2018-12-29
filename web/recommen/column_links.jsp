<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@include file="/recommen/menu_recommen.jsp" %>
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
    var urlSourceMap = new Map();
    urlSourceMap.put("0","请选择");
    urlSourceMap.put("1", "商品详情页");
    urlSourceMap.put("2", "栏目商品列表");
    urlSourceMap.put("3", "H5活动列表");
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use(['laydate', 'upload', 'layer', 'table', 'element'], function () {
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

        //栏目链接列表加载
        table.render({
            elem: '#columnLink'
            , url: '${ctx}/recommen?method=getColumnLinks'
            , limit: 100
            , limits: [100, 500, 1000]
            , height: 690
            , cols: [[
                {
                    type: 'checkbox', fixed: 'left', field: "ids"

                },
                {field: 'id', width: 60, title: '编号', align: 'center'},
                {
                    field: 'clink_status', width: 100, title: '状态', align: 'center', templet: function (d) {
                        switch (d.clink_status) {
                            case "1":
                                return "<font color='red'>正常</font>";
                            case "0":
                                return "禁用";
                            default:
                                return "状态未表明";
                        }
                    }
                },
                {field: 'column_link', width: 200, title: '栏目链接名称', align: 'center'},
                {field: 'cadd_time', width: 180, title: '添加时间', align: 'center', templet: '#cdd_timeTpl'},
                {field: 'url_link', width: 220, title: 'URL链接', align: 'center'},
                {field: 'url_flag', width: 120, title: '链接类型', align: 'center',templet:function (d) {
                        if (d.url_flag == 1) {
                            return "商品详情页";
                        } else if (d.url_flag == 2) {
                            return "栏目商品列表";
                        } else if (d.url_flag == 3) {
                            return "H5活动列表";
                        } else {
                            return "尚未填写";
                        }
                    }},
                {field: 'link_remark', width: 300, title: '备注', align: 'center'},
                {field: 'last_oper_time', width: 180, title: '最后操作时间', align: 'center', templet: '#oper_timeTpl'},
                {field: 'nick_name', width: 150, title: '最后操作人', align: 'center'},
                {fixed: 'right', title: '操作', width: 400, align: 'center', toolbar: "#recommenColumnStatusManage"}
            ]]
            , page: true//关闭自动分页
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , id: 'ColumnLinkInfoReload'
        });
        // 栏目链接
        table.on('tool(columnLinkFilter)', function (obj) {
            if (obj.event === 'recommenColumnStatus') {
                var columnStatus = obj.data.clink_status;
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
                            setTimeout(sendMsg(obj, obj.data.id, 0), 60000);//60秒内不可以重复点击，一秒等于1000毫秒
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
                            setTimeout(sendMsg(obj, obj.data.id, 1), 60000);//60秒内不可以重复点击，一秒等于1000毫秒
                            //    table.reload("columnList");
                        }
                        , btn2: function () {
                            layer.closeAll();
                        }
                    });
                }
            }
            var columnListIndex;
            if (obj.event === 'edit') {
                console.log("   obj   " + obj.data.id);
                var title = "<h3>修改【" + obj.data.column_link + "】栏目链接的信息</h3>";
                columnListIndex = layer.open({  //打开
                    type: 1
                    , title: title
                    , offset: 'auto'
                    , id: 'addPlanOpen'
                    , area: ['40%', '60%']
                    , content: $('#updateColumnLinkDiv')
                    //,btn: '关闭'
                    , btnAlign: 'c' // 按钮居中
                    , shade: 0 // 遮罩
                    , yes: function () {
                        layer.closeAll();
                    }
                    , end: function () {   //层销毁后触发的回调
                        //将所有的表单数据置为空

                    }
                });
                getColumnLinkInfo(obj.data.id);
            }

            // 拉取数据 栏目链接信息 单条
            function getColumnLinkInfo(id) {
                $.ajax({
                    type: "get",
                    url: "${ctx}/recommen?method=getColumnLinkInfo&id=" + id,
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        if (data.success) {
                            $("#u_url_flag").empty();
                            var u_url_flag =  data.rs[0].url_flag;
                            console.log("  u_url_flag  " + u_url_flag);
                            urlSourceMap.each(function (value, key) {
                                console.log(" key " + key + " value " + value);
                                if (value == u_url_flag) {
                                    $("#u_url_flag").append("<option value='" + value + "' selected>"  + "  " + key + " " + "</option>");
                                } else {
                                    $("#u_url_flag").append("<option value='" + value + "'>" + "  " + key + " " + "</option>");
                                }
                            });

                            $('#_column_link').val(data.rs[0].column_link);
                            $('#url_link').val(data.rs[0].url_link);
                            $('#link_remark').val(data.rs[0].link_remark);
                            $('#id').val(data.rs[0].id);

                            form.render('select');
                        }
                    },
                    error: function (error) {
                        console.log("error=" + error);
                    }
                });
            };

            if (obj.event === 'dele') {
                console.log(" dele ")
                console.log("    id      " + obj.data.id)
                layer.msg('确定要删除吗?', {
                    skin: 'layui-layer-molv' //样式类名  自定义样式
                    , closeBtn: 1    // 是否显示关闭按钮
                    , anim: 1 //动画类型
                    , btn: ['确定', '取消'] //按钮
                    , icon: 6    // icon
                    , yes: function () {
                        SendPost(obj.data.id);
                    }
                    , btn2: function () {
                        table.reload('columnLink');
                    }
                });

            }
        });

        function sendMsg(obj, id, clink_status) {
            $.ajax({
                type: "get",
                url: "${ctx}/recommen?method=updateColumnLinkStatus",
                data: {"id": id, "clink_status": clink_status},   //status=2 移入回收站
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('栏目状态变更成功!', {time: 2000}, function () {
                            //do something
                            console.log("  successful columnList   ");
                            table.reload("columnLink");
                            window.location.href = "${ctx}/recommen/column_links.jsp";
                        });
                    } else {
                        layer.msg("  变更状态失败  ");
                    }
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }
                // data:{"uvid":data.id,"memthodname":"edituv","aid":data.aid,"uv":value},
            });
            // table.reload("columnList");
        }

        // 逻辑删除栏目链接库
        function SendPost(id) {
            $.ajax({
                type: "get",
                url: "${ctx}/recommen",
                data: "method=deleteColumnLink&id=" + id,
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    console.log(data.success);
                    if (data.success == 1) {
                        layer.msg(" 删除成功! ");
                    }
                    table.reload("columnLink");
                    window.location.href = "${ctx}/recommen/column_links.jsp";
                },
                error: function () {
                    layer.alert("错误");
                }
            });
        }

        var $ = layui.$, active = {};

        //监听"checkbox"操作
        form.on('checkbox(checkboxFilter)', function (obj) {
            //处理时间
            if (this.name == 'hasPreTimeEnd' && obj.elem.checked) {
                $("#presell_endtime").val('');
                $("#presell_endtimeDiv").hide();
            } else if (this.name == 'hasPreTimeEnd' && !obj.elem.checked) {
                $("#presell_endtimeDiv").show();
            }
            form.render('checkbox');
        });
        // 栏目外链接-开
        form.on('checkbox(linkStartFilter)', function (obj) {
            if (this.name == 'linkStart' && obj.elem.checked) {
                $("#chooseColumnLinkDIV").show();
                // 商品链接 与栏目外链接二者互斥 必须有一个开启
                $("#linkf").html("<font color='red'>已开启</font>");
            } else {
                $("#chooseColumnLinkDIV").hide();
                $("#linkf").html("<font color='blue'>已关闭</font>");
            }
        });

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

        $('#searchBtn').on('click', function () {
            console.log("  search  ")
            var column_link = $('#column_link');
            var start_usefultime = $('#start_usefultime');
            var end_usefultime = $('#end_usefultime');
            table.reload('ColumnLinkInfoReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    column_link: column_link.val(),
                    start_usefultime: start_usefultime.val(),
                    end_usefultime: end_usefultime.val()
                }
            });
            return false;
        });

        $('#batchDelete').on('click', function () {

            var checkStatus = table.checkStatus('ColumnLinkInfoReload'),
                data = checkStatus.data;
            console.log("  checkStatus  " + checkStatus + " data  is  "+data );
            var selectCount = checkStatus.data.length;
            if (selectCount == 0) {
                layer.msg("请选择一条链接信息！");
                return false;
            }
            var id = new Array(selectCount);

            for (var i = 0; i < selectCount; i++) {
                id[i] = checkStatus.data[i].id;
                console.log("  columnLinkId   "+id);
            }
            ;

            layer.msg('确定要删除吗?', {
                skin: 'layui-layer-molv' //样式类名  自定义样式
                , closeBtn: 1    // 是否显示关闭按钮
                , anim: 1 //动画类型
                , btn: ['确定', '取消'] //按钮
                , icon: 5    // icon
                , yes: function () {
                    sendBatchDelete(id);

                }
                , btn2: function () {
                    layer.closeAll();
                }
            });

            return false;
        });
        
        function sendBatchDelete(id) {
            $.ajax({
                type:"POST",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                url: "${ctx}/recommen?method=batchDelete&id=" + id,
                // data:{'id':id} ,
                // traditional: true,
                success: function (data) {
                    layer.closeAll();
                    layer.msg('栏目链接删除成功');
                    window.location.href = "${ctx}/recommen/column_links.jsp";
                },
                error: function () {
                    layer.msg('栏目链接删除失败');
                }
            })
        }

        //点击按钮 添加栏目链接库
        var linkIndex;
        $('#insert').on('click', function(){
            console.log("             insert             ");
            linkIndex =layer.open({
                type: 1
                ,title: '提示：请输入一个栏目链接信息'
                ,offset: 'auto'
                ,id: 'linkOpen'
                //,area: ['800px', '550px']
                ,area: ['40%','60%']
                ,content: $('#saveColumnLinkDiv')
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
            return false;
        });
        // end
    });


</script>

<script id="cdd_timeTpl" type="text/html">
    {{#  if(d.cadd_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.cadd_time.substr(0,2) }}-{{ d.cadd_time.substr(2,2) }}-{{ d.cadd_time.substr(4,2) }} {{ d.cadd_time.substr(6,2) }}:{{ d.cadd_time.substr(8,2) }}:{{ d.cadd_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>

<script id="oper_timeTpl" type="text/html">
    {{#  if(d.last_oper_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.last_oper_time.substr(0,2) }}-{{ d.last_oper_time.substr(2,2) }}-{{ d.last_oper_time.substr(4,2) }} {{ d.last_oper_time.substr(6,2) }}:{{ d.last_oper_time.substr(8,2) }}:{{ d.last_oper_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>

<script type="text/html" id="recommenColumnStatusManage">
    <a lay-event="edit">编辑</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    {{#  if(d.clink_status == 1){ }}
    <a href="javascript:return false;" onclick="return false;" style="cursor: default;">
        <i class="start" style="opacity: 0.2">开启</i></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a lay-event="recommenColumnStatus">禁用</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <i lay-event="dele">删除</i>
    {{#  } else if(d.clink_status == 0) { }}
    <a lay-event="recommenColumnStatus">启动</a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="javascript:return false;" onclick="return false;" style="cursor: default;">
        <i class="stop" style="opacity: 0.2">禁用</i></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a lay-event="dele">删除</a>
    <%--<a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="orderDetailInfo">去处理</a>--%>
    <%--<a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" style="color: gray">去处理</a>--%>
    <%----%>
    {{#  } }}
</script>


<div class="layui-body">
    <div id="updateColumnLinkDiv" style="display: none;">
        <form id="updateLinkForm" class="layui-form" style="padding: 15px;">
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>栏目链接名称</label>
                    <div class="layui-input-inline">
                        <input id="_column_link" name="_column_link" autocomplete="off" placeholder=""
                               class="layui-input"
                               type="text">
                        <input id="id" name="id" type="hidden">
                    </div>
                </div>
            </div>
<!-- url链接 -->
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>链接类型</label>
                    <div class="layui-input-inline">
                        <select class="layui-select" name="u_url_flag" id="u_url_flag">
                            <option value="" selected="selected">全部</option>
                            <option value="1">商品详情页</option>
                            <option value="2">栏目商品列表页</option>
                            <option value="3">H5活动列表</option>
                        </select>
                    </div>
                </div>
            </div>
<!-- end    -->
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>URL链接:</label>
                    <div class="layui-input-inline">
                        <input id="url_link" name="url_link" autocomplete="off" placeholder="" class="layui-input"
                               type="text">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px">
                        备注:</label>
                    <div class="layui-input-inline">
                        <input id="link_remark" name="link_remark" autocomplete="off" placeholder="" class="layui-input"
                               type="text">
                    </div>
                </div>
            </div>

            <div class="layui-inline" style="margin-left: 150px;margin-top: 10px;">
                <div class="layui-form-item" style="margin-top: 20px;margin-left: 80px;">
                    <div class="layui-input-block" align="center">
                        <button class="layui-btn" id="updateLinkBtn" lay-submit="" lay-filter="demo1">更新</button>
                    </div>
                </div>
            </div>
            <script type="application/javascript">
                //点击按钮 保存加入到首页推荐
                $('#updateLinkBtn').on('click', function () {
                    var column_link = $("#_column_link").val();
                    if (column_link == "") {
                        layer.msg('栏目链接名称不能为空！');
                        $("#_column_link").focus();
                        return false;
                    }
                    if ($("#url_link").val() == "") {
                        layer.msg('栏目链接地址不能为空');
                        return false;
                    }

                    if ($("#u_url_flag").val() == "" || $("#u_url_flag").val() == "0") {
                        layer.msg('url链接地址 必须选择 ');
                        return false;
                    }
                    $.ajax({
                        type: "POST",
                        url: "${ctx}/recommen?method=updateGoodsLink", //="+$("#_column_link").val()+"&url_link="+$("#url_link").val()+"&",
                        // data: {jsonString:JSON.stringify($('#updateLinkForm').serializeObject())},
                        // contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                        data: {
                            id:$("#id").val(),
                            column_link: $("#_column_link").val(),
                            url_link: $("#url_link").val(),
                            link_remark: $("#link_remark").val(),
                            urlFlag:$("#u_url_flag").val()
                        },
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            console.log("    data   is   " + data.success);
                            if (data.success) {
                                layer.msg('保存成功!', {time: 1000}, function () {
                                    layer.closeAll();
                                    // table.reload('columnLink');
                                    window.location.href = "${ctx}/recommen/column_links.jsp";
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
            </script>
        </form>

    </div>

    <div id="saveColumnLinkDiv" style="display: none;">
        <form id="saveLinkForm" class="layui-form" style="padding: 15px;">
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>栏目链接名称</label>
                    <div class="layui-input-inline">
                        <input id="column_link_" name="column_link_" autocomplete="off" placeholder=""
                               class="layui-input"
                               type="text">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>链接类型</label>
                    <div class="layui-input-inline">
                        <select class="layui-select" name="url_flag" id="url_flag">
                            <option value="" selected="selected">全部</option>
                            <option value="1">商品详情页</option>
                            <option value="2">栏目商品列表页</option>
                            <option value="3">H5活动列表</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red"></label>URL链接:</label>
                    <div class="layui-input-inline">
                        <input id="url_link_" name="url_link_" autocomplete="off" placeholder="" class="layui-input"
                               type="text">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px">
                        备注:</label>
                    <div class="layui-input-inline">
                        <input id="link_remark_" name="link_remark_" autocomplete="off" placeholder="" class="layui-input"
                               type="text">
                    </div>
                </div>
            </div>

            <div class="layui-inline" style="margin-left: 150px;margin-top: 10px;">
                <div class="layui-form-item" style="margin-top: 20px;margin-left: 80px;">
                    <div class="layui-input-block" align="center">
                        <button class="layui-btn" id="saveLinkBtn" lay-submit="" lay-filter="demo1">保存</button>
                    </div>
                </div>
            </div>
            <script type="application/javascript">
                //点击按钮 保存
                $('#saveLinkBtn').on('click', function () {
                    var column_link = $("#column_link_").val();
                    if (column_link == "") {
                        layer.msg('栏目链接名称不能为空！');
                        $("#column_link_").focus();
                        return false;
                    }
                    // if ($("#url_link_").val() == "") {
                    //     layer.msg('URL链接地址不能为空');
                    //     return false;
                    // }

                    var url_flag =  $("#url_flag").val();
                    if (url_flag == "" || url_flag == "0") {
                        layer.msg(" 链接类型 必须选择");
                        $("#column_link_").focus();
                        return false;
                    }

                    $.ajax({
                        type: "POST",
                        url: "${ctx}/recommen?method=saveColumnLink", //="+$("#_column_link").val()+"&url_link="+$("#url_link").val()+"&",
                        // data: {jsonString:JSON.stringify($('#updateLinkForm').serializeObject())},
                        // contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                        data: {
                            column_link: $("#column_link_").val(),
                            url_link: $("#url_link_").val(),
                            link_remark: $("#link_remark_").val(),
                            urlFlag: $("#url_flag").val()
                        },
                        cache: false,
                        async: false,
                        dataType: "json",
                        success: function (data) {
                            console.log("    data   is   " + data.success);
                            if (data.success) {
                                layer.msg('保存成功!', {time: 1000}, function () {
                                    layer.closeAll();
                                    window.location.href = "${ctx}/recommen/column_links.jsp";
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
            </script>
        </form>

    </div>

    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">栏目链接库</div>
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">
                    <label class="layui-form-label">栏链名称</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input class="layui-input" autocomplete="off" name="column_link" id="column_link">
                    </div>

                    <label class="layui-form-label" style="width: 120px;">最后操作时间</label>
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
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="searchBtn"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button class="layui-btn layui-btn-sm" style="margin-top:5px;" id="reset"><i class="layui-icon">&#x2746;</i>重置
                        </button>
                    </div>

                    <div class="layui-form-item" style="margin-bottom: 0">
                        <button class="layui-btn layui-btn-sm" id="batchDelete" style="margin-top: 5px"><i class="layui-icon">&#xe640;</i>批量删除
                        </button>
                        <button id="insert" class="layui-btn layui-btn-sm" style="margin-top: 5px">新增
                        </button>
                    </div>

                </div>
            </div>
        </form>

    </div>
    <table class="layui-hide" id="columnLink" lay-filter="columnLinkFilter"></table>
    <!-- 新增栏目链接信息 start -->
    <div id="columnLinkDiv" style="display: none;padding: 15px;">

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
            <a class="layui-btn layui-btn-sm layui-btn-normal"  lay-event="select">选定</a>
        </script>


    </div>
    <!--  end -->
</div>

<div class="layui-footer">
    <%@ include file="/common/footer.jsp" %>
</div>
