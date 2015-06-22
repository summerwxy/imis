package imis
import iwill.*
import grails.util.Environment


class Log22DataJob {
    static triggers = {
        cron name: 'Log22DataTrigger', startDelay:30000, cronExpression: '0 0/5 * * * ?'
    }

    def execute() {
        if (Environment.current == Environment.PRODUCTION) {
            def job = new Job()
            job.get22DataLog()
        }
    }
}
