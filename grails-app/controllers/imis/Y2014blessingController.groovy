package imis

class Y2014blessingController extends BaseController {

    def index() {
        def lights = Y2014blessing.list(sort: 'id', order: 'desc')
        
        [lights: lights]
    }


    def bless() { 
        if (params.pray) {
            def light = new Y2014blessing(params)
            light.save()
            redirect(controller: 'y2014blessing')
            return
        }
    }

}
