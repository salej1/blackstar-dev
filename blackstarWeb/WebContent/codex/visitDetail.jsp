<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="clientes" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Prospecto</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen"/>
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>	
	<script src="${pageContext.request.contextPath}/js/jquery.ui.datepicker.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common/popup.js"></script>
	
	
	<script type="text/javascript">
	   $(function(){
	   		if("${mode}" == "new" || "${isEditable}" == "true"){
		   		$("#visitDate").datepicker();
	   		}
	   		else{
	   			if("${isEditable}" == "false"){
	   				$(".editable").attr("disabled", "");
	   			}
	   		}
	   });

	   function discard(){
	   		$("#visitStatusId").val(3);
	   		$("#visit").submit();
	   }
	</script>
	
	
	
	<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>Visita a Cliente</h2>
                        <form:form  commandName="visit" action="${pageContext.request.contextPath}/codex/visit/insert.do">
						<table>
							<tr>
								<td>Cliente:</td>
								<td><form:select items="${clients}" itemLabel="corporateName" itemValue="id" style="width:95%;" path="codexClientId" class="editable"/></td>
							</tr>
							<tr>
								<td>Fecha:</td>
								<td><form:input type="text" style="width:50%;" path="visitDate" readOnly="true" required="true" class="editable"/></td>
							</tr>
							<tr>
								<td>CST:</td>
								<td><form:select items="${cstList}" itemLabel="name" itemValue="cstId" style="width:50%;" path="cstId" class="editable"/></td>
							</tr>
							<tr>
								<td>Comentarios:</td>
								<td><form:input type="text" style="width:95%;" path="description" class="editable"/></td>
							</tr>
							<tr>
								<td>Estatus:</td>
								<td><form:select items="${statusList}" itemLabel="visitStatus" itemValue="visitStatusId" style="width:50%;" path="visitStatusId"  class="editable"/></td>
							</tr>
						</table>
						<p></p>
						<div>
							<c:if test="${isEditable}">
								<button class="searchButton" onclick="submit();">Guardar</button>
								<button class="searchButton" onclick="discard();">Descartar</button>
								<button class="searchButton" onclick="window.location='/dashboard'">Cerrar</button>
							</c:if>
						</div>
						</form:form>
					</div>					
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
								
<!--   ~ CONTENT COLUMN   -->

<!--   ~ CONTENT   -->
			</div>