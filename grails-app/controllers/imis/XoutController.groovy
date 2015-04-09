package imis

import iwill.*
import grails.converters.*
import org.codehaus.groovy.grails.plugins.qrcode.*

class XoutController {

    def index() { }


    def page1() {
        def today = _.date2String(new Date(), 'yyyy/MM/dd')
        def drivers = []
        def sql = _.sql
        def s = "select id, name, phone from iwill_data1 where enable = 1 order by name"
        sql.eachRow(s, []) {
            drivers << it.toRowResult()
        }
        ['today': today, 'drivers': drivers as JSON, 'zone': page1_zone]
    }

    def page1_zone = ['相城区', '工业园区', '金阊区', '平江区', '沧浪区', '虎丘区', '吴中区', '吴江区', '昆山市', '张家港市', '常熟市', '太仓市', '无锡市']

    def page1_load() {
        def data = ['h': [], 'b': [:]]
        def sql = _.sql
        def st = []
        if (params.st1 == 'true') { st << '送货上门' }
        if (params.st2 == 'true') { st << '门店自取' }
        def ot = []
        if (params.ot1 == 'true') { ot << '生日蛋糕' }
        if (params.ot2 == 'true') { ot << '零散订单' }
        if (params.ot3 == 'true') { ot << '券卡订单' }
        if (params.ot4 == 'true') { ot << '节庆订单' }

        def zn = params['zn[]']
        if (zn instanceof String) {
            zn = zn
        } else if (zn == null) {
            zn = ''
        } else {
            zn = zn.join("', '")
        }

        def s = """
            -- HEAD
            SELECT FBillNo AS SHIP_NO
            , CONVERT(CHAR, c.FHeadSelfB0161, 111) AS TAKE_DATE
            , CONVERT(CHAR, c.FHeadSelfB0161, 108) AS TAKE_TIME
            , d.FName AS STORE
            , c.FHeadSelfB0160 AS CONTACT
            , c.FHeadSelfB0158 AS PHONE
            , c.FHeadSelfB0156 AS ADDR
            , c.FExplanation AS REMARK
            , DATEDIFF(ss, GETDATE(), c.FHeadSelfB0161) AS TAKE_DIFF
            , c.FInterID
            , t1293.FName AS ORDER_TYPE
            , c.FHeadSelfB0154 AS POS_NO
            , c.FHeadSelfB0157 AS MOBILE
            , c.FHeadSelfB0159 AS CREATE_TIME 
            , CONVERT(char, c.FDate, 112) AS ORDER_DATE
            , p1.fstatus AS STATUS, ISNULL(p1.fdata1id, 0) AS DID, d1.name AS DNAME, d1.phone AS DPHONE, ISNULL(p1.fzone, '') AS ZONE
            , t055.FName AS SHIP_TYPE
            FROM AIS20121019100529..ICStockBill c
            LEFT JOIN AIS20121019100529..t_Organization d ON c.FSupplyID = d.FItemID AND d.FItemID <> 0
            LEFT JOIN AIS20121019100529..t_SubMessage t055 ON c.FHeadSelfB0163 = t055.FInterID AND t055.FInterID <> 0
            LEFT JOIN AIS20121019100529..t_SubMessage t003 ON c.FSaleStyle = t003.FInterID AND t003.FInterID <> 0
            LEFT OUTER JOIN AIS20121019100529..t_Emp t106 ON c.FEmpID = t106.FItemID AND t106.FItemID <> 0
            LEFT OUTER JOIN AIS20121019100529..t_SubMessage t1293 ON c.FHeadSelfB0164 = t1293.FInterID AND t1293.FInterID <> 0
            LEFT JOIN iwill..iwill_xout_page1 p1 ON c.FInterID = p1.finterid
            LEFT JOIN iwill..iwill_data1 d1 ON p1.fdata1id = d1.id
            WHERE c.FTranType = 21  -- 銷售出貨單: 21
            AND c.FSelTranType in (81, 21, 82) -- 源單類型: 81 銷售訂單(出货的), 21 销售出库(退货的), 82 退货通知单
            AND NOT (c.FROB = -1 AND c.FHeadSelfB0154 <> '') -- 退單, 且有 POS 編號的 不要列入計算
            AND c.FCheckerID <> 0
            AND c.FCancellation = 0 -- 不含作废
            AND ISNULL(t055.FName, '') in ('${st.join("', '")}') -- 送货上门 门店自取
            AND t1293.FName in ('${ot.join("', '")}') -- 生日蛋糕 零散订单 券卡订单 节庆订单
            AND ISNULL(p1.fzone, '') in ('${zn}')
            AND CONVERT(CHAR, c.FHeadSelfB0161, 111) = ?
            ORDER BY c.FHeadSelfB0161, FBillNo
        """
        sql.eachRow(s, [params.day]) {
            data['h'] << it.toRowResult()
        }        

        s = """
            -- BODY
            SELECT b.FNumber, b.FName, b.FSalePrice, t3.FName AS Unit, a.FQty, a.FInterID
            FROM AIS20121019100529.dbo.ICStockBillEntry a
            LEFT JOIN AIS20121019100529.dbo.t_ICItem b ON a.FItemID = b.FItemID AND b.FItemID <> 0
            LEFT JOIN AIS20121019100529.dbo.ICStockBill c ON a.FInterID = c.FInterID AND c.FInterID <> 0
            LEFT JOIN AIS20121019100529.dbo.t_MeasureUnit t3 ON b.FUnitID = t3.FMeasureUnitID
            LEFT JOIN AIS20121019100529..t_SubMessage t055 ON c.FHeadSelfB0163 = t055.FInterID AND t055.FInterID <> 0
            WHERE 1 = 1
            AND c.FTranType = 21  -- 銷售出貨單: 21
            AND c.FSelTranType IN (81, 21, 82) -- 源單類型: 81 銷售訂單(出货的), 21 销售出库(退货的), 82 退货通知单
            AND NOT (c.FROB = -1 AND c.FHeadSelfB0154 <> '') -- 退單, 且有 POS 編號的 不要列入計算
            AND c.FCheckerID <> 0
            AND c.FCancellation = 0 ----不含作废
            AND ISNULL(t055.FName, '') in ('送货上门', '门店自取')
            AND CONVERT(CHAR, c.FHeadSelfB0161, 111) = ?
        """
        sql.eachRow(s, [params.day]) {
            def foo = it.toRowResult()
            if (data['b'][foo.FInterID] == null) {
                data['b'][foo.FInterID] = []
            }
            data['b'][foo.FInterID] << foo
        }
        render (contentType: 'text/json') {data}
    }

    def page1_change_status() {
        def row = IwillXoutPage1.findByFinterid(params.id)
        if (!row) {
            def qq = new IwillXoutPage1(finterid: params.id, fdata1id: 0, fstatus: '', fzone: '')
            qq.fstatus = '' // 很奇怪, 上面那行會出錯, 值變成 null
            qq.fzone = ''
            if (!qq.save()) {
                qq.errors.allErrors.each {
                    println '-----'
                    println it
                    println '-----'
                }
            }
        }
        row = IwillXoutPage1.findByFinterid(params.id)
        row.fstatus = params.status
        row.save()
        render (contentType: 'text/json') {['status': params.status, 'id': params.id]}
    }

    def page1_change_driver() {
        def row = IwillXoutPage1.findByFinterid(params.id)
        if (!row) {
            def qq = new IwillXoutPage1(finterid: params.id, fdata1id: 0, fstatus: '', fzone: '')
            qq.fstatus = ''
            qq.fzone = ''
            if (!qq.save()) {
                qq.errors.allErrors.each {
                    println '-----'
                    println it
                    println '-----'
                }
            }
        }
        row = IwillXoutPage1.findByFinterid(params.id)
        row.fdata1id = params.driver.toFloat()
        row.save()
        render (contentType: 'text/json') {['driver': params.driver, 'id': params.id]}
    }

    def page1_change_zone() {
        def row = IwillXoutPage1.findByFinterid(params.id)
        if (!row) {
            def qq = new IwillXoutPage1(finterid: params.id, fdata1id: 0, fstatus: '', fzone: '')
            qq.fstatus = ''
            qq.fzone = ''
            if (!qq.save()) {
                qq.errors.allErrors.each {
                    println '-----'
                    println it
                    println '-----'
                }
            }
        }
        row = IwillXoutPage1.findByFinterid(params.id)
        row.fzone = params.zone
        row.save()
        render (contentType: 'text/json') {['zone': params.zone, 'id': params.id]}
    }


    def page2() {
        def url = ''
        def shipDate = params.shipDate ?: _.today('yyyy/MM/dd')
        def sql = _.sql
        def orderTypes = []
        def s = """
            SELECT FInterID AS FId, FName FROM AIS20121019100529.dbo.t_SubMessage WHERE FParentID = 10010 ORDER BY FID
        """
        sql.eachRow(s, []) {
            orderTypes << it.toRowResult()
        }
        def oUrl = ''
        if (params.q) {
            url = grailsApplication.config.myBaseUrl + servletContext.contextPath
            url = url + "/xout/page2_items?shipDate=${params.shipDate}&orderType=${params.orderType}"
            oUrl = url
            url = java.net.URLEncoder.encode(url)
        }

        [shipDate: shipDate, orderTypes: orderTypes, url: url, oUrl: oUrl]
    }


    def page2_items() {
        def sql = _.sql
        def result = [:]
        def items = []
        def s = """
            SELECT c.Fname, b.FQty, b.FUnitName, b.FItemNO, b.FItemName
            -- a.FBillNO, c.FNumber, c.Fname, a.FDate, b.FItemNO, b.FItemName, b.Fmodel
            -- , b.FUnitName, b.FQty, b.FOrderTypeName, b.FOrderBillNo ,b.FOrderTypeID
            From K3ERPtoBarCode..ICStockBill_21 a, K3ERPtoBarCode..ICStockBillEntry_21 b, K3ERPtoBarCode..t_Organization c 
            Where a.Fdate = ?
            and b.FOrderTypeID = ?
            and a.FInterID = b.FInterID 
            and a.Fcheck = 'Y' 
            and a.Fcancellation != 'Y' 
            and a.FSupplyID = c.FItemID 
            order by b.FItemNO asc, c.Fname asc
        """
        sql.eachRow(s, [params.shipDate, params.orderType]) {
            if (result[it.FItemNO] == null) {
                result[it.FItemNO] = []
            }
            result[it.FItemNO] << it.toRowResult()
            items << [it.FItemNo, it.FItemName]
        }

        items = items.unique()


        [result: result, items: items]
    }
}
