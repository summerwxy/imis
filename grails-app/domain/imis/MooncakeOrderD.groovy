package imis

class MooncakeOrderD {

    static belongsTo = [ h:MooncakeOrderH ]

    String pNo
    long qty

    // system data
    Date dateCreated
    Date lastUpdated

    static constraints = {
    }
}
