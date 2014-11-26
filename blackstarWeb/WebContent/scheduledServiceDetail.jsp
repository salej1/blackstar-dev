<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>

<script type="text/javascript">
	
	function filterEquipmentByProject(project){
		var equipments = $("#equipments").dataTable();
		equipments.fnFilter(project, 3);
	}
	
	function validateData(){
		var valid = true;
		// Data Validation
		var defEmp = $("input[name='employeeList']:checkbox:checked").val();
		if(defEmp == null){
			$("#employeesInfo").show();
			valid = false;
		}
		else{
			$("#employeesInfo").hide();
		}
		
		var policy = $("input[name='policyList']:checkbox:checked").val();
		if(policy == null){
			$("#equipmentInfo").show();
			valid = false;
		}
		else{
			$("#equipmentInfo").hide();
		}
		
		var startDate = $("#serviceStartDate").val();	
		if(startDate == null || startDate == ''){
			$("#dateInfo").show();
			valid = false;
		}
		else{
			$("#dateInfo").hide();
		}
		return valid;
	}	
	
	$(function(){
		$("#optOffices").bind('change', function(){
			$("#officeId").val($(this).val().substring(0,1));
		});

		if("${scheduledService.scheduledServiceId}" > 0){
			var officeId = "${scheduledService.officeId}";
			var officeName = "";

			switch(officeId){
				case "Q": officeName = "QRO"; break;
				case "M": officeName = "MXO"; break;
				case "G": officeName = "GDL"; break;
			}
			$("#optOffices option[value='" + officeName + "']").attr("selected", "true");
		}
		else{
			$("#optOffices option[value='" + $.cookie('blackstar_office_pref') + "']").attr("selected", "true");
			$("#officeId").val($.cookie('blackstar_office_pref'));
		}

		var noPolicy = "${scheduledService.noPolicy}";
		if(noPolicy == "true"){
			$("#equipmentSelect").hide();			
		}
		else{
			$("#equipmentCapture").hide();			
		}
		$("input[id^='noPolicy']").bind('click', function(item){
			if(this.checked){
				$("#equipmentSelect").hide();
				$("#equipmentCapture").show();
			}
			else{
				$("#equipmentSelect").show();
				$("#equipmentCapture").hide();
			}
		});

		$("#optProjects").bind('change', function(){
			$("#project").val($(this).val());
		});

		$("#optProjects option[value='${scheduledService.project}']").attr("selected", "true");

		$("#serviceStartDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});

		// tabla de empleados
		var strEpmloyees = '${employees}';
		var empData = $.parseJSON(strEpmloyees);
		 // seleccion de empleados asociados
	    var rawEmps = "${scheduledService.employeeList}";
	    var emps = rawEmps.replace("[", "").replace("]", "").split(","); 

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
						  { "mData": "employee" }
					  ],
			"aoColumnDefs" : [
						{"mRender" : function(data, type, row){
							var template = "<input type='checkbox' name='employeeList' value='" + row.DT_RowId + "' checked/>"
							
							for(var emp in emps){
								if(emps[emp].trim() == row.DT_RowId){
									return template;
								}
							}

							return template.replace("checked", "");
						}, "aTargets" : [0]}       
					]}
		);	

		// tabla de equipos
		var strEquimpents = '${equipments}';
		var eqData = $.parseJSON(strEquimpents);

		var rawEqs = "${scheduledService.policyList}";
	    var eqs = rawEqs.replace("[", "").replace("]", "").split(","); 

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
						{"mRender" : function(data, type, row){
							var template = "<input type='checkbox' name='policyList' value='"+ row.DT_RowId +"' checked/>";

							for(var eq in eqs){
								if(eqs[eq].trim() == row.DT_RowId){
									return template;
								}
							}

							return template.replace("checked", "");
						}, "aTargets" : [0]}
					]}
		);	
		
		$(".info").hide();

		$('#employees, #equipments').delegate('input:checkbox', 'click', function(item){
	        if(this.checked){
	            $(this).closest("tr").addClass("no-filter");
	        }
	        else{
	            $(this).closest("tr").removeClass("no-filter");
	        }
	    });

		
		// Soporte para deshabilitar filtro en elementos seleccionados
	    $('#employees').bind('filter', function() {
	    	$("input:checked[name='employeeList']").each(function(){
				$(this).closest("tr").addClass("no-filter");
			});

	        var nTable    = $(this).dataTable();
	        var oSettings = nTable.fnSettings();
	    
	        // Separar los elementos no-filter
	        var aiSelectedRowIDs = $.grep(oSettings.aiDisplayMaster, function(iRowID) {
	            var oRow = nTable.fnGetNodes(iRowID);
	            return $(oRow).hasClass("no-filter");
	        });

	        var oSelectedRecordIDs = {};
	        $.each(aiSelectedRowIDs, function(idx, iRowID) {
	            oSelectedRecordIDs[iRowID] = true;
	        });
	    
	        // eliminacion de los no-filter del display
	        for (var i = oSettings.aiDisplay.length; i >= 0; i--) {
	            if (oSelectedRecordIDs[ oSettings.aiDisplay[i] ]) {
	                oSettings.aiDisplay.splice(i, 1);
	            }
	        }
	    
	        // insercion manual de las filas no-filter
	        Array.prototype.unshift.apply(oSettings.aiDisplay, aiSelectedRowIDs);
	    });

		$('#equipments').bind('filter', function() {
	        var nTable    = $(this).dataTable();
	        var oSettings = nTable.fnSettings();
	    
	        // Separar los elementos no-filter
	        var aiSelectedRowIDs = $.grep(oSettings.aiDisplayMaster, function(iRowID) {
	            var oRow = nTable.fnGetNodes(iRowID);
	            return $(oRow).hasClass("no-filter");
	        });

	        var oSelectedRecordIDs = {};
	        $.each(aiSelectedRowIDs, function(idx, iRowID) {
	            oSelectedRecordIDs[iRowID] = true;
	        });
	    
	        // eliminacion de los no-filter del display
	        for (var i = oSettings.aiDisplay.length; i >= 0; i--) {
	            if (oSelectedRecordIDs[ oSettings.aiDisplay[i] ]) {
	                oSettings.aiDisplay.splice(i, 1);
	            }
	        }
	    
	        // insercion manual de las filas no-filter
	        Array.prototype.unshift.apply(oSettings.aiDisplay, aiSelectedRowIDs);
	    });

		// filtro inicial 
		$("#equipments").dataTable().fnFilter("${scheduledService.project}"); 

		// tipos de equipo
		$("#equipmentTypeList").bind('change', function(){
			$("#equipmentTypeId").val($(this).val());
		});
		$("#equipmentTypeId").val($("#equipmentTypeList option:selected").val());
	});
	
	function processForm(form){
		var valid = validateData();
		if(!valid){
			return false;
		}
		else{
			$("#" + form).submit();
		}
	}
</script>
</head>
<body>
	<div id="content" class="container_16 clearfix">
		<div class="grid_16">					
			<form:form  commandName="scheduledService" action="/scheduleStatus/save.do" method="POST">
				<form:hidden path="createdByUsr" value="${user.userEmail}"/>
				<div class="box">
					<h2>Datos del servicio</h2>
					<div id="dateInfo" class="info">
						Por favor seleccione una fecha
					</div>
					<p></p>
					<div style="width:630px;">
						<span>
							Oficina:
							<form:input type="hidden" path="officeId" id="officeId"/>
							<select id="optOffices">
								<option value="">Todas</option>
								<c:forEach var="office" items="${offices}">
									<option value = "${office}">${office}</option>
								</c:forEach>					
							</select>
						</span>
						
						<span style="margin-left:10px">
							Proyecto: 
							<form:input type="hidden" id="scheduledServiceId" path="scheduledServiceId"/>
							<select id="optProjects" onchange="filterEquipmentByProject($(this).val());">
								<option value=""></option>
								<c:forEach var="project" items="${projects}">
									<option value = "${project}">${project}</option>
								</c:forEach>	
							</select>
						</span>
						<span style="margin-left:10px">
							Fecha y hora: <form:input id="serviceStartDate" path="serviceStartDate" type="text" readonly="readonly" required="true" />
						</span>
						<span style="margin-left:10px">
							Dias: <form:input id="numDays" path="numDays" type="text" style="width:20px;" required="true" />
						</span>
						<div>
							<div style="margin-top:20px;">Descripcion:</div>
							<form:textarea path="description" id="description" style="width:70%;" rows="8"/>
						</div>
						<div style="width:120px;">
							Persona de contacto:
							<form:input path="serviceContact" style="width:443px;"/>
						</div>
						<div style="width:120px;">
							Email de contacto:
							<form:input path="serviceContactEmail" style="width:443px;"/>
						</div>
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
									<th style="width:80px;">Agregar</th>
									<th>Empleado</th>
								</tr>
							</thead>
						</table>
					</div>
					<p> </p>

					Agendar equipo sin poliza
					<form:checkbox path="noPolicy"/>

					<!-- Seleccion de equipos en poliza -->
					<div id = "equipmentSelect">
						<h2>Equipos</h2>
						<div id="equipmentInfo" class="info">
							Por favor seleccione al menos un equipo
						</div>
						<div class="equipmentBox">
							<table id="equipments">
								<thead>
									<tr>
										<th style="width:80px;">Agregar</th>
										<th style="width:150px;">Equipo</th>
										<th>Num. Serie</th>
										<th>Proyecto</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					
					<!-- Captura de equipo sin poliza -->
					<div id="equipmentCapture">
						<h2>Equipo sin poliza</h2>
						<div id="openCustomerInfo" class="info">
							Por favor seleccione al menos un equipo
						</div>
						<div class="openCustomerBox">
							<table id="openCustomer">
								<tr>
									<td>Cliente</td>
									<td colspan="2"><form:input type="text" path="customer" style="width:95%"/></td>
								</tr>
								<tr>
									<td>Direccion</td>
									<td colspan="2"><form:input type="text" path="address" style="width:95%"/></td>
								</tr>
								<tr>
									<td>Contacto</td>
									<td style="width:300px"><form:input type="text" path="contact" style="width:95%"/></td>
									<td>Telefono</td>
									<td><form:input type="text" path="contactPhone" style="width:95%"/></td>
								</tr>
								<tr>
									<td>Equipo</td>
									<td>
										<form:hidden path="equipmentTypeId" />
										<select id="equipmentTypeList">
											<c:forEach var="etype" items="${equipmentTypeList}">
										        <option value="${etype.equipmentTypeId}" 
										        <c:if test="${etype.equipmentTypeId == scheduledService.equipmentTypeId}">
										        	selected="true"
										    	</c:if>
										        >${etype.equipmentType}</option>
										    </c:forEach>
										</select>
									</td>
									<td>Email</td>
									<td><form:input type="text" path="contactEmail" style="width:95%"/></td>
								</tr>
								<tr>
									<td>Marca</td>
									<td><form:input type="text" path="brand" style="width:95%"/></td>
									<td>Modelo</td>
									<td><form:input type="text" path="model" style="width:95%"/></td>
								</tr>
								<tr>
									<td>Numero de serie</td>
									<td><form:input type="text" path="serialNumber" style="width:95%"/></td>
								</tr>
								<tr>
									<td>Proyecto</td>
									<td><form:input path="project" style="width:95%"/></td>
								</tr>
							</table>
						</div>
					</div>
				</div>	
			</form:form>
			<button class="searchButton" id="send" onclick='return processForm("scheduledService");'>Guardar</button>
			<button class="searchButton" id="cancel" onclick="window.location='/scheduleStatus/show.do'">Cancelar</button>
		</div>
	</div>	
</body>
</html>