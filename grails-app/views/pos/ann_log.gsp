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
<content tag="title">门店通知管理</content>
<content tag="subtitle">查看记录</content>
<body>

<div class="row">
    <div class="span10 offset1">
        <g:link action="ann" class="btn btn-primary">返回清单</g:link>
        <ul>
            <li>编号: ${ann.code}</li>
            <li>标题: ${ann.title}</li>
            <li>日期: ${ann.annDate}</li>
            <li>经办人: ${ann.handler}</li>
        </ul>   
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>区域</th>
                    <th>门店</th>
                    <th>电话</th>
                    <th>IP</th>
                    <th>次数</th>
                    <th>第一次时间</th>
                    <th>签名</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${store}" status="i" var="it">
                    <tr class="${(it.dt) ? 'success': 'error'}">
                        <td>${it.R_NAME}</td> 
                        <td>${it.S_NAME}</td> 
                        <td>${it.S_TEL}</td> 
                        <td>${it.S_IP}</td> 
                        <td>${it.times}</td> 
                        <td>${it.date}</td> 
                        <td>${it.op_name} ${it.dt}</td>
                    </tr>
                </g:each> 
            </tbody>
        </table>


    </div>
</div>

</body>
</html>
