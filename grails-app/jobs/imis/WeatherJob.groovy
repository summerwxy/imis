package imis

import iwill.*

class WeatherJob {
    static triggers = {
        // simple repeatInterval: 500000l // execute job once in 5 seconds
        // 每六小時 30 分 執行一次
        cron name: 'weatherTrigger', startDelay:30000, cronExpression: '0 0 6-18 * * ?'
    }

    def execute() {
        // execute job
        def job = new Job()
        job.getAndSaveBaiduWeather()
    }
}
