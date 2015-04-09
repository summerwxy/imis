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
            $('#myCarousel').carousel('prev');
            $(document).scrollTop(0);
        });
        $('#listBtn').click(function() {
            $('#myCarousel').carousel(0);
            $(document).scrollTop(0);
        });
        $('#nextBtn, #nextBtn2').click(function() {
            $('#myCarousel').carousel('next');
            $(document).scrollTop(0);
        });
        $('.itemBtn').click(function() {
            var foo = $(this).data('index');    
            $('#myCarousel').carousel(foo);
            $(document).scrollTop(0);
        });
        // $('#nextBtn').scrollToFixed();

        alert('读取完成！可以开始使用！');
    })    
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
        <div class="span12">
            <div id="myCarousel" class="carousel slide">
                <!-- Carousel items -->
                <div class="carousel-inner">
                    <div class="active item">
                        <g:each in="${items}" status="i" var="it">
                            <button class="itemBtn btn btn-large btn-block btn-success" type="button" data-index="${i+1}">${it[0]} ${it[1]}</button>
                        </g:each>                    
                    </div>
                    <g:each in="${result}" status="i" var="it">
                        <div class="item">
                            <h3>${it.value[0].FItemNO} ${it.value[0].FItemName}</h3>
                            <table class="itemList table table-condensed">
                                <g:each in="${it.value}" status="j" var="it2">
                                    <tr>
                                        <td>${it2.Fname} ${iwill._.numberFormat(it2.FQty, '###.##')} ${it2.FUnitName}</td>
                                    </tr>
                                </g:each>
                            </table>
                        </div>
                    </g:each>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="span12">
            <button id="nextBtn2" class="btn btn-large btn-block btn-info" type="button">下一项</button>
        </div>
    </div>
    <hr/>


</div>


    
</body>
</html>
