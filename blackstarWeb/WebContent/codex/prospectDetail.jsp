<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="prospectDetail" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Prospecto</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common/popup.js"></script>
	
	
	<script type="text/javascript">
	   function checkZipCode(evt) {
           var theEvent = evt || window.event;
           var key = theEvent.keyCode || theEvent.which;
           key = String.fromCharCode( key );
           var regex = /[0-9]|\./;
           if( !regex.test(key) ) {
             theEvent.returnValue = false;
             if(theEvent.preventDefault) 
            	  theEvent.preventDefault();
           }
           if($("#zipCode").val().length == 4){
        	   $('#municipality').empty().append('<option value="">Seleccione</option>');
        	   $('#neighborhood').empty().append('<option value="">Seleccione</option>');
        	   $('#city').empty().append('<option value="">Seleccione</option>');
        	   
        	   $('#municipality').prop( "disabled", false );
        	   $('#neighborhood').prop( "disabled", false );
        	   $('#city').prop( "disabled", false );
 			  $.ajax({
 				  url: "${pageContext.request.contextPath}/codex/prospect/getLocationsByZipCode.do?zipCode=" + $("#zipCode").val() + key,
 				 type: 'get',
                 dataType: 'json',
                 async:true,
 				  success: function(data){
 					         for (var i = 0; i < data.length; i++) {
 					            d = data[i];
 					        	$('#municipality').append('<option value="' + d.municipality + '">' + d.municipality + '</option>');
 					        	$('#neighborhood').append('<option value="' + d.neighborhood + '">' + d.neighborhood + '</option>');
 					        	$('#city').append('<option value="' + d.city + '">' + d.city + '</option>');
 					         }
 					         
 					        var found = [];
 					       $("#municipality option").each(function() {
 					         if($.inArray(this.value, found) != -1) $(this).remove();
 					         found.push(this.value);
 					       });
 					      found = [];
 					      $("#neighborhood option").each(function() {
  					         if($.inArray(this.value, found) != -1) $(this).remove();
  					         found.push(this.value);
  					       });
 					     found = [];
 					     $("#city option").each(function() {
 					         if($.inArray(this.value, found) != -1) $(this).remove();
 					         found.push(this.value);
 					       });
                           } 
 				});
 			  
 		  }
        }

	</script>
	
	
	
	<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
			<!--   LINKS   -->
		<div class="grid_16">	
			<p>
				<img src="img/navigate-right.png"/><a href="projectNew.html" >Crear Cedula de proyecto</a>
			</p>
		</div>	
<!--  ~ LINKS   -->
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>Nuevo prospecto</h2>

						<table>
							<tr>
								<td style="width:120px;">Numero</td>
								<td colspan="2"><input type="text" style="width:95%;" value="${prospect.id}" readonly=""/></td>
							</tr>
							<tr>
								<td>RFC</td>
								<td colspan="4"><input type="text" style="width:95%;" value="${prospect.rfc}"/></td>
							</tr>
							<tr>
								<td>Razon Social</td>
								<td colspan="6"><input type="text" style="width:95%;" value="${prospect.corporateName}"/></td>
							</tr>
							<tr>
								<td>Nombre comercial</td>
								<td colspan="6"><input type="text" style="width:95%;" value="${prospect.tradeName}"/></td>
							</tr>
							<tr><td></td></tr>
							<tr>
								<td>Telefono 1</td>
								<td>Lada</td>
								<td><input type="text" style="width:95%;" value="${prospect.phoneArea}"/></td>
								<td>Telefono</td>
								<td><input type="text" style="width:95%;" value="${prospect.phoneNumber}"/></td>
								<td>Extension</td>
								<td><input type="text" style="width:95%;" value="${prospect.phoneExtension}"/></td>
							</tr>
							<tr>
								<td>Telefono 2</td>
								<td>Lada</td>
								<td><input type="text" style="width:95%;" value="${prospect.phoneAreaAlt}"/></td>
								<td>Telefono</td>
								<td><input type="text" style="width:95%;" value="${prospect.phoneNumberAlt}"/></td>
								<td>Extension</td>
								<td><input type="text" style="width:95%;" value="${prospect.phoneExtensionAlt}"/></td>
							</tr>
							<tr>
								<td>Email 1</td>
								<td colspan="2"><input type="text"  style="width:95%;" value="${prospect.email}"/></td>
								<td>Email 2</td>
								<td colspan="2"><input type="text"  style="width:95%;" value="${prospect.emailAlt}"/></td>
							</tr>
							<tr>
								<td>Domicilio: </td>
								<td>Calle</td><td colspan="3"><input type="text" style="width:95%;" value="${prospect.street}"/></td>
							</tr>	
							<tr>
								<td></td>
								<td>Num. Exterior</td>
								<td><input type="text" style="width:95%;" value="${prospect.extNumber}"/></td>
								<td>Num. Interior</td>
								<td><input type="text" style="width:95%;" value="${prospect.intNumber}"/></td>
							</tr>	
							
							<tr>
								<td></td>
								<td>Pais:</td>
								<td><input type="text"  style="width:95%;" value="México" readonly/></td>
								<td>Estado:</td>
								<td><select name="" id="state">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${states}">
												<option value="ss.state"
												<c:if test="${ss.state == prospect.state}">
													selected="true"
												</c:if>
												>${ss.state}</option>
											</c:forEach>
											
										</select>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>Codigo postal:</td>
								<td><input id="zipCode" type="text"  style="width:95%;" value="${prospect.zipCode}" onkeypress='checkZipCode(event)' maxlength="5"/></td>
							</tr>
							<tr>
							    <td></td>
							    <td>Municipio:</td>
								<td><select id="municipality" name="municipality" style="width:100%;" disabled>
									<option value="">Seleccione</option>
								</select></td>
								<td>Colonia:</td>
								<td><select id ="neighborhood" name="neighborhood" style="width:95%;" disabled>
									<option value="">Seleccione</option>
								</select></td>
							</tr>
							<tr>
								<td></td>
								<td>Ciudad:</td>
								<td><select name="city" id="city" style="width:95%;" disabled>
									<option value="">Seleccione</option>
								</select></td>
							</tr>	
							<tr><td></td></tr>
							<tr>
								<td>Vendedor</td>
								<td colspan="2"><select name="" id="seller" style="width:95%;">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${sellers}">
												<option value="ss.id"
												<c:if test="${ss.id == prospect.sellerId}">
													selected="true"
												</c:if>
												>${ss.userName}</option>
											</c:forEach>
										</select></td>
								<td>Contacto</td>
								<td colspan="2"><input type="text" style="width:95%;" value="${prospect.contactName}"/></td>
							</tr>
							<tr>
								<td>Clasificacion</td>
								<td colspan="2"><select name="" id="clientType" style="width:95%;">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${clientTypes}">
												<option value="ss.id"
												<c:if test="${ss.id == prospect.clientTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
										</select></td>
								<td>Origen</td>
								<td colspan="2"><select name="" id="originType" style="width:95%;">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${originTypes}">
												<option value="ss.id"
												<c:if test="${ss.id == prospect.clientOriginId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
										</select></td>
							</tr>
							<tr>
								<td>CURP</td>
								<td colspan="2"><input type="text" style="width:95%;" value=""/></td>
								<td>Retencion</td>
								<td colspan="2"><input type="text"  style="width:95%;" value=""/></td>
							</tr>
							
						</table>
						<p></p>
						<div>
							<button class="searchButton" onclick="window.history.back();">Guardar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
						</div>
					</div>					
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
								
<!--   ~ CONTENT COLUMN   -->

<!--   ~ CONTENT   -->
			</div>