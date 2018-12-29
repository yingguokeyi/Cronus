<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<script type="text/javascript" src="${ctx}/layui/layui.js?t=1515376178738"></script>

<%
    String spu_id = request.getParameter("spu_id");
%>
<script>
    var spu_id = <%=spu_id%>;

    layui.use(['upload','form','laydate'], function(){
        var $ = layui.jquery
            ,upload = layui.upload;
        var form = layui.form;
        var laydate = layui.laydate;



        //多图片上传
        upload.render({
            elem: '#showUpload'
            ,url: '${ctx}/upload?method=uploadGoodsShowImg'
            ,multiple: true
            ,before: function(obj){
                //预读本地文件示例，不支持ie8
                obj.preview(function(index, file, result){
                    //$('#showUploadDiv').empty();
                    $('#showUploadDiv').append('<img src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img" id="showImg'+index+'" name="showImg'+index+'">')
                });
            }
            ,done: function(res){
                //上传完毕

                if(res.success){
                    //上传成功
                    $('#showUploadDiv').show();
                    layer.msg('上传成功');


                    //demoText.html('');
                    //$('#imgId').val(res.result.ids[0]);
                }else{
                    //如果上传失败
                    layer.msg("异常");
                }


            }
        });





        upload.render({
            elem: '#detailUpload'
            ,url: '/upload/'
            ,multiple: true
            ,before: function(obj){
                //预读本地文件示例，不支持ie8
                obj.preview(function(index, file, result){
                    $('#detailUploadDiv').append('<img src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img">')
                });
            }
            ,done: function(res){
                //上传完毕
            }
        });



        //点击按钮 保存商品
        $('#saveBtn').on('click', function(){
            $.ajax({
                type: "get",
                url: "/cronus/demo",
                data: "method=addData&jsonString="+JSON.stringify($('form').serializeObject()),
                contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                cache: false,
                async : false,
                dataType: "json",
                success:function(data) {
                    var id;
                    if(data.success){
                        layer.msg('返回数据!',{time:2000}, function(){

                            var sysdate = data.result.rs[0].sysdate;
                            layer.alert(sysdate);
                            $('#activeTimeStart').val(sysdate);

                        });
                    }else{
                        layer.msg("异常");
                    }
                },
                error : function() {
                    layer.alert("错误");
                }
            });

            return false;
        });





    });


</script>
<!-- 内容主体区域 -->
<div class="layui-body" style="padding: 30px">
    <form enctype="multipart/form-data">

        <h3>图片 : </h3>
        <hr class="layui-bg-blue">
        <div class="layui-upload" style="margin-left: 110px;">
            <button type="button" class="layui-btn" id="showUpload">上传show图片</button>
            <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                预览图：
                <div class="layui-upload-list" id="showUploadDiv"></div>
            </blockquote>
        </div>


        <div class="layui-upload" style="margin-left: 110px;">
            <button type="button" class="layui-btn" id="detailUpload">上传detail图片</button>
            <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                预览图：
                <div class="layui-upload-list" id="detailUploadDiv"></div>
            </blockquote>
        </div>


        <div class="layui-form-item">
            <div class="layui-input-block">

                <button id="saveBtn" class="layui-btn layui-btn-normal">提交</button>

            </div>
        </div>

    </form>


<%@ include file="/common/footer.jsp"%>