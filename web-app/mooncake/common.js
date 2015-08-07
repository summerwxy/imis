    var notFilled="未填写"; 
	var file;
	var dateId;
	var imgShowId;
	var lng="";//经度
	var lat="";//纬度
	var upLoadImgType;//上传图片后是否需要回调函数
	var upLoadImgHeightType;//上传图片显示高度类型
	var isDelImgNotify;//是否删除图片后通知，1为通知
	var internetErrorMsg="网络错误，请重试！";

	function DqdpForm() {
	    DqdpForm.prototype.submitCheck = function ($formId) {
	        var fieldList = $("#" + $formId + " [valid]");
	        var canSubmit = true;
	        var firstError = null;
	        $.each(fieldList, function (index, content) {
	            var eleStatus = "";
	            var validStr = $(content).attr("valid");
	            var validJson = eval("(" + validStr + ")");
	            if(validJson.type=="RadioButton"){
	            	if(validJson.must && _isNotChoose(content)){
		                eleStatus = "请填写" + validJson.tip;
		                canSubmit = _appendErrorTip(content, eleStatus);
	            	} else {_removeErrorTip(content);}
	            }
	            else if(validJson.type=="CheckBox"){
	            	eleStatus = _checkChoose(content,validJson.minLength,validJson.maxLength,validJson.must);
	            	if(eleStatus != ""){
		                canSubmit = _appendErrorTip(content, eleStatus);
	            	} else {_removeErrorTip(content);}
	            }
	            else if(validJson.type=="GeoField"){
		            var validValue = $(content).val();
	    			if(!isWeChatApp()) {
		                eleStatus = "该表单需要获取微信位置信息，请使用微信企业号填写";
		                canSubmit = _appendErrorTip(content, eleStatus);
	    			}
	    			else if(validJson.must && ( _isNullValue(validValue) || _isNull(validValue))){
		                eleStatus = "需要打开GPS，并开启该应用的‘提供位置信息’";
		                canSubmit = _appendErrorTip(content, eleStatus);
	            	} else {_removeErrorTip(content);}
	            }
	            else if(validJson.type=="TimeField"){
		            var validValue = $(content).val();
	            	if(validJson.must && ( _isNullValue(validValue) || _isNull(validValue))){
		                eleStatus = "请填写" + validJson.tip;
		                canSubmit = _appendErrorTip(content, eleStatus);
	            	} else {
		            	//需要完善如果选择了其中一项，另一项必须选择的问题
	            		var nullIndex = 0;
		            	var els =document.getElementsByName($(content).attr("name"));
	            		var length = els.length;
		            	for (var i = 0; i < length; i++){
		            		if(_isNullValue(els[i].value) || _isNull(els[i].value)){
		            			nullIndex++;
		            		}
		            	}
		            	if(nullIndex<length && nullIndex>0){
			                eleStatus = "请将" + validJson.tip+"填写完整";
			                canSubmit = _appendErrorTip(content, eleStatus);
			                if (!firstError)firstError = els[i];
		            	}
		            	else{
		            		_removeErrorTip(content);
		            	}
	            	}
	            }
	            else{
		            var validValue = $(content).val();
		            if (_isNullValue(validValue) || _isNull(validValue)) {
		            	if(validJson.must){
			                eleStatus = "请填写" + validJson.tip;
			                canSubmit = _appendErrorTip(content, eleStatus);
		            	}else {_removeErrorTip(content);}
		            }
		            else{
		                switch (validJson.fieldType) {
		                    case "datetime":
		                    {
		                        eleStatus = checkDate(validValue, 'yyyy-MM-dd HH:mm:ss');
		                        break;
		                    }
		                    case "date":
		                    {
		                        eleStatus = checkDate(validValue, 'yyyy-mm-dd');
		                        if(eleStatus == ""){
		                        	eleStatus = checkTime(validJson.stratTime, validJson.endTime,validValue);
		                        }
		                        break;
		                    }
		                    case "certId":
		                    {
		                        eleStatus = checkCertID(validValue);
		                        break;
		                    }
		                    case "pattern":
		                    {
		                        var temp = new RegExp(validJson.regex, "g");
		                        if (!temp.test(validValue)) { eleStatus = "输入的格式不正确或者输入了换行符"; }
		                        break;
		                    }
		                    case "func":
		                    {
		                        var result = eval(validJson.regex);
		                        if (!result) { eleStatus = "格式不正确"; }
		                        break;
		                    }
		                    default:
		                    {}
		                }
		                var min = validJson.minLength;
						var max = validJson.maxLength;
			            if(validJson.type=="NumberField"){
							if(max>0 && min==0){
				            	if(validValue>max){
				            		eleStatus = "只能输入不大于"+max+"的数字";
				            	}
							}
							else if(max==0 && min>0){
				            	if(validValue<min){
				            		eleStatus = "只能输入不小于"+min+"的数字";
				            	}
							}
							else if(max>0 && min>0){
				            	if(validValue>max || validValue<min){
				            		eleStatus = "只能输入"+min+"-"+max+"之间的数";
				            	}
							}
			            }
			            else{
							if(max>0 && min==0){
								var num = _strlength(validValue);
				            	if(num>max){
				            		eleStatus = "只能输入不大于"+max+"个英文字符或一半长度的汉字";
				            	}
							}
							else if(max==0 && min>0){
								var num = _strlength(validValue);
				            	if(num<min){
				            		eleStatus = "只能输入不小于"+min+"个英文字符或一半长度的汉字";
				            	}
							}
							if(max>0 && min>0){
								var num = _strlength(validValue);
				            	if(num>max || num<min){
				            		eleStatus = "只能输入"+min+"-"+max+"个英文字符或一半长度的汉字";
				            	}
							}
			            }
		                if (eleStatus == "")_removeErrorTip(content);
		                else { _appendErrorTip(content, validJson.tip + eleStatus);}
		            }
	            }
                if (eleStatus != "") {
                    canSubmit = false;
                    if (!firstError)firstError = content;
                }
	        });
	        if (firstError)
	            firstError.focus();
	        //_resetFrameHeight();
	        return canSubmit;
	    };
	}
	function _appendErrorTip($ele, $tip) {
	    if ($(".error", $($ele).parent()).html() == null){
	        $($ele).parent().append("<p class='error'><font color='red'>" + $tip + "</font></p>");
	    }
	    else{
	        $(".error", $($ele).parent()).remove();
	        $($ele).parent().append("<p class='error'><font color='red'>" + $tip + "</font></p>");
	    }
	    return false;
	}
	function _removeErrorTip($ele) {
	    if ($(".error", $($ele).parent()).html() != null)
	        $(".error", $($ele).parent()).remove();
	    return false;
	}
	/**-------------校验方法区开始---------------------*/
	var regYyyy_mm_dd_A = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;
	var regDateTime = /^(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})$/;
	var regChineseY_m_d = /^(\d{4})年(\d{1,2})月(\d{1,2})$/;
	var regSlashY_m_d = /^(\d{4})\/(\d{1,2})\/(\d{1,2})$/;
	var regSlashYmd = /^(\d{4})(\d{1,2})(\d{1,2})$/;
	var sDateFormatA = "yyyy-mm-dd";
	//默认的日期格式
	var sDateFormatB = "yyyy年mm月dd日";
	//中文格式
	var sDateFormatC = "yyyy/mm/dd";
	var MONTH_LENGTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	var LEAP_MONTH_LENGTH = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	function _isNull($value) {
	    if (typeof($value) == "object")$value = $value.toString();
	    if ($value == "" || $value.replace(/\s+/g, "") == "")
	        return true;
	    return false;
	}

	function checkCertID($cerValue) {
	    var rs = true;
	    var certID = $cerValue;
	    //先去掉身份证前后的空格
	    certID = certID.replace(/(^\s+)|(\s+$)/g, "");
	    if (certID != "") { }
	    else return "身份证号格式错误";
	    if (certID.length == 15 || certID.length == 18) {
	        if (certID.length == 15) {
	            year = "19" + certID.substring(6, 8);
	            month = certID.substring(8, 10);
	            day = certID.substring(10, 12);
	        } else {
	            year = certID.substring(6, 10);
	            month = certID.substring(10, 12);
	            day = certID.substring(12, 14);
	        }

	        rs = checkDate(year + month + day, "yyyymmdd")
	    } else {
	        return "不应为" + certID.length + "位，请纠正\n";
	    }
	    return rs == "" ? "" : "身份证号中的日期错误";
	}

	function checkDate(sValue, sFormat) {
	    if (sValue != "") {
	        var regUseFormat = null;
	        /**
	         * 默认值为YYYY-mm-dd
	         */
	        if (sFormat == null) {
	            sFormat = sDateFormatA;
	            regUseFormat = regYyyy_mm_dd_A;
	        }

	        if (sFormat == "yyyy-mm-dd") {
	            regUseFormat = regYyyy_mm_dd_A;
	            //yyyy-mm-dd
	        } else if (sFormat == "yyyy年mm月dd日") {
	            regUseFormat = regChineseY_m_d;
	            //yyyy年mm月dd日
	        } else if (sFormat == "yyyy/mm/dd") {
	            regUseFormat = regSlashY_m_d;
	            //yyyy/mm/dd
	        } else if (sFormat == "yyyymmdd") {
	            regUseFormat = regSlashYmd;
	            //yyyy/mm/dd
	        } else if (sFormat == "yyyy-MM-dd HH:mm:ss") {
	            regUseFormat = regDateTime;
	            //yyyy/mm/dd
	        } else {
	            return  "正确的格式应为:" + sFormat + "!\n";
	        }

	        if (!regUseFormat.test(sValue)) {
	            return "应为日期类型!";
	        }

	        /**
	         * 检查日期的年月日是否正确
	         */
	        var aryYmd = sValue.match(regUseFormat);
	        var iYear = aryYmd[1];
	        var iMonth = aryYmd[2];
	        var iDay = aryYmd[3];

	        if (iYear < 1 || iYear > 9999 || iMonth < 1 || iMonth > 12 || iDay < 1 || iDay > getMonthDay(iMonth - 1, iYear)) {
	            return "中的日期有误!";
	        }
	        return "";
	    }
	    else return "";
	}

	function checkTime(begintime, endtime, userTime) {
	    if (userTime != "") {
		    //var bt = document.getElementsByName(begintime)[0].value;
		    //var et = document.getElementsByName(endtime)[0].value;
		    var ut = userTime.replaceAll("-", "/");
		    var dut = new Date(ut);
		    if(begintime != ""){
			    var bt = begintime.replaceAll("-", "/");
			    var dbt = new Date(bt);
			    if (dbt.getTime() > dut.getTime()) {
			        return "不能早于"+begintime;
			    }
		    }
		    if(endtime != ""){
			    var et = endtime.replaceAll("-", "/");
			    var det = new Date(et);
			    if (det.getTime() < dut.getTime()) {
			        return "不能晚于"+endtime;
			    }
		    }
		    //var today = new Date();
		    //today = today.getFullYear() + "/" + (today.getMonth() + 1) + "/" + today.getDate();
		    //today = new Date(today);
	    }
	    return "";
	}

	function getMonthDay(iMonth, iYear) {
	    return isLeapYear(iYear) ? LEAP_MONTH_LENGTH[iMonth] : MONTH_LENGTH[iMonth];
	}

	function isLeapYear(iYear) {
	    return ((iYear % 4 == 0) && ((iYear % 100 != 0) || (iYear % 400 == 0)));
	}
	
	
	/**判断区*/
	//判断字符串的长度
	function _strlength($str) {
	    var l = $str.length;
	    var n = l;
	    for (var i = 0; i < l; i++) {
	        if ($str.charCodeAt(i) < 0 || $str.charCodeAt(i) > 255) n++;
	    }
	    return n;
	}
	function _isNullValue($value) {
	    return $value == undefined || $value == null;
	}
    function _isNotChoose($value){
    	var isChoose = true;
    	var radio = $($value).find("input");
		for(var i=0;i<radio.length;i++){
			if ($(radio[i]).attr("checked")) {
				return false;
			}
		}
    	return isChoose;
    }
    function _checkChoose($value,min,max,must){
    	var checkedIndex = 0;
    	var radio = $($value).find("input");
    	var size = radio.length;
		for(var i=0;i<size;i++){
			if ($(radio[i]).attr("checked")) {
				checkedIndex = checkedIndex+1;
			}
		}
    	if(must && min == 0){
    		min = 1;
    	}
    	else if(min>size){
    		min = size;
		}
    	if(max>size){
    		max = size;
    	}
    	if(checkedIndex == 0 && min>0){
			return "请至少选择"+min+"项";
    	}
		if(checkedIndex<min || (max>0 && checkedIndex>max)){
			if(min == max){
				return "只能选择"+min+"项";
			}
			else if(min>0 && max==0){
				return "至少选择"+min+"项";
			}
			else if(min>0 && max>0){
				return "只能选择"+min+"-"+max+"项";
			}
			else{
				return "最多选择"+max+"项";
			}
		}
    	return "";
    }

	/**--------------校验方法区结束--------------------*/
	
    /**--------------初始化编辑页面---*/
    function _doEleValueDispathc($ele, $value) {
    	var objArgs = new Array();
    	objArgs.push($value);
        var valueTargets = $("[name]", $ele);
        $.each(valueTargets, function (index, content) {
            var targetObj = $(this);
            var names = targetObj.attr("name");
            names=names.split(".");
            var value = null;
            for (var i = 0; i < names.length; i++) {
                value = i == 0 ? $value : value[names[i]];
                if (value == null || value == undefined)value = "";
            }
            if (value != null && value != undefined && value!="") {
                _doElementValueSet(this, value);
            }
        });
    }
    function _doElementValueSet($ele, $value) {
        var targetObj = $($ele);
        if ($ele.tagName == "INPUT" || $ele.tagName == "TEXTAREA" || $ele.tagName == "SELECT") {
            if ($ele.tagName == "TEXTAREA") {
                targetObj.html($value);
            }
            else if ($ele.tagName == "SELECT") {
                switch (targetObj.attr("type")) {
	                case "hour":
	                	targetObj.val($value.split(":")[0]);
	                    break;
	                case "minute":
	                	targetObj.val($value.split(":")[1]);
	                    break;
	                default:
	                	targetObj.val($value);
                }
            } else {
                switch (targetObj.attr("type")) {
                    case "radio":
                        if (targetObj.val() == $value)
                        	radioSelect(targetObj.parent());
                        break;
                    case "checkbox":
                    	if($.type($value) != "array"){
                            if (targetObj.val() == $value)
                            	mutipleSelect(targetObj.parent());
                    	}
                    	else{
                            for (var j = 0; j < $value.length; j++) {
                                if (targetObj.val() == $value[j])
                                	mutipleSelect(targetObj.parent());
                            }
                    	}
                        break;
                    case "hidden":
                    	if(targetObj.attr("fields") == "ratingfield"){
                    		if($value>0){
                            	targetObj.val($value);
                    			var sib = targetObj.siblings('i');
                    			var size = (sib.length+1)/3;//加一是为了让有三个时1个为灰，有5个时两个为灰，有10个时三个为灰
                    			for(var i=0;i<$value;i++){
       			            	   if($value<=size){
       			            		   sib.eq(i).addClass('checked1');
       			                   }else{
       			            		   sib.eq(i).addClass('checked');
       			                   }
       			                }
                    		}
                    	}
                        break;
                    default:
                    	targetObj.val($value);
                }
            }
        } else if ($ele.tagName == "IMG") {
            targetObj.attr("src", targetObj.attr("src") + $value);
        } else {
            /*var charLength = targetObj.attr("charLength");
            if ($value == null || $value == undefined)$value = targetObj.attr("defaultValue");
            else {
                if (charLength != undefined && charLength != null && charLength != "") {
                    targetObj.attr("title", $value);
                    $value = _getStrByLen($value, charLength);
                }
            }*/
			var reg0=new RegExp("\r\n","g");
			var reg1=new RegExp("\r","g");
			var reg2=new RegExp("\n","g");
			$value = $value.replace(reg0,"</br>");
			$value = $value.replace(reg1,"</br>");
			$value = $value.replace(reg2,"</br>");
            targetObj.html(checkURL($value));
        }
    }
    function _isNullValue($value) {
        return $value == undefined || $value == null;
    }
    function _getStrByLen($str, $len) {
        if ($str == "")return "";
        var len = _strlength($str);
        var s = "";
        var n = 0;
        for (var i = 0; n < $len; i++) {
            n++;
            if ($str.charCodeAt(i) < 0 || $str.charCodeAt(i) > 255)n++;
            if (n > len) {
                break;
            }
            if (n <= $len + 1) {
                s = s + $str.charAt(i);
                if (n > $len || (n == $len && $len != len))s = s + "......";
            }
        }
        return s;
    }
    
    /**---------------初始化编辑页面结束-----------*/
	
    var reg_url =/(http:\/\/|https:\/\/)([\w].+\/?)\s*/g;
  //上传图片完成后的通知
    function notifyImage(paths,obj,name){
    	if(name==undefined || name ==""){
    		name = "imageUrls";
    	}
    	//imgShowId = imgUlId;
    	/*isDelImgNotify = 0;
    	var width = 65;
    	var height = 65;
    	//如果高度为屏幕款第的1/2
    	if(upLoadImgHeightType == 1){
    		width = "100%";
    		if(company_img_height == undefined){
    			height = $(window).width()/2;
    		}
    		else{
            	height = company_img_height+"px";
    		}
    	}*/
    	var _test="";
    	for(var i=0;i<paths.length;i++){
    		_test+="<li><input type=\"hidden\" name=\""+name+"\" value=\""+paths[i]+"\" />"+
        		"<a class=\"remove_icon\" onclick=\"doDelLi(this);\" href=\"javascript:void(0)\" style=\"display: none;\"></a>" +
        		"<p class=\"img\"><img onclick=\"viewImage('"+compressURL+paths[i]+"');\" src=\""+compressURL+paths[i]+"\"/></p></li>";
    	}
    	obj.before(_test);
       	//隐藏上传中的层
       	hideLoading();
       	if($('#imglist').find('li').length>2){
    		var url=document.location.href;
    		if(window.localStorage[url]){
    			var jsonStorage=JSON.parse(localStorage.getItem(url));
    			jsonStorage['uploadImgList']=$('#imglist').html();
    			localStorage[url]=JSON.stringify(jsonStorage);
    		}
        }
       	/*//调用回调函数
       	if(upLoadImgType == "1"){
           	uploadImageSucceed();
       	}*/
    }//删除部门
    function removeImage(obj,imgUlId){
    	var arry;
    	arry = $(obj).parent().find("a");
    	var show = $(obj).attr("show");
    	if(show==0){
    		$(obj).attr("show","1");
    		for(var i=0;i<arry.length;i++){
    			$(arry[i]).show();
    		}
    	}else{
    		$(obj).attr("show","0");
    		for(var i=0;i<arry.length;i++){
    			$(arry[i]).hide();
    		}
    	}
    	
    }
    /**
     * 删除li
     * @param $this  点击的a标签的对象
     */
    function doDelLi($this){
    	$($this).parent().remove();
    		var url=document.location.href;
    		if(window.localStorage[url]){
    			var jsonStorage=JSON.parse(localStorage.getItem(url));
    			jsonStorage['uploadImgList']=$('#imglist').html();
    			localStorage[url]=JSON.stringify(jsonStorage);
    		}
   
    }
    /**
     * 预览图片
     * @param imageVOs  图片的list
     */
    function previewImages(imageVOs,ulId,name){
    	if(!imageVOs || imageVOs.length==0){
    		return;
    	}
    	if(ulId==undefined || ulId ==""){
    		ulId = "imglist";
    	}
    	if(name==undefined || name ==""){
    		name = "imageUrls";
    	}
    	var _test="";
    	for(var i=0;i<imageVOs.length;i++){
    		_test+="<li><input type=\"hidden\" name=\""+name+"\" value=\""+imageVOs[i].picPath+"\" />"+
    		"<a class=\"remove_icon\" onclick=\"doDelLi(this);\" href=\"javascript:void()\" style=\"display: none;\"></a>" +
        		"<p class=\"img\"><img onclick=\"comPreviewImg(this);\" src=\""+compressURL+imageVOs[i].picPath+"\"/></p></li>";
    	}
       	$("#"+ulId).prepend(_test);
    }
    
    var loadMore = 
    {
    	viewMoreText: "",
    	loading: function() {
    		viewMoreText = $("#listMore").find("a").first().html();
    		$("#listMore").find("a").html("努力加载中...").attr("href", "javascript:void(0)");
    		$("#listMore").css("display", "block");
    	},
    	
    	afterLoad: function() {
    		$("#listMore").find("a").html(viewMoreText).attr("href", "javascript:listMore()");
    		$("#listMore").css("display", "block");
    	},
    	
    	finish: function() {
    		$("#listMore").find("a").html("已没有更多").attr("href", "javascript:void(0)");
    		$("#listMore").css("display", "block");
    	},
    	
    	showTag: function(hasMore) {
    		if (hasMore) this.afterLoad();
    		else this.finish();
    	}
    };
    
    function preLoadImage(url, $imgPlaceHolder) {
        var img = new Image(); //创建一个Image对象，实现图片的预下载
        img.src = url;
       
        if (img.complete) { // 如果图片已经存在于浏览器缓存，直接调用回调函数
        	$imgPlaceHolder.attr("src", img.src).css("display", "block");
            return; // 直接返回，不用再处理onload事件
        }

        img.onload = function () { //图片下载完毕
        	$imgPlaceHolder.attr("src", img.src).css("display", "block");
        };
    };
    
    /**
     * 替换没有头像的图片
     * @param obj
     */
    function replaceUserHeadImage(obj){
		$(obj).attr("src",baseURL+"/jsp/wap/images/img/touxiang02.png");
	}
    /**
     * 判断是否校友会或者微信企业号用户
     * @param obj
     */
    function judgeClient(obj){
    	var url = window.location.href;
        if((isWeChatApp() && url.indexOf("wxqyh") >= 0)) {
        	return false;
        }
    	$("#aLink").click();
    	return true;
	}
    var wxqyh_iswechatapp = null;//是否微信手机客户端打开
    /**
     * 判断是否微信打开
     * @returns {Boolean}
     */
    function isWeChatApp(){
    	if(wxqyh_iswechatapp == null){
        	var ua = navigator.userAgent.toLowerCase();
            if((ua.match(/MicroMessenger/i)=="micromessenger") && ua.indexOf("windowswechat")==-1) {
            	wxqyh_iswechatapp = true;
            }
            else{
            	wxqyh_iswechatapp = false;
            }
    	}
        return wxqyh_iswechatapp;
    }
   
    var sy = $.extend({}, sy);/* 定义一个全局变量 */
    sy.serializeObject = function(form) { /* 将form表单内的元素序列化为对象，扩展Jquery的一个方法 */
    	var o = {};
    	$.each(form.serializeArray(), function(index) {
    		if (o[this['name']]) {
    			o[this['name']] = o[this['name']] + "," + this['value'];
    		} else {
    			o[this['name']] = this['value'];
    		}
    	});
    	return o;
    };

    function Map()   
    {    
       this.container = {};    
    }    
     
    //将key-value放入map中   
    Map.prototype.put = function(key,value){    
     try{    
          
       if(key!=null && key != "")   
          this.container[key] = value;    
     
      }catch(e){    
        return e;    
       }    
    };    
     
    //根据key从map中取出对应的value   
    Map.prototype.get = function(key){    
     try{    
     
        return this.container[key];    
     
     }catch(e){    
        return e;    
     }    
    }; 
    
    Array.prototype.indexOf = function(val) {
        for (var i = 0; i < this.length; i++) {
            if (this[i] == val) return i;
        }
        return -1;
    };
    Array.prototype.remove = function(val) {
        var index = this.indexOf(val);
        if (index > -1) {
            this.splice(index, 1);
        }
    };
    function strToJson(str){ 
    	var json = (new Function("return " + str))(); 
    	return json; 
  	}
    
    (function($) {    
        /** 
         * 将form表单中的值转换为json格式 
         */  
        $.fn.formtojson = function() {     
            var obj={};  
            var serializedParams = this.serialize();  
            function evalThem (str) {  
                var attributeName =  str.split("=")[0];  
                var attributeValue = str.split("=")[1];  
                if(!attributeValue){  
                    attributeValue = '';  
                }  
                var array = attributeName.split(".");  
                for (var i = 1; i < array.length; i++) {  
                    var tmpArray = Array();  
                    tmpArray.push("obj");  
                    for (var j = 0; j < i; j++) {  
                        tmpArray.push(array[j]);  
                    };  
                    var evalString = tmpArray.join(".");  
                    if(!eval(evalString)){  
                        eval(evalString+"={};");                  
                    }  
                };  
                eval("obj."+attributeName+"='"+unescape(attributeValue).replace(/'/, "\\'")+"';");   
            };  
            var properties = serializedParams.split("&");  
            for (var i = 0; i < properties.length; i++) {  
                evalThem(properties[i]);  
            };  
            return obj;  
        };
    }($));
    
    String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {  
        if (!RegExp.prototype.isPrototypeOf(reallyDo)) {  
            return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);  
        } else {  
            return this.replace(reallyDo, replaceWith);  
        }  
    }
	Date.prototype.Format = function(fmt)   
	{ //author: meizz   
	  var o = {   
	    "M+" : this.getMonth()+1,                 //月份   
	    "d+" : this.getDate(),                    //日   
	    "h+" : this.getHours(),                   //小时   
	    "m+" : this.getMinutes(),                 //分   
	    "s+" : this.getSeconds(),                 //秒   
	    "q+" : Math.floor((this.getMonth()+3)/3), //季度   
	    "S"  : this.getMilliseconds()             //毫秒   
	  };   
	  if(/(y+)/.test(fmt))   
	    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
	  for(var k in o)   
	    if(new RegExp("("+ k +")").test(fmt))   
	  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
	  return fmt;   
	}
	//去除左右空格
	function trimLR(sendComment){
		sendComment = sendComment.replace(/(^\s*)/g, ""); 
   	    //去除右空格
   		sendComment = sendComment.replace(/(\s*$)/g, "");  
   		return sendComment;
	}
	//评论输入内容转换（表情标签转编码）
	function imgToCode(){
		var html = $("#inputDiv").html();
		var emojis = html.match(/\[.*?\]/g);
		emojis = (emojis==null)?"":emojis;
		if(typeof(emojis)=="object"){
			for(var i=0;i<emojis.length;i++){
				var word = emojis[i];
				var code = wordToCode(word.substring(1,word.length-1));
				if(code!=null){
					html = html.replace(word," "+code);
				}
			}
		}
		return html;
	}
	function tranImgToCode(){
		var html = $("#inputDiv").html();
		var list = $("#inputDiv").find("img");
		for(var i=0;i<list.length;i++){
			var img = list[i];
			var title = $(img).attr("title");
			var tmp = document.createElement("div");
			tmp.appendChild(img);
			html = html.replace(tmp.innerHTML," "+title);
		}
		return html;
	}
	
	function closeEmoji(){
		var plus_btns = $("#plus_btns"),
        emoji_list = $("#emoji_list"),
        text_input = $(".text_input");

	    text_input.blur();
	    if( !plus_btns.ishide() || !emoji_list.ishide() ){
	        plus_btns.hide();
	        emoji_list.hide();
	        text_input.focus();
	    }
	}
    // 计算选人的图片长度
    function setSelectUserWidth(){
        var totalWidth = 0;
        $(".selected_user li").each(function(index){
            $(this).find("img").on("load", function(){
                totalWidth += ($(this).parent().width()+5);
                if($(".selected_user li").length = index+1){
                    $(".selected_user_inner").width(totalWidth);
                }

            });
        });
    }
    
    /**
     * 上传图片后预览图片，此时显示的为小图
     * @param src
     */
    function viewImage(src){
    	showImage(src);
    }
	$(function() {
		//内容图片预览
		$(".article_content").on("click","img",function(){
			if(checkJsApi_image && isWeChatApp()) {
				var contentPicList=new Array();	//当前页面图片集合
				var cureentpath=$(this).attr("src");		//当前点击的图片链接
				$('.article_detail').find("img").each(function(i){
					var path=$(this).attr('src');
					var temp = path.substring(path.lastIndexOf('.') + 1, path.length).toLowerCase();
					if(path!='' &&  path!=undefined && path.indexOf("emoji")==-1){
						if(temp=="jpg" || temp=="png" || temp=="jpeg"){
							contentPicList.push($(this).attr('src'));
						}
					}
				});
				wx.previewImage({
				    current: cureentpath, // 当前显示的图片链接
				    urls: contentPicList // 需要预览的图片链接列表
				});
		    }else{
				var src = $(this).attr("src");
				window.location.href = baseURL + "/jsp/wap/tips/show_image.jsp?imgSrc="+src;
			}
		});
		// wxqyh.init();
	});
	function comPreviewImg(obj) {
		//评论图片预览
			if(checkJsApi_image && isWeChatApp()) {
				var comPicList=new Array();	//当前评论页面图片集合
				var comcureentpath=$(obj).attr("src");		//当前点击的图片链接
				$('.article_detail').find("img").each(function(i){
					var path=$(this).attr('src');
					var temp = path.substring(path.lastIndexOf('.') + 1, path.length).toLowerCase();
					if(path!='' &&  path!=undefined && path.indexOf("emoji")==-1){
						if(temp=="jpg" || temp=="png" || temp=="jpeg"){
							comPicList.push($(this).attr('src'));
						}
					}
				});
				wx.previewImage({
				    current: comcureentpath, // 当前显示的图片链接
				    urls: comPicList // 需要预览的图片链接列表
				});
		    }else{
				var src = $(obj).attr("src");
				window.location.href = baseURL + "/jsp/wap/tips/show_image.jsp?imgSrc="+src;
			}
	}
	//URL识别
	function checkURL(obj){
		if(!obj || obj==null){
			return "";
		}
		var str = obj.replace(/([=]?['"]?)(http(s)?\:\/\/[a-zA-Z0-9]+.[a-zA-Z0-9]+[a-zA-Z0-9\$\%\#\&\/\?\-\=\.\_\;\:]+)/gi,function(match,first,second,pos,origin){
			if(first == '="' || first == "='"){//判断url是否为元素中的属性值
				return match;
			}else {
				return first+"<a class='URLlink' href='"+second+"'><span>网页链接</span></a>";
			}
		});
		return str;
	}
	
	
	/**
	 * @author lishengtao
	 * 2015-6-4
	 * 设置分享的属性
	 */
	function setDataForWeixinValue(title,img,summary,shareUrl){
		
		if(img!=""){
			dataForWeixin.MsgImg=img;
		}
		
		title=$.trim(title);
		if(title!=""){
			dataForWeixin.title=title;
		}
		
		summary=$.trim(summary);
		if(summary!=""){
			dataForWeixin.desc=summary;
		}
		
		if(shareUrl.indexOf("&userId=${param.userId}")!=-1){
			shareUrl = shareUrl.replace("&userId=${param.userId}","");
		}else{
			shareUrl = shareUrl.replace("?userId=${param.userId}","");
		}
		
		dataForWeixin.url=shareUrl;
	}
	
	function restoreSubmit(){
    	setTimeout(function(){
    		$('.form_btns a.fbtn').css('pointer-events','auto');
    		},500)//还原提交按钮
    }

var noImg_inList="/themes/default/images/qw/pic_normal.png";//没有显示图片，方形，用在列表中
var secretImg_inList="/themes/default/images/qw/ic_secret.png";//保密图片，方形，用在列表中
var secretImg="/themes/default/images/qw/secret.jpg";//保密图片，用在封面和发送消息
