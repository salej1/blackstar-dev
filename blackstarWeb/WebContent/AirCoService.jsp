<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio Aire Acondicionado</title>
	
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
						<h2>AIRES ACONDICIONADOS / CHILLER</h2>
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
									<td>Equipo</td>
									<td><form:input path="equipmentType" type="text" style="width:95%;" readOnly="true" /></td>
									<td style="padding-left:10px;">Marca</td>
									<td><form:input path="brand" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Modelo</td>
									<td><form:input path="model" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Serie</td>
									<td><form:input path="serialNumber" type="text" style="width:95%;" readOnly="true" /></td>
										
								</tr>
								<tr>
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
										<th colspan="9">1. EVAPORADOR</th>
									</tr>
								</thead>
								<tr>
									<td colspan="5">1.1 OPERACIÓN Y ESTADO DE FUNCIONAMIENTO ENCONTRADO</td>
									<td colspan="4"><form:input path="evaDescription" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.2 VALORES ACTUALES</td>
									<td>Temp.</td>
									<td><form:input path="evaValTemp" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
									<td>Hum.</td>
									<td><form:input path="evaValHum" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
								</tr>
								<tr>
									<td colspan="5">1.2.1 SETPOINTS</td>
									<td>Temp.</td>
									<td><form:input path="evaSetpointTemp" type="text" style="width:95%;" /></td>
									<td>Hum.</td>
									<td><form:input path="evaSetpointHum" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.3 SE REALIZÓ COMPARACION Y CALIBRACION T/H MEDIDO</td>
									<td colspan="4"><form:checkbox path="evaFlagCalibration"  style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.4 REVISIÓN Y LIMPIEZA DE FILTROS, EVAPORADOR Y EQUIPO EN GRAL.</td>
									<td colspan="4"><form:checkbox path="evaReviewFilter"  style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.5 REVISIÓN Y AJUSTE DE BANDAS, ALINEACIÓN Y BALANCEO DE TURBINAS</td>
									<td colspan="4"><form:checkbox path="evaReviewStrip" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.6 INSPECCIÓN Y LIMPIEZADEL SISTEMA ELECTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES (PLATINOS)</td>
									<td colspan="4"><form:checkbox path="evaCleanElectricSystem" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.7	REVISIÓN Y LIMPIEZA DE TARJETA DE CONTROL Y SENSOR DE TEMP/HUMEDAD</td>
									<td colspan="4"><form:checkbox path="evaCleanControlCard"  style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.8	REVISIÓN Y LIMPIEZA DE CHAROLA Y DRENAJE DE CONDENSADOS Y HUMIDIFICADOR</td>
									<td colspan="4"><form:checkbox path="evaCleanTray" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.9	LECTURA DE PRESIÓN DE COMPRESIÓN EN OPERACIÓN NORMAL</td>
									<td>Alta</td>
									<td><form:input path="evaLectrurePreasureHigh" type="text" style="width:95%;" /></td>
									<td>Baja(60 psig min)</td>
									<td><form:input path="evaLectrurePreasureLow" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.10 LECTURA DE TEMPERATURA EN SUCCIÓN Y ENTRADA DE VÁLVULA DE EXPANSIÓN</td>
									<td colspan="4"><form:input path="evaLectureTemp" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.11 ESTADO DE ACEITE EN EL COMPRESOR</td>
									<td>Color</td>
									<td><form:input path="evaLectureOilColor" type="text" style="width:95%;" /></td>
									<td>Nivel</td>
									<td><form:input path="evaLectureOilLevel" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACIÓN</td>
									<td>Color</td>
									<td><form:input path="evaLectureCoolerColor" type="text" style="width:95%;" /></td>
									<td>Nivel</td>
									<td><form:input path="evaLectureCoolerLevel" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.13 REVISIÓN DE OPERACIÓN DE PROTECCIONES POR ALTA Y BAJA PRESIÓN</td>
									<td colspan="4"><form:input path="evaCheckOperatation" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.14 VERIFICAR RUIDOS EXTRAÑOS, VIBRACIÓN EXCESIVA, SENTADO DEL EQUIPO Y COMPONENTES Y POSIBLES FUGAS EN TODO EL SISTEMA</td>
									<td colspan="4"><form:input path="evaCheckNoise" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.15 CORRECTO AISLAMIENTO DE TUBERÍA Y TAPAS DEL EQUIPO</td>
									<td colspan="4"><form:input path="evaCheckIsolated" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td colspan="3">1.16 TOMA DE LECTURAS DE VOLTAJE</td>
									<td>Tomas a tierra</td>
									<td><form:input path="evaLectureVoltageGroud" type="text" style="width:95%;" /></td>
									<td>Entre fases</td>
									<td><form:input path="evaLectureVoltagePhases" type="text" style="width:95%;" /></td>
									<td>Control</td>
									<td><form:input path="evaLectureVoltageControl" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="1">1.17 LECTURA DE CORRIENTE POR FASE</td>
									<td>Motor</td>
									<td><form:input path="evaLectureCurrentMotor1" type="text" style="width:95%;" /></td> 
									<td><form:input path="evaLectureCurrentMotor2" type="text" style="width:95%;" /></td> 
									<td><form:input path="evaLectureCurrentMotor3" type="text" style="width:95%;" /></td>
									<td>Compresor</td>
									<td><form:input path="evaLectureCurrentCompressor1" type="text" style="width:95%;" /></td> 
									<td><form:input path="evaLectureCurrentCompressor2" type="text" style="width:95%;" /></td> 
									<td><form:input path="evaLectureCurrentCompressor3" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="1"></td>
									<td>Humidificador</td>
									<td><form:input path="evaLectureCurrentHumidifier1" type="text" style="width:95%;" /></td>
									<td><form:input path="evaLectureCurrentHumidifier2" type="text" style="width:95%;" /></td>
									<td><form:input path="evaLectureCurrentHumidifier3" type="text" style="width:95%;" /></td>
									<td>Calentador</td>
									<td><form:input path="evaLectureCurrentHeater1" type="text" style="width:95%;" /></td>
									<td><form:input path="evaLectureCurrentHeater2" type="text" style="width:95%;" /></td>
									<td><form:input path="evaLectureCurrentHeater3" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td colspan="5">1.18 PRUEBA DE SENSOR DE AIRE Y FILTRO SUCIO</td>
									<td colspan="4"><form:checkbox path="evaCheckFluidSensor"  style="width:99%;" /></td>
								</tr>	
								<tr>
									<td colspan="5">1.19 REQUERIMIENTO DE LAMINADO Y PINTURA EN EL EQUIPO</td>
									<td colspan="4"><form:checkbox path="evaRequirMaintenance" style="width:99%;" /></td>
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
									<td  colspan="6"><form:input path="condReview" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.2	INSPECCIÓN Y LIMPIEZA DEL SISTEMA ELÉCTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES</td>
									<td colspan="6"><form:checkbox path="condCleanElectricSystem"  style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.3	LAVADO DE CONDENSADOR (DRY FLUID COOLER) CON LIQUIDO DESINCRUSTANTE Y AGUA A PRESIÓN</td>
									<td colspan="6"><form:checkbox path="condClean" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.4	TOMA DE LECTURAS DE VOLTAJE</td>
									<td>Fases a tierra</td>
									<td><form:input path="condLectureVoltageGroud" type="text" style="width:90%;" /></td>
									<td>Entre fases</td>
									<td><form:input path="condLectureVoltagePhases" type="text" style="width:90%;" /></td>
									<td>Control</td>
									<td><form:input path="condLectureVoltageControl" type="text" style="width:90%;" /></td>
								</tr>
								<tr>
									<td>2.5	LECTURA DE CORRIENTE EN MONITORES DE CONDENSADOR</td>
									<td colspan="6" ><form:input path="condLectureMotorCurrent" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td>2.6	REVISIÓN Y AJUSTE DE TERMOSTATO</td>
									<td colspan="6"><form:input path="condReviewThermostat" type="text" style="width:99%;" /></td>
								</tr>
								<tr>
									<td></td>
									<td>MODELO:</td>
									<td><form:input path="condModel" type="text" style="width:90%;" /></td>
									<td>No. DE SERIE:</td>
									<td><form:input path="condSerialNumber" type="text" style="width:90%;" /></td>
									<td>MARCA:</td>
									<td><form:input path="condBrand" type="text" style="width:90%;" /></td>
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
										<form:textarea path="observations"   style="width:100%;height:99%;"></form:textarea>
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