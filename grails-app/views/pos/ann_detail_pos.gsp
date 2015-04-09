<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta name="layout" content="w8_pos"/>
    <style type="text/css" media="screen">
    
    #ifc {
        height: auto !important;
        height: 1500px;
        width: 100%;
        min-height: 1500px;
        max-height: 9000px;
    }
    </style>
    <script type="text/javascript">
    $(function() {
    })
    </script>
</head>
<content tag="title">签报单</content>
<content tag="subtitle"></content>
<body>

<div class="row">
    <div class="span10 offset1">
        <g:if test="${flash.msg}">
            <div class="alert alert-info text-center">${flash.msg}</div>
        </g:if>
        <table class="table">
            <tr>
                <td>
                    <g:link action="ann_pos" class="btn btn-primary">返回列表</g:link>
                </td>
                <td>
                    <ul>
                        <li>编号: ${ann.code}</li>
                        <li>标题: ${ann.title}</li>
                        <li>日期: ${ann.annDate}</li>
                        <li>经办人: ${ann.handler}</li>
                    </ul> 
                </td>
                <td>
                    <g:if test="${annSign}">
                        ${annSign.opName} ${iwill._.date2String(annSign.dateCreated, 'yyyy/MM/dd HH:mm:ss')}
                    </g:if>
                    <g:if test="${s_no && !annSign}">
                        <form method="POST">
                            POS帐号: <input type="text" name="account" class="input-small"/><br/>
                            POS密码: <input type="password" name="password" class="input-small"/>
                            <input type="hidden" name="s_no" value="${s_no}"/>
                            <button type="submit" name="signit" value="hmm" class="btn btn-primary">${s_name}看了</button>
                        </form>
                    </g:if>
                </td>
            </tr>
        </table>
    </div>
</div>
<div class="row">
    <div class="span10 offset1">
        <iframe id="ifc" src="${url}" frameborder="0"></iframe> 
    </div>
</div>
    
</body>
</html>
