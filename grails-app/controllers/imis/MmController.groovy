package imis
import iwill.*
import grails.converters.*

class MmController extends BaseController {

    def index() { }


    def page1() {
        def result = [:]
        def sql = _.sql
        def s = "select * from iwill_weight order by cate1, cate2, section, seq"
        sql.eachRow(s, []) {
            def foo = it.toRowResult()
            if (result[foo.cate1] == null) {
                result[foo.cate1] = [:]
            }
            if (result[foo.cate1][foo.cate2] == null) {
                result[foo.cate1][foo.cate2] = [:]
            }
            if (result[foo.cate1][foo.cate2][foo.section] == null) {
                result[foo.cate1][foo.cate2][foo.section] = []
            }
            result[foo.cate1][foo.cate2][foo.section] << foo
        }


        [result: result]
    }


    def printit() {
        def result = [:]
        def wp = new IwillWeightPrint(params)
        wp.username = '林郁帏'
        wp.save()  
        result.id = wp.id
        // TODO: print at prod and dev environment
        "\"C:\\Program Files (x86)\\Seagull\\BarTender Suite\\bartend.exe\" /F=D:\\foo.btw /?id=\"${result.id}\" /P /X".execute()
        render result as JSON
    }
}
