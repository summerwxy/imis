<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8_pos"/>
    <style type="text/css" media="screen">

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
<content tag="title">门店单品项退货明细</content>
<content tag="subtitle">（退货率超8%的品项）</content>
<body>

<form method="POST">

<div class="row">
    <div class="span10 offset1">
        <g:if test="${flash.msg}">
            <div class="alert alert-info text-center">${flash.msg}</div>
        </g:if>
        <table class="table">
            <tr>
                <td>${s_name}</td>
                <td>
                    日期: 
                    <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input">
                        <input class="input-small" type="text" id="the_day" name="the_day" value="${the_day}" readonly>
                        <span class="add-on"><i class="icon-th"></i></span>
                    </div>
                    <input type="submit" name="qbtn" id="qbtn" class="btn btn-primary" value="查询" />
                </td>
                <td>
                    <g:if test="${refundSign}">
                        ${refundSign.opName} ${iwill._.date2String(refundSign.dateCreated, 'yyyy/MM/dd HH:mm:ss')}
                    </g:if>
                    <g:if test="${s_no && !refundSign}">
                        <form method="POST">
                            POS帐号: <input type="text" name="account" class="input-small"/><br/>
                            POS密码: <input type="password" name="password" class="input-small"/>
                            <button type="submit" name="signit" value="hmm" class="btn btn-primary">${s_name}看了</button>
                        </form>
                    </g:if>                
                </td>
            </tr>
        </table>



        <table class="table table-condensed">
            <thead>
                <tr>
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
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
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
    

    </div>
</div>

</form>
    

</body>
</html>
