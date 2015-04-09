package iwill

import groovy.sql.Sql
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import com.spreada.utils.chinese.*


class Dao {

    static getStore() {
        def result = []
        def sql = _.sql
        def s = """
            select a.S_NO, a.S_NAME, a.S_TEL, a.S_IP, b.R_NAME, a.S_STATUS
            from STORE a
            left join REGION b on a.R_NO = b.R_NO
        """
        sql.eachRow(s, []) {
            def store = it.toRowResult()
            store.S_PY = _.zh2py(store.S_NAME)
            store.S_STATUS_NAME = _._STORE_STATUS[store.S_STATUS]
            result << store
        }
        return result 
    }

    static getPart() {
        def result = []
        def sql = _.sql
        def s = """
            select a.P_NO, a.P_NAME, a.P_PRICE, a.UN_NO, b.D_CNAME, c.SUB_NAME, a.P_STATUS, P_NAME + P_SPMODE AS PDASTR
            from PART a 
            left join DEPART b on a.D_NO = b.D_NO
            left join SUBDEP c on b.[GROUP] = c.SUBDEP
            order by P_NO
        """
        sql.eachRow(s, []) {
            def part = it.toRowResult()
            part.P_PY = _.zh2py(part.P_NAME).toLowerCase()
            part.P_STATUS_NAME = _._PART_STATUS[part.P_STATUS]
            part.P_PDA = canUseInPda(part.PDASTR) ? 'O' : 'X'
            result << part
        }
        return result 
    }

    static canUseInPda(str) {
        boolean foo = false
        int count = 0
        str.each {
            if (Integer.toHexString((int) it.charAt(0)).length() == 4) {
                count += 2
            } else {
                count += 1
            }            
            if (count == 22) { // 要刚好 22 不然就是中文字会拆开来
                foo = true
            }
        }
        if (count < 22) { // 小于 22 的也没事
            foo = true
        }
        return foo
    }

}

