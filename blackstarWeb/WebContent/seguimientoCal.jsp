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
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
	</head>
	<!--   CONTENT   -->
	<body>
	<!--   CONTENT COLUMN   -->		
					
		<div class="box">
			<h2>Tickets por revisar</h2>
		</div>
		<div style="width:1000px; height: 2000px">
			<table id = "bigTicketsTable" style="width:3540px;">
				<thead>
					<tr>
						<th style="width:15px;">#</th>
						<th style="width:80px;">Ticket</th>
						<th style="width:120px;">Estatus</th>
						<th style="width:125px;">Marca temporal</th>
						<th style="width:130px;">Contacto</th>
						<th style="width:170px;">Número de serie</th>
						<th style="width:350px;">Observaciones</th>
						<th style="width:170px;">Cliente</th>
						<th style="width:40px;">Equipo</th>
						<th style="width:170px;">Ubicacion</th>
						<th style="width:120px;">Centro Servicio</th>
						<th style="width:70px;">Proyecto</th>
						<th style="width:70px;">Solucion Tel.</th>
						<th style="width:125px;">F. Llegada</th>
						<th style="width:700px;">Seguimiento</th>
						<th style="width:125px;">Cierre</th>
						<th style="width:80px;">Numero OS</th>
						<th style="width:180px;">Ingeniero</th>
						<th style="width:80px;">Desviación</th>
						<th style="width:100px;">Cerrar Ticket</th>
						<th style="width:80px;">Ticket</th>
					</tr>
				</thead>							
				<tbody>
				</tbody>
			</table>
		</div>
		
					
	<!--   ~ CONTENT COLUMN   -->

	<!--   CONTENT ADDS  -->
		<div style="display:none;">
			<c:import url="followUpControl.jsp"></c:import>
		</div>
		
		
		<div id="cerrarOSCapture" title="Cerrar Ticket ${ticketF.ticketNumber}">
			<form id = "closeTicketSend" action="/ticketDetail" method="POST">
				<p>
					Folio de la OS que cierra el ticket:
					<input type="text" id="osId" name="osId" style="width:95%" />
				</p>
				<p>
					Fecha y hora de cierre:
					<input type="text" id="closeDatetime" name="closeDatetime" style="width:95%" />
				</p>
				<p>
					Ingeniero que atendio:
					<input type="text" id="attendingEmployee" name="attendingEmployee" style="width:95%" />
				</p>
				<input type="hidden" name="action" value = "closeTicket" />
				<input type="hidden" id="closeTicketId" name="closeTicketId" />
				<input type="hidden" id="sender" name="sender" value="seguimiento"/>
			</form>
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
		<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
		<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
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
				$("#closeTicketId").val(id);
			}
			
			function applyCloseTicket(){
				// TODO: Reactivas seleccion de OS para prduccion
				// var osId = $("#closureOs option:selected").val();
				
				// $("#osId").val(osId);
				
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
							$('td:eq(0), td:eq(34)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( i+1 );
						}
					},				
					"bProcessing": true,
					"aaData": data,
					"sDom": '<"top"if>rt<"bottom"lp><"clear">',
					"aaSorting": [],
					"aoColumns": [
								  { "mData": "num" },
								  { "mData": "ticketNumber" },
								  { "mData": "ticketStatus" },
								  { "mData": "created" },
								  { "mData": "contactName" },
								  { "mData": "serialNumber" },
								  { "mData": "observations" },
								  { "mData": "customer" },
								  { "mData": "equipmentType" },
								  { "mData": "equipmentLocation" },
								  { "mData": "serviceCenter" },
								  { "mData": "project" },
								  { "mData": "phoneResolved" },
								  { "mData": "arrival" },
								  { "mData": "followUps" },
								  { "mData": "closed" },
								  { "mData": "serviceOrderNumber" },
								  { "mData": "employee" },
								  { "mData": "solutionTimeDeviationHr" },
								  { "mData": "Cerrar" },
								  { "mData": "ticketNumber" }

							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){
														ticketNumberMap[row.DT_RowId] = data; 
														return "<b><a href='ticketDetail?ticketId=" + row.DT_RowId  + "'>" + data + "</a></b>";
													}, "aTargets" : [1]},	
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
																	d = new Date(obj.timeStamp);
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
													}, "aTargets" : [14]},
									  {"mRender" : function(data, type, row){return "<a href='osDetail?osNum=" + data  + "'>" + data + "</a>";}, "aTargets" : [16]},
									  {"mRender" : function(data, type, row){
									  					ticketStatusMap[row.DT_RowId] = data;
									  					var template = "<div style='text-align:center;display:table-cell;vertical-align:middle;height:50px;width:100px;background-color:#COLOR;'>" + data + "</div>";
									  					var color = "";
									  					switch(data){
									  						case "ABIERTO": color = "FFFF00"; break;
									  						case "RETRASADO": color = "FF0000"; break;
									  						case "CERRADO":  color = "00FF00"; break;
									  						case "CERRADO FT":  color = "FF9900"; break;
									  					}

									  					template = template.replace("COLOR", color);
									  					return template;
									  				}, "aTargets" : [2]},
									  {"mRender" : function(data, type, row){
														if(ticketStatusMap[row.DT_RowId] == "CERRADO" || ticketStatusMap[row.DT_RowId] == "CERRADO FT"){
															return "<a href='#' class='edit' onclick='javascript: reopenTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Reabrir ticlet</a>";
														}
														else{
															return "<a href='#' class='edit' onclick='javascript: closeTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Cerrar ticket</a>";
														}
													}, "aTargets" : [19]}
									 ]}
				);
				
				// No se ha podido hacer funcionar FixHeader, por el momento se ignora, ya que causa un error de JS
				// new FixedHeader( oTable, { "left": true, "right": true, "bottom": true } );
			}

			$(function() {
				
				// dialogo para confirmar cierre de ticket con Orden de Servicio
				$("#cerrarOSCapture").dialog({
					autoOpen: false,
					height: 300,
					width: 360,
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
				initFollowUpDlg("ticket", "seguimiento");
				
				// inicializando el llenado de la tabla
				showBigTable();

				// inicializando selectores de fecha/hora
				$('#closeDatetime').datetimepicker({format:'d/m/Y H:i', lang:'es'});
			});
		</script>
</html>