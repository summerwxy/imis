<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <title>爱维尔阳光蛋糕</title>

    <script type="text/javascript" src="${resource(dir: 'BigWheel', file: 'jquery-1.8.0.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'BigWheel', file: 'jQueryRotate.2.2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'BigWheel', file: 'jquery.easing.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'BigWheel', file: 'zp.js')}"></script>
    <link href="${resource(dir: 'BigWheel', file: 'BigWheel.css')}" rel="stylesheet" type="text/css" />

    <link href="${resource(dir: 'bootstrap/css', file: 'bootstrap.min.css')}" rel="stylesheet" />
    <script type="text/javascript">

    $(function() {
        var isRun = false;
        var isReady = false;
        var prize = '';
        var angle = 60; // 不是中獎位置

        $('#theLottery').on('click', function() {
            $.ajax({
                url: 'wheel_lottery',
                type: 'get',
                data: {type: 'lottery', sl_key: $('#sl_key').val()}, 
                dataType: 'json'
            }).done(function(json) {
                if (json.isValid) {
                    prize = json.prize;
                    angle = json.angle;
                    $('#theInput').slideUp("slow", function() {
                        $('#theWheel').slideDown("slow");
                    });
                    isReady = true;
                } else {
                    alert(json.prize);
                }
            }).fail(function(json) {
                alert('程序出错!(PTCMAC)');    
            });  
        });

        $('#theTest').on('click', function() {
            $.ajax({
                url: 'wheel_lottery',
                type: 'get',
                data: {type: 'test'}, 
                dataType: 'json'
            }).done(function(json) {
                prize = json.prize;
                angle = json.angle;
                $('#theInput').slideUp("slow", function() {
                    $('#theWheel').slideDown("slow");
                });
                isReady = true;
            }).fail(function(json) {
                alert('程序出错!(HYPAMC)');    
            });  
        });


        $(window).keydown(function(e) {
            if (e.keyCode == 96 && isReady) {  // space down
                if (!isRun) {
                    isRun = true;
                    $(".rotate-con-zhen").rotate({
                        duration: 60*60*1000,
                        angle: 0,
                        animateTo: 360,
                        easing: function(e,f,a,h,g) {
                            return f;
                        }
                    });
                }
            }
        }).keyup(function(e) {
            if (e.keyCode == 96 && isReady) { // space up
                var tar = $(".rotate-con-zhen");
                tar.stopRotate();
                // TODO: change this
                var tarAngle = parseInt(tar.getRotateAngle(), 10) % 360;
                tar.rotate({
                    duration: 2000,
                    angle: tarAngle,
                    animateTo: 1080 + angle,
                    easing: $.easing.easeOutSine,
                    callback: function () {
                        alert(prize);
                        $('#theWheel').slideUp("slow", function() {
                            $('#theInput').slideDown("slow");
                        });
                        isReady = false;
                        tar.rotate(0);
                    }
                });
                isRun = false;
            }
        }); 
            
    });

    </script>

</head>
<body>
    <div class="main">
        <br/>
        <div class="content">
            <div id="SetUp" class="boxcontent boxyellow">
                <div class="box">
                    <div class="title-green">
                        <span>奖项设置：</span></div>
                    <div class="Detail">
                        <p id="FirstPrize">
                            一等奖：双人台湾往返机票。奖品数量：1 名
                        </p>
                        <p id="SecondPrize">
                            二等奖：24cmB价生日蛋糕券一张 。奖品数量：2 名
                        </p>
                        <p id="ThirdPrize">
                            三等奖：QQ公仔一对 。奖品数量：200 名
                        </p>
                        <p id="FourthPrize">
                            参加奖：10元牛轧糖一盒 。
                        </p>
                    </div>
                </div>
            </div>
            <div id="SetUp1" class="boxcontent boxyellow">
                <div class="box">
                    <div class="title-green">
                        活动说明：</div>
                    <div class="Detail">
                        <p id="LotteryNumber">
                            1. 现金订购喜庆礼盒满500元即可参加抽奖<br/>
                            2. 如取消订单，则需要退还奖品或按照相应金额买单<br/>
                            3. 微网站每天公布前一天的中奖名单<br/>
                        </p>
                        <br/>
                        <p id="RateSum">
                            我们的中奖率高达100%！！
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <br/>


        <div id="theInput" style="text-align: center;">
            <div class="input-append" id="input-barcode">
                <input class="input-xlarge" id="sl_key" type="text" placeholder="输入客订单号" />
                <div class="btn-group" data-toggle="buttons-radio">
                    <button id="theLottery" class="btn btn-primary">参加抽奖</button>
                    <button id="theTest" class="btn btn-danger">测试抽奖</button>
                </div>
            </div>
        </div>
        <div id="theWheel" class="rotate-content" style="display: none;">
            <div class="rotate-con-pan">
                <div class="rotate-con-zhen">
                </div>
            </div>
            按下数字键 0 开始转动转盘, 松开停止转盘
        </div>        
    </div>
</body>
</html>
