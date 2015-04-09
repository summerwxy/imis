package iwill

class AllotDao {
    static prType = ['01': '面包、西点', '02': '现烤', '03': '生日蛋糕'
        , '04': '喜庆礼盒', '05': '非自制品', '06': '水吧', '07': '券、卡']

    static getSpecialData(sNo) {
        def result = []
        def sql = _.sql
        def s = """
            -- 找出合約
            SELECT * INTO #aa FROM IWILL_JOIN_CONTRACT_PART WHERE S_NO + CT_NO = (SELECT TOP 1 S_NO + CT_NO FROM IWILL_JOIN_CONTRACT WHERE S_NO = ?)
            -- 找出特殊結算物料
            SELECT a.P_NO, b.CT_DISC_P
            FROM CARE_D a
            INNER JOIN #aa b ON a.C_NO = b.P_NO
        """
        sql.eachRow(s, [sNo]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result
    }

    static getInsData(sNo, sDate, eDate) { // 包含特殊结算的资料
        def result = []
        def sql = _.sql
        def s = """
            -- 進貨驗收單
            SELECT a.IN_NO as THE_NO, b.IN_DATE AS THE_DATE, d.D_CNAME, d.PR_TYPE, a.P_NO, c.P_NAME, c.P_PRICE, a.P_QTY
            FROM INS_D a
            LEFT JOIN INS_H b ON a.IN_NO = b.IN_NO AND a.S_NO = b.S_NO
            LEFT JOIN PART c ON a.P_NO = c.P_NO
            LEFT JOIN DEPART d ON c.D_NO = d.D_NO
            WHERE b.FLS_NO = 'CO' AND b.S_NO = ? AND b.IN_DATE >= ? AND b.IN_DATE <= ?
            AND c.P_PRICE > 0 AND a.P_QTY > 0
            ORDER BY b.IN_DATE, a.P_NO
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result 
    }

    static getStorData(sNo, sDate, eDate) { // 包含特殊结算的资料
        def result = []
        def sql = _.sql
        def s = """
            -- 生產入庫單
            SELECT a.SST_NO AS THE_NO, b.SPK_DATE AS THE_DATE, d.D_CNAME, d.PR_TYPE, a.P_NO, c.P_NAME, c.P_PRICE, a.SST_QTY AS P_QTY
            FROM S_STOR_D a
            LEFT JOIN S_STOR_H b ON a.S_NO = b.S_NO AND a.SST_NO = b.SST_NO
            LEFT JOIN PART c ON a.P_NO = c.P_NO
            LEFT JOIN DEPART d ON c.D_NO = d.D_NO
            WHERE b.FLS_NO = 'CO' AND b.S_NO = ? AND b.SPK_DATE >= ? AND b.SPK_DATE <= ?
            ORDER BY b.SPK_DATE, a.P_NO
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result     
    }

    static getTrInData(sNo, sDate, eDate) { // 包含特殊结算的资料
        def result = []
        def sql = _.sql
        def s = """
            -- 轉入
            SELECT a.TR_NO AS THE_NO, b.TR_DATE AS THE_DATE, d.D_CNAME, d.PR_TYPE, a.P_NO, c.P_NAME, c.P_PRICE, a.TR_IN_QTY AS P_QTY
            FROM TRAN_D a
            LEFT JOIN TRAN_H b ON a.TR_NO = b.TR_NO AND a.S_NO_OUT = b.S_NO_OUT
            LEFT JOIN PART c ON a.P_NO = c.P_NO
            LEFT JOIN DEPART d ON c.D_NO = d.D_NO
            WHERE b.FLS_NO IN ('CF', 'CO') AND b.S_NO_IN = ? AND b.TR_DATE >= ? AND b.TR_DATE <= ?
            ORDER BY b.TR_DATE, a.P_NO
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result     
    }

    static getTrOutData(sNo, sDate, eDate) { // 包含特殊结算的资料
        def result = []
        def sql = _.sql
        def s = """
            -- 轉出
            SELECT a.TR_NO AS THE_NO, b.TR_DATE AS THE_DATE, d.D_CNAME, d.PR_TYPE, a.P_NO, c.P_NAME, c.P_PRICE, a.TR_OUT_QTY AS P_QTY
            FROM TRAN_D a
            LEFT JOIN TRAN_H b ON a.TR_NO = b.TR_NO AND a.S_NO_OUT = b.S_NO_OUT
            LEFT JOIN PART c ON a.P_NO = c.P_NO
            LEFT JOIN DEPART d ON c.D_NO = d.D_NO
            WHERE b.FLS_NO IN ('CF', 'CO') AND b.S_NO_OUT = ? AND b.TR_DATE >= ? AND b.TR_DATE <= ?
            ORDER BY b.TR_DATE, a.P_NO
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result     
    }

    static getBackData(sNo, sDate, eDate) { // 包含特殊结算的资料
        def result = []
        def sql = _.sql
        def s = """
            -- 退貨
            SELECT a.BA_NO AS THE_NO, b.BA_DATE AS THE_DATE, d.D_CNAME, d.PR_TYPE, a.P_NO, c.P_NAME, c.P_PRICE, a.P_QTY
            FROM BACK_D a
            LEFT JOIN BACK_H b ON a.S_NO = b.S_NO AND a.BA_NO = b.BA_NO
            LEFT JOIN PART c ON a.P_NO = c.P_NO
            LEFT JOIN DEPART d ON c.D_NO = d.D_NO
            WHERE b.FLS_NO IN ('CF', 'CO') AND a.S_NO = ? AND b.BA_DATE >= ? AND b.BA_DATE <= ?
            ORDER BY b.BA_DATE, a.P_NO
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result     
    }

    static getAllExtraData(sNo, sDate, eDate) {
        def result = []
        def sql = _.sql
        def s = """
            select * from iwill_allot where sno = ? and date >= ? and date <= ?
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result
    }

    static getExtraData(p) {
        def result = []
        def sql = _.sql
        def s = """
            select * from iwill_allot where sno = ? and date = ? and catg = ? and data = ? and sp = ? order by id desc
        """
        sql.eachRow(s, [p.sno, p.date, p.catg, p.data, p.sp ? p.sp : 'X']) {
            def foo = it.toRowResult()
            result << foo
        }
        return result
    }

    static getRechargeData(sNo, sDate, eDate) {
        def result = []
        def sql = _.sql
        def s = """
            select CRE_DATE, PAY_AMT from IC_GIFT_RECHARGE where S_NO = ? and CRE_DATE >= ? and CRE_DATE <= ?
        """
        sql.eachRow(s, [sNo, sDate, eDate]) {
            def foo = it.toRowResult()
            result << foo
        }
        return result       
    }

    static filterNonSpecialList(data, special) {
        def result = []
        def pnos = special.collect {it.P_NO}
        data.each {
            if (!(it.P_NO in pnos)) {
                result << it
            }
        }
        return result
    }

    static filterSpecialList(data, special) {
        def result = []
        def pnos = special.collect {it.P_NO}
        data.each {
            if (it.P_NO in pnos) {
                result << it
            }
        }
        return result
    }
    static calcRechargeAmount(data, tDate) {
        def result = 0.0
        data.each {
            if (it.CRE_DATE == tDate) {
                result = result + it.PAY_AMT
            }
        }
        return result
    }

    static calcAllotAmount(data, date, catg, dataType, extraList) {
        def result = 0.0
        filterAllotList(data, date, catg).each {
            result = result + it.P_QTY * it.P_PRICE
        }
        extraList.each {
            if (it.date == date && it.data == dataType && it.catg == catg) {
                result = result + it.amount
            }
        }
        return result 
    }

    static filterAllotList(data, date, catg) {
        def result = []
        data.each {
            if (it.THE_DATE == date && it.PR_TYPE == catg) {
                result << it
            }
        }
        return result
    }

    static calcAllotOthers(data, date, dataType, extraList) {
        def result = 0.0
        filterAllotOthersList(data, date).each {
            result = result + it.P_QTY * it.P_PRICE
        }
        extraList.each {
            if (it.date == date && it.data == dataType && it.catg == 'others') {
                result = result + it.amount
            }
        }
        return result
    }

    static filterAllotOthersList(data, date) {
        def result = []
        data.each {
            if (it.THE_DATE == date && !(it.PR_TYPE in prType.keySet())) {
                result << it
            }
        }
        return result
    }

    static calcAllotSpecial(data, date, specialData, sp, dataType, extraList) {
        def result = 0.0
        filterAllotSpecialList(data, date, specialData, sp).each {
            result = result + it.P_QTY * it.P_PRICE
        }
        extraList.each {
            if (it.date == date && it.data == dataType && it.catg == 'special' && it.sp.toString() == sp.toString()) {
                result = result + it.amount
            }
        }
        return result
    }

    static filterAllotSpecialList(data, date, specialData, sp) {
        def result = []
        sp = Double.valueOf(sp)
        def items = specialData.collect {if (sp == it.CT_DISC_P) {return it.P_NO}}
        data.each {
            if (it.THE_DATE == date && it.P_NO in items) {
                result << it
            }
        }
        return result
    }

    static appendTotal(list) {
        def total = ['01': 0, '02': 0, '03': 0, '04': 0, '05': 0, '06': 0, '07': 0, 'others': 0]
        list.each { k, v ->
            total['01'] += v['01']
            total['02'] += v['02']
            total['03'] += v['03']
            total['04'] += v['04']
            total['05'] += v['05']
            total['06'] += v['06']
            total['07'] += v['07']
            total['others'] += v['others']
        }
        list['total'] = total
        return list
    }

    static appendSpecialTotal(list, spList) {
        def foo = [:]
        list.each { k, v ->
            spList.each { sp ->
                if (!foo[sp]) { foo[sp] = 0 }
                foo[sp] += list[k][sp]
            }                
        }
        list['total'] = foo
        return list
    }
}

