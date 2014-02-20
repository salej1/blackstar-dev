<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="customers" />
<c:import url="headerSales.jsp" />
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="/css/jquery.ui.theme.css" />
	<link rel="stylesheet" href="/css/jquery-ui.min.css" />
	<script src="/js/jquery-1.10.1.min.js"></script>
	<script src="/js/jquery-ui.js"></script>
	<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
	<title>Clientes</title>
	</head>
	<body>
		<div id="content" class="container_16 clearfix">

			<div class="grid_16">
				<p>
					<img src="../img/navigate-right.png" /><a href="add.do">Nuevo Prospecto</a>
				</p>
			</div>

			<div class="grid_16">
				<div class="box">
					<h2>Prospectos</h2>
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="leafletTable">
						<thead>
							<tr>
								<th>Número</th>
								<th>Tipo</th>
								<th>Cliente</th>
								<th>Ciudad</th>
								<th>Contacto</th>
								<th>Crear CP</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="leaflet" items="${leafletList}">
								<tr>
									<td>${leaflet.customerId}</td>
									<td>P</td>
									<td>${leaflet.companyName}</td>
									<td>${leaflet.city}</td>
									<td><a href="mailto: ${leaflet.contactEmail}">${leaflet.contactPerson}</a></td>
									<td><a href="projectNew.html">Crear cédula</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			<div class="grid_16">
				<div class="box">
					<h2>Clientes</h2>
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="customerTable">
						<thead>
							<tr>
								<th>Número</th>
								<th>Tipo</th>
								<th>Cliente</th>
								<th>Ciudad</th>
								<th>Contacto</th>
								<th>Crear CP</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="customer" items="${customerList}">
								<tr>
									<td>${customer.customerId}</td>
									<td>C</td>
									<td>${customer.companyName}</td>
									<td>${customer.city}</td>
									<td><a href="mailto: ${customer.contactEmail}">${customer.contactPerson}</a></td>
									<td><a href="projectNew.html">Crear cédula</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</body>
</html>
