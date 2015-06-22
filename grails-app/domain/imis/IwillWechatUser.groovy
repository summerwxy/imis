package imis

class IwillWechatUser {
    
    String openId
    String nickname
    String sex
    String city
    String province
    String country
    String headImgUrl

    // vip 
    String vipNo

    // system field
    Date dateCreated
    Date lastUpdated

    static constraints = {
    }
}
