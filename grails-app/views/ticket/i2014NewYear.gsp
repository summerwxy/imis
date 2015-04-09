<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    #input-barcode i.icon-barcode {
        font-size: 39px;
    }
    #input-barcode span.add-on {
        height: 40px;
    }
    #input-barcode input {
        height: 40px;
        font-size: 35px;
        line-height: 40px;
        font-weight: bold;
    }
    #input-barcode button {
        height: 50px;
    }
    </style>
    <script type="text/javascript">
    $(function() {
        // focus to input and bind checkBarcode on input
        $('#input_barcode').focus(function() {
            this.select();  
        }).focus().keyup(function(e) {
            if (e.keyCode == 13) {
                checkBarcode(e);
            } 
        });

        // template
        var tpl = _.template('<tr id="<\%= tid%\>"><td><\%= tno%\></td><td><\%= status%\></td></tr>');

        // check barcode via ajax
        function checkBarcode(e) {
            var tar = $('#input_barcode');
            // add to table list
            var tid = _.uniqueId('id_');
            $('#the_tbody').prepend(tpl({tid: tid, tno: tar.val(), status: '检查中'}));
            // ajax to check the status
            $.ajax({
                url: 'i2014NewYear_check',
                type: 'get',
                data: {tid: tid, tno: tar.val()},
                dataType: 'json'
            }).done(function(json) {
                var tds = $('#' + json.tid).addClass(json.classname).find('td');
                tds[1].innerHTML = json.status;
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });
            // empty input
            tar.val('');
        }

    })
    </script>
</head>
<content tag="title">2014年礼提货</content>
<content tag="subtitle">验证码检查</content>
<body>

<div class="row">
    <div class="span12 text-center">
        <div class="input-append" id="input-barcode">
            <span class="add-on">
                <i class="icon-barcode"></i>
            </span>
            <input class="input-xlarge" id="input_barcode" type="text" placeholder="输入验证码" />
            <div class="btn-group" data-toggle="buttons-radio">
                <button class="btn btn-primary">检查</button>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
            <table class="table table-hover table-condensed">
              <thead>
                <tr>
                  <th width="20%">验证码</th>
                  <th>验证结果</th>
                </tr>
              </thead>
              <tbody id="the_tbody">
              </tbody>
            </table>
    </div>
</div>
</body>
</html>
