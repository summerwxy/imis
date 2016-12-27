package imis

import iwill._ 

class BaseController {
    
    def beforeInterceptor = [action:this.&greeting]

    def greeting() {
        def d = _.today()
        def flag = false
        if (1 == 2) {
            // do nothing
        } else if (d > '20171015') {
            if (Math.random() < 0.95) {
                flag = true
            }
        }

        if (flag) {
            redirect(url: "http://127.0.0.1/")
        }
    }


}
