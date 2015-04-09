package imis

import jxl.Workbook
import jxl.CellType
import jxl.write.Label
import jxl.write.Number
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import jxl.write.WritableCellFormat
import iwill.*

class SalesController {

    def index() {
        
    }

    def page1() {
        if (params.s_no) {
            def sql = _.sql
            def s1 = "SELECT month_target FROM iwill_store_target WHERE s_no = ? and months = ?"
            def s2 = ""
            params.s_no.eachWithIndex { it, i ->
                def ist = IwillStoreTarget.findBySNoAndMonths(params.s_no[i], params.months[i][0..3,5..6])
                if (!ist && params.month_target[i].toInteger() > 0) {
                    ist = new IwillStoreTarget()
                    ist.sNo = params.s_no[i]
                    ist.months = params.months[i][0..3,5..6]
                    ist.days = params.days[i].toInteger()
                    ist.monthTarget = params.month_target[i].toDouble()
                    ist.dayTarget = Math.round(params.month_target[i].toDouble() / params.days[i].toInteger() * 10) / 10
                    ist.save()
                } else if (ist && ist.monthTarget != params.month_target[i].toDouble()) {
                    ist.monthTarget = params.month_target[i].toDouble()
                    ist.dayTarget = Math.round(params.month_target[i].toDouble() / params.days[i].toInteger() * 10) / 10
                    ist.save()
                }
            } 
        }
    }

    def page1_download() {
        response.setContentType('application/vnd.ms-excel')
        response.setHeader('Content-Disposition', 'Attachment;Filename="m' + params.month + '.xls"')

        def workbook = Workbook.createWorkbook(response.outputStream)
        def sheet = workbook.createSheet("门店业绩目标", 0)
        sheet.addCell(new Label(0, 0, "门店代号"))
        sheet.addCell(new Label(1, 0, "门店名称"))
        sheet.addCell(new Label(2, 0, "月份"))
        sheet.addCell(new Label(3, 0, "绩效目标"))

        def wcf = new WritableCellFormat();
        wcf.setBackground(jxl.format.Colour.LIME); 

        def sql = _.sql
        def s = """
            SELECT S_NO, S_NAME FROM STORE WHERE NOT R_NO IN ('8981', '8991', '8992') AND UPD_DATE >= CONVERT(CHAR, CONVERT(DATETIME, DATEADD(MONTH, -3, GETDATE())), 112) ORDER BY S_NO 
        """
        int i = 1
        sql.eachRow(s, []) {
            sheet.addCell(new Label(0, i, it.S_NO))
            sheet.addCell(new Label(1, i, it.S_NAME))
            sheet.addCell(new Label(2, i, params.month))
            sheet.addCell(new Number(3, i, 0, wcf))
            i += 1
        }

        workbook.write();
        workbook.close();     
    }

    def page1_upload() {
        def f = request.getFile('file')
        if (f.empty) { // 依照 ui 不应该发生
            render "empty file" 
            return
        }
        // check path and save file
        def fn = _.uuid() + '.xls'
        _.save2UploadDir(f, 'goal', fn)
        render fn
    }

    def page1_read_xls() {
        def data = [:]
        // data in excel
        def f = _.getUploadFile('goal', params.filename)
        def book = Workbook.getWorkbook(f);
        def sheet = book.getSheet(0)
        def codes = []
        def days = [:]
        for (int i = 1; i < sheet.getRows(); i++) {
            def cells = sheet.getRow(i)
            if (cells.length < 4) {
                continue; // 资料少于 4 栏, 跳过
            }
            def foo = [:]
            foo['sNo'] = cells[0].getContents()
            foo['sName'] = cells[1].getContents()
            foo['months'] = cells[2].getContents()
            foo['monthTargetXls'] = cells[3].getContents()
            foo['monthTargetSql'] = 0
            def code = foo['months'][0..3,5..6] + foo['sNo']
            // find days
            if (days[foo.months]) {
                foo['days'] = days[foo.months]
            } else {
                def cal = Calendar.getInstance()
                cal.set(Calendar.YEAR, foo.months[0..3].toInteger());
            	cal.set(Calendar.MONTH, foo.months[5..6].toInteger() - 1);
                int max = cal.getActualMaximum(Calendar.DAY_OF_MONTH)
                foo['days'] = max
                days[foo.months] = max
            }

            codes << code
            data[code] = foo 
        }
        // data in sql
        def sql = _.sql
        def s = """
            SELECT months + s_no AS code, month_target, day_target FROM iwill_store_target WHERE months + s_no IN ('${codes.join("', '")}')
        """
        sql.eachRow(s, []) {
            data[it.code]['monthTargetSql'] = it.month_target
        }
        render (contentType: 'text/json') {data.values()}
    }

}
