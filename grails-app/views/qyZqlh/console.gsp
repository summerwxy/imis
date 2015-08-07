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
<content tag="title">微信订单</content>
<content tag="subtitle">订单管理后台</content>
<body>

<div class="row">
    <div class="span10 offset1">

        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>id</th>
                    <th>weixin</th>
                    <th>name</th>
                    <th>phone</th>
                    <th>ship_time</th>
                    <th>status</th>
                    <th>address</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td nowrap>
                            <g:link action="console_detail" id="${it.id}">${it.id}</g:link>
                        </td>
                        <td nowrap>${it.wxname}</td>
                        <td nowrap>${it.name}</td>
                        <td nowrap>${it.phone}</td>
                        <td nowrap>${it.ship_time}</td>
                        <td nowrap>${imis.QyZqlhController.status[it.all_status]}</td>
                        <td nowrap>${it.address}</td>
                    </tr>
                </g:each> 
            </tbody>
        </table>
    </div>
</div>
    
</body>
</html>
