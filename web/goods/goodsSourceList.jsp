<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/menu.jsp" %>

<script>
    //JavaScript代码区域
    layui.use(['layer', 'table', 'element'], function () {

        var $ = layui.jquery;
        var layer = layui.layer; //弹层
        var element = layui.element; //元素操作
        var form = layui.form;
        var table = layui.table;

        //执行一个 table 实例
        table.render({
            elem: '#goodsSourceList'
            , height: 'full-192'
		    , cellMinWidth: 190
            , url: '${ctx}/goods?method=getGoodsSourceList' //数据接口
            , page: true //开启分页
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1  //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left', field: "ids",align:'center'}
                , {field: 'dict_data_name', title: '商品渠道来源',align:'center'}
                , {field: 'dict_data_value',  title: '来源编码',align:'center'}
                , {field: 'memo',  title: '备注',align:'center'}
                , {field: 'nick_name',  title: '最后操作者',align:'center'}
                , {field: 'edit_time',  title: '最后编辑时间',align:'center',templet:function (d) {
						if(d.edit_time==""){
						    return "———";
						}else{
						    return "20"+d.edit_time;
						}
                    }}
                , {field: 'wealth', width: 250, fixed: 'right', align: 'center', title: '操作', toolbar: "#barDemo"}
            ]]
        });

        //监听启用禁用操作
        form.on('switch(fixedFilter)', function (obj) {
            var othis = $(this)
                , status = (othis.data('method') ? 0 : 1)
                , id = this.value;

            var that = obj.othis;
            $.ajax({
                type: "get",
                url: "${ctx}/goods",
                data: "method=updateGoodsSourceStatus&status=" + status + "&id=" + id,
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

        //监听启用操作
        form.on('checkbox(lockDemo)', function (obj) {
            layer.tips(this.value + ' ' + this.name + '：' + obj.elem.checked + obj.elem.title, obj.othis);
        });

        //点击按钮
        $('#btnDemo').on('click', function () {
            var text = "Demo Demo";
            layer.open({
                type: 1
                , title: '添加商品来源'
                , id: 'layerDemo'
                , area: ['400px']
                , content: $('#openDemo')
                //,btn: '关闭'
                , btnAlign: 'c' //按钮居中
                ,shade: 0 //不显示遮罩
                , yes: function () {
                    layer.closeAll();
                }
            });
        });


        //点击按钮 保存商品来源
        $('#saveGoodsSourceBtn').on('click', function () {
            var url = "${ctx}/goods";
            var sourceName = $("#sourceName").val();
            var sourceCode = $("#sourceCode").val();
            var memo = $("#memo").val();
            //layer.msg(url+ encodeURI($("#sourceName").val()))

            //校验
            if (sourceName.length < 2) {
                layer.msg('来源名称至少得2个字符');
            } else {
                $.ajax({
                    type: "get",
                    url: url,
                    data: "method=addGoodsSource&sourceName=" + encodeURI(sourceName) + "&sourceCode=" + encodeURI(sourceCode) + "&memo=" + encodeURI(memo),
                    cache: false,
                    async: false,
                    dataType: "json",
                    success: function (data) {

                        if (data.result == "fail") {
                            layer.msg("添加商品来源失败，可能商品来源编码已存在，请检查！");
                        } else {
                            layer.msg('成功添加商品来源', {time: 2000}, function () {
                                //do something
                                window.location.reload();
                            });
                        }

                    },
                    error: function () {
                        layer.msg('添加商品来源失败', {time: 2000}, function () {
                            // //do something
                            // window.location.reload();
                        });
                    }
                });

            }
            return false;
        });

    });
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <div style="padding:5px 5px 0px 5px">
        <div class="layui-elem-quote" >
            商品来源
        </div>
        <button id="btnDemo" data-method="offset" data-type="auto" class="layui-btn layui-btn-sm"><i class="layui-icon">&#xe61f;</i>添加商品来源</button>

        <table class="layui-hide" id="goodsSourceList"></table>

        <script type="text/html" id="barDemo">
            <input type="checkbox" name="is_fixed" value="{{d.id}}" lay-skin="switch" lay-text="启用|禁用"
                   data-method="{{d.is_fixed}}" lay-filter="fixedFilter" {{ d.is_fixed== 1 ? 'checked' : '' }}>
        </script>
    </div>


	<div id="openDemo" style="display: none; padding: 15px;">
		<form class="layui-form layui-form-pane" action="">
			<div class="layui-form-item">
				<label class="layui-form-label">来源名称:</label>
				<div class="layui-input-block">
					<input type="text" name="sourceName" lay-verify="required" placeholder="请输入名称" autocomplete="off" class="layui-input">
				</div>
			</div>

			<div class="layui-form-item">
				<label class="layui-form-label">来源编码:</label>
				<div class="layui-input-block">
					<input id="sourceCode" name="sourceCode" autocomplete="off" placeholder="建议填写拼音或名称首字母" class="layui-input" type="text">
				</div>
			</div>

			<div class="layui-form-item">
				<label class="layui-form-label">备注:</label>
				<div class="layui-input-block">
					<input id="memo" name="memo" autocomplete="off" placeholder="" class="layui-input" type="text">
				</div>
			</div>
			<div class="layui-form-item">
                <div class="layui-input-block">
                    <button id="saveGoodsSourceBtn" class="layui-btn" >保存</button>
                </div>
            </div>
		</form>
	</div>
	<%@ include file="/common/footer.jsp" %>
</div>