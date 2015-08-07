<!DOCTYPE html>
<html>    
<head>
    <meta charset="utf-8">
    <title>中秋订单</title>
    <meta name="description" content="">
    <meta name="HandheldFriendly" content="True">
    <meta name="MobileOptimized" content="320">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta content="telephone=no" name="format-detection" />
    <meta content="email=no" name="format-detection" />

    <link rel="stylesheet" href="${resource(dir: 'mooncake', file: 'ku.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'mooncake', file: 'mobiscroll.2.13.2.min.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'themes/font-awesome/css', file: 'font-awesome.min.css')}" />

    <script type="text/javascript" src="${resource(dir: 'bower_components/jquery/dist', file: 'jquery.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'mooncake', file: 'mobiscroll.2.13.2.min.js')}"></script>

    <script type="text/javascript" src="${resource(dir: 'mooncake', file: 'common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'mooncake', file: 'jquery.form.js')}"></script>
    <style>
    .center {
        text-align: center;
    }
    .num {
        margin-left: 20px; 
        margin-right: 20px; 
        width: 45px;
        background-color: transparent;
    }
    .red {
        color: red;
    }
    .bgOrder {
        background-color: #fdf8c3;
    }
    </style>
	    
    <script type="text/javascript">
    (function($){$(function(){

        opt.preset='datetime';//调用日历显示  日期时间
        $('#shipTime').mobiscroll(opt);//直接调用日历 插件
        $('#shipTime').on('focus', function(){
            $("#title").css("ime-mode","disable");
            $("#content").css("ime-mode","disable");
        });
        //设置初始化时间
        var date = new Date();
        date.setDate(date.getDate() + 1);
        $("#shipTime").val(date.Format("yyyy-MM-dd 08:00"));	

        // -
        $('i.icon-minus-sign').on('click', function() {
            var tar = $(this).next();
            var val = (tar.val().length == 0) ? 0 : parseInt(tar.val(), 10);
            val -= 1;
            tar.val(val < 0 ? 0 : val);
            calcTotal();
        });

        // +
        $('i.icon-plus-sign').on('click', function() {
            var tar = $(this).prev();
            var val = (tar.val().length == 0) ? 0 : parseInt(tar.val(), 10);
            val += 1;
            tar.val(val);
            calcTotal();
        });

        // inputs
        $("input[type='number']").on("click", function () {
           $(this).select();
        }).on('keyup', function() {
            calcTotal();
        }).on('blur', function() {
            var foo = parseInt(this.value, 10);
            this.value = foo ? foo : 0;
        });

        // 一进画面的显示
        showOrderItemOnly();
        calcTotal();

        // menu title toggle
        $('.menu_title').on('click', function() {
            var tar = $(this);
            var i = tar.find('i');
            var id = tar.prop('id');
            if (i.prop('class') == 'icon-caret-right') {
                i.prop('class', 'icon-caret-down');
                $('.' + id).show();
            } else {
                i.prop('class', 'icon-caret-right');
                $('.' + id).hide();
                showOrderItemOnly();
            }
        });    

        // hide loading
        hideLoading();
    });})(jQuery);
        
    function showOrderItemOnly() {
        $('.menu_item input').each(function(i) {
            var tar = $(this);
            if (tar.val().length > 0 && parseInt(tar.val(), 10) > 0) {
                var foo = tar.parent().parent().parent();
                foo.show();
            }
                
        });    
    }

    function calcTotal() {
        var price = $('[name=price]');
        var box = $('[name=box]');
        var ticket = $('[name=ticket]');
        var total_box = 0;
        var total_ticket = 0;
        var total_price = 0;
        box.each(function(i) {
            var this_box = parseInt($(this).val(), 10); 
            this_box = this_box ? this_box : 0;
            var this_ticket = parseInt(ticket.eq(i).val(), 10); 
            this_ticket = this_ticket ? this_ticket : 0;
            var this_price = parseInt(price.eq(i).val(), 10);
            total_box += this_box;
            total_ticket += this_ticket;
            total_price += (this_box + this_ticket) * this_price;
            if ((this_box + this_ticket) > 0) {
                $(this).parent().parent().parent().addClass('bgOrder');    
            } else {
                $(this).parent().parent().parent().removeClass('bgOrder');    
            }

        });
        $('#total_box').html(total_box);
        $('#total_ticket').html(total_ticket);
        $('#total_price').html(total_price);
    }

        
    // 提交订单
    function commitOrder(status){
        
        $('#status').val(status);

        // when status = init, check inputs
        if (status == 'init') {
            var msg = [];
            if ($('#total_price').text() == '0') {
                msg.push('请选择礼盒或礼券！');
            }
            if ($('[name=name]').val().length == 0) {
                msg.push('请输入联络人！');
            }
            if ($('[name=phone]').val().length == 0) {
                msg.push('请输入联系电话！');
            }
            if ($('[name=shipTime]').val().length == 0) {
                msg.push('请输入提货时间！');
            }
            if ($('[name=type]').val().length == 0) {
                msg.push('请选择提货方式！');
            }
            if ($('[name=address]').val().length == 0) {
                msg.push('请选择门店/地址！');
            }
            if ($('[name=comment]').val().length == 0) {
                msg.push('请输入订单说明！');
            }
            if (msg.length > 0) {
                showMsg("", msg.join('<br/>'), 1);
                return;
            }
        }

        showLoading("正在提交...");
        $.ajax({
            url: "${createLink(action: 'salesOrder_save')}",
            type: "POST",
            data: $("#orderForm").serialize(),
            dataType: "json",
            success: function(result){
                var view = (status == 'draft') ? 'draft' : 'my';
                window.location.href = '${createLink(action: 'list')}?view=' + view;
            },
            error: function(){
                hideLoading();
                showMsg("", "出错了", 1);
            }
        });        
    }
    
            /*
            $("#taskStatus").val(status);
            var asktemp=/^\d+(\.\d+)?$/; 
            var askDay=$('#askDay').val();
            if(askDay!=null &&askDay!=""){
                if(!asktemp.test(askDay)){
                    showMsg("","请假天数只能为数字",1);
                    return ;
                }
            }else{
                $('#askDay').val("0");
            }
            var askHour=$("#askHour").val();
            if(askHour==""||askHour==null){
                $("#askHour").val("0");
            }else{
                if(!asktemp.test(askHour)){
                    showMsg("","请假小时数只能为数字",1);
                    return ;
                }
            }
           if($('#askDay').val()=="0"&&$("#askHour").val()=="0"){
                showMsg("","申请时长不能为0",1);
                return ;
            }
            
            var startTime=$("#taskStart").val()+":00";
            
            
            var date1=new Date(Date.parse(startTime.replace(/-/g, "/")));
            var date3=new Date((date1/1000+86400*askDay)*1000);

            if($("#taskType").val()==""){
                showMsg("","请选择类型",1);
                return ;
            }
            if($("#title").val().length>30){
                showMsg("","标题过长，请重新编辑",1);
                return ;
            }
            if($("#content").val()==""){
                showMsg("","请输入请假内容",1);
                return ;
            }
            if($("#taskStart").val()==""){
                showMsg("","请输入请假开始时间",1);
                return ;
            }
            
            //合并日期与时间
            var start = "";
            //start = $("#taskStart").val()+" "+$("#startHour").val()+":"+$("#startMinute").val()+":00";
            start = $("#taskStart").val()+":00";
            $("#hiddenStartTime").val(start);
            var stop="";
            
            //showLoading("正在提交...");
            $.ajax({
                url:"http://qy.do1.com.cn/wxqyh/portal/askAction!ajaxAdd.action",
                type:"POST",
                data:$("#taskform").serialize(),
                dataType:"json",
                success:function(result){
                    //$("#imgFileLoadDiv").hide();
                    if(result.code=="0"){
                        //提交完成后清除缓存
                        removeStorage();
                        if(status=="0"){
                            //提交草稿跳转到草稿列表
                            window.location.href="http://qy.do1.com.cn/wxqyh/jsp/wap/ask/list.jsp?type=1&status=0";
                        }else{
                            //提交发布跳转到已提交列表
                            window.location.href="http://qy.do1.com.cn/wxqyh/jsp/wap/ask/list.jsp?type=1&status=1";
                        }
                    }else{
                        showMsg("",result.desc,1);
                    }
                    //hideLoading();
                },
                error:function(){
                    showMsg("",internetErrorMsg,1);
                }
            });

        */

    </script>
</head>
    
<body>

<div class="simple_tips" id="loading_simple_div" style="display: none; position: fixed;">
    <div class="simple_tips_content text-center">
        <div id="loading" class="loading ma">
            <div><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span>
			</div>
        </div>
        <div class="simple_tips_text mt10">
            <p id="loading_text">加载中...</p>
        </div>
    </div>
</div>

<div class="overlay" id="overlayImage" style="display: none;"></div>




<script>
	 /**
	 *显示加载页面
	 *msgContent 加载页面显示的内容，如果不传，默认为"加载中..."
	 */
	function showLoading(msgContent) {
		//传入的信息为空
		if(msgContent == undefined || msgContent==""){
			$("#loading_text").html("加载中...");
		}
		else{
			$("#loading_text").html(msgContent);
		}
		$(".overlay").show();
		win_height = document.getElementById("overlayImage").offsetHeight/5;
		win_width = document.getElementById("overlayImage").offsetWidth;
		
		document.getElementById("loading_simple_div").style.display = "block";
		//让加载中剧中对齐
        var tips_width = document.getElementById("loading_simple_div").offsetWidth,
        tips_height= document.getElementById("loading_simple_div").offsetHeight,
        top = (win_height-tips_height)/2,
        left = (win_width-tips_width)/2;
		$("#loading_simple_div").css({
			'top' : top + "px",
			'left' : left + "px"
		});
	}

	 /**
	 *隐藏加载页面
	 */
	function hideLoading() {
		$(".overlay").hide();
		document.getElementById("loading_simple_div").style.display = "none";
	}

    showLoading();
</script>




<div id="wrap_main" class="wrap">
    <div id="main" class="wrap_inner">
        <form id="orderForm">
            <div class="form-style">
                <g:each in="${mooncake}" status="i" var="it1"> 
                    <div class="letter_bar menu_title" id="menu_${i}">
                        <i class="icon-caret-right"></i>
                        <span>${it1.key}</span>
                    </div>
                    <g:each in="${it1.value}" status="j" var="it2"> 
                        <div class="f-item menu_item menu_${i}" style="display: none;">
                            <div class="inner-f-item item-text flexbox "> 
                                <span class="f-item-title" style="width: 105px;">${it2.name}</span>
                                <span class="f-item-title" style="width: 25px;">${it2.price}</span>
                                <input type="hidden" name="price" value="${it2.price}"/>
                                <input type="hidden" name="pno" value="${it2.no}"/>
                                <div class="flexItem center">
                                    礼盒：
                                    <i class="icon-minus-sign red"></i>
                                    <input type="number" name="box" value="${it2.box}" class="item-select inputStyle center num"/>
                                    <i class="icon-plus-sign green"></i>
                                </div>
                                <div class="flexItem center">
                                    礼券：
                                    <i class="icon-minus-sign red"></i>
                                    <input type="number" name="ticket" value="${it2.ticket}" class="item-select inputStyle center num"/>
                                    <i class="icon-plus-sign green"></i>
                                </div>
                            </div> 
                        </div>
                    </g:each>
                </g:each>

                <div class="letter_bar">订单信息</div>
                <div class="f-item ">
                    <div class="inner-f-item item-text flexbox "> 
                        <div class="flexItem center">
                        礼盒合计：<span id="total_box">0</span> 盒，礼券合计：<span id="total_ticket">0</span> 张，金额合计：<span id="total_price">0</span> 元
                        </div>
                    </div> 
                </div>
                <div class="f-item ">
                    <div class="inner-f-item item-text flexbox "> 
                        <span class="f-item-title" >联络人</span>
                        <div class="flexItem">
                            <input type="text" name="name" value="${h.name}" class="item-select item-input inputStyle" />
                        </div>
                    </div> 
                </div>
                <div class="f-item ">
                    <div class="inner-f-item item-text flexbox "> 
                        <span class="f-item-title" >联系电话</span>
                        <div class="flexItem">
                            <input type="text" name="phone" value="${h.phone}" class="item-select item-input inputStyle" />
                        </div>
                    </div> 
                </div>
            
                <div class="f-item ">
                    <div class="inner-f-item item-text flexbox "> 
                        <span class="f-item-title" >提货时间</span>
                        <div class="flexItem">
                            <input type="text" style="width:75%" id="shipTime" name="shipTime" value="${h.shipTime}" placeholder="请选择日期" readonly="readonly" class="item-input inputStyle" />
                        </div>
                    </div> 
                </div>


                <div class="f-item ">
                    <div class="inner-f-item item-text flexbox"> 
                        <span class="f-item-title">提货方式</span>
                        <div class="flexItem">
                            <select name="type" class="flexItem item-select" >
                                <option value="0" ${(h.type=='0') ? 'selected="selected"' : ''}>门店取货</option>
                                <option value="1" ${(h.type=='1') ? 'selected="selected"' : ''}>送货上门</option>
                                <option value="2" ${(h.type=='2') ? 'selected="selected"' : ''}>工厂自取</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="f-item ">
                    <div class="inner-f-item item-text flexbox "> 
                        <span class="f-item-title" >门店/地址</span>
                        <div class="flexItem">
                            <input type="text" name="address" value="${h.address}" class="item-select item-input inputStyle" />
                        </div>
                    </div> 
                </div>
                <div class="f-item">
                    <div class="inner-f-item">
                        <div class="text_div">
                            <textarea class="item-select inputStyle" name="comment" cols="30" rows="5" placeholder="请输入订单备注">${h.comment}</textarea>
                        </div>
                    </div>
                </div>                    
                <div class="form_btns mt10">
                    <div class="inner_form_btns">
                        <div class="fbtns flexbox"> 
                            <input type="hidden" name="status" id="status" value="" />
                            <input type="hidden" name="id" id="id" value="${h.id}" />
                            <a class="fbtn btn gray_btn flexItem" style="margin-right: 5px;" href="javascript:commitOrder('draft')">保存为草稿</a>
                            <a class="fbtn btn flexItem" style="margin-left: 5px;" href="javascript:commitOrder('init')">立即提交</a>
                        </div>
                        <div class="fbtns_desc">如果你还没有确定现在立即发布，可以保存为草稿，之后可以再次编辑。</div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
        
<!-- script type="text/javascript" src="http://qy.do1.com.cn/wxqyh/jsp/wap/js/jweixin-1.0.0.js"></script -->
<!-- script type="text/javascript" src="http://qy.do1.com.cn/wxqyh/jsp/wap/js/CheckJSApi.js?ver=15.07.17.28"></script -->
<script type="text/javascript" language="javascript">

	var operationNeedHandle = "";

    var width = $(this).width(),
        height = $(this).height(),
        win_width = $(window).width(),
        win_height = ($(window).height())*0.9;//需要减去微信上方的头的2倍高度
	/**
	 * msgTitle 标题
	 * msgContent 消息内容
	 * type 1 确认；2确认，取消
	 * needHandle 传入成功或者失败的处理函数，如下{ok:function(result){},fail:function(result){}}
	 */
	function showMsg(msgTitle, msgContent, type, needHandle) {
		if (msgTitle == "")
			msgTitle = "提示内容";
		//$("#showMsg_overlay").height(($("#showMsg_overlay").height()+document.body.clientHeight)+"px");
		$("#showMsg_overlay").height($(document).height());
		$("#hmsgTitle").html(msgTitle);
		$("#pmsgContent").html(msgContent);
		if (1 == type) {
			$("#btnConfirm").show();
			$("#btnCancel").hide();
		} else if (2 == type) {
			$("#btnConfirm").show();
			$("#btnCancel").show();
		} else {
			$("#btnConfirm").show();
			$("#btnCancel").hide();
		}

		$(".overlay").show();
        console.log(document.getElementById('overlayImage'))
		win_height = document.getElementById("overlayImage").offsetHeight/5;
		win_width = document.getElementById("overlayImage").offsetWidth;
		//$("#showMsg_div").show();
		document.getElementById("showMsg_div").style.display = "block";
		//让加载中剧中对齐
        var tips_width = document.getElementById("showMsg_div").offsetWidth,
        tips_height= document.getElementById("showMsg_div").offsetHeight,
        top = (win_height-tips_height)/2,
        left = (win_width-tips_width)/2;
		$("#showMsg_div").css({
			'top' : top + "px",
			'left' : left + "px"
		});
		operationNeedHandle = needHandle;
	}

	/**
	 * 关闭消息窗口 operationRCD{0:确定, -1:取消，1:关闭}
	 */
	function closeMsgBox(flag) {
		$("#hmsgTitle").html("");
		$("#pmsgContent").html("");
		$(".overlay").hide();
		document.getElementById("showMsg_div").style.display = "none";

		if (operationNeedHandle == undefined || operationNeedHandle == "") {
			return;
		} else if (operationNeedHandle == 1) {
			if (0 == flag) {
				try {
					handle();
				} catch (e) {

				}
			}
		} else {
			//执行操作事件
			if (0 == flag) {
				e = operationNeedHandle.ok;
			} else {
				e = operationNeedHandle.fail;
			}
			if (e != null) {
				e && e.call(e, null, null);
			}
		}
	}
	

	/**
	 * option 选项
	 * msgTitle 标题
	 * needHandle 传入成功或者失败的处理函数，如下{ok:function(result){},fail:function(result){}}
	 */
	function showChooseBox(option, msgTitle, needHandle,flowId) {
		if(1<arguments.length && msgTitle != ""){
			$("#chooseMsgTital").html("<p>"+msgTitle+"</p>");
		}
		else{
			$("#chooseMsgTital").hide();
		}
		if(option.length>0){
			var temp = "";
			if(flowId){
				for(var i=0;i<option.length;i++){
					if(flowId==option[i].id){
						temp += '<li class="active"><input type="radio" style="display:none" name="radio_choose" checked="checked" vname="'+option[i].name+'" value="'+option[i].id+'">'+
						'<div class="xian_option"><i class="fa"></i>'+option[i].name+'</div></li>';
					}
					else{
						temp += '<li><input type="radio" style="display:none" name="radio_choose" vname="'+option[i].name+'" value="'+option[i].id+'">'+
						'<div class="xian_option"><i class="fa"></i>'+option[i].name+'</div></li>';
					}
				}
			}
			else{
				for(var i=0;i<option.length;i++){
					temp += '<li><input type="radio" style="display:none" name="radio_choose" vname="'+option[i].name+'" value="'+option[i].id+'">'+
					'<div class="xian_option"><i class="fa"></i>'+option[i].name+'</div></li>';
				}
			}
		}

		$(".overlay").show();
		win_height = document.getElementById("overlayImage").offsetHeight/5;
		win_width = document.getElementById("overlayImage").offsetWidth;
		//$("#showMsg_div").show();
		document.getElementById("chooseMsg_div").style.display = "block";
		//让加载中剧中对齐
        var tips_width = document.getElementById("chooseMsg_div").offsetWidth,
        tips_height= document.getElementById("chooseMsg_div").offsetHeight,
        top = (win_height-tips_height)/2,
        left = (win_width-tips_width)/2;
		$("#chooseMsg_div").css({
			'top' : top + "px",
			'left' : left + "px"
		});
		if(2<arguments.length){
			operationNeedHandle = needHandle;
		}
	}



</script>

<div class="text_tips" id="showMsg_div"
	style="display: none; position: fixed; left: 50%;">
	<div class="inner_text_tips">
		<div class="text_tips_content" id="pmsgContent"></div>
		<div class="text_tips_btns flexbox">
			<a id="btnConfirm" class="btn tips_submit_btn flexItem" href="javascript:closeMsgBox(0);">确定</a>
			<a id="btnCancel" class="btn tips_cancel_btn  flexItem" href="javascript:closeMsgBox(-1);">取消</a>
		</div>
	</div>
	<input type="hidden" value="" id="operationNeedHandle" />
</div>





</body>
</html>
