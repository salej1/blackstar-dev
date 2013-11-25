<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio general</title>
	
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

			// Signature capture box # 1 
			$('#signCapture').signature({syncField: '#leftSignJSON'});
			$('#leftSign').signature({disabled: true}); 
			$("#signCapDialog").dialog({
				autoOpen: false,
				height: 220,
				width: 370,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$('#leftSign').signature('draw', $('#leftSignJSON').val()); 
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
			$('#signCapture2').signature({syncField: '#leftSignJSON2'});
			$('#rightSign').signature({disabled: true}); 
			$("#signCapDialog2").dialog({
				autoOpen: false,
				height: 220,
				width: 370,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$('#rightSign').signature('draw', $('#leftSignJSON2').val()); 
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
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrderDetail.serviceOrderId}");
			
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

			 $('#fldSitEnc').val('${serviceOrder.troubleDescription}');
			 $('#lbParametros').val('${serviceOrder.techParam}');
			 $('#fldTrabReal').val('${serviceOrder.workDone}');
			 $('#fldReq').val('${serviceOrder.materialUsed}');
			 $('#fldObserv').val('${serviceOrder.observations}');
		});
	
	</script> 
	
		 
	</head>
	<body>
	<form id = "formServicio" action="/crear" method="POST">
		<div id="content" class="container_16 clearfix">
		<!--   CONTENT COLUMN   -->			
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
							<td>Fecha y hora de llegada</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>Solicitante</td>
							<td colspan="5"><input id="lbSolicitante" type="text" style="width:95%;" readOnly="true" /></td>
							<td>Telefono</td>
							<td><input type="text" id="lbTelefono" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>Equipo</td>
							<td><input id="lbEquipo" type="text" style="width:95%;" readOnly="true" /></td>
							<td style="padding-left:10px;">Marca</td>
							<td><input id="lbMarca" type="text" style="width:95%;" readOnly="true" /></td>
							<td>Modelo</td>
							<td><input id="lbModelo" type="text" style="width:95%;" readOnly="true" /></td>
							<td>Serie</td>
							<td><input id="lbSerie" type="text" style="width:95%;" readOnly="true" /></td>
							
						</tr>
						<tr>
							<td>Reporte de falla</td>
							<td colspan="7"><input id="lbFalla" type="text" style="width:95%;" readOnly="true" /></td>
						</tr>
						<tr>
							<td>Tipo de servicio</td>
							<td colspan="3"><input id="lbTipoServicio" type="text" style="width:95%;" readOnly="true" /></td>
							<td>Contrato/Proyecto</td>
							<td colspan="3"><input id="lbProyecto" type="text" style="width:95%;" readOnly="true" /></td>
						</tr>							
					</table>
				</div>					
			</div>	
			<div class="grid_16">
				<div class="box">
					<h2>Detalles</h2>
						<table>
							<thead>
								<tr>
									<th>Situacion encontrada</th>
									<th>Trabajos realizados</th>
								</tr>
							</thead>
							<tr>
								<td style="height:100px;">
									<textarea id="fldSitEnc" readOnly="true" style="width:100%;height:100%;"></textarea>
								</td>
								<td rowspan="3" style="height:100px;">
									<textarea id="fldTrabReal"  readOnly="true" style="width:100%;height:100%;"></textarea>
								</td>
							</tr>
							<thead>
								<tr>
									<th>Parametros tecnicos</th>
								</tr>
							</thead>
							<tr>
								<td style="height:100px;">
									<textarea  id="lbParametros" readOnly="true" style="width:100%;height:100%;"></textarea>
								</td>
							</tr>
						</table>
						<table>
							<thead>
								<tr>
									<th>Requerimientos o material utilizado</th>
								</tr>
							</thead>
							<tr>
								<td style="height:140px;">
									<textarea  id="fldReq"  readOnly="true" style="width:100%;height:100%;"></textarea>
								</td>
							</tr>
							<thead>
								<tr>
									<th>Observaciones / Estatus del equipo</th>
								</tr>
							</thead>
							<tr>
								<td style="height:140px;">
									<textarea id="fldObserv"  readOnly="true" style="width:100%;height:100%;"></textarea>
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
								<td>Nombre</td><td><input id="lbNombreRealizado" type="text" style="width:95%;" readOnly="true" /></td>
								<td>Nombre</td><td><input id="lbNombreRecibido" type="text" style="width:95%;"readOnly="true" /></td>
							</tr>
							<tr>
								<td>Fecha y hora de salida</td><td><input id="lbFechaSalida" type="text" style="width:95%;" readOnly="true" /></td>
								<td>Puesto</td><td><input type="text" id="lblPuesto" style="width:95%;" readOnly="true" /></td>
							</tr>						
						</table>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" >Guardar servicio</button>
											<button class="searchButton" onclick="window.location = 'dashboard'">Cerrar</button>
										</td>
									</tr>
								<tbody>
							</table>
							<br/>
							<br/>
							<!-- Control de secuencia y captura de seguimiento -->
							<c:import url="followUpControl.jsp"></c:import>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="addSeguimiento(${serviceOrderDetail.serviceOrderId}, '${serviceOrderDetail.serviceOrderNo}');">Agregar seguimiento</button>
											<button class="searchButton" onclick="window.location = 'dashboard'">Cerrar</button>
										</td>
									</tr>
								<tbody>
							</table>
							
							<!-- Adjuntos -->
							<c:import url="_attachments.jsp"></c:import>
						</div>					
					</div>		
				
				<!-- Signature capture box # 1 -->
				<hidden id="leftSignJSON"></hidden>
				<hidden id="rightSignJSON"></hidden>
				<div id="signCapDialog" title="Capture su firma en el cuadro" class="signBoxDlg">
					<div id="signCapture">
					
					</div>
				</div>
				
				<!-- Signature capture box # 2 -->
				<hidden id="leftSignJSON2"></hidden>
				<hidden id="rightSignJSON2"></hidden>
				<div id="signCapDialog2" title="Capture su firma en el cuadro" class="signBoxDlg">
					<div id="signCapture2">
					
					</div>
				</div>
			</div>
		</form>
	</body>
</html>