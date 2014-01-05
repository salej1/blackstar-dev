<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio de baterias</title>
	
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

		// Signature capture box # 1 
		$('#leftSign').signature('draw', '${serviceOrder.signCreated}'); 
		// Signature capture box # 2 
		$('#rightSign').signature('draw', '${serviceOrder.signReceivedBy}'); 
	});

	function isNumberKey(evt){
	      var charCode = (evt.which) ? evt.which : event.keyCode;
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
						<h2>BATERIAS</h2>
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
									<td>Marca</td>
									<td><form:input path="brand" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Modelo</td>
									<td><form:input path="model" type="text" style="width:95%;" readOnly="true" /></td>
									<td>Capacidad</td>
									<td><form:input path="capacity" type="text" style="width:95%;" readOnly="true" /></td>
										
								</tr>
								<tr>
									<td>NO. DE SERIE</td>
									<td><form:input path="serialNumber" type="text" style="width:95%;" readOnly="true" /></td>
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
						
						<c:forEach var="i" begin="1" end="22">
							<tr>
								<td><c:out value="${i}"/></td>
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