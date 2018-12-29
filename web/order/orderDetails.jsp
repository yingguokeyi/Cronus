<%@ page import="common.PropertiesConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="/common/common.jsp" %>
<%
    String imgUrlPrefix = PropertiesConf.IMG_URL_PREFIX;
    System.out.println(imgUrlPrefix);
%>

<div class="layui-layer-iframe">
    <div class="layui-row">
        <div class="layui-col-xs3">
            <div class="grid-demo grid-demo-bg1" style="">&nbsp;&nbsp;<span style="color: grey">单号:</span>
                <span style="color: #393D49"><label id="order_no" name="order_no"></label></span>
            </div>
        </div>
        <%--#3F3F3F--%>
        <div class="layui-col-xs3">
            <%--<div class="grid-demo">类型:
                <label id="order_type"></label>
            </div>--%>
        </div>
        <div class="layui-col-xs3">
            <div class="grid-demo grid-demo-bg1"><span style="color: grey">当前状态:</span>
                <span style="color: #393D49"><label id="status"></label></span>
            </div>
        </div>
        <%-- <div class="layui-col-xs3">
             <div class="grid-demo"><button class="layui-btn layui-btn-primary layui-btn-sm" id="btn"><i class="layui-icon"></i></button></div>
         </div>--%>
    </div>
    <div class="layui-tab" lay-filter="demo">
        <ul class="layui-tab-title">
            <li class="layui-this" lay-id="orderInfoGeneral">概要</li>
            <li lay-id="goodsInfoDetailList">商品清单</li>
            <li lay-id="orderInfoHandleStyle">处理状态</li>
            <li lay-id="orderLogisticsInfo">物流信息</li>
        </ul>
        <div class="layui-tab-content" style="height: 100%;">
            <div class="layui-tab-item layui-show">
                <div class="layui-row">
                    <div class="layui-col-xs3">
                        <div class="grid-demo grid-demo-bg1" style="size: A5">付款信息</div>
                    </div>
                </div>
                <br/>
                <div class="layui-row" style="margin-left: 40px">
                    <div class="layui-col-xs3">
                        <div class="grid-demo grid-demo-bg1"><span style="color: grey">付款方式:</span>
                            <span style="color: #393D49"><label id="payment_way_key"></label></span>
                        </div>
                    </div>
                </div>
                <br/>
                <div class="layui-row" style="margin-left: 40px">
                    <div class="layui-col-xs3">
                        <div class="grid-demo grid-demo-bg1"><span style="color: grey">支付总金额:</span>
                            <span style="color: #393D49"><label id="total_price"></label></span>
                        </div>
                    </div>
                </div>
                <br/>
                <div class="layui-row" style="margin-left: 40px">
                    <div class="layui-col-xs3">
                        <div class="grid-demo grid-demo-bg1"><span style="color: grey">用户实际支付金额:</span>
                            <span style="color: #393D49"><label id="market_price"></label></span>
                        </div>
                    </div>
                </div>
                <br/>
                <div class="layui-row" style="margin-left: 40px">
                    <div class="layui-col-xs3">
                        <div class="grid-demo grid-demo-bg1"><span style="color: grey">返现:</span>
                            <span style="color: #393D49"><label id="backMoney"></label></span>
                        </div>
                    </div>
                </div>
                <br/>

                <hr class="layui-bg-cyan">
                <div class="layui-row">
                    <div class="layui-col-xs6">
                        <div class="grid-demo grid-demo-bg1">
                            收货人信息
                        </div>
                        <br/>
                        <div class="grid-demo grid-demo-bg1" style="margin-left: 40px">
                            <span style="color: grey"> 收货人:</span>
                            <span style="color: #393D49"><label id="consignee"></label></span>
                        </div>
                        <br/>
                        <div class="grid-demo grid-demo-bg1" style="margin-left: 40px">
                            <span style="color: grey"> 收货地址:</span>
                            <span style="color: #393D49"><label id="delivery_address"></label></span>
                        </div>
                        <br/>
                        <div class="grid-demo grid-demo-bg1" style="margin-left: 40px">
                            <span style="color: grey">电话:</span>
                            <span style="color: #393D49"><label id="consignee_tel"></label></span>
                        </div>
                        <br/>
                    </div>
                </div>

                <hr class="layui-bg-cyan">
                <div class="layui-row">
                    <div class="layui-col-md4">
                        <div class="grid-demo grid-demo-bg1">
                            <div class="grid-demo grid-demo-bg1">
                                物流信息
                            </div>
                            <br/>
                            <div class="grid-demo grid-demo-bg1" style="margin-left: 40px">
                                <span style="color: grey">物流状态:</span>
                                <span style="color: #393D49"><label id="logistics_status"></label></span>
                                <%-- <button class="layui-btn" data-type="tabChange"  style="margin-left: 40px">物流信息</button>--%>
                                <button class="layui-btn site-demo-active" data-type="tabChange"
                                        style="margin-left: 40px">物流信息
                                </button>
                            </div>
                            <br/>
                            <div class="grid-demo grid-demo-bg1" style="margin-left: 40px">
                                <span style="color: grey">运单编号:</span>
                                <span style="color: #393D49"><label id="logistics_numbers"></label></span>
                            </div>
                            <br/>
                        </div>
                    </div>
                </div>

                <hr class="layui-bg-cyan">
                <div class="layui-row">
                    <div class="layui-col-xs6">
                        <div class="grid-demo grid-demo-bg1">
                            订单备注
                        </div>
                        <br/>
                        <div class="grid-demo grid-demo-bg1" style="margin-left: 40px">
                            <span style="color: grey"> 用户留言:</span>
                            <span style="color: #393D49"><label id="remark"></label></span>
                        </div>
                        <br/>

                    </div>
                </div>

            </div>

            <div class="layui-tab-item">
                <table class="layui-table" id="goodsInfoList" lay-filter="goodsInfoFilter"></table>
            </div>
            <div class="layui-tab-item">
                <div>
                    <label id="goodsInfoTab2"></label>
                </div>
                <ul class="layui-timeline" style="margin-left: 10%;margin-top: 5%;">
                    <li class="layui-timeline-item">
                        <i class="layui-icon layui-timeline-axis"></i>
                        <div class="layui-timeline-content layui-text">
                            <h3 class="layui-timeline-title">8月18日</h3>
                            <p>
                                开始备货,操作人:<label id="edit_user1"></label>
                                <br>&nbsp;&nbsp;备注:
                                <br>&nbsp;&nbsp;<label id="memo"></label>
                            </p>
                        </div>
                    </li>
                    <li class="layui-timeline-item">
                        <i class="layui-icon layui-timeline-axis"></i>
                        <div class="layui-timeline-content layui-text">
                            <h3 class="layui-timeline-title">8月16日</h3>
                            <p>
                                支付完成,付款方式:<label id="payment_way_key1"></label>
                            </p>
                        </div>
                    </li>
                    <li class="layui-timeline-item">
                        <i class="layui-icon layui-timeline-axis"></i>
                        <div class="layui-timeline-content layui-text">
                            <h3 class="layui-timeline-title">8月15日</h3>
                            <p>
                                提交订单,订单号:<label id="order_no1"></label>
                                <br>&nbsp;&nbsp;买家留言:
                                <br>&nbsp;&nbsp;<label id="memo1"></label>
                            </p>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="layui-tab-item" style="margin-left: 10%;">
                <div class="site-demo-flow" id="orderLogisticsInfo">
                    <li class="layui-timeline-item" id='orderLogistic'>
                        <div class="layui-timeline-content layui-text">
                            <div class="layui-timeline-title" id="time"></div>
                            <div class="layui-timeline-title" id="context"></div>
                        </div>
                    </li>
                </div>
            </div>
        </div>
    </div>
</div>
</form>
<script>
    var imgUrlPrefix = "<%=imgUrlPrefix%>";
    layui.use(['element', 'table'], function () {
        var table = layui.table; //表格
        var $ = layui.jquery,
            element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
        //触发事件
        var active = {
            tabChange: function () {
                //切换到指定Tab项
                element.tabChange('demo', 'orderLogisticsInfo'); //切换到：物流信息
            }
        };

        $('.site-demo-active').on('click', function () {
            var othis = $(this), type = othis.data('type');
            active[type] ? active[type].call(this, othis) : '';
        });

        //Hash地址的定位
        var layid = location.hash.replace(/^#demo=/, '');
        element.tabChange('demo', layid);

        element.on('tab(demo)', function (data) {
            if (data.index == '1') {
                var order_Code = $("#order_no").text();
                //执行一个 table 实例
                table.render({
                    elem: '#goodsInfoList'
                    , url: '${ctx}/order?method=getOrderOnGoodsInfo' //数据接口
                    , page: false //开启分页
                    , response: {
                        statusName: 'success' //数据状态的字段名称，默认：code
                        , statusCode: 1  //成功的状态码，默认：0
                        , msgName: 'errorMessage' //状态信息的字段名称，默认：msg
                        , countName: 'total' //数据总数的字段名称，默认：count
                        , dataName: 'rs' //数据列表的字段名称，默认：data
                    }
                    , cols: [[ //表头
                        {field: 'dict_data_name', width: 100, title: '商品来源', align: 'center'}
                        , {field: 'spu_code', width: 120, title: '商品编码', align: 'center'}
                        , {field: 'spu_name', width: 225, title: '商品名称', align: 'center'}
                        , {
                            field: 'http_path',
                            style: 'height:150px;width:150;line-height:48px!important;',
                            title: '商品图片',
                            templet: function (d) {
                                if (d.http_path == "") {
                                    var image_path = new Array();
                                    image_path = d.image_path.split(",");

                                    return "<img src=" + imgUrlPrefix + image_path[0] + "  class='layui-upload-img' style='height: 100px;width:100px;margin-top: -50px'>";
                                } else {
                                    var http_path = new Array();
                                    http_path = d.http_path.split(",");
                                    return "<img src=" + http_path[0] + "  class='layui-upload-img' style='height: 200px;width: 200px;margin-left: 30px'>";
                                }
                            }
                            ,
                            align: 'center'
                        }
                        , {field: 'sku_num', width: 80, title: '数量', align: 'center'}
                        , {
                            field: 'total_price', width: 180, title: '用户实际支付金额', templet: function (d) {
                                return (d.total_price * 0.01).toFixed(2);
                            }, align: 'center'
                        }
                        , {
                            field: 'self', width: 120, title: '返现', templet: function (d) {
                                return (d.self * 0.01).toFixed(2);
                            }, align: 'center'
                        }
                        , {
                            field: 'stock', width: 120, title: '库存状态', align: 'center', templet: function (d) {
                                if (d.stock != 0) {
                                    return d.stock;
                                } else {
                                    return "已售磬";
                                }

                            }
                        }
                    ]]
                    , where: {order_no: order_Code}
                });

            } else if (data.index == '2') {

            }
        });

    });

</script>
<script type="text/html" id="stockStyleTpl">
    {{#  if(d.stock > 0){ }}
    <span style="color: rgba(168,167,160,0.46);">有货</span>
    {{#  } else { }}
    <span style="color: rgba(168,167,160,0.46);">无货</span>
    {{#  } }}
</script>
<script id="create_timeTpl" type="text/html">

    {{#  if(d.created_date !== ''){ }}
    <span style="color: rgba(10,10,10,0.46);">20{{ d.created_date.substr(0,2) }}-{{ d.created_date.substr(2,2) }}-{{ d.created_date.substr(4,2) }} {{ d.created_date.substr(6,2) }}:{{ d.created_date.substr(8,2) }}:{{ d.created_date.substr(10,2) }}</span>
    {{#  } else { }}
    <span style="color: rgba(10,10,10,0.46);">---</span>
    {{#  } }}
</script>
<%--
<%@ include file="/common/footer.jsp"%>--%>
