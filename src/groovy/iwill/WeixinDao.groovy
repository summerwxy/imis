package iwill

class WeixinDao {

    static updateUserLocation(map) {
        def sql = _.sql
        def s = "UPDATE iwill_weixin_user SET latitude = ?, longitude = ? WHERE openid = ?"
        sql.execute(s, [map['Latitude'], map['Longitude'], map['FromUserName']])
    }

 

}

