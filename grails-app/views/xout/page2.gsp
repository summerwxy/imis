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
<content tag="title">发货</content>
<content tag="subtitle">....</content>
<body>
<div class="row">
    <div class="span2 offset5">
        <g:if test="${msg}">
            <p class="text-success lead">${msg} </p>
        </g:if>
    </div>
</div>


<div class="row">
    <div class="span10 offset1">
        <form class="form-horizontal" method="POST" action="page2">
            <div class="control-group">
                <label class="control-label" for="orderType">订单类别</label>
                <div class="controls">
                    <select class="form-control" name="orderType">
                        <option value=""></option>
                        <g:each in="${orderTypes}" status="i" var="it">
                            <option value="${it.FId}" ${(it.FId.toString() == params.orderType) ? 'selected="selected"' : ''}>${it.FName}</option>
                        </g:each>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="shipDate">发货日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="shipDate" class="input-small" type="text" value="${shipDate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" name="q" value="true" class="btn btn-primary">生成二维码</button>
                </div>
            </div>
        </form>    

        <g:if test="${params.q}">
            <g:img uri="http://zxing.org/w/chart?cht=qr&chs=300x300&chld=L&choe=UTF-8&chl=${url}" class="qrcode"/>
            ${oUrl}
        </g:if>
    </div>
</div>


    
</body>
</html>
