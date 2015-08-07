package imis

class MooncakeOrderH {

    static hasMany = [ d: MooncakeOrderD ]

    String wxUserId
    String name
    String phone
    String shipTime
    String type
    String address
    String comment
    // 电脑的栏位
    String orderSno
    String shipSno
    String username
    
    String slKey
    String status

    // system data
    Date dateCreated
    Date lastUpdated


    static constraints = {
    }
}
