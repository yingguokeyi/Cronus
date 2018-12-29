<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/common/common.jsp" %>
<%@ include file="/advertising/advertising_memu.jsp"%>


<%
    String id = request.getParameter("id");
%>

<script>

    var id = <%=id%>;
    var max_end_time = 0;
    var endTime,intStart,intEnd;


    //JavaScript代码区域
    layui.use(['element','laydate','table'], function(){
        var element = layui.element;
        var laydate = layui.laydate;
        var table = layui.table;
        laydate.render({
            elem: '#start_time'
            ,type: 'datetime'
        });
        laydate.render({
            elem: '#end_time'
            ,type: 'datetime'
        });
        var tableContent = new Array();
        table.render({
            elem: '#test'
            ,url:'${ctx}/advertising?method=getAdvertList&position_id='+ id
            //,width: 1900
            ,height: 580
            ,data : tableContent
            ,cols: [[
                {type:'checkbox', fixed: 'left'}
                ,{field:'id', width:60, title: '编号'}
                ,{field:'advert_num', width:150, title: '广告编号',align:'center'}
                ,{field:'advert_name', width:150, title: '广告名称',align:'center'}
                ,{field:'status', width:150, title: '状态',align:'center',templet: '#StatusAdvertising'}
//                ,{field:'add_time', width:180, title: '添加时间',align:'center',templet:function (d) {
//                    var index="";
//                    if(d.add_time==""){
//                        index="----";
//                    }else {
//                        var index = "20" + d.add_time.substr(0, 2) + "-" + d.add_time.substr(2, 2) + "-" + d.add_time.substr(4, 2) + " " + d.add_time.substr(6, 2) + ":" + d.add_time.substr(8, 2) + ":" + d.add_time.substr(10, 2);
//                    }
//                    return index;
//                }}
                ,{field:'start_time', width:180, title: '有效开始时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.start_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.start_time.substr(0, 2) + "-" + d.start_time.substr(2, 2) + "-" + d.start_time.substr(4, 2) + " " + d.start_time.substr(6, 2) + ":" + d.start_time.substr(8, 2) + ":" + d.start_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'end_time', width:180, title: '有效结束时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.end_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.end_time.substr(0, 2) + "-" + d.end_time.substr(2, 2) + "-" + d.end_time.substr(4, 2) + " " + d.end_time.substr(6, 2) + ":" + d.end_time.substr(8, 2) + ":" + d.end_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'edit_time', width:180, title: '最后操作时间',align:'center',templet:function (d) {
                    var index="";
                    if(d.edit_time==""){
                        index="----";
                    }else {
                        var index = "20" + d.edit_time.substr(0, 2) + "-" + d.edit_time.substr(2, 2) + "-" + d.edit_time.substr(4, 2) + " " + d.edit_time.substr(6, 2) + ":" + d.edit_time.substr(8, 2) + ":" + d.edit_time.substr(10, 2);
                    }
                    return index;
                }}
                ,{field:'operator', width:150, title: '最后操作人',align:'center'}
                ,{fixed:'right',title:'操作', width:180,align:'center', toolbar: "#barDemo"}
            ]]
            ,id: 'listAdvert'
            ,limit:20
            ,limits:[20,30,40,50,100]
            ,page: true
            ,response: {
                statusName: 'success'
                ,statusCode: 1
                ,msgName: 'errorMessage'
                ,countName: 'total'
                ,dataName: 'rs'
            },done: function(res, curr, count){
                var startArray = new Array();
                var endArray = new Array();
                var statusArray = new Array();

                $("[data-field='end_time']").each(function(){
                    endTime = $(this).text();
                    if(endTime !="有效结束时间"){
                        endTime = DateSubString(endTime);
                        if(endTime > max_end_time) {
                            max_end_time = endTime;
                        }
                        endArray.push(endTime);
                    }
                });
                $("[data-field='start_time']").each(function(){
                    var startTime = $(this).text();
                    if(startTime !="有效开始时间"){
                        startTime = DateSubString(startTime);
                        startArray.push(startTime);
                    }
                });
                $("[data-field='status']").each(function(){
                    var statu = $(this).text();
                    if(statu !="状态"){
                        statusArray.push(statu);
                    }
                });
                for (var i=0;i<endArray.length;i++){
                    var nowTime = new Date().Format("yyyy-MM-dd HH:mm:ss");
                    nowTime = Number(DateSubString(nowTime));
                    intStart = Number(startArray[i]);
                    intEnd = Number(endArray[i]);
                    var st = statusArray[i];
                    if(intEnd > nowTime && intStart < nowTime && st.indexOf("启用") > 0){
                        console.log(intStart);
                        console.log(intEnd);
                        $("[data-field='start_time']").each(function(){
                            var aaa = $(this).text();
                            if(aaa !="有效开始时间"){
                                aaa = Number(DateSubString(aaa));
                                if(Number(aaa) == intStart ){
                                    $(this).parent().children("td").css("background","yellow");
                                }
                            }

                        });
                    }
                }
                console.log(res);
                console.log(curr);
                console.log(count);

            }
        });


        //点击按钮 搜索
        $('#sreachBtn').on('click', function(){

            var status = $('#status').val();
            var start_time = $('#start_time').val();
            var end_time = $('#end_time').val();
            if(CompareDate(start_time,end_time)){
                layer.msg("开始时间不能大于结束时间");
                return false;
            }

            table.reload('listAdvert', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                ,where: {
                    status: status,
                    start_time: start_time,
                    end_time: end_time
                }
            });
            return false;
        });

        //批量启用
        $('#status_open').on('click', function(){
            var checkStatus = table.checkStatus('listAdvert');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定启用广告吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/advertising",
                        data: "method=updateAdvertStatus&status=1&ids=" + ids,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("listAdvert");
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    })
                });
            }
            return false;
        });

        //批量停用
        $('#status_shut').on('click', function(){
            var checkStatus = table.checkStatus('listAdvert');
            var data = checkStatus.data;
            var selectCount = data.length;
            if(selectCount==0){
                layer.msg("请选择一条数据！");
                return false;
            };
            if(selectCount >= 1){
                layer.confirm('确定停用广告吗？', function (index) {
                    layer.close(index);
                    var ids = new Array(selectCount);
                    for (var i = 0; i < selectCount; i++) {
                        ids[i] = checkStatus.data[i].id;
                    }

                    $.ajax({
                        type: "get",
                        async: false, // 同步请求
                        cache: true,// 不使用ajax缓存
                        contentType: "application/json",
                        url: "${ctx}/advertising",
                        data: "method=updateAdvertStatus&status=2&ids=" + ids,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                layer.msg("操作成功");
                                table.reload("listAdvert");
                            } else {
                                layer.msg("异常");
                            }
                        },
                        error: function () {
                            layer.alert("错误");
                        }
                    })
                });
            }
            return false;
        });
        //新增广告
        $('#advert_add').on('click', function(){
            <%--var id = <%=id%>;--%>
            window.location.href = '${ctx}/advertising/advertAdd.jsp?&position_id='+ id+'&max_end_time='+max_end_time;
        });


        table.on('tool(positionList)', function(obj){
            var data = obj.data;
            if (obj.event === 'advertEdit') {
                var id = $("#id").val();
                window.location.href = '${ctx}/advertising/advertEdit.jsp?id=' + data.id + '&position_id='+ <%=id%>;
            }
            if (obj.event === 'advertDelete') {
                var id = $("#id").val();
                $.ajax({
                    type: "get",
                    async: false, // 同步请求
                    cache: true,// 不使用ajax缓存
                    contentType: "application/json",
                    url: "${ctx}/advertising",
                    data: "method=delAdvert&id=" + data.id,
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            layer.msg("操作成功");
                            table.reload("listAdvert");
                        } else {
                            layer.msg("异常");
                        }
                    },
                    error: function () {
                        layer.alert("错误");
                    }
                })
            }
        });


    });

    layui.use('laydate', function(){
        var laydate = layui.laydate;
        //时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });

    });
    function CompareDate(d1,d2){
        return ((new Date(d1.replace(/-/g,"\/"))) > (new Date(d2.replace(/-/g,"\/"))));
    }
    function DateSubString(time) {
        var time = time.substring(2,4)+time.substring(5,7)+time.substring(8,10)+time.substring(11,13)+time.substring(14,16)+time.substring(17,19);
        return time;
    }
    Date.prototype.Format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "H+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }

</script>

<%--广告状态--%>
<script type="text/html" id="StatusAdvertising">
    {{# if(d.status ==''){}}
    <span style="color: rgba(10,10,10,0.46);"> ----</span>
    {{# }else { }}
    {{# if(d.status =='1'){}}
    启用
    {{# }else if(d.status =='2'){ }}
    停用
    {{# }else if(d.status =='3'){ }}
    排期中
    {{# } }}
    {{# } }}
</script>

<!-- 操作 -->
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="advertEdit">编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal layui-btn-radius" lay-event="advertDelete">删除</a>
</script>

<!-- 内容主体区域 -->
<div class="layui-body">
    <!-- 上部分查询表单-->
    <div class="main-top" style="padding:5px 5px 0px 5px">

        <div class="layui-elem-quote">
            广告区域设置>>广告位列表>>广告列表
            <button id="return" class="layui-btn layui-btn-sm" onclick="javascript:history.go(-1);"
                    style="margin-left: 1200px;"><i class="layui-icon">&#xe65c;</i>返回
            </button>
        </div>
        <form class="layui-form layui-form-pane" >

            <div style="background-color: #f2f2f2;padding:5px 0">

                <div class="layui-form-item" style="margin-bottom:5px">

                    <label class="layui-form-label">状态：</label>
                    <div class="layui-input-inline" >
                        <select id="status" name="status">
                            <option value="">全部</option>
                            <option value="1">启用</option>
                            <option value="2">停用</option>
                            <option value="3">排期中</option>
                        </select>
                    </div>


                    <label class="layui-form-label">有效时间</label>
                    <div class="layui-input-inline">
                        <input name="start_time" id="start_time" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <div class="layui-form-mid">-</div>

                    <div class="layui-input-inline">
                        <input name="end_time" id="end_time" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                    </div>

                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" id="sreachBtn"><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button class="layui-btn layui-btn-sm" style="margin-top: 5px" data-type="reset" ><i class="layui-icon">&#x2746;</i>重置</button>

                </div>


            </div>

        </form>
        <div style="margin-top: 5px">
            <button id="status_open" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>启用</button>
            <button id="status_shut" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>停用</button>
            <button id="advert_add" class="layui-btn layui-btn-sm" style="margin-top: 5px"><i class="layui-icon">&#xe63c;</i>新增</button>
        </div>


        <!-- 表格显示-->
        <table class="layui-hide" id="test" lay-filter="positionList"></table>

    </div>
</div>

<%@ include file="/common/footer.jsp"%>