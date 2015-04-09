<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    /*
    function throttle(f, delay){
        var timer = null;
        return function(){
            var context = this, args = arguments;
            clearTimeout(timer);
            timer = window.setTimeout(function(){
                f.apply(context, args);
            },
            delay || 500);
        };
    }
    */
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
<content tag="title">POS考勤查询</content>
<content tag="subtitle">查询 POS 考勤资料</content>
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
        <form class="form-horizontal" method="POST" action="page1">
            <div class="control-group">
                <label class="control-label" for="op_no">工号</label>
                <div class="controls">
                    <input name="op_no" type="text" id="op_no" value="${params.op_no}" class="input-mini">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="sDate">开始日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="sDate" class="input-small" type="text" value="${params.sDate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <label class="control-label" for="eDate">结束日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="eDate" class="input-small" type="text" value="${params.eDate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" name="q" value="true" class="btn btn-primary">查询</button>
                    <button type="submit" name="sync" value="true" class="btn btn-success">同步最近60天资料到人事系统</button>
                </div>
            </div>
        </form>    
    </div>
</div>


<div class="row">
    <div class="span10 offset1">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>工号</th>
                    <th>姓名</th>
                    <th>门店</th>
                    <th>日期</th>
                    <th>时间</th>
                    <th>上下班</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td>${it.OP_NO}</td> 
                        <td>${it.OP_NAME}</td> 
                        <td>${it.S_NAME}</td> 
                        <td>${it.DUT_DATE}</td> 
                        <td>${it.DUT_TIME}</td> 
                        <td>${(it.DUT_TYPE == 'off') ? '下班' : '上班'}</td> 
                    </tr>
                </g:each>             
            </tbody>
        </table>
    </div>
</div>
    
</body>
</html>
