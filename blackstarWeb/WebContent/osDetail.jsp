<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />

<c:import url="header.jsp"></c:import>
<html>
<head>
<title>Detalle orden servicio</title>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script src="js/glow/1.7.0/core/core.js" type="text/javascript"></script>
		<script src="js/glow/1.7.0/widgets/widgets.js" type="text/javascript"></script>
		<script src="js/jquery-1.10.1.min.js"></script>
		<script src="js/jquery-ui.js"></script>
		<script src="js/jquery.ui.touch-punch.min.js"></script>
		<script src="js/jquery.ui.core.js"></script>
		<script src="js/jquery.ui.widget.js"></script>
		<script src="js/jquery.ui.mouse.js"></script>
		<script src="js/jquery.ui.button.js"></script>
		<script src="js/jquery.ui.draggable.js"></script>
		<script src="js/jquery.ui.position.js"></script>
		<script src="js/jquery.ui.resizable.js"></script>
		<script src="js/jquery.ui.button.js"></script>
		<script src="js/jquery.ui.dialog.js"></script>
		<script src="js/jquery.ui.effect.js"></script>
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

	});

	$("#seguimientoCapture").hide();
					
					function addSeguimiento(){
						var d = new Date(); 
						$("#seguimientoCapture").show();	
						$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss')+ ', ');
						$("#seguimientoText").val('');
					}
					
				function ocultarSeguimiento(){
						//funcion de guardar followup
						var comentario =  $("#seguimientoText").val();
						var asignado = $("#AsignadoASelect").val();
	
						$.ajax({
								type: form.attr('method'),
								url: form.attr('action'),
								data: form.serialize(),
								success: function (data) {var result=data;$('#result').attr("value",result);}
							});
						
						$("#seguimientoCapture").hide();
					}
	

					
	 				
	
 </script> 

	 
</head>
<body>

<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">	
					<p>
						Coordinador: <input  id="lbCoordinador" type="text" style="width:95%;" readOnly="true" />
					</p>
				</div>
				<div class="grid_15">					
					<div class="box">
						<h2>Orden de servicio</h2>
						<div class="utils">
							<a id="linkTicket" href="tickDetail.html"> </a>
						</div>
						<table>
							<tr>
								<td>Folio:</td>
								<td><input  id="lbFolio" type="text" style="width:95%;" readOnly="true" /></td>
								<td colspan="2"><small><a href="#" onclick="window.open('img/UPSPreview.png', '_blank'); return false;">Ver PDF</a></small>
									<img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/>
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
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
				<div class="grid_15">
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
							<p><label>&nbsp;</label></p>
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
							<table id="seguimientoTable">
								<thead>
									<th>Seguimiento</th>
								</thead>
									<tr>
										<td id="seguimientoContent">
											<c:if test="ComentariosOS">
												<c:forEach var="followup" items="${ComentariosOS} }">
													<div class="comment">
														<p>
															<strong> <c:out value=" "/> <c:out value=" "/>  </strong>
														</p>
														<p>
															<small> <c:out value=" "/> </small>
														</p>
													</div>
												</c:forEach>
											</c:if>
										</td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label> 
											</div>
											<div> Asignar a:
												<select id="AsignadoASelect" style="width:200px;">												
													<c:forEach var="usuario" items="${UsuariosAsignados}">
														<option>usuario</option>
													</c:forEach>
												</select>
												<p></p>
												<textarea id="seguimientoText" rows="5" style="width:65%;" ></textarea> 
												<button id="EnviarComentario"   class="searchButton" >Agregar</button>
												<button class="searchButton" onclick="cancelAddSeguimiento();">Cancelar</button>
											</div>
										</td>
									</tr>
							</table>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="addSeguimiento();">Agregar seguimiento</button>
											<button class="searchButton" onclick="window.location = 'dashboard_coo.html'">Cerrar</button>
										</td>
									</tr>
								<tbody>
							</table>
					</div>					
				</div>				
<!--   ~ CONTENT COLUMN   -->

				
				<!-- Signature capture box # 1 -->
				<input type="hidden" id="leftSignJSON" />
				<!-- Signature capture box # 2 -->
				<input type="hidden" id="rightSignJSON" />
				
				
<!--   ~ CONTENT   -->
			</div>
		


</body>
</html>