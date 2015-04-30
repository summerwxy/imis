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
        // month picker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            autoclose: 1,
            startView: 3,
            minView: 3,
            format: 'yyyy-mm',
            forceParse: 0
        });
        // datetimepicker
        /*
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });
        */
    })
    </script>
</head>
<content tag="title">实际业绩升降</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">
        <form method="POST">
            年月: 
            <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input">
                <input class="input-small" type="text" id="sdate" name="sdate" value="${params.sdate}" readonly>
                <span class="add-on"><i class="icon-th"></i></span>
            </div>
            <input type="submit" name="qbtn" id="qbtn" class="btn btn-primary" value="查询" />
        </form>
    </div>
</div>
 <div class="row">
    <div class="span10 offset1">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>门店代码</th>
                    <th>门店名称</th>
                    <th>日期</th>
                    <th>营业总额</th>
                    <th>实际业绩</th>
                    <th>总客流量</th>
                    <th>日目标</th>
                    <th>达成率</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${data}" status="i" var="row">
                    <tr>
                        <td nowrap>${row.门店代码}</td>
                        <td nowrap>${row.门店名称}</td>
                        <td nowrap>${row.日期}</td>
                        <td nowrap>${row.营业总额}</td>
                        <td nowrap>${row.实际业绩}</td>
                        <td nowrap>${row.总客流量}</td>
                        <td nowrap>${Math.round(row.日目标 * 10) / 10}</td>
                        <td nowrap>
                            <g:if test="${row.日目标}">
                                ${Math.round(row.实际业绩 / row.日目标 * 10000) / 100} %
                            </g:if>
                            <g:else>
                                N/A
                            </g:else> 
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </div>
</div>
       

</body>
</html>
