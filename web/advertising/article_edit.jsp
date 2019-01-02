<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp"%>
<%@ include file="/advertising/advertising_memu.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/common/css/goodsCateSelect.css"/>

<script type="text/javascript" src="${ctx}/js/Utils.js?t=1515376178738"></script>

<%
    String id = request.getParameter("id");
%>

<script>

    var id = <%=id%>;
    var imgId;

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
            url: "${ctx}/article",
            data: "method=getArticleInfo&id="+id,
            dataType: "json",
            success: function (data) {
                if (data.success) {
                    $("#articalId").val(id);
                    $("#articalId").val(id);
                    $("#article_title").val(data.rs[0].article_title);
//                    $("#article_content").val(data.rs[0].article_content);
                    $("#link_address").val(data.rs[0].link_address);
                    $("#article_source").val(data.rs[0].article_source);
                    imgId =$("#showImgIds").val(data.rs[0].imgId);
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

    });




</script>

<!-- 内容主体区域 -->
<div class="layui-body" style="padding: 15px">

    <div class="layui-elem-quote">
            <span>
                <a>编辑文章</a>&nbsp;&nbsp;
            </span>
        <button class="layui-btn  layui-btn-sm" style="margin-left: 50%" onclick="history.go(-1)">返回到文章列表</button>
    </div>
    <form enctype="multipart/form-data">



        <div class="layui-form-item">
            <div class="layui-input-block">
                <input  id="articalId" name="articalId"
                       autocomplete="off"
                       class="layui-input" type="hidden" >
            </div>

        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">*</label>文章标题：</label>
            <div class="layui-input-block" style="width: 70%;">
                <input style="width: 500px;display: inline-block;" id="article_title" name="article_title"
                       autocomplete="off"
                       class="layui-input" type="text" >
            </div>

        </div>

        <%--<div class="layui-form-item">--%>
            <%--<label class="layui-form-label"><label style="color: red">*</label>文章内容：</label>--%>
            <%--<div class="layui-input-block" style="width: 70%;">--%>
                <%--<input style="width: 500px;display: inline-block;" id="article_content" name="article_content"--%>
                       <%--autocomplete="off"--%>
                       <%--class="layui-input" type="text" >--%>
            <%--</div>--%>

        <%--</div>--%>

        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">*</label>文章链接：</label>
            <div class="layui-input-block" style="width: 70%;">
                <input style="width: 500px;display: inline-block;" id="link_address" name="link_address"
                       autocomplete="off"
                       class="layui-input" type="text" >
            </div>

        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"><label style="color: red">*</label>文章来源：</label>
            <div class="layui-input-block" style="width: 70%;">
                <input style="width: 500px;display: inline-block;" id="article_source" name="article_source"
                       autocomplete="off"
                       class="layui-input" type="text" >
            </div>

        </div>

        <div style="padding:20px 5px 50px 50px">
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

    </form>
    <div class="layui-form-item">
        <div class="layui-input-block">

            <button id="submit" class="layui-btn layui-btn-normal">保存</button>
            <button id="exit" class="layui-btn layui-btn-normal">取消</button>
        </div>
    </div>
    <script type="application/javascript">
//        var imgId;
        layui.use(['element','laydate','table'], function(){
            var element = layui.element;
            var laydate = layui.laydate;
            var table = layui.table;
        });
        $("#exit").click(function () {
            window.location.href="${ctx}/advertising/article_list.jsp";
        });
        $("#submit").click(function () {

            var article_title = $("#article_title").val();
//            var article_content = $("#article_content").val();
            var link_address = $("#link_address").val();
            var article_source = $("#article_source").val();

            if (article_title == "") {
                layer.msg('文章内容不能为空！');
                return false;
            }
//            if (article_content == "") {
//                layer.msg('文章内容不能为空！');
//                return false;
//            }
            if (link_address == "") {
                layer.msg('链接地址不能为空！');
                return false;
            }
            if (article_source == "") {
                layer.msg('文章来源不能为空！');
                return false;
            }

            $.ajax({
                //几个参数需要注意一下
                type: "post",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${ctx}/article?method=updateArticle",
                async: true,
                data: {
                    'article_title':article_title,
//                    'article_content':article_content,
                    'link_address':link_address,
                    'imgId':$("#showImgIds").val(),
                    'article_source':article_source,
                    'articalId':$("#articalId").val()
                },
                success: function (data) {
                    if (data.success == 1) {
                        layer.msg('操作成功', {time: 1000}, function () {
                            window.location.href="${ctx}/advertising/article_list.jsp";
                        });
                    }

                },
                error: function () {
                    layer.msg("异常");
                },
            });
            return false;

        });


    </script>

</div>
<%@ include file="/common/footer.jsp" %>
