package imis

import iwill.*
import grails.converters.*
import java.io.File

class TestController extends BaseController {

    def index() { 
        redirect(action: "page1")
    }

    def test() {
        def job = new Job()
        job.disableRandomIndex()
        job.deleteRandomIndex()
        render "hello"
    }




    // Welcome to Grails
    def welcome() {
    }

    def sample1() {
    
    }

    def sample2() {
    
    }

    def ng() {
    
    }



    def map() {
        // google map test
        def store = []
        def sql = _.sql
        def s = """
            -- 点交付款别 有問題 沒有訂金欄位
            -- 今天的所有交易(賣出的跟客人退貨的). 不包含補登的
            select S_NO, SL_DATE, SL_AMT
            into #transaction
            from SALE_H
            where SL_DATE = convert(char, GETDATE(), 112) and SL_SOURCE = 1
            union all
            -- 今天客訂的訂金部分 (PP提出 CL注銷 CO結案) 有下過單就算
            select S_NO, SL_DATE, IWILL_PAY_CASH_OLD + IWILL_PAY_CARD_OLD + IWILL_PAY_3_OLD + IWILL_PAY_4_OLD + IWILL_PAY_5_OLD + IWILL_PAY_6_OLD + IWILL_PAY_7_OLD + IWILL_PAY_8_OLD + IWILL_PAY_9_OLD + IWILL_PAY_10_OLD + IWILL_PAY_11_OLD + IWILL_PAY_12_OLD
            from SALE_ORDER_H
            where IWILL_PP_DATE = convert(char, GETDATE(), 112) and FLS_NO in ('PP', 'CL', 'CO')
            union all
            -- 今天客訂取貨的尾款部分 (CO結案)
            select S_NO, UPD_DATE, PAY_CASH - IWILL_PAY_CASH_OLD + PAY_CARD - IWILL_PAY_CARD_OLD
            + PAY_3 - IWILL_PAY_3_OLD + PAY_4 - IWILL_PAY_4_OLD
            + PAY_5 - IWILL_PAY_5_OLD + PAY_6 - IWILL_PAY_6_OLD
            + PAY_7 - IWILL_PAY_7_OLD + PAY_8 - IWILL_PAY_8_OLD
            + PAY_9 - IWILL_PAY_9_OLD + PAY_10 - IWILL_PAY_10_OLD
            + PAY_11 - IWILL_PAY_11_OLD + PAY_12 - IWILL_PAY_12_OLD
            from SALE_ORDER_H 
            where UPD_DATE = convert(char, GETDATE(), 112) and FLS_NO in ('CO')
            union all
            -- 扣除今天客訂取消的訂金部分 (CL注銷)
            select S_NO, UPD_DATE, SL_AMT * - 1
            from SALE_ORDER_H
            where UPD_DATE = convert(char, GETDATE(), 112) and FLS_NO in ('CL')
            union all
            -- 异常阳光卡.
            select S_NO, SL_DATE, AMT * QTY
            from (
                select CARD_NO, SL_DATE, S_NO, AMT, case when isnull(QTY,0) = 0 then 1 else QTY end as QTY
                from SALE_CARD 
                where CARD_NO in (select GT_NO from IWILL.dbo.GIFT_TOKEN where not IC_PCT = 100)
                and SL_DATE = convert(char, GETDATE(), 112)
                union all
                select soc.CARD_NO, soc.SL_DATE, soc.S_NO, soc.AMT, case when isnull(soc.QTY,0) = 0 then 1 else soc.QTY end as QTY
                from SALE_ORDER_CARD soc
                left join SALE_ORDER_H sh on sh.SL_KEY = soc.SL_KEY and sh.S_NO = soc.S_NO and sh.SL_DATE = soc.SL_DATE
                where sh.FLS_NO in('CL','PP','AP')
                and soc.CARD_NO in (select GT_NO from IWILL.dbo.GIFT_TOKEN where not IC_PCT = 100)
                and soc.SL_DATE = convert(char, GETDATE(), 112)
                union all
                select IC_NO, CRE_DATE as SL_DATE, S_NO, ADD_AMT * -1 as AMT, 1 as QTY
                from IC_GIFT_RECHARGE
                where RE_TYPE = '3'
                and IC_NO in (select GT_NO from IWILL.dbo.GIFT_TOKEN where not IC_PCT = 100)
                and CRE_DATE = convert(char, GETDATE(), 112)
            ) temp where CARD_NO in (select GT_NO from IWILL.dbo.GIFT_TOKEN where not IC_PCT = 100)
            and SL_DATE = convert(char, GETDATE(), 112)
            -- group
            select S_NO, SL_DATE, SUM(SL_AMT) as AMT
            into #today_sale
            from #transaction
            group by S_NO, SL_DATE
            
            -- join with map data
            SELECT a.S_NO, a.S_NAME, a.S_ADDR, b.lat, b.lng, ISNULL(c.AMT, 0) AS AMT
            FROM STORE a
            LEFT JOIN iwill_store b ON a.S_NO = b.s_no
            LEFT JOIN #today_sale c ON a.S_NO = c.S_NO
            WHERE NOT (b.lat IS NULL OR b.lng IS NULL OR b.lat = 0 OR b.lng = 0)
        """
        sql.eachRow(s, []) {
            store << it.toRowResult()
        }

        ['store': store as JSON]
    }


    def d3() {
 
    }

    def d3_1() {
        def result = [:]
        def sql = _.sql
        def s = """
            -- 定義分類
            SELECT P_NO, P_NAME, P_DEF2, P_PRICE
            , CASE 
            WHEN D_NO IN ('1611', '1612', '1613', '1614', '1615') THEN '面包' 
            WHEN D_NO IN ('1801', '1802', '1803', '1804', '1805', '1806', '1807', '1808') THEN '现烤' 
            WHEN D_NO IN ('1616', '1617', '1635', '1618', '1619', '1620') THEN '蛋糕.西点'
            WHEN D_NO IN ('1621', '1622', '1623', '1624', '1625', '1626', '1627', '1628', '1629', '1630', '1631', '1632', '1633', '1634', '1640', '1641', '1642', '1643', '1644', '1645', '1646', '1647', '1648', '1641', '1642', '1643', '1644', '1645', '1646', '1647', '1648') THEN '生日蛋糕'
            WHEN D_NO IN ('1636', '1638') THEN '喜慶禮盒'
            WHEN D_NO IN ('8001', '8002', '8003', '8004') THEN '券'
            WHEN D_NO IN ('1901', '1902', '1903', '1904', '1905') THEN '水吧'
            WHEN D_NO IN ('1302') THEN '代销品'
            WHEN D_NO IN ('8013', '9013', '9113', '8014', '9014', '9114', '8015', '9015', '9115', '8016', '9016', '9116', '8017', '9017', '9117', '8018', '9018', '9118', '8019', '9019', '9119') THEN '节庆礼盒'
            WHEN D_NO IN ('1652') THEN '杯子蛋糕'
            ELSE '其他' END AS CATEGORY
            INTO #part
            FROM PART
            -- select 1st time
            SELECT a.SL_PRICE, LEFT(b.SL_TIME, 2) AS SL_HOURS, c.CATEGORY
            INTO #aa
            FROM SALE_D a
            LEFT JOIN SALE_H b ON a.SL_KEY = b.SL_KEY
            LEFT JOIN #part c ON a.P_NO = c.P_NO
            WHERE 1 = 1
            AND b.SL_DATE >= ?
            AND b.SL_DATE <= ?
            -- select 2nd time
            SELECT SUM(SL_PRICE) AS SL_PRICE, SL_HOURS + ':00' AS SL_HOURS, CATEGORY
            INTO #bb
            FROM #aa
            WHERE SL_HOURS <> '00'
            GROUP BY SL_HOURS, CATEGORY
            ORDER BY SL_HOURS, CATEGORY
            -- select 3rd time
            SELECT a.*, b.*, ISNULL(c.SL_PRICE, 0) AS SL_PRICE
            FROM (SELECT DISTINCT SL_HOURS FROM #bb) a
            FULL JOIN (SELECT DISTINCT CATEGORY FROM #bb) b ON 1 = 1
            LEFT JOIN #bb c ON a.SL_HOURS = c.SL_HOURS AND b.CATEGORY = c.CATEGORY
            ORDER BY a.SL_HOURS, b.CATEGORY
        """
        sql.eachRow(s, [params.dates, params.datee]) {
            if (!result[it.CATEGORY]) {
                result[it.CATEGORY] = ['key': it.CATEGORY, values: []]
            }
            result[it.CATEGORY]['values'] << ['x': it.SL_HOURS, 'y': it.SL_PRICE]
        }
        render (contentType: 'text/json') {['result': result.values().asList()]} 
    }
    
    def d3_1x() {
        def result = []
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].each {
            def foo = [:]
            foo.key = '类别' + it
            foo.values = []
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each { itt ->
                foo.values.push(['x': 'X' + itt, 'y': it * itt])
            }
            result.push(foo)
        }

        render (contentType: 'text/json') {['result': result]} 
    }

    def img() {
    
    
    }


    def weather() {
        def job = new Job()
        job.getAndSaveBaiduWeather() 
        println '123'
        render "123"
    }


    def exchange() {
        if (params.act == '验证') {
            def sql = _.sql
            def s = """
                select * from GIFT_TOKEN where vid = ?
            """
            def row = sql.firstRow(s, [params.code])
            if (row) {            
                flash.code = params.code
                flash.step = 2
            } else {
                flash.msg = '无效的验证码！'
            }
            redirect(action: 'exchange')
        } else if (params.act == '兑换') {
            def sql = _.sql
            def s = "update GIFT_TOKEN set vid = '' where vid = ?"
            sql.execute(s, [params.code])
            flash.step = 3
            redirect(action: 'exchange')
        }

    }

}


