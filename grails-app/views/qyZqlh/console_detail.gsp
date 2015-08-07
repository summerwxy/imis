<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>

    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    $(function() {
        $('.selectize').selectize();

        $('#the_form').on('submit', function() {
            var f1 = $('#username').val();
            var f2 = $('#order_sno').val();
            var f3 = $('#ship_sno').val();
            if (f1 && f2 && f3) {
                // submit it
            } else {
                alert('请把资料填写齐全！');
                return false;
            }
        });

    })
    </script>
</head>
<content tag="title">微信订单</content>
<content tag="subtitle">订单管理后台</content>
<body>

<div class="row">
    <div class="span10 offset1">
        <g:form name="the_form" action="console_detail">
            <table class="table">
                <tr>
                    <th colspan="6">状态：${imis.QyZqlhController.status[h.all_status]}</th>
                </tr>
                <tr>
                    <th>微信号</th>
                    <td>${h.wxname}</td>
                    <th>联络人</th>
                    <td>${h.name}</td>
                    <th>联系电话</th>
                    <td>${h.phone}</td>
                </tr>
                <tr>
                    <th>提货时间</th>
                    <td>${h.ship_time}</td>
                    <th>提货方式</th>
                    <td>${['0': '门店取货', '1': '送货上门', '2': '工厂自取'][h.type]}</td>
                    <th>门店/地址</th>
                    <td>${h.address}</td>
                </tr>

                <g:if test="${h.all_status == 'init'}">
                    <tr>
                        <th>建档人</th>
                        <td>
                            <input type="text" id="username" name="username" />
                        </td>
                        <th>业务员</th>
                        <td>
                            <select id="order_sno" name="order_sno" class="selectize" placeholder="请选择业务员...">
                                <option value="">选择业务员...</option>
                                <g:each in="${store}" status="i" var="it">
                                    <option value="${it.value}">${it.label}</option>
                                </g:each>
                            </select>
                        </td>
                        <th>送货门店</th>
                        <td>
                            <select id="ship_sno" name="ship_sno" class="selectize" placeholder="请选择送货门店...">
                                <option value="">选择送货门店...</option>
                                <g:each in="${store}" status="i" var="it">
                                    <option value="${it.value}">${it.label}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                </g:if>
                <g:else>
                    <tr>
                        <th>建档人</th>
                        <td>${h.username}</td>
                        <th>业务员</th>
                        <td>${h.order_sname}</td>
                        <th>送货门店</th>
                        <td>${h.ship_sname}</td>
                    </tr>
                </g:else>

                <tr>
                    <th>备注</th>
                    <td colspan="5">${h.comment}</td>
                </tr>
                <tr>
                    <td colspan="6" style="text-align: center;">
                        <input type="hidden" name="id" value="${h.id}"/>
                        <g:if test="${h.all_status == 'init'}">
                            <button type="submit" name="transfer" value="true" class="btn btn-primary">转POS 2K1</button>
                        </g:if>
                        <g:if test="${h.all_status == 'ship_c'}">
                            <button type="submit" name="back" value="true" class="btn btn-primary">转POS 9F1</button>
                        </g:if>

                    </td>
                </tr>
                 
            </table>
        </g:form>

        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>品名</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>单位</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${d}" status="i" var="it">
                    <tr>
                        <td>${it.P_NAME}</td>
                        <td>${it.P_PRICE.toInteger()}</td>
                        <td>${it.qty}</td>
                        <td>${it.UN_NO}</td>
                    </tr>
                </g:each> 
            </tbody>
        </table>
    
    </div>
</div>
    
</body>
</html>
