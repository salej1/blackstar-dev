<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<script type="text/javascript">

	function postScheduledService(){
		
	}
	
	$(function(){
		 $("#createServiceDlg").dialog({
				autoOpen: false,
				height: 200,
				width: 260,
				modal: true,
				buttons: {
					"Aceptar": function() {
						var employee = $("#employeeSelect option:selected").val();

						postScheduledService(assignedTicket, employee);
						
						$( this ).dialog( "close" );
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
		});		
	});
</script>
<body>
	<!--   CONTENT   -->
	<div id="content" class="container_16 clearfix">

		<!--   CONTENT COLUMN   -->
		<div class="grid_16">
			<div>
				<div>
					<img src="img/navigate-right.png" />
					<a href="#" onclick='$("#createServiceDlg").dialog("open");'>Agendar servicio preventivo</a>
				</div>
			</div>
			<p>
				<small>&nbsp;</small>
			</p>
		</div>
		<div class="grid_16">
			<div class="box">
				<h2>Programa semanal de servicios preventivos</h2>
				<div class="utils"></div>
				<caption>&nbsp;</caption>
				<table>
					<thead>
						<tr>
							<th colspan="4">${ today }</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach var="service" items="${servicesToday}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
						
					<thead>
						<tr>
							<th colspan="4">${ today1 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday1}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today2 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday2}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today3 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday3}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today4 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday4}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today5 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday5}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today6 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday6}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<p>
			<small>&nbsp;</small>
		</p>
		<div class="grid_16">
			<div class="box">
				<h2>Servicios programados a futuro</h2>
				<div class="utils"></div>
				<table id="futureServices">
					<thead>
						<tr>
							<th>Fecha</th>
							<th>Cliente</th>
							<th>Equipo</th>
							<th>Proyecto</th>
							<th>Oficina</th>
							<th>Marca</th>
							<th>No. Serie</th>
							<th>Editar</th>
						</tr>
					</thead>
			
				</table>
			</div>
		</div>
		<!--   ~ CONTENT COLUMN   -->
		<!--   ~ CONTENT   -->
	</div>
	
	<div id = "createServiceDlg">
		<div class="grid_8">					
			<div class="box">
				<h2>Agendar servicio</h2>
				<script type="text/javascript">
						var engineers = [
							<c:forEach var="engineer" items="${serviceEngineers}">
								<option value = "engineer.key">${engineer.value}</option>
							</c:forEach>
				</script>
				<table>
					<tbody>
						<tr>
							<td style="width:100px;">Fecha:</td>
							<td><input id="datepicker" type="text" style="width:300px;"/></td>
						</tr>

						<tr>
							<td>Cliente: </td>
							<td>
								<select id = "optCustomerCollection" style="width:300px;" 
								onchange="javascript:populateEquipmentCollection($('optCustomer option:selected').text(), $('#optCustomerCollection')">
									<option selected></option>
									<c:forEach var="equipment" items="${clientCollection}">
										<option>${equipment.clientName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td>Equipo: </td>
							<td>
								<select id = "optEquipmentCollection"style="width:300px;">

								</select>
							</td>
						</tr>
						<tr>
							<td>Ing. de servicio: </td>
							<td>
							<input type="text"/>

							</td>
						</tr>
						<tr>
							<td style="width:100px;">Ingenieros adicionales:</td>
							<td><textarea name="" id="" cols="30" rows="10" style="width:300px;"></textarea></td>
						</tr>
					</tbody>
				</table>
				<p><small>&nbsp;</small></p>
				<button class="searchButton" onclick="window.location='programaServicio_coo.html'">Agregar</button>
				<button class="searchButton" onclick="window.location='programaServicio_coo.html'">Cancelar</button>
			</div>					
		</div>
	</div>
</body>
</html>