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
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });
    })
    </script>
</head>
<content tag="title">销售与退货</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">
        <form method="POST">
            日期: 
            <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input">
                <input class="input-small" type="text" id="sdate" name="sdate" value="${params.sdate}" readonly>
                <span class="add-on"><i class="icon-th"></i></span>
            </div>
            ~
            <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input">
                <input class="input-small" type="text" id="edate" name="edate" value="${params.edate}" readonly>
                <span class="add-on"><i class="icon-th"></i></span>
            </div>
            <input type="submit" name="qbtn" id="qbtn" class="btn btn-primary" value="查询" />
        </form>
    </div>
</div>
 <div class="row">
    <div class="span10 offset1">
        <g:each in="${data}" status="i" var="set">
            <h3>${set.key}</h3>
            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>门店</th>
                        <th>类别</th>
                        <th>品号</th>
                        <th>品名</th>
                        <th>进货数量</th>
                        <th>进货金额</th>
                        <th>生产数量</th>
                        <th>生产金额</th>
                        <th>退货数量</th>
                        <th>退货金额</th>
                        <th>销售数量</th>
                        <th>销售金额</th>
                        <th>转入数量</th>
                        <th>转入金额</th>
                        <th>转出数量</th>
                        <th>转出金额</th>
                        <th>退货率</th>
                    </tr>
                </thead>
                <tbody id="data">
                    <g:each in="${set.value}" status="j" var="it">
                        <tr>
                            <td nowrap>${it.S_NO} ${it.S_NAME}</td>
                            <td nowrap>${it.category}</td>
                            <td nowrap>${it.P_NO}</td>
                            <td nowrap>${it.P_NAME}</td>
                            <td nowrap>${it.in_qty}</td>
                            <td nowrap>${it.in_amt}</td>
                            <td nowrap>${it.sst_qty}</td>
                            <td nowrap>${it.sst_amt}</td>
                            <td nowrap>${it.ba_qty}</td>
                            <td nowrap>${it.ba_amt}</td>
                            <td nowrap>${it.sl_qty}</td>
                            <td nowrap>${it.sl_amt}</td>
                            <td nowrap>${it.tr_in_qty}</td>
                            <td nowrap>${it.tr_in_amt}</td>
                            <td nowrap>${it.tr_out_qty}</td>
                            <td nowrap>${it.tr_out_amt}</td>
                            <td nowrap>${it.back_rate * 100} %</td>
                        </tr>
                    </g:each> 
                </tbody>
            </table>
        </g:each>
    </div>
</div>
       

</body>
</html>
