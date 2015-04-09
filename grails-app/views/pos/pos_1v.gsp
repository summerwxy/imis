<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    $(function() {

    })
    </script>
</head>
<content tag="title">1V 门市产品模板</content>
<content tag="subtitle">查询 POS 门市销售画面上的物料及门店即使库存</content>
<body>

<z:wrapper />
    

<h2>2RPM有/1V没有的物料 <small> - 处理方法:从2RPM移除或加入到1V</small></h2>
<g:each in="${list}">
    <hr/>
    <h4>${it.line1}</h4>
    <h5>${it.line2}</h5>

    <table class="table table-condensed">
        <tr>
            <th>模版编号</th>
            <th>模版名称</th>
            <th>物料编号</th>
            <th>物料名称</th>
        </tr>
        <g:each in="${it.table}" var="row">
        <tr>
            <td>${row.PM_NO}</td>
            <td>${row.PM_NAME}</td>
            <td>${row.P_NO}</td>
            <td>${row.P_NAME}</td>
        </tr>
        </g:each>
    </table>


</g:each>


</body>
</html>
