package imis

import org.zkoss.zk.grails.composer.*

import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.event.*
import org.zkoss.zul.*
import iwill.*

class Iwill_001Composer extends GrailsComposer {
    
    def g1

    def afterCompose = { window ->
        // initialize components here
        def result = []
        def sql = _.sql
        def s = """
            SELECT b.S_NAME, a.SL_DATE, a.SL_TIME, a.SL_NO
            FROM SALE_H a
            LEFT JOIN STORE b ON a.S_NO = b.S_NO
            WHERE NOT a.SL_KEY IN (SELECT SL_KEY FROM SALE_D)
            AND a.SL_DATE >= CONVERT(CHAR, DATEADD(m, -3, GETDATE()), 112)
            ORDER BY b.S_NAME, a.SL_NO
        """
        sql.eachRow(s, []) {
            result << it.toRowResult()
        }
        g1.model = new ListModelList(result)

    }
}
