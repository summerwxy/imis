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
        url: 'page1_upload', 
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
                readXls(text);
            });
         }
    };

    var tpl_h = _.template('<tr><th>门店编号</th><th>门店名称</th><th>月份</th><th>天数</th><th>系统目标(更新前)</th><th>Excel目标(更新后)</th></tr>');
    var tpl_b = _.template('<tr><td><\%=sNo%\></td><td><\%=sName%\></td><td><\%=months%\></td><td><\%=days%\></td><td class="center"><\%=monthTargetSql%\></td><td class="center"><\%=monthTargetXls%\><input type="hidden" name="s_no" value="<\%=sNo%\>"/><input type="hidden" name="months" value="<\%=months%\>"/><input type="hidden" name="days" value="<\%=days%\>"/><input type="hidden" name="month_target" value="<\%=monthTargetXls%\>"/></td></tr>');
    function readXls(text) {
        $.ajax({
            url: 'page1_read_xls',
            type: 'get',
            data: {filename: text}, 
            dataType: 'json'
        }).done(function(json) {
            var data = $('#data')
            data.empty();
            data.append(tpl_h());
            $.each(json, function(k, v) {
                data.append(tpl_b(v));
            });
            $('#update').show();
        }).fail(function(json) {
            alert('AJAX FAIL!');    
        });  
    } 

    $(function() {
        var options = {
            pattern: 'yyyy-mm',
            selectedYear: (new Date).getFullYear(),
            startYear: (new Date).getFullYear() - 2,
            finalYear: (new Date).getFullYear() + 1,
            monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一', '十二']
        }
        $('#picker').monthpicker(options);

        $('#download').click(function() {
            var month = $('#picker').val();
            if (month.length > 0) {
                window.location.href = 'page1_download?month=' + month;    
            } else {
                // do nothing
            }
        });
    });
    </script>
</head>
<content tag="title">门店业绩</content>
<content tag="subtitle">门店业绩资料上传</content>
<body>

<div class="row">
    <div class="span10 offset1">
        <h2>步骤一：下载 excel 模板</h2>
        <div class="input-append" id="input-picker">
            <span class="add-on">
                <i class="icon-calendar"></i>
            </span>
            <input id="picker" type="text" placeholder="选择月份" />

            <div class="btn-group" data-toggle="buttons-radio">
                <button id="download" class="btn btn-primary">下载</button>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
        <h2>步骤二：编辑 excel, 在绿色部分输入月目标, 其他地方不要改</h2>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
        <h2>步骤三：上传档案, 如果已有资料会直接覆盖</h2>
        <div id="dropzone" class="dropzone"></div>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
        <h2>步骤四：确认并更新（更新按钮在最底下）</h2>
        <form action="page1" method="POST">
            <table class="table table-condensed" id="data">
            </table>
            <button id="update" style="display: none;" type="submit" class="btn btn-primary">更新</button>
        </form>
    </div>
</div>
</body>
</html>
