package imis

class IwillBooking {
    String title
    String body
    String startTime
    String endTime
    int userId
    Date dateCreated 
    Date lastUpdated

    static mapping = {
        body type: 'text'
    }


    static constraints = {

    }
}
