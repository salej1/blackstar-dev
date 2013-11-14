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
		
			$('#lbCoordinador').val('${serviceOrderDetail.coordinator}');
			$('#linkTicket').text('Consultar Ticket ' + '${serviceOrderDetail.ticketNo}');
			$('#lbNoTicket').val('${serviceOrderDetail.ticketNo}');
			$('#lbFolio').val('${serviceOrderDetail.serviceOrderNo}');
			$('#lbCliente').val('${serviceOrderDetail.customer}');
			$('#lbDomicilio').val('${serviceOrderDetail.equipmentAddress}');
			$('#fechaLlegada').val('${serviceOrderDetail.serviceDate}');
			$('#lbSolicitante').val('${serviceOrderDetail.contactName}');
			$('#lbTelefono').val('${serviceOrderDetail.contactPhone}');
			$('#lbEquipo').val('${serviceOrderDetail.equipmentType}');
			$('#lbMarca').val('${serviceOrderDetail.equipmentBrand}');
			$('#lbModelo').val('${serviceOrderDetail.equipmentModel}');
			$('#lbSerie').val('${serviceOrderDetail.equipmentSerialNo}');
			$('#lbFalla').val('${serviceOrderDetail.failureDescription}');
			$('#lbTipoServicio').val('${serviceOrderDetail.serviceType}');
			$('#lbProyecto').val('${serviceOrderDetail.proyectNumber}');
			$('#fldSitEnc').val('${serviceOrderDetail.detailIssue}');
			$('#fldTrabReal').val('${serviceOrderDetail.detailWorkDone}');
			$('#lbParametros').val('${serviceOrderDetail.detailTechnicalJob}');
			$('#fldReq').val('${serviceOrderDetail.detailRequirments}');
			$('#fldObserv').val('${serviceOrderDetail.detailStatus}');
			$('#leftSignJSON').val();
			$('#rightSignJSON').val();
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
				
			 $('#aaServiceId').val('${serviceOrder.aaServiceId}');			 
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
							<td>Contrato/Proyecto</td>
							<td colspan="3"><input id="lbProyecto" type="text" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>Domicilio</td>
							<td colspan="5"><textarea  id="lbDomicilio" style="width:95%;height:50px;"></textarea></td>
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
								<th>1. EVAPORADOR</th>
							</tr>
						</thead>
						<tr>
							<td>1.1 OPERACIÓN Y ESTADO DE FUNCIONAMIENTO ENCONTRADO</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.2 VALORES ACTUALES</td>
							<td>Temp.</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Hum.</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.2.1 SETPOINTS</td>
							<td>Temp.</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Hum.</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.3 SE REALIZÓ COMPARACION Y CALIBRACION T/H MEDIDO</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.4 REVISIÓN Y LIMPIEZA DE FILTROS, EVAPORADOR Y EQUIPO EN GRAL.</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.5 REVISIÓN Y AJUSTE DE BANDAS, ALINEACIÓN Y BALANCEO DE TURBINAS</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.6 INSPECCIÓN Y LIMPIEZADEL SISTEMA ELECTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES (PLATINOS)</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.7	REVISIÓN Y LIMPIEZA DE TARJETA DE CONTROL Y SENSOR DE TEMP/HUMEDAD</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.8	REVISIÓN Y LIMPIEZA DE CHAROLA Y DRENAJE DE CONDENSADOS Y HUMIDIFICADOR</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.9	LECTURA DE PRESIÓN DE COMPRESIÓN EN OPERACIÓN NORMAL</td>
							<td>Alta</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Baja(60 psig min)</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.10 LECTURA DE TEMPERATURA EN SUCCIÓN Y ENTRADA DE VÁLVULA DE EXPANSIÓN</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.11 ESTADO DE ACEITE EN EL COMPRESOR</td>
							<td>Color</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Nivel</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACIÓN</td>
							<td>Color</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Nivel</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.13 REVISIÓN DE OPERACIÓN DE PROTECCIONES POR ALTA Y BAJA PRESIÓN</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.14 VERIFICAR RUIDOS EXTRAÑOS, VIBRACIÓN EXCESIVA, SENTADO DEL EQUIPO Y COMPONENTES Y POSIBLES FUGAS EN TODO EL SISTEMA</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.15 CORRECTO AISLAMIENTO DE TUBERÍA Y TAPAS DEL EQUIPO</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.16 TOMA DE LECTURAS DE VOLTAJE</td>
							<td>Tomas a tierra</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Entre fases</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Control</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.17 LECTURA DE CORRIENTE POR FASE</td>
							<td>Motor</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Compresor</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td></td>
							<td>Humidificador</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Calentador</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td> /
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>1.18 PRUEBA DE SENSOR DE AIRE Y FILTRO SUCIO</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>	
						<tr>
							<td>1.19 REQUERIMIENTO DE LAMINADO Y PINTURA EN EL EQUIPO</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>	
					</table>
					<table>
						<thead>
							<tr>
								<th>2. CONDENSADOR:</th>
							</tr>
						</thead>
						<tr>
							<td>2.1	REVISION DE CONDENSADOR (RUIDO, VIBRACIÓN, FUGAS) Y VERIFICACIÓN DE OPERACIONES DE PROPELAS (ROTACIÓN CORRECTA):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>2.2	INSPECCIÓN Y LIMPIEZA DEL SISTEMA ELÉCTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>2.3	LAVADO DE CONDENSADOR (DRY FLUID COOLER) CON LIQUIDO DESINCRUSTANTE Y AGUA A PRESIÓN</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>2.4	TOMA DE LECTURAS DE VOLTAJE</td>
							<td>Fases a tierra</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Entre fases</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Control</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>2.5	LECTURA DE CORRIENTE EN MONITORES DE CONDENSADOR</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>2.6	REVISIÓN Y AJUSTE DE TERMOSTATO</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MODELO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>No. DE SERIE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MARCA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>

					<table>
						<thead>
							<tr>
								<th>OBSERVACIONES.</th>
								<th> Mantenimiento y lecturas de otros accesorios (bombas, manómetros, termómetros, etc) Realizar pruebas de operación (COOL, REHEAT, HUMIF, DESHUMIF) , ajustes finales e historial de alarmas</th>
							</tr>
						</thead>
						<tr>
							<td style="height:140px;">
								<textarea id="fldObserv"  readOnly="true" style="width:100%;height:100%;"></textarea>
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
							<td>Nombre</td><td><input id="lbNombreRealizado" type="text" style="width:95%;" readOnly="true" /></td>
							<td>Nombre</td><td><input id="lbNombreRecibido" type="text" style="width:95%;"readOnly="true" /></td>
						</tr>
						<tr>
							<td>Fecha y hora de salida</td><td><input id="lbFechaSalida" type="text" style="width:95%;" readOnly="true" /></td>
							<td>Puesto</td><td><input type="text" id="lblPuesto" style="width:95%;" readOnly="true" /></td>
						</tr>						
						<tr>
							<td style="height:40px;"></td>
							<td></td>
							<td></td>
						</tr>
					</table>
						
				</div>					
			</div>		
			
			<!-- Signature capture box # 1 -->
			<input type="hidden" id="leftSignJSON" />
			<!-- Signature capture box # 2 -->
			<input type="hidden" id="rightSignJSON" />
		</div>
	</body>
</html>