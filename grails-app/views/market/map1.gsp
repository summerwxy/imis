<!DOCTYPE html>  
<html lang="en">  
<head>  
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />  
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  
<title>Hello, World</title>  

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
    width: 310px;
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
        <!--
        <select>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style01.png); background-repeat: no-repeat;">　　01</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style02.png); background-repeat: no-repeat;">　　02</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style03.png); background-repeat: no-repeat;">　　03</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style04.png); background-repeat: no-repeat;">　　04</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style05.png); background-repeat: no-repeat;">　　05</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style06.png); background-repeat: no-repeat;">　　06</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style07.png); background-repeat: no-repeat;">　　07</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style08.png); background-repeat: no-repeat;">　　08</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style09.png); background-repeat: no-repeat;">　　09</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style10.png); background-repeat: no-repeat;">　　10</option>
            <option style="background-image:url(http://lbsyun.baidu.com/map/resource/geodata/css/images/style11.png); background-repeat: no-repeat;">　　11</option>
        </select> 
        -->
    </div>
    <div class="row">
        <hr/>
        <button id="testBtn" type="button" class="btn"> TEST </button>
    </div>
</div>

<div id="container"></div> 

<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=fvLAZfjIjb1EA8ANBkoIL5ri"></script>
<script src="${resource(dir: 'bower_components/jquery/dist', file: 'jquery.min.js')}"></script>
<script src="${resource(dir: 'bootstrap/js', file: 'bootstrap.min.js')}"></script>
<script src="${resource(dir: 'js', file: 'underscore-min.js')}"></script>
<script type="text/javascript"> 
var map = new BMap.Map("container");          // 创建地图实例  
// init map center
//var point = new BMap.Point(116.404, 39.915);  // 创建点坐标  
map.centerAndZoom("苏州", 13);                 // 初始化地图，设置中心点坐标和地图级别  
// add controller

map.addControl(new BMap.NavigationControl());    
map.addControl(new BMap.ScaleControl());    
map.addControl(new BMap.OverviewMapControl({isOpen: true}));    
map.addControl(new BMap.MapTypeControl());    
map.setCurrentCity("苏州");
map.enableScrollWheelZoom(true);

// ============== list all marker =============
var data = ${data};
// ============= icon =============
var i01 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style01.png", new BMap.Size(12, 15)); // pink
var i02 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style02.png", new BMap.Size(12, 15)); // navy
var i03 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style03.png", new BMap.Size(12, 15)); // blue
var i04 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style04.png", new BMap.Size(12, 15)); // green
var i05 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style05.png", new BMap.Size(12, 15)); // black
var i06 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style06.png", new BMap.Size(12, 15)); // gray
var i07 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style07.png", new BMap.Size(12, 15)); // purple
var i08 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style08.png", new BMap.Size(12, 15)); // red
var i09 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style09.png", new BMap.Size(12, 15)); // pink2
var i10 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style10.png", new BMap.Size(12, 15)); // orange
var i11 = new BMap.Icon("http://lbsyun.baidu.com/map/resource/geodata/css/images/style11.png", new BMap.Size(12, 15)); // yellow


// ==============  search =================
var tpl_info = _.template('名称: <input type="text" id="info_name" value="${raw('<%=name%>')}"><br/>lat: <input type="text" id="info_lat" value="${raw('<%=lat%>')}"><br/>lng: <input type="text" id="info_lng" value="${raw('<%=lng%>')}"><br/>tag: <input type="text" id="info_tag" value="${raw('<%=tag%>')}"><br/>地址: <input type="text" id="info_address" value="${raw('<%=address%>')}" class="input-xxlarge"><br/>电话: <input type="text" id="info_phone" value="${raw('<%=phone%>')}"><br/><button id="info_save" onClick="info_save();">储存</button><input type="hidden" id="info_uid" value="${raw('<%=uid%>')}">');
var searchMarker = [];
$('#search').on('click', function() {
  var options = {      
    onSearchComplete: function(results){      
      if (local.getStatus() == BMAP_STATUS_SUCCESS){      
        // remove marker
        for (var i = 0; i < searchMarker.length; i++) {
            map.removeOverlay(searchMarker[i]);
        }
        searchMarker = [];
        console.log('total result: ' + results.getCurrentNumPois());
        for (var i = 0; i < results.getCurrentNumPois(); i ++){      
          var it = results.getPoi(i);
          var opts = {}
          if (data[it.uid]) {
            opts['icon'] = i10;
          }
          var marker = new BMap.Marker(it.point, opts);
          searchMarker.push(marker);
          var content = tpl_info({name: it.title, lat: it.point.lat, lng: it.point.lng, tag: $('#txt').val(), address: it.address, phone: it.phoneNumber, uid: it.uid});
          addClickHandler(content, marker);
          map.addOverlay(marker);
          data[it.uid] = {address: it.address, lat: it.lat, lng: it.lng, name: it.name, phone: it.phone, tag: it.tag, uid: it.uid};
        }      
      }      
    }      
  };      
  var local = new BMap.LocalSearch(map, options);      
  local.setPageCapacity(100);
  local.searchInBounds($('#txt').val(), map.getBounds());            
});

function addClickHandler(content, marker){
  marker.addEventListener("click", function(e){
    openInfo(content, e)
  });
}

function openInfo(content, e) {
  var p = e.target;
  var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
  var infoWindow = new BMap.InfoWindow(content, {width: 600, height: 300});  // 创建信息窗口对象 
  map.openInfoWindow(infoWindow, point); //开启信息窗口
}
function info_save() {
    $.ajax({
        url: 'map1_info_save',
        type: 'post',
        data: {name: $('#info_name').val(), 
            lat: $('#info_lat').val(), 
            lng: $('#info_lng').val(), 
            tag: $('#info_tag').val(), 
            address: $('#info_address').val(), 
            phone: $('#info_phone').val(), 
            uid: $('#info_uid').val()
        }, 
        dataType: 'json'
    }).done(function(json) {
        if (json.status == 'ok') {
            //alert('储存成功!');
            map.closeInfoWindow();
            for (var i = 0; i < searchMarker.length; i++) {
                var it = searchMarker[i];
                if (it.point.lat == json.lat && it.point.lng == json.lng) {
                    map.removeOverlay(it);
                    break;
                }
            }
        }
    }).fail(function(json) {
        alert('AJAX FAIL!');    
    });  
}

// ---------------- search -------------------




// ========== 显示行政区 ============
var zoneBoundary = []
function showBoundary(name, color){       
  var bdary = new BMap.Boundary();
  bdary.get(name, function(rs){       //获取行政区域
    // map.clearOverlays();        //清除地图覆盖物       
    var count = rs.boundaries.length; //行政区域的点有多少个
    for(var i = 0; i < count; i++){
      var ply = new BMap.Polygon(rs.boundaries[i], {strokeWeight: 2, strokeColor: '#ff0000', fillOpacity: 0.00000001, fillColor: '#ff0000'}); //建立多边形覆盖物
      map.addOverlay(ply);  //添加覆盖物
      //map.setViewport(ply.getPath());    //调整视野         
      zoneBoundary.push(ply);
    }                
  });   
}
function showZone() {
  var zone = [
    '苏州市相城区', 
    '苏州市沧浪区', 
    '苏州市虎丘区', 
    '苏州市平江区', 
    '苏州市太仓市', 
    '苏州市常熟市', 
    '苏州市金阊区', 
    '苏州市吴江市', 
    '苏州市昆山市',
    '苏州市张家港市', 
    '苏州市吴中区', 
    '无锡市' 
  ]
  for (var i = 0; i < zone.length; i++) {
    showBoundary(zone[i])
  }
}
function hideZone() {
  for (var i = 0; i < zoneBoundary.length; i++) {
    map.removeOverlay(zoneBoundary[i]);
  }
  zoneBoundary = [];
}
$('#toggleZone').on('click', function() {
    if (this.checked) {
        showZone();
    } else {
        hideZone();
    }
});
// -------------- 显示行政区 --------------

$('#testBtn').on('click', function() {
    $('#list').hide();

});

var showMarker = [];
var tpl_info_show = _.template('名称: ${raw('<%=name%>')}<br/>lat: ${raw('<%=lat%>')}<br/>lng: ${raw('<%=lng%>')}<br/>tag: ${raw('<%=tag%>')}<br/>地址: ${raw('<%=address%>')}<br/>电话: ${raw('<%=phone%>')}');
$('#showData').on('click', function() {
    // remove marker
    for (var i = 0; i < showMarker.length; i++) {
        map.removeOverlay(showMarker[i]);
    }
    for(var k in data) {
        

        var it = data[k];
        var opts = {}
        if (it.tag == '爱维尔') {
            opts['icon'] = i10; // orange
        } else if (it.tag == '肯德基') {
            opts['icon'] = i01; // pink1
        } else if (it.tag == '好利来') {
            opts['icon'] = i06; // gray
        } else if (it.tag == '85度C') {
            opts['icon'] = i08; // red
        } else if (it.tag == '麦当劳') {
            opts['icon'] = i11; // yellow
        } else if (it.tag == '长发西饼') {
            opts['icon'] = i07; // purple 
        } else if (it.tag == '花园饼屋') {
            opts['icon'] = i04; // green 
        } else {
            opts['icon'] = i05; // black
        }
        var point = new BMap.Point(it.lng, it.lat);
        var marker = new BMap.Marker(point, opts);
        showMarker.push(marker);
        var content = tpl_info_show({name: it.name, lat: it.lat, lng: it.lng, tag: it.tag, address: it.address, phone: it.phone, uid: it.uid});
        addClickHandler(content, marker);
        map.addOverlay(marker);
    }

});


// word links
function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) 
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) 
        {
            return sParameterName[1];
        }
    }
}   

function showStore() {
    var code = getUrlParameter('code');
    if (code == 'all') {
        map.setMapStyle({style:'light'});
        showZone();
        $('#list').hide();
        var foo = {'a': '长发西饼', 'b': '花园饼屋', 'c': '85度C', 'd': '面包新语', 'e': '元祖', 'f': '好利来', 'g': '瑞美尔特', 'h': '欧贝司精品烘焙', 'i': 'MU.BREAD', 'j': '宜芝多', 'k': '爱维尔'};
        for (var k in foo) {
            for (var k2 in data) {
                var it = data[k2];
                if (it.tag == foo[k]) {
                    // TODO: custom icon
                    var opts = {}
                    opts['icon'] = new BMap.Icon("${resource(dir: 'images/logos', file: '')}/" + k + "64.png", new BMap.Size(64, 64));
                    var point = new BMap.Point(it.lng, it.lat);
                    var marker = new BMap.Marker(point, opts);
                    showMarker.push(marker);
                    var content = tpl_info_show({name: it.name, lat: it.lat, lng: it.lng, tag: it.tag, address: it.address, phone: it.phone, uid: it.uid});
                    addClickHandler(content, marker);
                    map.addOverlay(marker);
                }
            }
        }

    } else if (code) {
        showZone();
        $('#list').hide();
        // remove marker
        for (var i = 0; i < showMarker.length; i++) {
            map.removeOverlay(showMarker[i]);
        }
        var foo = {'a': '长发西饼', 'b': '花园饼屋', 'c': '85度C', 'd': '面包新语', 'e': '元祖', 'f': '好利来', 'g': '瑞美尔特', 'h': '欧贝司精品烘焙', 'i': 'MU.BREAD', 'j': '宜芝多'};
        var store = foo[code];
        for(var k in data) {
            var it = data[k];
            if (it.tag == store) {
                var point = new BMap.Point(it.lng, it.lat);
                var marker = new BMap.Marker(point);
                showMarker.push(marker);
                var content = tpl_info_show({name: it.name, lat: it.lat, lng: it.lng, tag: it.tag, address: it.address, phone: it.phone, uid: it.uid});
                addClickHandler(content, marker);
                map.addOverlay(marker);
            }
        }
    }
}
showStore();

</script>  
</body>  
</html>
