<%@ page import="imis.IwillData1" %>



<div class="fieldcontain ${hasErrors(bean: iwillData1Instance, field: 'enable', 'error')} ">
	<label for="enable">
		<g:message code="iwillData1.enable.label" default="Enable" />
		
	</label>
	<g:checkBox name="enable" value="${iwillData1Instance?.enable}" />
</div>

<div class="fieldcontain ${hasErrors(bean: iwillData1Instance, field: 'name', 'error')} ">
	<label for="name">
		<g:message code="iwillData1.name.label" default="Name" />
		
	</label>
	<g:textField name="name" value="${iwillData1Instance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: iwillData1Instance, field: 'phone', 'error')} ">
	<label for="phone">
		<g:message code="iwillData1.phone.label" default="Phone" />
		
	</label>
	<g:textField name="phone" value="${iwillData1Instance?.phone}"/>
</div>

