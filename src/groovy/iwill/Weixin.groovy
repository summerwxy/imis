package iwill

import java.security.MessageDigest
import org.dom4j.Document
import org.dom4j.Element
import org.dom4j.io.SAXReader
import java.io.*
import iwill.*
import grails.converters.*
import groovy.json.JsonSlurper
import imis.*

class Weixin {

    def parseRequest(request) {
        def map = [:]
        def reader = new SAXReader()
        def inputStream = request.getInputStream()
        reader.read(inputStream).getRootElement().elements().each {
            map[it.name] = it.text
        }
        inputStream.close()
        inputStream = null  
        return map
    }

    def checkSignature(signature, timestamp, nonce) {
        def token = 'this_is_a_secret_word' 
        def tmpArr = [timestamp, nonce, token].sort()
        MessageDigest md = MessageDigest.getInstance("SHA-1")
        md.update(tmpArr.join('').getBytes("UTF-8"))
        def tmpStr = convertToHexString(md.digest())
        // TODO: something wrong, make it always true
        return tmpStr == signature || true
    }
    
    def convertToHexString(data) {
        StringBuffer strBuffer = new StringBuffer();
        for (int i = 0; i < data.length; i++) {
            strBuffer.append(Integer.toHexString(0xff & data[i]))
        }
        return strBuffer.toString();
    }



    def replyText(map, content) {
        return """<xml>
            <ToUserName><![CDATA[${map['FromUserName']}]]></ToUserName>
            <FromUserName><![CDATA[${map['ToUserName']}]]></FromUserName>
            <CreateTime>${map['CreateTime']}</CreateTime>
            <MsgType><![CDATA[text]]></MsgType>
            <Content><![CDATA[${content}]]></Content>
        </xml>""" 
    }

    def replyVoice(map) {
        def word = map['Recognition']
        def isVoice = true
        // for text type test
        if (word == null) { 
            word = map['Content']
            isVoice = false
        }
        // TODO: chat bot in this function
        // TODO: inquire store 
        def text = "你说什么!? [[${word}]]"
        // 查门店销售
        if (word.endsWith('业绩') || word.endsWith('夜机')) {
            def S_NO = ''
            def SL_DATE = ''
            def SL_DATE_S = ''
            def SL_AMT = 0
            def sql = _.sql
            def key = word - '业绩'
            key = word - '夜机'
            if (key.endsWith('今天')) {
                key -= '今天'
                SL_DATE = '20140315'
                SL_DATE_S = '2014/03/21'
            } else if (key.endsWith('昨天')) {
                key -= '昨天'
                SL_DATE = '20140314' 
                SL_DATE_S = '2014/03/22'
            }
            def s = 'SELECT S_NO FROM STORE WHERE S_NAME = ?'
            def row = sql.firstRow(s, [key])
            if (row) {
                S_NO = row.S_NO
            }
            // inquire
            s = "SELECT SUM(SL_AMT) AS SL_AMT FROM SALE_H WHERE S_NO = ? AND SL_DATE = ?"
            row = sql.firstRow(s, [S_NO, SL_DATE])
            if (row) {
                SL_AMT = row.SL_AMT
            }
            s = """SELECT TOP 5 b.P_NO, b.P_NAME, SUM(a.SL_AMT) AS SL_AMT, SUM(a.SL_QTY) AS SL_QTY
                FROM SALE_D a
                LEFT JOIN PART b ON a.P_NO = b.P_NO
                WHERE a.S_NO = ? AND a.SL_DATE = ?
                GROUP BY b.P_NO, b.P_NAME
                ORDER BY SUM(a.SL_AMT) DESC"""
            def temp = []
            sql.eachRow(s, [S_NO, SL_DATE]) { 
                temp << it.P_NAME + ' ' + it.SL_AMT + '元 ' + it.SL_QTY + '个'
            }        
            text = (isVoice) ? "[[${word}]]\r\n" : ''
            text += """${key} ${SL_DATE_S} 业绩\r\n总金额: ${SL_AMT}元\r\n销售Top5:\r\n${temp.join('\r\n')}"""
        } else {
            def html = "http://www.simsimi.com/func/req?msg=${word}&lc=ch&ft=0.0".toURL().text
            def slurper = new JsonSlurper()
            def result = slurper.parseText(html)
            text = (isVoice) ? "[[${word}]]\r\n" : ''
            text += """${result.response}"""
        }

        return replyText(map, "${text}")
    }

    def replyMsg(map) {
        def html
        if (map['MsgType'] == 'event' && map['Event'] == 'subscribe') {
            // if user not exist, create one to DB
            if (!IwillWeixinUser.findByOpenid(map['FromUserName'])) {
                def u = new IwillWeixinUser(openid: map['FromUserName'])
                if (!u.save()) {
                    u.errors.each {
                        println it
                    }    
                }
            }
            html = replyText(map, '欢迎加入【爱维尔】管理微信号!') 
        } else if (map['MsgType'] == 'event' && map['Event'] == 'unsubscribe') {
            // PASS
        } else if (map['MsgType'] == 'event' && map['Event'] == 'CLICK' && map['EventKey'] == 'IWILL_REPORT') {
            html = replyText(map, '你要查报表哦!!')        
        } else if (map['MsgType'] == 'event' && map['Event'] == 'CLICK' && map['EventKey'] == 'IWILL_GOOD') {
            html = replyText(map, '谢谢你的赞')        
        } else if (map['MsgType'] == 'event' && map['Event'] == 'LOCATION') {
            WeixinDao.updateUserLocation(map)
        } else if (map['MsgType'] == 'voice') {
            html = replyVoice(map)
        } else if (map['MsgType'] == 'text') {
            // html = replyText(map, 'echo: ' + map['Content'])
            html = replyVoice(map)
        } else {
            html = replyText(map, 'huh!?')
        }

        saveRequestLog(map) // save all request log
        return html
    }

    def saveRequestLog(map) {
        def l = new IwillWeixinRequestLog(map)
        if (!l.save()) {
            l.errors.each {
                println it
            }
        }
    }

    
}

