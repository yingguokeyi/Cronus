<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/common.jsp" %>
<%@ include file="/advertising/advertising_memu.jsp"%>


<%
    String id = request.getParameter("id");
    String position_id = request.getParameter("position_id");
%>

<script>

    var page_location,position,size,next_advertNum,imgId,advert_name,start_time,end_time,advert_url_id,linkName;
    var id = <%=id%>;
    var position_id = <%=position_id%>;

    layui.use(['upload','laydate', 'element', 'form'], function () {
        var $ = layui.jquery
            , upload = layui.upload
            , element = layui.element;
        var form = layui.form;
        var laydate = layui.laydate;
        laydate.render({
            elem: '#start_time'
            ,type: 'datetime'
        });
        laydate.render({
            elem: '#end_time'
            ,type: 'datetime'
        });


        $.ajax({
            type: "get",
            async: false, // 同步请求
            cache: true,// 不使用ajax缓存
            contentType: "application/json",
            url: "${ctx}/advertising",
            data: "method=getAdvertInfo&id="+id,
            dataType: "json",
            success: function (data) {
                if (data.success) {
                    $("#position").val(data.rs[0].position);
                    $("#size").val(data.rs[0].size);
                    switch (data.rs[0].page_location) {
                        case "1":
                            $("#page_location").val("首页");
                            break;
                        case "2":
                            $("#page_location").val("分类");
                            break;
                        case "3":
                            $("#page_location").val("会员");
                            break;
                        case "4":
                            $("#page_location").val("我的");
                            break;
                    }
                    $("#next_advertNum").val(+data.rs[0].advert_num);
//                    if(data.rs[0].next_advertNum.length == 1){
//                       var next_advertNum=  data.rs[0].page_location + '000' +data.rs[0].next_advertNum;
//                        $("#next_advertNum").val(next_advertNum);
//                    }else if(data.rs[0].next_advertNum.length == 2){
//                        var next_advertNum=  data.rs[0].page_location + '00' +data.rs[0].next_advertNum;
//                        $("#next_advertNum").val(next_advertNum);
//                    }else if(data.rs[0].next_advertNum.length == 3){
//                        var next_advertNum=  data.rs[0].page_location + '0' +data.rs[0].next_advertNum;
//                        $("#next_advertNum").val(next_advertNum);
//                    }
                    id = $("#id").val(data.rs[0].id);
                    advert_name = $("#advert_name").val(data.rs[0].advert_name);
                    advert_url_id = data.rs[0].advert_url_id;
//                    $("#advert_url_id").val(advert_url_id);
                    linkName = data.rs[0].link_name;
                    $("#linkName").val(linkName);
                    if(data.rs[0].start_time.length == 12){
                        var st = data.rs[0].start_time;
                        start_time = "20" + st.substr(0, 2) + "-" + st.substr(2, 2) + "-" + st.substr(4, 2) + " " + st.substr(6, 2) + ":" + st.substr(8, 2) + ":" + st.substr(10, 2);
                        $("#start_time").val(start_time);
                    }
                    if(data.rs[0].end_time.length == 12){
                        var et = data.rs[0].end_time;
                        end_time = "20" + et.substr(0, 2) + "-" + et.substr(2, 2) + "-" + et.substr(4, 2) + " " + et.substr(6, 2) + ":" + et.substr(8, 2) + ":" + et.substr(10, 2);
                        $("#end_time").val(end_time);
                    }
                    imgId =$("#showImgIds").val(data.rs[0].advert_img_id);
                    $('#demo1').attr('src', data.rs[0].image);
                } else {

                    layer.msg("异常");
                }
            },
            error: function () {
                layer.alert("错误");
            }
        });

        //普通图片上传
        var uploadInst = upload.render({
            elem: '#test1'
            , url: '${ctx}/upload?method=uploadGoodsImg&uploadType=loadAdvertisingImg'
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
                imgId = res.result.ids[0];
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

        //提交
        $('#submit').on('click', function (){
            if ($("#advert_name").val() == "") {
                layer.msg('请输入广告名称');
            }else if($("#linkName").val() == ""){
                layer.msg('请选择广告链接');
            }else if($("#start_time").val() == ""){
                layer.msg('请选择开始时间');
            }else if($("#end_time").val() == ""){
                layer.msg('请选择结束时间');
            }else if($("#showImgIds").val() == ""){
                layer.msg('请上传图片');
            }
            $.ajax({
                type: "get",
                async : false, // 同步请求
                cache :true,// 不使用ajax缓存
                contentType : "application/json",
                url: "${ctx}/advertising?method=updateAdvert",
                data: {
                    'id':<%=id%>,
                    'advert_num':$("#next_advertNum").val(),
                    'advert_url_id':advert_url_id,
                    'imgId':$("#showImgIds").val(),
                    'advert_name':$("#advert_name").val(),
                    'start_time':$("#start_time").val(),
                    'end_time':$("#end_time").val(),
                    'position_id':position_id
                },
                dataType : "json",
                success : function(data){

                    if (data.success == 1) {
                        layer.msg('操作成功', {time: 1000}, function () {
//                                window.location.reload();
                            history.go(-1);
                        });
                    }else if(data.success == 2){
                        layer.msg("请输入正确的时间");
                    } else {
                        layer.msg("异常");
                    }
                }
            })
        });

    });




</script>

<script type="text/html" id="Category_status">
    {{# if(d.category ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.category =='1'){}}
    商品详情页
    {{# }else if(d.category =='2'){ }}
    栏目列表
    {{# }else if(d.category =='3'){ }}
    活动页面
    {{# } }}
    {{# } }}
</script>

<div class="layui-body">
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            广告位信息
            <button id="return" class="layui-btn layui-btn-sm" onclick="javascript:history.go(-1);"
                    style="margin-left: 1200px;"><i class="layui-icon">&#xe65c;</i>返回
            </button>
        </div>
        <div style="padding:10px 5px 0px 5px">
            <div class="layui-col-md3">
                所属页面：
                <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="page_location"/>
            </div>
            <div class="layui-col-md3">
                广告位名称：
                <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="position"/>
            </div>
            <div class="layui-col-md3">
                广告编号：
                <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="next_advertNum"/>
            </div>
            <div class="layui-col-md3">
                广告尺寸：
                <input style="border:none;width: 200px;margin-left: 10px" readonly="readonly" id="size"/>
            </div>
        </div>
        <br />
        <br />
        <div class="layui-elem-quote">
            广告材料
        </div>
        <form>
            <div style="padding:20px 5px 0px 50px">
                广告ID：     <%=id%>
            </div>
            <div style="padding:20px 5px 0px 50px">
                广告名称：
                <input style="width: 250px;height:30px;margin-left: 10px" type="text" id="advert_name"/>
            </div>
            <div style="padding:20px 5px 0px 50px">
                广告链接：
                <button class="layui-btn layui-btn-sm"  type="button" id="new_url">
                    新建链接
                </button>
                <button id="url_list" class="layui-btn layui-btn-sm" type="button">
                    链接库添加
                </button>
                <script type="application/javascript">
                    var mylay;
                    layui.use(['layer', 'table'], function () {
                        var table = layui.table;
                        var layer = layui.layer;

                        $('#url_list').on('click', function () {
                            mylay = layer.open({
                                type: 1
                                , title: '提示:请选择一条数据'
                                , offset: 'auto'
                                , id: 'listOpen'
                                //,area: ['800px', '550px']
                                , area: ['70%', '70%']
                                , content: $('#advertUrlList')
                                //,btn: '关闭'
                                , btnAlign: 'c' //按钮居中
                                , shade: 0 //遮罩
                                , yes: function () {

                                }
                                , end: function () {   //层销毁后触发的回调

                                }
                            });

                            table.render({
                                elem: '#test'
                                , height: '500px'
                                , cellMinWidth: 190
                                , url: '${ctx}/advertising?method=getUrlList'
                                ,data: {
                                    'start_time': start_time2,
                                    'end_time':end_time2,
                                    'advertlink_name':advertlink_name2,
                                    'operator':operator
                                }
                                , response: {
                                    statusName: 'success' //数据状态的字段名称，默认：code
                                    , statusCode: 1  //成功的状态码，默认：0
                                    , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                                    , countName: 'total' //数据总数的字段名称，默认：count
                                    , dataName: 'rs' //数据列表的字段名称，默认：data
                                }
                                , id: 'listUrl'
                                , limit: 50 //每页显示的条数
                                , limits: [50, 100, 200]
                                , page: false
                                , cols: [[ // 表头
                                    {type: 'checkbox', fixed: 'left'}
                                    , {field: 'advertlink_name', width: 260, title: '广告链接名称'}
                                    , {field:'remarks', width:250, title: '备注'}
                                    , {field: 'category',width:100, title: 'URL类型',templet: '#Category_status'}
                                    , {field: 'operator',width:150, title: '创建人'}
                                    ,{field:'edit_time', width:180, title: '最后操作时间',templet:function (d) {
                                        var index="";
                                        if(d.edit_time==""){
                                            index="----";
                                        }else {
                                            var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                                        }
                                        return index;
                                    }}
                                ]]
                            });
                        });

                        $('#new_url').on('click', function (){
                            var index = layer.open({
                                type: 1
                                , title: '编辑'
                                , id: 'layerDemo'
                                , area: ['600px','600px']
                                , content: $('#NewUrlPage')
                                , btn: ['保存','取消']
                                , btnAlign: 'c' //按钮居中
                                , shade: 0 //不显示遮罩
                                , yes: function (data) {
                                    var advertlink_name = $("#advertlink_name").val();
                                    var url_link = $("#url_link").val();
                                    var remarks = $("#remarks").val();
                                    var category = $("#category").val();
                                    if(advertlink_name ==""){
                                        layer.msg('请输入广告链接名称');
                                    }else if(url_link ==""){
                                        layer.msg('请输入广告链接');
                                    }else if(category ==""){
                                        layer.msg('请选择链接类型');
                                    }else{
                                        $.ajax({
                                            type: "get",
                                            async: false, // 同步请求
                                            cache: true,// 不使用ajax缓存
                                            contentType: "application/json",
                                            url: "${ctx}/advertising?method=addAdvertUrl",
                                            data: {
                                                "advertlink_name": advertlink_name,
                                                "url_link":url_link,
                                                "remarks":remarks,
                                                "category":category
                                            },

                                            dataType: "json",
                                            success: function (data) {
                                                if (data.success) {
                                                    advert_url_id = data.result.ids;
//                                                    $("#advert_url_id").val(advert_url_id);
                                                    linkName = data.result.advertlink_name;
                                                    $("#linkName").val(linkName);
                                                    layer.msg('编辑成功',{time: 1000}, function () {
                                                        layer.close(index);
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

                                }
                                ,btn2:function () {
//                                    layer.closeAll();
                                    var index=parent.layer.getFrameIndex(window.name);
                                    parent.layer.close(index);
                                }
                            });
                        });

                        //选择一条广告链接
                        $('#determine').on('click', function (){

                            var table = layui.table;
                            var layer = layui.layer;
                            var checkStatus = table.checkStatus('listUrl');
                            var selectCount = checkStatus.data.length;
                            if(selectCount == 1){
                                advert_url_id = checkStatus.data[0].id;
//                                $("#advert_url_id").val(advert_url_id);
                                linkName = checkStatus.data[0].advertlink_name;
                                $("#linkName").val(linkName);
                                layer.msg('成功'
                                    , {time: 1000}, function () {
                                        layer.close(mylay);}
                                );

                                return true;
                            };
                            if(selectCount != 1){
                                layer.msg("请选择一条数据！");
                                return false;
                            };
                        });

                    });




                </script>

            </div>
            <%--<div style="padding:20px 5px 0px 50px">--%>
                <%--广告链接ID：--%>
                <%--<input style="width: 50px;height:30px;margin-left: 10px" type="text" id="advert_url_id" value="advert_url_id" readonly="readonly"/>--%>
            <%--</div>--%>
            <div style="padding:20px 5px 0px 50px">
                广告链接名称：
                <input style="width: 250px;height:30px;margin-left: 10px" type="text" id="linkName" readonly="readonly"/>
            </div>

            <div style="padding:20px 5px 0px 50px">
                有效开始时间：
                <input style="width: 200px;height:30px;margin-left: 10px" type="text" id="start_time"/>
            </div>

            <div style="padding:20px 5px 0px 50px">
                有效结束时间：
                <input style="width: 200px;height:30px;margin-left: 10px" type="text" id="end_time"/>
            </div>

            <%--<div style="padding:20px 5px 0px 50px">--%>
                <%--图片预览：--%>
                <%--<div style="width: 200px;height:200px;margin-left: 10px">--%>

                <%--</div>--%>
            <%--</div>--%>


            <div style="padding:20px 5px 0px 50px">
                上传图片：
                <div class="layui-upload" style="margin-left: 150px;">
                    <div class="layui-upload-list">
                        <img class="layui-upload-img" id="demo1">
                        <p id="demoText"></p>
                    </div>
                    <input type="hidden" id="showImgIds" name="showImgIds" value="showImgIds" lay-verify="required"
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

            </div>

            <div style="padding:20px 5px 0px 50px">
                &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
                &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
                <button class="layui-btn layui-btn"  type="button" id="submit">
                    提交
                </button>

            </div>

        </form>

    </div>

    <!-- 新建链接 -->
    <div id="NewUrlPage" style="display: none; padding: 15px;">
        <form class="layui-form layui-form-pane" action="">

            <div class="layui-form-item">

                <label class="layui-form-label">广告链接名称</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="advertlink_name" id="advertlink_name" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="remarks" id="remarks" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label">URL链接</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="url_link" id="url_link" lay-verify="title" autocomplete="off">
                </div>

                <label class="layui-form-label">链接类型：</label>
                <div class="layui-input-inline" >
                    <select id="category" name="category">
                        <option value="1">商品详情页</option>
                        <option value="2">栏目列表</option>
                        <option value="3">活动页面</option>
                    </select>

                </div>

            </div>

        </form>
    </div>

    <!--链接库列表-->
    <div id="advertUrlList" style="display: none;padding: 15px;">
        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label" style="width: 200px">最后操作时间</label>
                    <div class="layui-input-inline">
                        <input style="width: 200px" name="start_time2" id="start_time2" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline">
                        <input style="width: 200px" name="end_time2" id="end_time2" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                </div>

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label" style="width: 200px">广告位链接名称</label>
                    <div class="layui-input-inline">
                        <input style="width: 200px" type="text" name="advertlink_name2" id="advertlink_name2" autocomplete="off"
                               class="layui-input">
                    </div>

                    <label class="layui-form-label" style="width: 150px">最后操作人</label>
                    <div class="layui-input-inline">
                        <input style="width: 200px" type="text" name="operator" id="operator" autocomplete="off"
                               class="layui-input">
                    </div>

                    <div class="logisticMakesureDiv layui-inline">
                        <%--<button id="g_searchBtn" name="g_searchBtn" class="layui-btn layui-btn-sm"><i--%>
                                <%--class="layui-icon">&#xe615;</i>搜索--%>
                        <%--</button>--%>
                        <button class="layui-btn layui-btn-sm" type="button" id="determine"><i
                                class="layui-icon">&#xe63c;</i>确定
                        </button>
                        <%--<button type="reset" class="layui-btn layui-btn-sm"><i--%>
                                <%--class="layui-icon">&#x2746;</i>重置--%>
                        <%--</button>--%>

                    </div>

                </div>

            </div>

        </form>
        <table class="layui-hide" id="test" lay-filter="listUrl"></table>

    </div>


</div>



<%@ include file="/common/footer.jsp"%>