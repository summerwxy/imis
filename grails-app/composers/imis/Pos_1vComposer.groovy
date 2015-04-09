package imis

import org.zkoss.zk.grails.composer.*

import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.event.*
import org.zkoss.zul.*
import org.zkoss.zk.ui.select.*
import iwill.*

class Pos_1vComposer extends GrailsComposer {

    def lb1
    def lb2
    def lb3
    def muno = '11MU000001'

    @Listen("onClick = #lb1")
    public void lb1_onClick(Event event) {
        def dno = lb1.selectedItem.children[1].label
        def sql = _.sql
        def list = []
        def s = """
            SELECT a.RECNO, b.P_NO, b.P_NAME
            FROM PART_MENU_DD a
            LEFt JOIN PART b ON a.DD_NO = b.P_NO
            WHERE a.MU_NO = ? AND a.D_NO = ?
            ORDER BY RECNO
        """
        sql.eachRow(s, [muno, dno]) {
            list << it.toRowResult()
        }
        lb2.model = new ListModelList(list)
    }


    @Listen('onClick = #lb2')
    public void lb2_onClick(Event event) {
        def pno = lb2.selectedItem.children[1].label
        def sql = _.sql
        def list = []
        def s = """
            SELECT b.S_NAME, a.PS_QTY 
            FROM PART_S a
            LEFT JOIN STORE b ON a.S_NO = b.S_NO
            WHERE a.P_NO = ?
            AND a.PS_QTY <> 0
            ORDER BY b.S_NAME
        """
        sql.eachRow(s, [pno]) {
            list << it.toRowResult()
        }
        lb3.model = new ListModelList(list)
    }

    def afterCompose = { window ->
        // initialize components here

        // render PART_MENU_D list
        def sql = _.sql
        def list = []
        def s = """
            SELECT a.RECNO, a.D_NO, b.D_CNAME
            FROM PART_MENU_D a
            LEFT JOIN DEPART b ON a.D_NO = b.D_NO
            WHERE a.MU_NO = ? 
            ORDER BY a.RECNO
        """
        sql.eachRow(s, [muno]) {
            list << it.toRowResult()
        }
        lb1.model = new ListModelList(list)
        
        
    }
}
