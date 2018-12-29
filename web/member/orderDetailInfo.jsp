<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<%@ include file="/finance/menu_finance.jsp"%>



<!-- 内容主体区域 -->
<div class="layui-body">
    <div class="layui-row">
        <div style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
            <label style="font-size: 18px;margin-left: 3% ; line-height: 50px" >订单详情信息</label>
            <button class="layui-btn layui-btn-radius" style=" margin-left: 75%" onclick="history.go(-1)">返回</button>
        </div>
        <br>
        <div>
            <div class="layui-inline" style="font-size: 15px;margin-left: 10% ; line-height: 30px" >
                订单编号：
                <a class="layui-inline" id="username"></a>
            </div>
        </div>
        <div>
            <label style="font-size: 15px;margin-left: 10% ; line-height: 30px" >用户基本信息</label>
        </div>
        <div>
            <table style="margin-left: 10%; height: 50%;width: 60%" border="1">
                <tr style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50%" align="center">用户</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">会员类型</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">预计账户金额</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">实际账户活动金额</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>

            </table>
        </div>
        <div>
            <label style="font-size: 15px;margin-left: 10% ; line-height: 30px" >成交用户信息</label>
        </div>
        <div>
            <table style="margin-left: 10%; height: 50%;width: 60%" border="1">
                <tr style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50%" align="center">用户</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">成交时间</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">手机号</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">收货地址</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>

            </table>
        </div>
        <div>
            <label style="font-size: 15px;margin-left: 10% ; line-height: 30px" >支付信息</label>
        </div>
        <div style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px;width: 60%;margin-left: 10%;">
            <label style="font-size: 18px;margin-left: 3% ; line-height: 50px" >支付信息:</label>
            <a>微信支付/账户余额支付</a>
        </div>
    </div>
    <br>
    <div>
        <div>
            <label style="font-size: 15px;margin-left: 10% ; line-height: 30px"; >购买商品信息      【 订单号：1015015620017】</label>
            <hr class="layui-bg-gray">
        </div>
        <div style="margin-left: 10%;width: 60%">
            <table class="layui-table" id="goodsList"  style="visibility: hidden" lay-filter="demo" ></table>
        </div>
    </div>
    <div>
        <div>
            <label style="font-size: 15px;margin-left: 10% ; line-height: 30px" >订单信息</label>
            <hr class="layui-bg-gray">
        </div>
        <div>
            <table style="margin-left: 10%; height: 50%;width: 60%" border="1">
                <tr style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50%" align="center">下单用户</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">下单时间</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="background-color: #EEEEEE ;height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">手机号</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>
                <tr style="height: 50px;margin-top: 10px;margin-left: 10px">
                    <td style="width: 50px" align="center">收货地址</td>
                    <td style="width: 50px" align="left">11</td>
                </tr>

            </table>
        </div>
    </div>
</div>

<script type="text/html" id="imageTpl">
    <!-- 这里的 checked 的状态只是演示 -->
    <img src="http://img2.utuku.china.com/640x0/news/20170210/77b8b5ca-11d3-4307-9a93-c12df5eb1a35.jpg"
         style="width: 300px;height: 200px">

</script>
<script>

    layui.config({
        version: '1515376178738' //为了更新 js 缓存，可忽略
    });

    $(document).ready(myFunction());
    function myFunction(){
        var url = location.search;
        var theRequest = new Object();
        if ( url.indexOf( "?" ) != -1 ) {
            var str = url.substr( 1 ); //substr()方法返回从参数值开始到结束的字符串；
            var strs = str.split( "&" );
            for ( var i = 0; i < strs.length; i++ ) {
                theRequest[ strs[ i ].split( "=" )[ 0 ] ] = ( strs[ i ].split( "=" )[ 1 ] );
            }
            $('#username').text(theRequest.userName);
            $('#phone').text(theRequest.phoneNum);
            $('#usernametype').text(theRequest.usernameType);
        }
    }
    function UnicodeToUtf8(unicode) {
        var uchar;
        var utf8str = "";
        var i;

        for(i=0; i<unicode.length;i+=2){
            uchar = (unicode[i]<<8) | unicode[i+1];               //UNICODE为2字节编码，一次读入2个字节
            utf8str = utf8str  + String.fromCharCode(uchar);    //使用String.fromCharCode强制转换
        }
        return utf8str;
    }

    layui.use('table', function(){
        var table = layui.table;

        table.render({
            elem: '#goodsList'
            // ,url:'/demo/table/user/'
            //,cellMinWidth: 100 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,page:false
            ,cols: [[
                {field: 'field1', title: '子订单', width:100,align: 'center'}
                ,{field: 'field2', title: '商品来源', width:100,align: 'center'}
                ,{field: 'field3', title: '商品编码', width:150,align: 'center'}
                ,{field: 'field4', title: '商品图片', width:150,align: 'center',templet: '#imageTpl'}
                ,{field: 'field5', title: '商品名称', width: 170,align: 'center'}
                ,{field: 'field6', title: '购买数量', width: 100,align: 'center'}
                ,{field: 'field7', title: '预付', width: 100,align: 'center'}
                ,{field: 'field8', title: '返现', width: 100,align: 'center'}
                ,{field: 'field9', title: '是否到账', width: 135,align: 'center'}
            ]]
            ,data:[{
                "field1": "10015025641005"
                ,"field2": "淘宝"
                ,"field3": "TB04011100350"
                ,"field4": ""
                ,"field5": "三只松鼠休闲麻辣零食特产约辣辣条2000g/盒"
                ,"field6": "1盒"
                ,"field7": "￥19.00"
                ,"field8": "￥1.00"
                ,"field9": "是"
            },{
                "field1": "10015025641006"
                ,"field2": "会过"
                ,"field3": "HG04011100350"
                ,"field4": ""
                ,"field5": "一只松鼠休闲麻辣零食特产约辣辣条780g/袋"
                ,"field6": "12盒"
                ,"field7": "￥580.00"
                ,"field8": "￥50.00"
                ,"field9": "否"
            }]
        });
    });
    layui.use('laydate', function(){
        var laydate = layui.laydate;
        //常规用法
        laydate.render({
            elem: '#field10'
        });

    });
</script>

