package imis


import me.chanjar.weixin.common.util.*
import me.chanjar.weixin.common.api.*
import grails.converters.*
import iwill.*
import groovy.json.*

import java.util.UUID;
import weixin.popular.api.PayMchAPI;
import weixin.popular.bean.paymch.Unifiedorder
import weixin.popular.bean.paymch.UnifiedorderResult
import weixin.popular.util.PayUtil
import weixin.popular.bean.paymch.MchBaseResult;
import weixin.popular.bean.paymch.MchPayNotify;
import weixin.popular.util.ExpireSet;
import weixin.popular.util.SignatureUtil;
import weixin.popular.util.XMLConverUtil;

import jxl.Workbook
import jxl.CellType
import jxl.write.Label
import jxl.write.Number
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import jxl.write.WritableCellFormat

class MarketController extends BaseController {

    def wx

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
            where ${params.show ? 'not' : ''} express_no = ''
            and act_no = '2016_spring'
            order by id desc
        """
        sql.eachRow(s, []) { 
            list << it.toRowResult()
        }         

        [list: list]         
    }

    def list_mooncake_g3() {
        def list = []
        def sql = _.sql
        def s = """
            select a.*, b.GI_P_NO, b.BACK_NUM, b.GT_NO, c.P_NAME
            from mooncake_express a
            left join GIFT_TOKEN b on a.vid = b.vid
            left join PART c ON b.GI_P_NO = c.P_NO
            where ${params.show ? 'not' : ''} express_no = ''
            and act_no = '2016_spring'
            order by id desc
        """
        sql.eachRow(s, []) { 
            list << it.toRowResult()
        }         

        [list: list]         
    }




    def list_mooncake2() {
        def list = []
        def sql = _.sql
        def s = """
            Set ARITHABORT ON

            select b.*, d.P_NAME, c.BACK_NUM, c.GT_NO
            into #aa
            from express_charge_body a 
            left join express_charge_head b on a.h_id = b.id
            left join GIFT_TOKEN c on a.vid = c.vid
            left join PART d on c.GI_P_NO = d.P_NO
            where c.BACK_SNO in ('', '802B002')
            order by b.id, d.P_NAME

            select t.id, t.name, t.phone, t.lv1, t.lv2, t.lv3, t.address, t.express_no, t.fee, t.kg, t.status
            , STUFF(ISNULL((SELECT ', ' + x.P_NAME + ' * ' + CAST(COUNT(*) AS VARCHAR(20)) FROM #aa x WHERE x.id = t.id GROUP BY x.P_NAME FOR XML PATH (''), TYPE).value('.','VARCHAR(max)'), ''), 1, 2, '') AS boxs
            , STUFF(ISNULL((SELECT ', ' + x.GT_NO + ' ' + CASE WHEN x.BACK_NUM > 0 THEN '已提货' ELSE '未提货' END FROM #aa x WHERE x.id = t.id GROUP BY x.GT_NO, x.BACK_NUM FOR XML PATH (''), TYPE).value('.','VARCHAR(max)'), ''), 1, 2, '') AS tickets
            from #aa t
            where status <> ''
            and ${params.show ? 'not' : ''} express_no = ''
            group by t.id, t.name, t.phone, t.lv1, t.lv2, t.lv3, t.address, t.express_no, t.fee, t.kg, t.status
            order by t.id desc
        """
        sql.eachRow(s, []) {
            def foo = it.toRowResult()
            foo.boxs = _.bufferedReader2String(it.boxs.characterStream)
            foo.tickets = _.bufferedReader2String(it.tickets.characterStream)
            foo.fee = it.fee.toInteger()
            foo.kg = Math.round(it.kg * 1000) / 1000
            foo.ticketsList = foo.tickets.split(', ')
            list << foo
        }
        [list: list]    
    }


    def save_express_no() {
        def me = MooncakeExpress.get(params.id)
        me.expressNo = params.express_no
        me.save()
        render (contentType: 'text/json') {[status: 'okay']}
    }

    def save_express_no2() {
        def me = Mooncake2ExpressH.get(params.id)
        me.expressNo = params.express_no
        me.save()
        render (contentType: 'text/json') {[status: 'okay']}
    }

    // TODO: 檢查有沒有被掃過券了
    // 免费快递版本
    def mooncake() {
        def vid = flash.vid ?: ''
        def pno = flash.pno ?: ''
        def name = flash.name ?: ''
        def phone = flash.phone ?: ''
        def address = flash.address ?: ''
        def express = ''
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
                express = row.express_no
                // 有快递单号
                einfo = _.parseJson("http://v.juhe.cn/exp/index?key=b7f2944ba8eef30883de8eb21830bb6f&com=sf&no=${row.express_no}")

                /*
                // DELETE THIS
                def slurper = new JsonSlurper()
                if (_.dev()) {
                    def foo = "http://v.juhe.cn/exp/index?key=b7f2944ba8eef30883de8eb21830bb6f&com=sf&no=${row.express_no}".toURL().text
                    einfo = slurper.parseText(foo)
                } else {            
                    def u = "http://v.juhe.cn/exp/index?key=b7f2944ba8eef30883de8eb21830bb6f&com=sf&no=${row.express_no}"
                    einfo = slurper.parse(new URL(u), 'utf-8')
                }
                */
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

        [vid: vid, pno: pno, name: name, phone: phone, address: address, express: express, einfo: einfo]
    }

    def gift_box() {
        def this_act = '2016_spring_over' // 活動結束 把名字改掉 就可以了
        def vid = flash.vid ?: ''
        def pno = flash.pno ?: ''
        def name = flash.name ?: ''
        def phone = flash.phone ?: ''
        def address = flash.address ?: ''
        def a = flash.a ?: params.a
        def express = ''
        def einfo = []
        def lv1s = []
        def is_act = (this_act == a)
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
                express = row.express_no
                // 有快递单号
                einfo = _.parseJson("http://v.juhe.cn/exp/index?key=b7f2944ba8eef30883de8eb21830bb6f&com=sf&no=${row.express_no}")
            }
            // 省
            s = "select distinct lv1 from zone where lv1 in ('江苏省', '浙江省', '上海', '安徽省') order by lv1"
            sql.eachRow(s, []) {
                lv1s << it.toRowResult()
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
                s = "insert into mooncake_express(version, name, phone, address, vid, status, express_no, date_created, last_updated, act_no) values(0, ?, ?, ?, ?, 'init', '', GETDATE(), GETDATE(), ?)"
                sql.execute(s, [params.name, params.phone, params.address, params.code, this_act])
                flash.msg = "兑换成功！"
            }
            flash.vid = params.code
            flash.pno = params.pno
            flash.name = params.name
            flash.phone = params.phone
            flash.address = params.address
            flash.a = params.a
            redirect(action: 'gift_box')
        } 

        [vid: vid, pno: pno, name: name, phone: phone, address: address, express: express, einfo: einfo, lv1s: lv1s, is_act: is_act, a: a]    
    }


    def mooncake_weight = [
        '90150022': 900, // 2015爱维尔沁意礼盒
        '90150023': 900, // 2015秋之礼礼盒
        '90150024': 1200, // 2015八月十五礼盒
        '90150025': 1300, // 2015爱维尔乐活礼盒
        '90150026': 1400, // 2015谢礼礼盒
        '90150027': 1600, // 2015甜美生活礼盒
        '90150028': 2000, // 2015爱维尔珍馔礼盒
        '90150029': 2300, // 2015爱维尔金矿礼盒
        '90150030': 3200, // 2015大红礼盒
        '90150032': 900, // 2015宝岛印象礼盒
        '90150033': 1220, // 2015茶梅酥礼盒
        '90150034': 1110, // 2015凤梨酥礼盒
        '90150035': 1320, // 2015台北印象礼盒
        '90150037': 2000, // 2015蛋黄酥礼盒
        '90150038': 1800, // 2015台湾绿豆椪礼盒
        '90150039': 1800, // 2015台湾三宝礼盒
        '90150041': 3300, // 2015舌尖上的台湾礼盒            
    ]

    // TODO: 檢查有沒有被掃過券了
    // 付费快递版本 
    def mooncake2() {
        session.openid = 'wxy'
        // ===== weixin oauth2 =====
        if (params.code) {
            def token = wx.wxService.oauth2getAccessToken(params.code)
            def openid = token.openId
            session.openid = openid
        }
        if (!session.openid) {
            def url = _.wxOauth2Url('market', 'mooncake2')
            url += "?showwxpaytitle=1&vid=" + params.vid
            url = wx.wxService.oauth2buildAuthorizationUrl(url, WxConsts.OAUTH2_SCOPE_BASE, null)
            redirect(url: url) 
            return
        }
        // ========================

        def h = null
        def ds = []
        def lv1s = []
        def fee = [:]
        def express = []

        if (params.vid) { // 扫码来的
            def sql = _.sql
            def s = """
                select a.vid, b.h_id 
                from GIFT_TOKEN a
                left join mooncake2expressd b on a.vid = b.vid
                where a.vid = ? 
            """
            def row = sql.firstRow(s, [params.vid])
            if (!row) {
                render '无效访问！'
                return
            } else if (!row.h_id) {
                s = """
                    insert mooncake2expressh(version, address, date_created, express_no, last_updated, name, phone, status, fee, kg, lv1, lv2, lv3, lat, lng) values(0, '', GETDATE(), '', GETDATE(), '', '', '', 0, 0, '', '', '', 0, 0)
                    select * from mooncake2expressh where id = @@IDENTITY
                """
                h = sql.firstRow(s, [])
                s = "insert mooncake2expressd values(0, GETDATE(), ?, GETDATE(), ?)"
                sql.execute(s, [h.id, params.vid])
                // 解决第一次扫描没单身问题
                redirect(action: 'mooncake2', params: ['showwxpaytitle': '1', 'vid': params.vid])
            } else if (row.h_id) {
                s = "select * from mooncake2expressh where id = ?"
                h = sql.firstRow(s, [row.h_id])
            }
            s = """
                select a.GT_NO, a.VCODE, a.VID, c.P_NO, c.P_NAME
                from GIFT_TOKEN a
                left join mooncake2expressd b on a.VID = b.vid
                left join part c on a.GI_P_NO = c.P_NO
                where b.h_id = ?
            """
            sql.eachRow(s, [row.h_id]) {
                def foo = it.toRowResult()
                foo['weight'] = mooncake_weight[it.P_NO] ?: 0
                ds << foo
            }
            // 省
            s = "select distinct lv1 from zone order by lv1"
            sql.eachRow(s, []) {
                lv1s << it.toRowResult()
            }
            // fee
            s = "select distinct first, additional, lv1 from zone"
            sql.eachRow(s, []) {
                fee[it.lv1] = it.toRowResult()
            }
            // express
            if (h.express_no) {
                def foo = _.parseJson("http://v.juhe.cn/exp/index?key=b7f2944ba8eef30883de8eb21830bb6f&com=sf&no=${h.express_no}")
                if (foo.error_code == 0) {
                    express = foo.result.list
                }
            }
        } else if (params.act == 'pay') {
            h = Mooncake2ExpressH.get(params.hid)
            if (h.status == 'unpaid') {
                def h2del = h
                h = new Mooncake2ExpressH()
                h.name = ''
                h.phone = ''
                h.address = ''
                h.lv1 = ''
                h.lv2 = ''
                h.lv3 = ''
                h.kg = 0
                h.fee = 0
                h.expressNo = ''
                h.status = ''
                h.save()
                Mooncake2ExpressD.findAllByH(h2del).each {
                    it.h = h
                    it.save()
                }
                h2del.status = 'delete'
                h2del.save()
            }
            h.name = params.name
            h.phone = params.phone
            h.lv1 = params.lv1
            h.lv2 = params.lv2
            h.lv3 = params.lv3
            h.address = params.address
            h.kg = params.kg.toFloat()
            h.fee = params.fee.toFloat()
            h.status = 'unpaid'
            h.save(flush: true)

            def appid = _.wxMpAppId
            def mchid = _.wxMpMchId
            def key = _.wxMpMchKey

            Unifiedorder unifiedorder = new Unifiedorder();
            unifiedorder.setAppid(appid); 
            unifiedorder.setMch_id(mchid); 
            unifiedorder.setNonce_str(UUID.randomUUID().toString().toString().replace("-", ""));
            unifiedorder.setOpenid(session.openid);
            unifiedorder.setBody("爱维尔中秋礼盒(" + params.kg + ")");
            unifiedorder.setOut_trade_no("IWILL_SF_" + h.id.toString().padLeft(10, "0"));
            def tf = params.fee.toInteger() * 100
            if (_.dev()) { // 开发时除 100
                tf = params.fee.toInteger()
            }
            unifiedorder.setTotal_fee(tf.toString()); //单位分
            unifiedorder.setSpbill_create_ip(request.getRemoteAddr());//IP
            if (_.dev()) {
                unifiedorder.setNotify_url("http://test.dsiwill.com/imis/market/mooncake2_notify"); 
            } else {
                unifiedorder.setNotify_url("http://api.dsiwill.com/imis/market/mooncake2_notify"); 
            }
            unifiedorder.setTrade_type("JSAPI");//JSAPI，NATIVE，APP，WAP
            // 统一下单，生成预支付订单
            UnifiedorderResult unifiedorderResult = PayMchAPI.payUnifiedorder(unifiedorder,key);

            flash.json = PayUtil.generateMchPayJsRequestJson(unifiedorderResult.getPrepay_id(), appid, key);
            redirect(action: 'mooncake2_pay', params: ['showwxpaytitle': '1'])
            return
        } else if (!params.vid && !params.code && !flash.vid) {
            render '无效访问！！' // AD page ?
            return
        } 

        [h: h, ds: ds, lv1s: lv1s, fee: fee as JSON, express: express]    
    }

    def mooncake2_zone() {
        def result = []
        def sql = _.sql    
        def s = "select distinct ${params.clv} as name from zone where ${params.plv} = ? order by ${params.clv}"
        sql.eachRow(s, [params.val]) {
            result << it.toRowResult()
        }
        render (contentType: 'text/json') {result}
    }

    def mooncake2_pay() {
        def json = flash.json
        println json // 看看什么原因没跳出付款界面
        [json: json]
    }

    def mooncake2_del() {
        def foo = Mooncake2ExpressD.findByVid(params.vid)
        foo.delete()
        render (contentType: 'text/json') {[msg: 'okay']}
    }

    private static ExpireSet<String> expireSet = new ExpireSet<String>(60);
    def mooncake2_notify() {
        def key = _.wxMpMchKey
        //def key = "b84b9bb08bd8f064fab58420c7d304bb"

        // 获取请求数据
        MchPayNotify payNotify = XMLConverUtil.convertToObject(MchPayNotify.class, request.getInputStream());

        // 已处理 去重
        if(expireSet.contains(payNotify.getTransaction_id())){
            return;
        }
        // 签名验证
        if(SignatureUtil.validateAppSignature(payNotify,key)){
            // update
            def id = payNotify.out_trade_no[9..18].toInteger()
            def h = Mooncake2ExpressH.get(id)
            h.status = 'paid'
            h.save(flush: true)
            
            expireSet.add(payNotify.getTransaction_id());
            MchBaseResult baseResult = new MchBaseResult();
            baseResult.setReturn_code("SUCCESS");
            baseResult.setReturn_msg("OK");
            render XMLConverUtil.convertToXML(baseResult)
        }else{
            MchBaseResult baseResult = new MchBaseResult();
            baseResult.setReturn_code("FAIL");
            baseResult.setReturn_msg("ERROR");
            render XMLConverUtil.convertToXML(baseResult)
        }            
    }

    // TODO: 檢查券有沒有被掃
    def mooncake2_check() {
        def msg = ''
        def name = ''
        def tno = params.tno?.trim()
        def vcode = params.vcode?.trim().toUpperCase()
        def vid = ''
        def weight = 0
        def sql = _.sql
        def s = """
            select c.P_NO, c.P_NAME, a.GT_NO, a.VCODE, a.VID, b.id
            from GIFT_TOKEN a
            left join mooncake2expressd b on a.VID = b.VID
            left join part c on a.GI_P_NO = c.P_NO
            where GT_NO = ? and VCODE = ?
        """
        def row = sql.firstRow(s, [tno, vcode])
        if (!row) {
            msg = '券号或验证码错误！'
        }
        if (row && row.id) {
            msg = '此券号已被使用过！'
        }
        if (!msg) {
            def h = Mooncake2ExpressH.get(params.hid)
            def d = new Mooncake2ExpressD()
            d.vid = row.VID?.trim()
            d.h = h
            d.save()
            name = row.P_NAME?.trim()
            vid = row.VID?.trim()
            weight = mooncake_weight[row.P_NO?.trim()]
        }
        render (contentType: 'text/json') {[name: name, tno: tno, vcode: vcode, vid: vid, msg: msg, weight: weight]}
    }

    def test() {
        def appid = _.wxMpAppId
        //def appid = "wx52ea5a89a99b5be2"
        def mchid = _.wxMpMchId
        //def mchid = "1220083801"
        def key = _.wxMpMchKey
        //def key = "b84b9bb08bd8f064fab58420c7d304bb"

        Unifiedorder unifiedorder = new Unifiedorder();
        unifiedorder.setAppid(appid); 
        unifiedorder.setMch_id(mchid); 
        unifiedorder.setNonce_str(UUID.randomUUID().toString().toString().replace("-", ""));
        unifiedorder.setOpenid("XXXXXXXX");
        unifiedorder.setBody("商品信息");
        unifiedorder.setOut_trade_no("123456");
        unifiedorder.setTotal_fee("1");//单位分
        unifiedorder.setSpbill_create_ip(request.getRemoteAddr());//IP
        unifiedorder.setNotify_url("http://mydomain.com/test/notify");
        unifiedorder.setTrade_type("JSAPI");//JSAPI，NATIVE，APP，WAP
                //统一下单，生成预支付订单
        UnifiedorderResult unifiedorderResult = PayMchAPI.payUnifiedorder(unifiedorder,key);

        String json = PayUtil.generateMchPayJsRequestJson(unifiedorderResult.getPrepay_id(), appid, key);

        println json
        //将json 传到jsp 页面
        //request.setAttribute("json", json);    
    }

    def express_map() {
        def data = []
        def sql = _.sql
        def s = """
            --select 'a' + CAST(id as varchar) as id, address, phone, name, 1 as box, last_updated, lat, lng from mooncake_express
            --union all
            select 'b' + CAST(b.id as varchar) as id, lv1 + lv2 + lv3 + address as address, phone, name, COUNT(*) as box, b.last_updated, lat, lng
            from express_charge_body a left join express_charge_head b on a.h_id = b.id 
            where status = 'paid'
            group by b.id, lv1, lv2, lv3, address, phone, name, b.last_updated, lat, lng
            order by b.last_updated
        """
        sql.eachRow(s, []) {
            data << it.toRowResult()
        }   

        [data: data as JSON]
    }

    def express_map_lng_lat() {
        def result = [:]
        def sql = _.sql
        if (params.id?.indexOf('a') == 0) {
            def id = params.id - 'a'
            def s = "update mooncake_express set lng = ?, lat = ? where id = ?"
            sql.executeUpdate(s, [params.lng, params.lat, id])
        } else if (params.id?.indexOf('b') == 0) {
            def id = params.id - 'b'
            def s = "update express_charge_head set lng = ?, lat = ? where id = ?"
            sql.executeUpdate(s, [params.lng, params.lat, id])
        }
        render (contentType: 'text/json') {result}
    }

    def express_update() {
    
    }

    def express_update_upload() {
        def f = request.getFile('file')
        if (f.empty) { // 依照 ui 不应该发生
            render "empty file" 
            return
        }
        // check path and save file
        def fn = _.uuid() + '.xls'
        _.save2UploadDir(f, 'express', fn)
        render fn 
    }

    def express_update_read_xls() {
        def data = [:]
        // data in excel
        def f = _.getUploadFile('express', params.filename)
        def book = Workbook.getWorkbook(f);
        def sheet = book.getSheet(0)
        for (int i = 1; i < sheet.getRows(); i++) {
            def cells = sheet.getRow(i)
            if (cells.length != 59) {
                continue // 顺丰 excel 固定 59
            }
            def foo = [:]
            foo['ono'] = cells[0].getContents()
            foo['eno'] = cells[1].getContents()
            foo['man'] = cells[9].getContents()
            foo['tel'] = cells[8].getContents()
            foo['address'] = cells[7].getContents()
            foo['address'] = foo.address.length() > 6 ? foo.address[0..5] : foo.address
            def status = '!!??'
            if (!foo.ono) {
                status = '不更新：无订单号'
            }
            if (foo.ono && foo.ono[0] == 'a') {
                def mc = MooncakeExpress.get(foo.ono - 'a')
                if (mc.expressNo && mc.expressNo == foo.eno) {
                    status = '不更新：单号相同'
                } else if (mc.expressNo) {
                    status = '不更新：原运单' + mc.expressNo
                } else {
                    mc.expressNo = foo.eno
                    mc.save()
                    status = '已更新'
                }
            }
            if (foo.ono && foo.ono[0] == 'b') {
                status = '无效单号'
            }
            if (foo.ono && foo.ono[0] == 'c') {
                def mc = Mooncake2ExpressH.get(foo.ono - 'c')
                if (mc.expressNo && mc.expressNo == foo.eno) {
                    status = '不更新：单号相同'
                } else if (mc.expressNo) {
                    status = '不更新：原运单' + mc.expressNo
                } else {
                    mc.expressNo = foo.eno
                    mc.save()
                    status = '已更新'
                }
            }
            foo['status'] = status
            data[i] = foo 
        }        
        render (contentType: 'text/json') {data.values()}
    }


    def foo() {
        def einfo = "http://v.juhe.cn/exp/index?key=b7f2944ba8eef30883de8eb21830bb6f&com=sf&no=023495774109".toURL().text
        println ">>> " + einfo
        println ">>> 测试中文"
        render "123"

    }
}
