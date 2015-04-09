
<%@ page import="imis.IwillData1" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'iwillData1.label', default: 'IwillData1')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-iwillData1" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-iwillData1" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list iwillData1">
			
				<g:if test="${iwillData1Instance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="iwillData1.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${iwillData1Instance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${iwillData1Instance?.enable}">
				<li class="fieldcontain">
					<span id="enable-label" class="property-label"><g:message code="iwillData1.enable.label" default="Enable" /></span>
					
						<span class="property-value" aria-labelledby="enable-label"><g:formatBoolean boolean="${iwillData1Instance?.enable}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${iwillData1Instance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="iwillData1.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${iwillData1Instance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${iwillData1Instance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="iwillData1.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${iwillData1Instance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${iwillData1Instance?.phone}">
				<li class="fieldcontain">
					<span id="phone-label" class="property-label"><g:message code="iwillData1.phone.label" default="Phone" /></span>
					
						<span class="property-value" aria-labelledby="phone-label"><g:fieldValue bean="${iwillData1Instance}" field="phone"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${iwillData1Instance?.id}" />
					<g:link class="edit" action="edit" id="${iwillData1Instance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
