package imis

class MooncakeExpress {

    String name
    String phone
    String address
    
    String expressNo
    String status
    String vid

    float lat
    float lng

    // system data
    Date dateCreated
    Date lastUpdated


    static constraints = {
        lat( nullable: true )
        lng( nullable: true )            
    }
}
