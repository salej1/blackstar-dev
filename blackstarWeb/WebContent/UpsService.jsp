<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio UPS</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="js/jquery.ui.touch-punch.min.js"></script>
	<script src="js/jquery.signature.min.js"></script>
	<link rel="stylesheet" href="css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="css/jquery.ui.theme.css">
	<link rel="stylesheet" href="css/jquery-ui.min.css">
	<link rel="stylesheet" href="css/jquery.signature.css">
	<script type="text/javascript" charset="utf-8">
	
		$(document).ready(function () {

			// Signature capture box # 1 
			$('#signCapture').signature({syncField: '#leftSignJSON'});
			$('#leftSign').signature({disabled: true}); 
			$("#signCapDialog").dialog({
				autoOpen: false,
				height: 220,
				width: 370,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$('#leftSign').signature('draw', $('#leftSignJSON').val()); 
						$( this ).dialog( "close" );
					},
					
					"Borrar": function() {
						$('#signCapture').signature('clear'); 
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
			});
			
			// Signature capture box # 2 
			$('#signCapture2').signature({syncField: '#leftSignJSON2'});
			$('#rightSign').signature({disabled: true}); 
			$("#signCapDialog2").dialog({
				autoOpen: false,
				height: 220,
				width: 370,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$('#rightSign').signature('draw', $('#leftSignJSON2').val()); 
						$( this ).dialog( "close" );
					},
					
					"Borrar": function() {
						$('#signCapture2').signature('clear'); 
					},
					
					"Cancelar": function() {
					$( this ).dialog( "close" );
				}}
			});

			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrderDetail.serviceOrderId}");

			$('#lbFolio').val('${serviceOrderDetail.serviceOrderNo}');
			$('#lbCliente').val('${serviceOrderDetail.customer}');
			$('#lbDomicilio').val('${serviceOrderDetail.equipmentAddress}');
			$('#fechaLlegada').val('${serviceOrderDetail.serviceDate}');
			$('#lbTelefono').val('${serviceOrderDetail.contactPhone}');
			$('#lbEquipo').val('${serviceOrderDetail.equipmentType}');
			$('#lbMarca').val('${serviceOrderDetail.equipmentBrand}');
			$('#lbModelo').val('${serviceOrderDetail.equipmentModel}');
			$('#lbSerie').val('${serviceOrderDetail.equipmentSerialNo}');
			$('#lbProyecto').val('${serviceOrderDetail.proyectNumber}');
			$('#lbNombreRecibido').val('${serviceOrderDetail.receivedBy}');
			$('#lbNombreRealizado').val('${serviceOrderDetail.responsible}');
			$('#lbFechaSalida').val('${serviceOrderDetail.closed}');
			$('#lblPuesto').val('${serviceOrderDetail.receivedByPosition}');

			// Signature capture box # 1 
			$('#leftSign').signature({disabled: true}); 
			$('#leftSign').signature('draw', '${serviceOrderDetail.signCreated}'); 

			// Signature capture box # 2 
			$('#rightSign').signature({disabled: true}); 
			$('#rightSign').signature('draw', '${serviceOrderDetail.signReceivedBy}'); 

			 $('#estatusEquipment').val('${serviceOrder.estatusEquipment}');
			 $('#cleaned').val('${serviceOrder.cleaned}');
			 $('#hooverClean').val('${serviceOrder.hooverClean}');
			 $('#verifyConnections').val('${serviceOrder.verifyConnections}');
			 $('#capacitorStatus').val('${serviceOrder.capacitorStatus}');
			 $('#verifyFuzz').val('${serviceOrder.verifyFuzz}');
			 $('#chargerReview').val('${serviceOrder.chargerReview}');
			 $('#fanStatus').val('${serviceOrder.fanStatus}');
			 $('#observations').val('${serviceOrder.observations}');

			 $('#upsServiceBatteryBankId').val('${serviceOrder.upsServiceBatteryBankId}');
			 $('#upsServiceId').val('${serviceOrder.upsServiceId}');
			 $('#checkConnectors').val('${serviceOrder.checkConnectors}');
			 $('#cverifyOutflow').val('${serviceOrder.cverifyOutflow}');
			 $('#numberBatteries').val('${serviceOrder.numberBatteries}');
			 $('#manufacturedDateSerial').val('${serviceOrder.manufacturedDateSerial}');
			 $('#damageBatteries').val('${serviceOrder.damageBatteries}');
			 $('#other').val('${serviceOrder.other}');
			 $('#temp').val('${serviceOrder.temp}');
			 $('#chargeTest').val('${serviceOrder.chargeTest}');
			 $('#brandModel').val('${serviceOrder.brandModel}');
			 $('#batteryVoltage').val('${serviceOrder.batteryVoltage}');

			 $('#upsServiceGeneralTestId').val('${serviceOrder.upsServiceGeneralTestId}');
			 $('#upsServiceId').val('${serviceOrder.upsServiceId}');
			 $('#trasferLine').val('${serviceOrder.trasferLine}');
			 $('#transferEmergencyPlant').val('${serviceOrder.transferEmergencyPlant}');
			 $('#backupBatteries').val('${serviceOrder.backupBatteries}');
			 $('#verifyVoltage').val('${serviceOrder.verifyVoltage}');

			 $('#upsServiceParamsId').val('${serviceOrder.upsServiceParamsId}');
			 $('#upsServiceId').val('${serviceOrder.upsServiceId}');
			 $('#inputVoltagePhase').val('${serviceOrder.inputVoltagePhase}');
			 $('#inputVoltageNeutro').val('${serviceOrder.inputVoltageNeutro}');
			 $('#inputVoltageNeutroGround').val('${serviceOrder.inputVoltageNeutroGround}');
			 $('#percentCharge').val('${serviceOrder.percentCharge}');
			 $('#outputVoltagePhase').val('${serviceOrder.outputVoltagePhase}');
			 $('#outputVoltageNeutro').val('${serviceOrder.outputVoltageNeutro}');
			 $('#inOutFrecuency').val('${serviceOrder.inOutFrecuency}');
			 $('#busVoltage').val('${serviceOrder.busVoltage}');
						
		});
	
	</script> 
	
		 
	</head>
	<body>
	<form id = "formServicio" action="/crear" method="POST">
		<div id="content" class="container_16 clearfix">
			<div class="grid_16">					
				<div class="box">
					<h2>Órden de servicio</h2>
						<c:if test="${serviceOrderDetail.ticketId gt 0}">
							<div class="utils">
									<a id="linkTicket" href="ticketDetail?ticketId=${serviceOrderDetail.ticketId}"> </a>
							</div>
						</c:if>
					<table>
						<tr>
							<td>Folio:</td>
							<td><input  id="lbFolio" type="text" style="width:95%;" readOnly="true" /></td>
							<td colspan="2"><small></small>
								
							</td>
						</tr>
						<tr>
							<td>Cliente</td>
							<td colspan="5"><input id="lbCliente" type="text" style="width:95%;" readOnly="true" /></td>
							<td>No Ticket</td>
							<td><input  id="lbNoTicket" type="text" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>Domicilio</td>
							<td colspan="5"><textarea  id="lbDomicilio" style="width:95%;height:50px;"></textarea></td>
							<td>Telefono</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>Marca</td>
							<td colspan="5"><textarea  id="lbDomicilio" style="width:95%;height:50px;"></textarea></td>
							<td>Modelo</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
							<td>Capacidad</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>No. de serie</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Fecha y hora de llegada</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
				</div>					
			</div>
			<div class="grid_16">
				<div class="box">
					<table>
						<thead>
							<tr>
								<th colspan="4">ACTIVIDADES DESAROOLLADAS:</th>
							</tr>
						</thead>
						<tr>
							<td>Estado del equipo encontrado:</td>
							<td><input id="estatusEquipment" type="text" style="width:95%;" /></td>
							<td>Estado de los capacitores:</td>
							<td><input id="capacitorStatus" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Sopleteado:</td>
							<td><input id="cleaned" type="text" style="width:95%;" /></td>
							<td>Verificación de fusibles y conexiones eléctricas:</td>
							<td><input id="verifyFuzz" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Limpieza por aspirado y brocha:</td>
							<td><input id="hooverClean" type="text" style="width:95%;" /></td>
							<td>Revisión y verificación del rectificador/cargador:</td>
							<td><input id="chargerReview" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Verificación de conexiones y reapriete tornillería:</td>
							<td><input id="verifyConnections" type="text" style="width:95%;" /></td>
							<td>Estado de ventiladores:</td>
							<td><input id="fanStatus" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td><b>BANCO DE BATERIAS:</b></td>
						</tr>
						<tr>
							<td>Reapriete de puentes/conectores:</td>
							<td><input id="checkConnectors" type="text" style="width:95%;" /></td>
							<td>Temperatura ambiente:</td>
							<td><input id="temp" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Verificación de fugas/sulfataciones:</td>
							<td><input id="cverifyOutflow" type="text" style="width:95%;" /></td>
							<td>Pruebas de carga y descarga:</td>
							<td><input id="chargeTest" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>No de baterías:</td>
							<td><input id="numberBatteries" type="text" style="width:95%;" /></td>
							<td>Marca, modelo, capacidad:</td>
							<td><input id="brandModel" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Fecha o serie de fabricación:</td>
							<td><input id="manufacturedDateSerial" type="text" style="width:95%;" /></td>
							<td>Voltaje promedio de baterías:</td>
							<td><input id="batteryVoltage" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Baterías dañadas (cant y voltaje de c/carga):</td>
							<td colspan="3"><input id="damageBatteries" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Otro (modelo banco externo)):</td>
							<td colspan="3"><input id="other" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td colspan="4"><b>PRUEBAS GENERALES: (Solicitar autorización para pruebas)</b></td>
						</tr>
						<tr>
							<td>Transferencia  y re-transferencia a línea comercial:</td>
							<td><input id="trasferLine" type="text" style="width:95%;" /></td>
							<td>Respaldo de baterías con falla en línea:</td>
							<td><input id="backupBatteries" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Transferencia y re-transferencia con planta de emergencia:</td>
							<td><input id="transferEmergencyPlant" type="text" style="width:95%;" /></td>
							<td>Verificación de voltaje de baterías y de salida durante las pruebas:</td>
							<td><input id="verifyVoltage" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td><b>PARÁMETROS DE OPERACIÓN:</b></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a fase:</td>
							<td><input id="inputVoltagePhase" type="text" style="width:95%;" /></td>
							<td>Voltaje salida fase a fase:</td>
							<td><input id="outputVoltagePhase" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a neutro:</td>
							<td><input id="inputVoltageNeutro" type="text" style="width:95%;" /></td>
							<td>Voltaje salida fase a neutro:</td>
							<td><input id="outputVoltageNeutro" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Voltaje entre neutro y tierra:</td>
							<td><input id="inputVoltageNeutroGround" type="text" style="width:95%;" /></td>
							<td>Frec. entrada/salida:</td>
							<td><input id="inOutFrecuency" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Porcentaje de carga o corriente:</td>
							<td><input id="percentCharge" type="text" style="width:95%;" /></td>
							<td>Frec. entrada/salida:</td>
							<td><input id="busVoltage" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>COMENTARIOS</th>
							</tr>
						</thead>
						<tr>
							<td>Anotar comentarios del usuario. Anotar alarmas inusuales. Indicar condiciones del lugar y estado final del equipo. Otras observaciones.</td>
						</tr>
						<tr>
							<td style="height:140px;">
								<textarea id="fldObserv"  readOnly="true" style="width:100%;height:100%;"></textarea>
							</td>
						</tr>
						
					</table>
					<table>
						<thead>
							<tr>
								<th colspan="2">Realizado Por</th>
								<th colspan="2">Servicio y/o equipo recibido a mi entera satisfaccion</th>
							</tr>
						</thead>
						<tr>
							<td colspan="2">
								<span>Firma</span>
								<div id="leftSign" class="signBox" onclick="$('#signCapDialog').dialog('open');">
								</div>
							</td>
							<td colspan="2" >
								<span>Firma</span>
								<div id="rightSign" class="signBox" onclick="$('#signCapDialog2').dialog('open');">
								</div>
							</td>
						</tr>
						<tr>
							<td>Nombre</td><td><input id="lbNombreRealizado" type="text" style="width:95%;"  /></td>
							<td>Nombre</td><td><input id="lbNombreRecibido" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Fecha y hora de salida</td>
							<td><input id="lbFechaSalida" type="text" style="width:95%;"  /></td>
							<td>Puesto</td>
							<td><input type="text" id="lblPuesto" style="width:95%;"  /></td>
						</tr>						
					</table>
					<table>
						<tbody>
							<tr>
								<td>
									<button class="searchButton" >Guardar servicio</button>
									<button class="searchButton" onclick="window.location = 'dashboard'">Cerrar</button>
								</td>
							</tr>
						<tbody>
					</table>
					<br/>
					<br/>
					<!-- Control de secuencia y captura de seguimiento -->
					<c:import url="followUpControl.jsp"></c:import>
					<table>
						<tbody>
							<tr>
								<td>
									<button class="searchButton" onclick="addSeguimiento(${serviceOrderDetail.serviceOrderId}, '${serviceOrderDetail.serviceOrderNo}');">Agregar seguimiento</button>
									<button class="searchButton" onclick="window.location = 'dashboard'">Cerrar</button>
								</td>
							</tr>
						<tbody>
					</table>
					
					<!-- Adjuntos -->
					<c:import url="_attachments.jsp"></c:import>
				</div>					
			</div>		
			
				<!-- Signature capture box # 1 -->
				<hidden id="leftSignJSON"></hidden>
				<hidden id="rightSignJSON"></hidden>
				<div id="signCapDialog" title="Capture su firma en el cuadro" class="signBoxDlg">
					<div id="signCapture">
					
					</div>
				</div>
				
				<!-- Signature capture box # 2 -->
				<hidden id="leftSignJSON2"></hidden>
				<hidden id="rightSignJSON2"></hidden>
				<div id="signCapDialog2" title="Capture su firma en el cuadro" class="signBoxDlg">
					<div id="signCapture2">
					
					</div>
				</div>
		</div>
		</form>
	</body>
</html>