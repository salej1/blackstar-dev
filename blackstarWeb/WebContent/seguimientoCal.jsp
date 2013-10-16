<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="seguimiento" />
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="css/jquery-ui.min.css"/>
<script src="js/jquery-1.10.1.min.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<script type="text/javascript">
	var bigTicketStr = ${ ticketsList };

	var data = $.parseJSON(bigTicketStr);
		
	$('#bigTicketsTable').dataTable({	    		
		"bProcessing": true,
		"bFilter": true,
		"bLengthChange": false,
		"iDisplayLength": 50,
		"bInfo": false,
		"sPaginationType": "full_numbers",
		"aaData": data,
		"sDom": '<"top"i>rt<"bottom"flp><"clear">',
		"aoColumns": [
					  { "mData": "created" },
					  { "mData": "createdBy" },
					  { "mData": "contactName" },
					  { "mData": "contactPhone" },
					  { "mData": "contactEmail" },
					  { "mData": "serialNumber" },
					  { "mData": "observations" },
					  { "mData": "customer" },
					  { "mData": "equipmentType" },
					  { "mData": "brand" },
					  { "mData": "model" },
					  { "mData": "capacity" },
					  { "mData": "responseTimeHr" },
					  { "mData": "solutionTimeHr" },
					  { "mData": "equipmentAddress" },
					  { "mData": "equipmentLocation" },
					  { "mData": "includesParts" },
					  { "mData": "exceptionParts" },
					  { "mData": "serviceCenter" },
					  { "mData": "office" },
					  { "mData": "project" },
					  { "mData": "ticketNumber" },
					  { "mData": "phoneResolved" },
					  { "mData": "arrival" },
					  { "mData": "responseTimeDeviationHr" },
					  { "mData": "followUp" },
					  { "mData": "closed" },
					  { "mData": "serviceOrderNumber" },
					  { "mData": "employee" },
					  { "mData": "solutionTime" },
					  { "mData": "solutionTimeDeviationHr" },
					  { "mData": "ticketStatus" },
					  { "mData": "Cerrar" }

				  ],
		"aoColumnDefs" : [{"mRender" : function(rawData, type, row){
									
											var template = '<div class="comment"><p><strong>TIMESTAMP: FROM a: WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
											var d = new Date(); 
											var content = "";
											var buffer = "";
											
											for(int i = 0; i < rawData.length; i++){
												d = new Date(rawData[i].created);
												content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
												content = content.replace('FROM', rawData[i].createdBy);
												content = content.replace('WHO', rawData[i].asignee);
												content = content.replace('MYCOMMENT', rawData[i].followUp);
												
												buffer = buffer + content;
											}
											
											return buffer;
										
										}, "aTargets" : [25]},
						  {"mRender" : function(data, type, row){return "<a href='osDetail?' class='edit' onclick='javascript: closeTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [27]},	    		    	       
						  {"mRender" : function(data, type, row){return "<a href='#' class='edit' onclick='javascript: assignTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]},	    		    	       
						 ]}
	);
		
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
<!--   CONTENT   -->
			
			
<!--   CONTENT COLUMN   -->		
				<div class="grid_16">	
					<p></p>
				</div>
				
				<a href="/seguimiento?type=small">Ver tabla resumida</a>
				<p></p>
				
				<div class="box">
					<h2>Tickets por revisar</h2>
					<div class="utils">
						
					</div>
					<div class="bigtableContainer">
					<table id = "bigTicketsTable" style="width:6000px;">
						<thead>
							<tr>
								<th>Marca temporal</th>
								<th>Nombre usuario</th>
								<th>Contacto</th>
								<th>Telefóno Contacto</th>
								<th>E-mail</th>
								<th>Número de serie</th>
								<th>Observaciones</th>
								<th>Cliente</th>
								<th>Equipo</th>
								<th>Marca</th>
								<th>Modelo</th>
								<th>Cap.</th>
								<th>T. Resp. Comp.</th>
								<th>T. Sol. Comp./th>
								<th>Direccion</th>
								<th>Ubicacion</th>
								<th>Incluye Partes</th>
								<th>Excepcion Partes</th>
								<th>Centro Servicio</th>
								<th>Oficina</th>
								<th>Proyecto</th>
								<th>Ticket</th>
								<th>Solucion Tel.</th>
								<th>FH Llegada</th>
								<th>Desviación TR</th>
								<th>Seguimiento</th>
								<th>Cierre</th>
								<th>Numero Reporte</th>
								<th>Ingeniero</th>
								<th>TS en HR</th>
								<th>Desviación</th>
								<th>Estatus</th>
								<th>Cerrar Ticket</th>
							</tr>
						</thead>							
						<tbody>
							<tr>
								<td style="width:120px;">6/5/2013 9:16:10</td>
								<td>marlem.samano@gposac.com.mx</td>
								<td>Roberto Alvarado</td>
								<td>9933103500 ext 33811</td>
								<td>roberto.alvarado@pemex.com</td>
								<td>QE0534154120</td>
								<td style="width:350px;">UPS ESTA ALARMADO POR ALTA TEMPERATURA</td>
								<td>PEMEX</td>
								<td style="width:100px;">UPS</td>
								<td>APC</td>
								<td>SL80KF</td>
								<td style="width:80px;">80</td>
								<td style="width:180px;">6</td>
								<td style="width:180px;">12</td>
								<td style="width:350px;">Carretera Villahermosa a Reforma Chiapas s/n. Poblado Luis Gil Perez.  Municipio Centro, CP86000. Villahermosa Tabasco CPG Nuevo Pemex</td><td>NUEVO PEMEX</td>
								<td style="width:150px;">SI</td>
								<td>BATERIAS</td>
								<td style="width:140px;">Villahermosa IS</td>
								<td style="width:100px;">MXO</td>
								<td style="width:100px;">CM150</td>
								<td style="width:130px;">13-145</td>
								<td style="width:100px;">NO</td>
								<td style="width:150px;">6/5/2013</td>
								<td style="width:100px;">15.27</td>
								<td style="width:530px;" id="editSeguimiento" onclick="addSeguimiento();"><div class="comment" id="?">"Este reporte será tendido por Erik Lugo Aguilar el día de hoy.Ya está en el activo. la falla de este equipo es provocada por que el módulo de los ventiladores se encuentra dañado y ocupa sustitución modelo OG-0901311. El fabricante es APC y el modelo es SL80KF."</div></td>
								<td style="width:100px;" id="myFHCierre"></td>
								<td style="width:150px;"></td>
								<td style="width:100px;"></td>
								<td style="width:100px;"></td>
								<td style="width:100px;">-347.91</td>
								<td id="myStatus">RETRASADO
								<td style="width:100px;"><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td>
							</tr>						
						</tbody>
					</table></div>	
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT ADDS  -->
			<script type="text/javascript">
				$(function() {
					$("#estatusChgDlg").dialog({
						autoOpen: false,
						height: 220,
						width: 320,
						modal: true,
						buttons: {
							"Aceptar": function() {
								var newStatus = $("#selectStatus").val();
								$("#tickStatus").html(newStatus);
								$( this ).dialog( "close" );
							},
							
							"Cancelar": function() {
							$( this ).dialog( "close" );
						}}
					});
					
					$("#cerrarOSCapture").dialog({
						autoOpen: false,
						height: 240,
						width: 300,
						modal: true,
						buttons: {
							"Aceptar": function() {
								$("#myStatus").html("CERRADO");
								$("#myFHCierre").html("11/07/2013 10:35:22");
								$( this ).dialog( "close" );
							},
							
							"Cancelar": function() {
							$( this ).dialog( "close" );
						}}
					});
					
					$("#filterDlg").dialog({
						autoOpen: false,
						height: 150,
						width: 200,
						modal: true,
						buttons: {
							"Aceptar": function() {
								$( this ).dialog( "close" );
							},
							
							"Cancelar": function() {
							$( this ).dialog( "close" );
						}}
					});
					
					$("#seguimientoCaptureDlg").dialog({
						autoOpen: false,
						height: 320,
						width: 480,
						modal: true,
						buttons: {
							"Agregar": function() {
								applySeguimiento();
								$( this ).dialog( "close" );
							},							

							
							"Cancelar": function() {
							$( this ).dialog( "close" );
						}}
					});
				});
				
				function filtrar(field){
					$("#fldFilter").val("");
					$("#filterLabel").html(field);
					$("#filterDlg").dialog('open');
					$("#fldFilter").focus();
				}
				
				// Seguimiento
				function addSeguimiento(){
					var d = new Date(); 
					$("#seguimientoCaptureDlg").dialog('open');	
					$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Marelem Samano:');
					$("#seguimientoText").val('');
				}
				
				function applySeguimiento(){
					var template = '<div class="comment"><p><strong>TIMESTAMP: Marlem Samano WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
					var d = new Date(); 
					var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
					content = content.replace('MYCOMMENT', $("#seguimientoText").val());
					var who =  $("#seguimientoWho").val();
					if(who != ""){
						content = content.replace('WHO', " a: " + who);
					}
					else{
						content = content.replace('WHO', "");
					}
					var segContent = $("#editSeguimiento").html();
					segContent = segContent + content;
					
					$("#editSeguimiento").html('\n\r' + segContent);
				}
				
				function cancelAddSeguimiento(){
					$("#seguimientoCapture").hide();
				}
				
				function fillSeguimiento(){
					$("#seguimientoText").val('Se encuentro equipo apagado y la carga  que tenía conectada a tomas de corriente.');
				}
				
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
			</script>
			<!-- Change Status section -->
			<div id="estatusChgDlg" title="Cambiar estatus de ticket">
				<p>Seleccione el estatus del ticket<label>13-40:</label></p>
				<select id="selectStatus">
					<option>Abierto</option>
					<option>Retrasado</option>
					<option>Cerrado</option>
					<option>Cerrado FT</option>
				</select>
			</div>

			
			<!-- Filter Section -->
			<div id="filterDlg" title="Filtrar">
				<small id="filterLabel"></small><input id="fldFilter" type="text" style="width:90%" onkeypress="if(event.keyCode == 13){$('#filterDlg').dialog('close'); return false;}"></input>
			</div>
			
			<div id="cerrarOSCapture" title="Cerrar Ticket 12-34">
				<p>Por favor seleccione la OS que cierra el ticket:</p>
				<select style="width:90%">
					<option>3042</option>
					<option>3151</option>
					<option>UPS-Q0251</option>
					<option>3857</option>
					<option>3952</option>
					<option>3953</option>
					<option>3954</option>
					<option>OS-0016</option>
					<option>OS-0018</option>
					<option>OS-0017</option>
					<option>OS-0019</option>
					<option>UPS-0003</option>
					<option>BB-0001</option>
					<option>OS-0652</option>
				</select>
				<p>&nbsp;</p>
			</div>
			
			<div id="seguimientoCaptureDlg" title="Seguimiento a ticket 13-145">
				<div>
					<Label id="seguimientoStamp">stamp</Label>
				</div>
				<div> Asignar a:
					<select id="seguimientoWho" style="width:200px;">
						<option></option>
						<option>Alberto Lopez Gomez</option>
						<option>Alejandra Diaz</option>
						<option>Alejandro Monroy</option>
						<option>Marlem Samano</option>
						<option>Armando Perez Pinto</option>
						<option>Gonzalo Ramirez</option>
						<option>Jose Alberto Jonguitud Gallardo</option>
						<option>Marlem Samano</option>
						<option>Martin Vazquez</option>
						<option>Reynaldo Garcia</option>
						<option>Sergio  Gallegos</option>
					</select>
					<p></p>
					<textarea id="seguimientoText" rows="5"cols="50" onclick="fillSeguimiento();"></textarea>
				</div>
			</div>
			
<!--   ~ CONTENT ADDS  -->

<!--   ~ CONTENT   -->
			
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
<!--   ~ FOOTER   -->
	</body>
</html>