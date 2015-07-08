package imis

class RemindController {

    def list() {
        /*
        params.max = 20
        params.sort = 'id'
        params.order = 'desc'

        [list: Remind.list(params), total: Remind.count()]
        */
    }


    def add() {
        /*
        if (params.add) {
            if (!params.name) {
                params.error = '请输入证件名称' 
            }
            if (!params.error) {
                def foo = new Remind(params)
                foo.person = params.person ?: ''
                foo.address = params.address ?: ''
                foo.sdate = params.sdate ?: ''
                foo.edate = params.edate ?: ''
                foo.cdate = params.cdate ?: ''
                foo.man = params.man ?: ''
                foo.tel = params.tel ?: ''
                foo.comment = params.ccomment ?: ''
                foo.status = 'start'
                foo.save()
                flash.message = "新增成功"
                redirect(action: 'add')
                return 
            }
        }
        */
    
    }


    static papers = [
        'p1': '工商营业执照',
        'p2': '食品许可流通证',
        'p3': '餐饮许可证',
        'p4': '小作坊',
        'p5': '税务登记证',
        'p6': '商标注册证',
    ]

    static owner = [
        'o1': '个体直营店',
        'o2': '分公司',
    ]
}
