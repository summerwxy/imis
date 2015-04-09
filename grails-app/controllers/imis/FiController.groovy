package imis

import iwill.*

class FiController {

    def index() { }


    def prType = ['01': '面包、西点', '02': '现烤', '03': '生日蛋糕', '04': '喜庆礼盒', '05': '非自制品', '06': '水吧', '07': '券、卡']

    def allot() {
        def dateList = [] // 日期
        def spList = [] // 特殊結算折扣
        def insList1 = [:] // 进货 标准
        def insList2 = [:] // 进货 特殊
        def storList1 = [:] // 生产 标准
        def storList2 = [:] // 生产 特殊
        def trInList1 = [:] // 转入 标准
        def trInList2 = [:] // 转入 特殊
        def trOutList1 = [:] // 转出 标准
        def trOutList2 = [:] // 转出 特殊
        def backList1 = [:] // 退货 标准
        def backList2 = [:] // 退货 特殊
        def rechargeList = [:] // 充值
        def rechargeTotal = 0.0 
        if (params.q) {
            def sNo = params.store_no
            def sDate = _.dateStringRemoveSlash(params.sDate)
            def eDate = _.dateStringRemoveSlash(params.eDate)

            // 取资料
            def specialData = AllotDao.getSpecialData(sNo)
            def insData = AllotDao.getInsData(sNo, sDate, eDate)
            def storData = AllotDao.getStorData(sNo, sDate, eDate)
            def trInData = AllotDao.getTrInData(sNo, sDate, eDate)
            def trOutData = AllotDao.getTrOutData(sNo, sDate, eDate)
            def backData = AllotDao.getBackData(sNo, sDate, eDate)
            def rechargeData = AllotDao.getRechargeData(sNo, sDate, eDate)
            // 分成 标准1 与 特殊2 两份资料
            def insData1 = AllotDao.filterNonSpecialList(insData, specialData)
            def insData2 = AllotDao.filterSpecialList(insData, specialData)
            def storData1 = AllotDao.filterNonSpecialList(storData, specialData)
            def storData2 = AllotDao.filterSpecialList(storData, specialData)
            def trInData1 = AllotDao.filterNonSpecialList(trInData, specialData)
            def trInData2 = AllotDao.filterSpecialList(trInData, specialData)
            def trOutData1 = AllotDao.filterNonSpecialList(trOutData, specialData)
            def trOutData2 = AllotDao.filterSpecialList(trOutData, specialData)
            def backData1 = AllotDao.filterNonSpecialList(backData, specialData)
            def backData2 = AllotDao.filterSpecialList(backData, specialData)
            // special percent 程式裡面限定 整數的拆帳分式
            spList = specialData.collect {it.CT_DISC_P as int}.unique() 
            // 取出手動加的資料 
            def extraList = AllotDao.getAllExtraData(sNo, sDate, eDate)

            // 整理成顯示的格式
            def tDate = sDate
            while (tDate <= eDate) {
                dateList << tDate // 加入日期
                // insList1 进货 标准
                if (!insList1[tDate]) { insList1[tDate] = [:] }
                insList1[tDate]['01'] = AllotDao.calcAllotAmount(insData1, tDate, '01', 'ins1', extraList)
                insList1[tDate]['02'] = AllotDao.calcAllotAmount(insData1, tDate, '02', 'ins1', extraList)
                insList1[tDate]['03'] = AllotDao.calcAllotAmount(insData1, tDate, '03', 'ins1', extraList)
                insList1[tDate]['04'] = AllotDao.calcAllotAmount(insData1, tDate, '04', 'ins1', extraList)
                insList1[tDate]['05'] = AllotDao.calcAllotAmount(insData1, tDate, '05', 'ins1', extraList)
                insList1[tDate]['06'] = AllotDao.calcAllotAmount(insData1, tDate, '06', 'ins1', extraList)
                insList1[tDate]['07'] = AllotDao.calcAllotAmount(insData1, tDate, '07', 'ins1', extraList)
                insList1[tDate]['others'] = AllotDao.calcAllotOthers(insData1, tDate, 'ins1', extraList)
                // insList2 进货 特殊
                spList.each {
                    if (!insList2[tDate]) { insList2[tDate] = [:] }
                    insList2[tDate][it] = AllotDao.calcAllotSpecial(insData2, tDate, specialData, it, 'ins2', extraList)
                }

                // storList1 生产 标准
                if (!storList1[tDate]) { storList1[tDate] = [:] }
                storList1[tDate]['01'] = AllotDao.calcAllotAmount(storData1, tDate, '01', 'stor1', extraList)
                storList1[tDate]['02'] = AllotDao.calcAllotAmount(storData1, tDate, '02', 'stor1', extraList)
                storList1[tDate]['03'] = AllotDao.calcAllotAmount(storData1, tDate, '03', 'stor1', extraList)
                storList1[tDate]['04'] = AllotDao.calcAllotAmount(storData1, tDate, '04', 'stor1', extraList)
                storList1[tDate]['05'] = AllotDao.calcAllotAmount(storData1, tDate, '05', 'stor1', extraList)
                storList1[tDate]['06'] = AllotDao.calcAllotAmount(storData1, tDate, '06', 'stor1', extraList)
                storList1[tDate]['07'] = AllotDao.calcAllotAmount(storData1, tDate, '07', 'stor1', extraList)
                storList1[tDate]['others'] = AllotDao.calcAllotOthers(storData1, tDate, 'stor1', extraList)
                // storList2 生产 特殊
                spList.each {
                    if (!storList2[tDate]) { storList2[tDate] = [:] }
                    storList2[tDate][it] = AllotDao.calcAllotSpecial(storData2, tDate, specialData, it, 'stor2', extraList)
                }

                // trInList1 转入 标准
                if (!trInList1[tDate]) { trInList1[tDate] = [:] }
                trInList1[tDate]['01'] = AllotDao.calcAllotAmount(trInData1, tDate, '01', 'trIn1', extraList)
                trInList1[tDate]['02'] = AllotDao.calcAllotAmount(trInData1, tDate, '02', 'trIn1', extraList)
                trInList1[tDate]['03'] = AllotDao.calcAllotAmount(trInData1, tDate, '03', 'trIn1', extraList)
                trInList1[tDate]['04'] = AllotDao.calcAllotAmount(trInData1, tDate, '04', 'trIn1', extraList)
                trInList1[tDate]['05'] = AllotDao.calcAllotAmount(trInData1, tDate, '05', 'trIn1', extraList)
                trInList1[tDate]['06'] = AllotDao.calcAllotAmount(trInData1, tDate, '06', 'trIn1', extraList)
                trInList1[tDate]['07'] = AllotDao.calcAllotAmount(trInData1, tDate, '07', 'trIn1', extraList)
                trInList1[tDate]['others'] = AllotDao.calcAllotOthers(trInData1, tDate, 'trIn1', extraList)
                // trInList2 转入 特殊
                spList.each {
                    if (!trInList2[tDate]) { trInList2[tDate] = [:] }
                    trInList2[tDate][it] = AllotDao.calcAllotSpecial(trInData2, tDate, specialData, it, 'trIn2', extraList)
                }

                // trOutList1 转出 标准
                if (!trOutList1[tDate]) { trOutList1[tDate] = [:] }
                trOutList1[tDate]['01'] = AllotDao.calcAllotAmount(trOutData1, tDate, '01', 'trOut1', extraList) * -1
                trOutList1[tDate]['02'] = AllotDao.calcAllotAmount(trOutData1, tDate, '02', 'trOut1', extraList) * -1
                trOutList1[tDate]['03'] = AllotDao.calcAllotAmount(trOutData1, tDate, '03', 'trOut1', extraList) * -1
                trOutList1[tDate]['04'] = AllotDao.calcAllotAmount(trOutData1, tDate, '04', 'trOut1', extraList) * -1
                trOutList1[tDate]['05'] = AllotDao.calcAllotAmount(trOutData1, tDate, '05', 'trOut1', extraList) * -1
                trOutList1[tDate]['06'] = AllotDao.calcAllotAmount(trOutData1, tDate, '06', 'trOut1', extraList) * -1
                trOutList1[tDate]['07'] = AllotDao.calcAllotAmount(trOutData1, tDate, '07', 'trOut1', extraList) * -1
                trOutList1[tDate]['others'] = AllotDao.calcAllotOthers(trOutData1, tDate, 'trOut1', extraList) * -1
                // trOutList2 转出 特殊
                spList.each {
                    if (!trOutList2[tDate]) { trOutList2[tDate] = [:] }
                    trOutList2[tDate][it] = AllotDao.calcAllotSpecial(trOutData2, tDate, specialData, it, 'trOut2', extraList) * -1
                }

                // backList1 退货 标准
                if (!backList1[tDate]) { backList1[tDate] = [:] }
                backList1[tDate]['01'] = AllotDao.calcAllotAmount(backData1, tDate, '01', 'back1', extraList) * -1
                backList1[tDate]['02'] = AllotDao.calcAllotAmount(backData1, tDate, '02', 'back1', extraList) * -1
                backList1[tDate]['03'] = AllotDao.calcAllotAmount(backData1, tDate, '03', 'back1', extraList) * -1
                backList1[tDate]['04'] = AllotDao.calcAllotAmount(backData1, tDate, '04', 'back1', extraList) * -1
                backList1[tDate]['05'] = AllotDao.calcAllotAmount(backData1, tDate, '05', 'back1', extraList) * -1
                backList1[tDate]['06'] = AllotDao.calcAllotAmount(backData1, tDate, '06', 'back1', extraList) * -1
                backList1[tDate]['07'] = AllotDao.calcAllotAmount(backData1, tDate, '07', 'back1', extraList) * -1
                backList1[tDate]['others'] = AllotDao.calcAllotOthers(backData1, tDate, 'back1', extraList) * -1
                // backList2 退货 特殊
                spList.each {
                    if (!backList2[tDate]) { backList2[tDate] = [:] }
                    backList2[tDate][it] = AllotDao.calcAllotSpecial(backData2, tDate, specialData, it, 'back2', extraList) * -1
                }

                // 充值 
                rechargeList[tDate] = AllotDao.calcRechargeAmount(rechargeData, tDate)
                rechargeTotal = rechargeTotal + rechargeList[tDate]

                def cal = Calendar.getInstance()
                cal.setTime(_.string2Date(tDate))
                cal.add(Calendar.DATE, 1)
                tDate = _.date2String(cal.getTime(), 'yyyyMMdd')
            }

            // TODO: 合计
            insList1 = AllotDao.appendTotal(insList1)
            storList1 = AllotDao.appendTotal(storList1)
            trInList1 = AllotDao.appendTotal(trInList1)
            trOutList1 = AllotDao.appendTotal(trOutList1)
            backList1 = AllotDao.appendTotal(backList1)
            insList2 = AllotDao.appendSpecialTotal(insList2, spList)
            storList2 = AllotDao.appendSpecialTotal(storList2, spList)
            trInList2 = AllotDao.appendSpecialTotal(trInList2, spList)
            trOutList2 = AllotDao.appendSpecialTotal(trOutList2, spList)
            backList2 = AllotDao.appendSpecialTotal(backList2, spList)
        }
        
        def storeList = []
        def sql = _.sql
        def s = """
            select S_NO, S_NAME from STORE order by S_NO
        """
        sql.eachRow(s, []) {
            def foo = it.toRowResult()
            storeList << foo
        }

        [dateList: dateList, spList: spList, storeList: storeList
            , insList1: insList1, insList2: insList2
            , storList1: storList1, storList2: storList2
            , trInList1: trInList1, trInList2: trInList2
            , trOutList1: trOutList1, trOutList2: trOutList2
            , backList1: backList1, backList2: backList2
            , rechargeList: rechargeList, rechargeTotal: rechargeTotal]
    }


    def allotDetail() {
        def list = []
        def specialData = AllotDao.getSpecialData(params.sno)
        if (params.data == 'ins1') {
            def insData = AllotDao.getInsData(params.sno, params.date, params.date)
            list = AllotDao.filterNonSpecialList(insData, specialData)
        } else if (params.data == 'stor1') {
            def storData = AllotDao.getStorData(params.sno, params.date, params.date)
            list = AllotDao.filterNonSpecialList(storData, specialData)
        } else if (params.data == 'trIn1') {
            def trInData = AllotDao.getTrInData(params.sno, params.date, params.date)
            list = AllotDao.filterNonSpecialList(trInData, specialData)
        } else if (params.data == 'trOut1') {
            def trOutData = AllotDao.getTrOutData(params.sno, params.date, params.date)
            list = AllotDao.filterNonSpecialList(trOutData, specialData)
        } else if (params.data == 'back1') {
            def backData = AllotDao.getBackData(params.sno, params.date, params.date)
            list = AllotDao.filterNonSpecialList(backData, specialData)
        } else if (params.data == 'ins2') {
            def insData = AllotDao.getInsData(params.sno, params.date, params.date)
            list = AllotDao.filterAllotSpecialList(insData, params.date, specialData, params.sp)
        } else if (params.data == 'stor2') {
            def storData = AllotDao.getStorData(params.sno, params.date, params.date)
            list = AllotDao.filterAllotSpecialList(storData, params.date, specialData, params.sp)
        } else if (params.data == 'trIn2') {
            def trInData = AllotDao.getTrInData(params.sno, params.date, params.date)
            list = AllotDao.filterAllotSpecialList(trInData, params.date, specialData, params.sp)
        } else if (params.data == 'trOut2') {
            def trOutData = AllotDao.getTrOutData(params.sno, params.date, params.date)
            list = AllotDao.filterAllotSpecialList(trOutData, params.date, specialData, params.sp)
        } else if (params.data == 'back2') {
            def backData = AllotDao.getBackData(params.sno, params.date, params.date)
            list = AllotDao.filterAllotSpecialList(backData, params.date, specialData, params.sp)
        }
        if (params.catg == 'special') {
            // pass, do nothing
        } else if (params.catg == 'others') {
            list = AllotDao.filterAllotOthersList(list, params.date)
        } else {
            list = AllotDao.filterAllotList(list, params.date, params.catg)
        }
        def extraList = AllotDao.getExtraData(params)
        [list: list, extraList: extraList]
    }

    def allotDetailDel() {
        IwillAllot.get(params.del).delete()
        redirect(action: 'allotDetail', params: params)
    }

    def allotDetailSave() {
        def foo = params
        def bar = 0
        try {
            bar = Double.valueOf(params.amount)
        } catch(Exception e) {
            // DO NOTHING
        }
        foo.amount = bar
        foo.sp = (params.sp) ? params.sp : 'X'
        def a = new IwillAllot(foo)
        a.save()
        
        redirect(action: 'allotDetail', params: params)
    }
}
