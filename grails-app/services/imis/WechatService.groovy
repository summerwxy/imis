package imis

import grails.util.Environment
import grails.transaction.Transactional
import me.chanjar.weixin.mp.api.*
import me.chanjar.weixin.common.util.*
import me.chanjar.weixin.mp.bean.*
import me.chanjar.weixin.common.session.*
import me.chanjar.weixin.common.api.*

@Transactional
class WechatService {

   private __wxRouter
    def getWxRouter() {
        if (!__wxRouter || Environment.current != Environment.PRODUCTION) { // 开发时, 每次都要新增
            __wxRouter = new WxMpMessageRouter(wxService)
            // 使用方法: http://tinyurl.com/qhloo95
            // WxConsts: http://tinyurl.com/lp6hyau

            // ========== msgType='event', event='subscribe' ==========
            __bindSubscribe()
            // ========== msgType='event', event='LOCATION' ==========
            __bindLocation()
            // ========= 点赞 event = CLICK_LIKE =========
            __bindClickLike()
            // ========= 连到任何网页 ==========
            __bindViewAll()
            // ========= test ==========
            __bindTest()
            // ========= catch all ==========
            __bindCatchAll()
        }
        return __wxRouter
    }


    def sendText(wxMessage, text) {
        return WxMpXmlOutMessage.TEXT().content(text).fromUser(wxMessage.getToUserName()).toUser(wxMessage.getFromUserName()).build()
    }
    

    def parse(request, params) {
        def encryptType = StringUtils.isBlank(params.encrypt_type) ? "raw" : params.encrypt_type
        if ("raw".equals(encryptType)) { // 明文传输的消息
          def inMsg = WxMpXmlMessage.fromXml(request.getInputStream())
          def outMsg = wxRouter.route(inMsg)
          return (!!outMsg) ? outMsg.toXml() : ""
        }

        if ("aes".equals(encryptType)) { // 是aes加密的消息
          def inMsg = WxMpXmlMessage.fromEncryptedXml(request.getInputStream(), wxConfig, params.timestamp, params.nonce, params.msg_signature)
          def outMsg = wxRouter.route(inMsg)
          return (!!outMsg) ? outMsg?.toEncryptedXml(wxConfig) : ""
        }

        return "unknow encrypt type"

    }

    def __bindSubscribe() {
        def handler = new WxMpMessageHandler() {
            @Override
            public WxMpXmlOutMessage handle(WxMpXmlMessage wxMessage, Map<String, Object> context, WxMpService wxMpService, WxSessionManager wxSessionManager) {
                return sendText(wxMessage, "欢迎关注爱维尔公众号")
            }
        }
        __wxRouter.rule()
            .async(false)
            .msgType(WxConsts.XML_MSG_EVENT)
            .event(WxConsts.EVT_SUBSCRIBE)
            .handler(handler)
        .end()
    }

    def __bindLocation() {
        def handler = new WxMpMessageHandler() {
            @Override
            public WxMpXmlOutMessage handle(WxMpXmlMessage wxMessage, Map<String, Object> context, WxMpService wxMpService, WxSessionManager wxSessionManager) {
                println 'LOCATION'
            }
        }
        __wxRouter.rule()
            .msgType(WxConsts.XML_MSG_EVENT)
            .event(WxConsts.EVT_LOCATION)
            .handler(handler)
        .end()
    }

    def __bindClickLike() {
        def handler = new WxMpMessageHandler() {
            @Override
            public WxMpXmlOutMessage handle(WxMpXmlMessage wxMessage, Map<String, Object> context, WxMpService wxMpService, WxSessionManager wxSessionManager) {
                def it = IwillWechatClickLike.findByWxId(wxMessage.getFromUserName())
                if (!it) {
                    it = new IwillWechatClickLike()
                    it.wxId = wxMessage.getFromUserName()
                    it.times = 0
                }
                it.times = it.times + 1
                it.save()
                return sendText(wxMessage, "谢谢你第 ${it.times} 次的赞!")
            }
        }
        __wxRouter.rule()
            .async(false)
            .msgType(WxConsts.XML_MSG_EVENT)
            .event(WxConsts.EVT_CLICK)
            .eventKey("CLICK_LIKE")
            .handler(handler)
        .end()
    }

    def __bindViewAll() {
        def handler = new WxMpMessageHandler() {
            @Override
            public WxMpXmlOutMessage handle(WxMpXmlMessage wxMessage, Map<String, Object> context, WxMpService wxMpService, WxSessionManager wxSessionManager) {
                println wxMessage.getFromUserName() + ' open view -> ' + wxMessage.eventKey

            }
        }
        __wxRouter.rule()
            .msgType(WxConsts.XML_MSG_EVENT)
            .event(WxConsts.EVT_VIEW)
            .handler(handler)
        .end()    
    }

    def __bindTest() {
        def handler = new WxMpMessageHandler() {
            @Override 
            public WxMpXmlOutMessage handle(WxMpXmlMessage wxMessage, Map<String, Object> context, WxMpService wxMpService, WxSessionManager wxSessionManager) {
                def m = WxMpXmlOutMessage.TEXT().content("测试加密消息").fromUser(wxMessage.getToUserName()).toUser(wxMessage.getFromUserName()).build()
                return m
            }
        }
        __wxRouter.rule()
            .async(false)
            .content("哈哈")
            .handler(handler)
        .end()
    }

    def __bindCatchAll() {
        def handler = new WxMpMessageHandler() {
            @Override
            public WxMpXmlOutMessage handle(WxMpXmlMessage wxMessage, Map<String, Object> context, WxMpService wxMpService, WxSessionManager wxSessionManager) {
                println wxMessage
                println '---------------------'
                def m = WxMpXmlOutMessage.TEXT().content("catch_all").fromUser(wxMessage.getToUserName()).toUser(wxMessage.getFromUserName()).build()
                return m
            }
        }
        __wxRouter.rule()
            .async(false)
            .handler(handler)
        .end()
    }



    private __appId = "wxb3235f51f36fe4c8"
    private __secret = "7a879230c9c931338df16675a58df2fc"
    private __token = "this_is_a_secret_word"
    private __aesKey = ""
    private __wxConfig
    def getWxConfig() {
        if (!__wxConfig) {
            __wxConfig = new WxMpInMemoryConfigStorage()
            __wxConfig.setAppId(__appId)
            __wxConfig.setSecret(__secret)
            __wxConfig.setToken(__token)
            __wxConfig.setAesKey(__aesKey)
        }
        return __wxConfig
    }
    private __wxService
    def getWxService() {
        if (!__wxService) {
            __wxService = new WxMpServiceImpl()
            __wxService.setWxMpConfigStorage(wxConfig)
        }
        return __wxService
    }
    /*
    private __wxCryptUtil
    def getWxCryptUtil() {
        if (!__wxCryptUtil) {
            __wxCryptUtil = new 
        }
    }
    */

          
    


}
