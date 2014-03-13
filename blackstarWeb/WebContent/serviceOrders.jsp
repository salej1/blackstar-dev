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
					<img src="/img/navigate-right.png"/><a href="/scheduleStatus">Programa de servicios preventivos</a>
				</div>
			</div>
			<p><small>&nbsp;</small></p>
<!-- Inicia seccion Coordinadoras -->
			<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Coordinador']}" />
			<c:if test="${sysServicio == true}">
				<c:import url="newOpenOSLinks.jsp"></c:import>
			</c:if>
<!-- Fin seccion Coordinadoras -->

<!-- Seccion perfil Servicio -->
			<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio'] }" />
			<c:if test="${sysServicio == true}">
	
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
				
				<!-- La inicializacion debe ser despues de que se pintaron las tablas -->
				<script type="text/javascript">
					$(function(){
						officeFilter_init();
					});
				</script>
			</c:if>
<!-- Fin Contenido De Perfiles SysCallCenter Y SysCoordinador-->

<!-- Inicia Contenido De Perfil SysServicio -->

			<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
			<c:if test="${sysServicio == true}">

<!-- Inicia Historial De Ordenes De Servicio -->
				<c:import url="serviceOrdersHistory.jsp"></c:import>
				<script type="text/javascript">
					$(function(){
						serviceOrdersHistory_init();
					});
				</script>
			</c:if>
<!-- Fin Historial De Ordenes De Servicio -->

		</div>
	</body>
</html>