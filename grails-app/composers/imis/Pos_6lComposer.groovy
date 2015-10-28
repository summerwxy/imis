package imis

import org.zkoss.zk.grails.composer.*

import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.event.*
import org.zkoss.zul.*
import org.zkoss.zk.ui.select.*
import iwill.*


class Pos_6lComposer extends GrailsComposer {
  
    def t1, _lb1, l1
    def t2, _lb2, l2
    def db1, db2
    def g1

    def store_data = []
    def part_data = []

    @Listen("onChanging = #t1")
    public void t1_onChanging(Event event) {
        if (!store_data) {
            store_data = Dao.getStore()
        }
        def result = Filter.storeByKeyword(store_data, event.value.toLowerCase())
        _lb1.model = new ListModelList(result)
    }

    @Listen("onSelect = #lb1")
    public void lb1_onSelect(Event event) {
        def foo = _lb1.selectedItem.label
        t1.value = foo.split('-')[0].trim()
        l1.value = foo.split('-')[1].trim()
        t1.close() 
        
    }

    @Listen("onChanging = #t2")
    public void t2_onChanging(Event event) {
        if (!part_data) {
            part_data = Dao.getPart()
        }
        // _.tc2sc 不能用了
        // def result = Filter.partByKeyword(part_data, _.tc2sc(event.value.toString()).toLowerCase())
        def result = Filter.partByKeyword(part_data, event.value.toString().toLowerCase())
        _lb2.model = new ListModelList(result)
    }

    @Listen("onSelect = #lb2")
    public void lb2_onSelect(Event event) {
        def foo = _lb2.selectedItem.label
        t2.value = foo.split('-')[0].trim()
        l2.value = foo.split('-')[1].trim()
        t2.close() 
        
    }


    @Listen("onClick = #submit")
    public void submit_onClick(Event event) {
        if (!t1.value || !t2.value || !db1.value || !db2.value) {
            Messagebox.show("请输入完整查询条件!")
            return
        }
        def result = []
        def sql = _.sql
        def s = """
            select ps.S_NO, ps.P_NO, dbo.erosGetP_NAME(ps.P_NO) as P_NAME, ps.PS_QTY, lg.PSL_OLD_QTY, lg.PSL_CHG_QTY, lg.PSL_BILL_BNO
            , case lg.REMARK 
                when 'SALE' then '銷售单' 
                when 'INS' then '进货单' 
                when 'USELESS' then '库调单'
                when 'BACK' then '退货单' 
                when 'TRAN' then '调拨单' 
                when 'CO' then '盘点单'
                when 'PC' then '红利兑换'
                when 'UPDPNO' then '商品库存'
                when 'INS_BACK' then '进货回溯'
                when 'BAK_BACK' then '退货回溯' 
                when 'PA' then '组合拆解' 
                when 'SST' then '成品入库'
                when 'WP' then '分销出货' 
                when 'WB' then '分销退仓' 
                when 'SH' then '总仓出货'
                when 'SST_S' then '成品入库-扣原物料' 
                when 'ORDER' then '客订' 
                else dbo.erosGetMenu_Name(lg.REMARK) end REMARK, lg.PLS_DATE, lg.PLS_TIME
            from Part_s ps
            left join (select * from part_s_log lg 
                            where PLS_DATE >= ? AND PLS_DATE <= ? AND (PSL_OLD_QTY <> 0 OR PSL_CHG_QTY <> 0)
                            AND P_NO = ? AND S_NO = ?)lg on lg.S_NO = ps.S_NO and lg.P_NO = ps.P_NO
            where ps.S_NO = ? AND ps.P_NO = ? 
            order by ps.S_NO, ps.P_NO, lg.PLS_DATE, lg.PLS_TIME
        """
        sql.eachRow(s, [_.date2String(db1.value), _.date2String(db2.value), t2.value, t1.value, t1.value, t2.value]) {
            def store = it.toRowResult()
            result << store
        }
        if (result.size() == 0) {
            Messagebox.show("查无资料 !")
        } else {
            g1.model = new ListModelList(result)
        }
     }

    
    def afterCompose = { window ->
        // initialize components here
        _lb1 = Selectors.find(page, "#lb1")[0]
        _lb2 = Selectors.find(page, "#lb2")[0]


    }
}
