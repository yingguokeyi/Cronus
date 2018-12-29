<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>
<!-- 商品类目级联样式-->
<link rel="stylesheet" type="text/css" href="${ctx}/common/css/goodsCategory.css" />
<script>
    var id="";
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    //JavaScript代码区域
    layui.use(['laydate','upload','layer','table', 'element'], function(){
        var $ = layui.jquery
            ,upload = layui.upload
            ,layer = layui.layer //弹层
            ,form = layui.form
            ,element = layui.element; //元素操作

        //点击按钮 保存商品品牌
        $('#saveBrandBtn').on('click', function(){
            var goodsStyleName = $("#goodsStyleName").val();
            var classifyValue = $("#u3634_input_3").val();
            layer.msg(JSON.stringify($('form').serializeObject()));
            var dataVar="";
            if(id=="" || id==undefined){
                dataVar="method=addGoodsStuleInfo";
            }else{
                dataVar="method=upGoodsStuleInfo";
            }
            //校验
            if(goodsStyleName.length < 1){
                layer.msg('名称不能为空！');
            }else if(classifyValue == null){
                layer.msg('请选择所属类目！');
            }else {
                $.ajax({
                    type: "get",
                    url: "${ctx}/goodsStyle?"+dataVar,
                    data: {
                        "jsonString":JSON.stringify($('form').serializeObject())
                    },
                    contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                    cache: false,
                    async : false,
                    dataType: "json",
                    success:function(data) {
                        if(data.success){
                            layer.msg('成功添加商品类型',{time:2000}, function(){
                                //do something
                                window.location.href = "${ctx}/goods/goodsTypeList.jsp";
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


        /**
         * 自动将form表单封装成json对象
         */
        $.fn.serializeObject = function() {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function() {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [ o[this.name] ];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };
    });


    var u3634_input_2Map = new Map();
    var u3634_input_3Map = new Map();
    var dict_data_value="";

    $(document).ready(function(){
        $.ajax({
            type: "get",
            url: "${ctx}/goodsStyle?method=getGoodsClassifyInfo",
            dataType: "json",//表示后台返回的数据是json对象
            async:true,
            success: function (data) {
                if(data.success == 1) {
                    var array = data.result.rs;
                    for (var obj in array) {
                        if(array[obj].dict_data_value.substr(3, 9) < 1 ){
                            // if(obj!=0 || array[obj-1].dict_data_value.substr(0, 2) != array[obj].dict_data_value.substr(0, 2)){
                                $("#u3634_input_1").append("<option value='"+array[obj].dict_data_value+"'>"+array[obj].dict_data_name+"</option>");
                            // }

                        } else if(array[obj].dict_data_value.substr(6, 9) < 1){
                            u3634_input_2Map.set(array[obj].dict_data_name,array[obj].dict_data_value);
                        }else {
                            u3634_input_3Map.set(array[obj].dict_data_value,array[obj].dict_data_name);
                        }
                    }
                }
            },
            error: function (error) {
                console.log("error=" + error);
            }
        });

        var url = location.search;
        var theRequest = new Object();
        if ( url.indexOf( "?" ) != -1 ) {
            var str = url.substr( 1 ); //substr()方法返回从参数值开始到结束的字符串；
            var strs = str.split( "&" );
            for ( var i = 0; i < strs.length; i++ ) {
                theRequest[ strs[ i ].split( "=" )[ 0 ] ] = ( strs[ i ].split( "=" )[ 1 ] );
            }
            $('#goodsStyleName').val(theRequest.styleName);
            dict_data_value=theRequest.dict_data_value;
            id=theRequest.ids;
            $('#id').val(theRequest.ids);
        }
    });

    function u3634_input_1Change(in_val){
        $("select#u3634_input_3").hide();
        $("select#u3634_input_3").empty();
        $("select#u3634_input_2").empty();
        $("select#u3634_input_2").hide();

        u3634_input_2Map.forEach(function (value, key, map) {
            if(value.substr(0, 3)==in_val.substr(0, 3)){
                $("#u3634_input_2").append("<option value='"+value+"'>"+key+"</option>");
                $("select#u3634_input_2").show();
            // }else{
            //     $("select#u3634_input_2").hide();
            }
        });

    }

    function u3634_input_2Change(in_val){
        $("select#u3634_input_3").empty();
        $("select#u3634_input_3").hide();

        u3634_input_3Map.forEach(function (value, key, map) {
            if(key.substr(0, 6)==in_val.substr(0, 6)){
                $("#u3634_input_3").append("<option value='"+key+"'>"+value+"</option>")
            }
        })
        $("select#u3634_input_3").show();
    }



</script>


<!-- 内容主体区域 -->
<div class="layui-body">

    <div style="padding: 15px;">
        <blockquote class="layui-elem-quote"style="margin-top: -10px">
            添加商品类型
            <button class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" style="margin-left: 70%" onclick="javascript:history.go(-1);">返回</button>
        </blockquote>
        <form style="margin-top: 20px">
            <input type="hidden" name="id" id="id">
            <div>
                <label class="layui-form-label"><label style="color: red">*</label>类型名称:</label>
                <div  style="margin-left: 150px">
                    <input type="text" style="width: 500px; " value=""  id="goodsStyleName" name="goodsStyleName" placeholder="请输入名称" class="layui-input">
                </div>
            </div>
            <label class="layui-form-label"><label style="color: red">*</label>所属类目:</label>
            <div style="width: 1400px;height: 450px;background-color: #f2f2f2;margin: 0 auto; margin-top: 20px">
                <div style="border:1px solid black;width: 1200px;height: 400px;position: relative;left: 100px;top: 25px;background-color: white">
                    <div id="u3634_1" class="ax_default,_列表框">
                        <select id="u3634_input_1" size="2" tabindex="0" onchange="u3634_input_1Change(this.value)">
                        </select>
                    </div>
                    <div id="u3634_2" class="ax_default,_列表框">
                        <select id="u3634_input_2" size="2" tabindex="0" hidden="hidden" onchange="u3634_input_2Change(this.value)">
                        </select>
                    </div>
                    <div id="u3634_3" class="ax_default,_列表框" >
                        <select id="u3634_input_3" name="classifyValue" autocomplete="off" hidden="hidden" size="2" tabindex="0">
                        </select>
                    </div>
                </div>
            </div>
            <br>
            <div class="layui-form-item">
                <div class="layui-input-block" align="center">
                    <button id="saveBrandBtn" class="layui-btn layui-btn-normal">确定</button>
                    <button class="layui-btn layui-btn-primary" type="reset">重置</button>
                </div>
            </div>
        </form>
    </div>
</div>


<div class="layui-footer">
    <%@ include file="/common/footer.jsp"%>
</div>