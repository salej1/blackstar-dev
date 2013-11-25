<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio Aire Acondicionado</title>
	
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
				$('#lbTipoServicio').val('${serviceOrderDetail.serviceType}');
				$('#lbProyecto').val('${serviceOrderDetail.proyectNumber}');
				$('#fldObserv').val('${serviceOrderDetail.detailStatus}');
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
					
				 $('#evaDescription').val('${serviceOrder.evaDescription}');
				 $('#evaValTemp').val('${serviceOrder.evaValTemp}');
				 $('#evaValHum').val('${serviceOrder.evaValHum}');
				 $('#evaSetpointTemp').val('${serviceOrder.evaSetpointTemp}');
				 $('#evaSetpointHum').val('${serviceOrder.evaSetpointHum}');
				 $('#evaFlagCalibration').val('${serviceOrder.evaFlagCalibration}');
				 $('#evaReviewFilter').val('${serviceOrder.evaReviewFilter}');
				 $('#evaReviewStrip').val('${serviceOrder.evaReviewStrip}');
				 $('#evaCleanElectricSystem').val('${serviceOrder.evaCleanElectricSystem}');
				 $('#evaCleanControlCard').val('${serviceOrder.evaCleanControlCard}');
				 $('#evaCleanTray').val('${serviceOrder.evaCleanTray}');
				 $('#evaLectrurePreasureHigh').val('${serviceOrder.evaLectrurePreasureHigh}');
				 $('#evaLectrurePreasureLow').val('${serviceOrder.evaLectrurePreasureLow}');
				 $('#evaLectureTemp').val('${serviceOrder.evaLectureTemp}');
				 $('#evaLectureOilColor').val('${serviceOrder.evaLectureOilColor}');
				 $('#evaLectureOilLevel').val('${serviceOrder.evaLectureOilLevel}');
				 $('#evaLectureCoolerColor').val('${serviceOrder.evaLectureCoolerColor}');
				 $('#evaLectureCoolerLevel').val('${serviceOrder.evaLectureCoolerLevel}');
				 $('#evaCheckOperatation').val('${serviceOrder.evaCheckOperatation}');
				 $('#evaCheckNoise').val('${serviceOrder.evaCheckNoise}');
				 $('#evaCheckIsolated').val('${serviceOrder.evaCheckIsolated}');
				 $('#evaLectureVoltageGroud').val('${serviceOrder.evaLectureVoltageGroud}');
				 $('#evaLectureVoltagePhases').val('${serviceOrder.evaLectureVoltagePhases}');
				 $('#evaLectureVoltageControl').val('${serviceOrder.evaLectureVoltageControl}');
				 $('#evaLectureCurrentMotor1').val('${serviceOrder.evaLectureCurrentMotor1}');
				 $('#evaLectureCurrentMotor2').val('${serviceOrder.evaLectureCurrentMotor2}');
				 $('#evaLectureCurrentMotor3').val('${serviceOrder.evaLectureCurrentMotor3}');
				 $('#evaLectureCurrentCompressor1').val('${serviceOrder.evaLectureCurrentCompressor1}');
				 $('#evaLectureCurrentCompressor2').val('${serviceOrder.evaLectureCurrentCompressor2}');
				 $('#evaLectureCurrentCompressor3').val('${serviceOrder.evaLectureCurrentCompressor3}');
				 $('#evaLectureCurrentHumidifier1').val('${serviceOrder.evaLectureCurrentHumidifier1}');
				 $('#evaLectureCurrentHumidifier2').val('${serviceOrder.evaLectureCurrentHumidifier2}');
				 $('#evaLectureCurrentHumidifier3').val('${serviceOrder.evaLectureCurrentHumidifier3}');
				 $('#evaLectureCurrentHeater1').val('${serviceOrder.evaLectureCurrentHeater1}');
				 $('#evaLectureCurrentHeater2').val('${serviceOrder.evaLectureCurrentHeater2}');
				 $('#evaLectureCurrentHeater3').val('${serviceOrder.evaLectureCurrentHeater3}');
				 $('#evaCheckFluidSensor').val('${serviceOrder.evaCheckFluidSensor}');
				 $('#evaRequirMaintenance').val('${serviceOrder.evaRequirMaintenance}');
				 $('#condReview').val('${serviceOrder.condReview}');
				 $('#condCleanElectricSystem').val('${serviceOrder.condCleanElectricSystem}');
				 $('#condClean').val('${serviceOrder.condClean}');
				 $('#condLectureVoltageGroud').val('${serviceOrder.condLectureVoltageGroud}');
				 $('#condLectureVoltagePhases').val('${serviceOrder.condLectureVoltagePhases}');
				 $('#condLectureVoltageControl').val('${serviceOrder.condLectureVoltageControl}');
				 $('#condLectureMotorCurrent').val('${serviceOrder.condLectureMotorCurrent}');
				 $('#condReviewThermostat').val('${serviceOrder.condReviewThermostat}');
				 $('#condModel').val('${serviceOrder.condModel}');
				 $('#condSerialNumber').val('${serviceOrder.condSerialNumber}');
				 $('#condBrand').val('${serviceOrder.condBrand}');
				 $('#observations').val('${serviceOrder.observations}');	
					
	 					 
		});
	
	</script> 
	
		 
	</head>
	<body>
		<form id = "formServicio" action="/crear" method="POST">
			<div id="content" class="container_16 clearfix">
				<div class="grid_16">					
					<div class="box">
						<h2>AIRES ACONDICIONADOS / CHILLER</h2>
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
									<td>Contrato/Proyecto</td>
									<td colspan="3"><input id="lbProyecto" type="text" style="width:95%;" readOnly="true" /></td>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="5"><textarea  id="lbDomicilio" style="width:95%;height:50px;" readOnly="true"></textarea></td>
									<td>Telefono</td>
									<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
								</tr>
								<tr>
									<td>Equipo</td>
									<td><input id="lbEquipo" type="text" style="width:95%;" readOnly="true" /></td>
									<td style="padding-left:10px;">Marca</td>
									<td><input id="lbMarca" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Modelo</td>
									<td><input id="lbModelo" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Serie</td>
									<td><input id="lbSerie" type="text" style="width:95%;" readOnly="true" /></td>
										
								</tr>
								<tr>
									<td>Fecha y hora de llegada</td>
									<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true" /></td>
								</tr>
							</table>
						</div>					
					</div>
					<div class="grid_16">
						<div class="box">
							<table>
								<thead>
									<tr>
										<th colspan="9">1. EVAPORADOR</th>
									</tr>
								</thead>
								<tr>
									<td colspan="5">1.1 OPERACIÓN Y ESTADO DE FUNCIONAMIENTO ENCONTRADO</td>
									<td colspan="4"><input id="evaDescription" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.2 VALORES ACTUALES</td>
									<td>Temp.</td>
									<td><input id="evaValTemp" type="text" style="width:95%;" /></td>
									<td>Hum.</td>
									<td><input id="evaValHum" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.2.1 SETPOINTS</td>
									<td>Temp.</td>
									<td><input id="evaSetpointTemp" type="text" style="width:95%;" /></td>
									<td>Hum.</td>
									<td><input id="evaSetpointHum" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.3 SE REALIZÓ COMPARACION Y CALIBRACION T/H MEDIDO</td>
									<td colspan="4"><input id="evaFlagCalibration" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.4 REVISIÓN Y LIMPIEZA DE FILTROS, EVAPORADOR Y EQUIPO EN GRAL.</td>
									<td colspan="4"><input id="evaReviewFilter" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.5 REVISIÓN Y AJUSTE DE BANDAS, ALINEACIÓN Y BALANCEO DE TURBINAS</td>
									<td colspan="4"><input id="evaReviewStrip" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.6 INSPECCIÓN Y LIMPIEZADEL SISTEMA ELECTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES (PLATINOS)</td>
									<td colspan="4"><input id="evaCleanElectricSystem" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.7	REVISIÓN Y LIMPIEZA DE TARJETA DE CONTROL Y SENSOR DE TEMP/HUMEDAD</td>
									<td colspan="4"><input id="evaCleanControlCard" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.8	REVISIÓN Y LIMPIEZA DE CHAROLA Y DRENAJE DE CONDENSADOS Y HUMIDIFICADOR</td>
									<td colspan="4"><input id="evaCleanTray" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.9	LECTURA DE PRESIÓN DE COMPRESIÓN EN OPERACIÓN NORMAL</td>
									<td>Alta</td>
									<td><input id="evaLectrurePreasureHigh" type="text" style="width:95%;" /></td>
									<td>Baja(60 psig min)</td>
									<td><input id="evaLectrurePreasureLow" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.10 LECTURA DE TEMPERATURA EN SUCCIÓN Y ENTRADA DE VÁLVULA DE EXPANSIÓN</td>
									<td colspan="4"><input id="evaLectureTemp" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.11 ESTADO DE ACEITE EN EL COMPRESOR</td>
									<td>Color</td>
									<td><input id="evaLectureOilColor" type="text" style="width:95%;" /></td>
									<td>Nivel</td>
									<td><input id="evaLectureOilLevel" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACIÓN</td>
									<td>Color</td>
									<td><input id="evaLectureCoolerColor" type="text" style="width:95%;" /></td>
									<td>Nivel</td>
									<td><input id="evaLectureCoolerLevel" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.13 REVISIÓN DE OPERACIÓN DE PROTECCIONES POR ALTA Y BAJA PRESIÓN</td>
									<td colspan="4"><input id="evaCheckOperatation" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.14 VERIFICAR RUIDOS EXTRAÑOS, VIBRACIÓN EXCESIVA, SENTADO DEL EQUIPO Y COMPONENTES Y POSIBLES FUGAS EN TODO EL SISTEMA</td>
									<td colspan="4"><input id="evaCheckNoise" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.15 CORRECTO AISLAMIENTO DE TUBERÍA Y TAPAS DEL EQUIPO</td>
									<td colspan="4"><input id="evaCheckIsolated" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="3">1.16 TOMA DE LECTURAS DE VOLTAJE</td>
									<td>Tomas a tierra</td>
									<td><input id="evaLectureVoltageGroud" type="text" style="width:95%;" /></td>
									<td>Entre fases</td>
									<td><input id="evaLectureVoltagePhases" type="text" style="width:95%;" /></td>
									<td>Control</td>
									<td><input id="evaLectureVoltageControl" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="1">1.17 LECTURA DE CORRIENTE POR FASE</td>
									<td>Motor</td>
									<td><input id="evaLectureCurrentMotor1" type="text" style="width:95%;" /></td> 
									<td><input id="evaLectureCurrentMotor2" type="text" style="width:95%;" /></td> 
									<td><input id="evaLectureCurrentMotor3" type="text" style="width:95%;" /></td>
									<td>Compresor</td>
									<td><input id="evaLectureCurrentCompressor1" type="text" style="width:95%;" /></td> 
									<td><input id="evaLectureCurrentCompressor2" type="text" style="width:95%;" /></td> 
									<td><input id="evaLectureCurrentCompressor3" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="1"></td>
									<td>Humidificador</td>
									<td><input id="evaLectureCurrentHumidifier1" type="text" style="width:95%;" /></td>
									<td><input id="evaLectureCurrentHumidifier2" type="text" style="width:95%;" /></td>
									<td><input id="evaLectureCurrentHumidifier3" type="text" style="width:95%;" /></td>
									<td>Calentador</td>
									<td><input id="evaLectureCurrentHeater1" type="text" style="width:95%;" /></td>
									<td><input id="evaLectureCurrentHeater2" type="text" style="width:95%;" /></td>
									<td><input id="evaLectureCurrentHeater3" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.18 PRUEBA DE SENSOR DE AIRE Y FILTRO SUCIO</td>
									<td colspan="4"><input id="evaCheckFluidSensor" type="text" style="width:99%;" /></td>
								</tr>	
								<tr>
									<td colspan="5">1.19 REQUERIMIENTO DE LAMINADO Y PINTURA EN EL EQUIPO</td>
									<td colspan="4"><input id="evaRequirMaintenance" type="text" style="width:99%;" /></td>
								</tr>	
							</table>
							<table>
								<thead>
									<tr>
									<th colspan="7"	>2. CONDENSADOR:</th>
									</tr>
								</thead>
								<tr>
									<td>2.1	REVISION DE CONDENSADOR (RUIDO, VIBRACIÓN, FUGAS) Y VERIFICACIÓN DE OPERACIONES DE PROPELAS (ROTACIÓN CORRECTA):</td>
									<td  colspan="6"><input id="condReview" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.2	INSPECCIÓN Y LIMPIEZA DEL SISTEMA ELÉCTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES</td>
									<td colspan="6"><input id="condCleanElectricSystem" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.3	LAVADO DE CONDENSADOR (DRY FLUID COOLER) CON LIQUIDO DESINCRUSTANTE Y AGUA A PRESIÓN</td>
									<td colspan="6"><input id="condClean" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.4	TOMA DE LECTURAS DE VOLTAJE</td>
									<td>Fases a tierra</td>
									<td><input id="condLectureVoltageGroud" type="text" style="width:90%;" /></td>
									<td>Entre fases</td>
									<td><input id="condLectureVoltagePhases" type="text" style="width:90%;" /></td>
									<td>Control</td>
									<td><input id="condLectureVoltageControl" type="text" style="width:90%;" /></td>
								</tr>
								<tr>
									<td>2.5	LECTURA DE CORRIENTE EN MONITORES DE CONDENSADOR</td>
									<td colspan="6" ><input id="condLectureMotorCurrent" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.6	REVISIÓN Y AJUSTE DE TERMOSTATO</td>
									<td colspan="6"><input id="condReviewThermostat" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td></td>
									<td>MODELO:</td>
									<td><input id="condModel" type="text" style="width:90%;" /></td>
									<td>No. DE SERIE:</td>
									<td><input id="condSerialNumber" type="text" style="width:90%;" /></td>
									<td>MARCA:</td>
									<td><input id="condBrand" type="text" style="width:90%;" /></td>
								</tr>
							</table>
		
							<table>
								<thead>
									<tr>
										<th>OBSERVACIONES:</th>
										<th> Mantenimiento y lecturas de otros accesorios (bombas, manómetros, termómetros, etc) Realizar pruebas de operación (COOL, REHEAT, HUMIF, DESHUMIF) , ajustes finales e historial de alarmas</th>
									</tr>
								</thead>
								<tr>
									<td colspan="2" style="height:140px;">
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
									<td><input id="lbNombreRealizado" type="text" style="width:95%;"  /></td>
									<td>Nombre</td>
									<td><input id="lbNombreRecibido" type="text" style="width:95%;" /></td>
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