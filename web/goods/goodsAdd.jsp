<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/menu.jsp"%>



<!-- 内容主体区域 -->
<div class="layui-body">

    <blockquote class="layui-elem-quote">
        商品
    </blockquote>


    <form class="layui-form" action="" style="padding: 15px;">
        <div class="layui-form-item">
            <label class="layui-form-label">商品名称</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>

            <label class="layui-form-label">供应商</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>

            <label class="layui-form-label">商品编码</label>
            <div class="layui-input-block">
                <input type="text" name="username" lay-verify="required" placeholder="请输入" autocomplete="off" class="layui-input">
            </div>

        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">商品品牌</label>
            <div class="layui-input-block">
                <input type="text" name="username" lay-verify="required" placeholder="请输入" autocomplete="off" class="layui-input">
            </div>

            <label class="layui-form-label">商品类目</label>
            <div class="layui-input-block">
                <input type="text" name="username" lay-verify="required" placeholder="请输入" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">商品名称</label>
                <div class="layui-input-inline">
                    <input type="tel" name="phone" lay-verify="title" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">商品类目</label>
                <div class="layui-input-inline">
                    <input type="text" name="email" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">商品类目</label>
                <div class="layui-input-inline">
                    <input type="text" name="email"  autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">查询</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>

    </form>


    <div style="padding: 15px;">
        <table class="layui-hide" id="test" lay-filter="demo"></table>


        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>
            <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
        </script>


        <!-- 分页 -->
        <%--<div>--%>
        <%--<div id="pageDemo"></div>--%>
        <%--</div>--%>

    </div>



</div>


<script>

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    //JavaScript代码区域
    layui.use(['laydate', 'laypage', 'layer','table', 'element'], function(){
        var element = layui.element;

        var laydate = layui.laydate //日期
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,element = layui.element; //元素操作

        //监听Tab切换
        element.on('tab(demo)', function(data){
            layer.msg('切换了：'+ this.innerHTML);
            console.log(data);
        });

        //执行一个 table 实例
        table.render({
            elem: '#test'
            ,height: 332
            ,url: '/my-layui/good/getGoodSourceList' //数据接口
            ,page: true //开启分页
            ,cols: [[ //表头
                {field: 'id', title: 'ID', width:80, sort: true, fixed: 'left'}
                ,{field: 'username', title: '用户名', width:80}
                ,{field: 'sex', title: '性别', width:80, sort: true}
                ,{field: 'city', title: '城市', width:80}
                ,{field: 'sign', title: '签名', width: 170}
                ,{field: 'experience', title: '积分', width: 80, sort: true}
                ,{field: 'score', title: '评分', width: 80, sort: true}
                ,{field: 'classify', title: '职业', width: 80}
                ,{field: 'wealth', title: '财富', width: 135, sort: true}
                ,{fixed: 'right', width: 165, align:'center', toolbar: '#barDemo'}
            ]]
        });

        //分页
        // laypage.render({
        //     elem: 'pageDemo' //分页容器的id
        //     ,count: 1000 //总页数
        //     //,limit: 20 //每页显示的条数
        //     //,limits:[10, 20, 30, 40, 50] //每页条数的选择项
        //     ,skin: '#1E9FFF' //自定义选中色值
        //     ,skip: true //开启跳页
        //     ,jump: function(obj, first){
        //         if(!first){
        //             layer.msg('第'+ obj.curr +'页');
        //         }
        //     }
        // });


    });
</script>

