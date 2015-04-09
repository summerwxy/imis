<!DOCTYPE html>
<html>
<head>
    <title>爱维尔门店</title>
	<meta name="layout" content="weixin"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
    .card {
    }
    </style> 
    <script type="text/javascript">
    </script>
</head>
<body>

<div class="container-fluid">
    <g:each in="${list}" status="i" var="it"> 
        <br/>
        <div class="row">
            <div class="col-xs-3 text-center">
                <img src="${resource(dir: 'images', file: 'pic1.jpg')}"/>
            </div>
            <div class="col-xs-9">
                门店：${it.S_NAME} <br/>
                电话：${it.S_TEL} <br/>
                地址：${it.S_ADDR}
            </div>
        </div>
        <div class="row">
            <div class="col-xs-4 text-center">
                <g:if test="${it.S_TEL}">
                    <a href="tel:${it.S_TEL?.trim()}"><span class="glyphicon glyphicon-earphone"></span> 打电话</a>
                </g:if>
                <g:else>
                    <a href="javascript:alert('没有电话号码！');"><span class="glyphicon glyphicon-earphone"></span> 打电话</a>
                </g:else>
            </div>
            <div class="col-xs-4 text-center">
                <!-- a href="http://apis.map.qq.com/uri/v1/routeplan?type=bus&fromcoord=CurrentLocation&referer=MyWeiPage&to=${it.S_ADDR?.trim()}" -->
                <a href="http://map.wap.soso.com/x/index.jsp?welcomeChange=1&open=1&address=${it.S_ADDR?.trim()}&name=${it.S_NAME?.trim()}&hideAdvert=hide&Y=${extData[it.S_NO].lat}&X=${extData[it.S_NO].lng}&type=infowindow">
                    <span class="glyphicon glyphicon-map-marker"></span> 查地图
                </a>
            </div>
            <div class="col-xs-4 text-center"><a href="javascript:alert('没照片可以看！');"><span class="glyphicon glyphicon-picture"></span> 看照片</a></div>
        </div>
        <hr/>
    </g:each>
</div>

</body>
</html>
