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

<title>Portal de Servicios</title>
</head>
<body>
<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->		

	<!-- Link para crear nuevo ticket interno - Disponible para todos menos para el cliente -->
	<c:set var="sysCliente" scope="request" value="${user.belongsToGroup['Cliente']}" />
	<c:if test="${sysCliente == null || sysCliente == false}">
		<c:import url="bloom/newInternalTicketLink.jsp"></c:import>
	</c:if>
	<!-- FIN Link para crear nuevo ticket interno  -->

<!-- Inicia Contenido De Perfil Syscoordinador-->
<c:set var="captOsLinks" scope="request" value="${user.belongsToGroup['Coordinador'] || user.belongsToGroup['Implementacion y Servicio']}" />
	<c:if test="${captOsLinks == true}">

<!-- Links Para Crear Ordenes De Servicio -->
		<c:import url="newOSLinks.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				newOSLinks_init();
			});
		</script>
<!-- Fin Links Para Crear Ordenes De Servicio -->

	</c:if>
<!-- Fin Contenido De Perfil Syscoordinador-->

<!-- Inicia Contenido De Perfiles Syscallcenter Y Syscoordinador-->
	<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['Call Center'] || user.belongsToGroup['Coordinador']}" />
	<c:if test="${sysCallCenter == true}">

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

<!-- Inicia Contenido De Perfil Sysservicio -->

	<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
	<c:if test="${sysServicio == true}">

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

<!-- Mecanismo de envio de OS offline -->
		<c:import url="offlineSoSend.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				offlineSoSend_init();

				sendOfflineSO();
			});
		</script>
<!-- Fin Mecanismo de envio de OS offline -->
	</c:if>

<!-- Fin Contenido De Perfil Sysservicio -->

<!-- Contenido para empleados de comercial -->
	<c:set var="sysSalesManger" scope="request" value="${user.belongsToGroup['Gerente comercial']}" />
	<c:set var="sysCST" scope="request" value="${user.belongsToGroup['CST']}" />
	<c:if test="${sysSalesManger || sysCST}">
		<c:import url="/codex/dashboard.jsp"></c:import>
	</c:if>
<!-- FIN Contenido para empleados de comercial -->

<!-- Contenido para todo grupo sac Excepto cientes -->
	<c:set var="sacNoCustomer" scope="request" value="${user.belongsToGroup['Cliente'] == null || user.belongsToGroup['Cliente'] == false}" />
	<c:if test="${sacNoCustomer == true}">
<!-- Tabla De Ordenes De Servicio Con Pendientes -->
		<c:import url="issueControl.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				issueControl_init();
			});
		</script>
<!-- Fin Tabla De Ordenes De Servicio Con Pendientes -->

	<!-- Requisiciones por cerrar - Disponible solo apra usuarios responsables de Req -->
	<c:set var="reqViewer" scope="session" value="${user.belongsToGroup['Lider de Ingenieria'] || user.belongsToGroup['Ingeniero de Soporte'] || user.belongsToGroup['Gerente de Implementación y Servicio'] || user.belongsToGroup['Ingeniero de Redes y Monitoreo'] || user.belongsToGroup['Jefe de Compras'] || user.belongsToGroup['Compras'] || user.belongsToGroup['Jefe de Capital Humano'] || user.belongsToGroup['Gerente de Calidad'] || user.belongsToGroup['Encargado de las Redes'] || user.belongsToGroup['Calidad']}"/> 
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

<!-- Contenido para todo grupo sac Excepto cientes -->
	</c:if>

<!-- Contenido para clientes -->

	<c:set var="sysCustomer" scope="request" value="${user.belongsToGroup['Cliente']}" />
	<c:if test="${sysCustomer == true}">
<!-- Tabla de tickets abiertos para usuarios de acceso limitado (clientes) -->
		<c:import url="openLimitedTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				openLimitedTickets_init();
			});
		</script>
<!-- Fin Tabla de tickets abiertos para usuarios de acceso limitado (clientes) -->

		<c:import url="pendingLimitedServiceOrders.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingLimitedServiceOrders_init();
			});
		</script>
	</c:if>
<!-- Fin Contenido para clientes -->

</div>
</body>
