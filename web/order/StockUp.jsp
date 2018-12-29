<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/common.jsp"%>
<script>
    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use([ 'layer','element'] , function() {
        var layer = layui.layer //弹层
            , element = layui.element;
    });


</script>
<form class="layui-form">
    <div class="layui-form-item">
        <table class="layui-table" lay-filter="goodsInfoTab1">
            <%-- <label id="goodsTableOrderCode"></label>--%>
            <div class="layui-row" style="margin-left: 40px">
                <div class="layui-col-xs3">
                    <div class="grid-demo grid-demo-bg1">
                        <%-- <label id="id"></label>--%>
                        <input id="id" lay-verify="title" autocomplete="off" class="layui-input" type="hidden" name="id">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">订单编号</label>
                <div class="layui-input-block" style="width: 230px;margin-top: 20px">
                    <input id="order_no"  class="layui-input" type="text" name="order_no">
                </div>
            </div>
    </div>
    </table>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">发货仓库</label>
        <div class="layui-input-block" style="width: 230px">
            <select name="sign" lay-filter="sign" id="sign">
                <option value="0" selected="selected">自营</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block" style="width: 230px">
            <textarea class="layui-textarea" name="memo" id="memo"></textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-sm layui-btn-normal" style="width: 80px" id="saveStatusBtn">确认</button>
        </div>
    </div>
    </div>
</form>
<script>
        //创建一个编辑器
       // var editIndex = layedit.build('LAY_demo_editor');
        $('#saveStatusBtn').on('click', function(){
            layer.confirm('是否确认备货？确认后将无法还原',function(){
                $.ajax({
                    url: "${ctx}/order?method=upStockUp&id="+id,
                    data: {"jsonData":JSON.stringify($('form').serializeObject())},
                    contentType:"application/json",
                    cache:false,
                    async : false,
                    dataType: "json",
                    success:function(data) {
                        if (data.success==1) {
                            layer.msg("操作成功");
                            table.reload("test")
                        } else {
                            layer.msg("异常");
                        }
                    }
                    ,error : function() {
                        layer.alert("子页面 错误");
                    }
                });
            });
        });

</script>
