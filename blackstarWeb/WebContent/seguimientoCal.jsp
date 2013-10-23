<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="seguimiento" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="css/jquery.ui.theme.css"/>
		<link rel="stylesheet" href="css/jquery-ui.min.css"/>
		<style type="text/css" title="currentStyle">
			@import "DataTables-1.9.4/media/css/header.css";
			.FixedHeader_Cloned th {
				background-color: white;
			}
			th, td {
				height: 30px;
			}
			.left_cell {
				background-color: white  !important;
				border-right: 1px solid black  !important;
				text-align: center;
			}
			.right_cell {
				background-color: white !important;
				border-left: 1px solid black;
				text-align: center;
			}
			#info {
				position: absolute;
				top: 100px;
				left: 100px;
				width: 300px;
				background-color: white;
				border: 1px solid blue;
				z-index: 50;
				padding: 20px;
			}
		</style>
		<script src="js/jquery-1.10.1.min.js"></script>
		<script src="js/jquery-ui.js"></script>
		<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
		<script type="text/javascript" charset="utf-8" src="js/FixedHeader.js"></script>
		<script type="text/javascript">
		
			glow.ready(function(){
				new glow.widgets.Sortable(
					'#content .grid_5, #content .grid_6',
					{
						draggableOptions : {
							handle : 'h2'
						}
					}
				);
			});
			
			var ticketStatusMap = new Object();
			var ticketNumberMap = new Object();
			
			function closeTicket(id, ticketNumber){
				// mostrar el dialogo de seleccion de OS
				$("#cerrarOSCapture").dialog({ title: "Cerrar Ticket " + ticketNumber });
				$("#cerrarOSCapture").dialog("open");
				$("#ticketId").val(id);
			}
			
			function applyCloseTicket(){
				var osId = $("#closureOs option:selected").val();
				
				$("#osId").val(osId);
				
				$("#closeTicketSend").submit();
			}
			
			function reopenTicket(id, ticketNumber){
				$("#reopenTicketConfirm").dialog({ title: "Reabrir Ticket " + ticketNumber });
				$("#reopenTicketConfirmText").html("Desea reabrir el ticket " + ticketNumber + "?");
				$("#reopenTicketConfirm").dialog("open");
				$("#reopenTicketId").val(id);
			}
			
			function applyReopenTicket(){
				$("#reopenTicketSend").submit();
			}
			
			function showBigTable(){

				var bigTicketStr = '${ ticketsList }';

				try{
					var data = $.parseJSON(bigTicketStr);
				}
				catch(e){
					alert('Error: ' + e);
				}
				var oTable = $('#bigTicketsTable').dataTable({	    
					"iDisplayLength": -1,
					"bFilter": true,
					"bInfo": false,
					"bPaginate": false,
					"bLengthChange": false,
					"fnDrawCallback": function ( oSettings ) {
						for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ )
						{
							$('td:eq(0), td:eq(6)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( i+1 );
						}
					},				
					"bProcessing": true,
					"aaData": data,
					"sDom": '<"top"if>rt<"bottom"lp><"clear">',
					"aoColumns": [
								  { "mData": "num" },
								  { "mData": "created" },
								  { "mData": "createdBy" },
								  { "mData": "contactName" },
								  { "mData": "contactPhone" },
								  { "mData": "contactEmail" },
								  { "mData": "serialNumber" },
								  { "mData": "observations" },
								  { "mData": "customer" },
								  { "mData": "equipmentType" },
								  { "mData": "brand" },
								  { "mData": "model" },
								  { "mData": "capacity" },
								  { "mData": "responseTimeHr" },
								  { "mData": "solutionTimeHr" },
								  { "mData": "equipmentAddress" },
								  { "mData": "equipmentLocation" },
								  { "mData": "includesParts" },
								  { "mData": "exceptionParts" },
								  { "mData": "serviceCenter" },
								  { "mData": "office" },
								  { "mData": "project" },
								  { "mData": "ticketNumber" },
								  { "mData": "phoneResolved" },
								  { "mData": "arrival" },
								  { "mData": "responseTimeDeviationHr" },
								  { "mData": "followUps" },
								  { "mData": "closed" },
								  { "mData": "serviceOrderNumber" },
								  { "mData": "employee" },
								  { "mData": "solutionTime" },
								  { "mData": "solutionTimeDeviationHr" },
								  { "mData": "ticketStatus" },
								  { "mData": "Cerrar" },
								  { "mData": "num" }

							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){ticketNumberMap[row.DT_RowId] = data; return data;}, "aTargets" : [22]},	
									  {"mRender" : function(rawData, type, row){
														if(rawData != null){
															var outerTemplate = '<div onclick="addSeguimiento('+ row.DT_RowId + ', \'' + ticketNumberMap[row.DT_RowId] + '\');" style="width:700px;">INNER_TEMPLATE</div>';
															var template = '<div class="comment"><p><strong>TIMESTAMP: FROM a: WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
															var d = new Date(); 
															var content = "";
															var buffer = "";
															if(rawData[0].length == 0){ //Si no hay ningun seguimiento capturado
																buffer  = '<div onclick="addSeguimiento('+ row.DT_RowId + ', \'' + ticketNumberMap[row.DT_RowId] + '\');" style="width:700px;">Click aqui para agregar</div>';
															}
															else{
															
																for(var i = 0; i < rawData[0].length; i++){		
																	var obj = rawData[0][i];
																	d = new Date(obj.created);
																	content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
																	if(obj.createdBy != null){
																		content = content.replace('FROM', obj.createdBy);
																	}
																	else{
																		content = content.replace('FROM', '');
																	}
																	if(obj.asignee != null){
																		content = content.replace('WHO', obj.asignee);
																	}
																	else{
																		content = content.replace('WHO', '');
																	}
																	content = content.replace('MYCOMMENT', obj.followUp);
																	
																	buffer = buffer + content;
																}
																
																buffer = outerTemplate.replace("INNER_TEMPLATE", buffer);
															}
															
															return buffer;
														}
														else{
															return '';
														}
													}, "aTargets" : [26]},
									  {"mRender" : function(data, type, row){return "<a href='osDetail?osNum=" + data  + "'>" + data + "</a>";}, "aTargets" : [28]},	    		    	       
									  {"mRender" : function(data, type, row){ticketStatusMap[row.DT_RowId] = data; return data;}, "aTargets" : [34]},	    		    	       
									  {"mRender" : function(data, type, row){
														if(ticketStatusMap[row.DT_RowId] == "CERRADO" || ticketStatusMap[row.DT_RowId] == "CERRADO FT"){
															return "<a href='#' class='edit' onclick='javascript: reopenTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Reabrir ticlet</a>";
														}
														else{
															return "<a href='#' class='edit' onclick='javascript: closeTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Cerrar ticket</a>";
														}
													}, "aTargets" : [33]}	    		    	       
									 ]}
				);
				
				new FixedHeader( oTable, { "left": true, "right": true, "bottom": true } );
			}
		</script>	
	</head>
	<!--   CONTENT   -->
	<body>
	<!--   CONTENT COLUMN   -->		
					
		<div class="box">
			<h2>Tickets por revisar</h2>
		</div>
		<div style="width:2000px; height: 2000px">
			<table id = "bigTicketsTable" style="width:5800px;">
				<thead>
					<tr>
						<th>#</th>
						<th style="width:150px;">Marca temporal</th>
						<th>Nombre usuario</th>
						<th style="width:180px;">Contacto</th>
						<th>Telefóno Contacto</th>
						<th>E-mail</th>
						<th>Número de serie</th>
						<th style="width:700px;">Observaciones</th>
						<th style="width:180px;">Cliente</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>Modelo</th>
						<th>Cap.</th>
						<th>T. Resp. Comp.</th>
						<th>T. Sol. Comp.</th>
						<th style="width:230px;">Direccion</th>
						<th>Ubicacion</th>
						<th>Incluye Partes</th>
						<th>Excepcion Partes</th>
						<th>Centro Servicio</th>
						<th>Oficina</th>
						<th>Proyecto</th>
						<th>Ticket</th>
						<th>Solucion Tel.</th>
						<th style="width:150px;">F. Llegada</th>
						<th>Desviación TR</th>
						<th style="width:700px;">Seguimiento</th>
						<th style="width:150px;">Cierre</th>
						<th>Numero Reporte</th>
						<th style="width:180px;">Ingeniero</th>
						<th>T.Sol. HR</th>
						<th>Desviación</th>
						<th style="width:120px;">Estatus</th>
						<th>Cerrar Ticket</th>
						<th></th>
					</tr>
				</thead>							
				<tbody>
				</tbody>
			</table>
		</div>
		
					
	<!--   ~ CONTENT COLUMN   -->

	<!--   CONTENT ADDS  -->
		<c:import url="addfollowUpDlg.jsp"></c:import>
		<script type="text/javascript">
			$(function() {
				
				// dialogo para confirmar cierre de ticket con Orden de Servicio
				$("#cerrarOSCapture").dialog({
					autoOpen: false,
					height: 240,
					width: 300,
					modal: true,
					buttons: {
						"Aceptar": function() {
							applyCloseTicket();
							$( this ).dialog( "close" );
						},
						
						"Cancelar": function() {
						$( this ).dialog( "close" );
					}}
				});
				
				// Dialogo de confirmacion para reabrir ticket
				$("#reopenTicketConfirm").dialog({
					autoOpen: false,
					height: 180,
					width: 230,
					modal: true,
					buttons: {
						"Aceptar": function() {
							applyReopenTicket();
							$( this ).dialog( "close" );
						},
						
						"Cancelar": function() {
						$( this ).dialog( "close" );
					}}
				});
				
				// inicializando el dialogo para agregar seguimientos
				initFollowUpDlg("ticket", "/seguimiento");
				
				// inicializando el llenado de la tabla
				showBigTable();
			});
		</script>
		
		<div id="cerrarOSCapture" title="Cerrar Ticket ">
			<p>Por favor seleccione la OS que cierra el ticket:</p>
			<select id = "closureOs" style="width:90%">
				<c:forEach var="os" items="${potentialOs}">
					<option value = "${os.serviceOrderId}">${os.serviceOrderNo}</option>
				</c:forEach>
			</select>
			<form id = "closeTicketSend" action="/seguimiento" method="POST">
				<input type="hidden" name="action" value = "closeTicket"/>
				<input type="hidden" id="ticketId" name="ticketId"></input>
				<input type="hidden" id="osId" name="osId"></input>
			</form>
			<p>&nbsp;</p>
		</div>
		
		<div id="reopenTicketConfirm">
			<strong id = "reopenTicketConfirmText"></strong>
			<form id = "reopenTicketSend" action="/seguimiento" method="POST">
				<input type="hidden" name="action" value = "reopenTicket"/>
				<input type="hidden" id="reopenTicketId" name="reopenTicketId"/>
			</form>
		</div>
	<!--   ~ CONTENT ADDS  -->

	<!--   ~ CONTENT   -->
				
	<!--   FOOTER   -->			
			<div id="foot">
				<a href="#">Soporte</a>
			</div>
	<!--   ~ FOOTER   -->
	</body>
</html>