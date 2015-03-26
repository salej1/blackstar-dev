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

<title>Plataforma de Ventas</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">

			<div class="grid_16">
				<p>
					<img src="../img/navigate-right.png" /><a href="">Nuevo Prospecto</a>
				</p>
			</div>
			
			<div class="grid_16">
				<p>
					<img src="../img/navigate-right.png" /><a href="">Nuevo Cédula de Proyectos</a>
				</p>
			</div>

			<div class="grid_16">
				<div class="box">
					<h2>C. de Proyecto Nuevas</h2>
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="NewSalesTable">
						<thead>
							<tr>
								<th>Proyecto</th>
								<th>Cliente</th>
								<th>Última Actividad</th>
								<th>Ubicación</th>
								<th>Estatus</th>
								<th>Acción</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="newsales" items="${NewSaleslist}">
								<tr>
									<td>${newsales.warrantProjectId}</td>
									<td>${newsales.tradeName}</td>									
									<td>${newsales.updateDate}</td>
									<td>${newsales.ubicationProject}</td>
									<td>${newsales.projectstatus}</td>
									<td>Enviar Autorizacion</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			<div class="grid_16">
				<div class="box">
					<h2>C. de Proyecto Autorizadas</h2>
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="AuthorizedSalesTable">
						<thead>
							<tr>
								<th>Proyecto</th>
								<th>Cliente</th>
								<th>Última Actividad</th>
								<th>Ubicación</th>
								<th>Estatus</th>
								<th>Acción</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="authorized" items="${autSaleslist}">
								<tr>
									<td>${authorized.warrantProjectId}</td>
									<td>${authorized.tradeName}</td>									
									<td>${authorized.updateDate}</td>
									<td>${authorized.ubicationProject}</td>
									<td>${authorized.projectstatus}</td>
									<td>Crear Cotizacion</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			
			<div class="grid_16">
				<div class="box">
					<h2>C. de Proyecto en Cotizacion</h2>
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="PendingSalesTable">
						<thead>
							<tr>
								<th>Proyecto</th>
								<th>Cliente</th>
								<th>Última Actividad</th>
								<th>Ubicación</th>
								<th>Estatus</th>
								<th>Acción</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="pending" items="${pendingSaleslist}">
								<tr>
									<td>${pending.warrantProjectId}</td>
									<td>${pending.tradeName}</td>									
									<td>${pending.updateDate}</td>
									<td>${pending.ubicationProject}</td>
									<td>${pending.projectstatus}</td>
									<td>Crear Pedido</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			
		</div>
	</body>
</html>
