<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="wechat"/>
    <style>
    body { 
    
    }
    </style> 
    <script type="text/javascript">
    </script>
</head>
<body>



    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <g:if test="${msg}">
                    <div class="alert alert-danger" role="alert">${msg}</div> 
                </g:if>

                <h5>${session.user.nickname} 你好：</h5>
                <g:if test="${!session.user.vipNo}">
                    <form>
                        你还没绑定会员卡！
                        <br/>
                        <br/>
                        <div class="form-group">
                            <label>手机号码</label>
                            <input type="text" class="form-control" name="phone" placeholder="13812345678">
                        </div>
                        <div class="form-group">
                            <label>生日 (格式: yyyyMMdd)</label>
                            <input type="password" class="form-control" name="bday" placeholder="19870228">
                        </div>
                        <button type="submit" name="bind" value="vip" class="btn btn-success">绑定</button>
                    </form>
                </g:if>
                <g:if test="${summary}">
                    <table class="table table-bordered">
                        <tr>
                            <td>会员卡号：</td>
                            <td>${summary.CC_NO}</td>
                        </tr>
                        <tr>
                            <td>姓名：</td>
                            <td>${summary.C_NAME}</td>
                        </tr>
                        <tr>
                            <td>生日：</td>
                            <td>${summary.bday}</td>
                        </tr>
                        <tr>
                            <td>手机号码：</td>
                            <td>${summary.C_MOB}</td>
                        </tr>
                        <tr>
                            <td>积分：</td>
                            <td>${summary.C_POINT}</td>
                        </tr>
                        <tr>
                            <td>最近消费金额：</td>
                            <td>${summary.C_LAST}</td>
                        </tr>
                        <tr>
                            <td>今年消费金额：</td>
                            <td>${summary.C_TAMT}</td>
                        </tr>
                    </table>
                </g:if>
                <g:if test="${rows}">
                    <h5>最近 10 次消费明细</h5>
                    <table class="table table-condensed">
                        <tr>
                            <th>门店</th>
                            <th>日期</th>
                            <th>品名</th>
                            <th>数量</th>
                        </tr>
                        <g:each in="${rows}" status="i" var="it">
                            <tr style="${it.color ? '' : 'background: #fcf8e3;'}">
                                <td>${it.S_NAME}  ${it.color}</td>
                                <td>${it.SL_DATE}</td>
                                <td>${it.P_NAME}</td>
                                <td>${it.SL_QTY}</td>
                            </tr>
                        </g:each>
                    </table>
                </g:if>

            </div>
        </div>
    </div>

</body>
</html>
