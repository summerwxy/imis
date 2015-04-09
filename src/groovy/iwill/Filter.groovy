package iwill

import groovy.sql.Sql
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import com.spreada.utils.chinese.*


class Filter {

    static storeByKeyword(data, kw) {
        def result = []
        data.each {
            if (it.S_PY.indexOf(kw) != -1 || it.S_TEL.indexOf(kw) != -1 || it.S_NO.indexOf(kw) != -1) {
                result << it
            }
        } 
        return result
    } 


    static partByKeyword(data, kw) {
        def result = []
        data.each {
            if ((it.P_PY.indexOf(kw) != -1 || it.P_NAME.indexOf(kw) != -1 || it.P_NO.indexOf(kw) != -1) && result.size() <= 200) {
                result << it
            }
        }
        return result    
    }

    static partByPdaFail(data) {
        def result = []
        data.each {
            if (it.P_PDA == 'X' && it.P_STATUS == '1') {
                result << it
            } 
        }
        return result
    }
}

