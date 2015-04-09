<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="w8"/>
    <script type="text/javascript">
    $(document).ready(function() {
        // close sidebar
        $('#sidebar').addClass('menu-min');
    });
    </script>
</head>
<content tag="title">会议</content>
<content tag="subtitle">会议详细内容</content>
<body> 
    <g:link class="btn btn-primary" action="index" params="[date: result.date]"><i class="icon-chevron-left"></i>返回日历</g:link>
    <div style="font-size: 180%; line-height: 130%; ">
        <div class="row-fluid">
            <div class="span2 text-right"><strong>主题: </strong></div>
            <div class="span10">${result.title}</div>
        </div>
        <div class="row-fluid">
            <div class="span2 text-right"><strong>时间: </strong></div>
            <div class="span10">${result.date} (${result.week}) ${result.start} ~ ${result.end}</div>
        </div>
        <div class="row-fluid">
            <div class="span2 text-right"><strong>地点: </strong></div>
            <div class="span10">${result.room}</div>
        </div>
        <div class="row-fluid">
            <div class="span2 text-right"><strong>内容: </strong></div>
            <div class="span10">${result.body}</div>
        </div>
    </div>
</body>
</html>
