<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <link rel="stylesheet" href="${resource(dir: 'bootstrap-datetimepicker/css', file: 'datetimepicker.css')}" />
    <style>
    .xoutcard {
        margin: 5px 0px 5px 0px;
        text-align: left;
        color: black !important;
    }
    .table tbody tr.success > td {
        background-color: #DFF0D8;
    }
    #fixit {
        background-color: #ffffff;
    }
    </style> 
    <script type="text/javascript">
    var dselect;
    var zselect;

    $(function() {
        // close sidebar
        $('#sidebar').addClass('menu-min');

        // datetimepicker
        $('.form_datetime').datetimepicker({
            language:  'zh-CN',
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            minView: 2,
            forceParse: 0
        // }).on('changeDate', function(ev){
        //     load_data();
        });

        // create drivers select list
        var drivers = ${drivers};
        dselect = $('<select class="dselect" data-placeholder="未指定司机"/>'); 
        dselect.append('<option value="0"></option>');
        $.each(drivers, function(k, v) {
            dselect.append('<option value="' + v.id + '">' + v.name + ' ' + v.phone + '</option>');
        });

        // create zone select list
        var zones = ${zone as grails.converters.JSON}; 
        zselect = $('<select class="zselect" data-placeholder="未指定区域"/>');
        zselect.append('<option value=""></option>');
        $.each(zones, function(k, v) {
            zselect.append('<option value="' + v + '">' + v + '</option>');        
        });
        
        $('#the_tbody').on('click', '.btn-status', function(event) {
            var tar = $(this);
            var status;
            if (tar.hasClass('btn-danger')) {
                status = 'OK';
            } else {
                status = '';
            }
            var id = this.id.substr(3);
            $.ajax({
                url: 'page1_change_status',
                type: 'get',
                data: {id: id, status: status}, 
                dataType: 'json'
            }).done(function(json) {
                tar.toggleClass('btn-danger').toggleClass('btn-success');
                if (json.status == '') {
                    tar.html('未出');
                    $('#the_tbody .tr' + id).removeClass('success');
                } else {
                    tar.html('已出');
                    $('#the_tbody .tr' + id).addClass('success');
                }
                update_cnt();
            }).fail(function(json) {
                alert('AJAX FAIL!');    
            });  

        });
        // onload and load data
        load_data();

        $('#freshdata').click(function() {
            load_data();        
        });

        $('#showokdata').click(function() {
            $('#mydata .success, #mydata .success + tr').show();
        });

        $('#hideokdata').click(function() {
            $('#mydata .success, #mydata .success + tr').hide();         
        });

        $('#checkall').click(function() {
            $('input[type=checkbox]:not(:checked)').each(function() {
                $(this).prop('checked', true);    
            });   
        });

        $('#checknone').click(function() {
            $('input[type=checkbox]:checked').each(function() {
                $(this).prop('checked', false);    
            });                  
        });

        // fix it
        $('#fixit').scrollToFixed();
    });

    function load_data() {
        $('#myModal').modal('show');
        // template
        var tpl = _.template('<tr class="tr<\%=FInterID%\>"><td><\%=SHIP_NO%\></td><td><\%=TAKE_DATE%\> <\%=TAKE_TIME%\></td><td><\%=STORE%\></td><td><\%=CONTACT%\></td><td><\%=PHONE%\></td><td rowspan="4"><\%=DETAIL%\></td></tr><tr class="tr<\%=FInterID%\>"><td colspan="5"><strong>地址:</strong> <\%=ADDR%\></td></tr><tr class="tr<\%=FInterID%\>"><td colspan="5"><strong>备注:</strong> <\%=REMARK%\></td></tr>');
        var tpl2 = _.template('<tr class="tr<\%=FInterID%\>"><td colspan="5"><strong>送货方式:</strong> <\%=SHIP_TYPE%\> | <strong>订单类型:</strong> <\%=ORDER_TYPE%\> | <strong>状态:</strong> <button id="btn<\%=FInterID%\>" class="btn <\%=BtnClass%\> btn-status"><\%=BtnStatus%\></button> | <strong>司机:</strong> <\%=Dselect%\> | <strong>区域:</strong> <\%=Zselect%\></td></tr>');
        var tpl3 = _.template('<tr><td style="height: 2px; padding: 0px; background-color: #000000;" colspan="6"></td></tr>');

        var d = $('#the_day').val();
        var st1 = $('#ship_type_1').is(':checked'); 
        var st2 = $('#ship_type_2').is(':checked'); 
        var ot1 = $('#order_type_1').is(':checked'); 
        var ot2 = $('#order_type_2').is(':checked'); 
        var ot3 = $('#order_type_3').is(':checked'); 
        var ot4 = $('#order_type_4').is(':checked'); 
        var zn = [];
        $.each($('.zone_name:checked'), function(k, v) {
            zn.push(v.value);
        });

        // ajax to load data
        $.ajax({
            url: 'page1_load',
            type: 'get',
            data: {day: d, st1: st1, st2: st2, ot1: ot1, ot2: ot2, ot3: ot3, ot4: ot4, zn: zn}, 
            dataType: 'json'
        }).done(function(json) {
            var tar = $('#the_tbody');
            tar.empty();
            $.each(json['h'], function(k, v) {
                var temp = [];
                $.each(json['b'][v.FInterID], function(k, v) {
                    temp.push(v.FName + ' * ' + v.FQty + ' ' + v.Unit);
                });
                var detail = temp.join("<br/>");
                v['DETAIL'] = detail;
                v['BtnClass'] = (v.STATUS == 'OK') ? 'btn-success' : 'btn-danger';
                v['BtnStatus'] = (v.STATUS == 'OK') ? '已出' : '未出';
                var foo = dselect.clone().prop('id', 'select' + v.FInterID);
                foo.find('[value=' + v.DID + ']').attr('selected', 'selected');
                v['Dselect'] = foo.wrap('<div/>').parent().html();
                var bar = zselect.clone().prop('id', 'zselect' + v.FInterID);
                bar.find('[value="' + v.ZONE + '"]').attr('selected', 'selected');
                v['Zselect'] = bar.wrap('<div/>').parent().html();
                tar.append(tpl3()).append(tpl(v)).append(tpl2(v));
                // check bg color by time
                var bgclass = '';
                if (v.TAKE_DIFF <= 60*60*2) {
                    bgclass = 'error';
                } else if (v.TAKE_DIFF <= 60*60*5) {
                    bgclass = 'warning';
                } 
                tar.find('.tr' + v.FInterID).addClass(bgclass);
                // check bg color by status
                if (v.STATUS == 'OK') {
                    tar.find('.tr' + v.FInterID).addClass('success');
                }
            });
            tar.append(tpl3());

            // run chosen
            $('.dselect').chosen({no_results_text: "找不到这位司机!", allow_single_deselect: true, width: '160px'})
            .change(function(e) {
                var id = this.id.substr(6);
                var driver = this.options[this.selectedIndex].value;
                $.ajax({
                    url: 'page1_change_driver',
                    type: 'get',
                    data: {id: id, driver: driver}, 
                    dataType: 'json'
                }).done(function(json) {
                    // DONE and do nothing
                }).fail(function(json) {
                    alert('AJAX FAIL!');    
                });                               
            });

            $('.zselect').chosen({no_results_text: "找不到区域!", allow_single_deselect: true, width: '110px'})
            .change(function(e) {
                var id = this.id.substr(7);
                var zone = this.options[this.selectedIndex].value;
                $.ajax({
                    url: 'page1_change_zone',
                    type: 'get',
                    data: {id: id, zone: zone}, 
                    dataType: 'json'
                }).done(function(json) {
                    // DONE and do nothing
                }).fail(function(json) {
                    alert('AJAX FAIL!');    
                });                               
            });
            update_cnt();
            $('#myModal').modal('hide');
        }).fail(function(json) {
            alert('AJAX FAIL!');    
        });  
    }

    // update cnt
    function update_cnt() {
        var ocnt = $('.btn-success').size();
        var xcnt = $('.btn-danger').size();
        $('#ocnt').html(ocnt);    
        $('#xcnt').html(xcnt);
        $('#tcnt').html(ocnt + xcnt);
    }

    </script>
</head>
<content tag="title">[送货上门]出货单明细</content>
<content tag="subtitle">物流部门追踪专用</content>
<body>

<div id="fixit" class="row-fluid">
    <div class="span3">
        <div class="control-group left">
            出货日期: 
            <div class="controls input-append date form_datetime" data-date-format="yyyy/mm/dd" data-link-field="dtp_input1">
                <input class="input-small" type="text" id="the_day" value="${today}" readonly>
                <span class="add-on"><i class="icon-th"></i></span>
            </div>
            <input type="hidden" id="dtp_input1" value="" /><br/>
        </div>
        送货方式: 
        <label class="inline">
            <input id="ship_type_1" type="checkbox" checked="checked" />
            <span class="lbl">送货上门</span>
        </label>
        <label class="inline">
            <input id="ship_type_2" type="checkbox" />
            <span class="lbl">门店自取</span>
        </label>
    </div>
    <div class="span6">
        订单类型:
        <label class="inline">
            <input id="order_type_1" type="checkbox" checked="checked" />
            <span class="lbl">生日蛋糕</span>
        </label>
        <label class="inline">
            <input id="order_type_2" type="checkbox" checked="checked" />
            <span class="lbl">零散订单</span>
        </label>
        <label class="inline">
            <input id="order_type_3" type="checkbox" checked="checked" />
            <span class="lbl">券卡订单</span>
        </label>
        <label class="inline">
            <input id="order_type_4" type="checkbox" checked="checked" />
            <span class="lbl">节庆订单</span>
        </label>
        <br/>
        <br/>
        区域:
        <g:each in="${zone}" status="i" var="it">
            <label class="inline">
                <input class="zone_name" type="checkbox" checked="checked" value="${it}" />
                <span class="lbl">${it}</span>
            </label>
        </g:each>
        <label class="inline">
            <input class="zone_name" type="checkbox" checked="checked" value=""/>
            <span class="lbl">未指定</span>
        </label>
    </div>
    <div class="span3">
        <button id="freshdata" class="btn btn-primary">刷新</button>
        <button id="hideokdata" class="btn btn-info">隐藏已出</button>
        <button id="showokdata" class="btn btn-info">显示已出</button>    
        <br/>
        <br/>
        <button id="checkall" class="btn btn-warning">全部选取</button>
        <button id="checknone" class="btn btn-warning">全部取消</button>    
        <br/>
        <br/>
        <span class="label label-success">已出: </span> <span id="ocnt">0</span>
        <span class="label label-important">未出: </span> <span id="xcnt">0</span>
        <span class="label label-inverse">合计: </span> <span id="tcnt">0</span>
    </div>
</div>
<table class="table table-bordered">
    <tbody>
        <tr class="error"><td>红底色: 客取时间 小于 2 小时 未出货</td></tr>
        <tr class="warning"><td>黄底色: 客取时间 小于 5 小时 未出货</td></tr>
        <tr class="success"><td>绿底色: 已出货</td></tr>
    </tbody>
</table>
<table id="mydata" class="table table-bordered"> 
    <thead>
        <tr>
            
            <th width="150">出货单号</th>
            <th width="150">客取时间</th>
            <th width="150">购货单位</th>
            <th width="150">联系人</th>
            <th width="150">电话</th>
            <th>物品明细</th>
        </tr>
    </thead>
    <tbody id="the_tbody">
    </tbody>
</table>

<div id="myModal" class="modal hide fade">
    <div class="modal-header">
        <h3>载入中...</h3>
    </div>
    <div class="modal-body" style="text-align: center;">
        <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}"/>
    </div>
    <div class="modal-footer">
    </div>
</div>


</body>
</html>
