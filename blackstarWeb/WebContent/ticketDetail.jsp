<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
<c:import url="header.jsp"></c:import>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
</head>
<body>

<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->		
				<div class="grid_16">					
					<div class="box">
						<h2>Ticket ${ticketF.ticketNumber}</h2>
						<div class="utils">
						</div>
						<table>
							<tbody>
								<tr>
									<td style="width:200px;">Asignado a:</td>
									<td>
										<select id="selectAsignee"  style="width:78%;">
											<option value="0"></option>
											<c:forEach var="employee" items="${employees}">
												<option value="${employee.userEmail}"
												<c:if test="${ employee.userEmail == ticketF.asignee }">
													selected = "true"
												</c:if>
												>${ employee.userName }</option>
											</c:forEach>
										</select>
										<button class="searchButton" onclick="javascript:assignNow(); return false;">Asignar ahora</button>
									</td>
								</tr>
								<tr><td>Estatus</td><td><input id="lbEstatus" type="text" style="width:95%;" readonly="true"/>
								<tr><td>Marca temporal</td><td><input id="lbCreated" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Nombre de usuario</td><td><input id="lbNombreUsuario" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Contacto</td><td><input type="text" id="lbContacto" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Telefóno de Contacto</td><td><input id="lbTelContacto" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>E-mail</td><td><input type="text" id="lbMailContacto" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Número de serie del Equipo</td><td><input id="lbNoSerie" type="text" readonly="true"  style="width:95%;"/></td></tr>
								<tr><td>Observaciones</td><td><textarea id="lbObservaciones" readonly="true"  style="width:95%;" rows="7"></textarea></td></tr>
								<tr><td>Cliente</td><td><input type="text" id="lbCliente" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Equipo</td><td><input type="text" id="lbEquipo"  readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Marca</td><td><input type="text" id="lbMarca" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Modelo</td><td><input type="text" id="lbModelo" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Capacidad</td><td><input type="text" id="lbCAP" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Se pudo resolver via telefónica</td><td><input type="text" id="lbResolvioTel" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Fecha y Hora de llegada</td><td><input type="text" id="lbHoraLLegada" readonly="true"  style="width:20%;" />
									<img src="/img/edit.png" id="editArrival" class="clickable" alt="" style="vertical-align:middle;padding-left:5px;" onclick="edit('Arrival', 'lbHoraLLegada');"/>
									<img src="/img/okEdit.png" id="okEditArrival" class="clickable" alt="" style="vertical-align:middle;padding-left:5px;" onclick="okEdit('Arrival', 'lbHoraLLegada');"/>
									<img src="/img/cancelEdit.png" id="cancelEditArrival" class="clickable" alt="" style="vertical-align:middle;padding-left:5px;" onclick="cancelEdit('Arrival', 'lbHoraLLegada', '${ticketF.arrival}');"/></td></tr>
								<tr><td>Tiempo Respuesta</td><td><input type="text" readonly="true" id="lbRespuesta"  style="width:5%;" /> Hr</td></tr>
								<tr><td>Tiempo Respuesta Compromiso</td><td><input id="lbTiempoRespuesta" type="text" readonly="true"  style="width:5%;" /> Hr</td></tr>
								<tr><td>Desviación T. Respuesta</td><td><input type="text" readonly="true"  id="lbDesviacion" style="width:5%;" /> Hr</td></tr>
								<tr><td>Fecha y Hora de Cierre</td><td><input type="text" readonly="true" id="lbHoraCierre"  style="width:95%;" /></td></tr>
								<tr><td>Tiempo Solución</td><td><input type="text" readonly="true" id="lbTS"  style="width:5%;" /> Hr</td></tr>
								<tr><td>Tiempo Solucion Compromiso</td><td><input type="text" id="lbTiempoSolucion" readonly="true"  style="width:5%;" /> Hr </td></tr>
								<tr><td>Desviación T. Solución</td><td><input type="text" readonly="true" id="lbDesviacionTS" style="width:5%;" /> Hr</td></tr>
								<tr><td>Numero de Reporte de Servicio</td><td><input type="text" readonly="true" id="lbNoReporte" style="width:95%;"/></td></tr>
								<tr><td>Ingeniero que atendió</td><td><input type="text" readonly="true" id="lbIngeniero" style="width:95%;" /></td></tr>
								<tr><td>Proyecto</td><td><input type="text" readonly="true" id="lbProyecto" style="width:95%;" /></td></tr>
								<tr><td>Oficina</td><td><input type="text" readonly="true" id="lbOficina" style="width:95%;" /></td></tr>
								<tr><td>Direccion del Equipo</td><td><input type="text" id="lbDireccion" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Ubicación del Equipo</td><td><input type="text" id="lbUbicacion" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Incluye Partes</td><td><input type="text" id="lbIncluyePartes" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Excepción de Partes</td><td><input type="text" id="lbExcpcionPartes" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Centro de Servicio</td><td><input type="text" id="lbCentroServicio" readonly="true"  style="width:95%;" /></td></tr>
								</td>
								</tr>
							</tbody>
						</table>
						
						<!-- Control de secuencia y captura de seguimiento -->
						<c:import url="followUpControl.jsp"></c:import>

						<table>
							<tbody>
								<tr>
									<td>
										<p></p>
										<button class="searchButton" onclick="addSeguimiento(${ticketF.ticketId}, '${ticketF.ticketNumber}');">Agregar seguimiento</button>
										<c:choose>
											<c:when test="${ticketstatusT.ticketStatus == 'CERRADO' || ticketstatusT.ticketStatus == 'CERRADO FT'}">
												<button class="searchButton" onclick="reopenTicket(${ticketF.ticketId}, '${ticketF.ticketNumber}');">Reabrir ticket</button>
											</c:when>
											<c:otherwise>
												<button class="searchButton" onclick="closeTicket(${ticketF.ticketId}, '${ticketF.ticketNumber}');">Cerrar Ticket</button>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							<tbody>
						</table>
					</div>					
				</div>
				
			<form action="/dashboard/asignTicket.do" id="sendAssignNow" method="POST">
				<input type="hidden" name="ticketId" id="ticketId"/>
				<input type="hidden" name="employee" id="employee"/>
			</form>	
				
			<!-- 
				Seleccion automatica de os OS desactivada temporalmente, se capturara a mano
				Reactivar cuando entre en produccion Ordenes de Servicio

				<div id="cerrarOSCapture" title="Cerrar Ticket ${ticketF.ticketNumber}">
					<p>Por favor seleccione la OS que cierra el ticket:</p>
					<select id = "closureOs" style="width:90%">
						<c:forEach var="os" items="${ potentialOs }">
							<option value="${ os.key }">${ os.value }</option>
						</c:forEach>
					</select>
					<form id = "closeTicketSend" action="/ticketDetail" method="POST">
						<input type="hidden" name="action" value = "closeTicket"/>
						<input type="hidden" id="closeTicketId" name="closeTicketId"></input>
						<input type="hidden" id="osId" name="osId"></input>
					</form>
				</div>
			-->

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
				</form>
			</div>

			<div id="reopenTicketConfirm">
				<strong id = "reopenTicketConfirmText"></strong>
				<form id = "reopenTicketSend" action="/ticketDetail" method="POST">
					<input type="hidden" name="action" value = "reopenTicket"/>
					<input type="hidden" id="reopenTicketId" name="reopenTicketId"/>
				</form>
			</div>

			<div id="processing" title="Actualizando...">
				<div>Guardando cambios...</div>
				<div style="width:100%;text-align:center;"><img src="/img/processing.gif" alt="" style="padding-top:10px;"/></div>
				<form id="updateTicket" action="/ticketDetail" method="POST">
					<input type="hidden" name="action" value = "updateArrival"/>
					<input type="hidden" id="arrival" name="arrival">
					<input type="hidden" name="ticketId" value="${ticketF.ticketId}">
				</form>
			</div>
</div>
</body>
<!-- <script src="${pageContext.request.contextPath}/js/jquery.js"></script> -->
<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
<script type="text/javascript">
	
		function toggleEdit(what, val, fld){
			if(val == true){
				$('#edit'+what).hide();
				$('#okEdit'+what).show();
				$('#cancelEdit'+what).show();
				$('#'+fld).removeAttr("readonly");
				$('#'+fld).datetimepicker({format:'d/m/Y H:i', lang:'es'});				
				$('#'+fld).datetimepicker('show');		
			}
			else{
				$('#edit'+what).show();
				$('#okEdit'+what).hide();
				$('#cancelEdit'+what).hide();
				$('#'+fld).attr("readonly", "");
				$('#'+fld).datetimepicker("destroy");
				$('#'+fld).addClass("XX_REFRESH_CLASS");
				$('#'+fld).removeClass("XX_REFRESH_CLASS");
			}
		}

		function okEdit(what, field){
			$("#processing").dialog("open");
			$("#arrival").val($("#lbHoraLLegada").val());
			$("#updateTicket").submit();
		}

		function edit(what, field){
			toggleEdit(what, true, field);
		}

		function cancelEdit(what, field, old){
			toggleEdit(what, false);
			$('#'+field).val(old);		
		}

		function applyCloseTicket(){
			// TODO: Reactivas seleccion de OS para prduccion
			// var osId = $("#closureOs option:selected").val();
			
			// $("#osId").val(osId);
			
			$("#closeTicketSend").submit();
		}
		

		function closeTicket(id, ticketNumber){
			// mostrar el dialogo de seleccion de OS
			$("#cerrarOSCapture").dialog({ title: "Cerrar Ticket " + ticketNumber });
			$("#cerrarOSCapture").dialog("open");
			$("#closeTicketId").val(id);
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
			

		$(document).ready(function () 
		{
			// Ocultando botones de edicion
			$("#okEditArrival").hide();
			$("#cancelEditArrival").hide();

			// Close ticket section
			$("#cerrarOSCapture").dialog({
				autoOpen: false,
				height: 300,
				width: 360,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$( this ).dialog( "close" );
						applyCloseTicket();
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
			});

			$("#processing").dialog({
				autoOpen: false,
				height: 120,
				width: 230,
				modal: true,
				buttons: {}
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

			// inicializando selectores de fecha/hora
			$('#closeDatetime').datetimepicker({format:'d/m/Y H:i', lang:'es'});

			$('#lbCreated').val(new Date('${ticketF.created}').format('dd/MM/yyyy hh:mm:ss'));
			$('#lbNombreUsuario').val('${ticketF.user}');
			$('#lbContacto').val('${policyt.contactName}');
			$('#lbTelContacto').val('${policyt.contactPhone}');
			$('#lbMailContacto').val('${policyt.contactEmail}');
			$('#lbNoSerie').val('${policyt.serialNumber}');
			$('#lbObservaciones').html('${ticketF.observations}');
			$('#lbCliente').val('${policyt.customer}');
			$('#lbEquipo').val('${EquipmenttypeT.equipmentType}');
			$('#lbMarca').val('${policyt.brand}');
			$('#lbModelo').val('${policyt.model}');
			$('#lbCAP').val('${policyt.capacity}');
			$('#lbRespuesta').val('${ticketF.realResponseTime}');
			$('#lbTiempoRespuesta').val('${policyt.responseTimeHR}');
			$('#lbTiempoSolucion').val('${policyt.solutionTimeHR}');
			$('#lbDireccion').val('${policyt.equipmentAddress}');
			$('#lbUbicacion').val('${policyt.equipmentLocation}');
			if(${policyt.includesParts} == true){
				$('#lbIncluyePartes').val('SI')
			}
			else{
				$('#lbIncluyePartes').val('NO')
			}
			$('#lbExcpcionPartes').val('${policyt.exceptionParts}');
			$('#lbCentroServicio').val('${ServicecenterT.serviceCenter}');
			$('#lbOficina').val('${officeT.officeName}');
			$('#lbProyecto').val('${policyt.project}');
			if(${ticketF.phoneResolved}){
				$('#lbResolvioTel').val('SI');
			}
			else{
				$('#lbResolvioTel').val('NO');
			}
			if('${ticketF.arrival}' != ''){
				$('#lbHoraLLegada').val(new Date('${ticketF.arrival}').format('dd/MM/yyyy hh:mm:ss'));
			}
			$('#lbDesviacion').val('${ticketF.responseTimeDeviationHR}');
			if('${ticketF.closed}' != ''){
				$('#lbHoraCierre').val(new Date('${ticketF.closed}').format('dd/MM/yyyy hh:mm:ss'));
			}
			$('#lbNoReporte').val('${ticketF.serviceOrderNumber}');
			$('#lbIngeniero').val('${ticketF.employee}');
			if(${ticketF.solutionTime} > 0){
				$('#lbTS').val('${ticketF.solutionTime}');
			}
			$('#lbDesviacionTS').val('${ticketF.solutionTimeDeviationHr}');
			$('#lbEstatus').val('${ticketstatusT.ticketStatus}');
			
			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("ticket", "ticketDetail?ticketId=${ticketF.ticketId}");
		});
	
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
	
		function assignNow(){
			var ticketId = ${ticketF.ticketId};
			var asignee = $("#selectAsignee option:selected").val();
			
			$("#ticketId").val(ticketId);
			$("#employee").val(asignee);
			$("#sendAssignNow").submit();
		}
	</script>
</html>