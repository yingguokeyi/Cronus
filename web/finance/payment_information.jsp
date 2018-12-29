<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../common/header.jsp" %>
<%@include file="menu_finance.jsp" %>

<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
        <div class="layui-elem-quote" style="margin-top: 3px;background-color: #EEEEEE">
            <label>提现管理</label>

        </div>
        <table class="layui-table" id="withdrawalsList" lay-filter="withdrawals"></table>
    </div>




<%@ include file="/common/footer.jsp" %>




<script type="text/html" id="barDemo">
    <button lay-event="agree"
            style="height: 20px;line-height: 20px;width:50px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">
        修改
    </button>

</script>
<script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
    layui.use('table', function () {
        var table = layui.table;
        //列表加载
        table.render({

            elem: '#withdrawalsList'
            , url: '${ctx}/finance?method=getpayment'
            , cellMinWidth: 200 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , height: 650
            , page: true
            , cols: [[
                {type: 'numbers', fixed: 'true'}
                , {type: 'checkbox', fixed: 'true'}
                , {field: 'company_name', title: '公司名称', align: 'center', sort: true, fixed: true, width: '250'}
                , {field: 'account_name', title: '户名', sort: true, align: 'center', fixed: true, width: '200'}
                , {field: 'account_num', title: '账号', align: 'center', width: '200'}
                , {field: 'bank_name', title: '开户行', align: 'center', width: '250'}
                , {fixed: 'right', title: '操作', width: 300, align: 'center', toolbar: "#barDemo"}
            ]]
            , page: true
            , response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                , statusCode: 1 //成功的状态码，默认：0
                , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                , countName: 'total' //数据总数的字段名称，默认：count
                , dataName: 'rs' //数据列表的字段名称，默认：data
            }
        });

        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        //监听工具条
        table.on('tool(withdrawals)', function (obj) {
            var data = obj.data;
            if (obj.event === 'agree') {
                layer.open({
                    type: 1
                    , title: data.company_name + "汇款信息编辑"
                    , area: ['390px', '260px']
                    , content: '<ul class=""  lay-filter="test">'
                    + '<li class="layui-nav-item"> <label class="layui-form-label">户名</label>' +
                    '                    <div class="layui-input-block">' +
                    '                        <input name="title" id="account_name" value=' + data.account_name + ' class="layui-input" type="text" style="width:90% ;border-color: #0C0C0C"> ' +
                    '                    </div></li>'
                    + '<li class="layui-nav-item"><label class="layui-form-label">账户</label>' +
                    '                                     <div class="layui-input-block">' +
                    '                                         <input name="title" id="account_num" value=' + data.account_num + ' class="layui-input" type="text" style="width:90% ;border-color: #0C0C0C">' +
                    '                                     </div></li>'
                    + '<li class="layui-nav-item"><label class="layui-form-label">开户行</label>' +
                    '                                      <div class="layui-input-block">' +
                    '                                       <input name="title" id="bank_name" value=' + data.bank_name + ' class="layui-input" type="text" style="width:90% ;border-color: #0C0C0C">' +
                    '                                    </div></li>'
                    + '<li class="layui-nav-item"><hr class="layui-bg-gray"></li>'
                    , btn: '确认'
                    , btnAlign: 'c' //按钮居中
                    , shade: 0 //不显示遮罩
                    , yes: function () {

                        var company_name = data.company_name;
                        var account_name = $("#account_name").val();
                        var account_num = $("#account_num").val();
                        var bank_name = $("#bank_name").val();
                        $.ajax({
                            //几个参数需要注意一下
                            type: "post",//方法类型
                            dataType: "json",//预期服务器返回的数据类型
                            url: "${pageContext.request.contextPath}/finance?method=updatepayment",//url
                            async: true,
                            data: {
                                company_name: company_name,
                                account_name: account_name,
                                account_num: account_num,
                                bank_name: bank_name
                            },
                            success: function (res) {
                                var obj = JSON.parse(JSON.stringify(res));
                                if (obj.success == 1) {
                                    alert("修改成功");
                                }
                            },
                            error: function () {
                                alert("修改失败");
                            },
                        });
                        return false;
                    }
                });
            }
        });

        function agree(obj) {

        }


    });


</script>
