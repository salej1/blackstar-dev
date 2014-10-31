<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/date.js"></script>
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
	<script src="${pageContext.request.contextPath}/js/customAutocomplete.js"></script>
	
	<script type="text/javascript" charset="utf-8">
		
		$(document).ready(function () {
					
			// Asignacion de campos iniciales
			var mode = "${mode}";
			var hasPolicy =  "${hasPolicy}"
			var isEng = "${user.belongsToGroup['Implementacion y Servicio']}";
			
			if(mode == "detail"){
				$(".lockOnDetail").attr("disabled", "");
			}

			if(mode == "new"){
				//$("#serviceDate").val(dateNow());
				$("#responsibleName").val("${ user.userName }");
				$("#responsible").val("${ user.userEmail }");

				init_autoComplete('${serviceEmployees}', "responsibleName", "responsible");

				// Habilitar datetime picker
				$("#serviceDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});

				// Habilitando campos de captura del cliente
				if(hasPolicy == "true"){
					$(".lockOnPolicy").attr("disabled", "");
				}

				// Binding officeId
				$("#optOffices").bind('change', function(){
					$("#officeId").val($(this).val());
				});

				$("#officeId").val("G"); // valor inicial

				$(".hideOnNew").hide();
			}

			// bloqueando lockOnEngDetail
			if(isEng == "true" && mode == "detail"){
				$(".lockOnEngDetail").attr("disabled", "");
			}

			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("os",  "/osDetail/show.do?serviceOrderId=${serviceOrder.serviceOrderId}");

		});

		function closeService(){
			$("#serviceStatusId").val('C');
			$("#closed").val(dateNow());
			$('input').removeAttr("disabled");
			$('select').removeAttr("disabled");
			$('textarea').removeAttr("disabled");
			$('#serviceOrder').submit();
		}

		function validate(){
			var startTimestamp = Date.parseExact($("#serviceDate").val(), 'dd/MM/yyyy HH:mm:ss');
			if(startTimestamp == undefined || startTimestamp == null){
				$("#InvalidMessage").html("Por favor revise la fecha y hora del servicio");
				return false;
			}
			
			if($('#serviceOrder')[0].checkValidity()){
				if($("#signCreatedCapture").val().trim().length == 0 || $("#signReceivedByCapture").val().trim().length == 0){
					$("#InvalidMessage").html("Por favor firme la OS");
					return false;
				}

				$('input').removeAttr("disabled");
				$('select').removeAttr("disabled");
				$('textarea').removeAttr("disabled");
				if($("#responsible").val().indexOf(';') == 0){
					$("#responsible").val($("#responsible").val().substring(1));
				}
				$("#signCreated").val($("#signCreatedCapture").val())
				$("#signReceivedBy").val($("#signReceivedByCapture").val())
				$("#serviceEndDate").val(dateNow());
				return true;
			}
			else{
				setTimeout(function() { $(event.target).focus();}, 50);
				$("#InvalidMessage").html("Por favor revise que todos los campos hayan sido correctamente capturados");
				return false;
			}
		}
	</script> 
	
	</head>
	<body>
		<div id="content" class="container_16 clearfix">
			<form:form  commandName="serviceOrder" action="/aircoService/save.do" method="POST">			
				<div class="grid_16">					
					<div class="box">
						<h2>AIRES ACONDICIONADOS / CHILLER</h2>
							<table>
								<tr>
									<td>Folio:</td>
									<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="10" readOnly="true"/></td>
									<td colspan="2">
										<c:if test="${serviceOrder.serviceOrderId > 0}">
											<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>	
										</c:if>
										<form:input path="serviceOrderId" type="hidden"/>
										<form:input path="hasPdf" type="hidden"/>
									</td>
								</tr>
								<tr>
									<td>Cliente</td>
									<td colspan="5"><form:input path="customer" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
									<td>Contrato/Proyecto</td>
									<td colspan="3"><form:input path="project" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="5"><form:textarea path="equipmentAddress" style="width:95%;height:50px;" cssClass="lockOnDetail lockOnPolicy" required="true"></form:textarea></td>
									<td>Telefono</td>
									<td><form:input type="text" path="contactPhone" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
								</tr>
								<tr>
									<td>Marca</td>
									<td><form:input path="brand" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
									<td>Modelo</td>
									<td colspan="2"><form:input path="model" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
									<td>Serie</td>
									<td colspan="2"><form:input path="serialNumber" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
										
								</tr>
								<tr>
									<td>Oficina</td>
									<td>
										<form:hidden path="officeId"/>
										<select class="lockOnDetail lockOnPolicy" id="optOffices">
											<c:forEach var="office" items="${offices}">
										        <option value="${office}" 
										        <c:if test="${serviceOrder.officeId == fn:substring(office, 0, 1)}">
										        	selected="true"
										    	</c:if>
										        >${office}</option>
										    </c:forEach>
										</select>
									</td>
									<td>Fecha y hora de llegada</td>
									<td colspan="2"><form:input path="serviceDate" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Estatus:</td>
									<td>
										<form:hidden path="serviceStatusId" />
										<select name="" id="serviceStatuses" disabled>
											<c:forEach var="ss" items="${serviceStatuses}">
												<option value="ss.serviceStatusId"
												<c:if test="${ss.serviceStatusId == serviceOrder.serviceStatusId}">
													selected="true"
												</c:if>
												>${ss.serviceStatus}</option>
											</c:forEach>
											<option value=""></option>
										</select>
									</td>
									<form:input path="serviceTypeId" type="hidden" value="P" />
									<form:hidden path="equipmentTypeId" value="A"/>
									<form:hidden path="closed" />
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
									<td colspan="4"><form:input path="evaDescription" type="text" style="width:99%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.2 VALORES ACTUALES</td>
									<td>Temp.</td>
									<td><form:input path="evaValTemp" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Hum.</td>
									<td><form:input path="evaValHum" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.2.1 SETPOINTS</td>
									<td>Temp.</td>
									<td><form:input path="evaSetpointTemp" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Hum.</td>
									<td><form:input path="evaSetpointHum" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.3 SE REALIZÓ COMPARACION Y CALIBRACION T/H MEDIDO</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaFlagCalibration" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td colspan="5">1.4 REVISIÓN Y LIMPIEZA DE FILTROS, EVAPORADOR Y EQUIPO EN GRAL.</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaReviewFilter" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td colspan="5">1.5 REVISIÓN Y AJUSTE DE BANDAS, ALINEACIÓN Y BALANCEO DE TURBINAS</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaReviewStrip" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td colspan="5">1.6 INSPECCIÓN Y LIMPIEZADEL SISTEMA ELECTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES (PLATINOS)</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaCleanElectricSystem" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td colspan="5">1.7	REVISIÓN Y LIMPIEZA DE TARJETA DE CONTROL Y SENSOR DE TEMP/HUMEDAD</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaCleanControlCard" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td colspan="5">1.8	REVISIÓN Y LIMPIEZA DE CHAROLA Y DRENAJE DE CONDENSADOS Y HUMIDIFICADOR</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaCleanTray" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td colspan="5">1.9	LECTURA DE PRESIÓN DE COMPRESIÓN EN OPERACIÓN NORMAL</td>
									<td>Alta</td>
									<td><form:input path="evaLectrurePreasureHigh" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Baja(60 psig min)</td>
									<td><form:input path="evaLectrurePreasureLow" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.10 LECTURA DE TEMPERATURA EN SUCCIÓN Y ENTRADA DE VÁLVULA DE EXPANSIÓN</td>
									<td colspan="4"><form:input path="evaLectureTemp" type="text" style="width:99%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.11 ESTADO DE ACEITE EN EL COMPRESOR</td>
									<td>Color</td>
									<td><form:input path="evaLectureOilColor" type="text" style="width:95%;"  cssClass="lockOnDetail"/></td>
									<td>Nivel</td>
									<td><form:input path="evaLectureOilLevel" type="text" style="width:95%;" cssClass="lockOnDetail"  required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACIÓN</td>
									<td>Color</td>
									<td><form:input path="evaLectureCoolerColor" type="text" style="width:95%;" cssClass="lockOnDetail" /></td>
									<td>Nivel</td>
									<td><form:input path="evaLectureCoolerLevel" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.13 REVISIÓN DE OPERACIÓN DE PROTECCIONES POR ALTA Y BAJA PRESIÓN</td>
									<td colspan="4"><form:input path="evaCheckOperatation" type="text" style="width:99%;" cssClass="lockOnDetail"  required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.14 VERIFICAR RUIDOS EXTRAÑOS, VIBRACIÓN EXCESIVA, SENTADO DEL EQUIPO Y COMPONENTES Y POSIBLES FUGAS EN TODO EL SISTEMA</td>
									<td colspan="4"><form:input path="evaCheckNoise" type="text" style="width:99%;" cssClass="lockOnDetail"  required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.15 CORRECTO AISLAMIENTO DE TUBERÍA Y TAPAS DEL EQUIPO</td>
									<td colspan="4"><form:input path="evaCheckIsolated" type="text" style="width:99%;" cssClass="lockOnDetail"  required="true"/></td>
								</tr>
								<tr>
									<td colspan="3">1.16 TOMA DE LECTURAS DE VOLTAJE</td>
									<td>Tomas a tierra</td>
									<td><form:input path="evaLectureVoltageGroud" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Entre fases</td>
									<td><form:input path="evaLectureVoltagePhases" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Control</td>
									<td><form:input path="evaLectureVoltageControl" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="1">1.17 LECTURA DE CORRIENTE POR FASE</td>
									<td>Motor</td>
									<td><form:input path="evaLectureCurrentMotor1" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td> 
									<td><form:input path="evaLectureCurrentMotor2" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td> 
									<td><form:input path="evaLectureCurrentMotor3" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Compresor</td>
									<td><form:input path="evaLectureCurrentCompressor1" type="text" style="width:95%;" cssClass="lockOnDetail"/></td> 
									<td><form:input path="evaLectureCurrentCompressor2" type="text" style="width:95%;" cssClass="lockOnDetail"/></td> 
									<td><form:input path="evaLectureCurrentCompressor3" type="text" style="width:95%;" cssClass="lockOnDetail"/></td>
								</tr>
								<tr>
									<td colspan="1"></td>
									<td>Humidificador</td>
									<td><form:input path="evaLectureCurrentHumidifier1" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td><form:input path="evaLectureCurrentHumidifier2" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td><form:input path="evaLectureCurrentHumidifier3" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Calentador</td>
									<td><form:input path="evaLectureCurrentHeater1" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td><form:input path="evaLectureCurrentHeater2" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<td><form:input path="evaLectureCurrentHeater3" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td colspan="5">1.18 PRUEBA DE SENSOR DE AIRE Y FILTRO SUCIO</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaCheckFluidSensor" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>	
								<tr>
									<td colspan="5">1.19 REQUERIMIENTO DE LAMINADO Y PINTURA EN EL EQUIPO</td>
									<td colspan="4"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="evaRequirMaintenance" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
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
									<td  colspan="6"><form:input path="condReview" type="text" style="width:99%;" cssClass="lockOnDetail"  required="true"/></td>
								</tr>
								<tr>
									<td>2.2	INSPECCIÓN Y LIMPIEZA DEL SISTEMA ELÉCTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES</td>
									<td colspan="6"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="condCleanElectricSystem" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td>2.3	LAVADO DE CONDENSADOR (DRY FLUID COOLER) CON LIQUIDO DESINCRUSTANTE Y AGUA A PRESIÓN</td>
									<td colspan="6"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="condClean" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
								</tr>
								<tr>
									<td>2.4	TOMA DE LECTURAS DE VOLTAJE</td>
									<td>Fases a tierra</td>
									<td><form:input path="condLectureVoltageGroud" type="text" style="width:90%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Entre fases</td>
									<td><form:input path="condLectureVoltagePhases" type="text" style="width:90%;" cssClass="lockOnDetail" required="true"/></td>
									<td>Control</td>
									<td><form:input path="condLectureVoltageControl" type="text" style="width:90%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td>2.5	LECTURA DE CORRIENTE EN MONITORES DE CONDENSADOR</td>
									<td colspan="6" ><form:input path="condLectureMotorCurrent" type="text" style="width:99%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td>2.6	REVISIÓN Y AJUSTE DE TERMOSTATO</td>
									<td colspan="6"><form:input path="condReviewThermostat" type="text" style="width:99%;"  cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td></td>
									<td>MODELO:</td>
									<td><form:input path="condModel" type="text" style="width:90%;" cssClass="lockOnDetail"  required="true" /></td>
									<td>No. DE SERIE:</td>
									<td><form:input path="condSerialNumber" type="text" style="width:90%;" cssClass="lockOnDetail"  required="true"/></td>
									<td>MARCA:</td>
									<td><form:input path="condBrand" type="text" style="width:90%;" cssClass="lockOnDetail" required="true" /></td>
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
										<form:textarea path="observations" style="width:100%;height:99%;" cssClass="lockOnDetail"></form:textarea>
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
									<td><form:input path="responsibleName" type="text" style="width:95%;" cssClass="lockOnDetail"/></td>
									<form:hidden path="responsible" style="width:95%;"/>
									<td>Nombre</td>
									<td><form:input path="receivedBy" type="text" style="width:95%;" required="true" cssClass="lockOnDetail"/></td>
								</tr>
								<tr>
									<td></td>
									<td><form:hidden cssClass="lockOnDetail" path="serviceEndDate"/></td>
									<td>Puesto</td>
									<td><form:input path="receivedByPosition"  style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
								</tr>		
								<tr>
									<td colspan="2"></td>
									<td>Email</td>
									<td><form:input path="receivedByEmail"  style="width:95%;" cssClass="lockOnDetail" /></td>
								</tr>	
								<c:if test="${!user.belongsToGroup['Cliente']}">
									<tr class="hideOnNew">
										<td colspan="2">Errores de captura<form:checkbox path="isWrong" cssClass="lockOnEngDetail"/></td>
										<td></td>
										<td></td>
									</tr>
									<!-- Link a enuesta de servicio -->
									<c:choose>
										<c:when test="${serviceOrder.surveyServiceId > 0}">
											<tr class="hideOnNew">
												<td colspan="2">Resultado de encuesta: 
													<form:input path="surveyScore" cssClass="lockOnEngDetail" style="width:20px;" disabled="true"/>
													<a href="${pageContext.request.contextPath}/surveyServiceDetail/show.do?operation=2&idObject=${serviceOrder.surveyServiceId}">Ir a Encuesta de Servicio</a>
												</td>
												<td></td>
											</tr>
										</c:when>
										<c:otherwise>
											<tr class="hideOnNew">
												<td colspan="2">Sin encuesta de servicio</td>
												<td></td>
											</tr>
										</c:otherwise>
									</c:choose>
								</c:if>		
							</table>

							<table>
								<tbody>
									<tr>
										<td>
											
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
			<c:if test="${!user.belongsToGroup['Cliente']}">
				<c:import url="followUpControl.jsp"></c:import>
				<c:import url="saveService.jsp"></c:import>
			
				<table>
					<tbody>
						<tr>
							<td>
							<c:if test="${serviceOrder.serviceOrderId > 0}">
								<button class="searchButton" onclick="addSeguimiento(${serviceOrder.serviceOrderId}, '${serviceOrder.serviceOrderNumber}');">Agregar seguimiento</button>
								<c:if test="${serviceOrder.serviceStatusId != 'C'}">
									<button class="searchButton eligible coorOnly lockOnEngDetail" id="closeBtn" onclick="closeService();">Cerrar</button>
								</c:if>	
							</c:if>	
							<input class="searchButton lockOnEngDetail" id="guardarServicio" type="submit" onclick="saveService('AA', validate); return false;" 
								value="Guardar servicio" form="serviceOrder"/>
							<button class="searchButton" onclick="window.location = '/serviceOrders/show.do'">Cancelar</button>
							</td>
						</tr>
					</tbody>
				</table>
			</c:if>
		</div>
	</body>
</html>