<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>
<%
    String styleName = request.getParameter("styleName");
    String goodsTypeId = request.getParameter("id");
%>
<script>

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });
    var goodsTypeId="";
    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','table', 'element'], function(){
        var element = layui.element;
        var $ = layui.jquery;
        var laydate = layui.laydate //日期
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作
        var form = layui.form;


        //监听radio操作
        form.on('radio(entry_mode)', function(obj){
            layer.tips(this.value + ' ' + this.name + '：'+ obj.elem.checked + obj.elem.title, obj.othis);
            if(this.value == 2){
                $("#propertiesDiv").show(1000);
                $("#writerDiv").hide(1000);
            }else if(this.value == 1){
                $("#propertiesDiv").hide(1000);
                $("#writerDiv").show(1000);
            }


        });
        $("#goodsProperty_Add").on('click',function () {
            $.ajax({
                type: "get",
                url: "${ctx}/goodsProperty?method=addGoodsPropertyInfo",
                data: {"goodsTypeId":<%=goodsTypeId%>,"jsonStr":JSON.stringify($('form').serializeObject())},
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.tips('操作成功', that);
                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });
        });

    });

    // $(document).ready(function(){
    //     var url = location.search;
    //     var theRequest = new Object();
    //     if ( url.indexOf( "?" ) != -1 ) {
    //         var str = url.substr( 1 ); //substr()方法返回从参数值开始到结束的字符串；
    //         var strs = str.split( "&" );
    //         for ( var i = 0; i < strs.length; i++ ) {
    //             theRequest[ strs[ i ].split( "=" )[ 0 ] ] = ( strs[ i ].split( "=" )[ 1 ] );
    //         }
    //         goodsTypeId=theRequest.goodsTypeId;
    //         $('#styleName').text(decodeURI(decodeURI(theRequest.styleName)));
    //     }
    // });


</script>


<!-- 内容主体区域 -->
<div class="layui-body">

    <div style="padding: 15px;">

        <blockquote class="layui-elem-quote" style="font-size: 20px;margin-top: -10px">
            添加<%=styleName%>属性
            <a class="layui-btn layui-btn-normal" style="margin-left: 1200px" href="./goodsPropertyList.jsp" target="_self">属性列表</a>
        </blockquote>

        <form class="layui-form" action="" style="padding: 15px;">
            <div class="layui-form-item" align="center">
                <label class="layui-form-label">属性名称</label>
                <div class="layui-input-inline">
                    <input type="text" style="width: 500px;" name="attribute_name" lay-verify="title" lay-verify="required" autocomplete="off"
                           placeholder="请输入名称" class="layui-input">
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">属性类型</label>
                <div class="layui-input-block">
                    <input name="attribute_type" title="商品属性" type="radio" checked="" value="1">
                    <input name="attribute_type" title="销售属性" type="radio" value="2">
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">是否允许检索</label>
                <div class="layui-input-block">
                    <input name="retrieval_style" title="是" type="radio" checked="" value="1">
                    <input name="retrieval_style" title="否" type="radio" value="2">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">是否作为筛选项</label>
                <div class="layui-input-block">
                    <input name="screening_project" title="是" type="radio" checked="" value="1">
                    <input name="screening_project" title="否" type="radio" value="2">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">相同属性值的商品是否关联</label>
                <div class="layui-input-block">
                    <input name="commonattrbuteisnorelation" title="是" type="radio" checked="" value="1">
                    <input name="commonattrbuteisnorelation" title="否" type="radio" value="2">
                </div>
            </div>
            <%--<div class="layui-form-item">--%>
                <%--<label class="layui-form-label">属性值录入方式</label>--%>
                <%--<div class="layui-input-block">--%>
                    <%--<input name="sex" title="手动录入" type="radio" checked="" value="1">--%>
                    <%--<input name="sex" title="选择录入" type="radio" value="0">--%>
                <%--</div>--%>
            <%--</div>--%>
            <div class="layui-form-item">
                <label class="layui-form-label">该属性值录入方式</label>
                <div class="layui-input-block">
                    <input name="entry_mode" lay-filter="entry_mode" title="手工录入" type="radio" value="1">
                    <input name="entry_mode" lay-filter="entry_mode" title="从下面的列表中选择(一行代表一个可选值)" type="radio" value="2">
                </div>
            </div>

            <div class="layui-form-item" style="display:none;" id="propertiesDiv">
                <label class="layui-form-label"></label>
                <div class="layui-input-block">
                    <label class="layui-form-label">属性值</label>
                    <textarea  width="500" height="300" placeholder="一行代表一条可选值，请用回车换行" class="layui-textarea"></textarea>
                </div>
            </div>
            <div class="layui-form-item" style="display:none;" id="writerDiv">
                <label class="layui-form-label"></label>
                <div class="layui-input-block">
                    <label class="layui-form-label">属性值</label>
                    <input type="text" name="entry_modeValue" id="entry_modeValue"/>
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit="" lay-filter="demo1" id="goodsProperty_Add">确定</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>


    </div>


</div>



<%@ include file="/common/footer.jsp"%>