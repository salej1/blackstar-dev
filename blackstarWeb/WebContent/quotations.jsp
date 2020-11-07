<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="warrantProjects" />
<c:import url="headerSales.jsp" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/jquery.ui.theme.css" />
<link rel="stylesheet" href="/css/jquery-ui.min.css" />
<script src="/js/jquery-1.10.1.min.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<title>Cotizaciones</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">

			<div class="grid_16">
				<p>
					<img src="../img/navigate-right.png" /><a href="add.do">Nuevo Prospecto</a>
				</p>
				<p>
					<img src="../img/navigate-right.png" /><a href="add.do">Nueva Cedula de Proyectos</a>
				</p>
			</div>

			<div class="grid_16">
				<div class="box">
					<h2>Cedula de Proyecto en Cotizacion</h2>
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="leafletTable">
						<thead>
							<tr>
								<th>Proyecto</th>
								<th>Cliente</th>
								<th>Ultima actividad</th>
								<th>Monto</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="warrantProject" items="${warrantProjectList}">
								<tr>
								<td>${warrantProject.warrantProjectId}</td>
								<td>${warrantProject.customer}</td>
								<td>${warrantProject.updateDate}</td>
								<td>${warrantProject.totalProject}</td>
								</tr>
								</c:forEach>
								<tr>
								<td><a href="add.do">Soporte</a></td>
								</tr>
						</tbody>
					</table>
				</div>
			</div>
			</div>
</body>
</html>
