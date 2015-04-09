<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <link rel="stylesheet" href="${resource(dir: 'bootstrap-datetimepicker/css', file: 'datetimepicker.css')}" />
    <style>
    .cards {
        background: url("${resource(dir: '2014blessing', file: 'blessingbg.png')}") no-repeat scroll left top #FFFFFF;
    }
    .cards img {
        margin-top: 80px;
        margin-left: 150px;
    }
    .right {
        text-align: right;
        margin-right: 20px;
    }
    </style> 
    <script type="text/javascript">
    $(function() {
        // close sidebar
        $('#sidebar').addClass('menu-min');
    });

    </script>
</head>
<content tag="title">线上祈福</content>
<content tag="subtitle">2014祈福</content>
<body>
<div class="row-fluid">
    <div class="span2"></div>
    <div class="span8" style="text-align: center;">
        <g:link controller="y2014blessing" action="bless">
            <img src="${resource(dir: '2014blessing', file: 'blessbtn.png')}"/>
        </g:link>
    </div>
    <div class="span2"></div>
</div>
<br/><br/>
<g:each in="${lights}" var="it" status="i">
    <g:if test="${i % 4 == 0}">
        <div class="row-fluid">
    </g:if>
    <div class="span3 cards">
        <img src="${resource(dir: '2014blessing', file: it.light + '.png')}" />
        <h4>祈願 <u>${it.someone}</u></h4> 
        ${it.content} <br/>
        <h5 class="right">祈願人：<u>${it.pray}</u></h5>
    </div>
    <g:if test="${i % 4 == 3}">
        </div>
    </g:if>
</g:each>



</body>
</html>
