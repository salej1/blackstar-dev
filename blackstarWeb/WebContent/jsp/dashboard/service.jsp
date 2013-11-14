<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="dashboard" />
<c:import url="${pageContext.request.contextPath}/header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
	var strSO = '${serviceOrdersPendingDashboard}';
	var str = '${ticketsToAssignDashboard}';
	var strSOTR = '${serviceOrdersToReviewDashboard}';
	var assignedTicket = 0;
	
	 function assignTicket(tktId, tktNumber){
		assignedTicket = tktId;
		$('#lblTicketBeignAssigned').html(tktNumber);
		$('#tktAssignDlg').dialog('open');
	 }
	 
	 function refreshTicketList(){
	 
		// Tabla de tickets
		 var data = $.parseJSON(str);
		
		$('#dtTicketsPorAsignar').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": data,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "ticketNumber" },
						  { "mData": "created" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "responseTimeHR" },
						  { "mData": "project" }, 	              
						  { "mData": "ticketStatus" },
						  { "mData": "Asignar" }

					  ],
			"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=${pageContext.request.contextPath}/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]},
							  {"mRender" : function(data, type, row){return "<a href='#' class='edit' onclick='javascript: assignTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]}	    		    	       
							 ]}
		);
  
  
		// Tabla de Ordenes de servicio nuevas
		 var dataSOTR  = $.parseJSON(strSOTR);
		 
		$('#dtOrdenesPorRevisar').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": dataSOTR,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "serviceOrderNumber" },
						  { "mData": "placeHolder" },
						  { "mData": "ticketNumber" },
						  { "mData": "serviceType" },
						  { "mData": "created" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "project" },
						  { "mData": "officeName" },

					  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/osDetail?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data){return "<img src='${pageContext.request.contextPath}/img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
								  {"mRender" : function(data){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketId=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
								   ]}
		);

		// Tabla de ordenes de servicio pendientes
		var dataSO = $.parseJSON(strSO);	

		$('#dtOrdenesPendientes').dataTable({	
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": dataSO,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
						  { "mData": "serviceOrderNumber" },
						  { "mData": "placeHolder" },
						  { "mData": "ticketNumber" },
						  { "mData": "serviceType" },
						  { "mData": "created" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "project" },
						  { "mData": "officeName" },
						  { "mData": "brand" },
						  { "mData": "serialNumber" }

						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/osDetail?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){return "<img src='${pageContext.request.contextPath}/img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
								  {"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
								   ]}
		);
	 }
	 
	 function postAssignedTicket(pTicketId, pEmployee){
		$('#ticketId').val(pTicketId);
		$('#employee').val(pEmployee);
		$('#ticksetSelect').submit();
	}
 
 $(document).ready(function() {
	 
	 $("#tktAssignDlg").dialog({
			autoOpen: false,
			height: 200,
			width: 260,
			modal: true,
			buttons: {
				"Aceptar": function() {
					var employee = $("#employeeSelect option:selected").val();

					postAssignedTicket(assignedTicket, employee);
					
					$( this ).dialog( "close" );
				},
				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
	});

	refreshTicketList();
	
});
</script> 
<title>Tickets</title>
</head>
<body>
<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->		

               <div class="grid_16">	
					<div>
						<div>
							<img src="${pageContext.request.contextPath}/img/navigate-right.png"/><a href="$">Crear Orden de Servicio</a>
						</div>
						<div>
							<img src="${pageContext.request.contextPath}/img/navigate-right.png"/><a href="$">Crear Reporte de Aire Acondicionado</a>
						</div>
						<div>
							<img src="${pageContext.request.contextPath}/img/navigate-right.png"/><a href="$">Crear Reporte de Baterias</a>
						</div>
						<div>
							<img src="${pageContext.request.contextPath}/img/navigate-right.png"/><a href="$">Crear Reporte de Planta de emergencia</a>
						</div>
						<div>
							<img src="${pageContext.request.contextPath}/img/navigate-right.png"/><a href="$">Crear UPS</a>
						</div>
					</div>
					<p><small>&nbsp;</small></p>
               </div>	
				<div class="grid_16">
					<div class="box">
						<h2>Servicios Programados</h2>
						<div class="utils">
							
						</div>
						<div id= ticketTablaContainer>
							<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtTicketsPorAsignar">
								<thead>
									<tr> 
									   <th>Fecha<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Fecha:');"/></th>
									   <th>Cliente<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Cliente:');"/></th>
									   <th>Equipo<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Equipo:');"/></th>
									   <th>Proyecto<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Proyecto:');"/></th>
									   <th>Oficina<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Oficina:');"/></th>
									   <th>Marca<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Marca:');"/></th>
									   <th>No. Serie<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Modelo:');"/></th>
									   <th>O.S.</th>
									</tr>
								</thead>
								<tbody>  
								</tbody> 
							</table>
						</div>
					</div>
				</div>

				<div class="grid_16">
					<div class="box">
						<h2>Ultimos tickets asignados</h2>
						<div class="utils">
							
						</div>
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPorRevisar">
							<thead>
								<tr>
                                    <th>Ticket<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Ticket:');"/></th>
									<th>Fecha/Hora</th>
									<th>Contacto<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Contacto:');"/></th>
									<th>Cliente<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Cliente:');"/></th>
									<th>Equipo<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Equipo:');"/></th>
									<th>TR</th>
									<th>Proyecto<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Proyecto:');"/></th>
									<th>Estatus<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Estatus:');"/></th>
									<th>O.S.</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>

				</div>

				<div class="grid_16">
					<div class="box">
						<h2>Ordenes de servicio con pendientes</h2>
						<div class="utils">
							
						</div>
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPendientes">
							<thead>
								<tr>
                                    <th>Folio<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Folio:');"/></th>
									<th></th>
									<th>Ticket<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Ticket:');"/></th>
									<th>Tipo<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Tipo:');"/></th>
									<th>Fecha<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Fecha:');"/></th>
									<th>Cliente<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Cliente:');"/></th>
									<th>Equipo<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Equipo:');"/></th>
									<th>Proyecto<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Proyecto:');"/></th>
									<th>Oficina<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Oficina:');"/></th>
									<th>Marca<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Marca:');"/></th>
									<th>No. Serie<img class="filterImg" src="${pageContext.request.contextPath}/img/filter-16.png" onclick="filtrar('Modelo:');"/></th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>

				</div>

</div>
	<!-- Assign Ticket section -->
	<div id="tktAssignDlg" title="Asignar Ticket" >
		<p>Asignar ticket<label id="lblTicketBeignAssigned"></label></p>
			<select id="employeeSelect">
				<c:forEach var="employee" items="${employees}">
					<option value = "${employee.key}">${employee.value}</option>
				</c:forEach>
			</select>
		<form id="ticksetSelect" action="dashboard" method="post">
			<input id="ticketId" name="ticketId" type="hidden"/>
			<input id="employee" name="employee" type="hidden"/>
		</form>
	</div>
</body>
</html>