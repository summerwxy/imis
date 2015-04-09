package imis

import iwill.*

class HrController {

    def index() { }


    def page1() {
        def list = []
        def msg = ''
        if (params.op_no && params.sDate && params.eDate) {
            def sql = _.sql
            def s = """
                SELECT b.OP_NO, b.OP_NAME, c.S_NAME
                , CASE WHEN a.DUT_DATE_ON = '' THEN a.DUT_DATE_OFF ELSE a.DUT_DATE_ON END AS DUT_DATE
                , CASE WHEN a.DUT_DATE_ON = '' THEN a.DUT_TIME_OFF ELSE a.DUT_TIME_ON END AS DUT_TIME
                , CASE WHEN a.DUT_DATE_ON = '' THEN 'off' ELSE 'on' END AS DUT_TYPE
                INTO #aa
                FROM DUTY a
                LEFT JOIN CASHIER b ON a.ST_KEY = b.OP_NO
                LEFT JOIN STORE c ON a.S_NO = c.S_NO
                WHERE ST_KEY = ?

                SELECT * 
                FROM #aa
                WHERE DUT_DATE >= ? AND DUT_DATE <= ?
                ORDER BY DUT_DATE, DUT_TIME, DUT_TYPE DESC
            """
            def sDate = _.date2String(_.string2Date(params.sDate, 'yyyy/MM/dd'), 'yyyyMMdd')
            def eDate = _.date2String(_.string2Date(params.eDate, 'yyyy/MM/dd'), 'yyyyMMdd')
            sql.eachRow(s, [params.op_no, sDate, eDate]) { 
                list << it.toRowResult()
            } 
        } 

        if (params.sync) {
            def sql = _.sql
            def s = """
                exec IWILL_POS_DUTY_TO_HR -1
                exec IWILL_POS_DUTY_TO_HR -2
                exec IWILL_POS_DUTY_TO_HR -3
                exec IWILL_POS_DUTY_TO_HR -4
                exec IWILL_POS_DUTY_TO_HR -5
                exec IWILL_POS_DUTY_TO_HR -6
                exec IWILL_POS_DUTY_TO_HR -7
                exec IWILL_POS_DUTY_TO_HR -8
                exec IWILL_POS_DUTY_TO_HR -9
                exec IWILL_POS_DUTY_TO_HR -10
                exec IWILL_POS_DUTY_TO_HR -11
                exec IWILL_POS_DUTY_TO_HR -12
                exec IWILL_POS_DUTY_TO_HR -13
                exec IWILL_POS_DUTY_TO_HR -14
                exec IWILL_POS_DUTY_TO_HR -15
                exec IWILL_POS_DUTY_TO_HR -16
                exec IWILL_POS_DUTY_TO_HR -17
                exec IWILL_POS_DUTY_TO_HR -18
                exec IWILL_POS_DUTY_TO_HR -19
                exec IWILL_POS_DUTY_TO_HR -20
                exec IWILL_POS_DUTY_TO_HR -21
                exec IWILL_POS_DUTY_TO_HR -22
                exec IWILL_POS_DUTY_TO_HR -23
                exec IWILL_POS_DUTY_TO_HR -24
                exec IWILL_POS_DUTY_TO_HR -25
                exec IWILL_POS_DUTY_TO_HR -26
                exec IWILL_POS_DUTY_TO_HR -27
                exec IWILL_POS_DUTY_TO_HR -28
                exec IWILL_POS_DUTY_TO_HR -29
                exec IWILL_POS_DUTY_TO_HR -30
                exec IWILL_POS_DUTY_TO_HR -31
                exec IWILL_POS_DUTY_TO_HR -32
                exec IWILL_POS_DUTY_TO_HR -33
                exec IWILL_POS_DUTY_TO_HR -34
                exec IWILL_POS_DUTY_TO_HR -35
                exec IWILL_POS_DUTY_TO_HR -36
                exec IWILL_POS_DUTY_TO_HR -37
                exec IWILL_POS_DUTY_TO_HR -38
                exec IWILL_POS_DUTY_TO_HR -39
                exec IWILL_POS_DUTY_TO_HR -40
                exec IWILL_POS_DUTY_TO_HR -41
                exec IWILL_POS_DUTY_TO_HR -42
                exec IWILL_POS_DUTY_TO_HR -43
                exec IWILL_POS_DUTY_TO_HR -44
                exec IWILL_POS_DUTY_TO_HR -45
                exec IWILL_POS_DUTY_TO_HR -46
                exec IWILL_POS_DUTY_TO_HR -47
                exec IWILL_POS_DUTY_TO_HR -48
                exec IWILL_POS_DUTY_TO_HR -49
                exec IWILL_POS_DUTY_TO_HR -50
                exec IWILL_POS_DUTY_TO_HR -51
                exec IWILL_POS_DUTY_TO_HR -52
                exec IWILL_POS_DUTY_TO_HR -53
                exec IWILL_POS_DUTY_TO_HR -54
                exec IWILL_POS_DUTY_TO_HR -55
                exec IWILL_POS_DUTY_TO_HR -56
                exec IWILL_POS_DUTY_TO_HR -57
                exec IWILL_POS_DUTY_TO_HR -58
                exec IWILL_POS_DUTY_TO_HR -59
                exec IWILL_POS_DUTY_TO_HR -60
            """
            sql.execute(s, [])
            msg = '同步成功!'
        }
        [list: list, msg: msg]
    }
}
