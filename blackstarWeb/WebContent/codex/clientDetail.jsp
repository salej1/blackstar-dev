<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="clientes" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Prospecto</title>

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
		var userCanEdit = "${userCanEdit}";

		$(function(){
			$("#errMsg").dialog({
				modal: true,
				autoOpen: false,
				resizable: false,
				height: 140,
				width: 350,
			    buttons: {
			    	Aceptar: function() {
			        	$( this ).dialog( "close" );
        			}
        		}
			});

			if(userCanEdit == "false"){
				$("input").attr("readonly", "");
				$("select").attr("disabled", "");
				$("#saveButton").hide();
			}

		});

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
 				  url: "${pageContext.request.contextPath}/codex/client/getLocationsByZipCode.do?zipCode=" + $("#zipCode").val() + key,
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
	   
	   function validate(){

	   		// name
	   		var name = $("#corporateName").val();
	   		if(name == ""){
	   			$("#errMsg").html("Por favor ingrese la Razón Social del prospecto");
	   			$("#errMsg").dialog("open");
	   			return false;
	   		}

	   		name = $("#tradeName").val();
	   		if(name == ""){
	   			$("#errMsg").html("Por favor ingrese el Nombre Comercial del prospecto");
	   			$("#errMsg").dialog("open");
	   			return false;
	   		}

		   // phone
			var phoneArea = $("#phoneArea").val();
			var phoneNumber = $("#phoneNumber").val();
			if(phoneArea == "" || phoneNumber == ""){
	   			$("#errMsg").html("Por favor capture el Telefono incluyendo clave lada");
		   		$("#errMsg").dialog('open');
			 	return false;
		   }

		   // email
			var email = $("#email").val();
			if(email == ""){
	   			$("#errMsg").html("Por favor capture el email del prospecto");
		   		$("#errMsg").dialog('open');
			 	return false;
		   }

		   // CST
		   var cstId = $("#cstId").val();
			if(cstId == ""){
	   			$("#errMsg").html("Por favor seleccione un Vendedor");
		   		$("#errMsg").dialog('open');
			 	return false;
		   }

		   // contactName
		   var contactName = $("#contactName").val();
			if(contactName == ""){
	   			$("#errMsg").html("Por favor capture el nombre del contacto");
		   		$("#errMsg").dialog('open');
			 	return false;
		   }

	   		// type
			var classf = $("#clientTypeId").val();
			if(classf == ""){
	   			$("#errMsg").html("Por favor seleccione la Clasificacion del prospecto");
		   		$("#errMsg").dialog('open');
			 	return false;
		   }

		   // origin
			var originType = $("#originType").val();
			if(originType == ""){
	   			$("#errMsg").html("Por favor seleccione el origen del prospecto");
		   		$("#errMsg").dialog('open');
			 	return false;
		   }
		   // todo bien
		   return true;
	   }

		function save(frm){
			if(validate()){
				frm.submit();
			}
		}

	</script>
	
	
	
	<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
			<!--   LINKS   -->
		<div class="grid_16">	
			<p>
				<c:if test="${mode != 'new'}">
					<img src="/img/navigate-right.png"/><a href="/codex/project/create.do?clientId=${client.id}" >Crear Cedula de proyecto</a>
				</c:if>
			</p>
		</div>	
<!--  ~ LINKS   -->
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>
							<c:choose>
								<c:when test="${client.prospect == false}">Prospecto</c:when>
								<c:otherwise>Cliente</c:otherwise>
							</c:choose>
							
						</h2>
                        <form:form  commandName="client" action="${pageContext.request.contextPath}/codex/client/insert.do">
						<table>
							<tr>
								<td style="width:120px;">Numero</td>
								<td colspan="2"><form:input type="text" style="width:95%;" path="id" readonly="true"/></td>
							</tr>
							<tr>
								<td colspan="2" style="font-style: italic;">Los datos marcados con * son obligatorios</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td>RFC</td>
								<td colspan="4"><form:input type="text" style="width:95%;" path="rfc" maxlength="13"/></td>
							</tr>
							<tr>
								<td>Razon Social*</td>
								<td colspan="6"><form:input type="text" style="width:95%;" path="corporateName" required="true"/></td>
							</tr>
							<tr>
								<td>Nombre comercial*</td>
								<td colspan="6"><form:input type="text" style="width:95%;" path="tradeName" required="true"/></td>
							</tr>
							<tr><td></td></tr>
							<tr>
								<td>Telefono 1*</td>
								<td>Lada*</td>
								<td><form:input type="text" style="width:95%;" path="phoneArea" maxlength="3" required="true"/></td>
								<td>Telefono*</td>
								<td><form:input type="text" style="width:95%;" path="phoneNumber" maxlength="10" required="true"/></td>
								<td>Extension</td>
								<td><form:input type="text" style="width:95%;" path="phoneExtension" maxlength="6"/></td>
							</tr>
							<tr>
								<td>Telefono 2</td>
								<td>Lada</td>
								<td><form:input type="text" style="width:95%;" path="phoneAreaAlt" maxlength="3"/></td>
								<td>Telefono</td>
								<td><form:input type="text" style="width:95%;" path="phoneNumberAlt" maxlength="10"/></td>
								<td>Extension</td>
								<td><form:input type="text" style="width:95%;" path="phoneExtensionAlt" maxlength="6"/></td>
							</tr>
							<tr>
								<td>Email 1*</td>
								<td colspan="2"><form:input type="text"  style="width:95%;" path="email" maxlength="60" required="true"/></td>
								<td>Email 2</td>
								<td colspan="2"><form:input type="text"  style="width:95%;" path="emailAlt" maxlength="60"/></td>
							</tr>
							<tr>
								<td>Domicilio: </td>
								<td>Calle</td><td colspan="3"><form:input type="text" style="width:95%;" path="street"/></td>
							</tr>	
							<tr>
								<td></td>
								<td>Num. Exterior</td>
								<td><form:input type="text" style="width:95%;" path="extNumber" maxlength="5"/></td>
								<td>Num. Interior</td>
								<td><form:input type="text" style="width:95%;" path="intNumber" maxlength="5"/></td>
							</tr>	
							
							<tr>
								<td></td>
								<td>Pais:</td>
								<td><form:input type="text"  style="width:95%;" path="country" value="México" readonly="true"/></td>
								<td>Estado:</td>
								<td><form:select name="" id="state" path="state">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${states}">
												<option value="${ss.state}"
												<c:if test="${ss.state == client.state}">
													selected="true"
												</c:if>
												>${ss.state}</option>
											</c:forEach>
										</form:select>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>Codigo postal:</td>
								<td><form:input id="zipCode" type="text"  style="width:95%;" path="zipCode" onkeypress='checkZipCode(event)' maxlength="5"/></td>
							</tr>
							<tr>
							    <td></td>
							    <td>Municipio:</td>
								<td><form:select path="municipality" id="municipality" name="municipality" style="width:100%;" disabled="true">
									<option value="">Seleccione</option>
								</form:select></td>
								<td>Colonia:</td>
								<td><form:select path="neighborhood" id ="neighborhood" name="neighborhood" style="width:95%;" disabled="true">
									<option value="">Seleccione</option>
								</form:select></td>
							</tr>
							<tr>
								<td></td>
								<td>Ciudad:</td>
								<td><form:select path="city" name="city" id="city" style="width:95%;" disabled="true">
									<option value="">Seleccione</option>
								</form:select></td>
							</tr>	
							<tr><td></td></tr>
							<tr>
								<td>Vendedor*</td>
								<td colspan="2">
									<form:select path="cstId" name="cstId" style="width:95%;" required="true">
								            <option value="">Seleccione</option>
											<c:forEach var="cst" items="${cstList}">
												<option value="${cst.cstId}"
												<c:if test="${cst.cstId == client.cstId}">
													selected="true"
												</c:if>
												>${cst.name}</option>
											</c:forEach>
									</form:select>
								</td>
								<td>Contacto*</td>
								<td colspan="2"><form:input type="text" style="width:95%;" path="contactName" required="true"/></td>
							</tr>
							<tr>
								<td>Clasificacion*</td>
								<td colspan="2"><form:select path="clientTypeId" style="width:95%;" required="true">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${clientTypes}">
												<option value="${ss.id}"
												<c:if test="${ss.id == client.clientTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
										</form:select></td>
								<td>Origen*</td>
								<td colspan="2"><form:select path="clientOriginId" name="originType" id="originType" style="width:95%;" required="true">
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${originTypes}">
												<option value="${ss.id}"
												<c:if test="${ss.id == client.clientOriginId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
										</form:select></td>
							</tr>						
						</table>
						<p></p>
						<div>
							<button class="searchButton" id="saveButton" onclick="save(); return false;">Guardar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
						</div>
						</form:form>
					</div>					
				</div>
				<div id="errMsg" title="Datos incompletos">
					
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
								
<!--   ~ CONTENT COLUMN   -->

<!--   ~ CONTENT   -->
			</div>