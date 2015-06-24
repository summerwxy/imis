package imis

import iwill.*
import grails.converters.*
import groovy.json.*

class ApiController extends BaseController {

    def key = '122b359a-f6e2-4238-81b1-67fa5c8f14fc'

    def index() {
        render 'Hello'
    }

    // 傳入 key, account, password
    def login() {
        def result = ['status': false]
        if (params.key == null) {
            result.message = '缺少参数: key'
            result.errorCode = 1
        } else if (params.account == null) {
            result.message = '缺少参数: account'
            result.errorCode = 2
        } else if (params.password == null) {
            result.message = '缺少参数: password'    
            result.errorCode = 3
        } else if (params.key != key) {
            result.message = 'key 錯誤'
            result.errorCode = 4
        }
        // 如果有錯誤 顯示錯誤信息
        if (result.errorCode) {
            render result as JSON
            return
        }

        // 用 卡號+生日 驗證
        def sql = _.sql
        def s = """
            select CONVERT(NVARCHAR(MAX), DecryptByPassPhrase('Secret_key', C_NAME)) AS C_NAME, C_POINT, C_NO, CC_NO
            from CUST_V 
            where CC_NO = ? and CONVERT(NVARCHAR(MAX), DecryptByPassPhrase('Secret_key', C_BIRTH)) = ?
        """
        def row = sql.firstRow(s, [params.account, params.password])
        if (row) {
            result.status = true
            result.message = '验证成功'
            result.name = _.bufferedReader2String(row.C_NAME.characterStream) 
            result.point = row.C_POINT
            result.vip_no = row.C_NO
            result.card_no = row.CC_NO
            render result as JSON
            return
        }

        // 用 電話+密碼 驗證
        s = """
            select CONVERT(NVARCHAR(MAX), DecryptByPassPhrase('Secret_key', C_NAME))AS C_NAME, C_POINT, C_NO, CC_NO
            from CUST_V 
            where CONVERT(NVARCHAR(MAX), DecryptByPassPhrase('Secret_key', C_MOB)) = ?
        """
        row = sql.firstRow(s, [params.account])
        if (row) {
            // 去 C&C 查資料
            def mctKey = '086f3eb3-d1f1-4607-9bd3-fa2843025a7f1'
            def foo = "http://221.228.197.77:8011/MCTService.asmx/CCP_CHECK_MemberInfo?account=${params.account}&password=${URLEncoder.encode(params.password)}&mctKey=${mctKey}".toURL().text
            def slurper = new JsonSlurper()
            foo = foo.replaceAll("<[^>]*>", "") // remove xml tag
            def bar = slurper.parseText(foo)
            if (bar.Status) {
                result.status = true
                result.message = '验证成功'
                result.name = _.bufferedReader2String(row.C_NAME.characterStream)
                result.vip_no = row.C_NO
                result.card_no = row.CC_NO                
                result.point = row.C_POINT
            } else {
                result.message = bar.Msg
                result.errorCode = 5
            }
            render result as JSON
            return
        }

        result.message = '无此账号与密码'   
        result.errorCode = 6
        render result as JSON
    }



}
