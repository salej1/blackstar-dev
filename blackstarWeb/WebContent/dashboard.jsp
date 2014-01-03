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
	<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['Call Center']}" />
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

	<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
	<c:if test="${sysServicio == true}">

<!-- LINKS PARA CREAR ORDENES DE SERVICIO -->
	<div>
		<div>
			<img src="/img/navigate-right.png"/><a href="/dashboard/createServiceOrder.do?">Crear Orden de Servicio</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="/dashboard/createServiceOrder.do?equipmentType=aa">Crear Reporte de Aire Acondicionado</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="/dashboard/createServiceOrder.do?equipmentType=bb">Crear Reporte de Baterias</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="/dashboard/createServiceOrder.do?equipmentType=pe">Crear Reporte de Planta de emergencia</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="/dashboard/createServiceOrder.do?equipmentType=ups">Crear UPS</a>
		</div>
		<p><small>&nbsp;</small></p>
	</div>

<!-- FIN LINKS PARA CREAR ORDENES DE SERVICIO -->

<!-- TABLA DE SERVICIOS PROGRAMADOS - pendingServiceOrders.jsp -->
		<c:import url="scheduledPersonalServices.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				scheduledPersonalServices_init();
			});
		</script>
<!-- TABLA DE SERVICIOS PROGRAMADOS - pendingServiceOrders.jsp -->

<!-- TABLA DE TICKETS ASIGNADOS -->
		<c:import url="assignedTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				assignedTickets_init();
			});
		</script>
<!-- FIN TABLA DE TICKETS ASIGNADOS -->

<!-- TABLA DE ORDENES DE SERVICIO CON PENDIENTES -->
		<c:import url="pendingPersonalServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingPersonalServiceOrders_init();
			});
		</script>
<!-- FIN TABLA DE ORDENES DE SERVICIO CON PENDIENTES -->
	</c:if>

<!-- FIN CONTENIDO DE PERFIL sysServicio -->

</div>
</body>
</html>