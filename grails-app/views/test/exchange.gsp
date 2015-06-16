<!DOCTYPE html>
<html>
<head>
<style>
input {
    width: 100%;
}
#msg {
    color: #ff0000;
}
</style>
</head>
<body>

<g:if test="${flash.msg}">
    <div id="msg">${flash.msg}</div>
</g:if>

<form method="POST">
    <g:if test="${!flash.step}">
        <h3>请输入兑换验证码</h3>
        验证码：<br/>
        <input type="text" name="code"/><br/>
        <input type="submit" name="act" value="验证" />
    </g:if>
    <g:if test="${flash.step == 2}">
        <h3>请提供送货信息</h3>
        联络人：<br/>
        <input type="text" name="name" /><br/>
        手机号码：<br/>
        <input type="text" name="mobile" /><br/>
        送货地址：<br/>
        <input type="text" name="address" /><br/>
        <input type="hidden" name="code" value="${flash.code}" /><br/>
        <input type="submit" name="act" value="兑换" />
    </g:if>
    <g:if test="${flash.step == 3}">
        <div>兑换成功！</div>
    </g:if>
</form>

</body>
</html>
