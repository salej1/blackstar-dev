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
	<title>Órden de servicio planta de emergencia</title>
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
				$("#serviceDate").val(dateNow());
				$("#responsibleName").val("${ user.userName }");
				$("#responsible").val("${ user.userEmail }");

				init_autoComplete('${serviceEmployees}', "responsibleName", "responsible");

				// Habilitar datetime picker
				$("#serviceDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});
				$( "#oilChangeDisplay" ).datepicker({ dateFormat: 'dd/mm/yy'});
				$( "#tuningDateDisplay" ).datepicker({ dateFormat: 'dd/mm/yy'});
				$( "#serviceCorrectiveDisplay" ).datepicker({ dateFormat: 'dd/mm/yy'});

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
			initFollowUpDlg("os", "/osDetail/show.do?serviceOrderId=${serviceOrder.serviceOrderId}");

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

			// Dates verification
			// Oil change
			var startTimestamp = Date.parseExact($("#oilChangeDisplay").val(), 'dd/MM/yyyy');
			if(startTimestamp == undefined || startTimestamp == null || startTimestamp == "Invalid Date"){
				$("#InvalidMessage").html("Por favor revise la fecha del ultimo cambio de aceite");
				return false;
			}

			// tunning date
			startTimestamp = Date.parseExact($("#tuningDateDisplay").val(), 'dd/MM/yyyy');
			if(startTimestamp == undefined || startTimestamp == null || startTimestamp == "Invalid Date"){
				$("#InvalidMessage").html("Por favor revise la fecha de ultima afinacion");
				return false;
			}

			// serviceCorrective
			startTimestamp = Date.parseExact($("#serviceCorrectiveDisplay").val(), 'dd/MM/yyyy');
			if(startTimestamp == undefined || startTimestamp == null || startTimestamp == "Invalid Date"){
				$("#InvalidMessage").html("Por favor revise la fecha de ultimo servicio correctivo");
				return false;
			}

			$("#brandPE").val($("#brand").val());
			$("#modelPE").val($("#model").val());
			$("#serialPE").val($("#serialNumber").val());

			if($("#signCreatedCapture").val().trim().length == 0 || $("#signReceivedByCapture").val().trim().length == 0){
				$("#InvalidMessage").html("Por favor firme la orden de servicio");
				return false;
			}

			if($('#serviceOrder')[0].checkValidity()){
				$('input').removeAttr("disabled");
				$('select').removeAttr("disabled");
				$('textarea').removeAttr("disabled");

				if($("#responsible").val().indexOf(';') == 0){
					$("#responsible").val($("#responsible").val().substring(1));
				}
				
				$("#signCreated").val($("#signCreatedCapture").val())
				$("#signReceivedBy").val($("#signReceivedByCapture").val())
				$("#serviceEndDate").val(dateNow());
				$("#oilChange").val($("#oilChangeDisplay").val() + " 00:00:00");
				$("#tuningDate").val($("#tuningDateDisplay").val() + " 00:00:00");
				$("#serviceCorrective").val($("#serviceCorrectiveDisplay").val() + " 00:00:00");
			
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
		<form:form  commandName="serviceOrder" action="/emergencyPlantService/save.do" method="POST">			
			<div class="grid_16">					
					<div class="box">
						<h2>PLANTAS DE EMERGENCIA</h2>
							<table>
								<tr>
									<td>Folio:</td>
									<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="5" readOnly="true"/></td>
										<c:if test="${serviceOrder.serviceOrderId > 0}">
											<td colspan="2"><a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>	
										</c:if>
										<form:input path="serviceOrderId" type="hidden"/>
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
									<td>Capacidad</td>
									<td colspan="2"><form:input path="capacity" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
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
									<td colspan="2"><form:input path="serviceDate" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
									<form:input path="serviceTypeId" type="hidden" value="P" />
									<form:input path="equipmentTypeId" type="hidden" value="B"/>
									<form:input path="closed" type="hidden"/>
								</tr>
								<tr>
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
							<td style="width:120px;">PE MARCA:</td>
							<td><form:input path="brand" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
							<form:hidden path="brandPE"/>
							<td>MOTOR DIESEL MARCA:</td>
							<td><form:input path="brandMotor" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td style="width:120px">CAPACIDAD TANQUE DIESEL:</td>
							<td><form:input path="tankCapacity" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
						</tr>
						<tr>
							<td>MODELO PE:</td>
							<td><form:input path="model" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
							<form:hidden path="modelPE"/>
							<td>MODELO MOTOR:</td>
							<td><form:input path="modelMotor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>MODELO BOMBA COMBUSTIBLE:</td>
							<td><form:input path="pumpFuelModel" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>No SERIE PE:</td>
							<td><form:input path="serialNumber" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy" required="true"/></td>
							<form:hidden path="serialPE"/>
							<td>No. DE SERIE MOTOR:</td>
							<td><form:input path="serialMotor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>FILTRO DE COMBUSTIBLE. SE CAMBIÓ?:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="filterFuelFlag" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>TIPO DE TRANSFERENCIA:</td>
							<td><form:input path="transferType" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>CPL MOTOR:</td>
							<td><form:input path="cplMotor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>FILTRO DE ACEITE. SE CAMBIÓ?</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="filterOilFlag" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>MCA/MODELO TRANSF:</td>
							<td><form:input path="modelTransfer" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>GENERADOR MCA:</td>
							<td><form:input path="brandGenerator" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>FILTRO DE AGUA. SE CAMBIÓ?:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="filterWaterFlag" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>MCA/MODELO CONTROL:</td>
							<td><form:input path="modelControl" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>MODELO GENERADOR:</td>
							<td><form:input path="modelGenerator" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>FILTRO DE AIRE. SE CAMBIÓ?:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="filterAirFlag" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VOLTAJE:</td>
							<td><form:input path="modelRegVoltage" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>No DE SERIE GENERADOR:</td>
							<td><form:input path="serialGenerator" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
							<td>MODELO DE LA MARCHA:</td>
							<td><form:input path="brandGear" type="text" style="width:95%;" cssClass="lockOnDetail" /></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VELOCIDAD:</td>
							<td><form:input path="modelRegVelocity" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>POTENCIA (KW) GENERADOR:</td>
							<td><form:input path="powerWattGenerator" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>MODELO DE BATERÍAS:</td>
							<td><form:input path="brandBattery" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>MCA/MODELO CARGADOR DE BAT:</td>
							<td><form:input path="modelCharger" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
							<td>TENSIÓN GENERADOR:</td>
							<td><form:input path="tensionGenerator" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>LECTURA RELOJ CUENTA HORAS:</td>
							<td><form:input path="clockLecture" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>ULTIMO CAMBIO DE ACEITE:</td>
							<td><form:input path="oilChangeDisplay" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true" readOnly="true"/>
								<form:hidden path="oilChange"/>
							</td>
							<td>ULTIMA FECHA DE AFINACIÓN:</td>
							<td><form:input path="tuningDateDisplay" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" readOnly="true"/>
								<form:hidden path="tuningDate"/>
							</td>
							<td>ULTIMO SERVICIO CORRECTIVO:</td>
							<td><form:input path="serviceCorrectiveDisplay" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true" readOnly="true"/>
								<form:hidden path="serviceCorrective"/>
							</td>
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
							<td style="width:120px;"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="levelOilFlag" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>ZAPATAS DE BATERÍA:</td>
							<td><form:input path="batteryCap" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>MANGUERAS COMBUSTIBLE:</td>
							<td><form:input path="hoseOil" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>NIVEL DE AGUA/ANTICONGELANTE. SE CAMBIÓ?:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="levelWaterFlag" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>SULFATACIÓN BATERÍA:</td>
							<td><form:input path="batterySulfate" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
							<td>MANGUERAS AGUA:</td>
							<td><form:input path="hoseWater" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
						</tr>
						<tr>
							<td>NIVEL ELECTROLITO BATERÍA:</td>
							<td><form:input path="levelBattery" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>NIVEL DE COMBUSTIBLE %:</td>
							<td><form:input path="levelOil" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>VÁLVULAS Y TUBERÍAS (CU/NEGRA):</td>
							<td><form:input path="tubeValve" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
						</tr>
						<tr>
							<td>FUGA EN TUBO DE ESCAPE:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="tubeLeak" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>PRECALENTADO DE LA MÁQUINA. TEMPERATURA (MIN 60°):</td>
							<td><form:input path="heatEngine" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>TENSIÓN DE BANDAS/ESTADO DE ASPAS:</td>
							<td><form:input path="stripBlades" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th  colspan="6">SERVICIOS BÁSICOS</th>
							</tr>
						</thead>
						<tr>
							<td>LAVADO DE MOTOR/TANQUE (FUGA):</td>
							<td style="width:120px;"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="washEngine" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>SOPLETEADO DE TRANSFER:</td>
							<td style="width:120px;"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="cleanTransfer" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>PRUEBAS DE BATERÍAS:</td>
							<td style="width:120px;"><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="batteryTests" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>LAVADO DE RADIADOR:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="washRadiator" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>LIMPIEZA TARJETAS DE CONTROL:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="cleanCardControl" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>REVISIÓN CARGADOR DE BATERÍA/ALTERNADOR:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="checkCharger" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>LIMPIEZA ÁREA DE TRABAJO:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="cleanWorkArea" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>AJUSTE DE CONEXIONES DE CONTROL:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="checkConectionControl" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>PINTURA Y CONSERVACIÓN:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="checkPaint" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>REVISIÓN DE CABLEADO  Y CONEXIONES:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="conectionCheck" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>REVISIÓN DE EXT/EMBOBINADOS:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="checkWinding" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>SOPLETEADO TAB GENERADOR:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="cleanGenerator" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
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
							<td><form:input path="vacuumFrequency" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>VOLTAJE EN VACÍO:</td>
							<td><form:input path="vacuumVoltage" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>TIEMPO DE ARRANQUE:</td>
							<td><form:input path="startTime" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>FRECUENCIA EN CARGA:</td>
							<td><form:input path="chargeFrequency" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>VOLTAJE EN CARGA:</td>
							<td><form:input path="chargeVoltage" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>TIEMPO DE TRANSFERENCIA:</td>
							<td><form:input path="transferTime" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>NUM. DE INTENTOS DE ARRANQUE:</td>
							<td><form:input path="bootTryouts" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>CALIDAD DE EMISIONES DE HUMO:</td>
							<td><form:input path="qualitySmoke" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>TIEMPO DE PARO:</td>
							<td><form:input path="stopTime" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
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
							<td><form:input path="tempSensor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>SENSOR DE VOLTAJE O GENERACIÓN:</td>
							<td><form:input path="voltageSensor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>SENSOR BAJA PRESIÓN DE ACEITE:</td>
							<td><form:input path="oilPreasureSensor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>SENSOR DE PRESIÓN DEL ACEITE:</td>
							<td><form:input path="oilSensor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>SENSOR DE SOBRE-VELOCIDAD:</td>
							<td><form:input path="overSpeedSensor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>SENSOR DE NIVEL DE AGUA:</td>
							<td><form:input path="waterLevelSensor" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
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
							<td><form:input path="mechanicalStatus" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>AJUSTE DE TORNILLERÍA:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="screwAdjust" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>INTERLOCK ELÉCTRICO:</td>
							<td><form:input path="electricInterlock" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>LIMPIEZA DEL TABLERO:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="boardClean" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>AJUSTE DE CONEXIONES:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="conectionAdjust" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>INTERLOCK MECÁNICO:</td>
							<td><form:input path="mechanicalInterlock" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>PRUEBA DE LÁMPARAS:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="lampTest" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>MOTORES DEL SISTEMA:</td>
							<td><form:input path="systemMotors" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>CAPACIDAD EN AMPERES:</td>
							<td><form:input path="capacityAmp" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
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
							<td><form:input path="voltageABAN" type="text" style="width:95%;" onkeypress='return isNumberKey(event) cssClass="lockOnDetail" required="true"'/></td>
							<td>CORRIENTE A(AMP):</td>
							<td><form:input path="currentA" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>FRECUENCIA:</td>
							<td><form:input path="frequency" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>VOLTAJE AC/CN:</td>
							<td><form:input path="voltageACCN" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>CORRIENTE B(AMP):</td>
							<td><form:input path="currentB" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>PRESIÓN DE ACEITE:</td>
							<td><form:input path="oilPreassure" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>VOLTAJE BC/BN:</td>
							<td><form:input path="voltageBCBN" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>CORRIENTE C (AMP):</td>
							<td><form:input path="currentC" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>TEMPERATURA:</td>
							<td><form:input path="temp" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>VOLTAJE NT:</td>
							<td><form:input path="voltageNT" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
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
							<td><form:input path="adjsutmentTherm" type="text" style="width:95%;" cssClass="lockOnDetail" required="true" /></td>
							<td>VOLTAJE FLOTACIÓN BATERÍAS:</td>
							<td><form:input path="batteryCurrent" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>TIPO DE PROTECCIÓN TRANSFER:</td>
							<td><form:input path="trasnferTypeProtection" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>CORRIENTE PRECALENTADOR:</td>
							<td><form:input path="current" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>ESTADO RELOJ CUENTAS HORAS:</td>
							<td><form:input path="clockStatus" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
							<td>TIPO DE PROTECCIÓN GENERADOR:</td>
							<td><form:input path="generatorTypeProtection" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
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
									<td><form:input path="responsibleName" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
									<form:hidden path="responsible" style="width:95%;"/>
									<td>Nombre</td>
									<td><form:input path="receivedBy" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>
								<tr>
									<td></td>
									<td><form:hidden cssClass="lockOnDetail" path="serviceEndDate"/></td>
									<td>Puesto</td>
									<td><form:input path="receivedByPosition"  style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
								</tr>		
								<tr>
									<td colspan="2"></td>
									<td>Email</td>
									<td><form:input path="receivedByEmail"  style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
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
							<input class="searchButton lockOnEngDetail" id="guardarServicio" type="submit" onclick="saveService('PE', validate); return false;" 
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