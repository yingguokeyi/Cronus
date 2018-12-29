<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="common.PropertiesConf" %>

<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<%
    String brandId = request.getParameter("brandId");
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
%>
<script>
    var brandId = <%=brandId%>;
    var imgUrlPrefix = "<%=imgUrlPrefix%>";

    alert(brandId);
    //JavaScript代码区域
    layui.use(['laydate','upload','layer','table', 'element'], function(){
        var $ = layui.jquery
            ,upload = layui.upload
            ,layer = layui.layer //弹层
            ,form = layui.form
            ,element = layui.element; //元素操作


        //先把imgDiv隐藏起来
        $('#imgDiv').hide();

        //普通图片上传
        var uploadInst = upload.render({
            elem: '#test1'
            // ,url: '/upload/'
            ,url: "${ctx}/upload?method=uploadBrandLogo"
            ,before: function(obj){
                //预读本地文件示例，不支持ie8
                obj.preview(function(index, file, result){
                    $('#demo1').attr('src', result); //图片链接（base64）
                });
            }
            ,done: function(res){
                if(res.success){
                    //上传成功
                    $('#imgDiv').show();
                    layer.msg('上传成功');
                    // imgId = res.result.ids[0];
                    var demoText = $('#demoText');
                    demoText.html('');
                    $('#imgId').val(res.result.ids[0]);
                }else{
                    //如果上传失败
                    layer.msg("异常");
                }

            }
            ,error: function(){
                //演示失败状态，并实现重传
                var demoText = $('#demoText');
                demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
                demoText.find('.demo-reload').on('click', function(){
                    uploadInst.upload();
                });
            }
        });


        function onLoadData() {
            if(brandId){

                $("#newOrEditSpan").html("修改");

                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${ctx}/goods",
                    data : "method=getBrandInfo&brandId="+brandId,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            //layer.msg("查询成功");

                            var brandId = data.rs[0].id;
                            var brand_name = data.rs[0].brand_name;
                            $('#brandId').val(brandId);
                            $('#brand_name').val(brand_name);
                            $('#url').val(data.rs[0].url);
                            if(data.rs[0].logo_path!=""){
                                $('#demo1').attr('src', imgUrlPrefix + data.rs[0].logo_path);
                                $('#imgDiv').show();
                                $('#imgId').val(data.rs[0].logo_img_id);
                            }

                            $('#detail').val(data.rs[0].detail);

                        } else {
                            layer.msg("异常");
                        }
                    },
                    error : function() {
                        layer.alert("错误");
                    }
                })
            }
        }

        onLoadData();


        //绑定原始文件域
        // upload.render({
        //     elem: '#test20'
        //     ,url: '/upload/'
        //     ,done: function(res){
        //         console.log(res)
        //     }
        // });


        //点击按钮 保存商品品牌
        $('#saveBrandBtn').on('click', function(){

            //layer.msg(url+ encodeURI($("#sourceName").val()))

            //校验
            if(validate()){
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods?method=addBrand",
                    data: {"jsonString":JSON.stringify($('form').serializeObject())},
                    contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                    cache: false,
                    async : false,
                    dataType: "json",
                    success:function(data) {

                        if(data.success){
                            var newOrEdit = "添加";
                            if(brandId){
                                newOrEdit = "修改";
                            }
                            layer.msg('成功'+newOrEdit+'商品品牌',{time:2000}, function(){
                                //do something
                                window.location.href = "${ctx}/goods/goodsBrandList.jsp";
                            });

                        }else{
                            layer.msg("异常");
                        }
                    },
                    error : function() {
                        layer.alert("错误");
                    }
                });
            }

            return false;
        });



        //校验
        function validate(){

            var brand_name = $("#brand_name").val();
            var url = $("#url").val();
            var imgId = $('#imgId').val();

            if(!imgId){
                layer.msg('请上传品牌LOGO！');
                return false;
            }
            if(brand_name.length < 2){
                layer.msg('名称至少得2个字符');
                return false;
            }
            if(!url){
                layer.msg('请填写品牌网址！');
                return false;
            }
            return true;
        };

    });

</script>




<!-- 内容主体区域 -->
<div class="layui-body">

    <div style="padding: 15px;">

        <blockquote class="layui-elem-quote">
            <span id="newOrEditSpan">添加</span>品牌
            <a class="layui-btn layui-btn-normal" href="${ctx}/goods/goodsBrandList.jsp" style="margin-left: 85%;">品牌列表</a>
        </blockquote>


        <form class="layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">品牌名称</label>
                <div class="layui-input-inline">
                    <input type="hidden" name="method" value="addBrand" lay-verify="required" autocomplete="off">
                    <input type="text" style="width: 500px;" id="brand_name" name="brand_name" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="请输入名称" class="layui-input">
                </div>

                <!-- 存放页面参数 -->
                <input type="hidden" name="brandId" id="brandId" value="<%=brandId%>" lay-verify="required" autocomplete="off">

            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">品牌网址</label>
                <div class="layui-input-inline">
                    <input type="text" style="width: 500px;" id="url" name="url" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="请输入网址" class="layui-input">
                </div>
            </div>

            <%--<div class="layui-upload">--%>
            <%--<label class="layui-form-label">品牌LOGO</label>--%>
            <%--<div class="layui-input-inline">--%>
            <%--<input name="file" id="test20" type="file">--%>
            <%--</div>--%>
            <%--</div>--%>

            <div class="layui-form-item">
                <label class="layui-form-label">品牌LOGO</label>
                <div class="layui-input-inline">
                    <%--<button class="layui-btn layui-btn-sm" id="test1" type="button">上传品牌LOGO</button>--%>

                    <button type="button" class="layui-btn" id="test1">
                        <i class="layui-icon">&#xe67c;</i>上传品牌LOGO
                    </button>

                    <div class="layui-upload-list" id="imgDiv">
                        <img class="layui-upload-img" id="demo1">
                        <input type="hidden" id="imgId" name="imgId" value="" lay-verify="required" autocomplete="off">
                        <p id="demoText"></p>
                    </div>


                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">品牌介绍</label>
                <div class="layui-input-inline" style="width: 500px;">
                    <textarea name="detail" id="detail" maxlength="200" placeholder="请输入品牌介绍" class="layui-textarea"></textarea>
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-input-block">
                    <%--<button id="saveBrandBtn" class="layui-btn" lay-submit="" lay-filter="saveFilter">确定</button>--%>
                    <button id="saveBrandBtn" class="layui-btn layui-btn-normal">确定</button>

                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>


    </div>



<%@ include file="/common/footer.jsp" %>