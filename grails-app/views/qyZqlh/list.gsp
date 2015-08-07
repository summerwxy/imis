<!DOCTYPE html>
<html>    
<script>
var dqdp_csrf_token = "";
</script>
<!-- div id="id_dqdp_tip" style="position: absolute;"></div -->
<head>
    <meta charset="utf-8">
    <title>${title}</title>
    <meta name="description" content="">
    <meta name="HandheldFriendly" content="True">
    <meta name="MobileOptimized" content="320">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta content="telephone=no" name="format-detection" />
    <meta content="email=no" name="format-detection" />

    <link rel="stylesheet" href="${resource(dir: 'mooncake', file: 'ku.css')}" />
    <link rel="stylesheet" href="${resource(dir: 'themes/font-awesome/css', file: 'font-awesome.min.css')}" />

    <script type="text/javascript" src="${resource(dir: 'bower_components/jquery/dist', file: 'jquery.min.js')}"></script>

    <script type="text/javascript" src="${resource(dir: 'mooncake', file: 'common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'mooncake', file: 'jquery.form.js')}"></script>
</head>
    <body>
        <div id="wrap_main" class="wrap">
            <div class="search-box fixed" style="display: none;">
                <div class="inner-search-box">
	            <div class="search-box-o flexbox">
                	<div class="flexItem">
	                    <div class="search-input-box flexbox">
	                        <div class="flexItem" id="temp">
	                            <input class="search-input2" type="text" placeholder="搜索标题、人名" name="keyWord2" id="keyWord" style="display:none"/>  
	                            <input class="search-input" type="text" placeholder="搜索标题" name="keyWord" id="keyWord" style="display:none"/>  
	                        </div>
	                    </div>
	                </div>
	                <div class="search_more"> 
	                	<a href="javascript:enterSearch()" class="search_letter_btn"><i class="fa fa-search"></i></a>
                	</div>
                </div>
                </div>
            </div>
            <div id="main" class="wrap_inner" >
                <div class="address_list">
                    <div class="search-box-height" style="display: none;"></div>
                        <div class="search-box-height text-center" style="display: none;">
                            <h1 style="margin-top: 8px;">xxx</h1>
                        </div>                    
                    <!-- 模板数据 -->
                    <g:each in="${list}" status="i" var="it"> 
                        <div class="settings-item" id="order_${it.id}"> 
                            <span class="time">${it.last_updated[0..18]}</span> 
                            <div class="inner-settings-item flexbox"> 
                                <g:if test="${params.view == 'draft'}" >
                                    <div class="user_select_icon actived" onclick="selectTask(this, ${it.id})">
                                        <i class="icon-check"></i> 
                                    </div> 
                                </g:if>
                                <g:if test="${params.view == 'my'}">
                                    <div style="padding-right: 10px;">
                                        ${imis.QyZqlhController.status[it.all_status]}
                                    </div>
                                </g:if>
                                <div class="title description_title flexItem" onclick="gotoDetail(${it.id})"> 
                                    <p class="name">联络人：${it.name ?: '[未填写]'} / 出货时间：${it.ship_time ?: '[未填写]'}</p> 
                                    <p class="description description_ellipsis">提货方式：${['0': '门店取货', '1': '送货上门', '2': '工厂自取'][it.type]} / 地址：${it.address ?: '[未填写]'}</p> 
                                </div> 
                            </div> 
                        </div>
                    </g:each>
                </div>
                <div class="all_pull" id="showMoreDiv" >
                    <p class="lastComment"  id="moreTip">以下空白</p>
                </div>
                <div class="footheight" id="footheight" style="height:60px;display:none;"></div>
        	</div>
        	<div class="foot_bar" style="display:none;padding:5px;position:fixed">
                <div class="foot_bar_inner flexbox"> 
 					<a class="flexItem btn red_btn " href="javascript:doDelete()" style="margin-right: 10px;">删除选中任务</a>
                </div>
            </div>
       </div>
		
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
		 restoreSubmit();//还原提交按钮
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
		//$("#operationNeedHandle").val(needHandle);
		//operationCancelHandle = needCancelHandle;
		//$("#operationCancelHandle").val(needCancelHandle);
	}

	/* $(window).scroll(function() { */
		/* var scrolltop = $(window).scrollTop();
		$("#showMsg_div").css({
			'top' : scrolltop + 100 + "px"
		}); */
		/* //让加载中剧中对齐
        tips_height= document.getElementById("showMsg_div").offsetHeight,
        top = (win_height-tips_height)/2,
		$("#showMsg_div").css({
			'top' : top + "px"
		});
	}); */

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
	
	 /**
	  * show original image
	  */
	function showImage(url) {
		$("#src_image").attr("src",url);
		$("#overlayImage").show();
		$("#loading_image_div").show();
	}
	
	 /**
	  * hide original image
	  */
	function hideImage() {
		$("#overlayImage").hide();
		$("#loading_image_div").hide();
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
			$("#chooseMsgUl").html(temp);
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
        $('#chooseMsgUl').on('click','li',function(event){
            var self = $(this),
            context = self.parent(),
            siblings = $('.active',context);

    	    siblings.removeClass('active');
    	    self.addClass('active');

    	    context.find("input[type='radio']").attr("checked", false);
    	    self.find("input[type='radio']").attr("checked", true);
        });
	}
	/**
	 * 关闭消息窗口 operationRCD{0:确定, -1:取消，1:关闭}
	 */
	function closeChooseMsgBox(flag) {
		//console.log($("#chooseMsgUl input[name='radio_choose'][checked]"));
		var choose =  $("#chooseMsgUl input[name='radio_choose'][checked]");
		$("#chooseMsgTital").html("");
		$("#chooseMsgUl").html("");
		$(".overlay").hide();
		document.getElementById("chooseMsg_div").style.display = "none";

		if (operationNeedHandle == "") {
			return;
		}
		else {
			//执行操作事件
			if (0 == flag) {
				e = operationNeedHandle.ok;
			} else {
				e = operationNeedHandle.fail;
			}
			if (e != null) {
				var chooseValue = {};
				chooseValue.id = choose.val();
				chooseValue.name = choose.attr("vname");
				e && e.call(e, chooseValue, null);
			}
		}
	}

	function gotoDetail(id) {
        showLoading();
        <g:if test="${params.view == 'draft'}">
            window.location.href = '${createLink(action: 'salesOrder')}/' + id;
        </g:if>
        <g:if test="${params.view == 'my'}">
            window.location.href = '${createLink(action: 'detail')}/' + id;
        </g:if>
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

<!--图片预览-->
<div class="img_preview" id="loading_image_div" style="display: none;">
    <div class="inner_img_preview">
        <img  id='src_image'  src="" alt="" onclick="hideImage();"/>
      
    </div>
</div>

<div class="text_tips" id="chooseMsg_div" style="display: none;position: fixed; left: 40%;">
	<div class="inner_text_tips">
		<div id="question1" class="question_detail" style="">
			<div class="inner_question_detail">
				<div class="ask_info" id="chooseMsgTital"></div>
				<div class="ask_info">
					<div class="answer-list radio_btn">
						<ul id="chooseMsgUl">
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="text_tips_btns flexbox">
			<a id="btnConfirm" class="btn tips_submit_btn flexItem" href="javascript:closeChooseMsgBox(0);">确定</a>
			<a id="btnCancel" class="btn tips_cancel_btn  flexItem" href="javascript:closeChooseMsgBox(-1);">取消</a>
		</div>
	</div>
</div>
</body>
</html>
<script type="text/javascript">

	
	//删除选中的任务
	var objArray = new Array() ,idsArray = new Array();
	function selectTask(obj,taskId){
		var isActive = $(obj).hasClass("active");
		if(isActive){
			//取消选中
			$(obj).removeClass("active").addClass("actived");
			objArray.remove(obj);
			idsArray.remove(taskId);
		}else{
			//确定选中
			$(obj).removeClass("actived").addClass("active");
			objArray.push(obj);
			idsArray.push(taskId);
		}
		if(idsArray.length>0){
			//显示删除按钮
			$(".foot_bar").show();
			$("#footheight").show();
		}else{
			//隐藏删除按钮
			$(".foot_bar").hide();
			$("#footheight").hide();
		}
	}
	function doDelete(){
		showMsg(
				"提示",
				"确认删除订单？",
				2,
				{
					ok:function(result){
						batchDelete(idsArray);
					},
					fail:function(result){
						$("#showMsg_div").hide();
						$(".overlay").hide();
					}
				});
	}
	function batchDelete(idsArr){
		var ids = "";
		for(var i=0;i<idsArr.length;i++){
			ids+=idsArr[i]+",";
		}
        ids = ids.substring(0, ids.length - 1)
		showLoading("正在删除...");
		$.ajax({
			url: "${createLink(action: 'batch_delete')}",
			type:"post",
			data:{
				"ids":ids
			},
			dataType:"json",
			success:function(result){
                for(var i=0;i<idsArr.length;i++){
                    $('#order_' + idsArr[i]).remove();
		        }
                hideLoading();
                showMsg("","删除成功",1);
				idsArray = new Array();
    			//隐藏删除按钮
    			$(".foot_bar").hide();
    			$("#footheight").hide();                
			}
		});
	}
	function batchRemove(objArr){
		for(var i=0;i<objArr.length;i++){
			$(objArr[i]).parent().parent().remove();
		}
		objArray = new Array();
	}
	
</script>
