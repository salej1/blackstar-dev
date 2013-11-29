<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio planta de emergencia</title>
	
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
	});

	function isNumberKey(evt){


	      var charCode = (evt.which) ? evt.which : event.keyCode
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
							<tr >
								<th  colspan="6">DATOS DEL EQUIPO</th>
							</tr>
						</thead>
						<tr>
							<td>PE MARCA:</td>
							<td><input id="brandPE" type="text" style="width:95%;" /></td>
							<td>MOTOR DIESEL MARCA:</td>
							<td><input id="brandMotor" type="text" style="width:95%;" /></td>
							<td>CAPACIDAD TANQUE DIESEL:</td>
							<td><input id="tankCapacity" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MODELO PE:</td>
							<td><input id="modelPE" type="text" style="width:95%;" /></td>
							<td>MODELO MOTOR:</td>
							<td><input id="modelMotor" type="text" style="width:95%;" /></td>
							<td>MODELO BOMBA COMBUSTIBLE:</td>
							<td><input id="pumpFuelModel" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>No SERIE PE:</td>
							<td><input id="serialPE" type="text" style="width:95%;" /></td>
							<td>No. DE SERIE MOTOR:</td>
							<td><input id="serialMotor" type="text" style="width:95%;" /></td>
							<td>FILTRO DE COMBUSTIBLE. SE CAMBIÓ?:</td>
							<td><input id="filterFuelFlag" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>TIPO DE TRANSFERENCIA:</td>
							<td><input id="transferType" type="text" style="width:95%;" /></td>
							<td>CPL MOTOR:</td>
							<td><input id="cplMotor" type="text" style="width:95%;" /></td>
							<td>FILTRO DE ACEITE. SE CAMBIÓ?</td>
							<td><input id="filterOilFlag" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO TRANSF:</td>
							<td><input id="modelTransfer" type="text" style="width:95%;" /></td>
							<td>GENERADOR MCA:</td>
							<td><input id="brandGenerator" type="text" style="width:95%;" /></td>
							<td>FILTRO DE AGUA. SE CAMBIÓ?:</td>
							<td><input id="filterWaterFlag" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO CONTROL:</td>
							<td><input id="modelControl" type="text" style="width:95%;" /></td>
							<td>MODELO GENERADOR:</td>
							<td><input id="modelGenerator" type="text" style="width:95%;" /></td>
							<td>FILTRO DE AIRE. SE CAMBIÓ?:</td>
							<td><input id="filterAirFlag" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VOLTAJE:</td>
							<td><input id="modelRegVoltage" type="text" style="width:95%;" /></td>
							<td>No DE SERIE GENERADOR:</td>
							<td><input id="serialGenerator" type="text" style="width:95%;" /></td>
							<td>MODELO DE LA MARCHA:</td>
							<td><input id="brandGear" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VELOCIDAD:</td>
							<td><input id="modelRegVelocity" type="text" style="width:95%;" /></td>
							<td>POTENCIA (KW) GENERADOR:</td>
							<td><input id="powerWattGenerator" type="text" style="width:95%;" /></td>
							<td>MODELO DE BATERÍAS:</td>
							<td><input id="brandBattery" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO CARGADOR DE BAT:</td>
							<td><input id="modelCharger" type="text" style="width:95%;" /></td>
							<td>TENSIÓN GENERADOR:</td>
							<td><input id="tensionGenerator" type="text" style="width:95%;" /></td>
							<td>LECTURA RELOJ CUENTA HORAS:</td>
							<td><input id="clockLecture" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>ULTIMO CAMBIO DE ACEITE:</td>
							<td><input id="oilChange" type="text" style="width:95%;" /></td>
							<td>ULTIMA FECHA DE AFINACIÓN:</td>
							<td><input id="tuningDate" type="text" style="width:95%;" /></td>
							<td>ULTIMO SERVICIO CORRECTIVO:</td>
							<td><input id="serviceCorrective" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr>
								<th  colspan="6">INSPECCION BASICA</th>
							</tr>
						</thead>
						<tr>
							<td>NIVEL/LIMP/CAMBIO DE ACEITE LUBRICANTE. SE CAMBIÓ?</td>
							<td><input id="levelOilFlag" type="text" style="width:95%;" /></td>
							<td>ZAPATAS DE BATERÍA:</td>
							<td><input id="batteryCap" type="text" style="width:95%;" /></td>
							<td>MANGUERAS COMBUSTIBLE:</td>
							<td><input id="hoseOil" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>NIVEL DE AGUA/ANTICONGELANTE. SE CAMBIÓ?:</td>
							<td><input id="levelWaterFlag" type="text" style="width:95%;" /></td>
							<td>SULFATACIÓN BATERÍA:</td>
							<td><input id="batterySulfate" type="text" style="width:95%;" /></td>
							<td>MANGUERAS AGUA:</td>
							<td><input id="hoseWater" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>NIVEL ELECTROLITO BATERÍA:</td>
							<td><input id="levelBattery" type="text" style="width:95%;" /></td>
							<td>NIVEL DE COMBUSTIBLE %:</td>
							<td><input id="levelOil" type="text" style="width:95%;" /></td>
							<td>VÁLVULAS Y TUBERÍAS (CU/NEGRA):</td>
							<td><input id="tubeValve" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>FUGA EN TUBO DE ESCAPE:</td>
							<td><input id="tubeLeak" type="text" style="width:95%;" /></td>
							<td>PRECALENTADO DE LA MÁQUINA. TEMPERATURA (MIN 60°):</td>
							<td><input id="heatEngine" type="text" style="width:95%;" /></td>
							<td>TENSIÓN DE BANDAS/ESTADO DE ASPAS:</td>
							<td><input id="stripBlades" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr >
								<th  colspan="6">SERVICIOS BÁSICOS</th>
							</tr>
						</thead>
						<tr>
							<td>LAVADO DE MOTOR/TANQUE (FUGA):</td>
							<td><input id="washEngine" type="text" style="width:95%;" /></td>
							<td>SOPLETEADO DE TRANSFER:</td>
							<td><input id="cleanTransfer" type="text" style="width:95%;" /></td>
							<td>PRUEBAS DE BATERÍAS:</td>
							<td><input id="batteryTests" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>LAVADO DE RADIADOR:</td>
							<td><input id="washRadiator" type="text" style="width:95%;" /></td>
							<td>LIMPIEZA TARJETAS DE CONTROL:</td>
							<td><input id="cleanCardControl" type="text" style="width:95%;" /></td>
							<td>REVISIÓN CARGADOR DE BATERÍA/ALTERNADOR:</td>
							<td><input id="checkCharger" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>LIMPIEZA ÁREA DE TRABAJO:</td>
							<td><input id="cleanWorkArea" type="text" style="width:95%;" /></td>
							<td>AJUSTE DE CONEXIONES DE CONTROL:</td>
							<td><input id="checkConectionControl" type="text" style="width:95%;" /></td>
							<td>PINTURA Y CONSERVACIÓN:</td>
							<td><input id="checkPaint" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>REVISIÓN DE CABLEADO  Y CONEXIONES:</td>
							<td><input id="conectionCheck" type="text" style="width:95%;" /></td>
							<td>REVISIÓN DE EXT/EMBOBINADOS:</td>
							<td><input id="checkWinding" type="text" style="width:95%;" /></td>
							<td>SOPLETEADO TAB GENERADOR:</td>
							<td><input id="cleanGenerator" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr >
								<th  colspan="6">PRUEBAS DINAMICAS MOTOR DE COMBUSTION (Solicitar autorización para pruebas con carga)</th>
							</tr>
						</thead>
						<tr>
							<td>FRECUENCIA EN VACÍO:</td>
							<td><input id="vacuumFrequency" type="text" style="width:95%;" /></td>
							<td>VOLTAJE EN VACÍO:</td>
							<td><input id="vacuumVoltage" type="text" style="width:95%;" /></td>
							<td>TIEMPO DE ARRANQUE:</td>
							<td><input id="startTime" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>FRECUENCIA EN CARGA:</td>
							<td><input id="chargeFrequency" type="text" style="width:95%;" /></td>
							<td>VOLTAJE EN CARGA:</td>
							<td><input id="chargeVoltage" type="text" style="width:95%;" /></td>
							<td>TIEMPO DE TRANSFERENCIA:</td>
							<td><input id="transferTime" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>NUM. DE INTENTOS DE ARRANQUE:</td>
							<td><input id="bootTryouts" type="text" style="width:95%;" /></td>
							<td>CALIDAD DE EMISIONES DE HUMO:</td>
							<td><input id="qualitySmoke" type="text" style="width:95%;" /></td>
							<td>TIEMPO DE PARO:</td>
							<td><input id="stopTime" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr >
								<th colspan="6">PRUEBAS PROTECCIÓN DEL EQUIPO</th>
							</tr>
						</thead>
						<tr>
							<td>SENSOR DE TEMPERATURA:</td>
							<td><input id="tempSensor" type="text" style="width:95%;" /></td>
							<td>SENSOR DE VOLTAJE O GENERACIÓN:</td>
							<td><input id="voltageSensor" type="text" style="width:95%;" /></td>
							<td>SENSOR BAJA PRESIÓN DE ACEITE:</td>
							<td><input id="oilPreasureSensor" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>SENSOR DE PRESIÓN DEL ACEITE:</td>
							<td><input id="oilSensor" type="text" style="width:95%;" /></td>
							<td>SENSOR DE SOBRE-VELOCIDAD:</td>
							<td><input id="overSpeedSensor" type="text" style="width:95%;" /></td>
							<td>SENSOR DE NIVEL DE AGUA:</td>
							<td><input id="waterLevelSensor" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr >
								<th colspan="6">INTERRUPTOR DE TRANSFERENCIA AUTOMATICO</th>
							</tr>
						</thead>
						<tr>
							<td>ESTADO MECÁNICA:</td>
							<td><input id="mechanicalStatus" type="text" style="width:95%;" /></td>
							<td>AJUSTE DE TORNILLERÍA:</td>
							<td><input id="screwAdjust" type="text" style="width:95%;" /></td>
							<td>INTERLOCK ELÉCTRICO:</td>
							<td><input id="electricInterlock" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>LIMPIEZA DEL TABLERO:</td>
							<td><input id="boardClean" type="text" style="width:95%;" /></td>
							<td>AJUSTE DE CONEXIONES:</td>
							<td><input id="conectionAdjust" type="text" style="width:95%;" /></td>
							<td>INTERLOCK MECÁNICO:</td>
							<td><input id="mechanicalInterlock" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>PRUEBA DE LÁMPARAS:</td>
							<td><input id="lampTest" type="text" style="width:95%;" /></td>
							<td>MOTORES DEL SISTEMA:</td>
							<td><input id="systemMotors" type="text" style="width:95%;" /></td>
							<td>CAPACIDAD EN AMPERES:</td>
							<td><input id="capacityAmp" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr >
								<th colspan="6">LECTURAS DEL SISTEMA (CON CARGA/SIN CARGA)</th>
							</tr>
						</thead>
						<tr>
							<td>VOLTAJE AB/AN:</td>
							<td><input id="voltageABAN" type="text" style="width:95%;" /></td>
							<td>CORRIENTE A(AMP):</td>
							<td><input id="currentA" type="text" style="width:95%;" /></td>
							<td>FRECUENCIA:</td>
							<td><input id="frequency" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>VOLTAJE AC/CN:</td>
							<td><input id="voltageACCN" type="text" style="width:95%;" /></td>
							<td>CORRIENTE B(AMP):</td>
							<td><input id="currentB" type="text" style="width:95%;" /></td>
							<td>PRESIÓN DE ACEITE:</td>
							<td><input id="oilPreassure" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>VOLTAJE BC/BN:</td>
							<td><input id="voltageBCBN" type="text" style="width:95%;" /></td>
							<td>CORRIENTE C (AMP):</td>
							<td><input id="currentC" type="text" style="width:95%;" /></td>
							<td>TEMPERATURA:</td>
							<td><input id="temp" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>VOLTAJE NT:</td>
							<td><input id=voltageNT type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr >
								<th colspan="6">OTROS PARAMETROS</th>
							</tr>
						</thead>
						<tr>
							<td>AJUSTE DEL TERMOSTATO:</td>
							<td><input id="adjsutmentTherm" type="text" style="width:95%;" /></td>
							<td>VOLTAJE FLOTACIÓN BATERÍAS:</td>
							<td><input id="batteryCurrent" type="text" style="width:95%;" /></td>
							<td>TIPO DE PROTECCIÓN TRANSFER:</td>
							<td><input id="trasnferTypeProtection" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>CORRIENTE PRECALENTADOR:</td>
							<td><input id="current" type="text" style="width:95%;" /></td>
							<td>ESTADO RELOJ CUENTAS HORAS:</td>
							<td><input id="clockStatus" type="text" style="width:95%;" /></td>
							<td>TIPO DE PROTECCIÓN GENERADOR:</td>
							<td><input id="generatorTypeProtection" type="text" style="width:95%;" /></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr >
								<th>Observaciones (HISTORIAL DE ALARMAS CUANDO APLIQUE)</th>
							</tr>
						</thead>
						<tr>
							<td style="height:140px;">
								<textarea id="observations"   style="width:100%;height:99%;"></textarea>
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