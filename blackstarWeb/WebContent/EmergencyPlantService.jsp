<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio planta de emergencia</title>
	
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
								<th>DATOS DEL EQUIPO</th>
							</tr>
						</thead>
						<tr>
							<td>PE MARCA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MOTOR DIESEL MARCA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CAPACIDAD TANQUE DIESEL:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MODELO PE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MODELO MOTOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MODELO BOMBA COMBUSTIBLE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>No SERIE PE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>No. DE SERIE MOTOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>FILTRO DE COMBUSTIBLE. SE CAMBIÓ?:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>TIPO DE TRANSFERENCIA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CPL MOTOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>FILTRO DE ACEITE. SE CAMBIÓ?</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MCA/MODELO TRANSF:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>GENERADOR MCA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>FILTRO DE AGUA. SE CAMBIÓ?:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MCA/MODELO CONTROL:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MODELO GENERADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>FILTRO DE AIRE. SE CAMBIÓ?:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VOLTAJE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>No DE SERIE GENERADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MODELO DE LA MARCHA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MCA/MODELO REGULADOR DE VELOCIDAD:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>POTENCIA (KW) GENERADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MODELO DE BATERÍAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>MCA/MODELO CARGADOR DE BAT:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TENSIÓN GENERADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>LECTURA RELOJ CUENTA HORAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>ULTIMO CAMBIO DE ACEITE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>ULTIMA FECHA DE AFINACIÓN:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>ULTIMO SERVICIO CORRECTIVO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>INSPECCION BASICA</th>
							</tr>
						</thead>
						<tr>
							<td>NIVEL/LIMP/CAMBIO DE ACEITE LUBRICANTE. SE CAMBIÓ?</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>ZAPATAS DE BATERÍA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MANGUERAS COMBUSTIBLE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>NIVEL DE AGUA/ANTICONGELANTE. SE CAMBIÓ?:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SULFATACIÓN BATERÍA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MANGUERAS AGUA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>NIVEL ELECTROLITO BATERÍA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>NIVEL DE COMBUSTIBLE %:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>VÁLVULAS Y TUBERÍAS (CU/NEGRA):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>FUGA EN TUBO DE ESCAPE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>PRECALENTADO DE LA MÁQUINA. TEMPERATURA (MIN 60°):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TENSIÓN DE BANDAS/ESTADO DE ASPAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>SERVICIOS BÁSICOS</th>
							</tr>
						</thead>
						<tr>
							<td>LAVADO DE MOTOR/TANQUE (FUGA):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SOPLETEADO DE TRANSFER:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>PRUEBAS DE BATERÍAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>LAVADO DE RADIADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>LIMPIEZA TARJETAS DE CONTROL:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>REVISIÓN CARGADOR DE BATERÍA/ALTERNADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>LIMPIEZA ÁREA DE TRABAJO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>AJUSTE DE CONEXIONES DE CONTROL:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>PINTURA Y CONSERVACIÓN:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>REVISIÓN DE CABLEADO  Y CONEXIONES:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>REVISIÓN DE EXT/EMBOBINADOS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SOPLETEADO TAB GENERADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>PRUEBAS DINAMICAS MOTOR DE COMBUSTION (Solicitar autorización para pruebas con carga)</th>
							</tr>
						</thead>
						<tr>
							<td>FRECUENCIA EN VACÍO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>VOLTAJE EN VACÍO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TIEMPO DE ARRANQUE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>FRECUENCIA EN CARGA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>VOLTAJE EN CARGA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TIEMPO DE TRANSFERENCIA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>NUM. DE INTENTOS DE ARRANQUE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CALIDAD DE EMISIONES DE HUMO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TIEMPO DE PARO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>PRUEBAS PROTECCIÓN DEL EQUIPO</th>
							</tr>
						</thead>
						<tr>
							<td>SENSOR DE TEMPERATURA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SENSOR DE VOLTAJE O GENERACIÓN:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SENSOR BAJA PRESIÓN DE ACEITE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>SENSOR DE PRESIÓN DEL ACEITE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SENSOR DE SOBRE-VELOCIDAD:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>SENSOR BAJA PRESIÓN DE ACEITE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>INTERRUPTOR DE TRANSFERENCIA AUTOMATICO</th>
							</tr>
						</thead>
						<tr>
							<td>ESTADO MECÁNICA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>AJUSTE DE TORNILLERÍA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>INTERLOCK ELÉCTRICO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>LIMPIEZA DEL TABLERO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>AJUSTE DE CONEXIONES:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>INTERLOCK MECÁNICO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>PRUEBA DE LÁMPARAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>MOTORES DEL SISTEMA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CAPACIDAD EN AMPERES:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>LECTURAS DEL SISTEMA (CON CARGA/SIN CARGA)</th>
							</tr>
						</thead>
						<tr>
							<td>VOLTAJE AB/AN:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CORRIENTE A(AMP):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>FRECUENCIA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>VOLTAJE AC/CN:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CORRIENTE B(AMP):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>PRESIÓN DE ACEITE:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>VOLTAJE BC/BN:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>CORRIENTE C (AMP):</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TEMPERATURA:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>VOLTAJE NT:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>OTROS PARAMETROS</th>
							</tr>
						</thead>
						<tr>
							<td>AJUSTE DEL TERMOSTATO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>VOLTAJE FLOTACIÓN BATERÍAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TIPO DE PROTECCIÓN TRANSFER:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
						<tr>
							<td>AJUSTE DEL TERMOSTATO:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>VOLTAJE FLOTACIÓN BATERÍAS:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
							<td>TIPO DE PROTECCIÓN GENERADOR:</td>
							<td><input id="fechaLlegada" type="text" style="width:95%;" readOnly="true"/></td>
						</tr>
					</table>
					<table>
						<thead>
							<tr>
								<th>Observaciones (HISTORIAL DE ALARMAS CUANDO APLIQUE)</th>
							</tr>
						</thead>
						<tr>
							<td style="height:140px;">
								<textarea id="fldObserv"  readOnly="true" style="width:100%;height:100%;"></textarea>
							</td>
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