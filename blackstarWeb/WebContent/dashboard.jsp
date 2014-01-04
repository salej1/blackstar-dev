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

<!-- Inicia Contenido De Perfiles Syscallcenter Y Syscoordinador-->
	<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['Call Center'] || user.belongsToGroup['Coordinador']}" />
	<c:if test="${sysCallCenter == true}">

		<!-- Tabla De Tickets Por Asignar - Unassignedtickets.jsp -->
		<c:import url="unassignedTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				unassignedTickets_init();
			});
		</script>

		<!-- Tabla De Ordenes De Servicio Por Revisar - Newserviceorders.jsp -->
		<c:import url="newServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				newServiceOrders_init();
			});
		</script>

		<!-- Tabla De Ordenes De Servicio Con Pendientes - Pendingserviceorders.jsp -->
		<c:import url="pendingServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingServiceOrders_init();
			});
		</script>
	</c:if>

<!-- Fin Contenido De Perfiles Syscallcenter Y Syscoordinator -->

<!-- Inicia Contenido De Perfil Sysservicio -->

	<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
	<c:if test="${sysServicio == true}">

<!-- Links Para Crear Ordenes De Servicio -->
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

<!-- Fin Links Para Crear Ordenes De Servicio -->

<!-- Tabla De Servicios Programados - Pendingserviceorders.jsp -->
		<c:import url="scheduledPersonalServices.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				scheduledPersonalServices_init();
			});
		</script>
<!-- Tabla De Servicios Programados - Pendingserviceorders.jsp -->

<!-- Tabla De Tickets Asignados -->
		<c:import url="assignedTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				assignedTickets_init();
			});
		</script>
<!-- Fin Tabla De Tickets Asignados -->

<!-- Tabla De Ordenes De Servicio Con Pendientes -->
		<c:import url="pendingPersonalServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingPersonalServiceOrders_init();
			});
		</script>
<!-- Fin Tabla De Ordenes De Servicio Con Pendientes -->
	</c:if>

<!-- Fin Contenido De Perfil Sysservicio -->

</div>
</body>
</html>