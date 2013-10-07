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
<link rel="stylesheet" href="css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="css/jquery-ui.min.css"/>
<script src="js/jquery-1.10.1.min.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
	var strSO = '${serviceOrdersPendingDashboard}';
	var str = '${ticketsToAssignDashboard}';
	var strSOTR = '${serviceOrdersToReviewDashboard}';
	var assignedTicket = "";
	
	 function assignTicket(tkt){
		assignedTicket = tkt;
		$('#lblTicketBeignAssigned').html(tkt);
		$('#tktAssignDlg').dialog('open');
	 }
	 
	 function refreshTicketList(){
		 var data = $.parseJSON(str);
		$('#ticketTablaContainer').html('');

		$('#ticketTablaContainer').html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtTicketsPorAsignar"> <thead> <tr> <th style="width:60px;">Ticket</th> <th>Fecha/Hora</th> <th>Cliente</th> <th>Equipo</th> <th style="width:70px;">Tiem. R</th> <th>Proyecto</th> <th>Estatus</th> <th>Asignar</th> </tr> </thead> <tbody>  </tbody> </table>')	;
		
		$('#dtTicketsPorAsignar').dataTable({	    		
			"bProcessing": true,
			"bFilter": false,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"aaData": data,
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
			"aoColumnDefs" : [{"mRender" : function(data){return "<div align=center><a href=/ticketDetail?ticketId=" + data + ">" + data + "</a></div>";}, "aTargets" : [0]},
							  {"mRender" : function(data){return "<a href='#' class='edit' onclick='javascript: assignTicket(\"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]}	    		    	       
							 ]}
		);


		 var dataSOTR  = $.parseJSON(strSOTR);
		 
		$('#dtOrdenesPorRevisar').dataTable({	    		
			"bProcessing": true,
			"bFilter": false,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"aaData": dataSOTR,
			"aoColumns": [
						  { "mData": "serviceOrderNumber" },
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
			"aoColumnDefs" : [{"mRender" : function(dataSOTR){return "<div align='center'><a href='/osDetail.html?ticketId=" + dataSOTR + "'>" + dataSOTR + "</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='img/pdf.png' onclick=window.open('img/UPSPreview.png', '_blank');/></div>";}, "aTargets" : [0]},
							  {"mRender" : function(dataSOTR){return "<div align='center'><a href='/ticketDetail.html?ticketId=" + dataSOTR + "'>" + dataSOTR + "</a></div>";}, "aTargets" : [1]}	    		    	       
							   ]}
		);

		var dataSO = $.parseJSON(strSO);	
		alert(strSO);
			$('#dtOrdenesPendientes').dataTable({	    		
				"bProcessing": true,
				"bFilter": false,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"aaData": dataSO,
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
				"aoColumnDefs" : [{"mRender" : function(dataSO){return "<div align='center'><a href='/osDetail.html?ticketId=" + dataSO + "'>" + dataSO + "</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='img/pdf.png' onclick=window.open('img/UPSPreview.png', '_blank');/></div>";}, "aTargets" : [0]},
								  {"mRender" : function(dataSO){return "<div align='center'><a href='/ticketDetail.html?ticketId=" + dataSO + "'>" + dataSO + "</a></div>";}, "aTargets" : [1]}	    		    	       
								   ]}
		);
	 }
	 
	 function postAssignedTicket(pTicketNumber, pEmployee){

		$.post( "dashboard", { 
				ticketNumber: pTicketNumber, 
				employee: pEmployee
		})
		.done(function( str ) {
			alert('done');
			var data = $.parseJSON(str);
			$('#ticketTablaContainer').html('');
/*
			$('#ticketTablaContainer').html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtTicketsPorAsignar"> <thead> <tr> <th style="width:60px;">Ticket</th> <th>Fecha/Hora</th> <th>Cliente</th> <th>Equipo</th> <th style="width:70px;">Tiem. R</th> <th>Proyecto</th> <th>Estatus</th> <th>Asignar</th> </tr> </thead> <tbody>  </tbody> </table>')	;
			$('#dtTicketsPorAsignar').dataTable({	    		
				"bProcessing": true,
				"bFilter": false,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"aaData": data,
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
				"aoColumnDefs" : [{"mRender" : function(data){return "<div align=center><a href=/ticketDetail?ticketId=" + data + ">" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data){return "<a href='#' class='edit' onclick='javascript: assignTicket(\"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]}	    		    	       
								 ]}
			);	*/
			
	});
	}
 
 $(document).ready(function() {
	 
	 $("#tktAssignDlg").dialog({
			autoOpen: false,
			height: 200,
			width: 260,
			modal: true,
			buttons: {
				"Aceptar": function() {
					var employee = $("#selectStatus option:selected").val();

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
					
				</div>
				<div class="grid_16">
					<div class="box">
						<h2>Tickets por asignar</h2>
						<div class="utils">
							<a href="#">Ver Todos</a>
						</div>
						<div id= ticketTablaContainer>
							
						</div>
					</div>
				</div>

				<div class="grid_16">
					<div class="box">
						<h2>Ordenes de servicio por revisar</h2>
						<div class="utils">
							<a href="#">Ver Todos</a>
						</div>
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPorRevisar">
							<thead>
								<tr>
									<th style="width=250px;">Folio</th>
									<th style="width=50px;"></th>
									<th>Ticket</th>
									<th>Tipo</th>
									<th>Fecha</th>
									<th>Cliente</th>
									<th>Equipo</th>
									<th>Proyecto</th>
									<th>Oficina</th>
									<th>Marca</th>
									<th>No. Serie</th>
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
							<a href="#">Ver Todos</a>
						</div>
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPendientes">
							<thead>
								<tr>
									<th>Folio</th>
									<th></th>
									<th>Ticket</th>
									<th>Tipo</th>
									<th>Fecha</th>
									<th>Cliente</th>
									<th>Equipo</th>
									<th>Proyecto</th>
									<th>Oficina</th>
									<th>Marca</th>
									<th>No. Serie</th>
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
		<select id="selectStatus">
			<c:forEach var="employee" items="${employees}">
				<option>${employee}</option>
			</c:forEach>
		</select>
	</div>
</body>
</html>