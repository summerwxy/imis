package imis

import me.chanjar.weixin.common.util.*
import me.chanjar.weixin.common.api.*
import iwill.*
import grails.converters.*
import groovy.json.*


class QyZqlhController {
    def wxcpZqlh

    def index() {
        def signature = params.msg_signature
        def nonce = params.nonce
        def timestamp = params.timestamp
        def echostr = params.echostr

        if (StringUtils.isNotBlank(echostr)) {
            if (!wxcpZqlh.wxService.checkSignature(signature, timestamp, nonce, echostr)) {
                render "invalid access"
                return
            }
            render wxcpZqlh.wxCryptUtil.decrypt(echostr)
        }    

        // TODO: others code here
        // render wxcpZqlh.parse(request, params)

    }


    def salesOrder() {
        // ===== weixin oauth2 =====
        if (params.code) {
            def res = wxcpZqlh.wxService.oauth2getUserInfo(params.code);
            session.wxcpUserId = res[0]
            session.wxcpDeviceId = res[1]
        }
        if (!session.wxcpUserId) {
            def url = _.wxOauth2Url('qyZqlh', 'salesOrder')
            url = wxcpZqlh.wxService.oauth2buildAuthorizationUrl(url, WxConsts.OAUTH2_SCOPE_USER_INFO)
            redirect(url: url) 
            return
        }
        // ========================

        def h = (params.id) ? MooncakeOrderH.get(params.id) : new MooncakeOrderH()
        def d = (params.id) ? MooncakeOrderD.findAllByH(h) : []
        def mooncake = [
            '台湾进口冷冻系列': [
                [name: '雪绵娘', no: '90150040', price: 269, box: 0, ticket: 0],
                [name: '冰雪物语', no: '90150036', price: 169],
            ], '台湾手工制作系列': [
                [name: '舌尖上的台湾', no: '90150041', price: 399],
                [name: '台湾三宝', no: '90150039', price: 269],
                [name: '绿豆碰', no: '90150038', price: 269],
                [name: '蛋黄酥', no: '90150037', price: 239],
                [name: '凤梨酥', no: '90150034', price: 169],
                [name: '台北印象', no: '90150035', price: 199],
                [name: '茶梅酥', no: '90150033', price: 169],
                [name: '宝岛印象', no: '90150032', price: 139],
            ],
            '感恩系列': [
                [name: '喜宴中秋', no: '90150031', price: 599],
                [name: '爱维尔大红', no: '90150030', price: 369],
                [name: '爱维尔金矿', no: '90150029', price: 269],
                [name: '爱维尔珍馔', no: '90150028', price: 239],
                [name: '甜美生活', no: '90150027', price: 199],
                [name: '谢礼', no: '90150026', price: 199],
                [name: '爱维尔乐活', no: '90150025', price: 169],
                [name: '八月十五', no: '90150024', price: 169],
                [name: '秋之礼', no: '90150023', price: 139],
                [name: '爱维尔沁意', no: '90150022', price: 109],
                [name: '情洒中秋', no: '90150021', price: 69],
                [name: '秋戏', no: '90150020', price: 49],
                [name: '爱维尔祝福', no: '90150019', price: 30],
                [name: '贺中秋', no: '90150018', price: 19],
            ],
        ]
        
        mooncake.each { it1 ->
            it1.value.each { it2 ->
                it2.box = 0
                it2.ticket = 0
                d.each { it3 ->
                    if (it3.pNo == it2.no) {
                        it2.box = it3.qty
                    }
                    if (it3.pNo == ("80" + (it2.no - "90"))) {
                        it2.ticket = it3.qty
                    }
                }
            }
        }


        [mooncake: mooncake, h: h, d: d]
    }

    def batch_delete() {
        if (params.ids) {
            params.ids.split(',').each {
                def h = MooncakeOrderH.get(it)
                h.status = 'draft_x'
                h.save()
            }
        }
        render (contentType: 'text/json') {['status': 'okay']}
    }

    def salesOrder_status() {
        def h = MooncakeOrderH.get(params.id)
        h.status = params.status
        h.save()
        render (contentType: 'text/json') {['id': h.id]}
    }

    def salesOrder_save() {
        def h = (params.id) ? MooncakeOrderH.get(params.id) : new MooncakeOrderH()
        h.name = params.name ?: ''
        h.phone = params.phone ?: ''
        h.shipTime = params.shipTime ?: ''
        h.type = params.type ?: ''
        h.address = params.address ?: ''
        h.comment = params.comment ?: ''
        h.status = params.status ?: ''
        h.orderSno = ''
        h.shipSno = ''
        h.slKey = ''
        h.username = ''
        h.wxUserId = session.wxcpUserId
        h.save()
        MooncakeOrderD.findAllByH(h).each {
            it.delete()
        }
        params.pno.eachWithIndex { it, i ->
            if (params.box[i].toLong() > 0) {
                def d = new MooncakeOrderD()
                d.pNo = it
                d.qty = params.box[i].toLong()
                d.h = h
                d.save()
            }
            if (params.ticket[i].toLong() > 0) {
                def d = new MooncakeOrderD()
                d.pNo = "80" + (it - "90")
                d.qty = params.ticket[i].toLong()
                d.h = h
                d.save()
            }
        }
        render (contentType: 'text/json') {['id': h.id]}
    }

    def temp_sql = """
        select case 
            when b.FLS_NO = 'PP' then 'pp' 
            when b.FLS_NO = 'CO' then 'close'
            when b.FLS_NO = 'ED' then 'edit'
            when b.FLS_NO = 'CL' then 'cancel'
            else 'none' 
        end as pos_status, case
            when v1.FBillNo is null then 'none' 
            when v1.FCancellation <> 0 then 'cancel' 
            when (v1.FCheckerID <= 0 OR v1.FCheckerID IS NULL) and v1.FBillNo <> '' then 'uncheck'
            when v1.FCheckerID > 0 then 'check'  
        end as k3_order_status, case
            when Cv1.FCancellation <> 0 then 'cancel'
            when (Cv1.FCheckerID <= 0 OR Cv1.FCheckerID IS NULL) and Cv1.FBillNo <> '' then 'uncheck' 
            when Cv1.FCheckerID > 0 then 'check'  
            when Cv1.FBillNo is null then 'none' 
        end as k3_ship_status,case
            when Cv2.FCancellation <> 0 then 'cancel'
            when (Cv2.FCheckerID <= 0 OR Cv2.FCheckerID IS NULL) and Cv2.FBillNo <> '' then 'uncheck' 
            when Cv2.FCheckerID > 0 then 'check'  
            when Cv2.FBillNo is null then 'none' 
        end as k3_back_status, a.*
        into #aa
        from mooncake_orderh a 
        left join sale_order_h b on a.sl_key = b.SL_KEY 
        left join [AIS20121019100529].[dbo].SEOrder v1 on  a.sl_key = v1.FHeadSelfS0163 and v1.FHeadSelfS0163 <> ''
        left join [AIS20121019100529].[dbo].ICStockBill Cv1 on a.sl_key = Cv1.FHeadSelfB0154 and Cv1.FHeadSelfB0154 <> ''
        left join [AIS20121019100529].[dbo].ICStockBill Cv2 on a.sl_key = Cv2.FPOSName and Cv2.FPOSName <> ''  and Cv2.FROB = -1
        order by a.id
        -- 凑状态
        select case
            when status in ('draft', 'draft_x', 'init', 'init_x') then status
            when status = '2k1_c' and pos_status = 'cancel' then '2k1_x' -- 已注销
            when status = '2k1' and k3_ship_status = 'check' then 'ship' -- 已出货
            when status = 'ship_c' and k3_back_status = 'check' then 'ship_x' -- 已退货
            when status in ('2k1', '2k1_c', 'ship_c') then status -- 要放后面的
        end as all_status, * into #bb from #aa
    """

    def list() {
        // ===== weixin oauth2 =====
        // session.wxcpUserId = '13862150723' // for test
        if (params.code) {
            def res = wxcpZqlh.wxService.oauth2getUserInfo(params.code);
            session.wxcpUserId = res[0]
            session.wxcpDeviceId = res[1]
        }
        if (!session.wxcpUserId) {
            def url = _.wxOauth2Url('qyZqlh', 'list', ['view': params.view])
            url = wxcpZqlh.wxService.oauth2buildAuthorizationUrl(url, WxConsts.OAUTH2_SCOPE_USER_INFO)
            redirect(url: url) 
            return
        }
        // ========================

        def title = ''
        def list = []
        def sql = _.sql
        def s = ''
        if (params.view == 'draft') {
            title = '我的草稿'
            s = """select * from mooncake_orderh where wx_user_id = ? and status = 'draft' order by id desc"""
            sql.eachRow(s, [session.wxcpUserId]) {
                list << it.toRowResult()
            }
        } else if (params.view == 'my') {
            title = '我的订单'
            s = temp_sql + """
                -- result
                select * from #bb where wx_user_id = ? and all_status in ('init', '2k1', '2k1_c', 'ship', 'ship_c')
            """
            sql.eachRow(s, [session.wxcpUserId]) {
                list << it.toRowResult()
            }
        }
        [title: title, list: list]    
    } 


    def detail() {
        def sql = _.sql
        def s = temp_sql + """
            -- result
            select * from #bb where id = ?        
        """
        def h = sql.firstRow(s, [params.id])
        
        def d = []
        s = """
            select a.*, b.P_NAME, b.P_PRICE, b.UN_NO
            from mooncake_orderd a
            left join PART b on a.p_no = b.P_NO
            where a.h_id = ?
            order by a.p_no
        """
        sql.eachRow(s, [params.id]) {
            d << it.toRowResult()
        }

        [h: h, d: d]
    }

    
    def console() {
        def list = []
        def sql = _.sql
        def s = temp_sql + """
            -- result
            select a.*, b.name as wxname
            from #bb a 
            left join wx_cp_user b on a.wx_user_id = b.user_id
            order by a.id desc
        """    
        sql.eachRow(s, []) {
            list << it.toRowResult()
        }


        [list: list]
    }

    def console_detail() {
        if (params.transfer) {
            def h = MooncakeOrderH.get(params.id)
            h.username = params.username
            h.orderSno = params.order_sno
            h.shipSno = params.ship_sno
            h.save(flush: true)

            def sql = _.sql
            def s = "iwill_ship_shouji ${params.id}"
            sql.execute(s, [])
            
            redirect(action: 'console')
            return
        } else if (params.back) {
            def h = MooncakeOrderH.get(params.id)
            h.status = 'ship_c'
            h.save(flush: true)

            def sql = _.sql
            def s = "iwill_ship_shouji_ba ${params.id}"
            sql.execute(s, [])
            
            redirect(action: 'console')
            return
        }


        def sql = _.sql
        def s = temp_sql + """
            -- result
            select a.*, b.name as wxname, c.S_NAME as order_sname, d.S_NAME as ship_sname
            from #bb a 
            left join wx_cp_user b on a.wx_user_id = b.user_id
            left join STORE c on a.order_sno = c.S_NO
            left join STORE d on a.ship_sno = d.S_NO
            where a.id = ? 
        """
        def h = sql.firstRow(s, [params.id])
        
        def d = []
        s = """
            select a.*, b.P_NAME, b.P_PRICE, b.UN_NO
            from mooncake_orderd a
            left join PART b on a.p_no = b.P_NO
            where a.h_id = ?
            order by a.p_no
        """
        sql.eachRow(s, [params.id]) {
            d << it.toRowResult()
        }
        def store = []
        s = """
            select S_NO as value, S_NO + ' ' + S_NAME as label from STORE order by S_NO
        """
        sql.eachRow(s, []) {
            store << it.toRowResult()
        }
        
        [h: h, d: d, store: store]        
    }


    def syncWxcpUser() {
        wxcpZqlh.wxService.departGetUsers(1, true, 0).each {
            def u = imis.WxCpUser.findByUserId(it.userId) ?: new imis.WxCpUser()
            u.userId = it.userId ?: ''
            u.name = it.name ?: ''
            u.position = it.position ?: ''
            u.mobile = it.mobile ?: '' 
            u.gender = it.gender ?: ''
            u.tel = it.tel ?: ''
            u.email = it.email ?: ''
            u.weiXinId = it.weiXinId ?: ''
            u.avatar = it.avatar ?: ''
            u.status = (it.status == null) ? -1 : it.status
            u.save()
        }
        render 'okay' 
    }


    static status = [
        'draft': '草稿', 'draft_x': '已删除',
        'init': '未处理', 'init_x': '已取消',
        '2k1': '已处理', '2k1_c': '注销中', '2k1_x': '已注销',
        'ship': '已出货', 'ship_c': '退货中', 'ship_x': '已退货',
    ]

}
