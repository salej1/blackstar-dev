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
<script src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>
<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>

<title>Portal de Servicios</title>

</script>
</head>
<body>
<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->		
    <c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
	
<!-- Inicia Contenido De Perfiles Syscallcenter Y Syscoordinador-->
	<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['Call Center']}" />
	<c:if test="${sysCallCenter == true}">

       <p><small>&nbsp;</small></p>
   		<!-- Seleccion de filtro por oficina -->
		<c:import url="officeFilter.jsp"></c:import>

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
		

		<!-- La inicializacion se hace una vez que se pintaron las tablas -->
		<script type="text/javascript">
			$(function(){
				officeFilter_init();
			});
		</script>
	</c:if>
<!-- Fin Contenido De Perfiles Syscallcenter Y Syscoordinator -->



<!-- Inicia Contenido De Perfiles Syscoordinador-->
	<c:set var="sysCoordinador" scope="request" value="${user.belongsToGroup['Coordinador']}" />
	<c:if test="${sysCoordinador == true}">

        <p><small>&nbsp;</small></p>
		<!-- Seleccion de filtro por oficina -->
		<c:import url="officeFilter.jsp"></c:import>

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
		

		<!-- La inicializacion se hace una vez que se pintaron las tablas -->
		<script type="text/javascript">
			$(function(){
				officeFilter_init();
			});
		</script>
	</c:if>
<!-- Fin Contenido De Perfiles Syscoordinator -->


<!-- Inicia Contenido De Perfil Sysservicio -->

	<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
	<c:if test="${sysServicio == true}">

<!-- Links Para Crear Ordenes De Servicio -->
		<c:import url="newOSLinks.jsp"></c:import>
		<p><small>&nbsp;</small></p>
		<script type="text/javascript">
			$(function(){
				newOSLinks_init();
			});
		</script>
<!-- Fin Links Para Crear Ordenes De Servicio -->

<!-- Tabla de servicios programados -->
		<c:import url="scheduledPersonalServices.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				scheduledPersonalServices_init();
			});
		</script>
<!-- Fin Tabla de servicios programados -->

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
	

	<!-- Link para crear nuevo ticket interno - Disponible para todos menos para el cliente -->
	<c:set var="sysCliente" scope="request" value="${user.belongsToGroup['Cliente']}" />
	<c:if test="${sysCliente == null || sysCliente == false}">
		<c:import url="bloom/newInternalTicketLink.jsp"></c:import>
	</c:if>
	<!-- FIN Link para crear nuevo ticket interno  -->

	<!-- Requisiciones por cerrar - Disponible solo apra usuarios responsables de Req -->
	<c:set var="reqViewer" scope="session" value="${user.belongsToGroup['Lider de Ingenieria'] || user.belongsToGroup['Ingeniero de Soporte'] || user.belongsToGroup['Gerente de Implementación y Servicio'] || user.belongsToGroup['Ingeniero de Redes y Monitoreo'] || user.belongsToGroup['Jefe de Compras'] || user.belongsToGroup['Compras'] || user.belongsToGroup['Jefe de Capital Humano'] || user.belongsToGroup['Gerente de Calidad']}"/> 
	<c:if test="${reqViewer == true}">
		
		<!-- Tabla De Tickets internos pendientes - bloomPendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomPendingInternalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingInternalTicketsInit();
			});
		</script>
		
	</c:if>
	<!-- FIN Requisiciones por cerrar - Disponible solo apra usuarios responsables de Req -->

	<!-- Historico de requisiciones, disponible para todos los usuarios grupo sac -->
		<!-- Tabla De Tickets internos pendientes - bloomPendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomHistoricalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				historicalInternalTicketsInit();
			});
		</script>
	<!-- FIN Historico de requisiciones, disponible para todos los usuarios grupo sac -->
		

</div>
</body>
</html>