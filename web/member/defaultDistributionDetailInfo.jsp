<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${ctx}/common/third-part/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${ctx}/layui/layui.js"></script>
<!-- 内容主体区域 -->
<div class="layui-layer-iframe">
    <div class="layui-row">
        <div style="background-color: #EEEEEE ;height: 20px;margin-top: 10px;margin-left: 10px">
            <label style="font-size: 15px;margin-left: 3% ;height: 60px;margin-top: 20px" >当前位置：分销系统 >  分销设置  > 设置默认分销值</label>
        </div>
        <hr class="layui-bg-gray">
        <br>
        <div style=" height: 50px;margin-top: 10px;margin-left: 100px" id="a">

            <div class="layui-inline" >
                会员类型：
                <select class="layui-select" id="member_type" name="member_type">
                    <option value="0" >请选择会员类型</option>
                    <option value="1" selected="selected">会员</option>
                    <option value="2">非会员</option>
                </select>
            </div>
            <br>
            <div class="layui-inline">
                规则名称：
                <input class="layui-input" type="text" name="dis_name" id="dis_name" placeholder="请输入">
            </div>
            <br>
            <div class="layui-inline">
                顶级分销：
                <input class="layui-input" type="text" id="top_level_ratio" name="top_level_ratio">% &nbsp;<a style="font-size: 15px; color: red ;line-height: 10px"> (注：提成下一级购买的佣金比)</a>
                <br>

            </div>
            <br>
            <div class="layui-inline">
                父级分销：
                <input class="layui-input" type="text" id="parent_ratio" name="parent_ratio">% &nbsp;<a style="font-size: 15px;color: red ; line-height: 10px"> (注：提成下一级购买的佣金比)</a>
                <br>

            </div>
            <br>
            <div class="layui-inline">
                子级分销：
                <input class="layui-input" type="text" id="child_ratio" name="child_ratio">% &nbsp;<a style="font-size: 15px;color: red ; line-height: 10px"> (注：提成下一级购买的佣金比)</a>
                <br>

            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    function selectFunc() {
        var returnJson = {
            "member_type": $("#member_type").val(),
            "dis_name": $("#dis_name").val(),
            "top_level_ratio": $("#top_level_ratio").val(),
            "parent_ratio": $("#parent_ratio").val(),
            "child_ratio": $("#child_ratio").val()
        }
        return returnJson;
    }
</script>