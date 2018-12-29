<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<%
    String supplierId = request.getParameter("supplierId");
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
%>
<script>
    var supplierId = <%=supplierId%>;
    var imgUrlPrefix = "<%=imgUrlPrefix%>";

    //JavaScript代码区域
    layui.use(['laydate','layer','table', 'element'], function(){
        var $ = layui.jquery
            ,layer = layui.layer //弹层
            ,form = layui.form
            ,element = layui.element; //元素操作





        function onLoadData() {


            if(supplierId){

                $("#newOrEditSpan").html("修改");

                $.ajax({
                    type: "get",
                    async : false, // 同步请求
                    cache :true,// 不使用ajax缓存
                    contentType : "application/json",
                    url : "${ctx}/goods",
                    data : "method=getSupplierInfo&supplierId="+supplierId,
                    dataType : "json",
                    success : function(data){
                        if (data.success) {
                            //layer.msg("查询成功");

                            var supplierId = data.rs[0].id;
                            var supplier_name = data.rs[0].supplier_name;
                            $('#supplierId').val(supplierId);
                            $('#supplier_name').val(supplier_name);
                            $('#tel').val(data.rs[0].tel);
                            $('#address').val(data.rs[0].address);
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



        //点击按钮 保存供应商
        $('#saveSupplierBtn').on('click', function(){

            //校验
            if(validate()){
                $.ajax({
                    type: "get",
                    url: "${ctx}/goods?method=addSupplier",
                    data: {"jsonData":JSON.stringify($('form').serializeObject())},
                    contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                    cache: false,
                    async : false,
                    dataType: "json",
                    success:function(data) {
                        if(data.success){
                            var newOrEdit = "添加";
                            if(supplierId){
                                newOrEdit = "修改";
                            }
                            layer.msg('成功'+newOrEdit+'供应商',{time:2000}, function(){
                                //do something
                                window.location.href = "${ctx}/goods/supplierList.jsp";
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

            var supplier_name = $("#supplier_name").val();
            var address = $("#address").val();
            var tel = $('#tel').val();


            if(supplier_name.length < 2){
                layer.msg('名称至少得2个字符');
                return false;
            }
            if(!address){
                layer.msg('请填写供应商地址！');
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
            <span id="newOrEditSpan">添加</span>供应商
            <%--<a class="layui-btn layui-btn-normal" href="${ctx}/goods/supplierList.jsp" target="_self" style="margin-left: 85%;">供应商列表</a>--%>
        </blockquote>


        <form class="layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">供应商名称</label>
                <div class="layui-input-inline">
                    <input type="text" style="width: 500px;" id="supplier_name" name="supplier_name" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="请输入名称" class="layui-input">
                </div>

                <!-- 存放页面参数 -->
                <input type="hidden" name="supplierId" id="supplierId" value="<%=supplierId%>" lay-verify="required" autocomplete="off">

            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-inline">
                    <input type="text" style="width: 500px;" id="tel" name="tel" lay-verify="title" lay-verify="required" autocomplete="off" placeholder="请输入电话" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">地址</label>
                <div class="layui-input-inline">
                    <input type="text" style="width: 500px;" id="address" name="address" lay-verify="title" lay-verify="required" autocomplete="off" placeholder="请输入地址" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-inline">
                    <input type="text" style="width: 500px;" id="memo" name="memo" lay-verify="title" lay-verify="required" autocomplete="off" placeholder="请输入备注" class="layui-input">
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button id="saveSupplierBtn" class="layui-btn layui-btn-normal">确定</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>


    </div>

    <%@ include file="/common/footer.jsp" %>
