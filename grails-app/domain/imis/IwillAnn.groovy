package imis

class IwillAnn {
    String code
    String title
    String handler
    String annDate
    String pageType
    String url
    

    static constraints = {
        code unique: true
        title blank: false, size: 1..300
        handler blank: true
        url blank: true
    }
}
