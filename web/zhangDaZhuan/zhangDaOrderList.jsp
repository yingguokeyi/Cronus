<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/common.jsp" %>
<%@ include file="/common/zhangdazhuan_menu.jsp" %>

<script>
    layui.use(['laydate', 'layer', 'table', 'element'], function () {
        var laydate = layui.laydate; //日期
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        table.render({
            elem: '#orderList'
            , height: 710
            , url: '${ctx}/order?method=getzhangdzOrder'
            , cols: [[
                {type:'numbers',fixed: 'true',align:'center'}
                ,{type: 'checkbox', fixed: 'left', field: "id"}
                ,{field: 'goods_id', title: '', width: 5,style:'display:none;'}
                , {field: 'order_no', width: 200, title: '录入回填单号',align:'center', templet: '#idTpl'}
                , {field: 'img_path', width: 240, title: '回填单截图',align:'center',templet: '#imgPath'}
                , {field: 'status', width: 150, title: '状态',align:'center',templet: '#statusd'}
                , {field: 'create_date', width: 200, title: '录入时间',align:'center',templet: '#create_timeTpl'}
                , {field: 'phone', width: 200, title: '注册人手机号',align:'center',templet: '#phoneTpl'}
                , {field: 'goods_name', width: 200, title: '商品名称',align:'center',templet: '#goodsName'}
                , {field: 'operator_time', width: 200, title: '用户下单时间',align:'center',templet: '#create_timeTp2'}
                , {field: 'remark', width: 200, title: '用户备注',align:'center',templet: '#remark'}
                , {field: 'wealth', width: 260, fixed: 'right', align: 'center', title: '操作', toolbar: "#operation"}
            ]]
            , id: 'testReload'
            , page: true
            , limit: 100
            , limits: [50,100, 500, 100]
            , response: {
                statusName: 'success'
                , statusCode: 1
                , msgName: 'errorMessage'
                , countName: 'total'
                , dataName: 'rs'
            },
        });
        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        //日期时间选择器
        laydate.render({
            elem: '#price_min'
            ,type: 'datetime'
        });
        //日期时间选择器
        laydate.render({
            elem: '#price_max'
            ,type: 'datetime'
        });
        //点击按钮 搜索商品
        $('#searchBtn').on('click', function () {
            var order_no = $('#order_no');
            var goodsName = $('#goodsName');
            var phone = $('#phone');
            var status = $('#status');
            var price_min= $('#price_min');
            var price_max= $('#price_max');
            table.reload('testReload', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    orderNo: order_no.val(),
                    goodsName:goodsName.val(),
                    phone:phone.val(),
                    price_min:price_min.val(),
                    price_max:price_max.val(),
                    status: status.val()
                }
            });
            return false;
        });

        //监听工具条
        table.on('tool(orderlist)', function (obj) {
             if (obj.event === 'edit') {
                var data = obj.data;
                var goodsId = data.goods_id;
                var remark = data.remark;
                var ids = data.id;
                 var orderNo = data.order_no;
                 var img_path = data.img_path;
                 layer.open({
                     type: 1
                     , title: ['编辑回填单', 'font-size: 20px']
                     , offset: 'auto'
                     , id: 'Assignment_Task_Manage'
                     , area: ['980px', '780px']
                     , content: $('#Assignment_Task_Div')
                     //,btn: '关闭'
                     , shade: 0 //不显示遮罩
                     , btnAlign: 'c' //按钮居中
                     , yes: function () {
                         layer.closeAll();
                     }
                     , success: function () {
                         $.ajax({
                             type: "get",
                             async: false, // 同步请求
                             cache: true,// 不使用ajax缓存
                             contentType: "application/json",
                             url: "${ctx}/goods",
                             data: "method=getZhangDZGood",
                             dataType: "json",
                             success: function (data) {
                                 var array = data.rs;
                                 if (array.length > 0) {
                                     $("#goodsId").html("");
                                     for (var obj in array) {
                                         $("#goodsId").append("<option value='" + array[obj].id + "'>" + array[obj].sku_name + "</option>");
                                     }
                                 }
                             },
                             error: function () {
                                 layer.alert("错误");
                             }
                         });

                     }
                 });
                $("#orderNoId").val(orderNo);
                $("#goodsId").val(goodsId);
                $("#spuIds").val(ids);
                $("#remarkId").val(remark);
                $("#imgId").attr('src',img_path);
                return false;
            }
        });
    });

    //导出
    function exportOrder() {
        var exportData = "";
        var order_no = $('#order_no').val();
        var goodsName = $('#goodsName').val();
        var status = $('#status').val();
        var phone = $('#phone').val();
        var price_min = $('#price_min').val();
        var price_max = $('#price_max').val();
        if(order_no!=""){
            exportData = "&order_no="+order_no
        }
        if(goodsName!=""){
            exportData = "&goodsName="+goodsName
        }
        if(status!=""){
            exportData = "&status="+status
        }
        if(phone!=""){
            exportData = exportData+"&phone="+phone
        }
        if(price_min!=""){
            exportData =exportData+ "&price_min="+price_min
        }
        if(price_max!=""){
            exportData =exportData+ "&price_max="+price_max
        }
        var url = "${ctx}/createSimpleExcelToDisk?method=exportZhangDZOrderExcel";
        if(exportData != "")
            url =url+exportData;
        window.location.href= url;
    }
</script>
<script id="create_timeTpl" type="text/html">
    {{#  if(d.create_date !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.create_date.substr(0,2) }}-{{ d.create_date.substr(2,2) }}-{{ d.create_date.substr(4,2) }} {{ d.create_date.substr(6,2) }}:{{ d.create_date.substr(8,2) }}:{{ d.create_date.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>
<script id="create_timeTp2" type="text/html">
    {{#  if(d.operator_time !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.operator_time.substr(0,2) }}-{{ d.operator_time.substr(2,2) }}-{{ d.operator_time.substr(4,2) }} {{ d.operator_time.substr(6,2) }}:{{ d.operator_time.substr(8,2) }}:{{ d.operator_time.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;">----</span>
    {{#  } }}
</script>

<script type="text/html" id="phoneTpl">
    {{# if(d.phone ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.phone}}
    {{# } }}
</script>
<script type="text/html" id="imgPath">
    {{# if(d.img_path ==''){}}
    无截图
    {{# }else if(d.status ==0){ }}
    <img lay-event="edit" src={{d.img_path}} height="50" width="80">
    {{# }else if(d.status == 1 || d.status == 2 || d.status == 3){ }}
    <img src={{d.img_path}} height="50" width="80">
    {{# } }}
</script>
<%--状态--%>
<script type="text/html" id="statusd">
    {{# if(d.status ==0){}}
    <span >待处理</span>
    {{# }else if(d.status ==1){ }}
    <span >已完成</span>
    {{# }else if(d.status ==2){ }}
    <span >已失效</span>
    {{# }else if(d.status ==3){ }}
    <span >用户退款</span>
    {{# } }}
</script>

<%--<script type="text/html" id="phoneTpl">
    {{# if(d.phone ==''){}}
    <span style="color: rgba(10,10,10,0.46);text-align: center;width: 100%;height: 100%;display: inline-block;"> ----</span>
    {{# }else { }}
    {{d.phone}}
    {{# } }}
</script>--%>

<script>
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#submission_time'
        });
        //常规用法
        laydate.render({
            elem: '#created_date'
        });
    });

</script>
<script type="text/html" id="idTpl">
    <a href="#" onclick="Foo('{{d.order_no}}','{{d.id}}')" class="a" style="color: #003399">{{ d.order_no }}</a>
</script>

<script type="text/html" id="operation">
    {{#  if(d.img_path == '' || d.status == 1 || d.status == 2 || d.status == 3){ }}
    <a  style="color: grey">编辑</a>
    {{#  } else if(d.state !== '') { }}
    <a  lay-event="edit" style="color: blue">编辑</a>
    {{#  } }}
</script>
<script>
    //保存编辑的回填单
    function addGoods() {
        //document.getElementById("buttonId0").setAttribute("disabled", true);
        var orderNo = $('#orderNoId').val();
        var goodsName = $('#goodsId').val();
        var orderId = $('#spuIds').val();
        var remark = $('#remarkId').val();
        $.ajax({
            type: "post",
            async: false, // 同步请求
            cache: true,// 不使用ajax缓存
            contentType: "application/json",
            url: "${ctx}/order?method=updateZdzOrder&orderNo="+orderNo+"&orderId="+orderId+"&goodsName="+goodsName+"&remark="+remark,
            dataType: "json",
            success: function (data) {
                if(data.state == 0){
                    layer.msg(data.msg);
                }else {
                 //layer.alert("成功");
                  window.location.reload();
                }
            },
            error: function () {
                layer.alert("错误");
            }
        })
    };
    //取消按钮
    function closes() {
        window.location.reload();
    }
</script>

    <div class="layui-body">
        <div style="padding:5px 5px 0px 5px">
            <div class="layui-elem-quote">掌小龙回填单管理</div>
            <form class="layui-form layui-form-pane">
                <div style="background-color: #f2f2f2;padding:5px 0">
                    <div class="layui-form-item" style="margin-bottom:5px">
                        <label class="layui-form-label">回填单号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="orderNo" id="order_no">
                        </div>

                        <label class="layui-form-label">商品名称</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="goodsName" id="goodsName">
                        </div>

                        <label class="layui-form-label">订单状态</label>
                        <div class="layui-input-inline" style="width: 150px">
                            <select class="layui-select" name="status" id="status" lay-filter="aihao">
                                <option value="" selected="selected">全部</option>
                                <option value="0">待处理</option>
                                <option value="1">已完成</option>
                                <option value="2">已失效</option>
                                <option value="3">用户退款</option>
                            </select>
                        </div>

                        <label class="layui-form-label">注册手机号</label>
                        <div class="layui-input-inline">
                            <input autocomplete="off" class="layui-input" type="text" name="phone" id="phone">
                        </div>

                        <label class="layui-form-label" style="width: 150px">用户录入时间</label>

                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_min" id="price_min" placeholder="开始日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>

                        <div class="layui-form-mid">-</div>
                        <div class="layui-input-inline" style="width: 150px" >
                            <input lay-verify="date" name="price_max" id="price_max" placeholder="结束日期" autocomplete="off" class="layui-input" type="text" placeholder="yyyy-MM-dd HH:mm:ss">
                        </div>
                        <button id="searchBtn"  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe615;</i>搜索</button>
                        <button  class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px" type="reset"><i class="layui-icon">&#x2746;</i>重置</button>
                    </div>

                </div>
            </form>
            <div style="margin-top: 5px">
                <button id="exportSearch" onclick="exportOrder()" class="layui-btn layui-btn-sm" style="margin-top: 5px;margin-left: 10px"><i class="layui-icon">&#xe67c;</i>导出回填单</button>
                <button type="button" class="layui-btn layui-btn-sm" style="margin-top:5px;" id="importSearch">导入回填单</button>
                <button type="button" class="layui-btn layui-btn-sm" style="margin-top:5px;" value="上传回填单"
                        onclick="settime(this)" id="test9">
                    开始上传
                </button>
            </div>
            <table class="layui-table" id="orderList" lay-filter="orderlist"></table>
        </div>
        <!-- 编辑回填单 -->
        <div id="Assignment_Task_Div" style="display: none; overflow: hidden">
            <div style="float: left; width: 47%;">
                <p style="margin-left: 18px; margin-bottom: 5px;">回填单截图:</p>
                <div class="layui-inline">
                <img src="" id="imgId" height="700" width="100%" style="margin-left: 4%;">
                </div>
            </div>
            <div style="display:inline-block; padding: 15px;margin-left: 20px; float:right; width: 47%; vertical-align: middle" >
                <div class="layui-inline">
                    <div style="margin-bottom: 10px;">
                    <label>填写订单号:</label>
                    <div class="layui-inline">
                        <input <%--class="layui-input"--%> name="orderNo" id="orderNoId" onkeyup="value=value.replace(/[^\d]/g,'')" maxlength="18" size="30">
                    </div>
                    </div>
                    </br>
                    <div style="margin-bottom: 10px;">
                    <label>选择商品:</label>
                    <div class="layui-inline">
                        <select <%--class="layui-select"--%> style="width: 260px" autocomplete="off" name="goodsName"
                                id="goodsId" >
                            <%--<option value="" >请选择</option>--%>
                        </select>
                    </div>
                    </div>
                    </br>

                    </br>
                    <div style="margin-bottom: 10px;">
                    <label>添加备注:</label>
                    </br>
                    <div class="layui-input-inline" style="width: 500px">
                        <textarea style="width: 350px;height: 100px" id="remarkId" name="remark"></textarea>
                    </div>
                    </div>
                    <input type="hidden" name="spuIds" value ="" id="spuIds" style="margin-top: 100px;width: 200px;height: 35px;"/>
                    <button class="layui-btn layui-btn-sm" id="buttonId0" onclick="addGoods()" style="width: 100px; margin-left: 72px;margin-top: 20px">确认</button>
                    <button class="layui-btn layui-btn-sm" onclick="closes()" style="width: 100px;margin-top: 20px">取消</button>
                </div>
            </div>
        </div>
    </div>
<%--上传回填单功能--%>
<script type="application/javascript">
    function subtraction(count) {
        var countdown = count;
        return countdown;
    }

    function settime(val) {
        var countdown = subtraction('');
        if (countdown == '') {
            countdown = 300;
        }
        console.log("    countdown   " + countdown);
        if (countdown == 0) {
            val.removeAttribute("disabled");
            val.value = "可以开始上传EXCEL 支持格式后缀为xls和xlsx 请注意查看";
            // layer.msg(val.value);
            layer.msg(val.value,{time:30*1000},function() {
//回调
            })
        } else {
            val.setAttribute("disabled", true);
            val.value = "系统正在努力加载EXCEL中..请稍等";
            // layer.msg(val.value);
            layer.msg(val.value,{time:300*1000},function() {
//回调
            })
        }
        // setTimeout(function () {
        //     settime(val)
        // }, 1000)
    }

    layui.use('upload', function () {
        var $ = layui.jquery
            , upload = layui.upload;
        var layer = layui.layer;
        //指定允许上传的文件类型
        <%--upload.render({--%>
        <%--elem: '#importSearch'--%>
        <%--, url: '${ctx}/purchaseOrderImport?method=uploadExcel'--%>
        <%--, accept: 'file' //普通文件--%>
        <%--, done: function (res) {--%>
        <%--console.log("  res   " + res.msg);--%>
        <%--layer.msg(res.msg);--%>
        <%--//setTimeout(6000,navigators());--%>
        <%--}--%>
        <%--});--%>

        //选完文件后不自动上传
        upload.render({
            elem: '#importSearch'
            , url: '${ctx}/zdzOrderImport?method=zdzExcrlImport'
            , accept: 'file' //普通文件
            , auto: false
            //,multiple: true
            , bindAction: '#test9'
            , done: function (res) {
                console.log("  res   " + res.msg);
                layer.msg(res.msg);
                subtraction(0);
                $('#test9').attr("disabled", false);
            }
        });

    });

    function navigators() {
        window.location.href = "zhangDaOrderList.jsp";
    }

</script>
    <%@ include file="/common/footer.jsp" %>