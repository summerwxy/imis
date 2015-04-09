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

    <!--page specific plugin styles-->
    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'prettify.css')}" />

    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8.min.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8-responsive.min.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'themes/css', file: 'w8-skins.min.css')}" />

    <!--inline styles if any-->
    <link rel="stylesheet" href="${resource(dir: 'bower_components/jquery-ui/themes/smoothness', file: 'jquery-ui.min.css')}" />

    <!--basic scripts-->
    <script src="${resource(dir: 'bower_components/jquery/dist', file: 'jquery.min.js')}"></script>

    <script src="${resource(dir: 'bootstrap/js', file: 'bootstrap.min.js')}"></script>
    <script src="${resource(dir: 'bower_components/jquery-ui/ui/minified', file: 'jquery-ui.min.js')}"></script>
    <script src="${resource(dir: 'themes/js', file: 'jquery.ui.touch-punch.min.js')}"></script>
    
    <!--w8 scripts-->

    <script src="${resource(dir: 'themes/js', file: 'w8-elements.min.js')}"></script>
    <script src="${resource(dir: 'themes/js', file: 'w8.min.js')}"></script>

    <!-- ScrollToFixed -->
    <script src="${resource(dir: 'js', file: 'jquery-scrolltofixed-min.js')}"></script>

    <!-- my scripts -->
    <script src="${resource(dir: 'js', file: 'underscore-min.js')}"></script>
    
    <style type="text/css" media="screen">
    .itemList tr {
        height: 100px;
    }
    .itemList td {
        font-size: 300%;
    }
    </style>
    <script type="text/javascript">
    $(function() {
        $('#prevBtn').click(function() {
            index -= 1;
            if (index < 0) {
                index = items.length;
            }
            genView(index);
        });
        $('#listBtn').click(function() {
            genView(0);
        });
        $('#nextBtn, #nextBtn2').click(function() {
            index += 1;
            if (index > items.length) {
                index = 0;
            }
            genView(index);
        });
        $("#the_view").on("click", '.itemBtn', function() {
            genView($(this).data('index'));
        });

        genView(0);
    })    

    function genView(i) {
        if (i == 0) {
            genBtns();
        } else {
            genList(i);
        }
        index = i;
        $(document).scrollTop(0);
    }
    
    var items = ${items as grails.converters.JSON};
    var tpl = _.template('<button class="itemBtn btn btn-large btn-block btn-success" type="button" data-index="<\%=i%\>"><\%=no%\> <\%=name%\></button>');
    var index = 0;
    function genBtns() {
        var view = $('#the_view');
        view.empty();
        $.each(items, function(i, it) {
            view.append(tpl({'i': i+1, 'no': it[0], 'name': it[1]}));
        });
    }
    var data = ${result as grails.converters.JSON};
    function genList(i) {
        var view = $('#the_view');
        view.empty();
        var item = items[i-1];
        view.append('<h3>' + item[0] + ' ' + item[1] + '</h3>');
        var table = $('<table class="itemList table table-condensed"></table>');
        $.each(data[item[0]], function(i, it) {
            table.append('<tr><td>' + it.Fname + ' ' + it.FQty + ' ' + it.FUnitName + '</td></tr>');
        });
        view.append(table);
    }
    </script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="span3">
            <button id="prevBtn" class="btn btn-large btn-block btn-info" type="button">上一项</button>
        </div>
        <div class="span6">
            <button id="listBtn" class="btn btn-large btn-block btn-primary" type="button">所有物料</button>
        </div>
        <div class="span3">
            <button id="nextBtn" class="btn btn-large btn-block btn-info" type="button">下一项</button>
        </div>
    </div>
    <hr/>
    
    <div class="row">
        <div class="span12" id="the_view">
        </div>
    </div>
    <div class="row">
        <div class="span12">
            <button id="nextBtn2" class="btn btn-large btn-block btn-info" type="button">下一项</button>
        </div>
    </div>
</div>
</body>
</html>
