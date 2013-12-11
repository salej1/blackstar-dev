<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="dashboard" />
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

</head>
<body>
<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->		
<!-- INICIA CONTENIDO DE PERFILES sysCallCenter Y sysCoordinator-->
	<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['sysCallCenter']}" />
	<c:if test="${sysCallCenter == true}">

		<!-- TABLA DE TICKETS POR ASIGNAR - unassignedTickets.jsp -->
		<c:import url="unassignedTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				unassignedTickets_init();
			});
		</script>

		<!-- TABLA DE ORDENES DE SERVICIO POR REVISAR - newServiceOrders.jsp -->
		<c:import url="newServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				newServiceOrders_init();
			});
		</script>

		<!-- TABLA DE ORDENES DE SERVICIO CON PENDIENTES - pendingServiceOrders.jsp -->
		<c:import url="pendingServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingServiceOrders_init();
			});
		</script>
	</c:if>

<!-- FIN CONTENIDO DE PERFILES sysCallCenter Y sysCoordinator -->

<!-- INICIA CONTENIDO DE PERFIL sysServicio -->

	<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['sysServicio']}" />
	<c:if test="${sysServicio == true}">

		<!-- TABLA DE SERVICIOS PROGRAMADOS - pendingServiceOrders.jsp -->
		<c:import url="scheduledPersonalServices.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				scheduledPersonalServices_init();
			});
		</script>

	</c:if>

<!-- FIN CONTENIDO DE PERFIL sysServicio -->

</div>
</body>
</html>