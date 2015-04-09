
<%@ page import="imis.IwillData1" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'iwillData1.label', default: 'IwillData1')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-iwillData1" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-iwillData1" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="dateCreated" title="${message(code: 'iwillData1.dateCreated.label', default: 'Date Created')}" />
					
						<g:sortableColumn property="enable" title="${message(code: 'iwillData1.enable.label', default: 'Enable')}" />
					
						<g:sortableColumn property="lastUpdated" title="${message(code: 'iwillData1.lastUpdated.label', default: 'Last Updated')}" />
					
						<g:sortableColumn property="name" title="${message(code: 'iwillData1.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="phone" title="${message(code: 'iwillData1.phone.label', default: 'Phone')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${iwillData1InstanceList}" status="i" var="iwillData1Instance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${iwillData1Instance.id}">${fieldValue(bean: iwillData1Instance, field: "dateCreated")}</g:link></td>
					
						<td><g:formatBoolean boolean="${iwillData1Instance.enable}" /></td>
					
						<td><g:formatDate date="${iwillData1Instance.lastUpdated}" /></td>
					
						<td>${fieldValue(bean: iwillData1Instance, field: "name")}</td>
					
						<td>${fieldValue(bean: iwillData1Instance, field: "phone")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${iwillData1InstanceTotal}" />
			</div>
		</div>
	</body>
</html>
