package imis

class Mooncake2ExpressH {

    static hasMany = [ d: Mooncake2ExpressD ]

    String name
    String phone
    String address
    String lv1
    String lv2
    String lv3
    float kg
    float fee
    
    String expressNo
    String status

    float lat
    float lng

    // system data
    Date dateCreated
    Date lastUpdated
    
    static constraints = {
        lat(nullable: true)        
        lng(nullable: true)        
    }
}
