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
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>	
	<script type="text/javascript" charset="utf-8">

		function split( val ) {
	      return val.split( /,\s*/ );
	    }

	    function extractLast( term ) {
	      return split( term ).pop();
	    }

		$(document).ready(function () {
			
			$( "#serviceDate" ).val(dateNow());
			$( "#oilChange" ).datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){$(this).val(date+" 00:00:00")}});
			$( "#tuningDate" ).datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){$(this).val(date+" 00:00:00")}});
			$( "#serviceCorrective" ).datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){$(this).val(date+" 00:00:00")}});
			
			// Asignacion de campos iniciales
			var mode = "${mode}";
			if(mode == "detail"){
				$("#receivedBy").attr("disabled", "");
				$("#receivedByPosition").attr("disabled", "");
				$("#receivedByEmail").attr("disabled", "");
				$("#responsibleName").attr("disabled", "");
				var isEng = "${ user.belongsToGroup['Implementacion y Servicio']}";
				if(isEng == "true"){
					$("#guardarServicio").hide();
				}
			}
			else{
				$("#responsibleName").val("${ user.userName }");
				$("#responsible").val("${ user.userEmail }");
				var strEpmloyees = '${serviceEmployees}';
				var empData = $.parseJSON(strEpmloyees);

				$("#responsibleName").bind( "keydown", function( event ) {
			        if ( event.keyCode === $.ui.keyCode.TAB &&
			            $( this ).data( "ui-autocomplete" ).menu.active ) {
			          event.preventDefault();
			        }
			      }).autocomplete({
					minLength: 0,
					source: function( request, response ) {
			          response( $.ui.autocomplete.filter(
			            empData, extractLast( request.term ) ) );
			        },
					focus: function() {
			          return false;
			        },select: function( event, ui ) {
			        	var terms = this.value.split(/,\s*/);
			            terms.pop();
			            terms.push( ui.item.label );
			            terms.push( "" );
			            this.value = terms.join( ", " );

			            $("#responsible").val($("#responsible").val() + ";" + ui.item.value );
			            return false;
					}
				});

			    // Sincronizando los campos de firma
			    $("#serviceOrder").submit(function(){
					$("#signCreated").val($("#signCreatedCapture").val())
					$("#signReceivedBy").val($("#signReceivedByCapture").val())
				});
			}

			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrder.serviceOrderId}");

			// Cierre de la OS
			$("#closeBtn").bind("click", function(){
				$("serviceStatusId").val('C');
			});
		});

		function isNumberKey(evt){
		     var charCode = (evt.which) ? evt.which : event.keyCode;
	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
	            return false;
	         }

	         return true;
		}
	</script> 
	
		 
	</head>
	<body>	
		<div id="content" class="container_16 clearfix">
		<form:form  commandName="serviceOrder" action="save.do" method="POST">			
			<div class="grid_16">					
					<div class="box">
						<h2>PLANTAS DE EMERGENCIA</h2>
							<table>
								<tr>
									<td>Folio:</td>
									<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="5" /></td>
									<c:if test="${serviceOrder.serviceOrderId > 0}">
										<td colspan="2"><a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>	
									</c:if>
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
									<td>Capacidad</td>
									<td><form:input path="capacity" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Fecha y hora de llegada</td>
									<td><form:input path="serviceDate" type="text" style="width:95%;"  /></td>
									<form:input path="serviceTypeId" type="hidden" value="P" />
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
							<td><form:input path="brandPE" type="text" style="width:95%;" /></td>
							<td>MOTOR DIESEL MARCA:</td>
							<td><form:input path="brandMotor" type="text" style="width:95%;" /></td>
							<td>CAPACIDAD TANQUE DIESEL:</td>
							<td><form:input path="tankCapacity" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
						</tr>
						<tr>
							<td>MODELO PE:</td>
							<td><form:input path="modelPE" type="text" style="width:95%;" /></td>
							<td>MODELO MOTOR:</td>
							<td><form:input path="modelMotor" type="text" style="width:95%;" /></td>
							<td>MODELO BOMBA COMBUSTIBLE:</td>
							<td><form:input path="pumpFuelModel" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>No SERIE PE:</td>
							<td><form:input path="serialPE" type="text" style="width:95%;" /></td>
							<td>No. DE SERIE MOTOR:</td>
							<td><form:input path="serialMotor" type="text" style="width:95%;" /></td>
							<td>FILTRO DE COMBUSTIBLE. SE CAMBIÓ?:</td>
							<td><form:checkbox path="filterFuelFlag"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>TIPO DE TRANSFERENCIA:</td>
							<td><form:input path="transferType" type="text" style="width:95%;" /></td>
							<td>CPL MOTOR:</td>
							<td><form:input path="cplMotor" type="text" style="width:95%;" /></td>
							<td>FILTRO DE ACEITE. SE CAMBIÓ?</td>
							<td><form:checkbox path="filterOilFlag" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO TRANSF:</td>
							<td><form:input path="modelTransfer" type="text" style="width:95%;" /></td>
							<td>GENERADOR MCA:</td>
							<td><form:input path="brandGenerator" type="text" style="width:95%;" /></td>
							<td>FILTRO DE AGUA. SE CAMBIÓ?:</td>
							<td><form:checkbox path="filterWaterFlag"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO CONTROL:</td>
							<td><form:input path="modelControl" type="text" style="width:95%;" /></td>
							<td>MODELO GENERADOR:</td>
							<td><form:input path="modelGenerator" type="text" style="width:95%;" /></td>
							<td>FILTRO DE AIRE. SE CAMBIÓ?:</td>
							<td><form:checkbox path="filterAirFlag"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VOLTAJE:</td>
							<td><form:input path="modelRegVoltage" type="text" style="width:95%;" /></td>
							<td>No DE SERIE GENERADOR:</td>
							<td><form:input path="serialGenerator" type="text" style="width:95%;" /></td>
							<td>MODELO DE LA MARCHA:</td>
							<td><form:input path="brandGear" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VELOCIDAD:</td>
							<td><form:input path="modelRegVelocity" type="text" style="width:95%;" /></td>
							<td>POTENCIA (KW) GENERADOR:</td>
							<td><form:input path="powerWattGenerator" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>MODELO DE BATERÍAS:</td>
							<td><form:input path="brandBattery" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO CARGADOR DE BAT:</td>
							<td><form:input path="modelCharger" type="text" style="width:95%;" /></td>
							<td>TENSIÓN GENERADOR:</td>
							<td><form:input path="tensionGenerator" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>LECTURA RELOJ CUENTA HORAS:</td>
							<td><form:input path="clockLecture" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>ULTIMO CAMBIO DE ACEITE:</td>
							<td><form:input path="oilChange" type="text" style="width:95%;" /></td>
							<td>ULTIMA FECHA DE AFINACIÓN:</td>
							<td><form:input path="tuningDate" type="text" style="width:95%;" /></td>
							<td>ULTIMO SERVICIO CORRECTIVO:</td>
							<td><form:input path="serviceCorrective" type="text" style="width:95%;" /></td>
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
							<td><form:checkbox path="levelOilFlag"  style="width:95%;" /></td>
							<td>ZAPATAS DE BATERÍA:</td>
							<td><form:input path="batteryCap" type="text" style="width:95%;" /></td>
							<td>MANGUERAS COMBUSTIBLE:</td>
							<td><form:input path="hoseOil" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>NIVEL DE AGUA/ANTICONGELANTE. SE CAMBIÓ?:</td>
							<td><form:checkbox path="levelWaterFlag" style="width:95%;" /></td>
							<td>SULFATACIÓN BATERÍA:</td>
							<td><form:input path="batterySulfate" type="text" style="width:95%;" /></td>
							<td>MANGUERAS AGUA:</td>
							<td><form:input path="hoseWater" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>NIVEL ELECTROLITO BATERÍA:</td>
							<td><form:input path="levelBattery" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>NIVEL DE COMBUSTIBLE %:</td>
							<td><form:input path="levelOil" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>VÁLVULAS Y TUBERÍAS (CU/NEGRA):</td>
							<td><form:input path="tubeValve" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>FUGA EN TUBO DE ESCAPE:</td>
							<td><form:checkbox path="tubeLeak"  style="width:95%;" /></td>
							<td>PRECALENTADO DE LA MÁQUINA. TEMPERATURA (MIN 60°):</td>
							<td><form:input path="heatEngine" type="text" style="width:95%;" /></td>
							<td>TENSIÓN DE BANDAS/ESTADO DE ASPAS:</td>
							<td><form:input path="stripBlades" type="text" style="width:95%;" /></td>
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
							<td><form:checkbox path="washEngine"  style="width:95%;" /></td>
							<td>SOPLETEADO DE TRANSFER:</td>
							<td><form:checkbox path="cleanTransfer"  style="width:95%;" /></td>
							<td>PRUEBAS DE BATERÍAS:</td>
							<td><form:checkbox path="batteryTests" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>LAVADO DE RADIADOR:</td>
							<td><form:checkbox path="washRadiator"  style="width:95%;" /></td>
							<td>LIMPIEZA TARJETAS DE CONTROL:</td>
							<td><form:checkbox path="cleanCardControl"  style="width:95%;" /></td>
							<td>REVISIÓN CARGADOR DE BATERÍA/ALTERNADOR:</td>
							<td><form:checkbox path="checkCharger"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>LIMPIEZA ÁREA DE TRABAJO:</td>
							<td><form:checkbox path="cleanWorkArea"  style="width:95%;" /></td>
							<td>AJUSTE DE CONEXIONES DE CONTROL:</td>
							<td><form:checkbox path="checkConectionControl"  style="width:95%;" /></td>
							<td>PINTURA Y CONSERVACIÓN:</td>
							<td><form:checkbox path="checkPaint"  style="width:95%;" /></td>
						</tr>
						<tr>
							<td>REVISIÓN DE CABLEADO  Y CONEXIONES:</td>
							<td><form:checkbox path="conectionCheck"  style="width:95%;" /></td>
							<td>REVISIÓN DE EXT/EMBOBINADOS:</td>
							<td><form:checkbox path="checkWinding"  style="width:95%;" /></td>
							<td>SOPLETEADO TAB GENERADOR:</td>
							<td><form:checkbox path="cleanGenerator" style="width:95%;" /></td>
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
							<td><form:input path="vacuumFrequency" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>VOLTAJE EN VACÍO:</td>
							<td><form:input path="vacuumVoltage" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>TIEMPO DE ARRANQUE:</td>
							<td><form:input path="startTime" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>FRECUENCIA EN CARGA:</td>
							<td><form:input path="chargeFrequency" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>VOLTAJE EN CARGA:</td>
							<td><form:input path="chargeVoltage" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>TIEMPO DE TRANSFERENCIA:</td>
							<td><form:input path="transferTime" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>NUM. DE INTENTOS DE ARRANQUE:</td>
							<td><form:input path="bootTryouts" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>CALIDAD DE EMISIONES DE HUMO:</td>
							<td><form:input path="qualitySmoke" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>TIEMPO DE PARO:</td>
							<td><form:input path="stopTime" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
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
							<td><form:input path="tempSensor" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>SENSOR DE VOLTAJE O GENERACIÓN:</td>
							<td><form:input path="voltageSensor" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>SENSOR BAJA PRESIÓN DE ACEITE:</td>
							<td><form:input path="oilPreasureSensor" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
						</tr>
						<tr>
							<td>SENSOR DE PRESIÓN DEL ACEITE:</td>
							<td><form:input path="oilSensor" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
							<td>SENSOR DE SOBRE-VELOCIDAD:</td>
							<td><form:input path="overSpeedSensor" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>SENSOR DE NIVEL DE AGUA:</td>
							<td><form:input path="waterLevelSensor" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
					</table>
					<table>
						<thead >
							<tr >
								<th colspan="6">INTERRUPTOR DE TRANSFERENCIA AUTOMATICO</th>
							</tr>
						</thead>
						<tr>
							<td>ESTADO MECÁNICO:</td>
							<td><form:input path="mechanicalStatus" type="text" style="width:95%;" /></td>
							<td>AJUSTE DE TORNILLERÍA:</td>
							<td><form:checkbox path="screwAdjust"  style="width:95%;" /></td>
							<td>INTERLOCK ELÉCTRICO:</td>
							<td><form:input path="electricInterlock" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>LIMPIEZA DEL TABLERO:</td>
							<td><form:checkbox path="boardClean" style="width:95%;" /></td>
							<td>AJUSTE DE CONEXIONES:</td>
							<td><form:checkbox path="conectionAdjust"  style="width:95%;" /></td>
							<td>INTERLOCK MECÁNICO:</td>
							<td><form:input path="mechanicalInterlock" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>PRUEBA DE LÁMPARAS:</td>
							<td><form:checkbox path="lampTest" style="width:95%;" /></td>
							<td>MOTORES DEL SISTEMA:</td>
							<td><form:input path="systemMotors" type="text" style="width:95%;" /></td>
							<td>CAPACIDAD EN AMPERES:</td>
							<td><form:input path="capacityAmp" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
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
							<td><form:input path="voltageABAN" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>CORRIENTE A(AMP):</td>
							<td><form:input path="currentA" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>FRECUENCIA:</td>
							<td><form:input path="frequency" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>VOLTAJE AC/CN:</td>
							<td><form:input path="voltageACCN" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>CORRIENTE B(AMP):</td>
							<td><form:input path="currentB" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>PRESIÓN DE ACEITE:</td>
							<td><form:input path="oilPreassure" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>VOLTAJE BC/BN:</td>
							<td><form:input path="voltageBCBN" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>CORRIENTE C (AMP):</td>
							<td><form:input path="currentC" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
							<td>TEMPERATURA:</td>
							<td><form:input path="temp" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
						</tr>
						<tr>
							<td>VOLTAJE NT:</td>
							<td><form:input path="voltageNT" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
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
							<td><form:input path="adjsutmentTherm" type="text" style="width:95%;" /></td>
							<td>VOLTAJE FLOTACIÓN BATERÍAS:</td>
							<td><form:input path="batteryCurrent" type="text" style="width:95%;" /></td>
							<td>TIPO DE PROTECCIÓN TRANSFER:</td>
							<td><form:input path="trasnferTypeProtection" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>CORRIENTE PRECALENTADOR:</td>
							<td><form:input path="current" type="text" style="width:95%;" /></td>
							<td>ESTADO RELOJ CUENTAS HORAS:</td>
							<td><form:input path="clockStatus" type="text" style="width:95%;" /></td>
							<td>TIPO DE PROTECCIÓN GENERADOR:</td>
							<td><form:input path="generatorTypeProtection" type="text" style="width:95%;" /></td>
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
										<div id="leftSign" class="signBox">
											<canvas class="signPad" width="330" height="115"></canvas>
										</div>
									</td>
									<td colspan="2" >
										<span>Firma</span>
										<div id="rightSign" class="signBox">
											<canvas class="signPad" width="330" height="115"></canvas>
										</div>
									</td>
								</tr>
								<tr>
									<td>Nombre</td>
									<td><form:input path="responsibleName" type="text" style="width:95%;"/></td>
									<form:hidden path="responsible" style="width:95%;"/>
									<td>Nombre</td>
									<td><form:input path="receivedBy" type="text" style="width:95%;" required="true"/></td>
								</tr>
								<tr>
									<td colspan="2"></td>
									<td>Puesto</td>
									<td><form:input path="receivedByPosition"  style="width:95%;"  /></td>
								</tr>		
								<tr>
									<td colspan="2"></td>
									<td>Email</td>
									<td><form:input path="receivedByEmail"  style="width:95%;" required="true" /></td>
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
					
					<!-- Campos de firma -->
					<form:hidden path="signCreated"/>
			        <form:hidden path="signReceivedBy"/>
			</form:form>
					
			<!-- Fragmento de Firma -->
			<c:import url="signatureFragment.jsp"></c:import>

			<!-- Adjuntos -->
			<c:import url="_attachments.jsp"></c:import>
			
			<!-- Control de secuencia y captura de seguimiento -->
			<c:import url="followUpControl.jsp"></c:import>
			<c:if test="${serviceOrder.serviceOrderId > 0}">
				<table>
					<tbody>
						<tr>
							<td>
								<button class="searchButton" onclick="addSeguimiento(${serviceOrder.serviceOrderId}, '${serviceOrder.serviceOrderNumber}');">Agregar seguimiento</button>
								<c:if test="${ user.belongsToGroup['Coordinador']}">
									<button class="searchButton" id="closeBtn">Cerrar</button>
								</c:if>
							</td>
						</tr>
					<tbody>
				</table>	
			</c:if>
		</div>
	</body>
</html>