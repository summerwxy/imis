<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <link rel="stylesheet" href="${resource(dir: 'bootstrap-datetimepicker/css', file: 'datetimepicker.css')}" />
	<link rel="stylesheet" href="${resource(dir: 'dropzone/css', file: 'dropzone.css')}" />
    <style>
    #input-picker i.icon-calendar {
        font-size: 39px;
    }
    #input-picker span.add-on {
        height: 40px;
    }
    #input-picker #picker {
        height: 40px;
        font-size: 35px;
        line-height: 40px;
        font-weight: bold;
    }
    #input-picker button {
        height: 50px;
    }
    .dropzone {
        min-height: 123px;
        background: none repeat scroll 0% 0% rgba(0, 0, 0, 0.4);
    }
    .center {
        text-align: center !important;
    }
    </style> 
    <script type="text/javascript" src="${resource(dir: 'bower_components/monthpicker', file: 'jquery.mtz.monthpicker.js')}"></script>
  	<script src="${resource(dir: 'dropzone', file: 'dropzone.min.js')}"></script>
    <script type="text/javascript">
    Dropzone.options.dropzone = {
        url: 'express_update_upload', 
        maxFiles: 1,
        maxFilesize: 1, // MB
        accept: function(file, done) {
            if (!file.name.toLowerCase().match(/^.*\.xls$/gi)) {
                done("只能上传 .xls 档案");
            } else {
                done();
            }
        },
        init: function() {
            this.on("success", function(file, text) {
                console.log(text);
                readXls(text);
            });
         }
    };

    var tpl_h = _.template('<tr><th>订单号</th><th>运单号</th><th>联系人</th><th>手机号</th><th>地址</th><th>状态</th></tr>');
    var tpl_b = _.template('<tr><td><\%=ono%\></td><td><\%=eno%\></td><td><\%=man%\></td><td><\%=tel%\></td><td><\%=address%\></td><td><\%=status%\></td></tr>');
    function readXls(text) {
        $.ajax({
            url: 'express_update_read_xls',
            type: 'get',
            data: {filename: text}, 
            dataType: 'json'
        }).done(function(json) {
            console.log(json);
            var data = $('#data')
            data.empty();
            data.append(tpl_h());
            $.each(json, function(k, v) {
                data.append(tpl_b(v));
            });
        }).fail(function(json) {
            alert('AJAX FAIL!');    
        });  
    } 

    $(function() {


    });
    </script>
</head>
<content tag="title">月饼快递（单号更新）</content>
<content tag="subtitle">批次更新单号</content>
<body>


<div class="row">
    <div class="span10 offset1">
        <h2>上传档案, 直接把档案拖拉到这边</h2>
        <div id="dropzone" class="dropzone"></div>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
        <table class="table table-condensed" id="data">
        </table>
    </div>
</div>
</body>
</html>
