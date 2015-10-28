<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    .pagination {
        background-color: #EFEFEF;
        border-top: 0 none;
        box-shadow: 0 0 3px 1px #AAAAAA;
        margin: 0;
        padding: 0.3em 0.2em;
        text-align: center;
    }
    .pagination a, .pagination .currentStep {
        border-radius: 0.3em;
        color: #666666;
        display: inline-block;
        margin: 0 0.1em;
        padding: 0.25em 0.7em;
        text-decoration: none;
    }
    .pagination a:hover, .pagination a:focus, .pagination .currentStep {
        background-color: #999999;
        color: #FFFFFF;
        outline: medium none;
        text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.8);
    }
    .no-borderradius .pagination a:hover, .no-borderradius .pagination a:focus, .no-borderradius .pagination .currentStep {
        background-color: rgba(0, 0, 0, 0);
        color: #444444;
        text-decoration: underline;
    }
    </style>
    <script type="text/javascript">
    $(function() {
        $('.delbtn').click(function() {
            if (!confirm("确认删除吗？")) {
                return false; 
            }       
        });
    })
    </script>
</head>
<content tag="title">证件提醒</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">
        <g:link action="add" class="btn btn-success">新增</g:link>
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>序号</th>
                    <th>证件名称</th>
                    <th>证件类型</th>
                    <th>证件有效期</th>
                    <th>年检时间</th>
                    <th>证件所属性质</th>
                    <th>天数</th>
                    <th>状态</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td><g:link action="edit" id="${it.id}">${it.id}</g:link></td> 
                        <td>${it.name}</td> 
                        <td>${imis.RemindController.papers[it.type]}</td> 
                        <td>${it.sdate} ~ ${it.edate}</td> 
                        <td>${it.cdate}</td>
                        <td>${imis.RemindController.owner[it.owner]}</td>
                        <td>${it.days}</td>
                        <td>${imis.RemindController.status[it.status]}</td> 
                    </tr>
                </g:each> 
            </tbody>
        </table>
        <div class="pagination">
            <g:paginate total="${total}" next="下一页" prev="上一页"/>
        </div>

    </div>
</div>

</body>
</html>
