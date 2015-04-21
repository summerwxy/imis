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
    td {
        
    }
    </style>
    <script type="text/javascript">
    $(function() {
        // datetimepicker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            autoclose: 1,
            startView: 3,
            minView: 3,
            format: 'yyyy-mm',
            forceParse: 0
        });
    })
    </script>
</head>
<content tag="title">实际业绩升降</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">
        <form method="POST">
            年-月: 
            <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input">
                <input class="input-small" type="text" id="the_month" name="the_month" value="${params.the_month}" readonly>
                <span class="add-on"><i class="icon-th"></i></span>
            </div>
            <input type="submit" name="qbtn" id="qbtn" class="btn btn-primary" value="查询" />
        </form>
    </div>
</div>
 <div class="row">
    <div class="span10 offset1">
        <g:if test="${row}">
            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>门店代码</th>
                        <th>门店名称</th>
                        <th>去年同月营业天数</th>
                        <th>上月营业天数</th>
                        <th>${params.the_month[5..6]}月营业天数</th>
                        <th>去年同月实际业绩</th>
                        <th>上月实际业绩</th>
                        <th>${params.the_month[5..6]}月实际业绩</th>
                        <th>去年同月业绩升降</th>
                        <th>业绩升降</th>
                        <th>去年同月升降比率</th>
                        <th>升降比率</th>
                        <th>业绩目标</th>
                        <th>达标率</th>
                    </tr>
                </thead>
                <tbody id="data">
                    <tr>
                        <td nowrap>${row.门店代码}</td>
                        <td nowrap>${row.门店名称}</td>
                        <td nowrap>${row.去年同月营业天数}</td>
                        <td nowrap>${row.上月营业天数}</td>
                        <td nowrap>${row.营业天数}</td>
                        <td nowrap>${row.去年同月实际业绩}</td>
                        <td nowrap>${row.上月实际业绩}</td>
                        <td nowrap>${row.实际业绩}</td>
                        <td nowrap>${row.去年同月业绩升降}</td>
                        <td nowrap>${row.业绩升降}</td>
                        <td nowrap>${Math.round(row.去年同月升降比率 * 10000) / 100} %</td>
                        <td nowrap>${Math.round(row.升降比率 * 10000) / 100} %</td>
                        <td nowrap>${row.业绩目标}</td>
                        <td nowrap>${Math.round(row.达标率 * 10000) / 100} %</td>
                    </tr>
                </tbody>
            </table>
        </g:if>
    </div>
</div>
       

</body>
</html>
