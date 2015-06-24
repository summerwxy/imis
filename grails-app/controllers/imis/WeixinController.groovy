package imis
import java.security.MessageDigest
import java.io.*
import iwill.*
import grails.converters.*
import groovy.json.JsonSlurper

class WeixinController extends BaseController {

    def index() {
        println '-----------------------------'
        def wx = new Weixin()
        if (!wx.checkSignature(params.signature, params.timestamp, params.nonce)) {
            println 'check failed'
            render 'Not from Weixin'
            return
        }
        // for api url valid
        if (params.echostr) {
            println 'echo'
            render params.echostr
            return
        }
        request.setCharacterEncoding("UTF-8")
        response.setCharacterEncoding("UTF-8")

        def map = wx.parseRequest(request) 

        println params
        println map
        // render wx.replyMsg(map)
        render wx.replyText(map, "you said: " + map.Content)
    }


    def page() {
    }


    def store() {
        def list = []
        def sql = _.sql

        def s = "select S_NO, S_NAME, S_TEL, S_ADDR from store where S_ADDR <> '' and S_STATUS = '1' order by S_NAME"
        sql.eachRow(s, []) {
            list << it.toRowResult()
        }
        def extData = [:]
        extData['8027012'] = [lat: 31.310700, lng: 120.618110] // 大爱店
        extData['8022005'] = [lat: 31.293070, lng: 120.561580] // 狮山店
        extData['8024015'] = [lat: 31.265410, lng: 120.605960] // 四季晶华店
        extData['8021001'] = [lat: 31.166780, lng: 120.646720] // 中山店
        extData['8026003'] = [lat: 31.314040, lng: 120.673590]  // 左岸店        

        [list: list, extData: extData]
    }

    // use this url get access token
    // https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxb3235f51f36fe4c8&secret=d18c8415266c1aa47684460712b30e33
}
