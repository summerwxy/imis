package imis

import grails.transaction.Transactional
import grails.util.Environment
import me.chanjar.weixin.cp.api.*
import me.chanjar.weixin.common.util.*
import me.chanjar.weixin.cp.bean.*
import me.chanjar.weixin.common.session.*
import me.chanjar.weixin.common.api.*
import me.chanjar.weixin.cp.util.crypto.*
import grails.util.GrailsUtil

@Transactional
class WechatCpZqlhService {




    private __corpId = "wxb4bb14c7ee62b17a"
    private __corpSecret = "PUOk0teK9huTxJvSbGUHxl-gCUObB6WTMnLK0oDgU4yYDFeOmWa8QKddh1OQAXfx"
    private __agentId_dev = "22"
    private __agentId = "23"
    private __token = "kqSVRLYrqtYOsX9eb5SH"
    private __aesKey = "7kgOqeQqSDgWHncGStRLmWwgWG47vu5vDwRpengnRfa"

    private __wxConfig
    def getWxConfig() {
        if (!__wxConfig) {
            __wxConfig = new WxCpInMemoryConfigStorage()
            __wxConfig.setCorpId(__corpId)
            __wxConfig.setCorpSecret(__corpSecret)
            if(GrailsUtil.getEnvironment() == "development") {
                __wxConfig.setAgentId(__agentId_dev)
            } else {
                __wxConfig.setAgentId(__agentId)
            }
            __wxConfig.setToken(__token)
            __wxConfig.setAesKey(__aesKey)
        }
        return __wxConfig
    }
    private __wxService
    def getWxService() {
        if (!__wxService) {
            __wxService = new WxCpServiceImpl()
            __wxService.setWxCpConfigStorage(wxConfig)
        }
        return __wxService
    }
    private __wxCryptUtil
    def getWxCryptUtil() {
        if (!__wxCryptUtil) {
            __wxCryptUtil = new WxCpCryptUtil(wxConfig)
        }
        return __wxCryptUtil
    }


}
