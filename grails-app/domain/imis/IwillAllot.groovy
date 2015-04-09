package imis

class IwillAllot {
    String sno
    String date
    String catg
    String data
    String sp
    String remark
    double amount
    // system field
    Date dateCreated
    Date lastUpdated

    static constraints = {
        remark (blank: true, nullable: true)
        sp (blank: true, nullable: true)
    }
}
