package imis

import org.zkoss.zk.grails.composer.*

import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.event.*
import org.zkoss.zul.*
import iwill.*

class Iwill_003Composer extends GrailsComposer {

    def g1
    def s = """
        SELECT a.S_NO, a.S_NAME, ISNULL(b.bake, 0) AS bake, ISNULL(b.mount, 0) AS mount, ISNULL(b.bar, 0) AS bar, ISNULL(b.custom_view, 0) AS custom_view, ISNULL(b.ip, '') AS ip, a.S_IP, ISNULL(b.lat, 0) AS lat, ISNULL(b.lng, 0) AS lng
        FROM STORE a 
        LEFT JOIN iwill_store b ON a.S_NO = b.s_no
        WHERE NOT a.R_NO IN ('8991', '8992', '8981')
        AND a.S_STATUS = '1'
        ORDER BY a.S_NO
    """
    def afterCompose = { window ->
        // initialize components here
        def result = []
        def sql = _.sql
        sql.eachRow(s, []) {
            result << it.toRowResult()
        }
        g1.model = new ListModelList(result)
    }

    @Listen("onClick = button")
    def onClickButton(MouseEvent event) {
        // get DB settings
        def data = [:]
        def sql = _.sql
        sql.eachRow(s, []) {
            data[it.S_NO] = ['bake': it.bake, 'mount': it.mount, 'bar': it.bar, 'custom_view': it.custom_view, 'ip': it.ip, 'lat': it.lat, 'lng': it.lng]
        }
        // save checkbox data
        def cbs = $('#g1 checkbox')
        cbs.each {
            def foo = it.value.tokenize('.')
            if (it.checked != data[foo[0]][foo[1]]) {
                // insert if not exist
                sql.execute("IF NOT EXISTS (SELECT * FROM iwill_store WHERE S_NO = ?) INSERT INTO iwill_store(version, bake, bar, mount, s_no) values(0, 0, 0, 0, ?)", [foo[0], foo[0]])
                // update
                sql.execute("UPDATE iwill_store SET ${foo[1]} = ? WHERE S_NO = ?", [it.checked, foo[0]])
            }
        }
        // save textbox
        def tbs = $('#g1 textbox') 
        tbs.each {
            def foo = it.name.tokenize('.')
            if (it.value != data[foo[0]][foo[1]]) {
                // update    
                sql.execute("UPDATE iwill_store SET ${foo[1]} = ? WHERE S_NO = ?", [it.value, foo[0]])
            }
        }
        // done
        Messagebox.show('DONE')
    }

}
