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
<content tag="title">发货异常处理</content>
<content tag="subtitle">...</content>
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
        <form class="form-horizontal" method="POST" action="page3">
            <div class="control-group">
                <label class="control-label" for="itheDate">日期</label>
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" style="margin-left: 20px;">
                    <input name="theDate" class="input-small" type="text" id="itheDate" value="${params.theDate}" readonly>
                    <span class="add-on"><i class="icon-th"></i></span>
                </div>                
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="submit" name="check" value="true" class="btn btn-primary">检查</button>
                </div>
            </div>
        </form>    

        有差异的产品, 将 K3 销售出库单"删除"后, 可以就有中间表删除功能
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>删除</th>
                    <th>品号</th>
                    <th>品名</th>
                    <th>中间表数量</th>
                    <th>出库单数量</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${data}" status="i" var="it">
                    <tr>    
                        <td>
                            <g:if test="${it.K3fqty?.toInteger() == 0}">
                               <g:link action="page3_del" params="[date: the_date, item: it.FNumber]" class="btn btn-danger">删除</g:link>
                            </g:if>
                        </td>
                        <td>${it.FNumber}</td>
                        <td>${it.FName}</td>
                        <td>${it.t_AWE_FQty?.toInteger()}</td>
                        <td>${it.K3fqty?.toInteger()}</td>
                    </tr>
                </g:each> 
            </tbody>
        </table>

    </div>
</div>

</body>
</html>
