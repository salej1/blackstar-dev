<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio UPS</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="${pageContext.request.contextPath}/js/jquery.ui.touch-punch.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.signature.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.signature.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css">
	<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
	<script type="text/javascript" charset="utf-8">
	
	$(document).ready(function () {
		
		$( "#serviceDate" ).datetimepicker();
		$( "#closed" ).datetimepicker();
		
		// Signature capture box # 1 
		$('#signCapture').signature({syncField: '#signCreated'});
		$('#leftSign').signature({disabled: true}); 
		$("#signCapDialog").dialog({
			autoOpen: false,
			height: 220,
			width: 370,
			modal: true,
			buttons: {
				"Aceptar": function() {
					$('#leftSign').signature('draw', $('#signCreated').val()); 
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
		$('#signCapture2').signature({syncField: '#signReceivedBy'});
		$('#rightSign').signature({disabled: true}); 
		$("#signCapDialog2").dialog({
			autoOpen: false,
			height: 220,
			width: 370,
			modal: true,
			buttons: {
				"Aceptar": function() {
					$('#rightSign').signature('draw', $('#signReceivedBy').val()); 
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
		initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrder.serviceOrderId}");

		// Signature capture box # 1 
		$('#leftSign').signature('draw', '${serviceOrder.signCreated}'); 
		// Signature capture box # 2 
		$('#rightSign').signature('draw', '${serviceOrder.signReceivedBy}'); 
	});

	function isNumberKey(evt){
	      var charCode = (evt.which) ? evt.which : event.keyCode;
	    	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
	    	            return false;

	    	         return true;
	}
	
	</script> 
	
		 
	</head>
	<body>
		<div id="content" class="container_16 clearfix">
		<form:form  commandName="serviceOrder" action="save.do" method="POST">			
				<div class="grid_16">					
					<div class="box">
						<h2>UPS</h2>
							<table>
								<tr>
									<td>Folio:</td>
									<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="5" /></td>
									<td colspan="2"><small></small>
										
									</td>
								</tr>
								<tr>
									<td>Cliente</td>
									<td colspan="5"><form:input path="customer" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Contrato/Proyecto</td>
									<td colspan="3"><form:input path="project" type="text" style="width:95%;" readOnly="true" /></td>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="5"><form:textarea path="equipmentAddress" style="width:95%;height:50px;" readOnly="true"></form:textarea></td>
									<td>Telefono</td>
									<td><form:input type="text" path="contactPhone" style="width:95%;" readOnly="true" /></td>
								</tr>
								<tr>
									<td>Marca</td>
									<td><form:input path="brand" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Modelo</td>
									<td><form:input path="model" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Capacidad</td>
									<td><form:input path="capacity" type="text" style="width:95%;" readOnly="true" /></td>
										
								</tr>
								<tr>
									<td>NO. DE SERIE</td>
									<td><form:input path="serialNumber" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Fecha y hora de llegada</td>
									<td><form:input path="serviceDate" type="text" style="width:95%;"  /></td>
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
							<td><form:input path="estatusEquipment" type="text" style="width:95%;" /></td>
							<td>Estado de los capacitores:</td>
							<td><form:input path="capacitorStatus" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Sopleteado:</td>
							<td><form:checkbox path="cleaned"  style="width:95%;" /></td>
							<td>Verificación de fusibles y conexiones eléctricas:</td>
							<td><form:checkbox path="verifyFuzz"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Limpieza por aspirado y brocha:</td>
							<td><form:checkbox path="hooverClean"  style="width:95%;" /></td>
							<td>Revisión y verificación del rectificador/cargador:</td>
							<td><form:checkbox path="chargerReview"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Verificación de conexiones y reapriete tornillería:</td>
							<td><form:checkbox path="verifyConnections"  style="width:95%;" /></td>
							<td>Estado de ventiladores:</td>
							<td><form:input path="fanStatus" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td><b>BANCO DE BATERIAS:</b></td>
						</tr>
						<tr>
							<td>Reapriete de puentes/conectores:</td>
							<td><form:checkbox path="checkConnectors"  style="width:95%;" /></td>
							<td>Temperatura ambiente:</td>
							<td><form:input path="temp" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>Verificación de fugas/sulfataciones:</td>
							<td><form:checkbox path="cverifyOutflow"  style="width:95%;" /></td>
							<td>Pruebas de carga y descarga:</td>
							<td><form:checkbox path="chargeTest" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>No de baterías:</td>
							<td><form:input path="numberBatteries" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>Marca, modelo, capacidad:</td>
							<td><form:input path="brandModel" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Fecha o serie de fabricación:</td>
							<td><form:input path="manufacturedDateSerial" type="text" style="width:95%;" /></td>
							<td>Voltaje promedio de baterías:</td>
							<td><form:input path="batteryVoltage" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
						</tr>
						<tr>
							<td>Baterías dañadas (cant y voltaje de c/carga):</td>
							<td colspan="3"><form:input path="damageBatteries" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Otro (modelo banco externo)):</td>
							<td colspan="3"><form:input path="other" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td colspan="4"><b>PRUEBAS GENERALES: (Solicitar autorización para pruebas)</b></td>
						</tr>
						<tr>
							<td>Transferencia  y re-transferencia a línea comercial:</td>
							<td><form:checkbox path="trasferLine" style="width:95%;"/></td>
							<td>Respaldo de baterías con falla en línea:</td>
							<td><form:checkbox path="backupBatteries" style="width:95%;"/></td>
						</tr>
						<tr>
							<td>Transferencia y re-transferencia con planta de emergencia:</td>
							<td><form:checkbox path="transferEmergencyPlant" style="width:95%;" /></td>
							<td>Verificación de voltaje de baterías y de salida durante las pruebas:</td>
							<td><form:checkbox path="verifyVoltage" style="width:95%;" /></td>
						</tr>
						<tr>
							<td><b>PARÁMETROS DE OPERACIÓN:</b></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a fase:</td>
							<td><form:input path="inputVoltagePhase" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
							<td>Voltaje salida fase a fase:</td>
							<td><form:input path="outputVoltagePhase" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a neutro:</td>
							<td><form:input path="inputVoltageNeutro" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>Voltaje salida fase a neutro:</td>
							<td><form:input path="outputVoltageNeutro" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>Voltaje entre neutro y tierra:</td>
							<td><form:input path="inputVoltageNeutroGround" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>Frec. entrada/salida:</td>
							<td><form:input path="inOutFrecuency" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>Porcentaje de carga o corriente:</td>
							<td><form:input path="percentCharge" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
							<td>Frec. entrada/salida:</td>
							<td><form:input path="busVoltage" type="text" style="width:95%;"  onkeypress='return isNumberKey(event)'/></td>
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
								<form:textarea path="observations" style="width:100%;height:100%;"></form:textarea>
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
									<td>Nombre</td>
									<td><form:input path="responsible" type="text" style="width:95%;"  /></td>
									<td>Nombre</td>
									<td><form:input path="receivedBy" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td>Fecha y hora de salida</td>
									<td><form:input path="closed" type="text" style="width:95%;"  /></td>
									<td>Puesto</td>
									<td><form:input path="receivedByPosition"  style="width:95%;"  /></td>
								</tr>						
							</table>

							<table>
								<tbody>
									<tr>
										<td>
											<input class="searchButton" type="submit" value="Guardar servicio">
										</td>
									</tr>
								<tbody>
							</table>
							

					</div>
					</div>
					
					<form:hidden path="policyId"/>
					
					<!-- Signature capture box # 1 -->
					<form:hidden path="signCreated"/>
					<hidden id="rightSignJSON"/></hidden>
					<div id="signCapDialog" title="Capture su firma en el cuadro" class="signBoxDlg">
						<div id="signCapture">
						</div>
					</div>
					
					<!-- Signature capture box # 2 -->
					<form:hidden path="signReceivedBy"/>
					<hidden id="rightSignJSON2"></hidden>
					<div id="signCapDialog2" title="Capture su firma en el cuadro" class="signBoxDlg">
						<div id="signCapture2">
						</div>
					</div>
			</form:form>
							<!-- Adjuntos -->
							<c:import url="_attachments.jsp"></c:import>
							<!-- Control de secuencia y captura de seguimiento -->
							<c:import url="followUpControl.jsp"></c:import>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="addSeguimiento(${serviceOrder.serviceOrderId}, '${serviceOrder.serviceOrderNumber}');">Agregar seguimiento</button>
											<button class="searchButton" onclick="window.location = 'dashboard'">Cerrar</button>
										</td>
									</tr>
								<tbody>
							</table>	
		</div>
	</body>
</html>