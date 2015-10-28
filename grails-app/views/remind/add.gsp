<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">

    </style>
    <script type="text/javascript">
    $(function() {

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
<content tag="title">证件提醒</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span2 offset5">
        <g:if test="${params.error}">
            <p class="text-error lead">${params.error} </p>
        </g:if>
        <g:if test="${flash.message}">
            <p class="text-success lead">${flash.message} </p>
        </g:if>
    </div>
</div>

<div class="row">
    <div class="span10 offset1">
        <g:link action="list" class="btn btn-primary">返回清单</g:link>
        <form class="form-horizontal" method="POST" action="add">
            <div class="control-group">
                <label class="control-label">证件名称</label>
                <div class="controls">
                    <input name="name" type="text" value="" class="input-xxlarge">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">证件类型</label>
                <div class="controls">
                    <select name="type">
                        <g:each in="${imis.RemindController.papers}" status="i" var="it">
                            <option value="${it.key}">${it.value}</option>
                        </g:each>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">法人</label>
                <div class="controls">
                    <input name="person" type="text" value="${params.person}" class="input-xxlarge">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">地址</label>
                <div class="controls">
                    <input name="address" type="text" value="${params.address}" class="input-xxlarge">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">证件有效期(开始)</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="sdate" class="input-small" type="text" value="${params.sdate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <label class="control-label">证件有效期(结束)</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="edate" class="input-small" type="text" value="${params.edate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <label class="control-label">年检时间</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="cdate" class="input-small" type="text" value="${params.cdate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <label class="control-label">证件所属性质</label>
                <div class="controls">
                    <select name="owner">
                        <g:each in="${imis.RemindController.owner}" status="i" var="it">
                            <option value="${it.key}">${it.value}</option>
                        </g:each>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">电话机主姓名</label>
                <div class="controls">
                    <input name="man" type="text" value="${params.man}" class="input-xxlarge">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">电话号码</label>
                <div class="controls">
                    <input name="tel" type="text" value="${params.tel}" class="input-xxlarge">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注</label>
                <div class="controls">
                    <textarea name="comment" class="input-xxlarge" rows="4">${params.comment}</textarea>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" name="add" value="true" class="btn btn-primary">保存</button>
                </div>
            </div>            
        </form>    
    </div>
</div>

</body>
</html>
