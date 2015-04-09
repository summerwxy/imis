<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    function throttle(f, delay){
        var timer = null;
        return function(){
            var context = this, args = arguments;
            clearTimeout(timer);
            timer = window.setTimeout(function(){
                f.apply(context, args);
            },
            delay || 500);
        };
    }
    $(function() {
        var tpl = _.template('<tr><td><\%=S_NO%\></td><td><\%=S_NAME%\></td><td><\%=R_NAME%\></td><td><\%=S_TEL%\></td><td><\%=S_IP%\></td><td><\%=S_STATUS_NAME%\></td></tr>');
 
        $('#store').keypress(throttle(function() {
            $.ajax({
                url: 'store_query',
                type: 'get',
                data: {q: this.value}, 
                dataType: 'json'
            }).done(function(json) {
                var data = $('#data')
                data.empty();
                $.each(json, function(k, v) {
                    data.append(tpl(v));
                });
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });                
        }));
    })
    </script>
</head>
<content tag="title">门店查询</content>
<content tag="subtitle">查询 POS 门店资料</content>
<body>
    
<div class="row">
    <div class="span10 offset1">
        门店: <input id="store" type="text" /> (拼音, 电话)
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>门店代号</th>
                    <th>门店名称</th>
                    <th>区域</th>
                    <th>电话</th>
                    <th>IP</th>
                    <th>状态</th>
                </tr>
            </thead>
            <tbody id="data"></tbody>
        </table>
    </div>
</div>


</body>
</html>
