package imis

import iwill.*

class RemindController {

    def list() {
        def list = []
        def sql = _.sql
        // TODO: work around - clac "days" column
        def s = "select * from remind"
        def today = _.today('yyyy/MM/dd')
        sql.eachRow(s) {
            def d1 = _.diffDays(it.edate, today)
            def d2 = _.diffDays(it.cdate, today)
            def days = d1 > d2 ? d2 : d1
            if (days != it.days) {
                s = "update remind set days = ? where id = ?"
                sql.execute(s, [days, it.id])
                println "update it"
            }
        }





        // 读取资料
        params.max = 50
        params.offset = params.offset ?: 0
        list = []
        s = """
            WITH Results_CTE AS (select *, ROW_NUMBER() OVER (ORDER BY days, id desc) AS RowNum from remind)
            SELECT * FROM Results_CTE WHERE RowNum > ? AND RowNum <= ?
        """
        sql.eachRow(s, [params.offset, params.offset + params.max]) {
            list << it.toRowResult()
        }

        [list: list, total: Remind.count()]

    }


    def add() {
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
                foo.comment = params.comment ?: ''
                foo.status = 'init'
                foo.save()
                flash.message = "新增成功"
                redirect(action: 'edit', id: foo.id)
                return 
            }
        }
    
    }

    def edit() {
        if (params.save) {
            def foo = Remind.get(params.id.toLong())
            foo.name = params.name ?: ''
            foo.type = params.type ?: ''
            foo.person = params.person ?: ''
            foo.address = params.address ?: ''
            foo.sdate = params.sdate ?: ''
            foo.edate = params.edate ?: ''
            foo.cdate = params.cdate ?: ''
            foo.owner = params.owner ?: ''
            foo.man = params.man ?: ''
            foo.tel = params.tel ?: ''
            foo.comment = params.comment ?: ''
            foo.status = params.status ?: ''
            foo.save()
            flash.message = '保存成功'
            redirect(action: 'edit', id: foo.id)
            return
        } 
        if (params.del) {
            def foo = Remind.get(params.id.toLong())
            // foo.status = 'delete'
            foo.delete()
            flash.message = '删除成功'
            redirect(action: 'list')
            return
        }
        def foo = Remind.get(params.id.toLong())
        [foo: foo]
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

    static status = [
        'init': '新增证件',
        'delete': 'DELETE',
    ]
}
