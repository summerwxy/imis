package imis
import iwill.*


class Log22DataJob {
    static triggers = {
        cron name: 'Log22DataTrigger', startDelay:30000, cronExpression: '0 0/5 * * * ?'
    }

    def execute() {
        def job = new Job()
        job.get22DataLog()
    }
}
