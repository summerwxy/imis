package imis

import me.chanjar.weixin.common.util.*
import me.chanjar.weixin.common.api.*
import iwill.*

class QyController {

    def wxcp


    def index() {
        def signature = params.msg_signature
        def nonce = params.nonce
        def timestamp = params.timestamp
        def echostr = params.echostr

        if (StringUtils.isNotBlank(echostr)) {
            if (!wxcp.wxService.checkSignature(signature, timestamp, nonce, echostr)) {
                render "invalid access"
                return
            }
            render wxcp.wxCryptUtil.decrypt(echostr)
        }
        // TODO: others code here
        // render wxcp.parse(request, params)
    }


    def test() {}

    def test2() {}


    def salesOrder() {

        def mooncake = [
            '台湾进口冷冻系列': [
                [name: '雪绵娘', no: '90150040', price: 269],
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
    

        [mooncake: mooncake]
    }

}
