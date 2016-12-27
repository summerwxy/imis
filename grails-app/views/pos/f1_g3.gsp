<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8_g3"/>
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
        var tpl = _.template('<tr id="<\%= tid%\>"><td><\%= tno%\></td><td><\%= status%\></td><td><\%= sname%\></td><td><\%= date%\></td></tr>');

        // check barcode via ajax
        function checkBarcode(e) {
            var tar = $('#input_barcode');
            // add to table list
            var tid = _.uniqueId('id_');
            $('#the_tbody').prepend(tpl({tid: tid, tno: tar.val(), status: '检查中', sname: '', date: ''}));
            // ajax to check the status
            $.ajax({
                url: 'f1_check',
                type: 'get',
                data: {tid: tid, tno: tar.val(), is_update: $('#is_update').val()},
                dataType: 'json'
            }).done(function(json) {
                var tds = $('#' + json.tid).addClass(json.classname).find('td');
                tds[1].innerHTML = json.status;
                tds[2].innerHTML = json.sname;
                tds[3].innerHTML = json.date;
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });
            // empty input
            tar.val('');
        }

        // set button color and bind event
        $('#input-barcode button').click(updateButton);
        function updateButton() {
            if (parseInt($('#is_update').val())) { 
                $('#input-barcode button:eq(0)').addClass('btn-primary'); 
                $('#input-barcode button:eq(1)').removeClass('btn-primary'); 
                $('#is_update').val(0);
                $('#input_barcode').focus();
            } else {
                $('#input-barcode button:eq(0)').removeClass('btn-primary'); 
                $('#input-barcode button:eq(1)').addClass('btn-primary'); 
                $('#is_update').val(1);
                $('#input_barcode').focus();
            }
        }
        // run once onload
        updateButton();

    })
    </script>
</head>
<content tag="title">回收券检查</content>
<content tag="subtitle">检查回收的条码券是否正常被使用</content>
<body>

<div class="row">
    <div class="span12 text-center">
        <div class="input-append" id="input-barcode">
            <span class="add-on">
                <i class="icon-barcode"></i>
            </span>
            <input class="input-xxlarge" id="input_barcode" type="text" placeholder="输入条码编号" />
            <div class="btn-group" data-toggle="buttons-radio">
                <button class="btn">只检查状态</button>
                <button class="btn">检查并更新</button>
            </div>
            <input type="hidden" id="is_update" name="is_update" value="0"/>            
        </div>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
    

            <table class="table table-hover table-condensed">
              <thead>
                <tr>
                  <th>券号</th>
                  <th>状态</th>
                  <th>回收门店</th>
                  <th>回收日期</th>
                </tr>
              </thead>
              <tbody id="the_tbody">
              </tbody>
            </table>

    </div>
</div>

    
</body>
</html>
