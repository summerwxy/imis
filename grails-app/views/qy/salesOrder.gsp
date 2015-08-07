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
        }
        .red {
            color: red;
        }
        </style>
	    
	    <script type="text/javascript">
		    (function($){
		        $(function(){

		        	opt.preset='datetime';//调用日历显示  日期时间
		        	$('#taskStart').mobiscroll(opt);//直接调用日历 插件
		            $('#taskStart').on('focus', function(){
		            	$("#title").css("ime-mode","disable");
		        		$("#content").css("ime-mode","disable");
		            });

        		    //设置初始化时间
          			var nowDate1=new Date();
          			$("#taskStart").val(nowDate1.Format("yyyy-MM-dd 09:00"));	

        	//	showMsg("","请假天数只能为数字",1);
	

                    $('i.icon-minus-sign').on('click', function() {
                        var tar = $(this).next();
                        var val = (tar.val().length == 0) ? 0 : parseInt(tar.val(), 10);
                        val -= 1;
                        tar.val(val < 0 ? 0 : val);
                    });

                    $('i.icon-plus-sign').on('click', function() {
                        var tar = $(this).prev();
                        var val = (tar.val().length == 0) ? 0 : parseInt(tar.val(), 10);
                        val += 1;
                        tar.val(val);
                    });

                    $("input[type='number']").on("click", function () {
                       $(this).select();
                    });

		        });		
		    })(jQuery);
            
        	
        	//提交任务
        	function commitTask(status){
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
        	}
        </script>
    </head>
    
    <body>
        <div id="wrap_main" class="wrap">
            <div id="main" class="wrap_inner">
				
                <div class="form-style">
                    <g:each in="${mooncake}" status="i" var="it1"> 
                        <div class="letter_bar">
                            <span>${it1.key}</span>
                        </div>
                        <g:each in="${it1.value}" status="j" var="it2"> 
                            <div class="f-item ">
                                <div class="inner-f-item item-text flexbox "> 
                                    <span class="f-item-title" style="width: 105px;">${it2.name}</span>
                                    <span class="f-item-title" style="width: 25px;">${it2.price}</span>
                                    <div class="flexItem center">
                                        礼盒：
                                        <i class="icon-minus-sign red"></i>
                                        <input type="number" name="box" value="0" class="item-select inputStyle center num"/>
                                        <i class="icon-plus-sign green"></i>
                                    </div>
                                    <div class="flexItem center">
                                        礼券：
                                        <i class="icon-minus-sign red"></i>
                                        <input type="number" name="ticket" value="0" class="item-select inputStyle center num"/>
                                        <i class="icon-plus-sign green"></i>
                                    </div>
                                </div> 
                            </div>
                        </g:each>
                    </g:each>

                    <div class="letter_bar">订单信息</div>
                	<div class="f-item ">
                        <div class="inner-f-item item-text flexbox "> 
                        	<span class="f-item-title" >联络人</span>
                        	<div class="flexItem">
                        		<input type="text" name="name" class="item-select item-input inputStyle" />
                        	</div>
                        </div> 
                    </div>
                	<div class="f-item ">
                        <div class="inner-f-item item-text flexbox "> 
                        	<span class="f-item-title" >联系电话</span>
                        	<div class="flexItem">
                        		<input type="text" name="phone" class="item-select item-input inputStyle" />
                        	</div>
                        </div> 
                    </div>
                
                    <div class="f-item ">
                        <div class="inner-f-item item-text flexbox "> 
                        	<span class="f-item-title" >提货时间</span>
                        	<div class="flexItem">
                        		<input type="hidden" name="tbQyAskPO.startTime" value="" id="hiddenStartTime"/>
                        		<input type="text" style="width:75%" id="taskStart" value="" placeholder="请选择日期" readonly="readonly" class="item-input inputStyle" />
                        	</div>
                        </div> 
                    </div>


                    <div class="f-item ">
                        <div class="inner-f-item item-text flexbox"> 
                        	<span class="f-item-title">提货方式</span>
                        	<div class="flexItem">
	                        	<select name="type" class="flexItem item-select" >
                                    <option>门店取货</option>
                                    <option>送货上门</option>
                                    <option>工厂自取</option>
	                        	</select>
                        	</div>
                        </div>
                    </div>

                	<div class="f-item ">
                        <div class="inner-f-item item-text flexbox "> 
                        	<span class="f-item-title" >门店/地址</span>
                        	<div class="flexItem">
                        		<input type="text" name="address" class="item-select item-input inputStyle" />
                        	</div>
                        </div> 
                    </div>
                    <div class="f-item">
                        <div class="inner-f-item">
                            <div class="text_div">
                                <textarea class="item-select inputStyle" name="comment" id="content" cols="30" rows="5" placeholder="请输入订单备注"></textarea>
                            </div>
                        </div>
                    </div>                    
                    <div class="form_btns mt10">
                        <div class="inner_form_btns">
                            <div class="fbtns flexbox"> 
                            	<input type="hidden" name="tbQyAskPO.askStatus" id="taskStatus" value="" />
                            	<a class="fbtn btn gray_btn flexItem" style="margin-right: 5px;" href="javascript:commitTask('0')">保存为草稿</a>
 								<a class="fbtn btn flexItem" style="margin-left: 5px;" href="javascript:commitTask('1')">立即提交</a>
                            </div>
                            <div class="fbtns_desc">如果你还没有确定现在立即发布，可以保存为草稿，之后可以再次编辑。</div>
                        </div>
                    </div>
                </div>
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


<div class="overlay" id="overlayImage" style="display: none;"></div>



</body>
</html>
