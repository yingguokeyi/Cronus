
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>运营平台</title>
    <link rel="stylesheet" href="./layui/css/layui.css?t=1515376178739">
    <script  type="text/javascript" src="./layui/layui.js?t=1515376178739"></script>
    <script  type="text/javascript" src="./common/third-part/jquery-1.11.3.min.js"></script>
    <link rel="icon" href="favicon.ico" type="image/x-icon" />
    <style>
        #login {
            border: 1px solid #dddddd;
            width: 500px;
            height: 310px;
            background-color: #f2f2f2;
            margin: 250px auto;
        }

        #login-left {
            border: 1px solid #dddddd;
            width: 131px;
            height: 177px;
            background-color: #FFFFFF;
            margin-top: 55px;
            margin-left: 50px;
        }

        #login-left-bottom {
            width: 96px;
            height: 33px;
            margin-left: 72px;
            margin-top: 10px;
        }

        #login-right {
            width: 310px;
            height: 250px;
            position: relative;
            left: 185px;
            bottom: 225px;
        }

        #yzm {
            width: 75px;
            height: 30px;
            background-color: #e2e2e2;
            position: relative;
            left: 115px;
            bottom: 33px;
        }

        #yzm-z {
            position: relative;
            left: 7px;
            top: 7px;
        }

        #loginb-button {
            position: relative;
            bottom: 20px;
        }

    </style>
    <script type="text/javascript">

        var code; //在全局 定义验证码
        function createCode()
        { //创建验证码函数
            code = "";
            var codeLength =4;//验证码的长度
            var selectChar = new Array(0,1,2,3,4,5,6,7,8,9,'a','b','c','d','e','f','g','h','i','j','k',
                'l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');//所有候选组成验证码的字符，当然也可以用中文的
            for(var i=0;i<codeLength;i++)
            {
                var charIndex =Math.floor(Math.random()*36);
                code +=selectChar[charIndex];
            }
// 设置验证码的显示样式，并显示
            document.getElementById("discode").style.fontFamily="Fixedsys"; //设置字体
            document.getElementById("discode").style.letterSpacing="6px"; //字体间距
            document.getElementById("discode").style.color="#0ab000"; //字体颜色
            document.getElementById("discode").innerHTML=code; // 显示
        }


        //监听Enter键自动提交事件
        $(document).keyup(function(event){
            if(event.keyCode ==13){
                login();
            }
        });

        function login() {

            var loginName = encodeURI($("#loginName").val());
            var pwd = encodeURI($("#pwd").val());
            var code1 = encodeURI($("#t1").val());
            var oError = document.getElementById("loginNameMsg");
            var pwdError = document.getElementById("pwdMsg");
            if(loginName.length > 20 || loginName.length < 6){
                oError.innerHTML  =("用户名长度必须在6~20位之间") ;
                return;
            }else if(loginName.charCodeAt(0) >=48 && loginName.charCodeAt(0) <= 57){
                oError.innerHTML = ("用户名开头不能为数字");

                return;
            }else{
                for(var i=0; i<loginName.length; i++){
                    if((loginName.charCodeAt(i) > 122 || loginName.charCodeAt(i) < 97) && (loginName.charCodeAt(i) > 57 || loginName.charCodeAt(i) < 48)){
                        oError.innerHTML=("用户名只能包含小写字母和数字");

                        return;
                    }
                }
            }
            if(pwd.length > 20 || pwd.length < 6){
                pwdError.innerHTML = ("密码长度必须在6~20位之间");

                return;
            }
            if(code==code1){
                $.ajax({
                //几个参数需要注意一下
                type: "get",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "user?method=getUser&"+"loginName="+loginName+"&pwd="+pwd ,//url
                async : false,
              //  data: {loginName:loginName,pwd:pwd},
                success:function(res){
                    if(res.success==1){

                        window.location.href="${pageContext.request.contextPath}/index.jsp"
                    }
                },
                error:function(){
                    alert("用户名和密码错误或不存在");
                },
            });
            }
            else{
                alert("验证码错误");


            }
            return false;
        }
    </script>
</head>

<body onload="createCode()" style="background-image:url(image/login/20120416093957483.jpg);background-size: 100% 100%;">
<div id="login">
    <div id="login-left" style="background-image:url(image/login/c15a06363db98ca3d0b54b21076d11f340e51851288542-m4O3fl_fw658.jpeg);background-size: 100% 100%;">

    </div>
    <div id="login-left-bottom">
        <h2 style="color: #969696">管理后台</h2>
    </div>
    <div id="login-right">
        <div class="layui-form-item">
            <label class="layui-form-label">账号</label>
            <div class="layui-input-block" style="width: 190px;">
                <input type="text" id="loginName"  placeholder="请输入登录账号"
                       autocomplete="off" class="layui-input" >
                <text id="loginNameMsg">
                </text>
            </div>
        </div>
        <div class="layui-form-item" style="margin-top: 28px;">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-inline">
                <input type="password" id="pwd" placeholder="请输入登录密码"
                       autocomplete="off" class="layui-input">
                <text id="pwdMsg">
                </text>
            </div>
        </div>
        <div class="layui-form-item" style="margin-top: 28px;">
            <label class="layui-form-label">验证码</label>
            <div class="layui-input-block" style="width: 110px;">
                <input id="t1" type="text" placeholder="验证码" autocomplete="off" class="layui-input">
                <div id="yzm" class="c" onClick="createCode()">
                    <div id="discode"></div>


                </div>

            </div>


        </div>
        <div class="layui-form-item" id="loginb-button">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-normal"  type="button" style="width: 190px;" onclick="login()">
                    登录
                </button>
            </div>

        </div>


    </div>


</div>
</body>
</html>
