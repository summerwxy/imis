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
        var tpl = _.template('<tr><td><\%=SUB_NAME%\></td><td><\%=D_CNAME%\></td><td><\%=P_NO%\></td><td><\%=P_NAME%\></td><td><\%=P_SPMODE%\></td><td><\%=UN_NO%\></td><td><\%=P_PRICE%\></td><td><\%=P_STATUS%\><\%=P_STATUS_NAME%\></td><td><\%=P_PDA%\></td></tr>');
 
        $('#part').keypress(throttle(function() {
            $.ajax({
                url: 'part_query',
                type: 'get',
                data: {q: this.value, w: 'part'}, 
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

        $('#pda').click(function() {
            $.ajax({
                url: 'part_query',
                type: 'get',
                data: {q: this.value, w: 'pda'}, 
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
        });
    })
    </script>
</head>
<content tag="title">物料查询</content>
<content tag="subtitle">查询 POS 物料资料</content>
<body>

<div class="row">
    <div class="span10 offset1">
        物料: <input id="part" type="text" /> (拼音，繁体，简体，品号，max 200) 
        | <button id="pda" type="button" class="btn btn-primary">列出PDA出错料号</button>
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>大分类</th>
                    <th>中分类</th>
                    <th>品号</th>
                    <th>品名</th>
                    <th>规格</th>
                    <th>单位</th>
                    <th>单价</th>
                    <th>状态</th>
                    <th>PDA</th>
                </tr>
            </thead>
            <tbody id="data"></tbody>
        </table>
    </div>
</div>
    
</body>
</html>
