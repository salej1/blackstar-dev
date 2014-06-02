<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio de baterias</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
	<script src="${pageContext.request.contextPath}/js/customAutocomplete.js"></script>
	
	<script type="text/javascript" charset="utf-8">
		
		$(document).ready(function () {
					
			// Asignacion de campos iniciales
			var mode = "${mode}";
			var hasPolicy =  "${hasPolicy}"
			
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

				// Habilitando campos de captura del cliente
				if(hasPolicy == "true"){
					$(".lockOnPolicy").attr("disabled", "");
				}


				// Binding officeId
				$("#optOffices").bind('change', function(){
					$("#officeId").val($(this).val());
				});

				$("#officeId").val("G"); // valor inicial
			}

			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrder.serviceOrderId}");

		});

		function isNumberKey(evt){
		     var charCode = (evt.which) ? evt.which : event.keyCode;
	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
	            return false;
	         }

	         return true;
		}
		
		function saveService(){
			var startTimestamp = new Date($("#serviceDate").val());
			if(startTimestamp == undefined || startTimestamp == null){
				$("#serviceDate").val("");
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
				$('#serviceOrder').submit();
			}
			else{
				setTimeout(function() { $(event.target).focus();}, 50);
			}
		}
	</script> 		 
	</head>
	<body>
		<div id="content" class="container_16 clearfix">
		<form:form  commandName="serviceOrder" action="save.do" method="POST">			
							<div class="grid_16">					
					<div class="box">
						<h2>BATERIAS</h2>
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
									<td colspan="5"><form:input path="customer" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy"/></td>
									<td>Contrato/Proyecto</td>
									<td colspan="3"><form:input path="project" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy"/></td>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="5"><form:textarea path="equipmentAddress" style="width:95%;height:50px;"  cssClass="lockOnDetail lockOnPolicy"></form:textarea></td>
									<td>Telefono</td>
									<td><form:input type="text" path="contactPhone" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy" /></td>
								</tr>
								<tr>
									<td>Marca</td>
									<td><form:input path="brand" type="text" style="width:95%;" cssClass="lockOnDetail lockOnPolicy"/></td>
									<td>Modelo</td>
									<td><form:input path="model" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy"/></td>
									<td>Capacidad</td>
									<td><form:input path="capacity" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy"/></td>
										
								</tr>
								<tr>
									<td>No. Serie</td>
									<td><form:input path="serialNumber" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy"/></td>
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
									<td><form:input path="serviceDate" type="text" style="width:95%;"  cssClass="lockOnDetail lockOnPolicy"/></td>
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
								<th colspan="2">LIMPIEZA</th>
								<th>ESTADO FÍSICO </th>
								<th>OBSERVACIONES</th>
							</tr>
						</thead>
						<tr>
							<td>CONECTORES / TERMINALES</td>
							<td><form:checkbox path="plugClean"  style="width:95%;" /></td>
							<td><form:input path="plugCleanStatus" type="text" style="width:95%;" /></td>
							<td><form:input path="plugCleanComments" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>CUBIERTA</td>
							<td><form:checkbox path="coverClean"  style="width:95%;" /></td>
							<td><form:input path="coverCleanStatus" type="text" style="width:95%;" /></td>
							<td><form:input path="coverCleanComments" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>TAPONES</td>
							<td><form:checkbox path="capClean"  style="width:95%;" /></td>
							<td><form:input path="capCleanStatus" type="text" style="width:95%;" /></td>
							<td><form:input path="capCleanComments" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>TIERRA FÍSICA</td>
							<td><form:checkbox path="groundClean"  style="width:95%;" /></td>
							<td><form:input path="groundCleanStatus" type="text" style="width:95%;" /></td>
							<td><form:input path="groundCleanComments" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>ESTANTE/GABINETE/RACK</td>
							<td><form:checkbox path="rackClean"  style="width:95%;" /></td>
							<td><form:input path="rackCleanStatus" type="text" style="width:95%;" /></td>
							<td><form:input path="rackCleanComments" type="text" style="width:95%;" /></td>
						</tr>
						<tr>
							<td>NO DE SERIE, LOTE, FECHA DE FABRICACIÓN</td>
							<td colspan="2"><form:input path="serialNoDateManufact" type="text" style="width:98%;" /></td>
						</tr>
						<tr>
							<td>TEMPERATURA PROMEDIO BATERÍAS </td>
							<td colspan="2"><form:input path="batteryTemperature" type="text" style="width:98%;" /></td>
						</tr>
					</table>
					<br/>
					<br/>
					<table>
						<tr>
							<td>VOLTAJE DE FLOTACIÓN DEL BUS:</td>
							<td><form:input path="voltageBus" type="text" style="width:95%;"  onkeypress='return isNumberKey(event)'/></td>
							<td>V.C.D.</td>
							<td>TEMPERATURA AMBIENTE::</td>
							<td><form:input path="temperature" type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/> </td>
							<td>°C</td>
						</tr>
					</table>
					<table style="font-size:xx-small;">
						<tr>
							<td>BAT. CELDA No.</td>
							<td >VOLTAJE FLOTACIÓN</td>
							<td >VOLTAJE CON CARGA</td>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td >VOLTAJE CON CARGA</td>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td >VOLTAJE CON CARGA</td>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td>VOLTAJE CON CARGA</td>
						</tr>
						
						<c:forEach var="i" begin="0" end="22">
							<tr>
								<td><c:out value="${i+1}"/></td>
								<td>
									<form:hidden path="cells[${i}].cellNumber" value="${i}"/>
									<form:input path="cells[${i}].floatVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								<td>
									<form:input path="cells[${i}].chargeVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								
								<td><c:out value="${i+22}"/></td>
								<td>
									<form:hidden path="cells[${i+22}].cellNumber" value="${i+22}"/>
									<form:input path="cells[${i+22}].floatVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								<td>
									<form:input path="cells[${i+22}].chargeVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								
								<td><c:out value="${i+44}"/></td>
								<td>
									<form:hidden path="cells[${i+44}].cellNumber" value="${i+44}"/>
									<form:input path="cells[${i+44}].floatVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								<td>
									<form:input path="cells[${i+44}].chargeVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								
								<td><c:out value="${i+66}"/></td>
								<td>
									<form:hidden path="cells[${i+66}].cellNumber" value="${i+66}"/>
									<form:input path="cells[${i+66}].floatVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								<td>
									<form:input path="cells[${i+66}].chargeVoltage"  type="text" style="width:95%;" onkeypress='return isNumberKey(event)'/>
								</td>
								
					   		</tr>
						</c:forEach>
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
									<td></td>
									<td><form:hidden cssClass="lockOnDetail" path="serviceEndDate"/></td>
									<td>Puesto</td>
									<td><form:input path="receivedByPosition"  style="width:95%;"  /></td>
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
											<c:if test="${ (user.belongsToGroup['Implementacion y Servicio'] && mode == 'new') || user.belongsToGroup['Coordinador'] && mode == 'detail' }">
												<input class="searchButton" type="submit" value="Guardar servicio" onclick="saveService();">
											</c:if>
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