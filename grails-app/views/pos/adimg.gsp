<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
	<script src="${resource(dir: 'dropzone', file: 'dropzone.min.js')}"></script>
	<link rel="stylesheet" href="${resource(dir: 'dropzone/css', file: 'dropzone.css')}" />
    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    Dropzone.options.myId = {
        url: 'adimg_upload', 
        maxFilesize: 2, // MB
        accept: function(file, done) {
            if (!file.name.toLowerCase().match(/^.*\.jpe?g$/gi)) {
                done("只能上传 .jpg 档案");
            } else {
                done();
            }
        }
    };
    
    $(function() {
        $('#myTab a').click(function (e) {
            e.preventDefault();
            $(this).tab('show');
        });

        // template
        var tpl = _.template('<tr id="<\%=id%\>"><td><img width="120" height="120" src="../upload/ad/<\%=img%\>" ></td><td><\%=name%\></td><td><\%=size%\></td><td><\%=date%\></td><td><a href="#<\%=del%\>"><i class="icon-remove"></i></a></td></tr>');
        
        $('#imagesTab').click(function(e) {
            // ajax to load images
            $.ajax({
                url: 'adimg_getimgs',
                type: 'get',
                dataType: 'json'
            }).done(function(json) {
                $('#the_tbody').empty();
                $.each(json, function(k, v) {
                    $('#the_tbody').append(tpl({id: v.name, img: v.name, name: v.name, size: v.length, date: v.date, del: v.name}));
                });
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });            
        });

        $('#the_tbody').on('click', 'a', function(event) {
            if (confirm("是否删除 ?")) {
                $.ajax({
                    url: 'adimg_del',
                    type: 'get',
                    data: {file: this.href.match(/[^#]*\.jpe?g/ig)[0]},
                    dataType: 'json'
                }).done(function(json) {
                    $(document.getElementById(json.file)).remove()
                }).fail(function(json) {
                    alert('AJAX FAIL!');    
                });                    
            }
        });

        $('#stores button').click(function(event) {
            var ip = $(this).attr('ip'); 
            $(document.getElementById(ip)).html('下载中...');
            $.ajax({
                url: 'adimg_download',
                type: 'get',
                data: {ip: ip},
                dataType: 'json'
            }).done(function(json) {
                $(document.getElementById(json.ip)).html(json.msg);
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });   
        });
    })
    </script>
</head>
<content tag="title">客显图片</content>
<content tag="subtitle">上传广告图片</content>
<body>

<div class="alert alert-info">
    <ul>
        <li>图片后缀 .jpg</li>
        <li>图片大小 宽 640 高 478 (大小是由客显算出来的 w 640 * h H-290, W1024*H768)</li>
    </ul>
</div>

<ul class="nav nav-tabs" id="myTab">
    <li class="attive"><a href="#upload">上传新图片</a></li>
    <li><a id="imagesTab" href="#images">主机上的图片</a></li>
    <li><a href="#stores">下载到门店</a></li>
</ul>

<div class="tab-content">
    <div class="tab-pane active" id="upload">
        <div id="myId" class="dropzone"></div>
    </div>
    <div class="tab-pane" id="images">
        <table class="table">
            <thead>
                <tr>
                    <th>缩图</th>
                    <th>档名</th>
                    <th>大小</th>
                    <th>日期</th>
                    <th>删除</th>
                </tr>
            </thead>
            <tbody id="the_tbody">
            </tbody>
        </table>
    </div>
    <div class="tab-pane" id="stores">
        <table class="table table-condensed">
            <tr>
                <th>门店</th>
                <th>IP</th>
                <th>下载</th>
                <th>状态</th>
            </tr>
            <g:each in="${list}">
            <tr>
                <td>${it.S_NO} ${it.S_NAME}</td>
                <td>${it.ip}</td>
                <td>
                    <button class="btn btn-primary" type="button" ip="${it.ip}">下载</button>
                </td>
                <td>
                    <div id="${it.ip}"></div>
                </td>
            </tr>
            </g:each>
        </table>
    </div>
</div>
</body>
</html>
