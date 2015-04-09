<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>

    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    $(function() {
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });

        $('#btn3').on('click', function() {
            window.open('refund_excel?the_day=' + $('#the_day').val());
        });
    })
    </script>
</head>
<content tag="title">单品退货管理</content>
<content tag="subtitle">检查门店查看退货的记录</content>
<body>

<div class="row">
    <div class="span10 offset1">
        <form method="POST">
            日期: 
            <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input">
                <input class="input-small" type="text" id="the_day" name="the_day" value="${the_day}" readonly>
                <span class="add-on"><i class="icon-th"></i></span>
            </div>
            <input type="submit" name="btn1" id="btn1" class="btn btn-primary" value="查记录" />
            <input type="submit" name="btn2" id="btn2" class="btn btn-info" value="查退货" />
            <input type="button" name="btn3" id="btn3" class="btn btn-info" value="下载退货明细" />
            <g:if test="${params.btn1}">
                <table class="table table-condensed">
                    <thead>
                        <tr>
                            <th>区域</th>
                            <th>门店</th>
                            <th>电话</th>
                            <th>签名</th>
                        </tr>
                    </thead>
                    <tbody id="data1">
                        <g:each in="${list1}" status="i" var="it">
                            <tr class="${(it.dt) ? 'success': 'error'}">
                                <td>${it.R_NAME}</td> 
                                <td>${it.S_NAME}</td> 
                                <td>${it.S_TEL}</td> 
                                <td>${it.op_name} ${it.dt}</td>
                            </tr>
                        </g:each> 
                    </tbody>
                </table>
            </g:if>
            <g:if test="${params.btn2}">
                <table class="table table-condensed">
                    <thead>
                        <tr>
                            <th>编号</th>
                            <th>门店</th>
                            <th>品号</th>
                            <th>品名</th>
                            <th>订货</th>
                            <th>进货</th>
                            <th>差异</th>
                            <th>生产入库</th>
                            <th>期初</th>
                            <th>调拨</th>
                            <th>退货</th>
                            <th>销售</th>
                            <th>退货百分比(%)</th>
                        </tr>
                    </thead>
                    <tbody id="data2">
                        <g:each in="${list2}" status="i" var="it">
                            <tr>
                                <td>${it.S_NO}</td>
                                <td>${it.S_NAME}</td> 
                                <td>${it.P_NO}</td>
                                <td>${it.P_NAME}</td> 
                                <td>${it.PO_QTY as int}</td> 
                                <td>${it.IN_QTY as int}</td> 
                                <td>${it.PO_QTY - it.IN_QTY as int}</td> 
                                <td>${it.SST_QTY as int}</td>
                                <td>${it.PS_QTY as int}</td>
                                <td>${it.TR_IN_QTY - it.TR_OUT_QTY as int}</td>
                                <td>${it.BA_QTY as int}</td>
                                <td>${it.SL_QTY as int}</td>
                                <td>${it.BA_PRCNT ? (it.BA_PRCNT as int).toString() + '%' : 'N/A'}</td>
                            </tr>
                        </g:each> 
                    </tbody>
                </table>
            </g:if>
            
        </form>

    </div>
</div>

</body>
</html>
