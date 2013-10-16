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
	var jsDelayedTickets = '${delayedTickets}';
	var jsOpenTickets = '${openTickets}';
	var jsPendingSo = '${pendingSo}';
	
	var assignedTicket = 0;
	
	 function assignTicket(tktId, tktNumber){
		assignedTicket = tktId;
		$('#lblTicketBeignAssigned').html(tktNumber);
		$('#tktAssignDlg').dialog('open');
	 }
	 
	 function refreshTicketList(){
	 
		// Tabla de tickets retrasados
		 var data = $.parseJSON(jsDelayedTickets);
		
		$('#dtDelayedTickets').dataTable({	    		
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
						  { "mData": "ticketStatus" }
					  ],
			"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]}	    		    	       
							 ]}
		);
  
  
		// Tabla de Tickets abiertos
		 var data = $.parseJSON(jsOpenTickets);
		
		$('#dtDelayedTickets').dataTable({	    		
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
						  { "mData": "ticketStatus" }
					  ],
			"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]}	    		    	       
							 ]}
		);


		// Tabla de ordenes de servicio pendientes
		var dataSO = $.parseJSON(jsPendingSo);	

		$('#dtPendingSo').dataTable({	
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
						  { "mData": "asignee" },
						  { "mData": "description" }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='/osDetail?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){return "<img src='img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [2]},
								  {"mRender" : function(rawData, type, row){
									
											var template = '<div class="comment"><p><strong>TIMESTAMP: FROM a: WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
											var d = new Date(); 
											var content = "";
											var buffer = "";
											
											for(int i = 0; i < rawData.length; i++){
												d = new Date(rawData[i].created);
												content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
												content = content.replace('FROM', rawData[i].createdBy);
												content = content.replace('WHO', rawData[i].asignee);
												content = content.replace('MYCOMMENT', rawData[i].followUp);
												
												buffer = buffer + content;
											}
											
											return buffer;
										
										}, "aTargets" : [10]}   		    	       
								 ]}
		);
	 }
	 
	 function postAssignedTicket(pTicketId, pEmployee){
		$('#ticketId').val(pTicketId);
		$('#employee').val(pEmployee);
		$('#ticksetSelect').submit();
	}
 
 $(document).ready(function() {
	 
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
							<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtDelayedTickets">
								<thead>
									<tr> 
										<th>Ticket</th>
										<th>Fecha/Hora</th>
										<th>Cliente</th>
										<th>Equipo</th>
										<th>Tiem. R</th>
										<th>Proyecto</th>
										<th>Estatus</th>
										<th>Asignar</th>
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
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtPendingSo">
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

</body>
</html>