package imis

import iwill.*

class TicketController {

    def index() { }


    def i2014NewYear() {
    }

    def i2014NewYear_check() {
        def result = ['tid': params.tid, 'tno': params.tno?.trim(), 'status': '无此券号', 'classname': 'error']
        def barcode = Iwill.i2014NewYear_digit2barcode(result.tno)
        if (barcode == null) {
            result['status'] = "验证码错误!!" // digit 换不回去 barcode
        } else {
            def sql = _.sql
            def s = """
                SELECT a.GT_NO, b.S_NAME, a.BACK_DATE, a.BACK_NUM, c.P_NAME
                FROM GIFT_TOKEN a
                LEFT JOIN STORE b ON a.BACK_SNO = b.S_NO
                LEFT JOIN PART c ON a.GI_P_NO = c.P_NO
                WHERE a.GT_NO = ?
            """
            def row = sql.firstRow(s, [barcode])
            if (!row) {
                result['status'] = "验证码错误!!(" + barcode + ")" // barcode 没系统入库
            } else if (row.BACK_NUM > 0) {
                result['status'] = row.P_NAME + " 券号: " + row.GT_NO + ", 于 " + _.date2String(_.string2Date(row.BACK_DATE), 'yyyy/MM/dd') + " 在 " +  row.S_NAME + " 已经提领"
            } else if (row.BACK_NUM == 0) {
                result['status'] = row.P_NAME + " 券号: " + row.GT_NO
                result['classname'] = 'success'
            } else {
                result['status'] = "Huh!!??"
            }
        }
        render (contentType: 'text/json') {result}
 
    }

}
