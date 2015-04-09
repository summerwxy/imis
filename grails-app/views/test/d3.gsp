<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="w8"/>
	<script src="${resource(dir: 'bower_components/d3', file: 'd3.min.js')}"></script>
	<link rel="stylesheet" href="${resource(dir: 'bower_components/nvd3', file: 'nv.d3.min.css')}" />
	<script src="${resource(dir: 'bower_components/nvd3', file: 'nv.d3.min.js')}"></script>
    <style>
    .left {
        float: left;
    }
    </style>    
    <script type="text/javascript">

    $(function() {
        // datetimepicker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        });

        $.ajax({
            url: 'd3_1',
            type: 'get',
            data: {dates: '20131101', datee: '20131102'}, 
            dataType: 'json'
        }).done(function(json) {
            console.log(json.result)
            nv.addGraph(function() {
                var chart = nv.models.multiBarChart();
                //chart.xAxis.tickFormat(d3.format(',f'));
                //chart.yAxis.tickFormat(d3.format(',.1f'));
                d3.select('#chart svg').datum(json.result).transition().duration(500).call(chart);
                nv.utils.windowResize(chart.update);
                return chart;
            });
        }).fail(function(json) {
            alert('AJAX FAIL!');    
        });  
    })



        
    </script>
</head>
<content tag="title">D3</content>
<content tag="subtitle">chart page</content>
<body>

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


<div id="chart" style="height: 400px;">
    <svg></svg>
</div>

</body>
</html>
