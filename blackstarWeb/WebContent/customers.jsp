<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="customers" />
<c:import url="header.jsp" />
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="css/jquery.ui.theme.css" />
	<link rel="stylesheet" href="css/jquery-ui.min.css" />
	<script src="js/jquery-1.10.1.min.js"></script>
	<script src="js/jquery-ui.js"></script>
	<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
	<title>Clientes</title>
	</head>
	<body>
		<div id="content" class="container_16 clearfix">
			<div class="grid_16">
				<div class="box">
					<h2>Ultimos tickets</h2>
				<div class="utils"></div>
				<table cellpadding="0" cellspacing="0" border="0" class="display"
					id="tickets">
					<thead>
						<tr>
							<th>Ticket</th>
							<th style="width: 140px;">Fecha/Hora</th>
							<th style="width: 120px;">Cliente</th>
							<th>Equipo</th>
							<th>Tiem. R</th>
							<th>Proyecto</th>
							<th>Estatus</th>
							<th>Responsable</th>
							<th>Asignar</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- Assign Ticket section -->
	<div id="tktAssignDlg" title="Asignar Ticket">
		<p>
			Asignar ticket<label id="lblTicketBeignAssigned"></label>
		</p>
		<select id="employeeSelect">
			<c:forEach var="employee" items="${employees}">
				<option value="${ employee.userEmail }">${employee.userName}</option>
			</c:forEach>
		</select>
		<form id="ticksetSelect" action="tickets" method="post">
			<input id="ticketId" name="ticketId" type="hidden" /> <input
				id="employee" name="employee" type="hidden" />
		</form>
	</div>
</body>
</html>
