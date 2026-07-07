<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<html>
    <head>
        <title>运维笔记</title>
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"/>
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css" />
        <script type="text/javascript" src="${pageContext.request.contextPath}/lib/jquery-3.6.1.js"></script>
        <script src="${pageContext.request.contextPath}/js/login.js" type="text/javascript"></script>
    </head>
    <body>
        <form action="loginservlet" method="post" id="loginForm">
            <div class="A">
                <div class="box">
                    <div class="text">
                        <p class="t1">DevOps</p>
                        <p class="t2">欢迎回来</p>
                        <input type="text" id="uname" name="uname" placeholder="用户名" autocomplete="on" class="user">
                        <input type="password" id="passwd" name="passwd" placeholder="密码" class="pass">
                        <div class="info" id="msg">${error }</div>
                        <a href="#" class="forget">忘记密码?</a>
                        <input type="submit" value="登录" id="st">
                        <p id="t3">he_ber</p>
                    </div>
                </div>
            </div>
        </form>
    </body>
</html>
