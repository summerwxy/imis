package iwill

class Iwill {

    static long2DateString(long lng, format='yyMMdd HHmm') {
        def cal = Calendar.getInstance()
        cal.setTimeInMillis(lng)
        return date2String(cal.getTime(), format)
    }

    // 不要修改, 只能用 0~8 当 key
    static _i2014_TICKET_MAP = ['1': '90140005', '2': '90140001', '3': '90140002']
    static _i2014_seed = 97 // u can't change this, after digit generated

    static i2014NewYear_digit2barcode(digit) {
        // digit size = 6
        if (digit?.size() != 6) {
            return null
        }
        // 排序改回来
        def ttl = digit[0].toLong()
        def len = digit.size() - 1
        def i = ttl % len
        def barcode = (i == 0) ? digit[1..len] : digit[len-i+1..len] + digit[1..len-i]
        // 根据 seed 换回数字
        barcode = barcode[0..2].toLong() * Iwill._i2014_seed + barcode[3..4].toLong() as String
        // check map
        def ino = Iwill._i2014_TICKET_MAP[barcode[0]]
        if (!ino) {
            return null
        }
        barcode = barcode.padLeft(5, '0')
        barcode = ino + barcode[1..len-1].padLeft(8, '0')
        return barcode
    }

    static i2014NewYear_barcode2digit(barcode) {
        // barcode size = 16
        if (barcode?.size() != 16) {
            return null
        } 
        // 前 8 码换代号
        def digit = Iwill._i2014_TICKET_MAP.find{ it.value == barcode[0..7] }?.key
        if (digit) {
            // 后 4 码取流水号
            digit += barcode[-4..-1]
            // 根据 seed 换成其他数字 
            digit = ((digit.toLong() / Iwill._i2014_seed as long) as String).padLeft(3, '0') + (digit.toLong() % Iwill._i2014_seed as String).padLeft(2, '0')
            def ttl = 0
            digit.eachWithIndex { it, i -> ttl += it.toLong() * (i + 1) }
            ttl = ttl % 9 // 简单的做验证码
            def len = digit.size()
            def i = ttl % len
            digit = digit.toString()
            // 加上验证码 与 排顺序
            digit = (i == 0) ? ttl + digit[i..len-1] : ttl + digit[i..len-1] + digit[0..i-1]
        }
        return digit 
    }

    static myStore(request, sql, isDev=false) {
        // 从 ip 找 门店 资料
        def re = /^(172\.16\.\d+)\.\d+$/
        def finder = request.remoteAddr =~ re
        def s_no = ''
        def s_name = ''
        if (finder.count == 1) {
            def s = "select S_NO, S_NAME from STORE where S_IP like '" + finder[0][1] + ".%'"
            def row = sql.firstRow(s)
            s_no = row.S_NO
            s_name = row.S_NAME
        }    
        if (isDev || request.remoteAddr == '0:0:0:0:0:0:0:1' || request.remoteAddr.startsWith('192.168.')) {
            s_no = '802A001' // 8027010 平江店 8021001 中山店 
            s_name = '平江店'
        }
        return [s_no: s_no, s_name: s_name]
    }


}

