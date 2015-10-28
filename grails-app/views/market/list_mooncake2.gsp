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
        var btns = $('.kdBtn');
        btns.click(function() {
            var i = btns.index(this);
            var express_no = $('[name=express_no]:eq(' + i + ')').val();
            var id = $('[name=id]:eq(' + i + ')').val();
            $.ajax({
                url: 'save_express_no2',
                type: 'post',
                data: {express_no: express_no, id: id}, 
                dataType: 'json'
            }).done(function(json) {
                alert('保存成功!');
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });  
        });
    })
    </script>
</head>
<content tag="title">月饼快递</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">

        <a class="btn btn-primary" href="list_mooncake2">没快递单号</a>
        <a class="btn" href="list_mooncake2?show=express">有快递单号</a>


        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>id</th>
                    <th>收件人</th>
                    <th>市</th>
                    <th>费用</th>
                    <th>礼盒</th>
                    <th>状态</th>
                    <th>券</th>
                    <th>顺丰快递</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr class="${it.status == 'unpaid' ? 'error' : 'success'}">
                        <td>${it.id}</td> 
                        <td>${it.name}</td> 
                        <td>${it.lv2}</td> 
                        <td>${it.fee}</td>
                        <td>${it.boxs.replace(', ', '<br/>')}</td>
                        <td>${it.status == 'unpaid' ? '未付款' : '已付款'}</td> 
                        <td>
                            <g:if test="${it.status == 'unpaid' && it.tickets.indexOf('已') != -1}">
                                ${it.tickets.replace(', ', '<br/>')}
                                <br/>[拿券来工厂提货]
                            </g:if>
                            <g:else>
                                <g:each in="${it.ticketsList}" status="ii" var="itt">
                                    <g:if test="${it.status == 'paid'}">
                                        <g:img uri="/api/barcode?code=${itt[0..15]}&w=150&h=50"/> 
                                        <br/>
                                    </g:if>
                                    ${itt}
                                    <br/>
                                </g:each>
                            </g:else>
                        </td>
                        <td>
                            <input type="text" name="express_no" value="${it.express_no}">
                            <input type="hidden" name="id" value="${it.id}"/>
                            <button class="btn btn-info kdBtn">快递</button>
                        </td> 
                    </tr>
                </g:each> 
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
