<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
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
	 var str = '${ticketsList}';

	 function assignTicket(tktId, tktNumber){
		assignedTicket = tktId;
		$('#lblTicketBeignAssigned').html(tktNumber);
		$('#tktAssignDlg').dialog('open');
	 }
	 
	 $(document).ready(function() {

	 try{
	 var data = $.parseJSON(str);
	 }
	 catch(err){
	 alert(err);
	 }

	 $('#tickets').dataTable({
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
						  { "mData": "asignee" },
						  { "mData": "asignar" }

					  ],
			"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]},
							  {"mRender" : function(data, type, row){return "<a href='#' class='edit' onclick='javascript: assignTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [8]}	    		    	       
							 ]}
		);
		
	} );
	
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
		<div class="grid_16">

			<div class="box">
							<h2>Ultimos tickets</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="tickets">
				<thead>
					<tr>
						<th>Ticket</th>
						<th style="width:140px;">Fecha/Hora</th>
						<th style="width:120px;">Cliente</th>
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
	<div id="tktAssignDlg" title="Asignar Ticket" >
		<p>Asignar ticket<label id="lblTicketBeignAssigned"></label></p>
			<select id="employeeSelect">
				<c:forEach var="employee" items="${employees}">
					<option value = "${ eomployee.key }">${employee.value}</option>
				</c:forEach>
			</select>
		<form id="ticksetSelect" action="tickets" method="post">
			<input id="ticketId" name="ticketId" type="hidden"/>
			<input id="employee" name="employee" type="hidden"/>
		</form>
	</div>
</body>
</html>
