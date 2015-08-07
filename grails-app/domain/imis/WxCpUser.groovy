package imis

class WxCpUser {
    String userId
    String name
    // Integer[] departIds
    String position
    String mobile
    String gender
    String tel
    String email
    String weiXinId
    String avatar
    Integer status
    // List<Attr> extAttrs = new ArrayList<Attr>();

    // system data
    Date dateCreated
    Date lastUpdated

    static constraints = {
    }
}
