package iwill

import groovy.json.JsonSlurper
import imis.*
import java.net.*

class Job {

    public void getAndSaveBaiduWeather() {
        def area = [
            '%E6%97%A0%E9%94%A1', // 无锡 
            '%E8%8B%8F%E5%B7%9E', // 苏州 
            '%E5%B8%B8%E7%86%9F', // 常熟 
            '%E5%BC%A0%E5%AE%B6%E6%B8%AF',  // 张家港 
            '%E6%98%86%E5%B1%B1', // 昆山
            '%E5%90%B4%E4%B8%AD', // 吴中 
            '%E5%A4%AA%E4%BB%93', // 太仓
            '%E5%90%B4%E6%B1%9F' // 吴江
        ]
        area.each {
            def text = new URL("http://api.map.baidu.com/telematics/v3/weather?location=${it}&output=json&ak=XfsEZwidl14IVB2GiOEYBfhT").getText("UTF-8")
            def json = new JsonSlurper().parseText(text)
            if (json.error == 0 && json.status == 'success') {
                def foo = json.results[0]
                def date = json.date.replace('-', '')
                def ibw = IwillBaiduWeather.findWhere(city: foo.currentCity, date: date)
                println ibw
                if (!ibw) {
                    ibw = new IwillBaiduWeather()
                    ibw.city = foo.currentCity
                    ibw.date = date
                    ibw.week = foo.weather_data[0].date.substring(0, 2)
                    ibw.weather = foo.weather_data[0].weather
                    ibw.wind = foo.weather_data[0].wind
                    ibw.temperature = foo.weather_data[0].temperature
                    ibw.week1 = foo.weather_data[1].date
                    ibw.weather1 = foo.weather_data[1].weather
                    ibw.wind1 = foo.weather_data[1].wind
                    ibw.temperature1 = foo.weather_data[1].temperature
                    ibw.week2 = foo.weather_data[2].date
                    ibw.weather2 = foo.weather_data[2].weather
                    ibw.wind2 = foo.weather_data[2].wind
                    ibw.temperature2 = foo.weather_data[2].temperature
                    ibw.week3 = foo.weather_data[3].date
                    ibw.weather3 = foo.weather_data[3].weather
                    ibw.wind3 = foo.weather_data[3].wind
                    ibw.temperature3 = foo.weather_data[3].temperature
                    ibw.save()
                } 
            }
            println '-------------------------'
        }
    }

    public void getAndSaveWeather() {
        // http://blog.21004.com/post/178.html 說明
        def area = ['101190201' // 无锡
            , '101190401' // 苏州
            , '101190402' // 常熟
            , '101190403' // 张家港
            , '101190404' // 昆山
            , '101190405' // 吴中
            , '101190407' // 吴江
            ]
        area.each {
            // 先去抓資料
            def text = new URL("http://m.weather.com.cn/data/${it}.html").getText('UTF-8')
            def json = new JsonSlurper().parseText(text)

            // 檢查取得的資料是否存在, 有資料就不存了.
            println '---------'
            def iw = IwillWeather.findWhere(cityid: json.weatherinfo.cityid, date_y: json.weatherinfo.date_y)
            println iw
            if (!iw) {
                println '=========='
                iw = new IwillWeather()
                iw.properties = json.weatherinfo
                iw.index_c = json.weatherinfo.index // 保留字特殊處理
                iw.date = Date.parse("yyyy年MM月dd日", json.weatherinfo.date_y).format('yyyyMMdd') // date 都是空白的 更新成POS日期格式
                def re = /-?\d+/
                def matcher = json.weatherinfo.temp1 =~ re
                def foo = [matcher[0].toInteger(), matcher[1].toInteger()]
                iw.temp1n = foo.min()
                iw.temp1d = foo.max()
                matcher = json.weatherinfo.temp2 =~ re
                foo = [matcher[0].toInteger(), matcher[1].toInteger()]
                iw.temp2n = foo.min()
                iw.temp2d = foo.max()
                matcher = json.weatherinfo.temp3 =~ re
                foo = [matcher[0].toInteger(), matcher[1].toInteger()]
                iw.temp3n = foo.min()
                iw.temp3d = foo.max()
                matcher = json.weatherinfo.temp4 =~ re
                foo = [matcher[0].toInteger(), matcher[1].toInteger()]
                iw.temp4n = foo.min()
                iw.temp4d = foo.max()
                matcher = json.weatherinfo.temp5 =~ re
                foo = [matcher[0].toInteger(), matcher[1].toInteger()]
                iw.temp5n = foo.min()
                iw.temp5d = foo.max()
                matcher = json.weatherinfo.temp6 =~ re
                foo = [matcher[0].toInteger(), matcher[1].toInteger()]
                iw.temp6n = foo.min()
                iw.temp6d = foo.max()
                iw.save()
            }
        }
    } 

}

