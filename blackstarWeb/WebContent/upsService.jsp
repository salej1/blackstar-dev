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
	<title>Órden de servicio UPS</title>
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
							
		// Asignacion de campos iniciales
		var mode = "${mode}";
		var hasPolicy =  "${hasPolicy}"
		var isEng = "${user.belongsToGroup['Implementacion y Servicio']}";
		
		$(document).ready(function () {

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
				// Si el ingeniero regreso a guardar la firma...
				if('${serviceOrder.signReceivedBy}' == ""){
					$("#guardarServicio").removeAttr("disabled");
					enableSignCapture("right");
				}
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
			
			if($("#signCreated").val().trim().length == 0){
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
		<form:form  commandName="serviceOrder" action="/upsService/save.do" method="POST">			
			<div class="grid_16">					
				<div class="box">
					<h2>UPS</h2>
					<table>
						<tr>
							<td>Folio:</td>
							<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="5"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
								<c:if test="${serviceOrder.serviceOrderId > 0 && serviceOrder.hasPdf == 1}">
									<td colspan="2"><a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>	
								</c:if>	
								<form:input path="serviceOrderId" type="hidden"/>
								<form:input path="hasPdf" type="hidden"/>
							</td>
						</tr>
						<tr>
							<td>Cliente</td>
							<td colspan="5"><form:input path="customer" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
							<td>Contrato/Proyecto</td>
							<td colspan="3"><form:input path="project" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
						</tr>
						<tr>
							<td>Domicilio</td>
							<td colspan="5"><form:textarea path="equipmentAddress" style="width:95%;height:50px;"  cssClass="lockOnDetail lockOnPolicy" required="true"></form:textarea></td>
							<td>Telefono</td>
							<td><form:input type="text" path="contactPhone" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
						</tr>
						<tr>
							<td>Marca</td>
							<td><form:input path="brand" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
							<td>Modelo</td>
							<td><form:input path="model" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
							<td>Capacidad</td>
							<td colspan="3"><form:input path="capacity" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
								
						</tr>
						<tr>
							<td>NO. DE SERIE</td>
							<td><form:input path="serialNumber" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" required="true" /></td>
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
							<td colspan="3"><form:input path="serviceDate" type="text" style="width:95%;" cssClass="lockOnDetail" /></td>
							<form:input path="serviceTypeId" type="hidden" value="P" />
							<form:input path="equipmentTypeId" type="hidden" value="U"/>
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
							<tr>
								<th colspan="4">ACTIVIDADES DESAROOLLADAS:</th>
							</tr>
						</thead>
						<tr>
							<td>Estado del equipo encontrado:</td>
							<td><form:input path="estatusEquipment" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Estado de los capacitores:</td>
							<td><form:input path="capacitorStatus" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Sopleteado:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="cleaned" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Verificación de fusibles y conexiones eléctricas:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="verifyFuzz" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>Limpieza por aspirado y brocha:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="hooverClean" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Revisión y verificación del rectificador/cargador:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="chargerReview" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>Verificación de conexiones y reapriete tornillería:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="verifyConnections" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Estado de ventiladores:</td>
							<td><form:input path="fanStatus" type="text" style="width:95%;" cssClass="lockOnDetail"/></td>
						</tr>
						<tr>
							<td><b>BANCO DE BATERIAS:</b></td>
						</tr>
						<tr>
							<td>Reapriete de puentes/conectores:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="checkConnectors" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Temperatura ambiente:</td>
							<td><form:input path="temp" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Verificación de fugas/sulfataciones:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="cverifyOutflow" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Pruebas de carga y descarga:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="chargeTest" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>No de baterías:</td>
							<td><form:input path="numberBatteries" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Marca, modelo, capacidad:</td>
							<td><form:input path="brandModel" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Fecha o serie de fabricación:</td>
							<td><form:input path="manufacturedDateSerial" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Voltaje promedio de baterías:</td>
							<td><form:input path="batteryVoltage" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Baterías dañadas (cant y voltaje de c/carga):</td>
							<td colspan="3"><form:input path="damageBatteries" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Otro (modelo banco externo)):</td>
							<td colspan="3"><form:input path="other" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td colspan="4"><b>PRUEBAS GENERALES: (Solicitar autorización para pruebas)</b></td>
						</tr>
						<tr>
							<td>Transferencia  y re-transferencia a línea comercial:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="trasferLine" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Respaldo de baterías con falla en línea:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="backupBatteries" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td>Transferencia y re-transferencia con planta de emergencia:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="transferEmergencyPlant" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
							<td>Verificación de voltaje de baterías y de salida durante las pruebas:</td>
							<td><c:forEach var="item" items="${checkOptions}"><form:radiobutton path="verifyVoltage" value="${item.value}" required="true" cssClass="lockOnDetail"/>${item.label}</c:forEach></td>
						</tr>
						<tr>
							<td><b>PARÁMETROS DE OPERACIÓN:</b></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a fase:</td>
							<td><form:input path="inputVoltagePhase" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Voltaje salida fase a fase:</td>
							<td><form:input path="outputVoltagePhase" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a neutro:</td>
							<td><form:input path="inputVoltageNeutro" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Voltaje salida fase a neutro:</td>
							<td><form:input path="outputVoltageNeutro" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Voltaje entre neutro y tierra:</td>
							<td><form:input path="inputVoltageNeutroGround" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Frec. entrada/salida:</td>
							<td><form:input path="inOutFrecuency" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
						</tr>
						<tr>
							<td>Porcentaje de carga o corriente:</td>
							<td><form:input path="percentCharge" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/></td>
							<td>Voltaje Bus CD:</td>
							<td><form:input path="busVoltage" type="text" style="width:95%;"  cssClass="lockOnDetail" required="true"/></td>
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
							<td><form:input path="responsibleName" type="text" style="width:95%;" cssClass="lockOnEngDetail" required="true" /></td>
							<form:hidden path="responsible" style="width:95%;"/>
							<td>Nombre</td>
							<td><form:input path="receivedBy" type="text" style="width:95%;" cssClass="lockOnEngDetail" required="true" /></td>
						</tr>
						<tr>
							<td></td>
							<td><form:hidden cssClass="lockOnDetail" path="serviceEndDate"/></td>
							<td>Puesto</td>
							<td><form:input path="receivedByPosition"  style="width:95%;" cssClass="lockOnEngDetail" required="true" /></td>
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
							<input class="searchButton lockOnEngDetail" id="guardarServicio" type="submit" onclick="saveService('UPS', validate); return false;" 
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