<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>iwill 爱维尔</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!--basic styles-->
    <link href="${resource(dir: 'bootstrap/css', file: 'bootstrap.min.css')}" rel="stylesheet" />
    <link href="${resource(dir: 'bootstrap/css', file: 'bootstrap-responsive.min.css')}" rel="stylesheet" />
    <link rel="stylesheet" href="${resource(dir: 'themes/font-awesome/css', file: 'font-awesome.min.css')}" />
    <!--ace styles-->
    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8.min.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8-responsive.min.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8-skins.min.css')}" />
    <!--basic scripts-->
    <script src="${resource(dir: 'themes/js', file: 'jquery-1.9.1.min.js')}"></script>
    <script src="${resource(dir: 'bootstrap/js', file: 'bootstrap.min.js')}"></script>
    <!--w8 scripts-->
    <script src="${resource(dir: 'themes/js', file: 'w8-elements.min.js')}"></script>
    <script src="${resource(dir: 'themes/js', file: 'w8.min.js')}"></script>
    <!--bootstrap-datetimepicker-->
    <link rel="stylesheet" href="${resource(dir: 'bootstrap-datetimepicker/css', file: 'datetimepicker.css')}" />
    <script src="${resource(dir: 'bootstrap-datetimepicker/js', file: 'bootstrap-datetimepicker.min.js')}"></script>
    <script src="${resource(dir: 'bootstrap-datetimepicker/js/locales', file: 'bootstrap-datetimepicker.zh-CN.js')}"></script>
    <!-- my scripts -->
    <style>
    html, body, #map-canvas {
        margin: 0;
        padding: 0;
        height: 100%;
    }
    img {
        max-width: none;
    }
    #ace-settings-box {
        width: 500px;
    }
    #ace-settings-box > div {
        max-height: none;
    }
    input[type=checkbox], input[type=radio] {
        opacity: 1;
        position: static;
    }
    .left {
        float: left;
    }
    </style>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyBT49R0ejLKG1VQ6qYGTjUUxseJL2IQwy0&language=zh-CN&sensor=false"></script>
    <script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/src/markerclusterer.js"></script>
    <script type="text/javascript">
    // http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=foobar
    var store = ${store}
   
    // Enable the visual refresh
    google.maps.visualRefresh = true;
    
    var map;
    var markers = [];
    function initialize() {
        var mapOptions = {
            zoom: 12,
            center: new google.maps.LatLng(31.254780690042416, 120.60762852430344),
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            panControl: false,
            zoomControl: true,
            mapTypeControl: false,
            scaleControl: true,
            streetViewControl: false,
            overviewMapControl: true
        };
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

        var image = '${resource(dir: 'images', file: 'sunny32.png')}';
        for (var i = 0; i < store.length; i++) {
            var foo = store[i];
            var latlng = new google.maps.LatLng(foo.lat, foo.lng);

            //setTimeout(function(latlng, foo) {
                // marker
                var marker = new google.maps.Marker({
                    position: latlng,
                    map: map,
                    icon: image,
                    title: foo.S_NAME + ' $' + foo.AMT,
                    animation: google.maps.Animation.DROP
                });
                markers.push(marker);
                var color = findcolor(foo.AMT);
                // circle
                var circle = new google.maps.Circle({
                    strokeColor: color, // "#EE7500"
                    strokeOpacity: 0.8,
                    strokeWeight: 2,
                    fillColor: color, // "#EE7500"
                    fillOpacity: 0.35,
                    map: map,
                    center: latlng,
                    radius: (Math.min(foo.AMT, 2000) / 5) + (Math.min(Math.max(foo.AMT - 2000, 0), 8000) / 15) + (Math.max(foo.AMT - 10000, 0) / 25)
                });
            //}, i * 100, latlng, foo);
        }
        var mc = new MarkerClusterer(map, markers);
        mc.setCalculator(function(markers, numStyles) {
            var index = 0;
            var count = markers.length;
            var dv = count;
            while (dv !== 0) {
                dv = parseInt(dv / 10, 10);
                index++;
            }

            index = Math.min(index, numStyles);
            return {
                text: count,
                index: index
            };
        });
        
    }
    google.maps.event.addDomListener(window, 'load', initialize);

    // heat color
    function process(num) {
        var n = Math.floor(num + 0.1 * (256 - num)); // adjust lightness
        var s = n.toString(16); // turn to hex
        s = s.length == 1 ? '0' + s : s; // if no first char, prepend 0
        return s;		
    }
    function findcolor(val) {
        var max = 10000;
        var position = Math.min(val / max, 1); // value between 1 and 0
        var shft = position + 0.2 + 5.5*(1-position) - 0.5;
        var scale = 128; // scale will be multiplied by the cos(x) + 1 (0~2) 
        var x = shft + position * 2 * Math.PI; // x is place along x axis of cosine wave
        var r = process(Math.floor((Math.cos(x) + 1) * scale));
        var g = process(Math.floor((Math.cos(x+Math.PI / 2) + 1) * scale));
        var b = process(Math.floor((Math.cos(x+Math.PI) + 1) * scale));
        return '#' + r + g + b;
    }


    $(function() {
        // color or gray
        $('#gray').click(function() {
            var styles = [{"stylers": [{ "saturation": 0 }]}];
            if (this.checked) {
                styles = [{"stylers": [{ "saturation": -100 }]}];
            }
            map.setOptions({styles: styles});
        });
        // hide sunny marker
        $('#marker').click(function() {
            var flag = true;
            if (this.checked) {
                flag = false;
            }
            $.each(markers, function(i, marker) {
                marker.setVisible(flag);
            });
        });
        // datetimepicker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });



    })



    </script>
    
</head>
<body>

<div id="ace-settings-container">
    <div class="btn btn-app btn-mini btn-warning" id="ace-settings-btn">
        <i class="icon-cog"></i>
    </div>

    <div id="ace-settings-box">
        <div>
            <ul>
                <li>营业额越多, 圈越大, 颜色越接近红色</li>
            </ul>
            <input id="gray" type="checkbox" /> 使用灰阶地图 <br/>
            <input id="marker" type="checkbox" /> 隐藏太阳人 <br/>
            <hr/>
            <label class="control-label left">日期范围: </label>
            <div class="control-group left">
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input1">
                    <input class="input-small" type="text" value="" readonly>
					<span class="add-on"><i class="icon-th"></i></span>
                </div>
				<input type="hidden" id="dtp_input1" value="" /><br/>
            </div>
            <label class="control-label left"> ~ </label>
            <div class="control-group">
                <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input2">
                    <input class="input-small" type="text" value="" readonly>
					<span class="add-on"><i class="icon-th"></i></span>
                </div>
				<input type="hidden" id="dtp_input2" value="" /><br/>
            </div>
            <div>
                可选类别: 
                <input type="checkbox" id="cb_input1" checked="checked" /> <label for="cb_input1" style="display: inline;">包含券卡</label>
                <input type="checkbox" id="cb_input2" checked="checked" /> <label for="cb_input2" style="display: inline;">包含节庆</label>
            </div>


            <div style="text-align: right;">
                <button class="btn btn-primary" id="refresh" name="refresh" type="button">刷新</button>
            </div>

            <hr/>

        </div>
    </div>
</div><!--/#ace-settings-container-->



<div id="map-canvas"></div>




    
</body>
</html>
