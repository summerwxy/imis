package imis

import iwill.*
@Grab(group='commons-net', module='commons-net', version='3.3')
import org.apache.commons.net.ftp.FTPClient
import jxl.*
import jxl.write.*

class PosController extends BaseController {

    def index() {
        redirect(action: "ann_pos")
    }


    // 礼券回收检查
    def f1() {}
    def f1_g3() {}
    

    def f1_check() {
        def result = ['tid': params.tid, 'tno': params.tno, 'status': '无此券号', 'classname': 'error', 'sname': '', 'date': '']
        def sql = _.sql
        def s = """
            SELECT a.GT_NO, a.BACK_NUM, a.BACK_SNO, a.BACK_DATE, ISNULL(B.S_NAME, '') AS S_NAME
            FROM GIFT_TOKEN a
            LEFT JOIN STORE b ON a.BACK_SNO = b.S_NO
            WHERE a.GT_NO = ?
        """
        def row = sql.firstRow(s, [params.tno])
        if (row) {
            result['status'] = row.BACK_NUM > 0 ? '已回收' : '未回收'
            result['classname'] = row.BACK_NUM > 0 ? 'success' : 'error'
            result['sname'] = row.S_NAME
            result['date'] = row.BACK_DATE
        }
        // 有此券, 未回收, 而要更新
        if (row && row.BACK_NUM == 0 && params.is_update == '1') {
            s = "UPDATE GIFT_TOKEN SET BACK_NUM = 1, BACK_SNO = '0000000', BACK_DATE = CONVERT(CHAR, GETDATE(), 112) WHERE GT_NO = ?"
            sql.execute(s, [params.tno])
            result['status'] = '未回收-已处理'
            result['classname'] = 'warning'
        }
        render (contentType: 'text/json') {result}
    }

    // store
    def store() {}

    def store_query() {
        def result = Filter.storeByKeyword(Dao.getStore(), params.q.toLowerCase())
        render (contentType: 'text/json') {result}
    }
    // part
    def part() {}

    def part_query() {
        def result = []
        if (params.w == 'part') {
            result = Filter.partByKeyword(Dao.getPart(), _.tc2sc(params.q).toLowerCase())
        } else if (params.w == 'pda') {
            result = Filter.partByPdaFail(Dao.getPart())

        }
        render (contentType: 'text/json') {result}         
    }
    // 6L
    def pos_6l() {}
    // 1V
    def pos_1v() {
        def q = ['11MU000001': ['11PM000007', '11PM000017', '12PM000004', '12PM000006', '12PM000008', '12PM000010', '12PM000025', '12PM000027', '12PM000028', '12PM000030', '12PM000039', '12PM000044', '12PM000045', '12PM000046', '12PM000047', '13PM000001', '13PM000002', '13PM000003', '13PM000004', '13PM000006']
            , '11MU000003': ['12PM000025', '12PM000028', '12PM000044', '12PM000046', '12PM000047', '13PM000001', '13PM000007']]
        def list = []
        def sql = _.sql
        def s = ''

        q.each { k, v ->
            def data = [:]
            // line1
            s = "SELECT * FROM PART_MENU_H WHERE MU_NO = ?"  
            def row = sql.firstRow(s, [k])
            data['line1'] = row.MU_NO + ' ' + row.MU_NAME
            // line2
            s = """
                SELECT a.PM_NO, a.PM_NAME, CASE WHEN b.PM_NO IS NULL THEN 'X' ELSE 'O' END AS MARK
                FROM PartM_H a
                LEFT JOIN PartM_H b ON a.PM_NO = b.PM_NO AND b.PM_NO IN ('${v.join("', '")}')
            """
            def temp = []
            sql.eachRow(s, []) { r ->
                temp << r.PM_NO + ' ' + r.PM_NAME + ' ' + r.MARK
            }
            data['line2'] = temp.join(" / ") 
            // data
            s = """
                SELECT b.PM_NO, b.PM_NAME, d.P_NO, d.P_NAME
                FROM PartM_D a 
                LEFT JOIN PartM_H b ON a.PM_NO = b.PM_NO AND b.PM_NO IN ('${v.join("', '")}')
                LEFT JOIN PART_MENU_DD c ON a.P_NO = c.DD_NO AND MU_NO = ?
                LEFT JOIN PART d ON a.P_NO = d.P_NO
                WHERE b.FLS_NO = 'CO' AND c.DD_NO IS NULL
                ORDER BY a.P_NO
            """
            def tbl = []
            sql.eachRow(s, [k]) {
                tbl << it.toRowResult()
            }   
            data['table'] = tbl
            list << data
        } 
        return ['list': list]  
    }
    // 门店营业模式设定
    def f2() {}

    // 上传广告图片
    def adimg() {
        def list = []
        def sql = _.sql
        def s = """
            SELECT a.s_no, b.S_NAME, a.ip
            FROM IWILL_STORE a
            LEFT JOIN STORE b ON a.s_no = b.S_NO
            WHERE a.custom_view = 1
            ORDER BY a.s_no
        """
        sql.eachRow(s, []) {
            def foo = it.toRowResult()
            foo.ip.tokenize('/').each { sip ->
                list << ['S_NO': foo.s_no, 'S_NAME': foo.S_NAME, 'ip': sip.trim()]
            } 
        }
        return ['list': list]
    }

    def adimg_upload() {
        def f = request.getFile('file')
        if (f.empty) { // 依照 ui 不应该发生
            render "empty file" 
            return
        }
        // check path and save file
        _.save2UploadDir(f, 'ad', _.uuid() + '.jpg')
        response.sendError(200, 'Done')
    }

    def adimg_getimgs() {
        def list = []
        def files = _.listUploadFolder('ad')
        files.each {
            list << ['name': it.name, 'length': it.length(), 'date': _.formatDate(new Date(it.lastModified()), 'yyyy-MM-dd HH:mm:ss')]
        }
        render (contentType: 'text/json') {list}
    }

    def adimg_del() {
        _.delUploadFile('ad', params.file)

        render (contentType: 'text/json') {['msg': 'OK', 'file': params.file]}
    }

    def adimg_download() {
        def result = [:]
        try {
            def msg = '下载完成'
            // download via ftp
            def ftp = new FTPClient()
            ftp.connect(params.ip)
            if (!ftp.login("iwill", "111")) {
                msg = '异常(登入失败)'
            } else if (!ftp.changeWorkingDirectory("/d/emis/venus/imgs/ad") && !ftp.changeWorkingDirectory("/emis/venus/imgs/ad")) {
                println '---------------'
                println !ftp.changeWorkingDirectory('/d/emis/venus/imgs/ad')
                println !ftp.changeWorkingDirectory('/emis/venus/imgs/ad')
                println !ftp.changeWorkingDirectory("/d/emis/venus/imgs/ad") && !ftp.changeWorkingDirectory("/emis/venus/imgs/ad")
                msg = '异常(路径错误)'
            } else {
                ftp.setFileType(ftp.BINARY_FILE_TYPE);
                ftp.setFileTransferMode(ftp.STREAM_TRANSFER_MODE);

                // remove files
                def files = ftp.listNames()
                files.each {
                    ftp.deleteFile(it)
                }
                // upload files
                files = _.listUploadFolder('ad')
                files.each {
                    it.withInputStream { is -> 
                        if (!ftp.storeFile(it.name, is)) {
                            msg = '异常(下载失败)'
                        }
                    } 
                }
                ftp.disconnect()
            }
            result = ['msg': msg, 'ip': params.ip]
        } catch (Exception ex) {
            result = ['msg': '异常(' + ex.message + ')', 'ip': params.ip]
        }
        render (contentType: 'text/json') {result}
    }

    def ann_url = 'http://192.168.0.45:3000'

    def ann() {
        params.max = 20
        params.sort = 'code'
        params.order = 'desc'

        [list: IwillAnn.list(params), total: IwillAnn.count(), ann_url: ann_url]
    }

    def ann_add() {
        if (params.add) { // 新增
            if (params.code?.trim().length() == 0) {
                flash.error = "编号不可空白!"
            } else if (IwillAnn.findByCode(params.code)) {
                flash.error = "编号重复!"
            } else if (params.title?.trim().length() == 0) {
                flash.error = "标题不可空白!"
            } else {
                def ann = new IwillAnn(params)
                ann.handler = params.handler ?: ''
                ann.url = params.url ?: ''
                if (ann.save()) {
                    flash.message = "新增成功!"
                } else {
                    flash.error = "新增失败!"
                }
            }
            redirect(action: 'ann_add')
            return
        }
        def c = 0
        def result = IwillAnn.executeQuery('select max(code) from IwillAnn')[0]
        if (result) {
            c = result.toInteger()
        }
        c += 1
        [code: c.toString().padLeft(6, "0"), today: _.date2String(new Date(), 'yyyy/MM/dd')]
    }

    def ann_pos() {
        params.max = 20
        params.sort = 'code'
        params.order = 'desc'

        [list: IwillAnn.list(params), total: IwillAnn.count(), ann_url: ann_url]  
    }


    def ann_detail_pos() {
        def ann = IwillAnn.get(params.id)
        def sql = _.sql
        def s = ''
        if (params.signit) {
            // 检查 帐号 密码 有没有对
            s = 'select OP_NAME from CASHIER where OP_NO = ? and OP_PASSWORD = ?'
            def row = sql.firstRow(s, [params.account, params.password])
            if (row) {
                // save sign record
                def annSign = new IwillAnnSign([sNo: params.s_no, opNo: params.account, opName: row.OP_NAME, annId: params.id])
                annSign.save()
                flash.msg = '签名成功!'
            } else {
                flash.msg = '帐号/密码 不正确!'
            }
            flash.sign = 'true'
            redirect(action: 'ann_detail_pos', id: params.id)
            return
        }
        if (!flash.sign) {
            // record ip
            def annLog = new IwillAnnLog([annId: ann.id, ip: request.remoteAddr])
            annLog.save()
        }
        def url = ann_url + "/pages/" + ann.code + ".htm"
        if (ann.pageType == 'url') {
            url = ann.url
        }
        def ms = Iwill.myStore(request, sql) 
        // 找签到记录
        def annSign = IwillAnnSign.findByAnnIdAndSNo(params.id, ms.s_no)

        [url: url, ann: ann, s_no: ms.s_no, s_name: ms.s_name, annSign: annSign]
    }

    def ann_del() {
        def ann = IwillAnn.get(params.id)
        ann.delete()
        // delete record 
        def list = IwillAnnLog.findAllByAnnId(params.id)
        list.each {
            it.delete()
        }
        list = IwillAnnSign.findAllByAnnId(params.id) 
        list.each {
            it.delete()
        }
        redirect(action: 'ann')
    }

    def ann_log() {
        def sql = _.sql
        def s = ''
        // log data
        s = 'SELECT ip, COUNT(*) AS cnt, CONVERT(CHAR, MIN(date_created), 120) AS dt FROM iwill_ann_log WHERE ann_id = ? GROUP BY ip'
        def logs = [:]
        def re = /^(172\.16\.\d+)\.\d+$/
        sql.eachRow(s, [params.id]) {
            def finder = it.ip =~ re
            if (finder.count == 1) {
                def foo = logs[finder[0][1]]
                if (!foo) {
                    foo = [times: 0, date: '9999-99-99 99:99:99']
                    logs[finder[0][1]] = foo
                }
                foo.times += it.cnt
                foo.date = (foo.date < it.dt) ? foo.date : it.dt
            }
        }        
        // store data
        s = """
            SELECT b.R_NAME, a.S_NAME, a.S_TEL, a.S_IP, c.op_name, CONVERT(CHAR, c.date_created, 120) AS dt
            FROM STORE a
            LEFT JOIN REGION b ON a.R_NO = b.R_NO
            LEFT JOIN iwill_ann_sign c ON a.S_NO = c.s_no and ann_id = ?
            WHERE NOT a.R_NO IN ('8041', '8981', '8991', '8992')
            AND a.S_STATUS = 1
            ORDER BY a.S_NO
        """
        def store = []
        sql.eachRow(s, [params.id]) {
            def foo = it.toRowResult()
            def finder = it.S_IP =~ re
            if (finder.count == 1 && logs[finder[0][1]]) {
                foo.times = logs[finder[0][1]].times
                foo.date = logs[finder[0][1]].date
            } else {
                foo.times = 0
                foo.date = ''
            }
            store << foo
        }
        [store: store, ann: IwillAnn.get(params.id)]
    }


    def wheel_pos() {

    }

    def wheel_random() {
        def result = ['prize': '', 'angle': 60] // 60 是不中獎的位置
        // 取亂數
        def ran = Math.random()
        def firstRate = 1 // 1 代表 1% 機率, 0.1 代表 0.1% 機率
        def secondRate = 1
        def thirdRate = 1
        if (ran < (firstRate / 100)) {
            result.prize = '一等奖：双人台湾往返机票'
            int a = (332 + Math.random() * 56) % 360 // 332 ~ 28 之間
            result.angle = a
        } else if (ran < ((firstRate + secondRate) / 100)) {
            result.prize = '二等奖：24cmB价生日蛋糕券一张 '
            int a = 92 + Math.random() * 56 // 92 ~ 148 之間
            result.angle = a
        } else if (ran < ((firstRate + secondRate + thirdRate) / 100)) {
            result.prize = '三等奖：QQ公仔一对'
            int a = 212 + Math.random() * 56 // 212 ~ 268 之間
            result.angle = a
        } else {
            result.prize = '参加奖：10元牛轧糖一盒'
            int a = Math.random() * 56 * 3 // 三個區間的角度
            int x = a / 56 
            int y = a % 56
            // 确保 位置在 指定地方内
            result.angle = x * 120 + 32 + y
            if (!((result.angle >= 30 && result.angle <= 90) 
                || (result.angle >= 150 && result.angle <= 210) 
                || (result.angle >= 270 && result.angle <= 330))) {
                println 'impossible here!!'
                result.angle = 60
            }
        } 
        return result
    }

    def wheel_lottery() {
        def result = ['prize': '不符合参加条件！', 'angle': 60, 'isValid': false] // 60 是不中獎的位置
        // for test
        if (params.type == 'test') {
            def foo = wheel_random()
            result.prize = foo.prize
            result.angle = foo.angle        
        }

        // for lottery
        if (params.type == 'lottery') {
            def sql = _.sql
            def s = ''
            // 檢查有沒有抽獎過
            def wlog = IwillWheelLog.findBySlKey(params.sl_key)
            if (wlog) {
                result.prize = '== 已参加过抽奖 ==\n\n' + wlog.prize
                render (contentType: 'text/json') {result}
                return
            }

            // TODO: change the date
            s = """
                SELECT b.S_NO, d.S_NAME, a.P_NO, c.P_NAME, a.SL_QTY, b.PAY_CASH, b.PAY_10, b.SL_DATE, b.SL_KEY, a.RECNO
                FROM sale_order_d a
                LEFT JOIN sale_order_h b ON a.SL_KEY = b.SL_KEY
                LEFT JOIN part c ON a.P_NO = c.P_NO
                LEFT JOIN store d ON b.S_NO = d.S_NO
                WHERE 1 = 1
                AND b.SL_KEY IN (SELECT SL_KEY FROM sale_order_d WHERE (P_NO LIKE '1403%' OR P_NO LIKE '1636%' OR P_NO LIKE '1638%'))
                AND b.PAY_CASH + b.PAY_10 >= 500
                AND b.SL_DATE >= '20140901' AND b.SL_DATE <= '20141006'
                AND b.SL_KEY = ?
                ORDER BY a.RECNO
            """
            sql.eachRow(s, [params.sl_key]) {
                result.isValid = true
            }
            // 記錄 抽奖结果
            if (result.isValid) {
                def foo = wheel_random()
                result.prize = foo.prize
                result.angle = foo.angle
                def wheelLog = new IwillWheelLog([gameCode: '2014FLY2TW', 'storeIp': request.remoteAddr, 'slKey': params.sl_key, 'prize': result.prize, 'angle': result.angle])
                wheelLog.save(flush: true, failOnError: true)
            }
        }
        render (contentType: 'text/json') {result}
    }


    def refund_pos() {
        def sql = _.sql
        def s = ''
        def ms = Iwill.myStore(request, sql)
        // default date
        def the_day = _.yesterday('yyyy/MM/dd')
        if (params.the_day) {
            the_day = params.the_day 
        }
        if (flash.the_day) {
            the_day = flash.the_day
        }
        def d = _.date2String(_.string2Date(the_day, 'yyyy/MM/dd'))
        if (params.signit && !(flash.sign == 'true')) {
            // 检查 帐号 密码 有没有对
            s = 'select OP_NAME from CASHIER where OP_NO = ? and OP_PASSWORD = ?'
            def row = sql.firstRow(s, [params.account, params.password])
            if (row) {
                // save sign record
                def refundSign = new IwillRefundSign([refundDate: d, sNo: ms.s_no, opNo: params.account, opName: row.OP_NAME])
                refundSign.save()
                flash.msg = '签名成功!'
            } else {
                flash.msg = '帐号/密码 不正确!'
            }
            flash.sign = 'true'
            flash.the_day = the_day
            redirect(action: 'refund_pos')
            return
        }
        // 找签到记录
        def refundSign = IwillRefundSign.findByRefundDateAndSNo(d, ms.s_no)

        // query default data
        def list = []
        s = """
            declare @store varchar(8)
            declare @day0 varchar(10)
            declare @day_1 varchar(10)
            set @store = ?
            set @day0 = CONVERT(varchar, CONVERT(datetime, ?), 112)
            set @day_1 = CONVERT(varchar, DATEADD(d, -1, CONVERT(datetime, @day0)), 112)
            -- 订货
            select a.P_NO, SUM(a.P_QTY) AS PO_QTY into #aa
            from PO_D a left join POR b on a.POR_NO = b.POR_NO and a.S_NO = b.S_NO
            where b.FLS_NO = 'AP' and b.S_NO = @store and b.POR_DATE = @day_1 and a.P_QTY <> 0 group by a.P_NO
            -- 进货
            select a.P_NO, SUM(a.P_QTY) as IN_QTY into #bb
            from INS_D a left join INS_H b on a.IN_NO = b.IN_NO and a.S_NO = b.S_NO
            where b.FLS_NO = 'CO' and b.S_NO = @store and b.UPD_DATE = @day0 group by a.P_NO
            -- 生產入庫
            select a.P_NO, SUM(a.SST_QTY) as SST_QTY into #cc
            from S_STOR_D a left join S_STOR_H b on a.S_NO = b.S_NO and a.SST_NO = b.SST_NO
            where b.FLS_NO = 'CO' and a.S_NO = @store and b.SPK_DATE = @day0 group by a.P_NO
            -- 撥入
            select a.P_NO, SUM(a.TR_OUT_QTY) as TR_OUT_QTY into #dd
            from TRAN_D a left join TRAN_H b on a.TR_NO = b.TR_NO and a.S_NO_OUT = b.S_NO_OUT
            where b.FLS_NO in ('CF', 'CO') and b.S_NO_IN = @store and b.TR_DATE = @day0 group by a.P_NO
            -- 撥出
            select a.P_NO, SUM(a.TR_IN_QTY) as TR_IN_QTY into #ee
            from TRAN_D a left join TRAN_H b on a.TR_NO = b.TR_NO and a.S_NO_OUT = b.S_NO_OUT
            where b.FLS_NO in ('CF', 'CO') and b.S_NO_OUT = @store and b.TR_DATE = @day0 group by a.P_NO
            -- 退貨
            select a.P_NO, SUM(a.P_QTY) as BA_QTY into #ff
            from BACK_D a left join BACK_H b on a.S_NO = b.S_NO and a.BA_NO = b.BA_NO
            where b.FLS_NO in ('CF', 'CO') and a.S_NO = @store and b.BA_DATE = @day0 group by a.P_NO
            -- 銷售
            select P_NO, SUM(SL_QTY) as SL_QTY into #gg
            from SALE_D 
            where S_NO = @store and SL_DATE = @day0 group by P_NO
            -- join all
            select p.P_NO, p.P_NAME, isnull(a.PO_QTY, 0) as PO_QTY, isnull(b.IN_QTY, 0) as IN_QTY, ISNULL(c.SST_QTY, 0) as SST_QTY, isnull(d.TR_OUT_QTY, 0) as TR_OUT_QTY, isnull(e.TR_IN_QTY, 0) as TR_IN_QTY, isnull(f.BA_QTY, 0) as BA_QTY, isnull(g.SL_QTY, 0) as SL_QTY, isnull(h.PS_QTY, 0) as PS_QTY into #hh
            from part p left join #aa a on p.P_NO = a.P_NO left join #bb b on p.P_NO = b.P_NO left join #cc c on p.P_NO = c.P_NO left join #dd d on p.P_NO = d.P_NO left join #ee e on p.P_NO = e.P_NO left join #ff f on p.P_NO = f.P_NO left join #gg g on p.P_NO = g.P_NO 
            left join IWILL_PART_S h on h.S_NO = @store and h.PS_DATE = @day0 and p.P_NO = h.P_NO
            where p.P_PRICE > 0 and not (a.PO_QTY is null and b.IN_QTY is null and c.SST_QTY is null and d.TR_OUT_QTY is null and e.TR_IN_QTY is null and f.BA_QTY is null and g.SL_QTY is null)
            -- 只找有退货的
            select *, case IN_QTY + SST_QTY when 0 then null else BA_QTY / (IN_QTY + SST_QTY) * 100 end as BA_PRCNT
            from #hh where BA_QTY > 0 
            order by P_NO
        """
        sql.eachRow(s, [ms.s_no, the_day]) {
            list << it.toRowResult()
        }

        [s_no: ms.s_no, s_name: ms.s_name, the_day: the_day, list: list, refundSign: refundSign]
    }


    def refund() {
        // 根据日期查
        def list1 = []
        def list2 = []
        // default date
        def the_day = _.yesterday('yyyy/MM/dd')
        if (params.the_day) {
            the_day = params.the_day 
        }            
        def sql = _.sql
        def s = ''

        if (params.btn1) {
            s = """
                SELECT b.R_NAME, a.S_NAME, a.S_TEL, a.S_IP, c.op_name, CONVERT(CHAR, c.date_created, 120) AS dt
                FROM STORE a
                LEFT JOIN REGION b ON a.R_NO = b.R_NO
                LEFT JOIN iwill_refund_sign c ON a.S_NO = c.s_no and refund_date = CONVERT(varchar, CONVERT(datetime, ?), 112)
                WHERE NOT a.R_NO IN ('8041', '8981', '8991', '8992')
                AND a.S_STATUS = 1
                ORDER BY a.S_NO 
            """
            sql.eachRow(s, [the_day]) {
                list1 << it.toRowResult()
            }
        }
        if (params.btn2) {
            list2 = refund_all_store(sql, the_day)
        }

        [list1: list1, list2: list2, the_day: the_day]
    }

    def refund_all_store(sql, the_day) {
        def list = []
        def s = """
            declare @day0 varchar(10)
            declare @day_1 varchar(10)
            set @day0 = CONVERT(varchar, CONVERT(datetime, ?), 112)
            set @day_1 = CONVERT(varchar, DATEADD(d, -1, CONVERT(datetime, @day0)), 112)
            -- 订货
            select b.S_NO, a.P_NO, SUM(a.P_QTY) AS PO_QTY into #aa
            from PO_D a left join POR b on a.POR_NO = b.POR_NO and a.S_NO = b.S_NO
            where b.FLS_NO = 'AP' and b.POR_DATE = @day_1 and a.P_QTY <> 0 group by b.S_NO, a.P_NO
            -- 进货
            select b.S_NO, a.P_NO, SUM(a.P_QTY) as IN_QTY into #bb
            from INS_D a left join INS_H b on a.IN_NO = b.IN_NO and a.S_NO = b.S_NO
            where b.FLS_NO = 'CO' and b.UPD_DATE = @day0 group by b.S_NO, a.P_NO
            -- 生產入庫
            select a.S_NO, a.P_NO, SUM(a.SST_QTY) as SST_QTY into #cc
            from S_STOR_D a left join S_STOR_H b on a.S_NO = b.S_NO and a.SST_NO = b.SST_NO
            where b.FLS_NO = 'CO' and b.SPK_DATE = @day0 group by a.S_NO, a.P_NO
            -- 撥入
            select b.S_NO_IN, a.P_NO, SUM(a.TR_OUT_QTY) as TR_OUT_QTY into #dd
            from TRAN_D a left join TRAN_H b on a.TR_NO = b.TR_NO and a.S_NO_OUT = b.S_NO_OUT
            where b.FLS_NO in ('CF', 'CO') and b.TR_DATE = @day0 group by b.S_NO_IN, a.P_NO
            -- 撥出
            select b.S_NO_OUT, a.P_NO, SUM(a.TR_IN_QTY) as TR_IN_QTY into #ee
            from TRAN_D a left join TRAN_H b on a.TR_NO = b.TR_NO and a.S_NO_OUT = b.S_NO_OUT
            where b.FLS_NO in ('CF', 'CO') and b.TR_DATE = @day0 group by b.S_NO_OUT, a.P_NO
            -- 退貨
            select a.S_NO, a.P_NO, SUM(a.P_QTY) as BA_QTY into #ff
            from BACK_D a left join BACK_H b on a.S_NO = b.S_NO and a.BA_NO = b.BA_NO
            where b.FLS_NO in ('CF', 'CO') and b.BA_DATE = @day0 group by a.S_NO, a.P_NO
            -- 銷售
            select S_NO, P_NO, SUM(SL_QTY) as SL_QTY into #gg
            from SALE_D 
            where SL_DATE = @day0 group by S_NO, P_NO
            -- join all
           
            select s.S_NO, s.S_NAME, p.P_NO, p.P_NAME, isnull(a.PO_QTY, 0) as PO_QTY, isnull(b.IN_QTY, 0) as IN_QTY, ISNULL(c.SST_QTY, 0) as SST_QTY, isnull(d.TR_OUT_QTY, 0) as TR_OUT_QTY, isnull(e.TR_IN_QTY, 0) as TR_IN_QTY, isnull(f.BA_QTY, 0) as BA_QTY, isnull(g.SL_QTY, 0) as SL_QTY, isnull(h.PS_QTY, 0) as PS_QTY into #hh
            from PART p full join STORE s on 1 = 1
            left join #aa a on p.P_NO = a.P_NO and s.S_NO = a.S_NO
            left join #bb b on p.P_NO = b.P_NO and s.S_NO = b.S_NO
            left join #cc c on p.P_NO = c.P_NO and s.S_NO = c.S_NO
            left join #dd d on p.P_NO = d.P_NO and s.S_NO = d.S_NO_IN
            left join #ee e on p.P_NO = e.P_NO and s.S_NO = e.S_NO_OUT
            left join #ff f on p.P_NO = f.P_NO and s.S_NO = f.S_NO
            left join #gg g on p.P_NO = g.P_NO and s.S_NO = g.S_NO
            left join IWILL_PART_S h on h.S_NO = s.S_NO and h.PS_DATE = @day0 and p.P_NO = h.P_NO
            where p.P_PRICE > 0 and not (a.PO_QTY is null and b.IN_QTY is null and c.SST_QTY is null and d.TR_OUT_QTY is null and e.TR_IN_QTY is null and f.BA_QTY is null and g.SL_QTY is null)
           
            -- 只找有退货的
            select *, case IN_QTY + SST_QTY when 0 then null else BA_QTY / (IN_QTY + SST_QTY) * 100 end as BA_PRCNT
            from #hh where BA_QTY > 0 
            order by S_NO, P_NO                
        """
        sql.eachRow(s, [the_day]) {
            list << it.toRowResult()
        }
        return list
    }

    def refund_excel() {
        def the_day = params.the_day 
        def sql = _.sql
        def list = refund_all_store(sql, the_day)

        response.setContentType('application/vnd.ms-excel')
        response.setHeader('Content-Disposition', 'Attachment;Filename="Excel.xls"')

        WritableWorkbook workbook = Workbook.createWorkbook(response.outputStream)
        WritableSheet sheet1 = workbook.createSheet("Sheet1", 0)
        // header
        def h = ['日期', '编号', '门店', '品号', '品名', '订货', '进货', '差异', '生产入库', '期初', '调拨', '退货', '销售', '退货百分比(%)']
        h.eachWithIndex { obj, i ->
            sheet1.addCell(new Label(i, 0, obj))
        }
        // data
        list.eachWithIndex { obj, i ->
            def row = i + 1
            sheet1.addCell(new Label(0, row, the_day))
            sheet1.addCell(new Label(1, row, obj.S_NO))
            sheet1.addCell(new Label(2, row, obj.S_NAME))
            sheet1.addCell(new Label(3, row, obj.P_NO))
            sheet1.addCell(new Label(4, row, obj.P_NAME))
            sheet1.addCell(new Number(5, row, obj.PO_QTY as int))
            sheet1.addCell(new Number(6, row, obj.IN_QTY as int))
            sheet1.addCell(new Number(7, row, obj.PO_QTY - obj.IN_QTY as int))
            sheet1.addCell(new Number(8, row, obj.SST_QTY as int))
            sheet1.addCell(new Number(9, row, obj.PS_QTY as int))
            sheet1.addCell(new Number(10, row, obj.TR_IN_QTY - obj.TR_OUT_QTY as int))
            sheet1.addCell(new Number(11, row, obj.BA_QTY as int))
            sheet1.addCell(new Number(12, row, obj.SL_QTY as int))
            sheet1.addCell(new Label(13, row, obj.BA_PRCNT ? (obj.BA_PRCNT as int).toString() + '%' : 'N/A'))
        }
        workbook.write();
        workbook.close();        
    }

    def r1_pos() {
        def data = [:]
        if (params.qbtn) {
            def sql = _.sql
            def ms = Iwill.myStore(request, sql) 
            def s = """
                declare @pos_dates varchar(12)
                declare @pos_datee varchar(12)
                declare @store varchar(100)
                set @pos_dates = convert(varchar(12), convert(datetime, ?), 112)
                set @pos_datee = convert(varchar(12), convert(datetime, ?), 112) 
                set @store = ?
                SELECT S_NO, S_NAME INTO #aa FROM STORE WHERE S_NO IN (@store)    
                select  P_NO, P_NAME, case when D_NO in ('1611', '1612', '1613', '1614', '1615') then '面包'
                when D_NO ='1616' then '蛋糕'
                when D_NO in ('1617') then '冷点'
                when D_NO in ('1619', '1620') then '西点'
                when D_NO in ('1801', '1802', '1803', '1804', '1805', '1806', '1807', '1808') then '现烤'
                else 'XX' end as category
                into #a from part 
                select * into #bb from #a where category <> 'XX'
                SELECT b.S_NO, a.P_NO, SUM(a.P_QTY) AS IN_QTY, SUM(a.P_AMT) AS IN_AMT
                INTO #cc
                FROM INS_D a
                LEFt JOIN INS_H b ON a.IN_NO = b.IN_NO AND a.S_NO = b.S_NO
                WHERE b.S_NO in (@store) AND a.P_NO IN (SELECT P_NO FROM #bb)
                AND b.UPD_DATE >= @pos_dates AND b.UPD_DATE <= @pos_datee
                AND b.FLS_NO IN ('CO')
                GROUP BY b.S_NO, a.P_NO
                SELECT b.S_NO, a.P_NO, SUM(a.P_QTY) AS BA_QTY, SUM(a.P_AMT) AS BA_AMT, SUM(a.QTY_BAT) AS BA_QTY1
                INTO #dd
                FROM BACK_D a
                LEFt JOIN BACK_H b ON a.BA_NO = b.BA_NO AND a.S_NO = b.S_NO
                WHERE  b.S_NO in (@store) AND a.P_NO IN (SELECT P_NO FROM #bb)
                AND b.BA_DATE >= @pos_dates AND b.BA_DATE <= @pos_datee
                AND b.FLS_NO IN ('CF')
                GROUP BY b.S_NO, a.P_NO
                SELECT b.S_NO, a.P_NO, SUM(a.SL_QTY) AS SL_QTY, SUM(a.SL_AMT) AS SL_AMT
                INTO #ee
                FROM SALE_D a
                LEFt JOIN SALE_H b ON a.SL_KEY = b.SL_KEY
                WHERE  b.S_NO in (@store) AND a.P_NO IN (SELECT P_NO FROM #bb)
                AND b.SL_DATE >= @pos_dates AND b.SL_DATE <= @pos_datee
                GROUP BY b.S_NO, a.P_NO
                select a.S_NO, a.P_NO, SUM(a.SST_QTY) as SST_QTY, SUM(a.SST_QTY * c.P_PRICE) as SST_AMT
                into #ff
                from S_STOR_D a 
                left join S_STOR_H b on a.SST_NO = b.SST_NO and a.S_NO = b.S_NO
                left join part c on a.P_NO = c.P_NO
                where b.S_NO in (@store) and a.P_NO in (select P_NO from #bb) 
                and b.SPK_DATE >= @pos_dates and b.SPK_DATE <= @pos_datee
                group by a.S_NO, a.P_NO
                select b.S_NO_IN as S_NO, a.P_NO, sum(a.tr_out_qty) as tr_in_qty, SUM(a.tr_out_qty * c.P_PRICE) as TR_in_AMT
                into #gg
                from TRAN_D a
                left join TRAN_H b on a.TR_NO = b.TR_NO and a.S_NO_OUT = b.S_NO_OUT
                left join PART c on a.P_NO = c.P_NO
                where b.FLS_NO in ('CF', 'CO') and b.S_NO_IN in (@store) and a.P_NO in (select P_NO from #bb) and b.TR_DATE >= @pos_dates and b.TR_DATE <= @pos_datee
                group by b.S_NO_IN, a.P_NO
                select b.S_NO_OUT as S_NO, a.P_NO, sum(a.tr_out_qty) as tr_out_qty, SUM(a.tr_out_qty * c.P_PRICE) as tr_out_amt
                into #hh
                from TRAN_D a
                left join TRAN_H b on a.TR_NO = b.TR_NO and a.S_NO_OUT = b.S_NO_OUT
                left join PART c on a.P_NO = c.P_NO
                where b.FLS_NO in ('CF', 'CO') and b.S_NO_OUT in (@store) and a.P_NO in (select P_NO from #bb) and b.TR_DATE >= @pos_dates and b.TR_DATE <= @pos_datee
                group by b.S_NO_OUT, a.P_NO
                SELECT a.S_NO, a.S_NAME, b.category, b.P_NO, b.P_NAME
                , isnull(c.IN_QTY, 0) AS in_qty, isnull(c.IN_AMT, 0) AS in_amt
                , isnull(f.SST_QTY, 0) as sst_qty, isnull(f.SST_AMT, 0) as sst_amt
                , isnull(d.BA_QTY, 0) AS ba_qty, isnull(d.BA_QTY1, 0) AS ba_qty1, isnull(d.BA_AMT, 0) AS ba_amt
                , isnull(e.SL_QTY, 0) AS sl_qty, isnull(e.SL_AMT, 0) AS sl_amt
                , isnull(g.tr_in_qty, 0) as tr_in_qty, isnull(g.tr_in_amt, 0) as tr_in_amt
                , isnull(h.tr_out_qty, 0) as tr_out_qty, isnull(h.tr_out_amt, 0) as tr_out_amt
                , case when isnull(d.BA_QTY, 0) = 0 then 0 when (isnull(c.IN_QTY, 0)+isnull(f.SST_QTY, 0)+isnull(g.tr_in_qty, 0)-isnull(h.tr_out_qty, 0)) = 0 then 99999999 else isnull(d.BA_QTY, 0) / (isnull(c.IN_QTY, 0)+isnull(f.SST_QTY, 0)+isnull(g.tr_in_qty, 0)-isnull(h.tr_out_qty, 0)) end as back_rate
                FROM #aa a 
                FULL JOIN #bb b ON 1 = 1
                LEFT JOIN #cc c ON a.S_NO = c.S_NO AND b.P_NO = c.P_NO
                LEFT JOIN #dd d ON a.S_NO = d.S_NO AND b.P_NO = d.P_NO
                LEFT JOIN #ee e ON a.S_NO = e.S_NO AND b.P_NO = e.P_NO
                left join #ff f ON a.S_NO = f.S_NO and b.P_NO = f.P_NO
                left join #gg g ON a.S_NO = g.S_NO and b.P_NO = g.P_NO
                left join #hh h ON a.S_NO = h.S_NO and b.P_NO = h.P_NO
                WHERE NOT (c.P_NO IS NULL AND d.P_NO IS NULL AND e.P_NO IS NULL)
                ORDER BY a.S_NAME, b.category, e.SL_AMT desc
            """
            sql.eachRow(s, [params.sdate, params.edate, ms.s_no.toString()]) {
                def foo =  it.toRowResult()
                if (data[foo.category] == null) {
                    data[foo.category] = []
                }
                data[foo.category] << foo
            } 
        } 
        data.each { k, v ->
            def t = [ S_NO: '', S_NAME: '', category: '', P_NO: '', P_NAME: '合计: ', in_qty: 0, in_amt: 0, sst_qty: 0, sst_amt: 0, ba_qty: 0, ba_qty1: 0, ba_amt: 0, sl_qty: 0, sl_amt: 0, tr_in_qty: 0, tr_in_amt: 0, tr_out_qty: 0, tr_out_amt: 0, back_rate: 0]
            v.each { ii ->
                t.in_qty += ii.in_qty
                t.in_amt += ii.in_amt
                t.sst_qty += ii.sst_qty
                t.sst_amt += ii.sst_amt
                t.ba_qty += ii.ba_qty
                t.ba_qty1 += ii.ba_qty1
                t.ba_amt += ii.ba_amt
                t.sl_qty += ii.sl_qty
                t.sl_amt += ii.sl_amt
                t.tr_in_qty += ii.tr_in_qty
                t.tr_in_amt += ii.tr_in_amt
                t.tr_out_qty += ii.tr_out_qty
                t.tr_out_amt += ii.tr_out_amt
            }
            if (t.ba_qty == 0) {
                t.back_rate = 0
            } else if ((t.in_amt + t.sst_amt + t.tr_in_amt - t.tr_out_amt) == 0) {
                t.back_rate = 99999999           
            } else {
                t.back_rate = t.ba_amt / (t.in_amt + t.sst_amt + t.tr_in_amt - t.tr_out_amt)
            }
            v << t 
        }
        [data: data]
    }


    def r2_pos() {
        def data = []
        if (params.qbtn && params.sdate) {
            def y = params.sdate[0..3]
            def m = params.sdate[-2..-1]
            def sdate = "${y}/${m}/01"
            Calendar calendar = Calendar.instance
            calendar.set(y.toInteger(), m.toInteger() - 1, 1)
            def last = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            def edate = "${y}/${m}/${last}"
            def sql = _.sql
            def ms = Iwill.myStore(request, sql) 
            // 0083
            def s = """
                declare @p_dates varchar(20)
                declare @p_datee varchar(20)
                declare @p_store varchar(20)
                set @p_dates = ? -- '20160227'
                set @p_datee = ? -- '20160301'
                set @p_store= ? -- '8022015'

                -- =============== START ==================
                declare @dates varchar(8) 
                declare @datee varchar(8) 
                set @dates = convert(char, convert(datetime, @p_dates), 112) -- 日期
                set @datee = convert(char, convert(datetime, @p_datee), 112) -- 日期

                ---充值----
                select  GI_DATE,GI_BILL_SNO as S_NO, SUM(GI_AMT) as 充值
                into #充值
                from GIFT_LIFE  where GI_TYPE ='ADD'   and GI_BILL_SNO<>'0000000' and REMARK1='' 
                and GI_DATE>=@dates and GI_DATE<=@datee  and  GI_BILL_SNO in(@p_store)
                group by GI_BILL_SNO,GI_DATE
                

                SELECT  SL_DATE,a.S_NO, b.S_NAME,b.r_no, count(SL_KEY) as 总客流量,COUNT(distinct a.SL_DATE) as 营业天数,
                sum(isnull(SL_AMT,0)) as 总价, sum(isnull(SL_DISC_AMT,0)) as 折扣, sum(isnull(PAY_AMT,0)) as 营业总额, sum(isnull(PAY_CASH,0)) as 现金, --status_C 状态
                sum(isnull(PAY_CARD,0)) as 非公司券, sum(isnull(PAY_3,0)) as 阳光卡, sum(isnull(PAY_4,0)) as 促销券, sum(isnull(PAY_5,0)) as 提货券, sum(isnull(PAY_6,0)) as 代金券, 
                sum(isnull(PAY_7,0)) as 代金券溢收, sum(isnull(PAY_8,0)) as 促销券溢收, sum(isnull(PAY_9,0)) as 旧阳光卡, sum(isnull(PAY_10,0)) as 银联卡, sum(isnull(PAY_11,0)) as 提货券溢收,
                suM(isnull(PAY_12,0)) as  挂账, suM(isnull(PAY_21,0)) as  支付宝, suM(isnull(PAY_23,0)) as  微信,
                                suM( isnull(a.PAY_CASH,0)+isnull(a.PAY_10,0)+isnull(a.PAY_12,0)+isnull(a.PAY_21,0)+isnull(a.PAY_23,0)) as  现金H 
INTO #tmp_Party全 
                FROM SALE_H a
                LEFT JOIN STORE b ON a.S_NO = b.S_NO
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee   and  a.S_NO in(@p_store)---  and a.S_NO='8022002'
                group by a.S_NO, b.S_NAME,b.r_no,SL_DATE
                order by a.S_NO
                SELECT  SL_DATE,a.S_NO, b.S_NAME, count(SL_KEY) as 总客流量,COUNT(distinct a.SL_DATE) as 营业天数,
                sum(isnull(SL_AMT,0)) as 总价, sum(isnull(SL_DISC_AMT,0)) as 折扣, sum(isnull(PAY_AMT,0)) as 营业总额, sum(isnull(PAY_CASH,0)) as 现金, --status_C 状态
                sum(isnull(PAY_CARD,0)) as 非公司券, sum(isnull(PAY_3,0)) as 阳光卡, sum(isnull(PAY_4,0)) as 促销券, sum(isnull(PAY_5,0)) as 提货券, sum(isnull(PAY_6,0)) as 代金券, 
                sum(isnull(PAY_7,0)) as 代金券溢收, sum(isnull(PAY_8,0)) as 促销券溢收, sum(isnull(PAY_9,0)) as 旧阳光卡, sum(isnull(PAY_10,0)) as 银联卡, sum(isnull(PAY_11,0)) as 提货券溢收,
                suM(isnull(PAY_12,0)) as  挂账  , suM(isnull(PAY_21,0)) as  支付宝 , suM(isnull(PAY_23,0)) as  微信
                INTO #小于三千 
                FROM SALE_H a
                LEFT JOIN STORE b ON a.S_NO = b.S_NO
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee and (isnull(a.PAY_CASH,0)+isnull(a.PAY_10,0)+isnull(a.PAY_12,0)+isnull(a.PAY_21,0)+isnull(a.PAY_23,0))<3000  and  a.S_NO in(@p_store)
                group by a.S_NO, b.S_NAME,SL_DATE
                order by a.S_NO

                SELECT  SL_DATE,a.S_NO, b.S_NAME, count(SL_KEY) as 总客流量,COUNT(distinct a.SL_DATE) as 营业天数,
                suM( isnull(a.PAY_CASH,0)+isnull(a.PAY_10,0)+isnull(a.PAY_12,0)+isnull(a.PAY_21,0)+isnull(a.PAY_23,0)) as  现金H, 
                sum(isnull(PAY_AMT,0)) as 营业总额,

                sum(isnull(PAY_CARD,0)) as 非公司券, sum(isnull(PAY_3,0)) as 阳光卡, sum(isnull(PAY_4,0)) as 促销券, sum(isnull(PAY_5,0)) as 提货券, sum(isnull(PAY_6,0)) as 代金券, 
                sum(isnull(PAY_7,0)) as 代金券溢收, sum(isnull(PAY_8,0)) as 促销券溢收, sum(isnull(PAY_9,0)) as 旧阳光卡, sum(isnull(PAY_10,0)) as 银联卡, sum(isnull(PAY_11,0)) as 提货券溢收,
                suM(isnull(PAY_12,0)) as  挂账  , suM(isnull(PAY_21,0)) as  支付宝 , suM(isnull(PAY_23,0)) as  微信
                INTO #大于三千
                FROM SALE_H a
                LEFT JOIN STORE b ON a.S_NO = b.S_NO
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee and (isnull(a.PAY_CASH,0)+isnull(a.PAY_10,0)+isnull(a.PAY_12,0)+isnull(a.PAY_21,0))>=3000  and  a.S_NO in(@p_store)
                group by a.S_NO, b.S_NAME,SL_DATE
                order by a.S_NO
                ----本月客取非本月客订
                SELECT  c.SL_DATE,a.S_NO, b.S_NAME, count(a.SL_KEY) as 总客流量,COUNT(distinct a.SL_DATE) as 营业天数,
                sum(isnull(a.SL_AMT,0)) as 总价, sum(isnull(a.SL_DISC_AMT,0)) as 折扣, sum(isnull(a.PAY_AMT,0)) as 营业总额, sum(isnull(a.PAY_CASH,0)) as 现金, --status_C 状态
                sum(isnull(a.PAY_CARD,0)) as 非公司券, sum(isnull(a.PAY_3,0)) as 阳光卡, sum(isnull(a.PAY_4,0)) as 促销券, sum(isnull(a.PAY_5,0)) as 提货券, sum(isnull(a.PAY_6,0)) as 代金券, 
                sum(isnull(a.PAY_7,0)) as 代金券溢收, sum(isnull(a.PAY_8,0)) as 促销券溢收, sum(isnull(a.PAY_9,0)) as 旧阳光卡, sum(isnull(a.PAY_10,0)) as 银联卡, sum(isnull(a.PAY_11,0)) as 提货券溢收,
                suM(isnull(a.PAY_12,0)) as  挂账  , suM(isnull(a.PAY_21,0)) as  支付宝 , suM(isnull(a.PAY_23,0)) as  微信
                INTO #本月取
                FROM SALE_H a
                LEFT JOIN STORE b ON a.S_NO = b.S_NO
                left join SALE_ORDER_H c on a.SL_KEY_ORDER=c.SL_KEY
                WHERE a.SL_DATE >= @dates AND a.SL_DATE <= @datee  and a.SL_SOURCE=2  and  a.S_NO in(@p_store)
                and c.SL_DATE<@dates
                group by a.S_NO, b.S_NAME,c.SL_DATE
                order by a.S_NO

                SELECT SL_DATE,S_NO, SUM(isnull(AMT,0)) as 非公司券礼券S into #非公司券礼券S---相当于现金
                FROM SALE_CARD_PAY 
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME)) in  (select  FUNC_NAME from [iwill].[dbo].[STORE_CARD_Temp] where FUNC=2) and  S_NO in(@p_store)
                group by S_NO,SL_DATE

                SELECT SL_DATE,S_NO, SUM(isnull(AMT,0)) as 非公司券业绩S into #非公司券业绩S---相当于券
                FROM SALE_CARD_PAY 
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME))  in  (select  FUNC_NAME from [iwill].[dbo].[STORE_CARD_Temp] where FUNC=1)  and  S_NO in(@p_store)
                group by SL_DATE,S_NO

                SELECT SL_DATE,S_NO, SUM(isnull(AMT,0)) as 非公司券促销券S into #非公司券促销券S---相当于促销券
                FROM SALE_CARD_PAY 
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME))  in  (select  FUNC_NAME from [iwill].[dbo].[STORE_CARD_Temp] where FUNC=3)  and  S_NO in(@p_store)
                group by SL_DATE,S_NO
 
                SELECT SL_DATE,S_NO, SUM(isnull(AMT,0)) as 非公司未分类S into #非公司未分类
                FROM SALE_CARD_PAY 
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME))   in  (  select FUNC_NAME from  STORE_CARD where  GROUPID='BANK' and USERD='Y' and FUNC_NAME not in   (select  FUNC_NAME from [iwill].[dbo].[STORE_CARD_Temp]))  and  S_NO in(@p_store)
                group by SL_DATE, S_NO
  
                SELECT SL_DATE,S_NO, SUM(isnull(AMT,0)) as 非公司券月结券S into #非公司券月结券S
                FROM SALE_CARD_PAY  
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME))  in  ('月结券')  and  S_NO in(@p_store)
                group by SL_DATE, S_NO
 
                SELECT   c.SL_DATE,a.S_NO, SUM(isnull(AMT,0)) as 非公司业绩QS into #非公司业绩QS
                FROM SALE_CARD_PAY  a
                LEFT JOIN STORE b ON a.S_NO = b.S_NO 
                LEFT JOIN SALE_H H ON a.SL_KEY = H.SL_KEY 
                left join SALE_ORDER_H c on H.SL_KEY_ORDER=c.SL_KEY
                WHERE H.SL_DATE >= @dates AND H.SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME)) in  (select  FUNC_NAME from [iwill].[dbo].[STORE_CARD_Temp] where FUNC=1)
                and c.SL_DATE<@dates    and  a.S_NO in(@p_store)
                group by c.SL_DATE,a.S_NO

                SELECT  H.SL_DATE,a.S_NO, SUM(isnull(AMT,0)) as 非公司月结券QS into #非公司月结券QS
                FROM SALE_CARD_PAY  a
                LEFT JOIN STORE b ON a.S_NO = b.S_NO       LEFT JOIN SALE_H H ON a.SL_KEY = H.SL_KEY 
                left join SALE_ORDER_H c on H.SL_KEY_ORDER=c.SL_KEY
                WHERE H.SL_DATE >= @dates AND H.SL_DATE <= @datee  and rtrim(ltrim(CARD_NAME)) in  ('月结券')   and c.SL_DATE<@dates   and  a.S_NO in(@p_store) 
                group by a.S_NO,H.SL_DATE
                
                ---物料----
                select SL_DATE,S_NO, SUM(SL_AMT)as 节庆总额,sum(SL_TAXAMT) as 节庆营业总额
                into #节庆
                from SALE_D
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee and S_NO <> ''
                and ((DP_NO >= 8011 and DP_NO <= 8099) or (DP_NO >= 9011 and DP_NO <= 9099) or (DP_NO >= 9111 and DP_NO <= 9199))   and  S_NO in(@p_store)
                group by S_NO,SL_DATE

                select SL_DATE,S_NO, SUM(AMT)as 节庆提货总额
                into #节庆提货
                from SALE_CARD
                WHERE SL_DATE >= @dates AND SL_DATE <= @datee and S_NO <> ''
                and CARD_TYPE = 4 and CARD_NO like '9%'  and  S_NO in(@p_store)
                group by S_NO,SL_DATE

                select a.*, b.非公司券业绩S, c.非公司券促销券S, d.非公司券月结券S, e.非公司券礼券S, f.营业总额 as  小于三千, g.现金H as 大于三千, q.营业总额 as 本月取,
                n.充值, isnull(a.支付宝,0)+isnull(a.微信,0)+isnull(a.现金,0)+ISNULL(a.银联卡,0)+ISNULL(a.挂账,0)+isnull(b.非公司券业绩S,0)+ISNULL(n.充值,0) as 实际业绩,
                isnull(q.支付宝,0)+isnull(q.微信,0)+isnull(q.现金,0)+ISNULL(q.银联卡,0)+ISNULL(q.挂账,0)+isnull(MM.非公司业绩QS,0)+isnull(NN.非公司月结券QS,0) as 非本月实际业绩
                , isnull(OO.节庆总额, 0) as 节庆总额 , isnull(OO.节庆营业总额, 0) as 节庆营业总额, ISNULL(PP.节庆提货总额, 0) as 节庆提货总额,wp.非公司未分类S
                into #tmp_Party
                from #tmp_Party全 a 
                left join #非公司券业绩S b on a.S_NO=b.S_NO and a.SL_DATE=b.SL_DATE
                left join #非公司券促销券S c on a.S_NO=c.S_NO and a.SL_DATE=c.SL_DATE
                left join #非公司券月结券S d on a.S_NO=d.S_NO and a.SL_DATE=d.SL_DATE
                left join #非公司券礼券S e on a.S_NO=e.S_NO and a.SL_DATE=e.SL_DATE
                left join #小于三千 f on a.S_NO=f.S_NO and a.SL_DATE=f.SL_DATE
                left join #大于三千 g on a.S_NO=g.S_NO and a.SL_DATE=g.SL_DATE
                left join #充值 n on a.S_NO=n.S_NO and a.SL_DATE=n.GI_DATE
                left join #本月取 q on a.S_NO=q.S_NO and a.SL_DATE=q.SL_DATE
                left join #非公司业绩QS MM on a.S_NO=MM.S_NO and a.SL_DATE=MM.SL_DATE
                left join #非公司月结券QS NN on a.S_NO=NN.S_NO and a.SL_DATE=NN.SL_DATE
                left join #节庆 OO on a.S_NO = OO.S_NO and a.SL_DATE=OO.SL_DATE
                left join #节庆提货 PP on a.S_NO = PP.S_NO and a.SL_DATE=PP.SL_DATE
                left join #非公司未分类 wp on a.S_NO=wp.S_NO and a.SL_DATE=wp.SL_DATE

                select b.R_NO, b.R_NAME,SL_DATE, a.S_NO, S_NAME, 营业天数, (isnull(实际业绩,0)+ISNULL(非公司券月结券S,0)-ISNULL(大于三千,0))/营业天数 as 平均营业额, 营业总额 , isnull(代金券,0)+ISNULL(代金券溢收,0)+ISNULL(非公司券礼券S,0)+ISNULL(阳光卡,0) as 礼券回收,非公司未分类S
                , isnull(促销券,0)+ISNULL(非公司券促销券S,0) as 促销券, 折扣, isnull(大于三千,0) as 大于三千,  isnull(本月取,0) as 本月取, isnull(实际业绩,0)+ISNULL(非公司券月结券S,0) as 实际业绩订单, ISNULL(充值,0) as 充值,ISNULL(非公司券月结券S,0) as 非公司券月结券S
                ,isnull(实际业绩,0)+ISNULL(非公司券月结券S,0)-ISNULL(大于三千,0) as 实际业绩奖金,  ISNULL(非本月实际业绩,0) as 非本月实际业绩
                , 总客流量
                , case when 营业天数 = 0 then 0 else 总客流量/营业天数 end as 平均客流
                , case when 总客流量 = 0 then 0 else (isnull(实际业绩,0)+ISNULL(非公司券月结券S,0)-ISNULL(大于三千,0))/总客流量 end as 客单价, 提货券,提货券溢收
                ,节庆总额, 节庆提货总额,节庆营业总额, isnull(convert(decimal(18,2), c.day_target), 1) as 目标
                , case when c.day_target = 0 then 0 else convert(decimal(18,2),(isnull(实际业绩,0)+ISNULL(非公司券月结券S,0)-ISNULL(大于三千,0))/isnull(c.day_target,1)) end as 达成率
                from #tmp_Party a
                left join REGION b on a.R_NO=b.R_NO
                left join iwill_store_target c on a.S_NO=c.s_no and left(a.SL_DATE,6)=c.months
                where a.S_NO<>'8027010'
                order by b.R_NO,a.S_NO,SL_DATE
            """
            def total = [S_NO: '', S_NAME: '', SL_DATE: ' 合计:', 营业总额: 0, 实际业绩奖金: 0, 总客流量: 0, 目标: 0]
            sql.eachRow(s, [sdate.toString(), edate.toString(), ms.s_no.toString()]) {
                data << it.toRowResult()
                total.营业总额 += it.营业总额
                total.实际业绩奖金 += it.实际业绩奖金
                total.总客流量 += it.总客流量
                total.目标 += it.目标
            }
            // TODO: total 日目标 改一下
            s = 'select month_target from iwill_store_target where s_no = ? and months = ?'
            def mt = total.目标
            def row = sql.firstRow(s, [ms.s_no.toString(), y+m])
            if (row) {
                mt = row.month_target
            }
            total.目标 = mt 
            data << total
        }
        [data: data]
    } 
}
