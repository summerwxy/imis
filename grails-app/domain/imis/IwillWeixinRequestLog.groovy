package imis

class IwillWeixinRequestLog {
    // standard data
    String ToUserName
    String FromUserName
    long CreateTime
    String MsgType
    String Content
    long MsgId
    String PicUrl
    String MediaId
    String ThumbMediaId
    String Location_X
    String Location_Y
    String Scale
    String Label
    String Title
    String Description
    String Url
    String Event
    String EventKey
    String Ticket
    String Latitude
    String Longitude
    String Precision
    String Format
    String Recognition

    // system data
    Date dateCreated
    Date lastUpdated

    static constraints = {
        content (nullable: true)
        picUrl (nullable: true)
        mediaId (nullable: true)
        thumbMediaId (nullable: true)
        location_X (nullable: true)
        location_Y (nullable: true)
        scale (nullable: true)
        label (nullable: true)
        title (nullable: true)
        description (nullable: true)
        url (nullable: true)
        event (nullable: true)
        eventKey (nullable: true)
        ticket (nullable: true)
        latitude (nullable: true)
        longitude (nullable: true)
        precision (nullable: true)
        format (nullable: true)
        recognition (nullable: true)
    }
}
