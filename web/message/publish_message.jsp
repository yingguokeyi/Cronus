<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/header.jsp" %>
<%@include file="/message/menu_message.jsp" %>
<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>
<script>
    layui.use(['laydate', 'upload', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var form = layui.form;
        var upload = layui.upload
        table.render({
            elem: '#messageList'
            , height: 710
            , url: '${ctx}/message?method=getMessageInfoList'
            , cols: [[
                // {type:'numbers',fixed: 'true',align:'center'}
                // ,{type: 'checkbox', fixed: 'left', field: "id"}
                // ,{field: 'goods_id', title: '', width: 5,style:'display:none;'}
                {field: 'status', width: 200, title: '状态', align: 'center', templet: '#statusTpl'}
                , {field: 'message_name', width: 240, title: '消息标题', align: 'center'}
                , {field: 'message_context', width: 150, title: '消息内容', align: 'center'}
                , {field: 'imgPath', width: 200, title: '图片', align: 'center', templet: '#imgPath'}
                , {field: 'link_address', width: 200, title: '地址链接', align: 'center'}
                , {field: 'message_type', width: 200, title: '信息类型', align: 'center', templet: '#messageTypeTpl'}
                , {field: 'member_level', width: 200, title: '接收群体', align: 'center', templet: '#memberLevelTpl'}
                , {field: 'publish_time', width: 200, title: '发布时间', align: 'center', templet: '#publish_timeTpl'}
                , {field: 'add_user', width: 200, title: '创建人', align: 'center'}
                , {field: 'create_time', width: 200, title: '创建时间', align: 'center', templet: '#create_timeTpl'}
                , {field: 'wealth', width: 260, fixed: 'right', align: 'center', title: '操作', toolbar: "#operation"}
            ]]
            , id: 'messageReload'
            , page: true
            , limit: 100
            , limits: [50, 100, 500, 100]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            },
        });

        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        // 日期时间选择器
        laydate.render({
            elem: '#publish_min'
            , type: 'datetime'
        });
        // 日期时间选择器
        laydate.render({
            elem: '#publish_max'
            , type: 'datetime'
        });

        // 日期时间选择器
        laydate.render({
            elem: '#add_min'
            , type: 'datetime'
        });
        // 日期时间选择器
        laydate.render({
            elem: '#add_max'
            , type: 'datetime'
        });

        // 发送花四溅
        laydate.render({
            elem: "#send_begintime"
            , type: 'datetime'
        });

        // 发送花四溅
        laydate.render({
            elem: "#i_send_begintime"
            , type: 'datetime'
        });

        // 点击按钮 搜索商品
        $('#searchBtn').on('click', function () {
            var publisher = $('#publisher');
            var status = $('#status');
            var messageType = $('#message_type');
            var sendType = $('#send_type');
            var publish_min = $('#publish_min');
            var publish_max = $('#publish_max');
            var add_min = $("#add_min");
            var add_max = $("#add_max");
            var member_level = $("#member_level");

            table.reload('messageReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    publisher: publisher.val(),
                    // 发布人
                    messageType: messageType.val(),
                    // 信息类型
                    sendType: sendType.val(),
                    // 发送方式：站内 站外
                    publishMin: publish_min.val(),
                    publishMax: publish_max.val(),
                    // 发布时间
                    status: status.val(),
                    //  状态
                    addMin: add_min.val(),
                    addMax: add_max.val(),
                    // 创建时间
                    memberLevel: member_level.val()
                }
            });
            return false;
        });

        var updateMessageIndex;
        // 监听工具条
        table.on('tool(messagelist)', function (obj) {
            if (obj.event === 'edit') {
                var id = obj.data.id;
                updateMessageIndex = layer.open({
                    type: 1
                    , title: ['编辑信息', 'font-size: 20px']
                    , offset: 'auto'
                    , id: 'edit_Message_Manage'
                    , area: ['78%', '80%']
                    , content: $('#edit_Message_Div')
                    //,btn: '关闭'
                    , shade: 0 //不显示遮罩
                    , btnAlign: 'c' //按钮居中
                    , yes: function () {
                        layer.closeAll();
                    }
                    , success: function () {
                        $.ajax({
                            type: "get",
                            async: false, // 同步请求
                            cache: true,// 不使用ajax缓存
                            contentType: "application/json",
                            url: "${ctx}/message?method=selectMessageOne",
                            data: "id=" + id,
                            dataType: "json",
                            success: function (data) {
                                var create_time = data.rs[0].create_time;
                                var message_name = data.rs[0].message_name;
                                var image_path = data.rs[0].image_path;
                                var message_context = data.rs[0].message_context;
                                var imgPath = data.rs[0].imgPath;
                                var message_type = data.rs[0].message_type;
                                var id = data.rs[0].id;
                                var imgId = data.rs[0].imgId;
                                var link_address = data.rs[0].link_address;
                                var add_user = data.rs[0].add_user;
                                var status = data.rs[0].status;

                                var chbs = document.getElementsByName("messageType");
                                var scopes = document.getElementsByName("scope");

                                $("#YH").attr('checked', false);
                                $("#XT").attr('checked', false);
                                $("#XT").val("");
                                $("#YH").val("");

                                for (var i = 0; i < chbs.length; i++) {
                                    // console.log(" value is : "+chbs[i].value);
                                    // console.log(" value is : "+chbs[i].checked);
                                    var nameId = chbs[i].id;
                                    $("#" + nameId).attr('checked', false);
                                    // console.log(!$('#hasPreSaleTimeEnd').is(':checked'));
                                    if (chbs[i].id === message_type) {
                                        var nameId = chbs[i].id;
                                        chbs[i].checked = true;
                                        $("#" + nameId).attr('checked', true);
                                        $("#" + nameId).val(nameId);
                                        console.log("---------------- "+$("#"+nameId).val())
                                    }
                                }

                                // 重置接收范围参数值
                                // $("#0").attr('checked', false);
                                $("#1").attr('checked', false);
                                $("#2").attr('checked', false);
                                $("#3").attr('checked', false);
                                $("#1").val("");
                                $("#2").val("");
                                $("#3").val("");

                                var member_level = data.rs[0].member_level;
                                // 接收范围 是个数组
                                var memberLevels = member_level.split(",");
                                // for (var obj in  memberLevels, member_level) {
                                //     console.log("  memberLevels is : " + memberLevels[obj] + " member_level " + member_level[obj]);
                                // }
                                for (var i = 0; i < memberLevels.length; i++) {
                                    console.log(" memeberLevel is -- " + memberLevels[i]);
                                }

                                for (var i = 0; i < scopes.length; i++) {

                                    for (var j = 0; j < memberLevels.length; j++) {
                                        console.log(" memeberLevel is -- " + memberLevels[j]);
                                        if (scopes[i].id === memberLevels[j]) {
                                            var nameId = scopes[i].id;
                                            scopes[i].checked = true;
                                            $("#" + nameId).attr('checked', true);
                                            $("#" + nameId).val(nameId);
                                            // console.log("nameId is" + nameId);
                                            // console.log("#scope" + $("#" + nameId).val());
                                        }
                                    }

                                }

                                $("#message_name").val(message_name);
                                $("#message_context").val(message_context);

                                // 上传图片预览地址
                                $('#demo1').attr('src', imgPath);
                                $("#showImgIds").val(imgId);

                                $("#messageId").val(id);
                                $("#link_address").val(link_address);
                                $('#send_begintime').val(Utils.FormatDate(create_time));

                                form.render('checkbox');
                            },
                            error: function () {
                                layer.msg("错误");
                            }
                        });

                    }
                });

                return false;
            }

            if (obj.event === 'dele') {
                var messageId = $("#messageId").val();
                messageId = obj.data.id;
                layer.confirm('确认删除?', function (index) {
                    obj.del();//删除对应行（tr）的DOM结构，并更新缓存
                    console.log(" messageId  " + messageId);
                    deleteMessageInfo(messageId);
                });
                return false;
            }
        });

        function deleteMessageInfo(messageId) {
            $.ajax({
                type: "GET",
                url: "${ctx}/message?method=deleteMessageInfo",
                data: {
                    "messageId": messageId
                },
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    layer.msg(' 删除完毕 ');
                    layer.close(updateMessageIndex);
                    table.reload("messageReload");
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }

            });
        }

        $("#updateMessageInfo").on('click', function () {
            // console.log("      updateMessageInfo      ");
            var messageId = $("#messageId").val();
            var messageTypes = document.getElementsByName("messageType");
            var scopes = document.getElementsByName("scope");

            var messageTypeValue = "YH";
            var messageType0 = messageTypes.item(0).value;
            var messageType1 = messageTypes.item(1).value;

            if (messageType0 == "" && messageType1 == "") {
                layer.msg("  消息类型不能为空  ");
                return false;
            } else if (messageType0 == "" && messageType1 != "") {
                messageTypeValue = messageType1;
            } else if (messageType0 != "" && messageType1 == "") {
                messageTypeValue = messageType0;
            }
            console.log("messageTypeValue " + messageTypeValue);

            var messageId = $("#messageId").val();
            console.log("   messageId is: " + messageId);
            var count = 0;
            for (var i = 0; i < scopes.length; i++) {
                var val = scopes.item(i).value;
                if (val.trim() === "") {
                    console.log(" count " + count);
                    count++;
                }
                if (count === 3) {
                    layer.msg("  消息需要指定接收人群!  ");
                    return false;
                }
                console.log("scope is:    " + val);
                console.log(val.trim() === "");
            }

            var mname = $("#message_name").val();
            if (mname == '') {
                layer.msg("  信息名称不能为空  ");
                return false;
            }

            var mcontext = $("#message_context").val();
            if (mcontext == '') {
                layer.msg("  信息内容不能为空  ");
                return false;
            }

            var link_address = $("#link_address").val();
            if (link_address == '') {
                // layer.msg("  链接地址不能为空  ");
                // return false;
                link_address = "";
            }
            var showImgIds = "";
            if (messageTypeValue === "YH") {
                showImgIds = $("#showImgIds").val();
                if (showImgIds == '') {
                    // 必须是优惠类型才能
                    layer.msg("  优惠活动 请上传宣传图片  ");
                    return false;
                }
            }

            var begintime = $("#send_begintime").val();
            if (begintime == '') {
                layer.msg("    发送时间不能为空   ");
                return false;
            }

            updateMessageInfo(messageId, messageTypeValue, scopes, mname, mcontext, showImgIds, link_address, begintime);

            return false;
        });

        function updateMessageInfo(messageId, messageType, scopes, mname, mcontext, showImgIds, link_address, begintime) {

            $.ajax({
                type: "GET",
                url: "${ctx}/message?method=updateMessageInfo",
                data: {
                    "messageId": messageId,
                    "messageType": messageType,
                    "scopes": scopes.item(0).value + "," + scopes.item(1).value + "," + scopes.item(2).value,
                    "messageName": mname,
                    "messageContext": mcontext,
                    "showImgIds": showImgIds,
                    "linkAddress": link_address,
                    "begintime": begintime
                },
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    console.log("  success  " + data);
                    layer.msg(' 更新成功 ');
                    layer.close(updateMessageIndex);
                    table.reload("messageReload");
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }

            });
        }

        //编辑普通图片上传
        var uploadUpdate = upload.render({
            elem: '#test1'
            , url: '${ctx}/upload?method=uploadGoodsImg&uploadType=loadMessageImg'
            , size: 1024 //限制文件大小，单位 KB
            , before: function (obj) {
                //预读本地文件示例，不支持ie8
                obj.preview(function (index, file, result) {
                    $('#demo1').attr('src', result); //图片链接（base64）
                });
            }
            , done: function (res) {
                // 如果上传失败
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
                    uploadUpdate.upload();
                });
            }
        });

        //新增普通图片上传
        var uploadInstert = upload.render({
            elem: '#i_test1'
            , url: '${ctx}/upload?method=uploadGoodsImg&uploadType=loadMessageImg'
            , size: 1024 //限制文件大小，单位 KB
            , before: function (obj) {
                //预读本地文件示例，不支持ie8
                obj.preview(function (index, file, result) {
                    $('#i_demo1').attr('src', result); //图片链接（base64）
                });
            }
            , done: function (res) {
                // 如果上传失败
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
                    $('#i_showImgIds').val(showImgIds.substring(0, showImgIds.length - 1));
                }
            }
            , error: function () {
                //演示失败状态，并实现重传
                var demoText = $('#i_demoText');
                demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
                demoText.find('.demo-reload').on('click', function () {
                    uploadInstert.upload();
                });
            }
        })


        // 修改使用 消息类型
        form.on('checkbox(messageTypeFilter)', function (obj) {
            // console.log(this.value + "   " + $('#messageType').is(':checked'));
            // 处理时间
            if (this.id == 'YH' && !obj.elem.checked) {
                // 当前没有被选中 准备赋值
                $("#XT").val("XT");
                $("#YH").val("");
            } else if (this.id == 'YH' && obj.elem.checked) {
                // 当前选中 准备去除
                $("#XT").attr('checked', false);
                $("#XT").val("");
                $("#YH").val("YH");

            } else if (this.id == 'XT' && obj.elem.checked) {
                // 当前选中 准备去除
                $("#YH").attr('checked', false);
                $("#XT").val("XT");
                $("#YH").val("");
                console.log("   XT   ");
            } else if (this.id == 'XT' && !obj.elem.checked) {
                // 违背选中
                $("#XT").val("");
            }

            form.render('checkbox');
        });

        // 这样做的目的 是因为checkbox 复选框的判断困难 采用此方法
        form.on('checkbox(i_messageTypeFilter)', function (obj) {
            // console.log(this.value + "   " + $('#messageType').is(':checked'));
            // 处理时间
            if (this.id == 'i_YH' && !obj.elem.checked) {
                // 当前没有被选中 准备赋值
                $("#i_XT").val("XT");
                $("#i_YH").val("");

            } else if (this.id == 'i_YH' && obj.elem.checked) {
                // 当前选中 准备去除
                $("#i_XT").attr('checked', false);
                $("#i_XT").val("");
                $("#i_YH").val("YH");

            } else if (this.id == 'i_XT' && obj.elem.checked) {
                // 当前选中 准备去除
                $("#i_YH").attr('checked', false);
                $("#i_XT").val("XT");
                $("#i_YH").val("");
                console.log("   i_XT   ");
            } else if (this.id == 'i_XT' && !obj.elem.checked) {
                // 违背选中
                $("#i_XT").val("");
                // $("#i_YH").val("");
            }

            form.render('checkbox');

        });


        // 接收范围
        form.on('checkbox(scopeFilter)', function (obj) {
            // 处理时间
            if (this.id == '1' && obj.elem.checked) {
                // 普通会员
                $("#1").val("1");
            }
            if (this.id == "1" && !obj.elem.checked) {
                $("#1").val("");
            }
            if (this.id == '2' && obj.elem.checked) {
                // 小掌柜
                $("#2").val("2");
            }
            if (this.id == '2' && !obj.elem.checked) {
                // 小掌柜
                $("#2").val("");
            }
            if (this.id == '3' && obj.elem.checked) {
                // 大掌柜
                $("#3").val("3");
            }
            if (this.id == '3' && !obj.elem.checked) {
                // 大掌柜
                $("#3").val("");
            }
            if (this.id == '0' && obj.elem.checked) {
                //
                $("#0").val("0");
            }
            if (this.id == '0' && !obj.elem.checked) {
                //
                $("#0").val("");
            }
            form.render('checkbox');
        });

        // 新增使用 消息类型 这样做的目的是因为checkbox 复选框判断困难 采用此方法
        form.on('checkbox(i_scopeFilter)', function (obj) {
            // 处理时间
            if (this.id == 'i_1' && obj.elem.checked) {
                // 普通会员
                $("#i_1").val("1");
            }
            if (this.id == "i_1" && !obj.elem.checked) {
                $("#i_1").val("");
            }
            if (this.id == 'i_2' && obj.elem.checked) {
                // 小掌柜
                $("#i_2").val("2");
            }
            if (this.id == 'i_2' && !obj.elem.checked) {
                // 小掌柜
                $("#i_2").val("");
            }
            if (this.id == 'i_3' && obj.elem.checked) {
                // 大掌柜
                $("#i_3").val("3");
            }
            if (this.id == 'i_3' && !obj.elem.checked) {
                // 大掌柜
                $("#i_3").val("");
            }
            if (this.id == 'i_0' && obj.elem.checked) {
                //
                $("#i_0").val("0");
            }
            if (this.id == 'i_0' && !obj.elem.checked) {
                //
                $("#i_0").val("");
            }
            form.render('checkbox');
        });

        //点击按钮 增加推荐
        var MessageInfoIndex;
        $('#addMessageBtn').on('click', function () {

            MessageInfoIndex = layer.open({
                type: 1
                , title: '提示：请发布一条消息信息'
                , offset: 'auto'
                , id: 'MessageInfoOpen'
                //,area: ['800px', '550px']
                , area: ['50%', '80%']
                , content: $('#MessageInfoDiv')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                , shade: 0 //遮罩
                , yes: function () {
                    //layer.closeAll();
                }
                , end: function () {   //层销毁后触发的回调

                }
            });
            $("#i_message_name").val("");
            $("#i_message_context").val("");
            $("#i_XT").attr('checked', false);
            $("#i_YH").attr('checked', false);
            $("#i_XT").val("");
            $("#i_YH").val("");
            $("#i_1").val("");
            $("#i_2").val("");
            $("#i_3").val("");
            $("#i_1").attr('checked', false);
            $("#i_2").attr('checked', false);
            $("#i_3").attr('checked', false);
            $("#i_link_address").val("");
            $("#i_send_begintime").val("");
            $("#i_showImgIds").val("");
            $('#i_demo1').attr('src', "");
            form.render("checkbox");
            return false;
        });

        //
        $('#InsertMessageInfo').on('click', function () {

            var messageTypes = document.getElementsByName("i_messageType");
            var scopes = document.getElementsByName("i_scope");
            var messageTypeValue = "YH";
            var messageType0 = messageTypes.item(0).value;
            var messageType1 = messageTypes.item(1).value;

            if (messageType0 == "" && messageType1 == "") {
                layer.msg("  消息类型不能为空  ");
                return false;
            } else if (messageType0 == "" && messageType1 != "") {
                messageTypeValue = messageType1;
            } else if (messageType0 != "" && messageType1 == "") {
                messageTypeValue = messageType0;
            }
            console.log("messageTypeValue " + messageTypeValue);

            var count = 0;
            for (var i = 0; i < scopes.length; i++) {
                var val = scopes.item(i).value;
                if (val.trim() === "") {
                    console.log(" count " + count);
                    count++;
                }
                if (count === 3) {
                    layer.msg("  消息需要指定接收人群!  ");
                    return false;
                }
                console.log("scope is:    " + val);
                console.log(val.trim() === "");
            }
            // console.log(" messageType  " + messageType);
            // console.log(" scope  " + scope);

            var mname = $("#i_message_name").val();
            if (mname == '') {
                layer.msg("  信息名称不能为空  ");
                return false;
            }

            var mcontext = $("#i_message_context").val();
            if (mcontext == '') {
                layer.msg("  信息内容不能为空  ");
                return false;
            }

            var link_address = $("#i_link_address").val();
            if (link_address == '') {
                // layer.msg("  链接地址不能为空  ");
                // return false;
                link_address = "";
            }

            if (messageTypeValue === "YH") {
                var showImgIds = $("#i_showImgIds").val();
                if (showImgIds == '') {
                    // 必须是优惠类型才能
                    layer.msg("  优惠活动 请上传宣传图片  ");
                    return false;
                }
            }

            var begintime = $("#i_send_begintime").val();
            if (begintime == '') {
                layer.msg("  发送时间不能为空  ");
                return false;
            }

            InsertMessageInfo(messageTypeValue,scopes,mname,mcontext,showImgIds,link_address,begintime);

            return false;
        });

        function InsertMessageInfo(messageTypeValue,scopes,mname,mcontext,showImgIds,link_address,begintime) {

            $.ajax({
                type: "GET",
                url: "${ctx}/message?method=InsertMessageInfo",
                data: {
                    "messageType": messageTypeValue.trim(),
                    "messageScopes": scopes.item(0).value + "," + scopes.item(1).value + "," + scopes.item(2).value,
                    "messageName": mname.trim(),
                    "messageContext": mcontext.trim(),
                    "showImgIds": showImgIds.trim(),
                    "linkAddress": link_address.trim(),
                    "beginTime": begintime.trim()
                },
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    console.log("  success  " + data);
                    layer.msg(' 进入发布队列等待发布 ');
                    layer.close(MessageInfoIndex);
                    table.reload("messageReload");
                },
                error: function () {
                    layer.msg("  请求错误  ");
                }

            });

            return false;
        }

    });

</script>
<script id="create_timeTpl" type="text/html">
    {{#  if(d.create_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_time.substr(0,2) }}-{{ d.create_time.substr(2,2) }}-{{ d.create_time.substr(4,2) }} {{ d.create_time.substr(6,2) }}:{{ d.create_time.substr(8,2) }}:{{ d.create_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>

<script id="publish_timeTpl" type="text/html">
    {{#  if(d.publish_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.publish_time.substr(0,2) }}-{{ d.publish_time.substr(2,2) }}-{{ d.publish_time.substr(4,2) }} {{ d.publish_time.substr(6,2) }}:{{ d.publish_time.substr(8,2) }}:{{ d.publish_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>
<!-- 信息类型 -->
<script type="text/html" id="messageTypeTpl">
    {{# if(d.message_type =='YH'){ }}
    优惠活动
    {{# }else if(d.message_type == 'XT'){ }}
    系统通知
    {{# }else if(d.message_type == 'TK'){  }}
    弹框推荐
    {{# }  }}
</script>
<!-- 接收群体 -->
<script type="text/html" id="memberLevelTpl">
    {{# if(d.member_level =='1'){ }}
    普通会员
    {{# }else if(d.member_level == '1,2'){ }}
    普通会员, 小掌柜
    {{# }else if(d.member_level == '1,2,3'){ }}
    普通会员, 小掌柜, 大掌柜
    {{# }else if(d.member_level == '2'){ }}
    小掌柜
    {{# }else if(d.member_level == '2,3'){ }}
    小掌柜, 大掌柜
    {{# }else if(d.member_level == '3'){  }}
    大掌柜
    {{# }else if(d.member_level == '1,3'){  }}
    普通会员, 大掌柜
    {{# }  }}
</script>
<!-- 图片 -->
<script type="text/html" id="imgPath">
    {{# if(d.imgPath ==''){}}
    无图片
    {{# }else { }}
    <img src={{d.imgPath}} height="50" width="80">
    {{# } }}
</script>

<script>
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#submission_time'
        });
        //常规用法
        laydate.render({
            elem: '#created_date'
        });
    });

</script>

<script type="text/html" id="statusTpl">
    {{#  if(d.status === '1'){ }}
    <span><font color="#00CC00">已发送</font></span>
    {{#  } else if(d.status === '0'){ }}
    <span><font color="#dc143c">等待</font></span>
    {{#  } }}
</script>

<!-- 操作按钮管理 -->
<script type="text/html" id="operation">

    {{#  if(d.status == 0){ }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="edit">&nbsp;&nbsp;编辑&nbsp;&nbsp;</a>
    {{#  } else if(d.status == 1) { }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius status-Down"
    >&nbsp;&nbsp;编辑&nbsp;&nbsp;</a>
    {{#  } }}
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="dele">&nbsp;&nbsp;删除&nbsp;&nbsp;</a>
</script>
<style>
    .status-Down {
        background-color: #999999;
    }
</style>
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote">运营发布信息管理</div>
        <form class="layui-form layui-form-pane">
            <div style="background-color: #f2f2f2;padding:5px 0">
                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">发布人</label>
                    <div class="layui-input-inline">
                        <input autocomplete="off" class="layui-input" type="text" name="publisher" id="publisher">
                    </div>

                    <label class="layui-form-label">发布时间</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input lay-verify="date" name="publish_min" id="publish_min" placeholder="开始日期"
                               autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px">
                        <input lay-verify="date" name="publish_max" id="publish_max" placeholder="结束日期"
                               autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <%--<label class="layui-form-label">发送方式</label>--%>
                    <%--<div class="layui-input-inline">--%>
                    <%--<select class="layui-select" name="send_type" id="send_type">--%>
                    <%--<option value="" selected="selected">全部</option>--%>
                    <%--<option value="0">站内</option>--%>
                    <%--<option value="1">站外</option>--%>
                    <%--</select>--%>
                    <%--</div>--%>

                    <label class="layui-form-label">接收范围</label>
                    <div class="layui-input-inline">
                        <select class="layui-select" name="member_level" id="member_level">
                            <option value="" selected="selected"></option>
                            <option value="1">普通会员</option>
                            <option value="2">小掌柜</option>
                            <option value="3">大掌柜</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select class="layui-select" name="status" id="status">
                            <option value="" selected="selected"></option>
                            <option value="0">等待</option>
                            <option value="1">已发送</option>
                        </select>
                    </div>

                    <label class="layui-form-label">添加时间</label>
                    <div class="layui-input-inline" style="width: 150px">
                        <input lay-verify="date" name="add_min" id="add_min" placeholder="开始日期" autocomplete="off"
                               class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px">
                        <input lay-verify="date" name="add_max" id="add_max" placeholder="结束日期" autocomplete="off"
                               class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <label class="layui-form-label">信息类型</label>
                    <div class="layui-input-inline">
                        <select class="layui-select" name="message_type" id="message_type">
                            <option value="" selected="selected"></option>
                            <option value="YH">优惠活动</option>
                            <option value="XT">系统通知</option>
                        </select>
                    </div>

                    <button id="searchBtn" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i
                            class="layui-icon">&#xe615;</i>搜索
                    </button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset"><i
                            class="layui-icon">&#x2746;</i>重置
                    </button>

                </div>

            </div>
        </form>
        <div style="margin-top: 5px">
            <!-- 按钮 -->
            <button id="addMessageBtn" data-type="auto" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i
                    class="layui-icon">&#xe61f;</i>发布消息
            </button>
        </div>
        <table class="layui-table" id="messageList" lay-filter="messagelist"></table>
    </div>

    <!--  发布消息 start -->
    <div id="MessageInfoDiv" style="display: none;padding: 15px;">
        <form class="layui-form" id="MessageInfoForm">
            <!-- 单选框 -->
            <h3>信息设置：</h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label"><label style="color: red">*</label>消息类型:</label>
                    <div class="layui-input-inline" style="width: 500px;">
                        <input type="checkbox" id="i_YH" name="i_messageType" value=""
                               lay-filter="i_messageTypeFilter"/>优惠活动&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="i_XT" name="i_messageType" value=""
                               lay-filter="i_messageTypeFilter"/>系统通知
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label"><label style="color: red">*</label>接收范围:</label>
                    <div class="layui-input-inline" style="width: 500px;">
                        <input type="checkbox" id="i_1" name="i_scope" value="" lay-filter="i_scopeFilter"/>普通会员&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="i_2" name="i_scope" value="" lay-filter="i_scopeFilter"/>小掌柜&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="i_3" name="i_scope" value="" lay-filter="i_scopeFilter"/>大掌柜
                    </div>
                </div>
            </div>
            <h3>信息详情：</h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <label class="layui-form-label"><label style="color: red">*</label>信息名称:</label>
                <div class="layui-input-block">
                    <input style="width: 500px;" id="i_message_name" name="i_message_name"
                           autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label"><label style="color: red">*</label>信息内容:</label>

                <div class="layui-input-block">
                <textarea style="width: 500px;" id="i_message_context" name="i_message_context"
                          autocomplete="off" placeholder=""
                          class="layui-input" type="text"></textarea>
                </div>
            </div>

            <h4>宣传图片:</h4>
            <hr class="layui-bg-blue">
            <div class="layui-input-item">

                <div class="layui-upload" style="margin-left: 150px;">
                    <div class="layui-input-block">

                        <div class="layui-upload-list">
                            <img class="layui-upload-img" id="i_demo1">
                            <p id="i_demoText"></p>
                        </div>
                        <input type="hidden" id="i_showImgIds" name="i_showImgIds" value="" lay-verify="required"
                               autocomplete="off">

                        <button type="button" class="layui-btn" id="i_test1">选择图片</button>
                        <button type="button" class="layui-btn" id="i_dele" onclick="i_deleteFun()">删除</button>

                    </div>
                    <script type="application/javascript">
                        function i_deleteFun() {
                            $("#i_showImgIds").val("");
                            $('#i_demo1').attr('src', "");
                        }
                    </script>
                </div>
            </div>

            <div class="layui-form-item">
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">链接地址:</label>
                <div class="layui-input-block">
                    <input style="width: 500px;" id="i_link_address" name="i_link_address"
                           autocomplete="off" placeholder=""
                           class="layui-input" type="text"/>
                </div>
            </div>

            <h3>发送时间:</h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>发送时间:</label>
                    <div class="layui-input-inline">
                        <input class="layui-input" id="i_send_begintime" name="i_send_begintime"
                               placeholder="yyyy-MM-dd HH:mm:ss" autocomplete="off" type="text">
                    </div>
                </div>
            </div>

            <div style="text-align:center">
                <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset">重置
                </button>
                <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"
                        id="InsertMessageInfo">确定
                </button>
            </div>

        </form>

    </div>
    <!--  end -->

    <!-- 编辑 -->
    <div id="edit_Message_Div" style="display: none;">
        <form id="messageEditForm" class="layui-form" style="padding: 15px;">
            <!-- 单选框 -->
            <h3>信息设置：</h3>
            <hr class="layui-bg-blue">
            <input type="hidden" id="messageId"/>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label"><label style="color: red">*</label>消息类型:</label>
                    <div class="layui-input-inline" style="width: 250px;">
                        <input type="checkbox" id="YH" name="messageType" value="YH" lay-filter="messageTypeFilter"/>优惠活动
                        <input type="checkbox" id="XT" name="messageType" value="XT" lay-filter="messageTypeFilter"/>系统通知
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label"><label style="color: red">*</label>接收范围:</label>
                    <div class="layui-input-inline" style="width: 500px;">
                        <input type="checkbox" id="1" name="scope" value="" lay-filter="scopeFilter"/>普通会员&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="2" name="scope" value="" lay-filter="scopeFilter"/>小掌柜&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="3" name="scope" value="" lay-filter="scopeFilter"/>大掌柜
                        <%--<input type="checkbox" id="0" name="scope" value="0" lay-filter="scopeFilter"/>所有人--%>
                    </div>
                </div>
            </div>
            <h3>信息详情：</h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <label class="layui-form-label"><label style="color: red">*</label>信息名称:</label>
                <div class="layui-input-block">
                    <input style="width: 500px;" id="message_name" name="message_name"
                           autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label"><label style="color: red">*</label>信息内容:</label>

                <div class="layui-input-block">
                <textarea style="width: 500px;" id="message_context" name="message_context"
                          autocomplete="off" placeholder=""
                          class="layui-input" type="text"></textarea>
                </div>
            </div>

            <h4><label style="color: red">*</label>宣传图片:</h4>
            <hr class="layui-bg-blue">
            <div class="layui-input-item">

                <div class="layui-upload" style="margin-left: 150px;">
                    <div class="layui-input-block">

                        <div class="layui-upload-list">
                            <img class="layui-upload-img" id="demo1">
                            <p id="demoText"></p>
                        </div>
                        <input type="hidden" id="showImgIds" name="showImgIds" value="" lay-verify="required"
                               autocomplete="off">

                        <button type="button" class="layui-btn" id="test1">选择图片</button>
                        <button type="button" class="layui-btn" id="dele" onclick="deleteFun()">删除</button>

                    </div>
                    <script type="application/javascript">
                        function deleteFun() {
                            $("#showImgIds").val("");
                            $('#demo1').attr('src', "");
                        }
                    </script>
                </div>
            </div>

            <div class="layui-form-item">
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">链接地址:</label>
                <div class="layui-input-block">
                    <input style="width: 500px;" id="link_address" name="link_address"
                           autocomplete="off" placeholder=""
                           class="layui-input" type="text"></input>
                </div>
            </div>

            <h3>发送时间:</h3>
            <hr class="layui-bg-blue">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 150px"><label
                            style="color: red">*</label>发送时间:</label>
                    <div class="layui-input-inline">
                        <input class="layui-input" id="send_begintime" name="send_begintime"
                               placeholder="yyyy-MM-dd HH:mm:ss" autocomplete="off" type="text">
                    </div>
                </div>
            </div>

            <div style="text-align:center">
                <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset">重置
                </button>
                <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"
                        id="updateMessageInfo">确定
                </button>
            </div>

        </form>

    </div>
</div>

<%@ include file="/common/footer.jsp" %>
