<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
		<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>

		<title>Ordenes de servicio</title>
	</head>
	<body>

<!--   CONTENT COLUMN   -->		
		<div id="content" class="container_16 clearfix">
			<div>
				<div>
					<img src="/img/navigate-right.png"/><a href="/scheduleStatus/show.do">Programa de servicios</a>
				</div>
			</div>
			<p><small>&nbsp;</small></p>
<!-- Inicia Contenido De Perfil Coordinadoras e Ingenieros de Servicio-->
			<c:set var="captOsLinks" scope="request" value="${user.belongsToGroup['Coordinador'] || user.belongsToGroup['Implementacion y Servicio'] || user.belongsToGroup['Call Center']}" />
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
<!-- Fin Seccion perfil Servicio -->

<!-- Inicia Contenido De Perfiles SysCallCenter Y SysCoordinador-->
			<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['Call Center'] || user.belongsToGroup['Coordinador']}" />
			<c:if test="${sysCallCenter == true}">
				<!-- Seleccion de filtro por oficina -->
				<c:import url="officeFilter.jsp"></c:import>

				<!-- Tabla De Ordenes De Servicio Por Revisar - NewServiceOrders.jsp -->
				<c:import url="newServiceOrders.jsp"></c:import>
				<script type="text/javascript">
					$(function(){
						newServiceOrders_init();
					});
				</script>

				<!-- Tabla De Ordenes De Servicio Con Pendientes - PendingServiceOrders.jsp -->
				<c:import url="pendingServiceOrders.jsp"></c:import>
				<script type="text/javascript">
					$(function(){
						pendingServiceOrders_init();
					});
				</script>
				
			</c:if>
<!-- Fin Contenido De Perfiles SysCallCenter Y SysCoordinador-->

<!-- Inicia Contenido De Todo GPO Sac -->

			<c:set var="showHistory" scope="request" value="${!user.belongsToGroup['Cliente']}" />
			<c:if test="${showHistory == true}">

<!-- Inicia Historial De Ordenes De Servicio -->
				<c:import url="serviceOrdersHistory.jsp"></c:import>
				<script type="text/javascript">
					$(function(){
						serviceOrdersHistory_init();
					});
				</script>
			</c:if>
<!-- Fin Historial De Ordenes De Servicio -->

<!-- Historial de ordenes de servicio para Clientes -->
			<c:set var="sysCliente" scope="request" value="${user.belongsToGroup['Cliente']}" />
			<c:if test="${sysCliente == true}">
			<c:import url="limitedServiceOrdersHistory.jsp"></c:import>
				<script type="text/javascript">
					$(function(){
						limitedServiceOrdersHistory_init();
					});
				</script>
			</c:if>
<!-- Fin Historial de ordenes de servicio para Clientes -->

<!-- Se inicializa el filtro por oficina -->
			<c:if test="${sysCallCenter == true}">
				<!-- La inicializacion debe ser despues de que se pintaron las tablas -->
				<script type="text/javascript">
					$(function(){
						officeFilter_init();
					});
				</script>
			</c:if>
<!-- Fin inicializacion de filtro por oficina -->
		</div>
	</body>
</html>