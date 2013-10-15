<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
    	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    	<title>Grupo SAC</title>
		<link rel="stylesheet" href="css/960.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="css/template.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="css/colour.css" type="text/css" media="screen" charset="utf-8" />
		<!--[if IE]><![if gte IE 6]><![endif]-->
		<script src="js/glow/1.7.0/core/core.js" type="text/javascript"></script>
		<script src="js/glow/1.7.0/widgets/widgets.js" type="text/javascript"></script>
		<link href="js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
		<link rel="stylesheet" href="css/jquery.ui.theme.css">
		<link rel="stylesheet" href="css/jquery-ui.min.css">
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
<!--   HEADER   -->
		<h1 id="head">
			<div class="logo">
				<img alt="Grupo Sac" src="img/grupo-sac-logo.png" border="0"/>
			</div>
			<span class="slogan">Portal de servicios</span>
		</h1>
		
		<ul id="navigation">
			<li><a href="dashboard_coo.html">Inicio</a></li>
			<li><a href="tickets_cooadm.html">Tickets</a></li>
			<li><a href="ordenesServicio_coo.html">Ordenes de servicio</a></li>
			<li><span class="active">Seguimiento</span></li>
			<li><a href="encuestas.html">Encuestas de servicio</a></li>
			<li><a href="indicadores.html">Indicadores Serv.</a></li>
			<li><span style="width:15px;"></span></li>
			<li><input type="text"/></li>
			<li><small>&nbsp;</small></li>
			<li><input type="submit" value="Buscar" class="searchButton" onclick="window.location = 'resultadoBusqueda.html'"/></li>
		</ul>
<!--   ~ HEADER   -->

<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->		
				<div class="grid_16">	
		
				</div>
				<div class="grid_16">
					<div class="box">
						<h2>Tickets Retrasados</h2>
						<div class="utils">
						
						</div>
						<table>
							<thead>
								<tr>
									<th style="width:60px;">Ticket</th>
									<th>Fecha/Hora</th>
									<th>Cliente</th>
									<th>Equipo</th>
									<th style="width:70px;">Tiem. R</th>
									<th>Proyecto</th>
									<th>Estatus</th>
									<th>Asignar</th>
								</tr>
							</thead>
							<tbody>
								<tr id="hideMeRow"><td><small><a href="tickDetail_cal.html">13-40</small></td><td><small>02/09/2013 17:30</small></td><td><small>GOBIERNO DEL ESTADO DE GUANAJUATO</small></td><td><small>WE0247110050</small></td><td><small>24</small></td><td><small>CQ345</small></td><td id="tickStatus" onclick="$('#estatusChgDlg').dialog('open')";>Abierto</td><td><small><a href="#" class="edit" onclick="$('#tktAssignDlg').dialog('open'); return false;">Asignar</a></small></td></tr>
								<tr><td><small><a href="tickDetail_cal.html">13-41</small></td><td><small>02/12/2013 11:21</small></td><td><small>PEMEX</small></td><td><small>2009-4727-A</small></td><td><small>24</small></td><td><small>CM150</small></td><td onclick="$('#estatusChgDlg').dialog('open')";>Retrasado</td><td><small><a href="#" class="edit" onclick="$('#tktAssignDlg').dialog('open'); return false;">Asignar</a></small></td></tr>
								<tr><td><small><a href="tickDetail_cal.html">13-42</small></td><td><small>02/12/2013 11:23</small></td><td><small>PEMEX</small></td><td><small>PD0633160048</small></td><td><small>6</small></td><td><small>CM150</small></td><td onclick="$('#estatusChgDlg').dialog('open')";>Retrasado</td><td><small><a href="#" class="edit" onclick="$('#tktAssignDlg').dialog('open'); return false;">Asignar</a></small></td></tr>							
							</tbody>
						</table>
						Buscar:<input type="text"/>
					</div>
					<div class="box">
						<h2>Tickets Abiertos</h2>
						<div class="utils">
						
						</div>
						<table>
							<thead>
								<tr>
									<th style="width:60px;">Ticket</th>
									<th>Fecha/Hora</th>
									<th>Cliente</th>
									<th>Equipo</th>
									<th style="width:70px;">Tiem. R</th>
									<th>Proyecto</th>
									<th>Estatus</th>
									<th>Asignar</th>
								</tr>
							</thead>
							<tbody>
								<tr><td><small><a href="tickDetail_cal.html">13-40</small></td><td><small>02/09/2013 17:30</small></td><td><small>GOBIERNO DEL ESTADO DE GUANAJUATO</small></td><td><small>WE0247110050</small></td><td><small>24</small></td><td><small>CQ345</small></td><td id="tickStatus" onclick="$('#estatusChgDlg').dialog('open')";>Abierto</td><td><small><a href="#" class="edit" onclick="$('#tktAssignDlg').dialog('open'); return false;">Asignar</a></small></td></tr>
								<tr><td><small><a href="tickDetail_cal.html">13-41</small></td><td><small>02/12/2013 11:21</small></td><td><small>PEMEX</small></td><td><small>2009-4727-A</small></td><td><small>24</small></td><td><small>CM150</small></td><td onclick="$('#estatusChgDlg').dialog('open')";>Abierto</td><td><small><a href="#" class="edit" onclick="$('#tktAssignDlg').dialog('open'); return false;">Asignar</a></small></td></tr>
								<tr><td><small><a href="tickDetail_cal.html">13-42</small></td><td><small>02/12/2013 11:23</small></td><td><small>PEMEX</small></td><td><small>PD0633160048</small></td><td><small>6</small></td><td><small>CM150</small></td><td onclick="$('#estatusChgDlg').dialog('open')";>Abierto</td><td><small><a href="#" class="edit" onclick="$('#tktAssignDlg').dialog('open'); return false;">Asignar</a></small></td></tr>							
							</tbody>
						</table>
						Buscar:<input type="text"/>

					</div>
					<div class="box">
						<h2>Pendientes</h2>
						<div class="utils">
					
						</div>
						<table>
							<thead>
								<tr>
									<th>Folio</th>
									<th></th>
									<th>Ticket</th>
									<th>Tipo</th>
									<th>Fecha</th>
									<th>Cliente</th>
									<th>Equipo</th>
									<th>Proyecto</th>
									<th>Oficina</th>
									<th>Resp.</th>
									<th>Desc.</th>
								</tr>
							</thead>
							<tbody>
								<tr><td style="width:80px;"><small><a href="osDetail.html">UPS-Q0251</a></small></td><td><img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/></td><td style="width:70px;"><small><a href="tickDetail_cal.html">13-7</a></small></td><td><small>Correctivo</small></td><td><small>10/01/2013</small></td><td><small>PEMEX GAI</small></td><td><small>UPS</small></td><td><small>CM150</small></td><td><small>QRO</small></td><td><small>Alejandro Monroy</small></td><td><small>El mantenimiento se realizará una vez que el equipo cuente con baterías</small></td></tr>
								<tr><td><small><a href="osDetail.html">AA-Q0172</a></small></td><td><img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/></td><td><small><a href="tickDetail_cal.html">NA</a></small></td><td><small>Preventivo</small></td><td><small>12/01/2013</small></td><td><small>PEMEX GAI</small></td><td><small>AA</small></td><td><small>CM150</small></td><td><small>QRO</small></td><td><small>Gonzalo Ramirez</small></td><td><small>Se envia reorte a consultor para la cotización de las mismas || Cotización 435</small></td></tr>
								<tr><td><small><a href="osDetail.html">3857</a></small></td><td><img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/></td><td><small><a href="tickDetail_cal.html">12-29</a></small></td><td><small>Instalación</small></td><td><small>12/01/2013</small></td><td><small>PEMEX GAI</small></td><td><small>UPS</small></td><td><small>CM150</small></td><td><small>QRO</small></td><td><small>Martin Vazquez</small></td><td><small>Ya se solicito cotización a Consultor</small></td></tr>
							</tbody>
						</table>
						Buscar:<input type="text"/>
					</div>
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
					
					$("#tktAssignDlg").dialog({
						autoOpen: false,
						height: 200,
						width: 260,
						modal: true,
						buttons: {
							"Aceptar": function() {
								$("#hideMeRow").hide();
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
				});
				
				function filtrar(field){
					$("#fldFilter").val("");
					$("#filterLabel").html(field);
					$("#filterDlg").dialog('open');
					$("#fldFilter").focus();
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
			
			<!-- Assign Ticket section -->
			<div id="tktAssignDlg" title="Asignar Ticket">
				<p>Asignar ticket<label>13-40:</label></p>
				<select id="selectStatus">
					<option>Alberto Lopez Gomez</option>
					<option>Alejandra Diaz</option>
					<option>Alejandro Monroy</option>
					<option>Angeles Avila</option>
					<option>Armando Perez Pinto</option>
					<option>Gonzalo Ramirez</option>
					<option>Jose Alberto Jonguitud Gallardo</option>
					<option>Marlem Samano</option>
					<option>Martin Vazquez</option>
					<option>Reynaldo Garcia</option>
					<option>Sergio  Gallegos</option>
				</select>
			</div>
			
			<!-- Filter Section -->
			<div id="filterDlg" title="Filtrar">
				<small id="filterLabel"></small><input id="fldFilter" type="text" style="width:90%" onkeypress="if(event.keyCode == 13){$('#filterDlg').dialog('close'); return false;}"></input>
			</div>
			
<!--   ~ CONTENT ADDS  -->

<!--   ~ CONTENT   -->
		</div>
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
<!--   ~ FOOTER   -->
	</body>
</html>