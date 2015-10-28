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
                url: 'save_express_no',
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

        <a class="btn btn-primary" href="list_mooncake">没快递单号</a>
        <a class="btn" href="list_mooncake?show=express">有快递单号</a>

    
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>id</th>
                    <th>收件人</th>
                    <th>联系电话</th>
                    <th>送货地址</th>
                    <th>品名</th>
                    <th>券号</th>
                    <th>状态</th>
                    <th>快递单号</th>
                    <th>功能</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td>${it.id}</td> 
                        <td>${it.name}</td> 
                        <td>${it.phone}</td> 
                        <td>
                            ${(it.address.length() > 6)? it.address[0..5] : it.address}
                        </td> 
                        <td>${it.P_NAME}</td> 
                        <td>
                            <g:img uri="/api/barcode?code=${it.GT_NO}&w=150&h=50"/>
                            <br/>
                            ${it.GT_NO}
                        </td>
                        <td>
                            ${it.BACK_NUM == 0 ? '未提货' : '已提货'} 
                        </td>
                        <td><input type="text" name="express_no" value="${it.express_no}"></td>
                        <td>
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
