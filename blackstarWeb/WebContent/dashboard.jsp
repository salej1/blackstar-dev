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

<script>
function getNewInternalTickets(){
    var url = '/bloom/newInternalTicket.do';
    var data = new Array();
    redirect(url, data, "GET");
	
}

</script>
</head>
<body>
<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->		
    <c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />

	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getNewInternalTickets(); return false;">Crear Ticket Interno</a>
	</div>
	
	
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
		
		
		<!-- Tabla De Tickets internos pendientes - pendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomPendingInternalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingInternalTicketsInit();
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
		
		
		<!-- Tabla De Tickets internos pendientes - pendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomInternalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				internalTicketsInit();
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
	
			<!-- Tabla De Tickets internos pendientes - pendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomPendingInternalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingInternalTicketsInit();
			});
		</script>
	
	
	</c:if>
	<!-- Fin Contenido De Perfil Sysservicio -->
	
	<!-- Inicia Contenido De Perfil sysHelpDesk -->
	<c:set var="sysHelpDesk" scope="request" value="${user.belongsToGroup['Mesa de Ayuda']}" />
	
	
	
	
	<c:if test="${sysHelpDesk == true}">
	<!-- Fin Contenido De Perfil sysHelpDesk -->
	
	<!-- Links Para ver los reportes de Mesa de Ayuda -->
		<c:import url="bloom/bloomITLinks.jsp"></c:import>
		 <p><small>&nbsp;</small></p>
		<script type="text/javascript">
			$(function(){
				bloomITLinks_init();
			});
		</script>
	
	
	
		<!-- Tabla De Tickets internos pendientes - bloomPendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomPendingInternalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				pendingInternalTicketsInit();
			});
		</script>
		


		<!-- Tabla De Tickets internos pendientes - bloomPendingInternalTickets.jsp -->
		<c:import url="/bloom/bloomHistoricalTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				historicalInternalTicketsInit();
			});
		</script>
		
	
	</c:if>



</div>
</body>
</html>