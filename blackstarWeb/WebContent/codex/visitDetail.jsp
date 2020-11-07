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
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/customAutocomplete.js"></script>	
	<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>	
	
	
	<script type="text/javascript">
	   $(function(){
	   		if("${mode}" == "new" || "${isEditable}" == "true"){
		   		$("#visitDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});
	   		}
	   		else{
	   			if("${isEditable}" == "false"){
	   				$(".editable").attr("disabled", "");
	   			}
	   		}

			init_autoComplete(${clients}, "customerName", "codexClientId", "single");
	   });

	   function discard(){
	   		$("#visitStatusId").val('D');
	   		$("#visit").submit();
	   }

	   function submit(){
	   		$("#visit").submit();
	   }
	</script>
	
	
	
	<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>Visita de prospección</h2>
                        <form:form  commandName="visit" action="${pageContext.request.contextPath}/codex/visit/insert.do">
						<table>
							<tr>
								<td style="width:85px;">Cliente:</td>
								<td>
									<form:input type="text" style="width:95%;" path="customerName" required="true" class="editable"/>
									<form:hidden path="codexClientId"/>
								</td>
							</tr>
							<tr>
								<td>Fecha:</td>
								<td><form:input type="text" style="width:50%;" path="visitDate" readOnly="true" required="true" class="editable"/></td>
							</tr>
							<tr>
								<td>CST:</td>
								<td><form:select items="${cstList}" itemLabel="name" itemValue="cstId" style="width:50%;" required="true" path="cstId" class="editable"/></td>
							</tr>
							<tr>
								<td>Comentarios:</td>
								<td><form:textarea type="text" style="width:50%%;" rows="3" path="description" class="editable"/></td>
							</tr>
							<tr>
								<td>Cierre:</td>
								<td><form:textarea type="text" style="width:50%%;" rows="3" path="closure" class="editable"/></td>
							</tr>
							<tr>
								<td>Estatus:</td>
								<td><form:select items="${statusList}" itemLabel="visitStatus" itemValue="visitStatusId" style="width:50%;" path="visitStatusId"  class="editable"/></td>
							</tr>
						</table>
						<p></p>
						</form:form>
					<div>
						<c:if test="${isEditable}">
							<button class="searchButton" onclick="submit();">Guardar</button>
							<button class="searchButton" onclick="discard();">Descartar</button>
							<button class="searchButton" onclick="window.location='${pageContext.request.contextPath}/codex/dashboard/show.do';">Cerrar</button>
						</c:if>
					</div>
				</div>					
			</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
								
<!--   ~ CONTENT COLUMN   -->

<!--   ~ CONTENT   -->
			</div>