<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio de baterias</title>
	
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

			 $('#bbServiceId').val('${serviceOrder.bbServiceId}');
			 $('#serviceOrderId').val('${serviceOrder.serviceOrderId}');
			 $('#plugClean').val('${serviceOrder.plugClean}');
			 $('#plugCleanStatus').val('${serviceOrder.plugCleanStatus}');
			 $('#plugCleanComments').val('${serviceOrder.plugCleanComments}');
			 $('#coverClean').val('${serviceOrder.coverClean}');
			 $('#coverCleanStatus').val('${serviceOrder.coverCleanStatus}');
			 $('#coverCleanComments').val('${serviceOrder.coverCleanComments}');
			 $('#capClean').val('${serviceOrder.capClean}');
			 $('#capCleanStatus').val('${serviceOrder.capCleanStatus}');
			 $('#capCleanComments').val('${serviceOrder.capCleanComments}');
			 $('#groundClean').val('${serviceOrder.groundClean}');
			 $('#groundCleanStatus').val('${serviceOrder.groundCleanStatus}');
			 $('#groundCleanComments').val('${serviceOrder.groundCleanComments}');
			 $('#rackClean').val('${serviceOrder.rackClean}');
			 $('#rackCleanStatus').val('${serviceOrder.rackCleanStatus}');
			 $('#rackCleanComments').val('${serviceOrder.rackCleanComments}');
			 $('#serialNoDateManufact').val('${serviceOrder.serialNoDateManufact}');
			 $('#batteryTemperature').val('${serviceOrder.batteryTemperature}');
			 $('#voltageBus').val('${serviceOrder.voltageBus}');
			 $('#temperature').val('${serviceOrder.temperature}');

			 $('#bbCellServiceId').val('${serviceOrder.bbCellServiceId}');
			 $('#bbServiceId').val('${serviceOrder.bbServiceId}');
			 $('#cellNumber').val('${serviceOrder.cellNumber}');
			 $('#floatVoltage').val('${serviceOrder.floatVoltage}');
			 $('#chargeVoltage').val('${serviceOrder.chargeVoltage}');
						 
						
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
							<td>No Ticket</td>
							<td><input  id="lbNoTicket" type="text" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>Domicilio</td>
							<td colspan="5"><textarea  id="lbDomicilio" style="width:95%;height:50px;"></textarea></td>
							<td>Telefono</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
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
								<th>LIMPIEZA</th>
								<th></th>
								<th>ESTADO FÍSICO </th>
								<th>OBSERVACIONES</th>
							</tr>
						</thead>
						<tr>
							<td>CONECTORES / TERMINALES</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>CUBIERTA</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>TAPONES</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>TIERRA FÍSICA</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>ESTANTE/GABINETE/RACK</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>NO DE SERIE, LOTE, FECHA DE FABRICACIÓN</td>
							<td></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>TEMPERATURA PROMEDIO BATERÍAS </td>
							<td></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<br/>
					<br/>
					<table>
						<tr>
							<td>VOLTAJE DE FLOTACIÓN DEL BUS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
							<td>TEMPERATURA AMBIENTE::</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/> °C</td>
						</tr>
					</table>
					<table>
						<tr>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td>VOLTAJE CON CARGA</td>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td>VOLTAJE CON CARGA</td>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td>VOLTAJE CON CARGA</td>
							<td>BAT. CELDA No.</td>
							<td>VOLTAJE FLOTACIÓN</td>
							<td>VOLTAJE CON CARGA</td>
						</tr>
						
						<c:forEach var="i" begin="1" end="22">
							<tr>
								<td><c:out value="${i}"/></td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><c:out value="${i+22}"/></td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><c:out value="${i+44}"/></td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><c:out value="${i+66}"/></td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
								<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/>V.C.D.</td>
					   		</tr>
						</c:forEach>
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