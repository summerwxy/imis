package imis

import org.zkoss.zk.grails.composer.*

import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.event.*


class IndexComposer extends GrailsComposer {

    def afterCompose = { window ->
        // initialize components here
    }


    def onClick_buttonStore(Event event) {
        desktop.execution.sendRedirect('store.zul')
    }

    def onClick_buttonPart(Event event) {
        desktop.execution.sendRedirect('part.zul')
    }

    def onClick_buttonPos6l(Event event) {
        desktop.execution.sendRedirect('pos_6l.zul')
    }

    def onClick_buttonPos1v(Event event) {
        desktop.execution.sendRedirect('pos_1v.zul')
    }

    def onClick_buttonIwill001(Event event) {
        desktop.execution.sendRedirect('iwill_001.zul')
    }

    def onClick_buttonIwill002(Event event) {
        desktop.execution.sendRedirect('iwill_002.zul')
    }

    def onClick_buttonIwill003(Event event) {
        desktop.execution.sendRedirect('iwill_003.zul')
    }

}
