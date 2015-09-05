package imis

class Mooncake2ExpressD {

    static belongsTo = [ h:Mooncake2ExpressH ]

    String vid

    // system data
    Date dateCreated
    Date lastUpdated


    static constraints = {
    }
}
