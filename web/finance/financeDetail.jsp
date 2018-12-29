<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@include file="menu_finance.jsp"%>


<%
    String id = request.getParameter("id");
%>

<head>
    <title>认证审核 </title>
    <script>
        var id = <%=id%>
        //JavaScript代码区域
        layui.use(['element','layer'], function(){
            var element = layui.element;
            var $ = layui.jquery, layer = layui.layer;

            $('#layerDemo').on('click', function(){
                var othis = $(this), method = othis.data('method');
                active[method] ? active[method].call(this, othis) : '';
            });

        });
        layui.use('table', function(){

            var table = layui.table;

            table.render({
                elem: '#test'
                ,url: '${ctx}/finance?method=WithdrawDetail&id='+id //数据接口
                ,height: 650
                ,response: {
                    statusName: 'success' //数据状态的字段名称，默认：code
                    ,statusCode: 1  //成功的状态码，默认：0
                    ,msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                    ,countName: 'total' //数据总数的字段名称，默认：count
                    ,dataName: 'rs' //数据列表的字段名称，默认：data
                }
                ,cols: [[
                    {type:'checkbox'}
                    ,{field:'buyer_id',  title: 'ID'}
                    ,{field:'order_no',  title: '订单号'}
                    ,{field:'created_date',  title: '下单日期',templet:'#created_date'}
                    ,{field:'STATUS',  title: '订单状态',templet:'#status'}
                    ,{field:'profit_source',  title: '收益类型' ,templet:'#regulation_type'}
                    ,{field:'money', title: '收益金额', templet:'#money'}
                    // ,templet:'#money'

                ]]
                ,page: true //开启自动分页
                ,id:'listTable'
            });
            var $ = layui.$, active = {
                sreach: function () {
                    //执行重载
                    table.reload('testReload', {
                        page: {
                            curr: 1 //重新从第 1 页开始
                        }
                        , where: {
                            phone: $('#phone').val(),
                            date1: $('#date1').val(),
                            date2: $('#date2').val(),
                            nick_name: $('#nick_name').val(),
                            audit_status :$("#order_status option:checked").text(),
                            audit_status :$("#order_status option:checked").text(),
                        }
                    });
                }
            };
            $('.demoTableReload .layui-btn').on('click', function(){
                var type = $(this).data('type');
                active[type] ? active[type].call(this) : '';
            });


            //点击按钮 搜索
            $('#searchBtn').on('click', function(){

                //执行重载
                table.reload('listTable', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: {
                        name: $('#name').val(),
                        test5: $('#test5').val(),
                        test6: $('#test6').val(),
                        order_status :$('#order_status').val(),
                        earnings_type :$('#earnings_type').val(),
                    }
                });
                return false;
            });

        });

    </script>
    <script type="text/html" id="usernameTpl">
        <a href="javascript:void(0)" onclick="Foo('{{d.username}}')" class="a" style="color: #003399">{{d.username}}</a>
    </script>
    <script id="money" type="text/html">
        ￥{{(d.money/10000).toFixed(2)}}
    </script>
    <script type="text/html" id="status">
        {{# if(d.STATUS=='101'){}}
        <span style="color:#FF0000; ">待支付</span>
        {{# }else if(d.STATUS=='102'){ }}
        <span style="color:green; ">已付款</span>
        {{# }else if(d.STATUS=='103'){ }}
        <span style="color:green; ">待备货</span>
        {{# }else if(d.STATUS=='104'){ }}
        <span style="color:green; ">待发货</span>
        {{# }else if(d.STATUS=='105'){ }}
        <span style="color:green; ">待发货1</span>
        {{# }else if(d.STATUS=='106'){ }}
        <span style="color:green; ">待签收</span>
        {{# }else if(d.STATUS=='107'){ }}
        <span style="color:green; ">已签收</span>
        {{# }else if(d.STATUS=='108'){ }}
        <span style="color:green; ">已完成</span>
        {{# }else if(d.STATUS=='109'){ }}
        <span style="color:green; ">失效订单</span>
        {{# }else if(d.STATUS=='110'){ }}
        <span style="color:green; ">取消订单</span>
        {{# }else if(d.STATUS=='112'){ }}
        <span style="color:green; ">异常订单</span>
        {{# }else if(d.STATUS==''){ }}
        <span style="color:green; ">暂无状态</span>
        {{# } }}
    </script>
    <script type="text/html" id="regulation">
        {{# if(d.is_default=='1'){}}
        <span style="color:#FF0000; ">默认佣金规则</span>

        {{# }else if(d.is_default=='2'){ }}
        <span style="color:green; ">自定义佣金规则</span>
        {{# } }}
    </script>

  <script type="text/html" id="regulation_type">

        {{# if(d.profit_source=='1'){}}
        <span style="color:#FF0000; ">奖金</span>
        {{# }else if(d.profit_source=='2'){}}
        <span style="color:green; ">佣金</span>
        {{# }else if(d.profit_source=='3'){}}
        <span style="color:green; ">返现</span>
        {{# } }}
    </script>

    <%-- 转时间 --%>
    <script id="created_date" type="text/html">
        {{#  if(d.created_date !== ''){ }}
        <%--<span style="color: rgba(10,10,10,0.46);">{{ d.registration_time.substr(0,2) }}</span>--%>
        <span style="color: rgba(10,10,10,0.46);">20{{ d.created_date.substr(0,2) }}-{{ d.created_date.substr(2,2) }}-{{ d.created_date.substr(4,2) }} {{ d.created_date.substr(6,2) }}:{{ d.created_date.substr(8,2) }}:{{ d.created_date.substr(10,2) }}</span>
        {{#  } else { }}
        <span style="color: rgba(10,10,10,0.46);">---</span>
        {{#  } }}
    </script>
</head>
  <div class="layui-layout layui-layout-admin">
    <div class="layui-body">
      <!-- 内容主体区域 -->
      <div style="padding: 20px;">
        <div class="layui-row">
            <div class="layui-elem-quote" style="margin-top: 3px;background-color: #EEEEEE">
                <label>佣金/收益管理
                </label>
                <button id="exportOrder" data-method="offset" data-type="auto" class="layui-btn layui-btn-normal" style="margin-left: 85%;">导出数据</button>
            </div>



            <form class="layui-form" action="">
                <div class="layui-elem-quote" style="margin-top: 10px;background-color: #EEEEEE;margin-top: 5px;height: 30px">

                    <div class="layui-inline">
                        <label class="layui-form-label">用户名</label>
                        <div class="layui-input-inline">
                            <input type="text" name="name" id="name" lay-verify="required|number"  autocomplete="off" class="layui-input" placeholder="请输入用户名">
                        </div>
                    </div>
                    <div class="layui-inline" >
                        <label class="layui-form-label">申请日期</label>
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test5" placeholder="请输入开始时间">
                        </div>
                        <span style="line-height:40px;">~</span>
                    </div>

                    <div class="layui-inline" >
                        <div class="layui-input-inline">
                            <input type="text" class="layui-input" id="test6" placeholder="请输入结束时间">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">订单状态</label>
                        <div class="layui-input-inline">
                            <select id="order_status" lay-verify="required" lay-search="">
                                <option value="">全部</option>
                                <option value="0">已取消</option>
                                <option value="1">已完成</option>
                                <option value="2">处理中</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">收益类型</label>
                        <div class="layui-input-inline">
                            <select id="earnings_type" lay-verify="required" lay-search="">
                                <option value="">全部</option>
                                <option value="3">返现</option>
                                <option value="2">佣金</option>
                                <option value="1">奖金</option>
                            </select>
                        </div>
                    </div>
                    <button class="layui-btn layui-btn-sm"  style="margin-left:10px;" id="searchBtn" ><i class="layui-icon">&#xe615;</i>搜索</button>
                    <button type="reset" class="layui-btn layui-btn-sm" ><i class="layui-icon">&#x2746;</i>重置</button>
                </div>
            </form>
          <div>
              <table class="layui-hide" id="test"></table>
              <script type="text/html" id="barDemo">
                  <button  lay-event="agree" style="height: 20px;line-height: 20px;width:100px;background-color:#1E9FFF;text-align:center;font-size: 12px;color: #FFFFFF;border-radius:20px;border:none">查看个人收益</button>
              </script>

     <script>
          layui.use('table', function(){
              var table = layui.table;
              //监听表格复选框选择
              table.on('checkbox(demo)', function(obj){
                  console.log(obj)
              });
              //监听工具条
              table.on('tool(demo)', function(obj){
                  var data = obj.data;
                  if(obj.event === 'detail'){
                      layer.msg('ID：'+ data.id + ' 的查看操作');
                  } else if(obj.event === 'del'){
                      layer.confirm('真的删除行么', function(index){
                          obj.del();
                          layer.close(index);
                      });
                  } else if(obj.event === 'edit'){
                      layer.alert('编辑行：<br>'+ JSON.stringify(data))
                  }
              });

              var $ = layui.$, active = {
                  getCheckData: function(){ //获取选中数据
                      var checkStatus = table.checkStatus('idTest')
                          ,data = checkStatus.data;
                      layer.alert(JSON.stringify(data));
                  }
                  ,getCheckLength: function(){ //获取选中数目
                      var checkStatus = table.checkStatus('idTest')
                          ,data = checkStatus.data;
                      layer.msg('选中了：'+ data.length + ' 个');
                  }
                  ,isAll: function(){ //验证是否全选
                      var checkStatus = table.checkStatus('idTest');
                      layer.msg(checkStatus.isAll ? '全选': '未全选')
                  }
              };

              $('.demoTable .layui-btn').on('click', function(){
                  var type = $(this).data('type');
                  active[type] ? active[type].call(this) : '';
              });
          });
      </script>
              <script>
                  function Foo(){
                      layer.open({
                          type: 2,
                          title: '订单详情',
                          shadeClose: true,
                          shade: 0.8,
                          area: ['100%', '100%'],
                          content: 'membershipInformation.jsp'
                      });
                  }
                  //导出订单
                  function exportOrder(){
                      var params = formatParams();
                      if(!params.order_date_start){
                          M.alert('请选择开始时间！');
                          return false;
                      }
                      window.open("url" + token + "&" +  $.param(params));
                  }
              </script>
              <script>
                  layui.use('laydate', function() {
                      var laydate = layui.laydate;
                      //时间选择器
                      laydate.render({
                          elem: '#test5'
                          ,type: 'datetime'
                      });
                      //时间选择器
                      laydate.render({
                          elem: '#test6'
                          ,type: 'datetime'
                      });
                  })
              </script>

  </div>

      </div>
    </div>

  </div>
<%@ include file="/common/footer.jsp"%>