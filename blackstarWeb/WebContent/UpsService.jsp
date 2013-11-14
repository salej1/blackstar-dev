<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio UPS</title>
	
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
		
			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrderDetail.serviceOrderId}");
			
			// Signature capture box # 1 
			$('#leftSign').signature({disabled: true}); 
			$('#leftSign').signature('draw', '${serviceOrderDetail.signCreated}'); 
		
			// Signature capture box # 2 
			$('#rightSign').signature({disabled: true}); 
			$('#rightSign').signature('draw', '${serviceOrderDetail.signReceivedBy}'); 
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
							<td>Marca</td>
							<td colspan="5"><textarea  id="lbDomicilio" style="width:95%;height:50px;"></textarea></td>
							<td>Modelo</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
							<td>Capacidad</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>No. de serie</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
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
								<th>ACTIVIDADES DESAROOLLADAS:</th>
							</tr>
						</thead>
						<tr>
							<td>Estado del equipo encontrado:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Estado de los capacitores:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Sopleteado:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Verificación de fusibles y conexiones eléctricas:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Limpieza por aspirado y brocha:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Revisión y verificación del rectificador/cargador:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Verificación de conexiones y reapriete tornillería:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Estado de ventiladores:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>BANCO DE BATERIAS:</td>
						</tr>
						<tr>
							<td>Reapriete de puentes/conectores:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Temperatura ambiente:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Verificación de fugas/sulfataciones:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Pruebas de carga y descarga:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>No de baterías:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Marca, modelo, capacidad:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Fecha o serie de fabricación:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Voltaje promedio de baterías:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Baterías dañadas (cant y voltaje de c/carga):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Otro (modelo banco externo)):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>PRUEBAS GENERALES: (Solicitar autorización para pruebas)</td>
						</tr>
						<tr>
							<td>Transferencia  y re-transferencia a línea comercial:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Respaldo de baterías con falla en línea:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Transferencia y re-transferencia con planta de emergencia:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Verificación de voltaje de baterías y de salida durante las pruebas:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>PARÁMETROS DE OPERACIÓN:</td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a fase:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Voltaje salida fase a fase:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Voltaje entrada fase a neutro:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Voltaje salida fase a neutro:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Voltaje entre neutro y tierra:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Frec. Entrada/salida:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Porcentaje de carga o corriente:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>Frec. Entrada/salida:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<p><label>&nbsp;</label></p>
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
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
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