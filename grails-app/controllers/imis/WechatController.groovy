package imis

import me.chanjar.weixin.common.util.*
import me.chanjar.weixin.common.api.*
import iwill.*
import grails.converters.*

class WechatController extends BaseController {

    def wx


    def get_access_token() {
        println request.remoteAddr

        def result = [:]
        result['accessToken'] = wx.wxService.getAccessToken()
        result['expiresTime'] = wx.wxConfig.getExpiresTime()
        render result as JSON
    }

    def index() {
        println params
        if (!wx.wxService.checkSignature(params.timestamp, params.nonce, params.signature)) {
            println 'invalid request' //  not from weixin
            return
        }

        if (StringUtils.isNotBlank(params.echostr)) {
            render params.echostr
            return
        }
        render wx.parse(request, params)
    }

    def unbind() {
        def it = IwillWechatUser.findByOpenId(session.user.openId)
        it.vipNo = ''
        it.save()
        session.user.vipNo = ''
        redirect(action: 'my')
    }

    def my() {
        def result = [:]
        if (params.code) {
            def oauthToken = wx.wxService.oauth2getAccessToken(params.code)
            def wxUser = wx.wxService.oauth2getUserInfo(oauthToken, null)

            def user = IwillWechatUser.findByOpenId(wxUser.openId)
            if (!user) {
                user = new IwillWechatUser()
                user.openId = wxUser.openId
            }
            user.nickname = wxUser.nickname
            user.sex = wxUser.sex
            user.city = wxUser.city
            user.province = wxUser.province
            user.country = wxUser.country
            user.headImgUrl = wxUser.headImgUrl
            user.save()
            session.user = [openId: wxUser.openId, nickname: wxUser.nickname, sex: wxUser.sex, headImgUrl: wxUser.headImgUrl, vipNo: user.vipNo]
        } else if (!session.user) {
            def url = wx.wxService.oauth2buildAuthorizationUrl("http://221.224.213.130/imis/wechat/my", WxConsts.OAUTH2_SCOPE_USER_INFO, null)
            redirect(url: url)
            return
        } else if (params.bind == 'vip') {
            def sql = _.sql
            def s = """
                select CC_NO
                from CUST_V 
                where CONVERT(NVARCHAR(MAX),DecryptByPassPhrase('Secret_key',C_MOB)) = ?
                and CONVERT(NVARCHAR(MAX),DecryptByPassPhrase('Secret_key',C_BIRTH)) = ?
            """
            def row = sql.firstRow(s, [params.phone, params.bday])
            if (row) {
                // update IwillWechatUser
                def it = IwillWechatUser.findByOpenId(session.user.openId)
                it.vipNo = row.CC_NO
                it.save()
                // assign variable to session.user
                session.user.vipNo = row.CC_NO 
            } else {
                result.msg = '查无此手机号码与生日!'
            }
        }
        // if bind get vip information
        if (session.user.vipNo) {
            def sql = _.sql
            // 基本信息
            def s = """
                select C_NO, CC_NO, CONVERT(NVARCHAR(MAX),DecryptByPassPhrase('Secret_key',C_NAME)) AS C_NAME 
                , CONVERT(NVARCHAR(MAX),DecryptByPassPhrase('Secret_key',C_BIRTH)) AS bday
                , CONVERT(NVARCHAR(MAX),DecryptByPassPhrase('Secret_key',C_MOB)) AS C_MOB
                , C_POINT, POINT_TY, C_LAST, C_TAMT
                from CUST_V a left join  STORE b on a.S_NO=b.S_NO
                where CC_NO = ? 
            """
            def row = sql.firstRow(s, [session.user.vipNo])
            result.summary = [:]
            result.summary.CC_NO = row.CC_NO
            result.summary.C_NAME = _.bufferedReader2String(row.C_NAME.characterStream)
            result.summary.bday = _.bufferedReader2String(row.bday.characterStream)
            result.summary.C_MOB = _.bufferedReader2String(row.C_MOB.characterStream)
            result.summary.C_POINT = row.C_POINT
            result.summary.POINT_TY = row.POINT_TY
            result.summary.C_LAST = row.C_LAST
            result.summary.C_TAMT = row.C_TAMT
            // 消费明细
            result.rows = []
            s = """
                select a.SL_KEY, a.RECNO, a.SL_DATE, a.SL_QTY, a.SL_PRICE, a.SL_AMT, a.SL_TAXAMT, a.SL_DISC_AMT, b.P_NAME, c.S_NAME
                from SALE_D a 
                left join PART b ON a.P_NO = b.P_NO
                left join STORE c ON a.S_NO = c.S_NO
                WHERE a.SL_KEY in (select top 10 SL_KEY from POINT_V_LOG where cc_no = ? order by PTL_NO desc)
                order by a.SL_DATE desc, ID_NO, SL_NO
            """
            def lastSlkey = ''
            def color = 0
            sql.eachRow(s, [session.user.vipNo]) {
                def foo = it.toRowResult()
                if (lastSlkey == '' || lastSlkey != foo.SL_KEY) {
                    color = (color + 1) % 2
                }
                foo.color = color
                result.rows << foo
                lastSlkey = foo.SL_KEY
            }
        }

        return result
    }

    def test() {
    
    }

    def demo() {}

    def token() {
        render wx.wxService.getAccessToken()
    }


    def hello() {
        render "Hello, World!"
    }
}
