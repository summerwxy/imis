package iwill

import groovy.sql.Sql
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import com.spreada.utils.chinese.*
import java.text.*
import grails.util.GrailsUtil
import java.util.UUID
import groovy.io.FileType

class _ {

    static getSql() {
        return Sql.newInstance('jdbc:jtds:sqlserver://192.168.0.18/iwill', 'sa', '123456_abc', 'net.sourceforge.jtds.jdbc.Driver')
    }

    /**
    * 获取汉字串拼音首字母，英文字符不变
    *
    * @param chinese 汉字串
    * @return 汉语拼音首字母
    */
    static zh2py(String chinese) {
        StringBuffer pybf = new StringBuffer();
        char[] arr = chinese.toCharArray();
        HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
        defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
        defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] > 128) {
                try {
                    String[] _t = PinyinHelper.toHanyuPinyinStringArray(arr[i], defaultFormat);
                    if (_t != null) {
                        pybf.append(_t[0].charAt(0));
                    }
                } catch (BadHanyuPinyinOutputFormatCombination e) {
                    e.printStackTrace();
                }
            } else {
                pybf.append(arr[i]);
            }
        }
        return pybf.toString().replaceAll("\\W", "").trim();
    } 


    static tc2sc(String tc) {
        // Instantiation will fetch the property file which load the Chinese character mappings
        // TODO: fuck lib
        // return ZHConverter.getInstance(ZHConverter.SIMPLIFIED).convert(tc)
        return tc
    }

    static date2String(Date d, format='yyyyMMdd') {
        SimpleDateFormat sdf = new SimpleDateFormat(format)
        return sdf.format(d)
    }

    static string2Date(String s, format='yyyyMMdd') {
        SimpleDateFormat sdf = new SimpleDateFormat(format)
        return sdf.parse(s)
    }

    static dateStringRemoveSlash(String s) {
        return date2String(string2Date(s, 'yyyy/MM/dd'))
    }

    static dateStringAddSlash(String s) {
        return date2String(string2Date(s), 'yyyy/MM/dd')
    }

    static someday(field, amount, format) {
        def cal = Calendar.getInstance()
        cal.add(field, amount)
        return date2String(cal.getTime(), format)
    }

    static today(format='yyyyMMdd') {
        return someday(Calendar.DATE, 0, format)
    }

    static yesterday(format='yyyyMMdd') {
        return someday(Calendar.DATE, -1, format)
    }

    static long2DateString(long lng, format='yyMMdd HHmm') {
        def cal = Calendar.getInstance()
        cal.setTimeInMillis(lng)
        return date2String(cal.getTime(), format)
    }

    static dateString2Long(String str, format='yyMMdd HHmm') {
        def d = string2Date(str, format)
        return d.getTime()
    }

    static _STORE_STATUS = ['1': '正常', '2': '已停業']

    static _PART_STATUS = ['1': '正常', '3': '删除']

    static formatDate(date, format='yyyy-MM-dd') {
        def sdf = new SimpleDateFormat(format)
        return sdf.format(date) 
    }

    static numberFormat(num, pattern='##,##0.0') {
        def df = new DecimalFormat(pattern)
        return df.format(num)
    }

    static checkUploadDir(dirname) { 
        def path = ''
        if(GrailsUtil.getEnvironment() == "development") {
            path = 'web-app/upload/' + dirname
        } else if (GrailsUtil.getEnvironment() == "production") {
            path = 'webapps/imis/upload/' + dirname
        } else {
            throw new Exception()
        }
        def dir = new File(path)
        if (!dir.exists()) {
            dir.mkdirs()
        }
    }

    static save2UploadDir(f, dn, fn) {
        _.checkUploadDir(dn)
        def path = ''
        if(GrailsUtil.getEnvironment() == "development") {
            path = 'web-app/upload/' + dn + '/' + fn
        } else if (GrailsUtil.getEnvironment() == "production") {
            path = 'webapps/imis/upload/' + dn + '/' + fn
        } else {
            throw new Exception()
        }
        f.transferTo(new File(path)) 
    }

    static delUploadFile(dn, fn) {
        def f = getUploadFile(dn, fn)
        f.delete()
    }

    static getUploadFile(dn, fn) {
        def path = ''
        if(GrailsUtil.getEnvironment() == "development") {
            path = 'web-app/upload/' + dn + '/' + fn
        } else if (GrailsUtil.getEnvironment() == "production") {
            path = 'webapps/imis/upload/' + dn + '/' + fn
        } else {
            throw new Exception()
        }
        return new File(path)    
    }

    static listUploadFolder(dn) {
        def path = ''
        if(GrailsUtil.getEnvironment() == "development") {
            path = 'web-app/upload/' + dn
        } else if (GrailsUtil.getEnvironment() == "production") {
            path = 'webapps/imis/upload/' + dn
        } else {
            throw new Exception()
        }
        def list = []
        def dir = new File(path)
        dir.eachFileRecurse (FileType.FILES) { file ->
            list << file
        }
        return list
    }

    static uuid() {
        return UUID.randomUUID() as String
    }

    static bufferedReader2String(br) {
        def sb = new StringBuilder()
        def line = ''
        while ((line = br.readLine()) != null) {
		    sb.append(line);
		}  
        return sb.toString()
    }

}

