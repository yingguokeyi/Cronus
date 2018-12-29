<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/finance/menu_finance.jsp"%>
<%
    String user_id = request.getParameter("user_id");
    String id = request.getParameter("id");

%>


<script>
    var id = <%=id%>
    var user_id = <%=user_id%>

    layui.config({

        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    layui.use('table', function(){
        var table = layui.table;
        table.render({
            elem: '#withdrawalsList'
            ,url:'${ctx}/finance?method=WithdrawShowdetail&user_id=' + <%=user_id%>
            ,cellMinWidth: 200 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,height: 530
            ,page:true
            ,cols: [[
                {type:'numbers',fixed: 'true'}
                ,{field:'create_time', width:180, title: '申请时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.create_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.create_time.substr(0, 2) + "-" + d.create_time.substr(2, 2) + "-" + d.create_time.substr(4, 2) + " " + d.create_time.substr(6, 2) + ":" + d.create_time.substr(8, 2) + ":" + d.create_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'status', title: '处理状态',align: 'center',width:'150',templet:'#status'}
                , {
                    field: 'money', title: '可提现账户总金额(元)', align: 'center', width: '170', templet: function (d) {
                        var num = "";
                        if (Number(d.money) == '') {
                            num = 0;
                        } else {
                            num = Number((d.money / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }
                }
                , {
                    field: 'totalPreIncome', title: '当前预估总金额（元）', width: 170, templet: function (d) {
                        var num = "";
                        if (Number(d.totalPreIncome) == '') {
                            num = 0;
                        } else {
                            num = Number((d.totalPreIncome / 100).toFixed(2));
                        }
                        return '￥' + num;
                    }
                }
                ,{field: 'amount',title: '申请提现金额(元)',align: 'center',templet: function (d) {
                        var num = Number((d.amount / 100).toFixed(2));
                        return '￥' + num;
                    }
                }
                ,{field:'withdrawals_on', title: '提现单号',align:'center',width:'150'}
                ,{field:'withdrawals_way_key', title: '打款方式', align:'center',templet:'#withdrawals_way_key'}
                ,{field:'remarks', title: '决绝原因',align:'center',width:'150'}
                ,{field:'edit_time', width:180, title: '最后操作时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'operator', title: '最后处理人',align:'center',width:'150'}
            ]]
            ,response: {
                statusName: 'success' //数据状态的字段名称，默认：code
                ,statusCode: 1 //成功的状态码，默认：0
                ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                ,countName: 'total' //数据总数的字段名称，默认：count
                ,dataName: 'rs' //数据列表的字段名称，默认：data
            }
        });

        var $ = layui.$, active = {
            reload: function(){
                //执行重载
                table.reload('listReload', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        key: {
                            username: userName.val()
                        }
                    }
                });
            }
        };

        $("#phone").val("11111");


        var user_id = <%=user_id%>
            $(document).ready(function(){
                $.ajax({
                    //几个参数需要注意一下
                    type: "post",//方法类型
                    dataType: "json",//预期服务器返回的数据类型
                    url: "${ctx}/finance?method=Getpeople" ,//url
                    async : true,
                    data: {user_id:user_id},
                    success:function(res){
                        var nick_name=res.rs[0].nick_name;
                        var member_level=res.rs[0].member_level;
                        var phone=res.rs[0].phone;
                        document.getElementById("nick_name").innerHTML=(nick_name);
                        if(member_level==1){
                            document.getElementById("member_level").innerHTML=("会员");
                        }else{
                            document.getElementById("member_level").innerHTML=("非会员");
                        }

                        document.getElementById("phone").innerHTML=(phone);
                    },
                    error:function(){
                        alert("获取该用户信息失败，该用户不存在");
                        layer.closeAll();
                    },
                });
            });
    });

</script>

<script type="text/html" id="status">

    {{# if(d.status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.status =='1'){}}
    <span style="color:#FF0000; ">未处理</span>
    {{# }else if(d.status =='2'){ }}
    已同意
    {{# }else if(d.status =='3'){ }}
    已拒绝
    {{# }else if(d.status =='4'){ }}
    已作废
    {{# }else if(d.status =='5'){ }}
    已提现
    {{# }else if(d.status =='6'){ }}
    提现失败
    {{# } }}
    {{# } }}
</script>
<script type="text/html" id="withdrawals_way_key">

    {{# if(d.withdrawals_way_key ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.withdrawals_way_key =='1'){}}
    微信钱包
    {{# }else if(d.withdrawals_way_key =='2'){ }}
    银行卡
    {{# }else if(d.withdrawals_way_key =='3'){ }}
    其他
    {{# } }}
    {{# } }}
</script>
<%-- 转时间 --%>
<script id="create_date" type="text/html">
    {{#  if(d.operation_time !== ''){ }}
    <%--<span style="color: rgba(10,10,10,0.46);">{{ d.registration_time.substr(0,2) }}</span>--%>
    <span style="color: rgba(10,10,10,0.46);">20{{ d.operation_time.substr(0,2) }}-{{ d.operation_time.substr(2,2) }}-{{ d.operation_time.substr(4,2) }} {{ d.operation_time.substr(6,2) }}:{{ d.operation_time.substr(8,2) }}:{{ d.operation_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>
<!-- 内容主体区域 -->
<div class="layui-body">
    <div class="layui-row">
        <div style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
            <label style="font-size: 18px;margin-left: 3% ; line-height: 50px" >提现信息详情</label>
            <button class="layui-btn layui-btn-radius" style=" margin-left: 75%" onclick="history.go(-1)">返回</button>
        </div>
        <br>
        <div>
            <label style="font-size: 15px;margin-left: 3% ; line-height: 30px" >联系人信息</label>
            <hr class="layui-bg-gray">
        </div>
        <div style=" height: 50px;margin-top: 10px;margin-left: 100px">

            <div class="layui-inline" >
                姓名：
                <span style="color: red; " id="nick_name" />
            </div>
            <div class="layui-inline" style="position: relative;left:500px;">
                手机号：
                <span style="color: red; " id="phone"/>
            </div>
        </div>
        <div style=" height: 50px;margin-top: 10px;margin-left: 100px">
            会员类型：
            <span style="color: red; " id="member_level"/>
        </div>
    </div>

    <div>
        <div>
            <label style="font-size: 15px;margin-left: 3% ; line-height: 30px" >提现信息</label>
            <hr class="layui-bg-gray">
        </div>
        <div style="margin-left: 20px">
            <table class="layui-table" id="withdrawalsList"  style="visibility: hidden" lay-filter="demo" ></table>
        </div>
    </div>
</div>

