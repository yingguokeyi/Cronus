<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/member/huiyuan_menu.jsp" %>

<script>
    //JavaScript代码区域
    layui.use(['element', 'layer'], function () {
        var element = layui.element;
        var $ = layui.jquery, layer = layui.layer;
    });
    /* 表格数据查询*/
    layui.use('table', function () {
        var table = layui.table;
        table.render({
            elem: '#test'
            , url: '${pageContext.request.contextPath}/member?method=getDisableListPage'
            //,width:1550
            , height: 600
            , cols: [[
                {type: 'checkbox', fixed: 'left'}
                // ,{field:'id', width:300, title: 'ID',  fixed: 'left'}
                , {field: 'nick_name', width: 300,align: 'center', title: '禁止注册账户'}
                , {field: 'memo', width: 300,align: 'center', title: '备注'}
                , {field: 'Systemtime', width: 300,align: 'center', title: '最后编辑时间'}
                , {field: 'login_name', width: 300,align: 'center', title: '最后操作人'}
            ]]
            , page: true
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            }
        });
        //点击按钮 搜索商品
        $('#searchBtn').on('click', function () {
            var keywordTep = $('#keyword');
            table.reload('test', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    keyword: keywordTep.val(),
                }
            });
            return false;
        });
    });
    //搜索功能
    /*       function searchForm(){
               var table = layui.table;
               var keywordTep = $('#keyword');
               table.reload('test', {
                   page: {
                       curr: 1 //重新从第 1 页开始
                   }
                   ,where: {
                       keyword: keywordTep.val(),
                   }
               });
               console.log(keyword);
               return false;
           };*/
    //删除
    function del() {
        var table = layui.table;
        var checkStatus = table.checkStatus('test');
        var selectCount = checkStatus.data.length;
        if (selectCount == 0) {
            layer.msg("请选择一条数据！");
            return false;
        }
        ;
        layer.confirm('确定要删除选中的项吗？', function (index) {
            layer.close(index);
            var status = 0;
            var ids = new Array(selectCount);
            for (var i = 0; i < selectCount; i++) {
                ids[i] = checkStatus.data[i].id;
            }
            $.ajax({
                type: "get",
                async: false, // 同步请求
                cache: true,// 不使用ajax缓存
                contentType: "application/json",
                url: "${pageContext.request.contextPath}/aa",
                data: "",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg("操作成功");
                        table.reload("test")
                    } else {
                        layer.msg("异常");
                    }
                }
            })
        })
    };

    //添加
    function addp() {
        var layer = layui.layer;
        layer.open({
            type: 1
            , title: '添加禁止词'
            , id: 'layerDemo'
            , area: ['500px', '420px']
            , content: $('#textarea_add')
            /*  , btn: ['取消', '确认']*/
            , btnAlign: 'c' //按钮居中
            , shade: 0 //不显示遮罩
            , yes: function () {
                layer.closeAll();
            }
        });
    };

    //点击按钮 保存添加禁止词
    function saveKeyWordBtn() {
        var url = "${pageContext.request.contextPath}/member";
        var sourceName = $("#area1").val();
        layer.msg(url + encodeURI($("#area1").val()));

        //校验
        if (sourceName.length < 2) {
            layer.msg('禁用至少得2个字符');
        } else {
            $.ajax({
                type: "get",
                url: url,
                data: "method=addGoodsSource&sourceName=" + encodeURI(sourceName),
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        layer.msg('成功添加禁止词', {time: 2000}, function () {
                            //do something
                            window.location.reload();
                        });

                    } else {
                        layer.msg("异常");
                    }
                },
                error: function () {
                    layer.alert("错误");
                }
            });

        }
    };
</script>

<div class="layui-layout layui-layout-admin">
    <!--主体部分 -->
    <div class="layui-body">
        <div style="padding: 15px;">
            <!-- 上部分查询表单-->
            <div class="layui-elem-quote">
                注册设置
            </div>
            <div class="layui-elem-quote" style="background-color: #EEEEEE">
                <form class="layui-form layui-form-pane" style="margin-top:10px;">
                    <div class="layui-inline">
                        <label class="layui-form-label">关键词</label>
                        <div class="layui-inline">
                            <input type="text" name="keyword" autocomplete="off" id="keyword" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <%-- <div class="layui-input-inline" style="width:400px">--%>
                        <button class="layui-btn layui-btn-sm" style="margin-left:10px;" id="searchBtn"><i
                                class="layui-icon">&#xe615;</i>搜索
                        </button>
                        <button type="reset" class="layui-btn layui-btn-sm"><i class="layui-icon">&#x2746;</i>重置
                        </button>
                        <button class="layui-btn layui-btn-sm" onclick="del()" style="margin-left:10px"><i class="layui-icon">&#xe640;</i>删除
                        </button>
                        <button class="layui-btn layui-btn-sm" onclick="addp()" data-type="auto"><i
                                class="layui-icon">&#xe61f;</i>添加</button>
                        <%-- </div>--%>
                    </div>
                </form>
            </div>
            <div>

            </div>
            <!-- 中部表单 -->
            <%-- <div class="main-top">--%>
            <!-- 表格显示-->
            <table class="layui-hide" id="test"></table>
            <%--</div>--%>
        </div>

        <div style="padding: 20px 100px;height:100px; display: none;" id="textarea_add">
            <textarea name="textarea" id="area1" cols="30" rows="10"></textarea>
            可以设置通配符，每个关键字一行，可使用通配符 "*" 如 "*admin*"(不含引号)。
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button id="result" class="layui-btn layui-btn-normal" lay-filter="saveFilter">取消</button>
                    <button id="saveKeyWordBtn" class="layui-btn" onclick="saveKeyWordBtn()">保存</button>
                </div>
            </div>
        </div>

        <%@ include file="/common/footer.jsp" %>
