<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio planta de emergencia</title>
	
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
		
			$('#lbFolio').val('${serviceOrderDetail.serviceOrderNo}');
			$('#lbCliente').val('${serviceOrderDetail.customer}');
			$('#lbDomicilio').val('${serviceOrderDetail.equipmentAddress}');
			$('#fechaLlegada').val('${serviceOrderDetail.serviceDate}');
			$('#lbTelefono').val('${serviceOrderDetail.contactPhone}');
			$('#lbEquipo').val('${serviceOrderDetail.equipmentType}');
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

			 $('#brandPE').val('${serviceOrder.brandPE}');
			 $('#modelPE').val('${serviceOrder.modelPE}');
			 $('#serialPE').val('${serviceOrder.serialPE}');
			 $('#transferType').val('${serviceOrder.transferType}');
			 $('#modelTransfer').val('${serviceOrder.modelTransfer}');
			 $('#modelControl').val('${serviceOrder.modelControl}');
			 $('#modelRegVoltage').val('${serviceOrder.modelRegVoltage}');
			 $('#modelRegVelocity').val('${serviceOrder.modelRegVelocity}');
			 $('#modelCharger').val('${serviceOrder.modelCharger}');
			 $('#oilChange').val('${serviceOrder.oilChange}');
			 $('#brandMotor').val('${serviceOrder.brandMotor}');
			 $('#modelMotor').val('${serviceOrder.modelMotor}');
			 $('#serialMotor').val('${serviceOrder.serialMotor}');
			 $('#cplMotor').val('${serviceOrder.cplMotor}');
			 $('#brandGenerator').val('${serviceOrder.brandGenerator}');
			 $('#modelGenerator').val('${serviceOrder.modelGenerator}');
			 $('#serialGenerator').val('${serviceOrder.serialGenerator}');
			 $('#powerWattGenerator').val('${serviceOrder.powerWattGenerator}');
			 $('#tensionGenerator').val('${serviceOrder.tensionGenerator}');
			 $('#tuningDate').val('${serviceOrder.tuningDate}');
			 $('#tankCapacity').val('${serviceOrder.tankCapacity}');
			 $('#pumpFuelModel').val('${serviceOrder.pumpFuelModel}');
			 $('#filterFuelFlag').val('${serviceOrder.filterFuelFlag}');
			 $('#filterOilFlag').val('${serviceOrder.filterOilFlag}');
			 $('#filterWaterFlag').val('${serviceOrder.filterWaterFlag}');
			 $('#filterAirFlag').val('${serviceOrder.filterAirFlag}');
			 $('#brandGear').val('${serviceOrder.brandGear}');
			 $('#brandBattery').val('${serviceOrder.brandBattery}');
			 $('#clockLecture').val('${serviceOrder.clockLecture}');
			 $('#serviceCorrective').val('${serviceOrder.serviceCorrective}');
			 $('#observations').val('${serviceOrder.observations}');

			 $('#epServiceSurveyId').val('${serviceOrder.epServiceSurveyId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#levelOilFlag').val('${serviceOrder.levelOilFlag}');
			 $('#levelWaterFlag').val('${serviceOrder.levelWaterFlag}');
			 $('#levelBattery').val('${serviceOrder.levelBattery}');
			 $('#tubeLeak').val('${serviceOrder.tubeLeak}');
			 $('#batteryCap').val('${serviceOrder.batteryCap}');
			 $('#batterySulfate').val('${serviceOrder.batterySulfate}');
			 $('#levelOil').val('${serviceOrder.levelOil}');
			 $('#heatEngine').val('${serviceOrder.heatEngine}');
			 $('#hoseOil').val('${serviceOrder.hoseOil}');
			 $('#hoseWater').val('${serviceOrder.hoseWater}');
			 $('#tubeValve').val('${serviceOrder.tubeValve}');
			 $('#stripBlades').val('${serviceOrder.stripBlades}');

			 $('#epServiceWorkBasicId').val('${serviceOrder.epServiceWorkBasicId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#washEngine').val('${serviceOrder.washEngine}');
			 $('#washRadiator').val('${serviceOrder.washRadiator}');
			 $('#cleanWorkArea').val('${serviceOrder.cleanWorkArea}');
			 $('#conectionCheck').val('${serviceOrder.conectionCheck}');
			 $('#cleanTransfer').val('${serviceOrder.cleanTransfer}');
			 $('#cleanCardControl').val('${serviceOrder.cleanCardControl}');
			 $('#checkConectionControl').val('${serviceOrder.checkConectionControl}');
			 $('#checkWinding').val('${serviceOrder.checkWinding}');
			 $('#batteryTests').val('${serviceOrder.batteryTests}');
			 $('#checkCharger').val('${serviceOrder.checkCharger}');
			 $('#checkPaint').val('${serviceOrder.checkPaint}');
			 $('#cleanGenerator').val('${serviceOrder.cleanGenerator}');

			 $('#epServiceDynamicTestId').val('${serviceOrder.epServiceDynamicTestId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#vacuumFrequency').val('${serviceOrder.vacuumFrequency}');
			 $('#chargeFrequency').val('${serviceOrder.chargeFrequency}');
			 $('#bootTryouts').val('${serviceOrder.bootTryouts}');
			 $('#vacuumVoltage').val('${serviceOrder.vacuumVoltage}');
			 $('#chargeVoltage').val('${serviceOrder.chargeVoltage}');
			 $('#qualitySmoke').val('${serviceOrder.qualitySmoke}');
			 $('#startTime').val('${serviceOrder.startTime}');
			 $('#transferTime').val('${serviceOrder.transferTime}');
			 $('#stopTime').val('${serviceOrder.stopTime}');

			 $('#epServiceTestProtectionId').val('${serviceOrder.epServiceTestProtectionId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#tempSensor').val('${serviceOrder.tempSensor}');
			 $('#oilSensor').val('${serviceOrder.oilSensor}');
			 $('#voltageSensor').val('${serviceOrder.voltageSensor}');
			 $('#overSpeedSensor').val('${serviceOrder.overSpeedSensor}');
			 $('#oilPreasureSensor').val('${serviceOrder.oilPreasureSensor}');
			 $('#waterLevelSensor').val('${serviceOrder.waterLevelSensor}');

			 $('#epServiceTransferSwitchId').val('${serviceOrder.epServiceTransferSwitchId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#mechanicalStatus').val('${serviceOrder.mechanicalStatus}');
			 $('#boardClean').val('${serviceOrder.boardClean}');
			 $('#screwAdjust').val('${serviceOrder.screwAdjust}');
			 $('#conectionAdjust').val('${serviceOrder.conectionAdjust}');
			 $('#systemMotors').val('${serviceOrder.systemMotors}');
			 $('#electricInterlock').val('${serviceOrder.electricInterlock}');
			 $('#mechanicalInterlock').val('${serviceOrder.mechanicalInterlock}');
			 $('#capacityAmp').val('${serviceOrder.capacityAmp}');
			 $('#lampTest').val('${serviceOrder.lampTest}');

			 $('#epServiceLecturesId').val('${serviceOrder.epServiceLecturesId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#voltageABAN').val('${serviceOrder.voltageABAN}');
			 $('#voltageACCN').val('${serviceOrder.voltageACCN}');
			 $('#voltageBCBN').val('${serviceOrder.voltageBCBN}');
			 $('#voltageNT').val('${serviceOrder.voltageNT}');
			 $('#currentA').val('${serviceOrder.currentA}');
			 $('#currentB').val('${serviceOrder.currentB}');
			 $('#currentC').val('${serviceOrder.currentC}');
			 $('#frequency').val('${serviceOrder.frequency}');
			 $('#oilPreassure').val('${serviceOrder.oilPreassure}');
			 $('#temp').val('${serviceOrder.temp}');

			 $('#epServiceParamsId').val('${serviceOrder.epServiceParamsId}');
			 $('#epServiceId').val('${serviceOrder.epServiceId}');
			 $('#adjsutmentTherm').val('${serviceOrder.adjsutmentTherm}');
			 $('#current').val('${serviceOrder.current}');
			 $('#batteryCurrent').val('${serviceOrder.batteryCurrent}');
			 $('#clockStatus').val('${serviceOrder.clockStatus}');
			 $('#trasnferTypeProtection').val('${serviceOrder.trasnferTypeProtection}');
			 $('#generatorTypeProtection').val('${serviceOrder.generatorTypeProtection}');
						
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
							<td>Fecha y hora de llegada</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
				</div>					
			</div>
			<div class="grid_16">
				<div class="box">
					<p><label>&nbsp;</label></p>
					
					<table>
						<thead>
							<tr>
								<th>DATOS DEL EQUIPO</th>
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
						<thead>
							<tr>
								<th>INSPECCION BASICA</th>
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
							<tr>
								<th>SERVICIOS BÁSICOS</th>
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
						<thead>
							<tr>
								<th>PRUEBAS DINAMICAS MOTOR DE COMBUSTION (Solicitar autorización para pruebas con carga)</th>
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
						<thead>
							<tr>
								<th>PRUEBAS PROTECCIÓN DEL EQUIPO</th>
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
						<thead>
							<tr>
								<th>INTERRUPTOR DE TRANSFERENCIA AUTOMATICO</th>
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
						<thead>
							<tr>
								<th>LECTURAS DEL SISTEMA (CON CARGA/SIN CARGA)</th>
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
						<thead>
							<tr>
								<th>OTROS PARAMETROS</th>
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
							<tr>
								<th>Observaciones (HISTORIAL DE ALARMAS CUANDO APLIQUE)</th>
							</tr>
						</thead>
						<tr>
							<td style="height:140px;">
								<textarea id="observations"   style="width:100%;height:100%;"></textarea>
							</td>
						</tr>
					</table>
					<p><label>&nbsp;</label></p>
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
								<div id="leftSign" class="signBox">
								</div>
							</td>
							<td colspan="2" >
								<span>Firma</span>
								<div id="rightSign" class="signBox">
								</div>
							</td>
						</tr>
						<tr>
							<td>Nombre</td><td><input id="lbNombreRealizado" type="text" style="width:95%;"  /></td>
							<td>Nombre</td><td><input id="lbNombreRecibido" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>Fecha y hora de salida</td><td><input id="lbFechaSalida" type="text" style="width:95%;"  /></td>
							<td>Puesto</td><td><input type="text" id="lblPuesto" style="width:95%;"  /></td>
						</tr>						
						<tr>
							<td style="height:40px;"></td>
							<td></td>
							<td></td>
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
				</div>					
			</div>		
			
			<!-- Signature capture box # 1 -->
			<input type="hidden" id="leftSignJSON" />
			<!-- Signature capture box # 2 -->
			<input type="hidden" id="rightSignJSON" />
		</div>
		</form>
	</body>
</html>