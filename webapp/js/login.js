$('#st').click(function () {
    //获取用户名和密码的值
    var uname=$("#uname").val();
    var upwd=$("#passwd").val();
    //判断姓名是否为空
    if(isEmpty(uname)){
        //如果为空提示用户
        $("#msg").html("用户名不能为空！");
        return;
    }
    //判断密码是否为空
    if(isEmpty(upwd)){
        //如果密码为空提示用户
        $("#msg").html("密码不能为空！");
        return;
    }
    //如果不为空提交表单
    $("#st").submit();
});
/*
* 判断字符串是否为空
* 如果为空返回true
* 如果不为空返回false
* */
function isEmpty(str) {
    if(str==null || str.trim()==""){
        return true;

    }
    return false;
}