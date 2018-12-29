<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/common.jsp" %>
<form class="layui-form">
    <div class="layui-form-item">
        <table class="layui-table" lay-filter="goodsInfoTab1">
            <div class="layui-row" style="margin-left: 40px">
                <div class="layui-col-xs3">
                    <div class="grid-demo grid-demo-bg1">
                            <input id="order_id" lay-verify="title" autocomplete="off" class="layui-input" type="hidden" value="" name="order_id">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">订单编号</label>
                <div class="layui-input-block" style="width: 230px;margin-top: 10px">
                    <input id="order_no"  class="layui-input" type="text" name="order_no">
                </div>
            </div>
        </table>
    </div>

    </div>
        <div class="layui-form-item">
            <label class="layui-form-label">运单号</label>
            <div class="layui-input-block" style="width: 230px">
                <input name="logistics_numbers" lay-verify="required" autocomplete="off" class="layui-input" type="text" id="logistics_numbers">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-block" style="width: 230px">
                <textarea class="layui-textarea" lay-verify="required" name="memo" id="memo"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-sm layui-btn-normal" lay-submit=""  style="width: 80px" id="saveLogisticsBtn">确认</button>
            </div>
        </div>
    </div>
</form>


<script>
    //监听提交
    $('#saveLogisticsBtn').on('click', function () {
    //form.on('submit(save)', function(data){
        $.ajax({
            url: "${ctx}/order?method=addLogistic",
            data: {"jsonData":JSON.stringify($('form').serializeObject())},
            contentType:"application/json",  //缺失会出现URL编码，无法转成json对象
            cache: false,
            async: false,
            dataType: "json",
            success:function(data) {
                debugger;
                window.parent.location.reload();
                var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index)
            },
            error : function() {
                layer.alert("子页面 错误");
            }
        });
        return false;
    });



    layui.use(['form', 'layedit', 'laydate'], function(){
        var form = layui.form
            ,layer = layui.layer
            ,layedit = layui.layedit
            ,laydate = layui.laydate;
        var $ = layui.jquery;

        //日期
        laydate.render({
            elem: '#date'
        });
        laydate.render({
            elem: '#date1'
        });
    });

</script>


