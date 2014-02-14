<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	
$(document).ready(function() {
	 
	 $("#tktAssignDlg").dialog({
			autoOpen: false,
			height: 200,
			width: 260,
			modal: true,
			buttons: {
				"Aceptar": function() {
					var employee = $('#employeeSelect').find('option:selected').val();
					postAssignedTicket(assignedTicket, employee);
					
					$( this ).dialog( "close" );
				},
				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
	});
	
});

  function assignTicket(tktId, tktNumber){
	assignedTicket = tktId;
	$('#lblTicketBeignAssigned').html(tktNumber);
	$('#tktAssignDlg').dialog('open');
  }
  
  function postAssignedTicket(pTicketId, pEmployee){
	$('#ticketId').val(pTicketId);
	$('#employee').val(pEmployee);
	$('#ticksetSelect').submit();
  }
 
	// Inicializacion de tabla de tickets asignados
	function teamTickets_init(){
		// Tabla de tickets
		getTeamTickets();
	}	
	
	// Funcion que muestra la tabla de tickets asignados
	function getTeamTickets(){
		$.getJSON("/dashboard/teamTicketsJson.do", function(data){
			// Inicializacion de tabla de ticets asignados
			$('#teamTicketsTable').dataTable({	    		
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
							  { "mData": "ticketDate" },
							  { "mData": "customer" },
							  { "mData": "equipmentType" },
							  { "mData": "responseTime" },
							  { "mData": "project" }, 	              
							  { "mData": "ticketStatus" },
							  { "mData": "placeHolder" }

						  ],
				"aoColumnDefs" : [
									{"mRender" : function(data, type, row){return "<div><a href=${pageContext.request.contextPath}/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]},
									{"mRender" : function(data, type, row){return "<a href='#' class='edit' onclick='javascript: assignTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]}	       
								 ]}
			);
		});
	}
	
</script>

<!--
	Seccion tabla de tickets sin asignar
-->
<div class="grid_16">
	<div class="box">
		<h2>Tickets asignados en mi equipo</h2>
		<div class="utils">
			
		</div>
		<div id= ticketTablaContainer>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="teamTicketsTable">
				<thead>
					<tr> 
						<th style="width:50px;">Ticket</th>
						<th>Fecha/Hora</th>
						<th style="width:200px;">Cliente</th>
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

		<!-- Assign Ticket section -->
	<div id="tktAssignDlg" title="Asignar Ticket" >
		<p>Asignar ticket<label id="lblTicketBeignAssigned"></label></p>
			<select id="employeeSelect">
				<c:forEach var="employee" items="${staff}">
					<option value = "${ employee.email }">${employee.name}</option>
				</c:forEach>
			</select>
		<form id="ticksetSelect" action="/dashboard/asignTicket.do" method="post">
			<input id="ticketId" name="ticketId" type="hidden"/>
			<input id="employee" name="employee" type="hidden"/>
		</form>
	</div>

<!--
	FIN - Seccion tabla de tickets sin asignar
-->
