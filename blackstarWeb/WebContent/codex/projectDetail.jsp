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
	    
	    $(document).ready(function () {

			//Attachment dialog
			$("#attachmentDlg").dialog({
				autoOpen: false,
				height: 270,
				width: 420,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$.ajax({
					        type: "GET",
					        url: "addDeliverableTrace.do",
					        data: "projectId=${project.id}&deliverableTypeId=" + $("#attachmentType").val() + "&userId=${user.blackstarUserId}",
					        success: function(html) {
					        	$('#attachmentDlg').dialog( "close" );
					        }
					    });
					}}
			});
	    });
	    
	    function addEntry(){
	    	entryNumber++;
	    	$('#entryTable').append('<tr class="part" id="entry_' + entryNumber + '"><td>' + entryNumber + '</td><td colspan="2"><select name="" id="entryTypeId_' + entryNumber + '" style="width:350px"><option value="">Seleccione</option><c:forEach var="ss" items="${entryTypes}"><option value="ss.id">${ss.name}</option></c:forEach></select></td><td colspan="3"><input type="text" id="description_' + entryNumber + '" style="width:280px"/></td><td><input type="number" id="discount_' + entryNumber + '" style="width:50px"/></td><td><input type="number" id="totalPrice_' + entryNumber + '" style="width:50px"/></td><td><input type="text" id="comments_' + entryNumber + '" style="width:80px"/></td> </tr> <tr class="item_part' + entryNumber + '"><td colspan="9"><table class="items" id="items_'+ entryNumber + '" style="width:100%"></table></td></tr><tr><td></td><td><button class="searchButton" onclick="addItem(' + entryNumber +');">+ Item</button></td></tr>');
	    } 
	    function addItem(entryNumber){
	    	itemNumber++;
	    	$('#items_' + entryNumber).append('<tr id="item_' + itemNumber + '"><td><button class="searchButton" onclick="removeItem(\'item_' + itemNumber +'\')" style="width:10px">-</button></td><td><select name="" id="entryItemTypeId_' + itemNumber + '" style="width:157px"><option value="">Seleccione</option><c:forEach var="ss" items="${entryItemTypes}"><option value="ss.id">${ss.name}</option></c:forEach></select></td><td><select id="referenceId" disabled="true" style="width:150px"><option value="-1">Seleccione</option></select></td><td><input type="text" id="itemDescription_' + itemNumber + '" style="width:180px"/></td><td><input type="number" id="itemQuantity_' + itemNumber + '" style="width:40px"/></td><td><input type="number" id="itemPriceByUnit_' + itemNumber + '" style="width:40px"/></td><td><input type="number" id="itemDiscount_' + itemNumber + '" style="width:40px"/></td><td><input type="number" id="itemTotalPrice_' + itemNumber + '" style="width:40px"/></td><td><input type="text" id="itemComments_' + itemNumber + '" style="width:80px"/></td></tr>');
	    }
	    
	    function removeItem(itemId){
	    	$('#' + itemId).remove();
	    }
	    
	    function customPickerCallBack(data) {
			$("#attachmentFileName").val(data.docs[0].name);
			$('#attachmentDlg').dialog('open');
		}
	    
	    function prepareSubmit(){
	     	var entries = $( "tr.part" );
	     	alert(entries.length);
	     	for(var i = 0; i < entries.length ; i++){
	     		alert($("#" + entries[i].id).next().find("table.items tr").length);
	     		//alert(entries[i].find("td table.items").length);	
	     	}
	     	
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
							<c:if test="${enableEdition}">
							  <button class="searchButton" onclick="window.location = 'intTicketDetail_new.html'">Agregar Req. Gral.</button>
							  <button class="searchButton" onclick="window.location = projectDetailAut.html">Autorizar</button>
							</c:if>
							<button class="searchButton" onclick="window.history.back();">Guardar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							<button class="searchButton" onclick="window.history.back();">Descartar</button>
							<hr>
						</div>		
<!--   ENCABEZADO CEDULA   -->			
                        <form:form  commandName="project" action="${pageContext.request.contextPath}/codex/project/insert.do">
                           <table>
							  <tr>
								<td  style="width:140px">No. Cedula</td>
								<td><form:input type="text" path="projectNumber" readonly="true" style="width:100%"/></td>
								<td style="width:120px">Estatus</td>
								<td><form:input type="text" path="statusDescription" readonly="true" style="width:100%"/></td>
							  </tr>
							  <tr>
								<td>Cliente</td>
								<td colspan="4"><form:input type="text" path="clientDescription"  style="width:100%"/></td>
							  <tr>
							  </tr>
								<td>Centro de costos:</td>
								<td>
									<form:input type="text" path="costCenter" style="width:100%"/>
								</td>
							  </tr>
							  <tr>
								<td>Tipo de cambio:</td>
								<td><form:input type="text" path="changeType" style="width:100%"/></td>
								<td>Fecha:</td>
								<td><form:input id="fecha" type="text" path="created" style="width:100%"/></td>
							  <tr>
								<td>Nombre del Contacto:</td>
								<td><form:input type="text" path="contactName"  style="width:100%"/></td>
							  </tr>
							  <tr>
								<td>Ubucación(es) del Proyecto:</td>
								<td><form:input type="text" path="location"  style="width:100%"/></td>
								<td>Forma de pago:</td>
								<td><form:input type="text" path="paymentTypeId" style="width:100%"/></td>
							  </tr>
							  <tr>
								<td>Anticipo:</td>
								<td><form:input type="text" path="advance" style="width:100%"/></td>
								<td>Plazo:</td>
								<td><form:input id="fecha" type="text" path="timeLimit" style="width:100%"/></td>
							  <tr>
							  <tr>
								<td>Plazo finiquito:</td>
								<td><form:input type="text" path="settlementTimeLimit"  style="width:100%"/></td>
							  </tr>
							  <tr>
								<td>Moneda:</td>
								<td><form:select name="" id="currency" path="currencyTypeId" style="width:100%">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${currencyTypes}">
												<option value="ss.id"
												<c:if test="${ss.id == project.currencyTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
											
										</form:select></td>
								<td>IVA:</td>
								<td><form:select name="" id="taxes" path="taxesTypeId" style="width:100%">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${taxesTypes}">
												<option value="ss.id"
												<c:if test="${ss.id == project.taxesTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
											
										</form:select></td>
							  </tr>
							  <tr>
								<td>Tiempo de entrega:</td>
								<td><form:input type="text" path="deliveryTime" style="width:100%"/></td>
								<td>Intercom:</td>
								<td><form:input type="text" path="intercom" style="width:100%"/></td>
							  </tr>
							  <tr>
								<td>TOTAL DE PRODUCTOS</td>
								<td><form:input type="text" path="productsNumber" style="width:100%"/></td>
								<td>FIANZA(S)</td>
								<td><form:input type="text" path="financesNumber" style="width:100%"/></td>
							  </tr>
							  <tr>
								<td>TOTAL DE SERVICIOS</td>
								<td><form:input type="text" path="servicesNumber" style="width:100%"/></td>
								<td>TOTAL DEL PROYECTO</td>
								<td><form:input type="text" path="totalProjectNumber" style="width:100%"/></td>
							  </tr>
						   </table>
						   <form:input type="hidden" path="strEntries"/>
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
									<th style="width:200px;">Descripcion</th>
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

                         <c:if test="${enableEdition}">
                         
<!--   SEGUIMIENTO   -->		
						<br /><br />		
						<c:import url="_followTable.jsp"></c:import>
<!--   ~ SEGUIMIENTO   -->		

<!-- ADJUNTOS -->
						<br><br>		

						 <table id="fileTraceTable">
								<thead>
								</thead>
								    <c:forEach var="current" items="${deliverables}" >
									  <tr>
									    <td  style="width:5%;">
		                                  <c:choose>
											<c:when test="${current.delivered}">
												<img src='${pageContext.request.contextPath}/img/delivered.png'/>
											</c:when>
											<c:otherwise>
												<img src='${pageContext.request.contextPath}/img/notDelivered.png'/>
											</c:otherwise>
										  </c:choose>


										</td>
										<td align="left">
										  ${current.name}
										</td>
									  </tr>
									  </c:forEach>
							</table>

							<c:import url="/_attachments.jsp"></c:import>
							</c:if>
<!-- ~ ADJUNTOS -->

<!--   BOTONES    -->
						<div>
							<hr>
							<c:if test="${enableEdition}">
							  <button class="searchButton" onclick="window.location = 'intTicketDetail_new.html'">Agregar Req. Gral.</button>
							  <button class="searchButton" onclick="window.location = projectDetailAut.html">Autorizar</button>
							</c:if>
							<button class="searchButton" onclick="prepareSubmit();">Guardar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							<button class="searchButton" onclick="window.history.back();">Descartar</button>
						</div>
					</div>					
				</div>
				 
                 <!-- Attachment Img section -->
				<div id="attachmentDlg" title="Referencia">
					<p></p>
					<p>Tipo de archivo</p>
					<input id="attachmentFileName" size="80" readOnly="true"/> 
					<select id="attachmentType" style="width:200px;">
					   <option value="-1">Sin referencia</option>
					     <c:forEach var="current" items="${deliverableTypes}" >
					        <option value="${current.id}">${current.name}</option>
					     </c:forEach>
					</select>

				</div>		
								
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