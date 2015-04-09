<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="w8"/>
    <style type="text/css" media="screen">
    </style>
    <script type="text/javascript">
    $(function() {
        $('.delbtn').click(function() {
            if(!confirm('确定删除吗？')) {
                return false;
            }    
        });
    })    
    </script>
</head>
<content tag="title">拆帐明细</content>
<content tag="subtitle">....</content>
<body>
<div class="row">
    <div class="span2 offset5">
        <g:if test="${msg}">
            <p class="text-success lead">${msg} </p>
        </g:if>
    </div>
</div>

<div class="row">
    <div class="span10 offset1">
        <form class="form-horizontal" method="POST" action="allotDetailSave">
            <div class="control-group">
                <label class="control-label" for="remark">备注</label>
                <div class="controls">
                    <input name="remark" class="input-xxlarge" id="remark" type="text" value="" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="amount">金额</label>
                <div class="controls">
                    <input name="amount" class="input-small" type="text" id="acount" value="" />
                </div>                
            </div>
            <div class="control-group">
                <div class="controls">
                    <input type="hidden" name="sno" value="${params.sno}"/>
                    <input type="hidden" name="date" value="${params.date}"/>
                    <input type="hidden" name="catg" value="${params.catg}"/>
                    <input type="hidden" name="data" value="${params.data}"/>
                    <input type="hidden" name="sp" value="${params.sp}"/>
                    <button type="submit" name="summit" value="true" class="btn btn-primary">新增</button>
                </div>
            </div>
        </form>    
    </div>
</div>

<div class="row">
    <div class="span10 offset1">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>单号</th>
                    <th>日期</th>
                    <th>中分类名称</th>
                    <th>分类</th>
                    <th>品号</th>
                    <th>品名</th>
                    <th>单价</th>
                    <th>数量</th>
                </tr>
            </thead>
            <tbody id="data">
                <g:each in="${extraList}" status="i" var="it">
                    <tr>
                        <td colspan="6">${it.remark}</td>
                        <td>${it.amount}</td>
                        <td>
                            <a href="allotDetailDel?sno=${params.sno}&date=${params.date}&catg=${params.catg}&data=${params.data}&sp=${params.sp}&del=${it.id}" class="btn btn-primary delbtn">删</a>
                        </td>
                    </tr> 
                </g:each>
                <g:each in="${list}" status="i" var="it">
                    <tr>
                        <td>${it.THE_NO}</td> 
                        <td>${it.THE_DATE}</td> 
                        <td>${it.D_CNAME}</td> 
                        <td>${iwill.AllotDao.prType[it.PR_TYPE]}</td> 
                        <td>${it.P_NO}</td> 
                        <td>${it.P_NAME}</td> 
                        <td>${it.P_PRICE}</td> 
                        <td>${it.P_QTY}</td> 

                    </tr>
                </g:each>             
            </tbody>
        </table>
    </div>
</div>
    
</body>
</html>
