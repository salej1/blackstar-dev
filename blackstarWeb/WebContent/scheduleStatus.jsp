<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript">
	
	function filterEquipmentByProject(project){
		var equipments = $("#equipments").dataTable();
		equipments.fnFilter(project, 3);
	}
	
	function validateData(){
		var valid = true;
		// Data Validation
		var defEmp = $("input[name=isDefaultEmployee]:radio:checked").val();
		if(defEmp == null){
			$("#employeesInfo").show();
			valid = false;
		}
		else{
			$("#employeesInfo").hide();
		}
		
		var policy = $("input[name=policy]:checkbox:checked").val();
		if(policy == null){
			$("#equipmentInfo").show();
			valid = false;
		}
		else{
			$("#equipmentInfo").hide();
		}
		
		var startDate = $("#serviceDateStart").val();	
		if(startDate == null || startDate == ''){
			$("#dateInfo").show();
			valid = false;
		}
		else{
			$("#dateInfo").hide();
		}
		return valid;
	}	
	
	function employeeCheckedChange(rowId){
		var defEmp = $("input[name=isDefaultEmployee]:radio:checked").val();

		if(defEmp == null){
			$("input[value='"+ rowId +"']:radio").attr('checked', 'checked');
		}
	}
	
	$(function(){
		$("#serviceDateStart").datepicker();
		
		 $("#createServiceDlg").dialog({
				autoOpen: false,
				height: 580,
				width: 700,
				modal: true,
				buttons: {
					"Aceptar": function() {
						var valid = validateData();
						
						if(valid){
							$("#sendSchedule").submit();
							$( this ).dialog( "close" );
						}						
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
		});	

		$("#serviceDate").datepicker();	
		
		// tabla de empleados
		var strEpmloyees = '${employees}';
		var empData = $.parseJSON(strEpmloyees);
		
		$('#employees').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"aaData": empData,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "DT_RowId" },
						  { "mData": "employee" },
						  { "mData": "DT_RowId" }
					  ],
			"aoColumnDefs" : [
						{"mRender" : function(data, type, row){return "<input type='checkbox' name='employee' value='" + row.DT_RowId + "' onchange='employeeCheckedChange($(this).val());'/>";}, "aTargets" : [0]},
						{"mRender" : function(data, type, row){return "<input class='defaultemployee' type='radio' name='isDefaultEmployee' value='" + row.DT_RowId + "'>";}, "aTargets" : [2]}	    		    	       
					]}
		);	
		
		// tabla de equipos
		var strEquimpents = '${equipments}';
		var eqData = $.parseJSON(strEquimpents);

		$('#equipments').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"aaData": eqData,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "DT_RowId" },
						  { "mData": "equipmentType" },
						  { "mData": "serialNumber" },
						  { "mData": "project" }
					  ],
			"aoColumnDefs" : [
						{"mRender" : function(data, type, row){return "<input type='checkbox' name='policy' value='"+ row.DT_RowId +"'/>";}, "aTargets" : [0]}
					]}
		);	
		
		// tabla de servicios futuros
		var strServices = '${futureServices}';
		var servData = $.parseJSON(strServices);

		$('#futureServices').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"aaData": servData,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "scheduledDate" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "project" },
						  { "mData": "officeName" },
						  { "mData": "brand" },
						  { "mData": "serialNumber" }
					  ]}
		);	
		$(".info").hide();
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
					<c:forEach var="service" items="${servicesToday0}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.asignee }</td>
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
						</tr>
					</thead>
			
				</table>
			</div>
		</div>
		<!--   ~ CONTENT COLUMN   -->
		<!--   ~ CONTENT   -->
	</div>
	
	<div id = "createServiceDlg" title="Agendar Servicio">
		<div class="grid_12">					
			<form action="scheduleStatus" id="sendSchedule" method="POST">
				<div class="box">
					<h2>Datos del servicio</h2>
					<div id="dateInfo" class="info">
						Por favor seleccione una fecha
					</div>
					<p></p>
					<div style="width:630px;">
						<span>
							Proyecto: 
							<select name="" id="optProjects" onchange="filterEquipmentByProject($(this).val());">
								<option value=""></option>
								<c:forEach var="project" items="${projects}">
									<option value = "${project}">${project}</option>
								</c:forEach>	
							</select>
						</span>
						<!--
						<span>
							Ciudad
							<select name="" id="optCities">
									
							</select>
						</span>
						-->
						<span>
							Fecha: <input id="serviceDateStart" name="serviceDateStart" type="text" readonly="readonly" required />
						</span>
						<span>
							Dias: <input id="serviceDays" name="serviceDays" type="text" style="width:20px;" value="1" required />
						</span>
					</div>
					<p> </p>
					<h2>Ingenieros de servicio</h2>
					<div id="employeesInfo" class="info">
						Por favor seleccione al menos un ingeniero de servicio
					</div>
					<div class="employeeBox">
						<table id="employees">
							<thead>
								<tr>
									<th>Agregar</th>
									<th>Empleado</th>
									<th>Responsable</th>
								</tr>
							</thead>
						</table>
					</div>
					<p> </p>
					<h2>Equipos</h2>
					<div id="equipmentInfo" class="info">
						Por favor seleccione al menos un equipo
					</div>
					<div class="equipmentBox">
						<table id="equipments">
							<thead>
								<tr>
									<th>Agregar</th>
									<th>Equipo</th>
									<th>Num. Serie</th>
									<th>Proyecto</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>	
			</form>
		</div>
	</div>
</body>
</html>