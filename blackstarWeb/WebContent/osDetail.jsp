<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>

<body>

<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">	
					<p>${servicioOrderDetail.Usuario}</p>
				</div>
				<div class="grid_15">					
					<div class="box">
						<h2>Orden de servicio</h2>
						<div class="utils">
							<a href="tickDetail"> Consultar Ticket ${servicioOrderDetail.TicketNo} </a>
						</div>
						<table>
							<tr>
								<td>Folio:</td>
								<td> <input id="FolioOS" type="text" style="width:95%;" readOnly="true"/>${servicioOrderDetail.Folio} </td>
								<td colspan="2"><small><a href="#" onclick="window.open('img/UPSPreview.png', '_blank'); return false;">Ver PDF</a></small>
									<img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/>
								</td>
							</tr>
							<tr>
								<td>Cliente</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Cliente}</td>
								<td>No Ticket</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="13-152"/></td>
							</tr>
							<tr>
								<td>Domicilio</td>
								<td colspan="5"><textarea style="width:95%;height:50px;">${servicioOrderDetail.Domicilio}</textarea></td>
								<td>Fecha y hora de llegada</td>
								<td><input id="myDate" type="text" style="width:95%;" readOnly="true"/>${servicioOrderDetail.serviceDate}</td>
							</tr>
							<tr>
								<td>Solicitante</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Solicitante}</td>
								<td>Telefono</td>
								<td><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Telefono}</td>
							</tr>
							<tr>
								<td>Equipo</td>
								<td><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Equipo}</td>
								<td style="padding-left:10px;">Marca</td>
								<td><input type="text" style="width:95%;" readOnly="true"/>${servicioOrderDetail.Marca}</td>
								<td>Modelo</td>
								<td><input type="text" style="width:95%;" readOnly="true"/>${servicioOrderDetail.Modelo}</td>
								<td>Serie</td>
								<td><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Serie}</td>
								
							</tr>
							<tr>
								<td>Reporte de falla</td>
								<td colspan="7"><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Falla}</td>
							</tr>
							<tr>
								<td>Tipo de servicio</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.TipoServicio}</td>
								<td>Contrato/Proyecto</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.Contrato}</td>
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
										<textarea  readOnly="true" style="width:100%;height:100%;">${servicioOrderDetail.Situacion}</textarea>
									</td>
									<td rowspan="3" style="height:100px;">
										<textarea   readOnly="true" style="width:100%;height:100%;">${servicioOrderDetail.Trabajos}</textarea>
									</td>
								</tr>
								<thead>
									<tr>
										<th>Parametros tecnicos</th>
									</tr>
								</thead>
								<tr>
									<td style="height:100px;">
										<textarea  readOnly="true" style="width:100%;height:100%;">${servicioOrderDetail.Parametros}</textarea>
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
										<textarea  readOnly="true" style="width:100%;height:100%;">${servicioOrderDetail.Material}</textarea>
									</td>
								</tr>
								<thead>
									<tr>
										<th>Observaciones / Estatus del equipo</th>
									</tr>
								</thead>
								<tr>
									<td style="height:140px;">
										<textarea readOnly="true" style="width:100%;height:100%;">${servicioOrderDetail.Observaciones}</textarea>
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
									<td>Nombre</td><td><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.NombreRealizo}</td>
									<td>Nombre</td><td><input type="text" style="width:95%;"readOnly="true" />${servicioOrderDetail.NombreRecibido}</td>
								</tr>
								<tr>
									<td>Fecha y hora de salida</td><td><input id="myDate2" type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.FechaSalida}</td>
									<td>Puesto</td><td><input type="text" style="width:95%;" readOnly="true" />${servicioOrderDetail.PuestoRecibio}</td>
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
											<c:forEach var="Followup" items="${ComentariosOS} }">
												<div class="comment">
													<p>
														<strong>Followup.created + ":" +Followup.createdByUsr</strong>
													</p>
													<p>
														<small>Followup.followup</small>
													</p>
												</div>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label> <Label>${servicioOrderDetail.Usuario}</Label>
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

				<script type="text/javascript">
					$(document).ready(function () {
						 $('#fldSitEnc').val(fillText(0));
						 $('#fldTrabReal').val(fillText(1));
						 $('#fldReq').val(fillText(2));
						 $('#fldObserv').val(fillText(3));
						 
						// Signature capture box # 1 
						$('#leftSign').signature({disabled: true}); 
						$('#leftSign').signature('draw', $('#leftSignJSON').val()); 

						// Signature capture box # 2 
						$('#rightSign').signature({disabled: true}); 
						$('#rightSign').signature('draw', $('#rightSignJSON').val()); 

					});
				
				// Seguimiento
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

				$(document).ready(function() {                        
	                $('#"EnviarComentario"').click(function(event) 
	    	                {  
	                    		var cadenaComentario= $('#seguimientoText').val() + '&&' +$("#AsignadoASelect").val() + '&&' +$("#FolioOS");
	                	 		$.get('osDetail', {datosComentario:cadenaComentario}, function(responseText) 
   	                	 		{ 
	                	 			$("#seguimientoCapture").hide();
                   				});
                			});
	            });
				
				
				</script>
				<!-- Signature capture box # 1 -->
				<input type="hidden" id="leftSignJSON" />${servicioOrderDetail.signCreated}
				<!-- Signature capture box # 2 -->
				<input type="hidden" id="rightSignJSON" />${servicioOrderDetail.signReceivedBy}
				
				
<!--   ~ CONTENT   -->
			</div>
		


</body>
</html>