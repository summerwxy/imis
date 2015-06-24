package imis

import grails.converters.*

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

}
