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
<content tag="title">签报单管理</content>
<content tag="subtitle">发布与管理签报单</content>
<body>

<div class="row">
    <div class="span10 offset1">
        <g:link action="ann_add" class="btn btn-primary">新增</g:link>
        门店使用的网址: ${ann_url}/123.htm 
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>编号</th>
                    <th>标题</th>
                    <th>日期</th>
                    <th>经办人</th>
                    <th>查看记录</th>
                    <th>查看内容</th>
                    <th>删除</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td>
                            ${it.code}
                        </td> 
                        <td>${it.title}</td> 
                        <td>${it.annDate}</td> 
                        <td>${it.handler}</td> 
                        <td>
                            <g:link action="ann_log" id="${it.id}" class="btn btn-primary">
                                查看记录
                            </g:link>
                        </td>
                        <td>
                            <g:if test="${it.pageType == 'static'}">
                                <a href="${ann_url}/pages/${it.code}.htm" target="_blank" class="btn btn-primary">
                                    查看内容
                                </a>
                            </g:if>
                            <g:if test="${it.pageType == 'url'}">
                                <a href="${it.url}" target="_blank" class="btn btn-primary">
                                    查看内容
                                </a>
                            </g:if>
                        </td>
                        <td><g:link action="ann_del" id="${it.id}" class="btn btn-danger delbtn">删除</g:link></td> 
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
