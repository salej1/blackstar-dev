<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<script type="text/javascript">
	
	function populateEquipmentCollection(clientName){
		$.getJSON("/equipmentService?clientName=" + clientName, function( data ) {
			var buffer = "";
			  
			for(var eq = 0; eq < data.length; eq++){
				buffer = buffer + "<option value='" + data[eq].policyId + "'>" + data[eq].serialNumber + "</option>" ;
			}
			  
			$("#optEquipmentCollection").html(buffer);
		});
	}
	
	function postScheduledService(){
		var policyId;
		
		policyId = $("#optEquipmentCollection option:selected").val();
		$("#policyId").val(policyId);
		$("#sendSchedule").submit();
	}
	
	$(function(){
		 $("#createServiceDlg").dialog({
				autoOpen: false,
				height: 500,
				width: 580,
				modal: true,
				buttons: {
					"Aceptar": function() {
						
						postScheduledService();
						
						$( this ).dialog( "close" );
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
		});	

		$("#serviceDate").datepicker();		
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

				</script>
				<form action="scheduleStatus" id="sendSchedule" method="POST">
					<table>
						<tbody>
							<tr>
								<td style="width:200px;">Fecha:</td>
								<td><input name="effectiveDate" id="serviceDate" type="text" style="width:300px;"/></td>
							</tr>

							<tr>
								<td>Cliente: </td>
								<td>
									<select id = "optCustomerCollection" style="width:300px;" 
									onchange='javascript:populateEquipmentCollection($("#optCustomerCollection").val());'>
										<option selected></option>
										<c:forEach var="equipment" items="${customers}">
											<option>${equipment}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td>Equipo: </td>
								<td>
									<select name = "optEquipmentCollection" id = "optEquipmentCollection" style="width:300px;">

									</select>
								</td>
								<input type="hidden" name="policyId" id="policyId"/>
							</tr>
							<tr>
								<td>Ing. responsable: </td>
								<td>
								 <select name="serviceEng0" id="serviceEng0" style="width:300px;" >
									<option selected></option>
									<c:forEach var="engineer" items="${serviceEngineers}">
										<option value="${engineer.key}">${engineer.value}</option>
									</c:forEach>
								 </select>
								</td>
							</tr>
							<tr>
								<td>Ing. adicional 1: </td>
								<td>
								 <select name="serviceEng1" id="serviceEng1" style="width:300px;" >
									<option selected></option>
									<c:forEach var="engineer" items="${serviceEngineers}">
										<option value="${engineer.key}">${engineer.value}</option>
									</c:forEach>
								 </select>
								</td>
							</tr>
							<tr>
								<td>Ing. adicional 2: </td>
								<td>
								 <select name="serviceEng2" id="serviceEng2" style="width:300px;" >
									<option selected></option>
									<c:forEach var="engineer" items="${serviceEngineers}">
										<option value="${engineer.key}">${engineer.value}</option>
									</c:forEach>
								 </select>
								</td>
							</tr>
							<tr>
								<td>Ing. adicional 3: </td>
								<td>
								 <select name="serviceEng3" id="serviceEng3" style="width:300px;" >
									<option selected></option>
									<c:forEach var="engineer" items="${serviceEngineers}">
										<option value="${engineer.key}">${engineer.value}</option>
									</c:forEach>
								 </select>
								</td>
							</tr>
							<tr>
								<td>Ing. adicional 4: </td>
								<td>
								 <select name="serviceEng4" id="serviceEng4" style="width:300px;" >
									<option selected></option>
									<c:forEach var="engineer" items="${serviceEngineers}">
										<option value="${engineer.key}">${engineer.value}</option>
									</c:forEach>
								 </select>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>					
		</div>
	</div>
</body>
</html>