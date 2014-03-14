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
						
			$("#serviceDate").val(dateNow());

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

			if(mode == "new-policy" || mode == "new-open"){
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
			}

			if(mode == "new-policy"){
			    // Sincronizando los campos de firma
			    $("#serviceOrder").submit(function(){
					$("#signCreated").val($("#signCreatedCapture").val())
					$("#signReceivedBy").val($("#signReceivedByCapture").val())
				});
			}
			
			// Atributos de readonly
			if(mode=="new-open"){
				$("#serviceOrderNumber").attr("required", "");
				$("#cutomer").attr("required", "");
				$("#equipmentAddress").attr("required", "");
				$("#contactPhone").attr("required", "");
				$("#brand").attr("required", "");
				$("#model").attr("required", "");
				$("#serialNumber").attr("required", "");
				$("#serviceDate").attr("required", "");
				$("#serviceDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){$(this).val(date+" 00:00:00")}});
				$("#signatureRow").hide();
			}
			else{
				$("#serviceOrderNumber").attr("readonly", "");
				$("#customer").attr("readonly", "");
				$("#project").attr("readonly", "");
				$("#equipmentAddress").attr("readonly", "");
				$("#contactPhone").attr("readonly", "");
				$("#brand").attr("readonly", "");
				$("#model").attr("readonly", "");
				$("#serialNumber").attr("readonly", "");
				$("#serviceDate").attr("required", "");
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
						<h2>AIRES ACONDICIONADOS / CHILLER</h2>
							<table>
								<tr>
									<td>Folio:</td>
									<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="10" /></td>
									<td colspan="2">
										<c:if test="${serviceOrder.serviceOrderId > 0}">
											<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>	
										</c:if>
									</td>
								</tr>
								<tr>
									<td>Cliente</td>
									<td colspan="5"><form:input path="customer" type="text" style="width:95%;" /></td>
									<td>Contrato/Proyecto</td>
									<td colspan="3"><form:input path="project" type="text" style="width:95%;" /></td>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="5"><form:textarea path="equipmentAddress" style="width:95%;height:50px;"></form:textarea></td>
									<td>Telefono</td>
									<td><form:input type="text" path="contactPhone" style="width:95%;" /></td>
								</tr>
								<tr>
									<td>Equipo</td>
									<td><form:input path="equipmentType" type="text" style="width:95%;" readOnly="true" /></td>
									<td style="padding-left:10px;">Marca</td>
									<td><form:input path="brand" type="text" style="width:95%;" /></td>
									<td>Modelo</td>
									<td><form:input path="model" type="text" style="width:95%;" /></td>
									<td>Serie</td>
									<td><form:input path="serialNumber" type="text" style="width:95%;" /></td>
										
								</tr>
								<tr>
									<td>Fecha y hora de llegada</td>
									<td><form:input path="serviceDate" type="text" style="width:95%;" /></td>
									<form:input path="serviceTypeId" type="hidden" value="P" />
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
									<td><form:input path="evaSetpointTemp" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Hum.</td>
									<td><form:input path="evaSetpointHum" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
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
									<td><form:input path="evaLectrurePreasureHigh" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Baja(60 psig min)</td>
									<td><form:input path="evaLectrurePreasureLow" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
								</tr>
								<tr>
									<td colspan="5">1.10 LECTURA DE TEMPERATURA EN SUCCIÓN Y ENTRADA DE VÁLVULA DE EXPANSIÓN</td>
									<td colspan="4"><form:input path="evaLectureTemp" type="text" style="width:99%;" onkeypress='return isNumberKey(event)'/></td>
								</tr>
								<tr>
									<td colspan="5">1.11 ESTADO DE ACEITE EN EL COMPRESOR</td>
									<td>Color</td>
									<td><form:input path="evaLectureOilColor" type="text" style="width:95%;" /></td>
									<td>Nivel</td>
									<td><form:input path="evaLectureOilLevel" type="text" style="width:95%;" onkeypress='return isNumberKey(event)' /></td>
								</tr>
								<tr>
									<td colspan="5">1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACIÓN</td>
									<td>Color</td>
									<td><form:input path="evaLectureCoolerColor" type="text" style="width:95%;" /></td>
									<td>Nivel</td>
									<td><form:input path="evaLectureCoolerLevel" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
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
									<td><form:input path="evaLectureVoltageGroud" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Entre fases</td>
									<td><form:input path="evaLectureVoltagePhases" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Control</td>
									<td><form:input path="evaLectureVoltageControl" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
								</tr>
								<tr>
									<td colspan="1">1.17 LECTURA DE CORRIENTE POR FASE</td>
									<td>Motor</td>
									<td><form:input path="evaLectureCurrentMotor1" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td> 
									<td><form:input path="evaLectureCurrentMotor2" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td> 
									<td><form:input path="evaLectureCurrentMotor3" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Compresor</td>
									<td><form:input path="evaLectureCurrentCompressor1" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td> 
									<td><form:input path="evaLectureCurrentCompressor2" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td> 
									<td><form:input path="evaLectureCurrentCompressor3" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
								</tr>
								<tr>
									<td colspan="1"></td>
									<td>Humidificador</td>
									<td><form:input path="evaLectureCurrentHumidifier1" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td><form:input path="evaLectureCurrentHumidifier2" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td><form:input path="evaLectureCurrentHumidifier3" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Calentador</td>
									<td><form:input path="evaLectureCurrentHeater1" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td><form:input path="evaLectureCurrentHeater2" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
									<td><form:input path="evaLectureCurrentHeater3" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/></td>
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
									<td><form:input path="condLectureVoltageGroud" type="text" style="width:90%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Entre fases</td>
									<td><form:input path="condLectureVoltagePhases" type="text" style="width:90%;" onkeypress='return isNumberKey(event)'/></td>
									<td>Control</td>
									<td><form:input path="condLectureVoltageControl" type="text" style="width:90%;" onkeypress='return isNumberKey(event)'/></td>
								</tr>
								<tr>
									<td>2.5	LECTURA DE CORRIENTE EN MONITORES DE CONDENSADOR</td>
									<td colspan="6" ><form:input path="condLectureMotorCurrent" type="text" style="width:99%;" onkeypress='return isNumberKey(event)'/></td>
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
								<tr id="signatureRow">
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
									<td colspan="2" ></td>
									<td>Puesto</td>
									<td><form:input path="receivedByPosition"  style="width:95%;"/></td>
								</tr>		
								<tr>
									<td colspan="2"></td>
									<td>Email</td>
									<td><form:input path="receivedByEmail"  style="width:95%;" /></td>
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