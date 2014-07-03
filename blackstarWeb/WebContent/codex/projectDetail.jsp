<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="clientDetail" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Cédula de Proyecto</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen"/>
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common/popup.js"></script>
	
	<script type="text/javascript">
	    var entryNumber = 0;
	    var itemNumber = 0;
	    function addEntry(){
	    	entryNumber++;
	    	$('#entryTable').append('<tr class="part" id="entry_' + entryNumber + '"><td>' + entryNumber + '</td><td colspan="2"><select name="" id="entryTypeId_' + entryNumber + '"><option value="">Seleccione</option><c:forEach var="ss" items="${entryTypes}"><option value="ss.id">${ss.name}</option></c:forEach></select></td><td colspan="3"><input type="text" id="description_' + entryNumber + '"/></td><td><input type="number" id="discount_' + entryNumber + '"/></td><td><input type="number" id="totalPrice_' + entryNumber + '"/></td><td><input type="number" id="comments_' + entryNumber + '"/></td> </tr> <tr><td colspan="8"><table id="items_'+ entryNumber + '"></table></td></tr><tr><td></td><td><button class="searchButton" onclick="addItem(' + entryNumber +');">+ Item</button></td></tr>');
	    } 
	    function addItem(entryNumber){
	    	itemNumber++;
	    	console.log('<tr id="item_' + entryNumber + '"><td><select name="" id="entryItemTypeId_' + itemNumber + '"><option value="">Seleccione</option><c:forEach var="ss" items="${entryItemTypes}"><option value="ss.id">${ss.name}</option></c:forEach></select></td><td><select id="referenceId" disabled="true"><option value="-1">Seleccione</option></select></td><td><input type="text" id="itemDescription_' + itemNumber + '"/></td><td><input type="number" id="itemQuantity_' + itemNumber + '"/></td><td><input type="number" id="itemPriceByUnit_' + itemNumber + '"/></td><td><input type="number" id="itemDiscount_' + itemNumber + '"/></td><td><input type="text" id="itemComments_' + itemNumber + '"/></td></tr>');
	    	$('#items_' + entryNumber).append('<tr id="item_' + entryNumber + '"><td><select name="" id="entryItemTypeId_' + itemNumber + '"><option value="">Seleccione</option><c:forEach var="ss" items="${entryItemTypes}"><option value="ss.id">${ss.name}</option></c:forEach></select></td><td><select id="referenceId" disabled="true"><option value="-1">Seleccione</option></select></td><td><input type="text" id="itemDescription_' + itemNumber + '"/></td><td><input type="number" id="itemQuantity_' + itemNumber + '"/></td><td><input type="number" id="itemPriceByUnit_' + itemNumber + '"/></td><td><input type="number" id="itemDiscount_' + itemNumber + '"/></td><td><input type="text" id="itemComments_' + itemNumber + '"/></td></tr>');
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
                        <form:form  commandName="project" action="${pageContext.request.contextPath}/codex/project/insert.do">
                           <table>
							  <tr>
								<td style="width:250px;">Cotizacion</td>
								<td><form:input type="text" path="id" readonly="true"/></td>
								<td>Estatus</td>
								<td><form:input type="text" path="statusDescription" readonly="true"/></td>
							  </tr>
							  <tr>
								<td>Cliente</td>
								<td colspan="4"><form:input type="text" path="clientDescription" /></td>
							  <tr>
							  </tr>
								<td>Centro de costos:</td>
								<td>
									<form:input type="text" path="costCenter"/>
								</td>
							  </tr>
							  <tr>
								<td>Tipo de cambio:</td>
								<td><form:input type="text" path="changeType"/></td>
								<td>Fecha:</td>
								<td><form:input id="fecha" type="text" path="created"/></td>
							  <tr>
								<td>Nombre del Contacto:</td>
								<td><form:input type="text" path="contactName" /></td>
							  </tr>
							  <tr>
								<td>Ubucación(es) del Proyecto:</td>
								<td><form:input type="text" path="location" /></td>
								<td>Forma de pago:</td>
								<td><form:input type="text" path="paymentTypeId"/></td>
							  </tr>
							  <tr>
								<td>Tiempo de entrega:</td>
								<td><form:input type="text" path="deliveryTime"/></td>
								<td>Intercom:</td>
								<td><form:input type="text" path="intercom"/></td>
							  </tr>
							  <tr>
								<td>TOTAL DE PRODUCTOS</td>
								<td><form:input type="text" path="productsNumber"/></td>
								<td>FIANZA(S)</td>
								<td><form:input type="text" path="financesNumber"/></td>
							  </tr>
							  <tr>
								<td>TOTAL DE SERVICIOS</td>
								<td><form:input type="text" path="servicesNumber"/></td>
								<td>TOTAL DEL PROYECTO</td>
								<td><form:input type="text" path="totalProjectNumber"/></td>
							  </tr>
						   </table>
                       </form:form>
                        
                        
						
<!--   ~ ENCABEZADO CEDULA   -->

			
<!--   PARTIDAS   -->	
						<hr>
						<p></p>
						<table id="entryTable">
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
							</tbody>
						</table>
						<div>
							<button class="searchButton" onclick="addEntry();">+ Partida</button>
						</div>
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