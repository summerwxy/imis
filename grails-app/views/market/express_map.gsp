<!DOCTYPE html>  
<html lang="en">  
<head>  
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />  
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  
<title>中秋快递地图</title>  

<link href="${resource(dir: 'bootstrap/css', file: 'bootstrap.min.css')}" rel="stylesheet" />
<link href="${resource(dir: 'bootstrap/css', file: 'bootstrap-responsive.min.css')}" rel="stylesheet" />
<link rel="stylesheet" href="${resource(dir: 'themes/font-awesome/css', file: 'font-awesome.min.css')}" />
<style type="text/css">  
html{height:100%}  
body{height:100%;margin:0px;padding:0px}  
#container{height:100%}  
.row {
    padding: 0 0 0 35px;
}
#list {
    height: 100%;
    width: 0px;
    float: left; 
}
</style>  
</head>  
 
<body>  
<div id="list" class="container">
    <div class="row">
        <br/>
        <input id="txt" type="text" class="input-large" style="margin: 0;">
        <button id="search" type="button" class="btn"> <i class="icon-search"></i> 搜寻</button>
    </div>
    <div class="row">
        <hr/>
        <input type="checkbox" id="toggleZone" /> 
        <label for="toggleZone" style="display: inline;">显示行政区范围</label>
    </div>
    <div class="row">
        <hr/>
        <button type="button" class="btn" onClick="map.setMapStyle({style:'normal'});"> 默认 </button>
        <button type="button" class="btn" onClick="map.setMapStyle({style:'light'});"> 清新蓝 </button>
        <button type="button" class="btn" onClick="map.setMapStyle({style:'dark'});"> 黑夜 </button>
        <button type="button" class="btn" onClick="map.setMapStyle({style:'googlelite'});"> 精简 </button>
        <button type="button" class="btn" onClick="map.setMapStyle({style:'grayscale'});"> 高端灰 </button>
    </div>
    <div class="row">
        <hr/>
        <button id="showData" type="button" class="btn">显示Marker</button>
    </div>
    <div class="row">
        <hr/>
        <button id="testBtn" type="button" class="btn"> TEST </button>
    </div>
</div>

<div id="container"></div> 

<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=fvLAZfjIjb1EA8ANBkoIL5ri"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/TextIconOverlay/1.2/src/TextIconOverlay_min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/MarkerClusterer/1.2/src/MarkerClusterer_min.js"></script>
<script src="${resource(dir: 'bower_components/jquery/dist', file: 'jquery.min.js')}"></script>
<script src="${resource(dir: 'bootstrap/js', file: 'bootstrap.min.js')}"></script>
<script src="${resource(dir: 'js', file: 'underscore-min.js')}"></script>
<script type="text/javascript"> 
	// 百度地图API功能
	var map = new BMap.Map("container");    // 创建Map实例
	map.centerAndZoom("苏州", 9);  // 初始化地图,设置中心点坐标和地图级别
    map.addControl(new BMap.NavigationControl());    
    map.addControl(new BMap.ScaleControl());    
    map.addControl(new BMap.OverviewMapControl({isOpen: true}));    
    map.addControl(new BMap.MapTypeControl());    
	map.setCurrentCity("苏州");          // 设置地图显示的城市 此项是必须设置的
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
    map.setMapStyle({style:'googlelite'});

    // map data
    var data = ${data};
    var index = 0;
    var myGeo = new BMap.Geocoder();
    var markers = [];

    geocodeSearch();


    function geocodeSearch() {
        if (index >= data.length) {
            var markerClusterer = new BMapLib.MarkerClusterer(map, {markers:markers});
            return;
        }
        var tar = data[index];
        if (tar.lng && tar.lat) {
            showMarker(tar.lng, tar.lat, tar);
            index++;
            geocodeSearch();
        } else {
            myGeo.getPoint(tar.address, function(p) {
                if (p) {
                    showMarker(p.lng, p.lat, tar);
                    $.ajax({
                        url: 'express_map_lng_lat',
                        type: 'post',
                        data: {id: tar.id, lng: p.lng, lat: p.lat}, 
                        dataType: 'json'
                    }).done(function(json) {
                        if (console) {
                            console.log('save lnt lat okay');
                        }
                    }).fail(function(json) {
                        if (console) {
                            console.log('AJAX FAIL');
                        }
                    });  
                } else {
                    if (console) {
                        console.log(tar);
                    }
                }
                index++;
                geocodeSearch();
            });
        }
    }

    function showMarker(lng, lat, tar) {
        var point = new BMap.Point(lng, lat);
        var label = new BMap.Label(tar.address, {offset: new BMap.Size(20, -10)});
        var marker = new BMap.Marker(point);
        markers.push(marker);
        map.addOverlay(marker);
        marker.addEventListener('click', function(e) {
            var content = tar.address
            var title = tar.name + ': ' + tar.phone
            var infoWindow = new BMap.InfoWindow(content, {width: 250, height: 80, title: title});
            map.openInfoWindow(infoWindow, point);
        });    
    }

    
</script>  
</body>  
</html>
