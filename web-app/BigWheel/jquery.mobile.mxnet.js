var MXNET = {
    MobileAlert: function (options) {
        var html = "";
        //参数属性设置
        var title = options.title || "系统提示";
        var content = options.content || "请选择确定或取消？";
        var container = options.container || "body";
        if ($("#mobileAlert") != undefined) {
            $("#mobileAlert").remove();
        }
        html += "<div data-role=\"dialog\" id=\"mobileAlert\" >";
        html += "    <div data-role=\"header\" data-theme=\"b\"><h1>" + title + "</h1></div>";
        html += "    <div data-role=\"content\">";
        html += "        <p>" + content + "</p>";
        html += "        <a href=\"#\" id=\"ButtonAlertOk\" data-role=\"button\" data-rel=\"back\" data-theme=\"b\">确认</a> ";
        html += "    </div>";
        html += "</div>";
        $(container).append(html);
        
        $.mobile.changePage("#mobileAlert");
    },
    MobileDialog: function (options) {
        var html = "";
        //参数属性设置
        var href = options.href || "#";
        var transition = options.transition || "none";
        var title = options.title || "系统提示";
        var content = options.content || "请选择确定或取消？";
        var isCancel = options.isCancel ? "block" : "none";
        var isOk = options.isOk ? "block" : "none";

        if ($("#mobileDialog") != undefined) {
            $("#mobileDialog").remove();
        }

        html += "<div data-role=\"dialog\" id=\"mobileDialog\" >";
        html += "    <div data-role=\"header\" data-theme=\"b\"><h1>" + title + "</h1></div>";
        html += "    <div data-role=\"content\">";
        html += "        <p>" + content + "</p>";
        html += "        <a href=\"" + href + "\" id=\"ButtonDialogOk\" style=\"display:" + isOk + ";\" data-role=\"button\" data-rel=\"back\" data-theme=\"b\">确认</a> ";
        html += "        <a href=\"" + href + "\" id=\"ButtonDialogCancel\" style=\"display:" + isCancel + ";\" data-role=\"button\"  data-rel=\"back\" data-theme=\"c\">取消</a>";
        html += "    </div>";
        html += "</div>";
        $('body').append(html);

        var ObjDialog = $("#mobileDialog");
        var ButtonDialogOk = $("#ButtonDialogOk");
        var ButtonDialogCancel = $("#ButtonDialogCancel");

        $.mobile.changePage("#mobileDialog");
        ObjDialog.bind('pageshow', function (event) {
            if (typeof options.Ok == 'function' && options.isOk == true) {
                options.Ok(ObjDialog, ButtonDialogOk);
            }
            if (typeof options.Cancel == 'function', options.isCancel == true) {
                options.Cancel(ObjDialog, ButtonDialogCancel);
            }
        });
    },
    //倒计时
    TimerDown: function (ObjVal, ObjBtn) {
        var OldCount = parseInt(ObjVal.text());
        var Count = parseInt(ObjVal.text());
        var TimerS = setInterval(function () {
            if (Count > 0) {
                Count = Count - 1;
                ObjVal.text(Count);
            } else {
                clearInterval(TimerS);
                ObjVal.text(OldCount);
                ObjBtn.button('enable');
            }
        }, 1000);
    },
    //接收URL传递的参数
    GetUrlParam: function (name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]); return null; //返回参数值
    },
    //异步请求
    AjaxPost: function (sData, sService, fCallback, fComplate) {
        $.ajax({
            type: "post",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            url: sService,
            ifModified: false,
            cache: false,
            data: sData,
            complete: fComplate,
            success: fCallback,
            error: function (a, b) {
                //error message.
                debugger;
            }
        });
    },
    //同步请求
    AjaxAsyncPost: function (sData, sService, fCallback, fComplate) {
        $.ajax({
            type: "post",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            url: sService,
            ifModified: false,
            cache: false,
            data: sData,
            complete: fComplate,
            success: fCallback,
            error: function (a, b) {
                //error message.
                debugger;
            }
        });
    }
};
