<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
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
			<span class="slogan">Plataforma de Ventas</span>
		</h1>
		
		<ul id="navigation">
			<li><a href="dashboard_cst.html">Inicio</a></li>
			<li><a href="clientes.html">Clientes</a></li>
			<li><span class="active">Cedulas de proyectos</span></li>
			<li><a href="cotizaciones.html">Cotizaciones</a></li>
			<li><a href="pedidos.html">Pedidos</a></li>
			<li><a href="indicadores.html">Indicadores</a></li>
			<li><span style="width:15px;"></span></li>
			<li><input type="text"/></li>
			<li><small>&nbsp;</small></li>
			<li><input type="submit" value="Buscar" class="searchButton" onclick="window.location = 'resultadoBusqueda.html'"/></li>
		</ul>
<!--   ~ HEADER   -->
<script type="text/javascript">
	var partNum = 1;
	var ccNum = 498;

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

	$(function(){

		// Seguimiento
		$("#seguimientoCapture").hide();

		//Attachment dialog

		$("#attachmentDlg").dialog({
			autoOpen: false,
			height: 350,
			width: 420,
			modal: true,
			buttons: {
				"Aceptar": function() {
					$( this ).dialog( "close" );
					applyAttachment();
				},
				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});

		$("#mailDlg").dialog({
			autoOpen: false,
			height: 350,
			width: 420,
			modal: true,
			buttons: {
				"Aceptar": function() {
					$( this ).dialog( "close" );
					applyCotizacion();
				},
				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});
	});

	// Attachments
	function applyAttachment(){
		var template = '<div class="comment"><table><tr><td style="width:20%"><strong>TYPE</strong></td><td style="width:20%"><strong>COMM</strong></td><td style="width:20%">Liliana Diaz</td><td style="width:20%"><a href="req.pdf">MYFILE</a></td>	<td style="width:20%">TIMESTAMP</td></tr> </table></div>';
		var d = new Date(); 
		var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
		content = content.replace('TYPE', $("#attachmentType").val());
		var who =  $("#filename").val();
		content = content.replace('MYFILE', who);
		var comm =  $("#fileComment").val();
		content = content.replace('COMM', comm);
		var currSegContent = $("#attachmentsContent").html();
		currSegContent = currSegContent + content;
		$("#attachmentsContent").html(currSegContent);

	}

	function applyCotizacion(){
		var template = '<div class="comment"><table><tr><td style="width:20%"><strong>Cotizacion</strong></td><td style="width:20%"><strong></strong></td><td style="width:20%">Liliana Diaz</td><td style="width:20%"><a href="req.pdf">CQ283</a></td>	<td style="width:20%">TIMESTAMP</td></tr> </table></div>';
		var d = new Date(); 
		var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));

		var currSegContent = $("#attachmentsContent").html();
		currSegContent = currSegContent + content;
		$("#attachmentsContent").html(currSegContent);

	} 

	function addProj(){
		var template = '<option value="" selected="">CCQ'+ccNum+'</option>';
		$("#projects").append(template);
	}

	function refChange(val){
		if(val == 'p'){
			$("#refText").hide();
			$("#refSac").hide();
			$("#refSelect").show();
		}
		else if(val == 'm'){
			$("#refSac").show();
			$("#refText").hide();
			$("#refSelect").hide();
		}
		else{
			$("#refText").show();
			$("#refText").val("");
			$("#refText").attr("disabled", "");
			$("#refSelect").hide();
			$("#refSac").hide();
		}
	}

	function refChange2(val){
		if(val == 'p'){
			$("#refText2").hide();
			$("#refSac2").hide();
			$("#refSelect2").show();
		}
		else if(val == 'm'){
			$("#refSac2").show();
			$("#refText2").hide();
			$("#refSelect2").hide();
		}
		else{
			$("#refText2").show();
			$("#refText2").val("");
			$("#refText2").attr("disabled", "");
			$("#refSelect2").hide();
			$("#refSac2").hide();
		}
	}

	function refChange3(val){
		if(val == 'p'){
			$("#refText2").hide();
			$("#refSac2").hide();
			$("#refSelect2").show();
		}
		else if(val == 'm'){
			$("#refSac2").show();
			$("#refText2").hide();
			$("#refSelect2").hide();
		}
		else{
			$("#refText2").show();
			$("#refText2").val("");
			$("#refText2").attr("disabled", "");
			$("#refSelect2").hide();
			$("#refSac2").hide();
		}
	}

	// Seguimiento
	function addSeguimiento(){
		var d = new Date(); 
		$("#seguimientoCapture").show();	
		$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Liliana Diaz:');
		$("#seguimientoText").val('');
	}
	
	function applySeguimiento(){
		var template = '<div class="comment"><p><strong>TIMESTAMP: Liliana Diaz WHO:</strong></p><p><small>MYCOMMENT</small></p></div>';
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
		var currSegContent = $("#seguimientoContent").html();
		currSegContent = currSegContent + content;
		$("#seguimientoContent").html(currSegContent);
		$("#seguimientoCapture").hide();
	}
	
	function cancelAddSeguimiento(){
		$("#seguimientoCapture").hide();
	}
	
	function fillSeguimiento(){
		$("#seguimientoText").val('Por favor cotizar instalacion de cableado y equipo en torre incluyendo equipo especial de proteccion');
	}
</script>
<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>Cedula de proyectos</h2>				
						<div>
							<p></p>							
							<button class="searchButton" onclick="window.location = 'intTicketDetail_new.html'">Agregar Req. Gral.</button>
							<button class="searchButton" onclick="window.history.back();">Guardar</button>
							<button class="searchButton" onclick="window.location = 'projectDetailAut.html'">Autorizar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							<button class="searchButton" onclick="window.history.back();">Descartar</button>
							<hr>
						</div>		
<!--   ENCABEZADO CEDULA   -->			

						<table>
							<tr>
								<td style="width:250px;">Cotizacion</td>
								<td><input type="text" value="CQ283" disabled/></td>
								<td>Estatus</td>
								<td><input type="text" value="POR AUTORIZAR" disabled/></td>
							</tr>
							<tr>
								<td>Cliente</td>
								<td colspan="4"><input type="text" value="Tetra Pak Querétaro, S.A. de C.V." disabled/></td>
							<tr>
							</tr>
								<td>Centro de costos:</td>
								<td>
									<input type="text" value="CCQ101" disabled/>
								</td>
							</tr>
							<tr>
								<td>Tipo de cambio:</td>
								<td><input type="text" value="12.80" disabled=""/></td>
								<td>Fecha:</td>
								<td><input id="fecha" type="text" value="" readonly=""/></td>
							<tr>
								<td>Nombre del Contacto:</td>
								<td><input type="text" value="Ing. Jorge Rivera" disabled=""/></td>
							</tr>
							</tr>
							<tr>
								<td>Ubucación(es) del Proyecto:</td>
								<td><input type="text" value="QUERETARO, QRO." disabled=""/></td>
								<td>Forma de pago:</td>
								<td><input type="text" value="Contado" disabled=""/></td>
								
							</tr>
							<tr>
								<td>Tiempo de entrega:</td>
								<td><input type="text" value="30 Dias" disabled/></td>
								<td>Intercom:</td>
								<td><input type="text" value="DDP" disabled/></td>
							</tr>
							<tr>
								<td>TOTAL DEL PROYECTO</td>
								<td><input type="text" value="25000"  readonly=""/></td>
								<td>FIANZA(S)</td>
								<td><input type="text" value="0"/></td>
							</tr>
							<tr>
								<td>TOTAL DE PRODUCTOS Y SERVICIOS</td>
								<td><input type="text" value="25000" readonly=""/></td>
							</tr>
						</table>
<!--   ~ ENCABEZADO CEDULA   -->

			
<!--   PARTIDAS   -->	
						<hr>
						<p></p>
						<table id="partidasTable">
							<thead>
								<tr>
									<th style="width:5px;">Part.</th>
									<th style="width:180px;">Tipo</th>
									<th style="width:180px;">Referencia</th>
									<th style="width:250px;">Descripcion</th>
									<th style="width:15px;">Cant.</th>
									<th style="width:60px;">P. Unt.</th>
									<th style="width:50px;">Descto.</th>
									<th style="width:50px;">P. Tot.</th>
									<th>Observaciones</th>
								</tr>
							</thead>
							<tbody>
								<tr class="part" part="1">  
									<td>1</td>  
									<td colspan="2">  
										<input type="text" value="PROYECTO DE AIRE" readonly/>
									</td> 
									<td colspan="3"> 
										<input type="text" value="Suministro e Instalación de equipo Liebert NXB30"> 
									</td> 
									<td> 
										<input type="number" value="0"> 
									</td> 
									<td> 
										<input type="text"  disabled="" value="20000"> 
									</td> 
									<td> 
										<input type="text"> 
									</td> 
								</tr> 
								<tr id="it11"> 
									<td></td> 
									<td> 
										<input type="text" value="Lista de precios" readonly/>
									</td> 
									<td> 
										<input type="text" id="refText" value="1298 - Cableado" readonly/>
									</td> 
									<td> 
										<input type="text" value="Instalacion de cableado"> 
									</td> 
									<td> 
										<input type="text" value="10"> 
									</td> 
									<td> 
										<input type="text" value="1000"> 
									</td> 
									<td> 
										<input type="number" value="0"> 
									</td> 
									<td> 
										<input type="text" value="10000" disabled> 
									</td> 
									<td> 
										<input type="text"> 
									</td> 
								</tr> 

								<tr id="it12"> 
									<td></td> 
									<td> 
										<input type="text" value="Mesa de ayuda" readonly/>
									</td> 
									<td> 
										<input type="text" id="refText2" value="SAC 237" readonly/>
									</td> 
									<td> 
										<input type="text" value="Cedula de costos"> 
									</td> 
									<td> 
										<input type="text" value="1"> 
									</td> 
									<td> 
										<input type="text" value="10000"> 
									</td> 
									<td> 
										<input type="number" value="0"> 
									</td> 
									<td> 
										<input type="text" value="10000" disabled> 
									</td> 
									<td> 
										<input type="text"> 
									</td> 
								</tr> 
								<tr class="part" part="1">  
									<td>2</td>  
									<td colspan="2">  
										<input type="text" value="INSTALACIONES VARIAS" readonly/>
									</td> 
									<td colspan="3"> 
										<input type="text" value="Instalacion de equipo en torre"> 
									</td> 
									<td> 
										<input type="number" value="0"> 
									</td> 
									<td> 
										<input type="text"  disabled="" value="5000"> 
									</td> 
									<td> 
										<input type="text"> 
									</td> 
								</tr> 
								<tr id="it21"> 
									<td></td> 
									<td> 
										<input type="text" value="Abierto" readonly />
									</td> 
									<td> 
										<input type="text" id="refText3" disabled/>
									</td> 
									<td> 
										<input type="text" value="Equipo de proteccion"> 
									</td> 
									<td> 
										<input type="text" value="1"> 
									</td> 
									<td> 
										<input type="text" value="5000"> 
									</td> 
									<td> 
										<input type="number" value="0"> 
									</td> 
									<td> 
										<input type="text" value="5000" disabled> 
									</td> 
									<td> 
										<input type="text"> 
									</td> 
								</tr> 
							</tbody>
						</table>
<!--   ~PARTIDAS   -->		

<!--   SEGUIMIENTO   -->		
						<br /><br />		
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
											<select id="seguimientoWho" style="width:200px;">
												<option></option>
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
										<p></p>
										<button class="searchButton" onclick="addSeguimiento();">Agregar seguimiento</button>
									</td>
								</tr>
							<tbody>
						</table>
<!--   ~ SEGUIMIENTO   -->		

<!-- ADJUNTOS -->
						<br><br>		
						<table id="adjuntosTable">
							<thead>
								<th>Historial</th>
							</thead>
							<tr>
								<td id="attachmentsContent">
									<div class="comment"><table><tr><td style="width:20%"><strong>Creación</strong></td><td style="width:20%"><strong>Cedula creada</strong></td><td style="width:20%">Liliana Diaz</td><td style="width:20%"></td>	<td style="width:20%">12/30/2013 8:00:23 AM</td></tr> </table></div>
								</td>
							</tr>
						</table>
						<table>
							<tbody>
								<tr>
									<td>
										<p></p>
										<button  class="searchButton" onclick="$('#attachmentDlg').dialog('open'); return false;">Agregar archivo</button>
									</td>
								</tr>
							<tbody>
						</table>

						<!-- Attachment section -->
						<div id="attachmentDlg" title="Adjuntar archivo">
							<p>Tipo: <select id="attachmentType" style="width:200px;">
								<option></option>
								<option value="Requisicion general">Requisicion general</option>
							</select></p>
							<p></p>
							Comentario
							<input id="fileComment" type="text" style="width:95%" />
							<p></p>
							<p>Seleccione el archivo PDF</p>
							<input type="file" id="filename" size="80"> 
						</div>

						<!-- Cotizacion DLG -->
						<div id="mailDlg">
							<p>Correos:</p>
							<input type="text" id="correos" style="width:95%"/>
							<p>Cuerpo del correo:</p>
							<textarea name="" id="mail" style="width:95%" rows="5"></textarea>
						</div>
<!-- ~ ADJUNTOS -->

<!--   BOTONES    -->
						<div>
							<hr>
							<button class="searchButton" onclick="window.location = 'intTicketDetail_new.html'">Agregar Req. Gral.</button>
							<button class="searchButton" onclick="window.history.back();">Guardar</button>
							<button class="searchButton" onclick="window.location = projectDetailAut.html">Autorizar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							<button class="searchButton" onclick="window.history.back();">Descartar</button>
						</div>
					</div>					
				</div>
<!--   ~ BOTONES    -->
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
								
<!--   ~ CONTENT COLUMN   -->

				<script type="text/javascript">
					$(document).ready(function () {
						$("#fecha").val(new Date().format("MM/dd/yyyy"));
						$("#fecha").datepicker();
					});
				</script>

<!--   ~ CONTENT   -->
			</div>
			
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
<!--   ~ FOOTER   -->
	</body>
</html>