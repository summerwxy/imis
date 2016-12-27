<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    input[type="radio"] {
        opacity: 1;
    }
    </style>
    <script type="text/javascript">
    $(function() {
        $('#iurl').click(function() {
            $("#urlType").prop("checked", true)
            return false;
        });

        $('#icode').keyup(function() {
            $('#showCode').text(this.value);
        });

        // datetimepicker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });
    })
    </script>
</head>
<content tag="title">门店通知管理</content>
<content tag="subtitle">发布与管理公告</content>
<body>

<div class="row">
    <div class="span2 offset5">
        <g:if test="${flash.error}">
            <p class="text-error lead">${flash.error} </p>
        </g:if>
        <g:if test="${flash.message}">
            <p class="text-success lead">${flash.message} </p>
        </g:if>
    </div>
</div>

<div class="row">
    <div class="span10 offset1">
        <g:link action="ann" class="btn btn-primary">返回清单</g:link>
        <form class="form-horizontal" method="POST" action="ann_add">
            <div class="control-group">
                <label class="control-label" for="icode">编号</label>
                <div class="controls">
                    <input name="code" type="text" id="icode" value="${code}" class="input-mini">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="ititle">标题</label>
                <div class="controls">
                    <input name="title" type="text" id="ititle" placeholder="必填: 签报单标题" class="input-xxlarge">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="iannDate">日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="annDate" class="input-small" type="text" id="iannDate" value="${today}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <label class="control-label" for="ihandler">经办人</label>
                <div class="controls">
                    <input name="handler" type="text" id="ihandler" placeholder="" class="input-small">
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <label class="radio">
                        <input type="radio" name="pageType" value="static" checked="checked">
                        静态文档: 档案请放在 \\192.168.0.45\code\apache-tomcat-8.0.33\webapps\ROOT\pages\<span id="showCode">${code}</span>.htm
                    </label>
                    <label class="radio">
                        <input type="radio" id="urlType" name="pageType" value="url">
                        网址: <input name="url" type="text" id="iurl" class="input-xxlarge" placeholder=""/>
                    </label>
                    <button type="submit" name="add" value="true" class="btn btn-primary">新增</button>
                </div>
            </div>
        </form>    
    </div>
</div>

</body>
</html>
