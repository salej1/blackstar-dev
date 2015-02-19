<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<!-- saved from url=(0043)http://localhost:8888/codex/visit/create.do -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Reporte de emergencia</title>
		<title>GPO. SAC - Portal de Servicios</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
		<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
		<script src="${pageContext.request.contextPath}/js/glow/1.7.0/core/core.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
		<script src="${pageContext.request.contextPath}/js/customAutocomplete.js"></script>
		<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
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
	</head>
        
		<body><h1 id="head">
			<div class="logo">
				<a href="http://www.gposac.com.mx"><img alt="Grupo Sac" src="/img/grupo-sac-logo.png" border="0"></a>
			</div>
			<span class="slogan">Call Center</span>
		</h1>
		<ul id="navigation">
		
		</ul>
		<div id="user" class="container_16 clearfix">
			<div class="grid_16">	
				<p>${ user.fullDescriptor }</p>
			</div>
		</div>
<!--   ~ HEADER   -->
	
	<script type="text/javascript">
	   var isCustomer = "${user.belongsToGroup['Cliente']}";

	   $(function(){
	   		$("#ticketNumberRow").hide();
		    $("#successLiteral").hide();
	   		
	   		var equipmentList = '${equipmentList}';

	   		init_autoComplete(equipmentList, "serialNumber", "policyId", "single", fillPolicyData);

	   		 $( "#OkMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 450,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
		          	$("input").attr("disabled", "true");
		          	$("textArea").attr("disabled", "true");
		          	$(".searchButton").hide();
		          	$("#successLiteral").show();
		        }
		      }
		    });

		    $( "#FailMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
		        }
		      }
		    });

		     $( "#InvalidMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
		        }
		      }
		    });

		    $( "#WaitMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        
		        }
		    });

		    $("#contact").focus();
	   });

	   function fillPolicyData(){
	   		var policyId = $("#policyId").val();

	   		$.getJSON("/ticketCapture/getSupportInfo.do?policyId=" + policyId, function(data){
	   			$("#project").val(data[0].project);
				$("#equipmentLocation").val(data[0].equipmentLocation);
				$("#equipmentType").val(data[0].equipmentType);
				$("#model").val(data[0].model);
				$("#capacity").val(data[0].capacity);
				$("#brand").val(data[0].brand);
				$("#responseTimeHR").val(data[0].responseTimeHR);
				$("#solutionTimeHR").val(data[0].solutionTimeHR);
				if(data[0].includesParts == 1){
					$("#includesParts").val("SI");
				}
				else{
					$("#includesParts").val("NO");
				}
				$("#exceptionParts").val(data[0].exceptionParts);
				$("#serviceCenter").val(data[0].serviceCenter);
				$("#contractState").val(data[0].contractState);
				var endDate = new Date(data[0].endDate);
				$("#endDate").val(endDate.format('dd/MM/yyyy'));
				$("#customer").val(data[0].customer);
				$("#observations").focus();
	   		});
	   }

	   function validate(){
	   		var contactName = $("#contact").val();
	   		var contactEmail = $("#contactEmail").val();
	   		var contactPhone = $("#contactPhone").val();
	   		var policyId = $("#policyId").val();
	   		var observations = $("#observations").val();

	   		if(contactName == ""){
	   			$("#InvalidMessage").html("Por favor poroporcione el nombre del contacto");
	   			$("#contact").focus();
	   			return false;
	   		}

	   		if(contactEmail == ""){
	   			$("#InvalidMessage").html("Por favor poroporcione el email del contacto");
	   			$("#contactEmail").focus();
	   			return false;
	   		}

	   		if(contactPhone == ""){
	   			$("#InvalidMessage").html("Por favor poroporcione el teléfono de contacto");
	   			$("#contactPhone").focus();
	   			return false;
	   		}

	   		if(observations == ""){
	   			$("#InvalidMessage").html("Por favor poroporcione una descripcion de la falla");
	   			$("#observations").focus();
	   			return false;
	   		}

	   		if(policyId == null || policyId == ""){
	   			$("#InvalidMessage").html("Por favor seleccione un número de serie de la lista");
	   			$("#serialNumber").focus();
	   			return false;
	   		}

	   		return true;
	   }

	   function send(){

	   	if(validate()){
	   		$("#WaitMessage").dialog('open');
	   		$.post("${pageContext.request.contextPath}/ticketCapture/save.do", $("#ticket").serialize()).
				done(function(data){
					$( "#WaitMessage" ).dialog('close');
					var okMsg = $("#OkMessage").html();
					okMsg = okMsg.replace("FOLIO", data);
					$("#OkMessage").html(okMsg);
					$( "#OkMessage" ).dialog('open');

					var staticMsg = $("#successLiteral").html();
					staticMsg = staticMsg.replace("FOLIO", data);
					$("#successLiteral").html(staticMsg);
				}).
				fail(function(){
					$( "#WaitMessage" ).dialog('close');
					$( "#FailMessage" ).dialog('open');
				});
	   	}
	   	else{
	   		$("#InvalidMessage").dialog('open');
	   	}
	   }
	</script>
	
	
	
	<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>Reporte de Emergencia</h2>
                        <form:form commandName='ticket' action="/ticketCapture/save.do" method="POST">
							<table>
								<tbody>
								<tr id="ticketNumberRow">
									<td>Numero de reporte</td>
									<td><input type="text" id="ticketNumber" style="width:50%;" readOnly="true"/></td>
								</tr>
								<tr>
									<td style="width:200px;">Fecha</td>
									<td><form:input type="text" path="created" readOnly="true" style="width:50%;" required="true"/></td>
								</tr>
								<tr>
									<td>Nombre de quien reporta</td>
									<td><form:input type="text" path="contact" style="width:50%;" required="true"/>
								</tr>
								<tr>
									<td>Email</td>
									<td><form:input type="text" path="contactEmail" style="width:50%;" required="true"/>
								</tr>
								<tr>
									<td>Telefono</td>
									<td><form:input type="text" path="contactPhone" style="width:50%;" required="true"/>
								</tr>
								<tr>
									<td>Numero de serie del equipo</td>
									<td><input type="text" id="serialNumber" style="width:50%;" required="true"/>
									<form:input type="hidden" path="policyId"/></td>
								</tr>
								<tr>
									<td style="width:85px;">Cliente</td>
									<td>
										<input type="text" id="customer" style="width:95%;" required="true" readOnly="true"/>
									</td>
								</tr>
								<tr>
									<td>Reporte de falla</td>
									<td><form:textarea path="observations"style="width:95%;" type="text" rows="3"/></td>
								</tr>
								<tr>
									<td>Proyecto</td>
									<td><input id="project" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Ubicación del equipo</td>
									<td><input id="equipmentLocation" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Equipo</td>
									<td><input id="equipmentType" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Modelo</td>
									<td><input id="model" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Capacidad</td>
									<td><input id="capacity" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Marca</td>
									<td><input id="brand" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Tiempo máximo de respuesta</td>
									<td><input id="responseTimeHR" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Tiempo máximo de solución</td>
									<td><input id="solutionTimeHR" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Incluye partes</td>
									<td><input type="text" id="includesParts" readOnly="true" style="width:50%;"/></td>
								</tr>
								</tr>
									<td>Excepción de partes</td>
									<td><input type="text" id="exceptionParts" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Centro de servicio</td>
									<td><input id="serviceCenter" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Estado del contrato</td>
									<td><input id="contractState" readOnly="true" style="width:50%;"/></td>
								</tr>
									<td>Fecha de vencimiento del contrato</td>
									<td><input id="endDate" readOnly="true" style="width:50%;"/></td>
							</tbody></table>
							
							<br>
							<input type="submit" id="sendButton" class="searchButton" onclick="send(); return false;" value="Enviar"/>
							<input type="submit" id="cancelButton" class="searchButton" onclick="window.location = 'http://www.gposac.com.mx'; return false;" value="Cancelar"/>
							<span id="successLiteral"> <img src="/img/sucess.png" alt="" style="width:20px;height:20px;vertical-align:bottom;">&nbsp;El reporte fue registrado con exito. Folio: <strong>FOLIO</strong></span>
						</form:form>
					<div>
				</div>
			</div>					
		</div>
			
		<!-- Mensajes al usuario -->
		<div id="InvalidMessage" title="Revise los datos del reporte">
			Por favor revise que todos los campos hayan sido llenados correctamente.
		</div>
		<div id="WaitMessage" title="Enviar reporte de emergencia" style="text-align:center">
			Enviando reporte de emergencia, por favor espere... <br><br> <img src="/img/processing.gif"/>
		</div>
		<div id="OkMessage" title="Reporte de emergencia registrado">
			El reporte de emergencia se registró con exito con el folio <h3>FOLIO</h3>
			En breve recibirá un email con los detalles del reporte y un link para dar seguimiento al mismo.
		</div>
		<div id="FailMessage" title="Error al guardar el reporte">
			Ocurrio un error al registrar el reporte de emergencia. Por favor verifique los datos e intente nuevamente
		</div>

<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
								
<!--   ~ CONTENT COLUMN   -->

<!--   ~ CONTENT   -->
		
</body></html>