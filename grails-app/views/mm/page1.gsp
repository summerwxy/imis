<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    .memberdiv {
        background-color: #0088cc;
        color: #ffffff;
        font-size: 24px;
        margin-left: 10px !important;
        border-radius: 25px;
        text-align: center;
        padding: 10px !important;
        display: flex;
        flex-direction: column;
        justify-content: center;
        overflow: auto;
    }
    .clickme, #plus, #minus {
        cursor: pointer;
    }
    </style>
    <script type="text/javascript">
    $(function () {
        $('#myTab a:last').tab('show');

        var data = ${result as grails.converters.JSON};
        var tpl_title = _.template('<tr><th>名称</th><th>1倍(g)</th><th>N倍(g)</th><th>称重数(g)</th><th>功能</th></tr>');
        var tpl = _.template('<tr><td><\%=name%\></td><td><\%=gram%\></td><td><\%=gram%\></td><td><input data-section="<\%=section%\>" data-itemname="<\%=name%\>" data-standard="<\%=gram%\>" class="input-small" type="text" name="gram"/></td><td><button name="printit" class="btn btn-primary">确认并打印</button></td></tr>');
        var cate1 = '';
        var cate2 = '';
        $('.clickme').on('click', function() {
            var it = $(this);
            cate1 = it.data('cate1');
            cate2 = it.data('cate2');
            var items = data[cate1][cate2];
            $('#n').val(1);
            $('#showN').html('1');
            var n1 = $('#n1');
            var n1html = '';
            $.each(items, function(key, value) {
                if (key != 'NONE') {
                    n1html += '<h4>' + key + '</h4>';
                }
                n1html += '<table class="table table-bordered">';
                n1html += tpl_title();
                $.each(value, function(i, it) {
                    n1html += tpl(it);
                }); 

                n1html += '</html>';
            });
            n1.empty().append(n1html);

            $('#cateDiv').hide();
            $('#weighDiv').show();
        });

        $('#back').on('click', function() {
            $('#cateDiv').show();
            $('#weighDiv').hide();
        });

        $('#plus').on('click', function() {
            var tar = $('#n');
            tar.val(parseInt(tar.val(), 10) + 1);
            syncN(tar.val());
        });

        $('#minus').on('click', function() {
            var tar = $('#n');
            tar.val(parseInt(tar.val(), 10) - 1);
            syncN(tar.val());
        });

        $('#n').on('input', function() {
            syncN(this.value);
        });

        function syncN(n) {
            $('#showN').html(n);
            var foo = $('#n1 table tr:not(:first-child)');
            $.each(foo, function(i, it) {
                var children = $(it).children();
                var val = parseInt($(children.get(1)).html(), 10) * n;
                $(children.get(2)).html(val);
            });
        }

        $('#n1').on('click', '[name=printit]', function() {
            var i = $('[name=printit]').index(this);
            var tar = $($('[name=gram]').get(i));
            if (tar.val().length != 0) {
                $.ajax({
                    url: 'printit',
                    dataType: 'json',
                    data: {
                        cate1: cate1,
                        cate2: cate2,
                        section: tar.data('section'),
                        itemname: tar.data('itemname'),
                        standard: tar.data('standard'),
                        weigh: tar.val(),
                        n: $('#n').val()
                    },
                    success: function(data) {
                        // TODO: do what ?  
                    }
                });
            }
        });
    })
    </script>
</head>
<content tag="title">称重</content>
<content tag="subtitle">...</content>
<body>
<div class="row">
    <div class="span2 offset5">
        <g:if test="${msg}">
            <p class="text-success lead">${msg} </p>
        </g:if>
    </div>
</div>

<div id="cateDiv" class="row-fluid">
    <div class="span12">
        <ul class="nav nav-tabs">
            <g:each in="${result}" status="i" var="it">
                <li ${(i == 0) ? 'class="active"' : ''}>
                    <a data-toggle="tab" href="#tab${i}">${it.key}</a>
                </li>
            </g:each>
        </ul>
        <div class="tab-content padding-8">
            <g:each in="${result}" status="i" var="it">
                <div id="tab${i}" class="tab-pane ${(i == 0) ? 'active' : ''}">
                    <div class="clearfix">
                        <g:each in="${it.value}" status="j" var="it2">    
                            <div data-cate1="${it.key}" data-cate2="${it2.key}" class="itemdiv memberdiv clickme">${it2.key}</div>
                        </g:each>
                    </div>        
                </div>
            </g:each>
        </div>
    </div>
</div>

<div id="weighDiv" class="row-fluid hide">
    <div class="span12">
        <button id="back" class="btn btn-primary">返回</button>
    </div>
    <div class="span12">
        <div class="text-center" style="font-size: 50px;">
            <i id="minus" class="icon-minus"></i>
            <span id="showN">1</span>
            <i id="plus" class="icon-plus"></i>
            <br/>
            <input type="range" name="n" id="n" value="1" min="1" max="100" style="width: 80%;">
        </div>

    </div>
    <div id="n1" class="span12">
    </div>
    <!--
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <div id="n1"></div>
            </div>
            <div class="span9" style="background: blue;">
                <div id="nn"></div>
            </div>
        </div>
    </div>
    -->
</div>


    
</body>
</html>
