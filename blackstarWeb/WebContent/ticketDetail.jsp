<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
<c:import url="header.jsp"></c:import>
<html>
<head>
	<script type="text/javascript">
		$(document).ready(function () 
		{
			$('#lbCreated').val('${ticketF.created}');
			$('#lbNombreUsuario').val('${ticketF.user}');
			$('#lbContacto').val('${policyt.contactName}');
			$('#lbTelContacto').val('${policyt.contactPhone}');
			$('#lbMailContacto').val('${policyt.contactEmail}');
			$('#lbNoSerie').val('${policyt.serialNumber}');
			$('#lbObservaciones').val('${policyt.observations}');
			$('#lbCliente').val('${policyt.customer}');
			$('#lbEquipo').val('${EquipmenttypeT.equipmentType}');
			$('#lbMarca').val('${policyt.brand}');
			$('#lbModelo').val('${policyt.model}');
			$('#lbCAP').val('${policyt.capacity}');
			$('#lbTiempoRespuesta').val('${policyt.responseTimeHR}');
			$('#lbTiempoSolucion').val('${policyt.solutionTimeHR}');
			$('#lbDireccion').val('${policyt.equipmentAddress}');
			$('#lbUbicacion').val('${policyt.equipmentLocation}');
			$('#lbIncluyePartes').val('${policyt.includesParts}');
			$('#lbExcpcionPartes').val('${policyt.exceptionParts}');
			$('#lbCentroServicio').val('${ServicecenterT.serviceCenter}');
			$('#lbOficina').val('${officeT.officeName}');
			$('#lbProyecto').val('${policyt.project}');
			$('#lbNoTicket').val('${ticketF.ticketNumber}');
			$('#lbResolvioTel').val('${ticketF.phoneResolved}');
			$('#lbHoraLLegada').val('${ticketF.arrival}');
			$('#lbDesviacion').val('${ticketF.solutionTimeDeviationHr}');
			$('#lbHoraCierre').val('${ticketF.closed}');
			$('#lbNoReporte').val('${serviceOrderT.serviceOrderNumber}');
			$('#lbIngeniero').val('${ticketF.employee}');
			$('#lbTS').val('${ticketF.solutionTime}');
			$('#lbDesviacion').val('${serviceOrderDetail.solutionTimeDeviationHr}');
			$('#lbEstatus').val('${ticketstatusT.ticketstatus}');
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
			
			$("#seguimientoCapture").hide();
			
			// Close ticket section
			$("#cerrarOSCapture").dialog({
				autoOpen: false,
				height: 180,
				width: 360,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$( this ).dialog( "close" );
						$().selectedIndex = 2;
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
			});
		});
	
		Date.prototype.format = function(format) //author: meizz
		{
		  var o = {
			"M+" : this.getMonth()+1, //month
			"d+" : this.getDate(),    //day
			"h+" : this.getHours(),   //hour
			"m+" : this.getMinutes(), //minute
			"s+" : this.getSeconds(), //second
			"q+" : Math.floor((this.getMonth()+3)/3),  //quarter
			"S" : this.getMilliseconds() //millisecond
		  }
	
		  if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
			(this.getFullYear()+"").substr(4 - RegExp.$1.length));
		  for(var k in o)if(new RegExp("("+ k +")").test(format))
			format = format.replace(RegExp.$1,
			  RegExp.$1.length==1 ? o[k] :
				("00"+ o[k]).substr((""+ o[k]).length));
		  return format;
		}
					
		// Seguimiento
		function addSeguimiento(){
			var d = new Date(); 
			$("#seguimientoCapture").show();	
			$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' ${user.userName}:');
			$("#seguimientoText").val('');
		}
		
		function applySeguimiento(from, to, text, d){
			var template = '<div class="comment"><p><strong>TIMESTAMP: " + from + " WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
			var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
			content = content.replace('MYCOMMENT', text);
			var who = to;
			if(who != ""){
				content = content.replace('WHO', " a: " + who);
			}
			else{
				content = content.replace('WHO', "");
			}
			var currSegContent = $("#seguimientoContent").html();
			currSegContent = currSegContent + content;
			$("#seguimientoContent").html(currSegContent);
			$("#seguimientoCapture").hide();
		}
		
		function cancelAddSeguimiento(){
			$("#seguimientoCapture").hide();
		}

	</script>
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
										<select id="selectStatus"  style="width:78%;">
											<c:forEach var="employee" items="${employees}">
												<option value="${employee.key}"
												<c:if test="${ employee.key == ticketF.asignee }">
													selected = "true"
												</c:if>
												>${ employee.value }</option>
											</c:forEach>
										</select>
										<button class="searchButton" onclick="window.location = 'dashboard_coo.html'">Asignar ahora</button>
									</td>
								</tr>
								<tr><td>Marca temporal</td><td><input id="lbCreated" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Nombre de usuario</td><td><input id="lbNombreUsuario" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Contacto</td><td><input type="text" id="lbContacto" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Telefóno de Contacto</td><td><input id="lbTelContacto" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>E-mail</td><td><input type="text" id="lbMailContacto" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Número de serie del Equipo</td><td><input id="lbNoSerie" type="text" readonly="true"  style="width:95%;"/></td></tr>
								<tr><td>Observaciones</td><td><input type="text" id="lbObservaciones" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Cliente</td><td><input type="text" id="lbCliente" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Equipo</td><td><input type="text" id="lbEquipo"  readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Marca</td><td><input type="text" id="lbMarca" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Modelo</td><td><input type="text" id="lbModelo" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Capacidad</td><td><input type="text" id="lbCAP" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Tiempo de Respuesta Comprometido</td><td><input id="lbTiempoRespuesta" type="text" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Tiempo de Solucion</td><td><input type="text" id="lbTiempoSolucion" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Direccion del Equipo</td><td><input type="text" id="lbDireccion" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Ubicación del Equipo</td><td><input type="text" id="lbUbicacion" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Incluye Partes</td><td><input type="text" id="lbIncluyePartes" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Excepción de Partes</td><td><input type="text" id="lbExcpcionPartes" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Centro de Servicio</td><td><input type="text" id="lbCentroServicio" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Oficina</td><td><input type="text" readonly="true" id="lbOficina" style="width:95%;" /></td></tr>
								<tr><td>Proyecto</td><td><input type="text" readonly="true" id="lbProyecto" style="width:95%;" /></td></tr>
								<tr><td>Ticket</td><td><input type="text" readonly="true" id="lbNoTicket" style="width:95%;" /></td></tr>
								<tr><td>Se pudo resolver via telefónica</td><td><input type="text" id="lbResolvioTel" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Hora y Fecha de Llegada a Sitio</td><td><input type="text" id="lbHoraLLegada" readonly="true"  style="width:95%;" /></td></tr>
								<tr><td>Desviación TR</td><td><input type="text" readonly="true"  id="lbDesviacion" style="width:95%;" /></td></tr>
								<tr><td>Fecha y Hora de Cierre</td><td><input type="text" readonly="true" id="lbHoraCierre"  style="width:95%;" /></td></tr>
								<tr><td>Numero de Reporte de Servicio</td><td><input type="text" readonly="true" id="lbNoReporte" style="width:95%;"/></td></tr>
								<tr><td>Ingeniero que atendió</td><td><input type="text" readonly="true" id="lbIngeniero" style="width:95%;" /></td></tr>
								<tr><td>T S Brindado en HR</td><td><input type="text" readonly="true" id="lbTS"  style="width:95%;" /></td></tr>
								<tr><td>Desviación en Horas TS</td><td><input type="text" readonly="true" id="lbDesviacion" style="width:95%;" /></td></tr>
								<tr><td>Estatus</td><td><input id="lbEstatus" type="text" style="width:95%;" readonly="true"/>
								</td>
								</tr>
							</tbody>
						</table>
						<table id="seguimientoTable">
								<thead>
									<th>Seguimiento</th>
								</thead>
									<tr>
										<td id="seguimientoContent">
										</td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label>
											</div>
											<div> Asignar a:
												<select id="seguimientoWho" style="width:200px;">
													<c:forEach var="employee" items="${employees}">
														<option value="${employee.key}">${ employee.value }</option>
													</c:forEach>
												</select>
												<p></p>
												<textarea id="seguimientoText" rows="5" style="width:65%;"></textarea>
												<button class="searchButton" onclick="applySeguimiento();">Agregar</button>
												<button class="searchButton" onclick="cancelAddSeguimiento();">Cancelar</button>
											</div>
										</td>
									</tr>
							</table>
						<table>
								<tbody>
									<tr>
										<td>
											<p></p>
											<button class="searchButton" onclick="addSeguimiento();">Agregar seguimiento</button>
											<button class="searchButton" onclick="$('#cerrarOSCapture').dialog('open')">Cerrar Ticket</button>
										</td>
									</tr>
								<tbody>
							</table>
					</div>					
				</div>
				
			<div id="cerrarOSCapture" title="Cerrar Ticket ${ticketF.ticketNumber}">
				<p>Por favor seleccione la OS que cierra el ticket:</p>
				<select style="width:90%">
					<c:forEach var="os" items="${ potentialOs }">
						<option value="${ os.key }">${ os.value }</option>
					</c:forEach>
				</select>
			</div>
</div>
</body>
</html>