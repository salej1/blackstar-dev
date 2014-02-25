<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="encuestas" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
		<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

		<title>Ordenes de servicio</title>
	</head>
	<body>

<!--   CONTENT COLUMN   -->		
		<div id="content" class="container_16 clearfix">
			<div>
				<div>
					<img src="/img/navigate-right.png"/><a href="/surveyServiceDetail/show.do?operation=1&idObject=0">Crear Encuesta de Servicio</a>
				</div>
			</div>
			<p><small>&nbsp;</small></p>

			<!-- Tabla de Mis Encuestas de Servicio para Ingenieros de servicio -->
			<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
			<c:if test="${sysServicio == true}">
			<c:import url="personalSurveyServices.jsp"></c:import> <!-- TODO: Implementar -->
				<script type="text/javascript">
					$(function(){
						personalSurveyServices_init();
					});
				</script>
			</c:if>
			
			<!-- Tabla de historico de encuestas de servicio -->
			<c:import url="surveyServicesHistory.jsp"></c:import>
			<script type="text/javascript">
				$(function(){
					surveyServicesHistory_init();
				});
			</script>
		</div>
	</body>
</html>