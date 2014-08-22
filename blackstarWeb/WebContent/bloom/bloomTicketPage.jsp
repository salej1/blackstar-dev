<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="requisiciones" />
<c:import url="${pageContext.request.contextPath}/header.jsp"></c:import>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
		<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>

		<title>Requisiciones</title>
	</head>
	<body>

<!--   CONTENT COLUMN   -->		
		<div id="content" class="container_16 clearfix">
				
		<!-- Link para crear nuevo ticket interno - Disponible para todos menos para el cliente -->
		<c:set var="sysCliente" scope="request" value="${user.belongsToGroup['Cliente']}" />
		<c:if test="${sysCliente == null || sysCliente == false}">
			<c:import url="newInternalTicketLink.jsp"></c:import>
		</c:if>
		<!-- FIN Link para crear nuevo ticket interno  -->

		<!-- Requisiciones por cerrar - Disponible solo apra usuarios responsables de Req -->
		<c:set var="reqViewer" scope="session" value="${user.belongsToGroup['Lider de Ingenieria'] || user.belongsToGroup['Ingeniero de Soporte'] || user.belongsToGroup['Gerente de Implementación y Servicio'] || user.belongsToGroup['Ingeniero de Redes y Monitoreo'] || user.belongsToGroup['Jefe de Compras'] || user.belongsToGroup['Compras'] || user.belongsToGroup['Jefe de Capital Humano'] || user.belongsToGroup['Gerente de Calidad']}"/> 
		<c:if test="${reqViewer == true}">
			
			<!-- Tabla De Tickets internos pendientes - bloomPendingInternalTickets.jsp -->
			<c:import url="bloomPendingInternalTickets.jsp"></c:import>
			<script type="text/javascript">
				$(function(){
					pendingInternalTicketsInit();
				});
			</script>
			
		</c:if>
		<!-- FIN Requisiciones por cerrar - Disponible solo apra usuarios responsables de Req -->

		<!-- Historico de requisiciones, disponible para todos los usuarios grupo sac -->
			<!-- Tabla De Tickets internos pendientes - bloomPendingInternalTickets.jsp -->
			<c:import url="bloomHistoricalTickets.jsp"></c:import>
			<script type="text/javascript">
				$(function(){
					historicalInternalTicketsInit();
				});
			</script>
		<!-- FIN Historico de requisiciones, disponible para todos los usuarios grupo sac -->
			
		</div>
	</body>
</html>