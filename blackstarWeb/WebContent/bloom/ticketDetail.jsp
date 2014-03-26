<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
<c:import url="/header.jsp"></c:import>
<html>
<head>
	<script type="text/javascript">
			glow.ready(function(){
				new glow.widgets.Sortable(
					'#content .grid_5, #content .grid_6',
					{
						draggableOptions : {
							handle : 'h2'
						}
					}
				);
			});
		</script>
		<!--[if IE]><![endif]><![endif]-->
	</head>
	<body>
<script type="text/javascript">
Date.prototype.format = function(format) //author: meizz
{
  var o = {
    "M+" : this.getMonth()+1, //month
    "d+" : this.getDate(),    //day
    "h+" : this.getHours(),   //hour
    "m+" : this.getMinutes(), //minute
    "s+" : this.getSeconds(), //second
    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
    "S" : this.getMilliseconds() //millisecond
  }

  if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
    (this.getFullYear()+"").substr(4 - RegExp.$1.length));
  for(var k in o)if(new RegExp("("+ k +")").test(format))
    format = format.replace(RegExp.$1,
      RegExp.$1.length==1 ? o[k] :
        ("00"+ o[k]).substr((""+ o[k]).length));
  return format;
}

function fillText(fld)
{
	var text = [" Se acudio al levantamiento, la persona que acudio a la cita fue el Ing. Jose luis Esteva  pero aun no ha proporcionado la informacion a Carlos Hernandez para que el le de respuesta al cliente, el Ing ahora se encuenta en Nayarit y se hablara con el el lunes "];
	
	return text[fld];
}

</script>
<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_15">					
					<div class="box">
						<h2>Ticket interno</h2>
						<div class="utils">
					
						</div>
						<table>
							<tr>
								<td>Folio:</td>
								<td colspan="3" style="width:200px;"><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${ticketDetail.ticketNumber}"/></td>
								<td>Marca temporal:</td>
								<td><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${ticketDetail.created}"/></td>
							</tr>
							<tr>
								<td>Usuario</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.applicantUserName}"/></td>
								<td>Solicitante</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.applicantAreaName}"/></td>
							</tr>
							<tr>
								<td>Tipo</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.serviceTypeName}"/></td>
								<td>Fecha Limite</td>
								<td><input id="myDate" type="text" style="width:95%;" readOnly="true" value="${ticketDetail.dueDate}"/></td>
							</tr>
							<tr>
								<td>Descripcion de la solicitud</td>
								<td colspan="6">										
									<textarea id="fldSitEnc" style="width:100%;height:100%;" rows="15">${ticketDetail.description}</textarea>
								</td>
							</tr>
							<tr>
								<td>Proyecto</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.project}"/></td>
								<td>Oficina</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.officeName}"/></td>
								<!-- <td></td> -->
							</tr>
							<tr>
								<td>Persona asignada</td>
								<td colspan="7">
								    <input type="text" style="width:95%;" readOnly="true" value="${ticketTeam}"/>
								 </td>
							</tr>
							<tr>
								<td>Fecha y hora de respuesa</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.responseDate}"/></td>
								<td>Desv. fecha solicitada</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.desviation}"/></td>
							</tr>		
							<tr>
								<td>Entrega a tiempo?</td>
								<td><input type="checkbox" style="width:95%;" readOnly="true" checked="${ticketDetail.reponseInTime}"/></td>
							</tr>		
							<tr>
								<td>Calificacion interna</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.evaluation}"/></td>
							</tr>
							<tr>
								<td>Estatus</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.statusName}"/></td>
							</tr>

						</table>
					</div>					
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
				<script type="text/javascript">
					$(document).ready(function () {
						var attCounter = 0;
						
						//Attachment dialog
						$("#attachmentDlg").dialog({
							autoOpen: false,
							height: 270,
							width: 420,
							modal: true,
							buttons: {
								"Aceptar": function() {
									$( this ).dialog( "close" );
									var af = $("#folioAttached").val();
									$("#fldFolio").val(af);
								},
								
								"Cancelar": function() {
								$( this ).dialog( "close" );
							}}
						});
						
						//Save confirm dialog
						$("#saveConfirm").dialog({
							autoOpen: false,
							height: 250,
							width: 380,
							modal: true,
							buttons: {
								"Aceptar": function() {
									$( this ).dialog( "close" );
									window.location = 'dashboard.html';
								},
								
								"Cancelar": function() {
								$( this ).dialog( "close" );
							}}
						});
						
						//History dialog
						$("#historyDlg").dialog({
							autoOpen: false,
							height: 380,
							width: 500,
							modal: true,
							buttons: {
								"Cerrar": function() {
									$( this ).dialog( "close" );
							}}
						});
						
						//Attachment Img dialog
						$("#attachmentImgDlg").dialog({
							autoOpen: false,
							height: 340,
							width: 420,
							modal: true,
							buttons: {
								"Aceptar": function() {
									$( this ).dialog( "close" );
									attCounter++;
									$('#img'+attCounter+'PH').html("<img src='img/bigPdf.png' alt='' />");
									$('#img'+attCounter+'Desc').html($("#attachment option:selected").val());
								},
								
								"Cancelar": function() {
								$( this ).dialog( "close" );
							}}
						});
						
						// Seguimiento$("#seguimientoCapture").hide();
						$("#seguimientoCapture").hide();
					});
					
					function addSeguimiento(){
						var d = new Date(); 
						$("#seguimientoCapture").show();	
						$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Raul:');
						$("#seguimientoText").val('');
					}
					
					function applySeguimiento(){
						var template = '<div class="comment"><p><strong>TIMESTAMP: Raul: WHO</strong></p><p><small>MYCOMMENT</small></p></div>';
						var d = new Date(); 
						var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
						content = content.replace('MYCOMMENT', $("#seguimientoText").val());
						content = content.replace('WHO', $("#who option:selected").val());
						var currSegContent = $("#seguimientoContent").html();
						currSegContent = currSegContent + content;
						$("#seguimientoContent").html(currSegContent);
						$("#seguimientoCapture").hide();
					}
					
					function cancelAddSeguimiento(){
						$("#seguimientoCapture").hide();
					}
					
					function fillSeguimiento(){
						$("#seguimientoText").val('Se conocen los precios de los fletes y el precio unitario de unas de las baterias esprando el precio que falta. Ya fue enviado via correo el precio que faltaba.');
					}
				</script>
				<div class="grid_15">
					<div class="box">
						<h2>Seguimiento</h2>
							<table id="seguimientoTable">
								<thead>
									<th>Seguimiento</th>
								</thead>
									<tr>
										<td id="seguimientoContent">
										</td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label>
											</div>
											<div> Asignar a:
												<select id="who" style="width:200px;">
													<option value="Alberto Lopez Gomez">Alberto Lopez Gomez</option>
													<option value="Alejandra Diaz">Alejandra Diaz</option>
													<option value="Alejandro Monroy">Alejandro Monroy</option>
													<option value="Angeles Avila">Angeles Avila</option>
													<option value="Armando Perez Pinto">Armando Perez Pinto</option>
													<option value="Gonzalo Ramirez">Gonzalo Ramirez</option>
													<option value="Jose Alberto Jonguitud Gallardo">Jose Alberto Jonguitud Gallardo</option>
													<option value="Marlem Samano">Marlem Samano</option>
													<option value="Martin Vazquez">Martin Vazquez</option>
													<option value="Reynaldo Garcia">Reynaldo Garcia</option>
													<option value="Sergio  Gallegos">Sergio  Gallegos</option>
												</select>
												<p></p>
												<textarea id="seguimientoText" rows="5" style="width:65%;" onclick="fillSeguimiento();"></textarea>
												<button class="searchButton" onclick="applySeguimiento();">Agregar</button>
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
										</td>
									</tr>
								<tbody>
							</table>
							<table id="attachments">
								<thead>
									<tr>
										<th colspan="3">Archivos Adjuntos</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td id="img1PH" style="width:150px;"></td>
										<td id="img2PH" style="width:150px;"></td>
										<td id="img3PH" style="width:150px;"></td>
									</tr>
									<tr>
										<td id="img1Desc"></td>
										<td id="img2Desc"></td>
										<td id="img3Desc"></td>
									</tr>
									<tr>
										<td colspan="2"><button class="searchButton" onclick="$('#attachmentImgDlg').dialog('open');">Adjuntar Archivo</button></td>
									</tr>
								</tbody>
							</table>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="$('#saveConfirm').dialog('open');">Resolver Ticket</button>
										</td>
									</tr>
								<tbody>
							</table>
					</div>					
				</div>				
<!--   ~ CONTENT COLUMN   -->
				
				<!-- Attachment section -->
				<div id="attachmentDlg" title="Importar orden de servicio">
					<p>Número de Folio: <input type="text" id="folioAttached"/></p>
					<p></p>
					<p>Seleccione el archivo que desea adjuntar</p>
					<input type="file" name="somename" size="80"/> 
					<p></p>
					<p>Seleccione la entrada que corresponde al archivo</p>
					<select name="entrada" id="entrada">
						<option value="">Cedula de costos</option>
						<option value="">Cedula de proyectos</option>
						<option value="">CheckList de levantamiento</option>
						<option value="">Floor Map</option>
						<option value="">Hoja de visita</option>
					</select>
				</div>
				
				<!-- Attachment Img section -->
				<div id="attachmentImgDlg" title="Adjuntar archivo">
					<p></p>
					<p>Seleccione el archivo que desea adjuntar</p>
					<input type="file" name="somename" size="80"/> 
					<p>Seleccione la entrada que corresponde al archivo</p>
					<select name="attachment" id="attachment">
						<option value="Cedula de costos">Cedula de costos</option>
						<option value="Cedula de proyectos">Cedula de proyectos</option>
						<option value="CheckList de levantamiento">CheckList de levantamiento</option>
						<option value="Encuesta de satisfaccion">Encuesta de satisfaccion</option>
						<option value="Floor Map">Floor Map</option>
						<option value="Hoja de visita">Hoja de visita</option>
						<option value="Imagenes 3D del site">Imagenes 3D del site</option>
						<option value="Validacion de proyecto">Validacion de proyecto</option>
						<option value="Propuesta de unifilar">Propuesta de unifilar</option>
					</select>

				</div>
				
				<div id="saveConfirm" title="Cerrar Ticket SAC45">
					<p>¿Confirma que desea cerrar las acciones pendientes en el ticket SAC45?</p>
					<p>El ticket será asignado al personal de mesa de ayuda para su revision</p>
				</div>
				
<!--   ~ CONTENT   -->
			</div>
			
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
</body>
</html>