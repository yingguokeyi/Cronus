<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/common.jsp"%>

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
            <label class="layui-form-label">处理方式</label>
            <div class="layui-input-block" style="width: 230px">
                <select name="dispose_way_key" lay-filter="dispose_way_key" id="dispose_way_key">
                    <option value=""></option>
                    <option value="0">仅退货款</option>
                    <option value="1">退全款</option>
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
            <button class="layui-btn layui-btn-sm layui-btn-normal" style="width: 80px" id="saveDisposeStatusBtn">确认</button>
        </div>
    </div>
    </div>
</form>
<script>
  /*  var orderStatusMap = new Map();*/
    layui.use(['upload','form', 'layedit', 'laydate'], function(){
        var form = layui.form
            ,layer = layui.layer
            ,layedit = layui.layedit
            ,upload = layui.upload
            ,laydate = layui.laydate;
        var $ = layui.jquery;

        //创建一个编辑器
        var editIndex = layedit.build('LAY_demo_editor');
        $('#saveDisposeStatusBtn').on('click', function(){
            $.ajax({
                url: "${ctx}/order?method=upDisposeStatus&id="+id,
                data: {"jsonData":JSON.stringify($('form').serializeObject())},
                contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
                cache:false,
                async : false,
                dataType: "json",
                success:function(data) {
                    var id = $("#id").val();
                    layer.confirm('是否处理？确认后将无法还原', {
                        btn: ['确认','取消'] //按钮
                    }, function(index){
                        layer.close(index);
                        $.ajax({
                            type: "get",
                            async : false, // 同步请求
                            cache :true,// 不使用ajax缓存
                            contentType : "application/json",
                            url : "/cronus/order?method=upProStatus",
                            data:{'id':id},
                            dataType : "json",
                            success : function(data){
                                if (data.success) {
                                    layer.msg("操作成功");
                                    table.reload("test")
                                } else {
                                    layer.msg("异常");
                                }
                            }
                        });

                    },function(){
                        alert("取消");
                    });
                },
                error : function() {
                    layer.alert("子页面 错误");
                }

            });
            /*window.parent.location.reload();
            parent.layer.closeAll('iframe');*/
            return false;
        });
    });

</script>
