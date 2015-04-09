/****************************************************
*	 Author :	xuyw					            *
*	 Version:   v1.0								*
*   Email  :   xyw10000@163.com                    *
****************************************************/

function randomnum(smin, smax) {// 获取2个值之间的随机数
    var Range = smax - smin;
    var Rand = Math.random(); //系统随机选取大于等于 0.0 且小于 1.0 的伪随机 double 值
    return (smin + Math.round(Rand * Range)); //四舍五入
}

function runzp(FirstPrize, FirstPrizeRate, SecondPrize, SecondPrizeRate, ThreePrize, ThreePrizeRate) {
    var data = '[{"id":1,"prize":"' + FirstPrize + '","v":"' + FirstPrizeRate + '"},{"id":2,"prize":"' + SecondPrize + '","v":"' + SecondPrizeRate + '"},{"id":3,"prize":"' + ThreePrize + '","v":"' + ThreePrizeRate + '"}]'; // 奖项json
    var obj = eval('(' + data + ')');
    var result = randomnum(1, 100); // 获取2个值之间的随机数
    var line = 0;
    var temp = 0;
    var returnobj = "0";
    var index = 0;

    //alert("随机数"+result);
    for (var i = 0; i < obj.length; i++) {
        var obj2 = obj[i];
        /*parseFloat(string)该函数指定字符串中的首个字符是否是数字
        parseFloat 是全局函数，不属于任何对象。
        parseFloat 将它的字符串参数解析成为浮点数并返回。如果在解析过程中遇到了正负号（+ 或 -）、数字 (0-9)、小数点，
        或者科学记数法中的指数（e 或 E）以外的字符，则它会忽略该字符以及之后的所有字符，返回当前已经解析到的浮点数。
        同时参数字符串首位的空白符会被忽略。
        如果参数字符串的第一个字符不能被解析成为数字，则 parseFloat 返回 NaN。
        提示：您可以通过调用 isNaN 函数来判断 parseFloat 的返回结果是否是 NaN。如果让 NaN 作为了任意数学运算的操作数，
        则运算结果必定也是 NaN.*/
        var c = parseFloat(obj2.v); //获取当前obj[i]中的v的值
        temp = temp + c;
        line = 100 - temp;
        if (c != 0) {
            if (result > line && result <= (line + c)) {
                index = i;
                //alert(i+"中奖"+line+"<result"+"<="+(line + c));
                returnobj = obj2;
                break;
            }
        }
    }
    var angle = 330;
    var message = "";
    var myreturn = new Object;
    if (returnobj != "0") {// 有奖
        message = "恭喜中奖了:";
        var angle0 = [344, 373];
        var angle1 = [226, 256];
        var angle2 = [109, 136];
        switch (index) {
            case 0: // 一等奖
                var r0 = randomnum(angle0[0], angle0[1]);
                angle = r0;
                break;
            case 1: // 二等奖
                var r1 = randomnum(angle1[0], angle1[1]);
                angle = r1;
                break;
            case 2: // 三等奖
                var r2 = randomnum(angle2[0], angle2[1]);
                angle = r2;
                break;
        }
        myreturn.prize = returnobj.prize;
    } else {// 没有
        message = "再接再厉";
        var angle3 = [17, 103];
        var angle4 = [197, 220];
        var angle5 = [259, 340];
        var r = randomnum(3, 5);
        var angle;
        switch (r) {
            case 3:
                var r3 = randomnum(angle3[0], angle3[1]);
                angle = r3;
                break;
            case 4:
                var r4 = randomnum(angle4[0], angle4[1]);
                angle = r4;
                break;
            case 5:
                var r5 = randomnum(angle5[0], angle5[1]);
                angle = r5;
                break;
        }
        myreturn.prize = "继续努力!";

    }
    myreturn.angle = angle;
    myreturn.message = message;
    return myreturn;
}