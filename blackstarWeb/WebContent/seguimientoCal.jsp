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
					<p></p>
				</div>
					<a href="seguimiento_small_cal.html">Ver tabla resumida</a>
					<p></p>
					<div class="grid_16">

					<div class="box">
						<h2>Tickets por revisar</h2>
						<div class="utils">
							
						</div>
						<div class="bigtableContainer">
						<table style="width:6000px;">
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
									<th>TR Comprometido</th>
									<th>Tiempo Solucion</th>
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
							<tr><td style="width:120px;">6/5/2013 9:16:10</td><td>marlem.samano@gposac.com.mx</td><td>Roberto Alvarado</td><td>9933103500 ext 33811</td><td>roberto.alvarado@pemex.com</td><td>QE0534154120</td><td style="width:350px;">UPS ESTA ALARMADO POR ALTA TEMPERATURA</td><td>PEMEX</td><td style="width:100px;">UPS</td><td>APC</td><td>SL80KF</td><td style="width:80px;">80</td><td style="width:180px;">6</td><td style="width:180px;">12</td><td style="width:350px;">Carretera Villahermosa a Reforma Chiapas s/n. Poblado Luis Gil Perez.  Municipio Centro, CP86000. Villahermosa Tabasco CPG Nuevo Pemex</td><td>NUEVO PEMEX</td><td style="width:150px;">SI</td><td>BATERIAS</td><td style="width:140px;">Villahermosa IS</td><td style="width:100px;">MXO</td><td style="width:100px;">CM150</td><td  style="width:130px;">13-145</td><td style="width:100px;">NO</td><td style="width:150px;">6/5/2013</td><td style="width:100px;">15.27</td><td style="width:530px;" id="editSeguimiento" onclick="addSeguimiento();"><div class="comment" id="?">"Este reporte será tendido por Erik Lugo Aguilar el día de hoy.Ya está en el activo. la falla de este equipo es provocada por que el módulo de los ventiladores se encuentra dañado y ocupa sustitución modelo OG-0901311. El fabricante es APC y el modelo es SL80KF."</div></td><td style="width:100px;" id="myFHCierre"></td><td style="width:150px;"></td><td style="width:100px;"></td><td style="width:100px;"></td><td style="width:100px;">-347.91</td><td id="myStatus">RETRASADO<td style="width:100px;"><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/5/2013 10:06:07</td><td>marlem.samano@gposac.com.mx</td><td>Jesus Neil Valdes Carrillo</td><td>3640055 ext. 39131</td><td>jesus.neil.valdes@pemex.com</td><td>XK0303004773</td><td>"Observaciones:  equipo alarmado :1.- COMPRESSOR 1 HIGH PRESSURE 2.- RETURN HUMDITY SENSOR FAILUREEQUIPO TOTALMENTE PARADO."</td><td>PEMEX</td><td>AA</td><td>APC</td><td>AF-6.0-A-BA-D</td><td>6</td><td>24</td><td>48</td><td>Carretera Macuspana - Jonuta km 32 Col Empleados de Confianza. Villahermosa, Tab.</td><td>MACUSPANA</td><td>SI</td><td>BATERIAS</td><td>Villahermosa IS</td><td>MXO</td><td>CM150</td><td>13-146</td><td>NO</td><td>6/6/2013 10:00:00</td><td>0.10</td><td><div class="comment" id="?">Equipo encontrado fuera de  operacion por alarma de alta presion, se procede a la  revision del motor  dicipador de calor de la unidad condensadora de aire encontrando capacitor  de arranque del motor dañado, se procede al reemplazo del capacitor y al arranque del equipo para observarlo en operacion  y  checar los parametros del mismo. Queda el equipo en operacion normal.</div></td><td>6/6/2013 12:00:00</td><td style="width:90px;"><small><a href="osDetail.html">344</a></small><img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/></td><td>Jorge jonguitud.</td><td>25.90</td><td>22.10</td><td>CERRADO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/6/2013 12:35:07</td><td>marlem.samano@gposac.com.mx</td><td>ING. GERARDO RUIZ</td><td>7775642272</td><td>gruiz@iie.org.mx</td><td>2007-4777-E</td><td>Equipo alarmado : “High Presure Compress 1”</td><td>INSTITUTO DE INVESTIGACIONES ELECTRICAS</td><td>AA</td><td>DATA AIRE</td><td>DAAD-1032</td><td>10</td><td>6</td><td>408</td><td>REFORMA 113 COL. PALMIRA. CUERNAVACA, MOR. C.P.62490</td><td>NA</td><td>NO</td><td>INCLUYE CONSUMIBLES: FILTROS, BANDA Y GAS (10% MAX)</td><td>MXO</td><td>MXO</td><td>CM241</td><td>13-147</td><td>SI</td><td>6/6/2013 12:35:07</td><td>6.00</td><td><div class="comment" id="?">se atendió este reporte via telefónica con el ing. Gerardo Ruiz. Se reseteo la protección de alta presión con la ayuda del Ingeniero y se quito la alarma.</div></td><td>6/6/2013 12:35:07</td><td>NA</td><td>Julio Lara</td><td>0.00</td><td>408.00</td><td>CERRADO
							<tr><td>6/8/2013 11:38:31</td><td>alejandra.diaz@gposac.com.mx</td><td>Ing. Jose Luis Sanchez Priego</td><td>Cel. 937 116 2501, Tel. 01 993 310 6262 ext 35574</td><td>jose.luis.sanchez@pemex.com</td><td>LM-237523-1001</td><td>Equipo con alarma de batería descargada, se hace el cambio por una nueva, pero se apaga el equipo, puede ser falla en alternador o cargador de bateria.</td><td>PEMEX</td><td>PE</td><td>MARATHON ELECTRIC</td><td>431PSL1264</td><td>150</td><td>24</td><td>48</td><td>Carretera Coatzacoalcos -Vhsa km. 131 Zona Industrial "El Castaño"</td><td>CARDENAS</td><td>SI</td><td>BATERIAS</td><td>Carmen SI</td><td>MXO</td><td>CM150</td><td>13-148</td><td>NO</td><td>6/8/2013 11:40:00</td><td>23.98</td><td><div class="comment" id="?">Se encontro planta en operacion  , trabajando  con carga normalmente equipo funcionando bien, se requiere checar  boton de pago y bloqueo del equipo el cual esta localmente  en el  motor , bote esta fallando  no se pudo  revizar ya que el equipo esta trabajando con carga.</div></td><td>6/8/2013 12:35:00</td><td style="width:90px;"><small><a href="osDetail.html">151</a></small><img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/></td><td>Luis D.</td><td>0.94</td><td>47.06</td><td>CERRADO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/10/2013 8:40:31</td><td>marlem.samano@gposac.com.mx</td><td>Miguel  A. Glez Silva</td><td>Cel. 938 15 24 318</td><td>miguel.angel.gonzalezs@pemex.com</td><td>C08K8E0170</td><td>Manda demasiados mensajes de desconexión de la de tarjeta de comunicaciones.</td><td>PEMEX</td><td>AA</td><td>LIEBERT</td><td>DS042AUC0EI023A</td><td>12</td><td>6</td><td>12</td><td>Calle 33 Número 90, Edif. Advo. I P.B. Ala Poniente. DCTIPN,Edificio Administrativo 1</td><td>CD. DEL CARMEN</td><td>SI</td><td>BATERIAS</td><td>Carmen SI</td><td>MXO</td><td>CM150</td><td>13-149</td><td>NO</td><td>6/10/2013 10:00:00</td><td>4.68</td><td><div class="comment" id="?">Equipo operando pero sin comunicacion en tarjeta de monitoreo, el equipo requiere la actualizacion del  software la version actual es 1.0033.00 usuario no firmara nigun reporte hasta que personal de emerson actualice  el  software.</div></td><td></td><td></td><td></td><td></td><td>-228.51</td><td>RETRASADO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/10/2013 9:24:37</td><td>marlem.samano@gposac.com.mx</td><td>Ing. Jose Luis Carbajal</td><td>01971714900 ext 50018</td><td>jose.luis.carbajal@pemex.com</td><td>9912005</td><td>A partir del 27 de Mayo  empezó aparecer la Alarma de Baja presión en el compresor 1, a la fecha la Alarma es mas frecuente, en el tiempo que esta la Alarma presente el Aire Acondicionado solamente opera con el compresor 2 y ocasiona que la temperatura suba, al  momento de resetear la Alarma entra a operar el compresor 1 y empieza a bajar la temperatura.</td><td>PEMEX</td><td>AA</td><td>ATS</td><td>VFS-120-DAR-D</td><td>10</td><td>24</td><td>48</td><td>Carretera Transistmica Km. 3 Edif. Admvo. P.B. C. P. 70620</td><td>SALINA CRUZ</td><td>SI</td><td>BATERIAS</td><td>MXO</td><td>MXO</td><td>CM150</td><td>13-150</td><td>NO</td><td>6/19/2013 11:00:00</td><td>-193.59</td><td><div class="comment">Se confirma de visita a correctivo de Carlos Baylon el dia 18 de junio del 2013. 19/06/2013 ya se encuentran trabajando en sitio</div></td><td></td><td></td><td></td><td></td><td>-191.77</td><td>RETRASADO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/11/2013 9:20:50</td><td>alejandra.diaz@gposac.com.mx</td><td>ING. JORGE HUANTE</td><td>Cel. 044 33 14 09 20 70</td><td>jorge.huante@sanmina.com</td><td>EE0034000557</td><td>Se ha fundido un fusible, pide sea remplazado</td><td>SANMINA-SCI SYSTEMS DE MÉXICO SA DE CV</td><td>UPS</td><td>APC</td><td>SL15KFB1</td><td>15 KVA</td><td>4</td><td>408</td><td>CARR. GUAD-CHAPALA KM. 45 TLAJOMULCO DE ZUÑIGA CP. 45640</td><td>PANTA 3</td><td>SI</td><td>BATERIAS</td><td>NA</td><td>GDL</td><td>CG344</td><td>13-151</td><td>NO</td><td>6/11/2013 11:05:00</td><td>2.26</td><td><div class="comment">Se ecuentra  equipo operando , alimentando parte de la carga solo con dos fases,  se hizo revision  general detectando un fusible abierto en el tablero de bypass externo, se requiere 1 fusible con numero de parte: JKS45 de 600V  , Clase accion rapida, se solicitara para su reemplazo, se deja UPS operando, alimentando solo con dos fases.</div></td><td></td><td></td><td></td><td></td><td>192.16</td><td>ABIERTO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/14/2013 15:41:28</td><td>marlem.samano@gposac.com.mx</td><td>Rubi del Carmen Cobos Cruz</td><td>Tel. 019933106500/ Micro Ext. 34319</td><td>rubi.carmen.cobos@pemex.com</td><td>S059164-2</td><td>FALLA PRESENTA BLOQUEO Y NO ARRANCA</td><td>PEMEX</td><td>PE</td><td>STAMFORD</td><td>S/M</td><td>625</td><td>24</td><td>48</td><td>Prolongación de Juarez S/N, Ranchería Sur 1a. Secciòn Zona Industrial. COMPLEJO GOLPE</td><td>COMACALCO</td><td>SI</td><td>BATERIAS</td><td>Carmen SI</td><td>MXO</td><td>CM150</td><td>13-152</td><td>NO</td><td>6/14/2013 15:15:00</td><td>24.44</td><td><div class="comment">Se encuentra equipo en  modo automatico , sin alarmas, estando ok. Se revisa el estado del equipo y funcionamiento , se realizan pruebas del equipo en modo normal  3 veces y en modo automatico con carga 2 veces operando en perfecto estado, queda en modo automatico disponible.</div></td><td>6/14/2013 16:40:00</td><td style="width:90px;"><small><a href="osDetail.html">77</a></small><img src="img/pdf.png" onclick="window.open('img/UPSPreview.png', '_blank');"/></td><td>Luis A.</td><td>0.98</td><td>47.02</td><td>CERRADO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/15/2013 10:07:28</td><td>marlem.samano@gposac.com.mx</td><td>ING.  EFRAIN MEDINA</td><td>4777654724</td><td>emedinar@guanajuato.gob.mx</td><td>YK0734111406/N0L6180943</td><td>Equipo fuera de linea falla de enfriamiento</td><td>GOBIERNO DEL ESTADO DE GUANAJUATO</td><td>AA</td><td>APC</td><td>ACRC100/H3CE120A25A</td><td>5 TR</td><td>24</td><td>408</td><td>Paseo de la Presa no. 103</td><td>SITE</td><td>SI</td><td>NA</td><td>QRO</td><td>QRO</td><td>CQ345</td><td>13-153</td><td>NO</td><td>6/15/2013 18:07:28</td><td>16.00</td><td><div class="comment">EQUIPO QUEDA EN OPERACION NORMAL</div></td><td>6/15/2013 23:07:28</td><td></td><td>Josue Ramirez</td><td>13.00</td><td>395.00</td><td>CERRADO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							<tr><td>6/18/2013 11:03:26</td><td>marlem.samano@gposac.com.mx</td><td>Jorge Rivera</td><td>Tel: +52 442 211 2001 Mob: +521 442 1280 371</td><td>jorge.rivera@tetrapak.com</td><td>UK1028210875</td><td>ALARMA EN EL CONDENSADOR</td><td>SAC ENERGIA</td><td>AA</td><td>APC</td><td>INROW ACSC 100</td><td>5.3 KW</td><td>168</td><td>408</td><td>PARQUE ANTARA</td><td>2do. PISO</td><td>SI</td><td>NA</td><td>MXO</td><td>MXO</td><td>CM146</td><td>13-154</td><td>NO</td><td>6/18/2013 12:03:26</td><td>167.00</td><td><div class="comment">"la alarma del equipo inrow es debido a que la bomba de condensado esta dañada. Por lo que hay que sustituirla. Por lo tanto el equipo quedara fuera de servicio hasta conseguir la parte dañada."</div></td><td></td><td></td><td>Juan Pablo Procopio</td><td></td><td>361.87</td><td>ABIERTO<td><small><a href="#" class="edit" onclick="$('#cerrarOSCapture').dialog('open'); return false;">Cerrar</a></small></td></tr>
							</tbody>
						</table></div>	
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