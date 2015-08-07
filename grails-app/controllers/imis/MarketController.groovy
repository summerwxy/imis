package imis

import grails.converters.*
import iwill.*
import groovy.json.*

class MarketController extends BaseController {

    def index() { }

    def map1() {
        def data = [:]
        IwillStoreMap.list().each { it ->
            data[it.uid] = it
        }
        [data: data as JSON]
    }

    def map1_info_save() {
        def msg = ''
        if (params.uid) {
            def l = IwillStoreMap.findByUid(params.uid)
            if (!l) {
                l = new IwillStoreMap()
                l.uid = params.uid 
            }
            l.name = params.name ?: ''
            l.lat = params.lat.toFloat()
            l.lng = params.lng.toFloat()
            l.tag = params.tag ?: ''
            l.address = params.address ?: ''
            l.phone = params.phone ?: ''
            l.save(flush: true) 
            msg = 'ok' 
        }
        render (contentType: 'text/json') {[status: msg, lat: params.lat, lng: params.lng]}
    }


    def list_mooncake() {
        def list = []
        def sql = _.sql
        def s = """
            select a.*, b.GI_P_NO, b.BACK_NUM, b.GT_NO, c.P_NAME
            from mooncake_express a
            left join GIFT_TOKEN b on a.vid = b.vid
            left join PART c ON b.GI_P_NO = c.P_NO
            order by id desc
        """
        sql.eachRow(s, []) { 
            list << it.toRowResult()
        }         

        [list: list]         
    }

    def save_express_no() {
        def me = MooncakeExpress.get(params.id)
        me.expressNo = params.express_no
        me.save()
        render (contentType: 'text/json') {[status: 'okay']}
    }

    def mooncake() {
        def vid = flash.vid ?: ''
        def pno = flash.pno ?: ''
        def name = flash.name ?: ''
        def phone = flash.phone ?: ''
        def address = flash.address ?: ''
        def einfo = []
        if (params.vid) { // 扫码来的
            def sql = _.sql
            def s = """
                select a.GI_P_NO, b.* 
                from GIFT_TOKEN a
                left join mooncake_express b on a.vid = b.vid
                where a.vid = ?
            """
            def row = sql.firstRow(s, [params.vid])
            if (row) {            
                vid = params.vid
                pno = row.GI_P_NO
                name = row.name
                phone = row.phone
                address = row.address
            } else {
                render '无效访问！' // AD page ?
                return
            }     
            if (row.express_no) {
                // 有快递单号 
                def foo = "http://api.ickd.cn/?id=111892&secret=6e74148738da2310af3b0a247524a0e6&com=yuantong&encode=utf8&nu=${row.express_no}".toURL().text
                def slurper = new JsonSlurper()
                einfo = slurper.parseText(foo)                    
            }

        } else if (!params.vid && !params.code && !flash.vid) {
            render '无效访问！！' // AD page ?
            return
        } else if (params.act in ['兑换', '更新信息']) { // 兑换 / 更新信息
            def sql = _.sql
            def s = "select * from mooncake_express where vid = ?"
            def row = sql.firstRow(s, [params.code])
            if (row) {
                s = "update mooncake_express set name = ?, phone = ?, address = ? where vid = ?"
                sql.execute(s, [params.name, params.phone, params.address, params.code])
                flash.msg = "更新成功！"
            } else {
                s = "insert into mooncake_express(version, name, phone, address, vid, status, express_no, date_created, last_updated) values(0, ?, ?, ?, ?, 'init', '', GETDATE(), GETDATE())"
                sql.execute(s, [params.name, params.phone, params.address, params.code])
                flash.msg = "兑换成功！"
            }
            flash.vid = params.code
            flash.pno = params.pno
            flash.name = params.name
            flash.phone = params.phone
            flash.address = params.address
            redirect(action: 'mooncake')
        } 

        [vid: vid, pno: pno, name: name, phone: phone, address: address, einfo: einfo]
    }


}
