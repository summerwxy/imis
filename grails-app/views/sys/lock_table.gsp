<%@ page import="iwill.*" %>
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
<content tag="title">运行中作业</content>
<content tag="subtitle">...</content>
<body>

<div class="row">
    <div class="span10 offset1">

        <h2 class="text-error">按 F5 刷新画面, 大于 3 分钟的才可以删除</h2>

        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>删除</th>
                    <th>运行时间</th>
                    <th>排程器識別碼</th>
                    <th>要求的狀態</th>
                    <th>SPID</th>
                    <th>BlkBy</th>
                    <th>正在執行的 T-SQL 命令</th>
                    <th>CPU Time(ms)</th>
                    <th>開始時間</th>
                    <th>執行總時間(ms)</th>
                    <th>讀取數</th>
                    <th>寫入數</th>
                    <th>邏輯讀取數</th>
                    <th>資料庫名稱</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${data}" status="i" var="it">
                    <tr>
                        <td>
                            <g:if test="${it.執行總時間 > 3*60*1000}">
                                <g:link action="lock_table_del" id="${it.SPID}" class="btn btn-danger">删除</g:link>
                            </g:if>
                        </td>
                        <td>${_.formatDuration(it.執行總時間)}</td>
                        <td>${it.排程器識別碼}</td> 
                        <td>${it.要求的狀態}</td>
                        <td>${it.SPID}</td>
                        <td>${it.BlkBy}</td>
                        <td>${it['正在執行的 T-SQL 命令'].characterStream.text}</td>
                        <td>${it['CPU Time(ms)']}</td>
                        <td>${it.開始時間}</td>
                        <td>${it.執行總時間}</td>
                        <td>${it.讀取數}</td>
                        <td>${it.寫入數}</td>
                        <td>${it.邏輯讀取數}</td>
                        <td>${it.資料庫名稱}</td>
                    </tr>
                </g:each> 
            </tbody>
        </table>

    </div>
</div>

</body>
</html>
