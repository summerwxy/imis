<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8_pos"/>
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

    })
    </script>
</head>
<content tag="title">签报单</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">

        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>编号</th>
                    <th>标题</th>
                    <th>日期</th>
                    <th>经办人</th>
                    <th>查看内容</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td>${it.code}</td> 
                        <td>${it.title}</td> 
                        <td>${it.annDate}</td> 
                        <td>${it.handler}</td> 
                        <td>
                            <g:link action="ann_detail_pos" id="${it.id}" class="btn btn-primary">
                                查看内容
                            </g:link>
                        </td>
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
