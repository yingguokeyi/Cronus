<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>


<%
    String pCateName = request.getParameter("pCateName");   //父级分类名称
    String pCateCode = request.getParameter("pCateCode");   //父级分类编码
    String optType = request.getParameter("optType");       //定义返回页面类型
    String manType = request.getParameter("manType");       //操作类型

    String cateId = request.getParameter("cateId");       //编辑分类的id


    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
%>

<script>

    var cateId = <%=cateId%>;
    var imgUrlPrefix = "<%=imgUrlPrefix%>";

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','upload', 'element'], function(){
        var $ = layui.jquery;
        var laydate = layui.laydate //日期
            ,upload = layui.upload
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,element = layui.element; //元素操作

        //先把imgDiv隐藏起来
        $('#imgDiv').hide();

        var manType =  $("#manType").val();
        var optType = $("#optType").val();
        var pCateCode = $("#pCateCode").val();
        var pCateName = $("#pCateName").val();



        //普通图片上传
        var uploadInst = upload.render({
            elem: '#uploadBtn'
            // ,url: '/upload/'
            ,url: "${ctx}/upload?method=uploadCategoryImg"
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


        //alert("manType:"+manType+" pCateCode:"+pCateCode+ "  optType:"+optType+" pCateName:"+pCateName);



        function onLoadData() {
            if(cateId){
                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${ctx}/goodsCategory",
                    data : "method=getCateInfo&cateId="+cateId,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            //layer.msg("查询成功");

                            var cateId = data.rs[0].id;
                            var categoryName = data.rs[0].cateName;

                            $('#cateId').val(cateId);
                            $('#categoryName').val(categoryName);
                            $('#sort').val(data.rs[0].sort);


                            $('#demo1').attr('src', imgUrlPrefix + data.rs[0].image_path);
                            $('#imgDiv').show();

                            $('#imgId').val(data.rs[0].image_id);
                            $('#memo').val(data.rs[0].memo);

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



        //点击按钮 保存 分类
        $('#saveCategoryBtn').on('click', function(){

            var categoryName = $("#categoryName").val();
            //var string =  "method=addBrand&jsonString="+JSON.stringify($('form').serializeObject());

            //校验
            if(validate()){

                $('#saveCategoryBtn').attr("disabled",true);

                $.ajax({
                    type: "get",
                    url: "${ctx}/goodsCategory?method=addCategory",
                    data: {"jsonData":JSON.stringify($('form').serializeObject())},
                    contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                    cache: false,
                    async : false,
                    dataType: "json",
                    success:function(data) {
                        if(data.success){

                            layer.msg('成功保存商品分类',{time:2000}, function(){

                                var manType = "<%=manType%>";

                                    if(manType == 'topCate'){
                                        // alert("回一级列表"+manType);
                                        window.location.href = "${ctx}/goods/goodsCategoryList.jsp?manType=topCate";
                                    }else if(manType == 'subCate'){
                                        // alert("回二级列表"+manType);
                                        window.location.href = "${ctx}/goods/goodsCategoryList.jsp?pCateCode=<%=pCateCode%>&pCateName=<%=pCateName%>&manType=subCate";
                                    }else if(manType == 'minCate'){
                                        // alert("回三级列表"+manType);
                                        window.location.href = "${ctx}/goods/goodsCategoryList.jsp?pCateCode=<%=pCateCode%>&pCateName=<%=pCateName%>&manType=minCate";
                                    }
                            });
                        }else{
                            layer.msg("异常");
                        }
                    },
                    error : function() {
                        $('#saveCategoryBtn').attr("disabled",false);
                        layer.alert("错误");
                    }
                });
            }

            return false;
        });



        //校验
        function validate(){

            var manType = "<%=manType%>";

            var categoryName = $("#categoryName").val();
            var sort = $("#sort").val();
            var imgId = $('#imgId').val();

            if(manType == 'minCate'){
                if(!imgId){
                    layer.msg('请上传分类图片！');
                    return false;
                }
            }

            if(categoryName.length < 2){
                layer.msg('分类名称至少得2个字符！');
                return false;
            }

            if(!(/^\d+$/.test(sort))){
                layer.msg('序号请输入正整数！');
                $("#sort").focus();
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

            <% if(cateId == null){%>添加<%}else{%>修改<%}%><% if(optType.equals("addTopCate")){%>一级分类<%}else if(optType.equals("addSubCate")){%>
                [<%=pCateName%>]下的商品分类(类目等级：二级)
            <%}else if(optType.equals("addMinCate")){%>
                [<%=pCateName%>]下的商品分类(类目等级：三级)
            <%}%>

            <span class="layui-breadcrumb" style="visibility: visible;" >
              <a href="./goodsCategoryList.jsp?manType=topCate" target="_self">[分类管理]</a>
            </span>

            <!-- 存放页面参数 -->
            <input type="hidden" name="pCateName" value="<%=pCateName%>" lay-verify="required" autocomplete="off">
            <input type="hidden" id="manType" name="manType" value="<%=manType%>" lay-verify="required" autocomplete="off">





        </blockquote>

        <form class="layui-form" action="" style="padding: 15px;">
            <div class="layui-form-item">
                <label class="layui-form-label">分类名称</label>
                <div class="layui-input-inline">


                    <!-- 存放页面参数 这些参数是需要传入到后面的 -->

                    <input type="hidden" name="optType" value="<%=optType%>" lay-verify="required" autocomplete="off">
                    <input type="hidden" name="pCateCode" value="<%=pCateCode%>" lay-verify="required" autocomplete="off">
                    <input type="hidden" name="cateId" value="<%=cateId%>" lay-verify="required" autocomplete="off">

                    <input type="text" style="width: 500px;" id="categoryName" name="categoryName" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="请输入分类名称" class="layui-input">
                </div>
            </div>


            <% if(optType.equals("addTopCate")){%>

            <%}else if(optType.equals("addSubCate")){%>

            <%}else if(optType.equals("addMinCate")){%>
                <div class="layui-form-item">
                    <label class="layui-form-label">分类图</label>
                    <div class="layui-input-inline">

                        <button type="button" class="layui-btn" id="uploadBtn">
                            <i class="layui-icon">&#xe67c;</i>上传分类图
                        </button>

                        <div class="layui-upload-list" id="imgDiv">
                            <img class="layui-upload-img" id="demo1" style="width: 200px;height: 300px;">
                            <input type="hidden" id="imgId" name="imgId" value="" lay-verify="required" autocomplete="off">
                            <p id="demoText"></p>
                        </div>
                    </div>
                </div>
            <%}%>

            <div class="layui-form-item">
                <label class="layui-form-label">排序号</label>
                <div class="layui-input-inline">
                    <input id="sort" name="sort" lay-verify="sort" autocomplete="off" placeholder="请输入排序号"
                           class="layui-input" type="text">
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-inline">
                    <input id="memo" name="memo" lay-verify="memo" autocomplete="off" placeholder=""
                           class="layui-input" type="text">
                </div>
            </div>

            <!--
            <div class="layui-form-item">
                <label class="layui-form-label">分类</label>
                <div class="layui-input-inline">
                    <select name="interest" lay-filter="aihao" lay-verify="required" >
                        <option value=""></option>
                        <option value="0">顶级类目</option>
                        <option value="1" selected="">一级</option>
                        <option value="2">二级</option>
                        <option value="3">三级</option>
                        <option value="4">顶级二</option>
                    </select>
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">分类</label>
                    <div class="layui-input-inline">
                        <select name="quiz">
                            <option value="">请选择分类</option>
                            <optgroup label="顶级类目一">
                                <option value="11">一级</option>
                                <optgroup label="类目二">
                                    <option value="22">二级</option>
                                </optgroup>
                            </optgroup>
                            <optgroup label="学生时代">
                                <option value="你的工号">你的工号</option>
                                <option value="你最喜欢的老师">你最喜欢的老师</option>
                            </optgroup>
                        </select>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">默认单位数量</label>
                <div class="layui-input-inline">
                    <select name="interest" lay-filter="aihao">
                        <option value=""></option>
                        <option value="0">顶级类目</option>
                        <option value="1" selected="">一级</option>
                        <option value="2">二级</option>
                        <option value="3">三级</option>
                        <option value="4">顶级二</option>
                    </select>
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">搜索选择框</label>
                    <div class="layui-input-inline">
                        <select name="modules" lay-verify="required" lay-search="">
                            <option value="">直接选择或搜索选择</option>
                            <option value="1">layer</option>
                            <option value="2">form</option>
                            <option value="3">layim</option>
                            <option value="4">element</option>
                            <option value="5">laytpl</option>
                            <option value="6">upload</option>
                            <option value="7">laydate</option>
                            <option value="8">laypage</option>
                            <option value="9">flow</option>
                            <option value="10">util</option>
                            <option value="11">code</option>
                            <option value="12">tree</option>
                            <option value="13">layedit</option>
                            <option value="14">nav</option>
                            <option value="15">tab</option>
                            <option value="16">table</option>
                            <option value="17">select</option>
                            <option value="18">checkbox</option>
                            <option value="19">switch</option>
                            <option value="20">radio</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">筛选属性</label>
                    <div class="layui-input-inline">
                        <select name="interest" lay-filter="aihao">
                            <option value=""></option>
                            <option value="0">顶级类目</option>
                            <option value="1" selected="">一级</option>
                            <option value="2">二级</option>
                            <option value="3">三级</option>
                            <option value="4">顶级二</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <select name="interest" lay-filter="aihao">
                            <option value=""></option>
                            <option value="0">顶级类目</option>
                            <option value="1" selected="">一级</option>
                            <option value="2">二级</option>
                            <option value="3">三级</option>
                            <option value="4">顶级二</option>
                        </select>
                    </div>
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">METE Title</label>
                <div class="layui-input-inline">
                    <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="针对搜索引擎设置的标题" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">METE Keywords</label>
                <div class="layui-input-inline">
                    <input type="text" name="title" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="针对搜索引擎设置的关键词" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">METE Description</label>
                <div class="layui-input-block">
                    <textarea  width="500" height="300" placeholder="针对搜索引擎设置的网页描述" class="layui-textarea"></textarea>
                </div>
            </div>
            -->

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button id="saveCategoryBtn" class="layui-btn">确定</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>


    </div>




<%@ include file="/common/footer.jsp"%>