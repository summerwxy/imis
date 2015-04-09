package imis

class IwillWeixinUser {
    // standard data
    String openid
    String nickname
    String sex
    String language
    String city
    String province
    String country
    String headimgurl
    String subscribe_time
    // location data
    String latitude
    String longitude
    String precision
    // system data
    Date dateCreated
    Date lastUpdated

    static constraints = {
        nickname (nullable: true)
        sex (nullable: true)
        language (nullable: true)
        city (nullable: true)
        province (nullable: true)
        country (nullable: true)
        headimgurl (nullable: true)
        subscribe_time (nullable: true)
        latitude (nullable: true)
        longitude (nullable: true)
        precision (nullable: true)
    }
}
