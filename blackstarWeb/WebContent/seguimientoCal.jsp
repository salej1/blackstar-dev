<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
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
	function showBigTable(){

		var bigTicketStr = '${ ticketsList }';

		try{
			var data = $.parseJSON(bigTicketStr);
		}
		catch(e){
alert(e);	
		}
		$('#bigTicketsTable').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 50,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": data,
			"sDom": '<"top"if>rt<"bottom"lp><"clear">',
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
												var outerTemplate = '<div onclick="addSeguimiento('+ row.DT_RowId + ');">INNER_TEMPLATE</div>';
												var template = '<div class="comment"><p><strong>TIMESTAMP: FROM a: WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
												var d = new Date(); 
												var content = "";
												var buffer = "";
												
												for(var i = 0; i < rawData.length; i++){
													d = new Date(rawData[i].created);
													content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
													content = content.replace('FROM', rawData[i].createdBy);
													content = content.replace('WHO', rawData[i].asignee);
													content = content.replace('MYCOMMENT', rawData[i].followUp);
													
													buffer = buffer + content;
												}
												
												buffer = outerTemplate.replace("INNER_TEMPLATE", buffer);
												
												return buffer;
											
											}, "aTargets" : [25]},
							  {"mRender" : function(data, type, row){return "<a href='osDetail?' class='edit' onclick='javascript: closeTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [27]},	    		    	       
							  {"mRender" : function(data, type, row){return "<a href='#' class='edit' onclick='javascript: assignTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]}	    		    	       
							 ]}
		);
alert('se asigna json');
	}
		
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
			
			
<!--   CONTENT COLUMN   -->		
				
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
						</tbody>
					</table></div>	
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT ADDS  -->
			<script type="text/javascript">
				$(function() {
					
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
					alert('calling showBigTable');
					showBigTable();
				});
				
				// Seguimiento
				function addSeguimiento(ticketId){
					var d = new Date(); 
					$("#seguimientoCaptureDlg").dialog('open');	
					$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Marelem Samano:');
					$("#seguimientoText").val('');
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
			
			<!-- Filter Section -->
			<div id="filterDlg" title="Filtrar">
				<small id="filterLabel"></small><input id="fldFilter" type="text" style="width:90%" onkeypress="if(event.keyCode == 13){$('#filterDlg').dialog('close'); return false;}"></input>
			</div>
			
			<div id="cerrarOSCapture" title="Cerrar Ticket 12-34">
				<p>Por favor seleccione la OS que cierra el ticket:</p>
				<select style="width:90%">
					<c:forEach var="os" items="${potentialOs}">
						<option value = "${os.key}">${os.value}</option>
					</c:forEach>
				</select>
				<p>&nbsp;</p>
			</div>
			
			<div id="seguimientoCaptureDlg" title="Seguimiento a ticket ">
				<div>
					<Label id="seguimientoStamp">stamp</Label>
				</div>
				<div> Asignar a:
					<select id="employeeSelect">
						<c:forEach var="employee" items="${employees}">
							<option value = "${employee.key}">${employee.value}</option>
						</c:forEach>
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