<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>Órden de servicio general</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/date.js"></script>
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
	<script type="text/javascript" charset="utf-8">

	function split( val ) {
	  return val.split( /,\s*/ );
	}

	function extractLast( term ) {
	  return split( term ).pop();
	}

	var mode = "${mode}";
	var isCoord = "${user.belongsToGroup['Coordinador'] || user.belongsToGroup['Call Center']}";
	var isEng = "${user.belongsToGroup['Implementacion y Servicio']}";
	var hasPolicy = "${hasPolicy}";

	$(document).ready(function () {

		// Bloquear los campos de entrada en modo detalle
		if(mode == "detail"){
			$(".lockOnDetail").attr("disabled", "");
			$("#optOffices option[value*='${serviceOrder.officeId}']").prop("selected", true);
		}

		if(hasPolicy == "true"){
			$(".lockOnPolicy").attr("disabled", "");
		}
		// Auto-llenar campos iniciales (solo para OS nuevas)
		if(mode == "new"){
			if(isEng == "true"){
				$("#serviceDate").val(dateNow());
			}
			else{
				$("#serviceDate").val("");
			}

			if(isEng == "true"){
				$("#responsibleName").val("${ user.userName }");
				$("#responsible").val("${ user.userEmail }");
			}

			var strEpmloyees = '${serviceEmployees}';
			var empData = $.parseJSON(strEpmloyees);

			$("#responsibleName").bind( "keydown", function( event ) {
		        if ( event.keyCode === $.ui.keyCode.TAB &&
		            $( this ).data( "ui-autocomplete" ).menu.active ) {
		          event.preventDefault();
		        }
		      }).autocomplete({
				minLength: 0,
				source: function( request, response ) {
		          response( $.ui.autocomplete.filter(
		            empData, extractLast( request.term ) ) );
		        },
				focus: function() {
		          return false;
		        },select: function( event, ui ) {
		        	var terms = this.value.split(/,\s*/);
		            terms.pop();
		            terms.push( ui.item.label );
		            terms.push( "" );
		            this.value = terms.join( ", " );

		            $("#responsible").val($("#responsible").val() + ";" + ui.item.value );
		            return false;
				}
			});

		    if(isEng == "true") {
		    	// Bloqueando campos no editables para Ing en Ordenes nuevas
		    	$(".lockForEng").attr("disabled", "");

			    // Sincronizando los campos de firma
			    $("#serviceOrder").submit(function(){
					$("#signCreated").val($("#signCreatedCapture").val())
					$("#signReceivedBy").val($("#signReceivedByCapture").val())
				});
		    }

			// Ocultar campos dependientes de perfil
			$(".eligible").hide();

			// Mostrar campos para solo para Coordinador
			if(isCoord == "true"){
				$(".coorOnly").show();
			}

			// Mostrar campos solo para Ingenieros
			if(isEng == "true"){
				$(".engOnly").show();
			}

			// Deshabilitar required para campos ocultos
			$("body").find(":hidden").not("script").removeAttr("required");		

			// Habilitar datetime picker
			$("#serviceDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});
			$("#serviceEndDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});

			// Binding ticketId
			$("#ticketList").bind("change", function(){
				$("#ticketId").val($(this).val());
			});

			$('.hideOnNew').hide();
		}

		// Binding serviceTypes con campo oculto de tipo de servicio
		$("#serviceTypes").bind("change", function(){
			$("#serviceTypeId").val($(this).val());
			$("#serviceType").val($('#serviceTypes').find('option:selected').text());
		});
		$("#serviceType").val($('#serviceTypes').find('option:selected').text());

		// Binding equipmentTypes con campo oculto de tipo de servicio
		$("#equipmentTypeList").bind("change", function(){
			$("#equipmentTypeId").val($(this).val());
			$("#equipmentType").val($("option:selected", this).text());
		});
		$("#equipmentType").val($('#equipmentTypeList').find('option:selected').text());

		// Cierre de la OS
		$("#closeBtn").bind("click", function(){
			$("#serviceStatusId").val('C');
			$("#closed").val(dateNow());
			$('#serviceOrder').submit();
		});

		// Binding officeId
		$("#optOffices").bind('change', function(){
			$("#officeId").val($(this).val());
		});

		$("#officeId").val("G"); // valor inicial

		// bloqueando lockOnEngDetail
		if(isEng == "true" && mode == "detail"){
			$(".lockOnEngDetail").attr("disabled", "");
		}

	});

	function validate(){
		if($("#responsible").val() == ""){
			$("#responsibleName").val("");
			$("#InvalidMessage").html("Por favor asigne al ingeniero responsable");
			return false;
		}
		
		var startTimestamp = Date.parseExact($("#serviceDate").val(), 'dd/MM/yyyy HH:mm:ss');
		if(startTimestamp == undefined || startTimestamp == null){
			$("#InvalidMessage").html("Por favor revise la fecha y hora del servicio");
			return false;
		}

		if(isCoord == "true" && mode == "new"){
			var endTimestamp = Date.parseExact($("#serviceEndDate").val(), 'dd/MM/yyyy HH:mm:ss');
			if(endTimestamp == undefined || endTimestamp == null){
				$("#InvalidMessage").html("Por favor revise la fecha y hora de salida");
				return false;
			}
			if(endTimestamp < startTimestamp){
				$("#InvalidMessage").html("Por favor revise la fecha y hora de salida");
				return false;
			}
		}

		if(isEng == "true"){
			$("#serviceEndDate").val(dateNow());
			if($("#signCreatedCapture").val().trim().length == 0 || $("#signReceivedByCapture").val().trim().length == 0){
				$("#InvalidMessage").html("Por favor firme la OS");
				return false;
			}
		}

		if($('#serviceOrder')[0].checkValidity()){
			$('input').removeAttr("disabled");
			$('select').removeAttr("disabled");
			$('textarea').removeAttr("disabled");
			if($("#responsible").val().indexOf(';') == 0){
				$("#responsible").val($("#responsible").val().substring(1));
			}
			return true;
		}
		else{
			setTimeout(function() { $(event.target).focus();}, 50);
		}

		return false;
	}

	function saveIfConnected(){
		$.get("${pageContext.request.contextPath}/dashboard/ping.do", function(data){
			// send to server
			$.post("${pageContext.request.contextPath}/plainService/save.do", $("#serviceOrder").serialize()).
				done(function(){
					$( "#WaitMessage" ).dialog('close');
					$( "#OkMessage" ).dialog('open');
				}).
				fail(function(){
					$( "#WaitMessage" ).dialog('close');
					$( "#FailMessage" ).dialog('open');
				});
		}).
		fail(function(){
			// localSave for later send
			if(typeof(Storage) !== "undefined") {
			    // Code for localStorage/sessionStorage.
			    var osName = $("#serviceOrderNumber").val();
			    if(localStorage.blackstar_osIndex){
			    	localStorage.blackstar_osIndex = localStorage.blackstar_osIndex + ',' + osName;
			    }
			    else{
			    	localStorage.blackstar_osIndex = osName;
			    }
			    
			    localStorage.setItem("blackstarKey" + osName, "OS")
			    localStorage.setItem("blackstarContent" + osName, $("#serviceOrder").serialize());

			    $( "#WaitMessage" ).dialog('close');
				$( "#OfflineSaveMessage" ).dialog('open');
			} else {
			    $( "#WaitMessage" ).dialog('close');
			    $( "#InvalidMessage" ).html("No fué posible conectar con el servidor y el dispositivo no soporta almacenamiento local, por favor espere a tener conexión e intente de nuevo");
				$( "#InvalidMessage" ).dialog('open');
			}
		});
	}

	function saveService(){
		if(validate()){
			// sincronizando firma
			$("#signCreated").val($("#signCreatedCapture").val())
			$("#signReceivedBy").val($("#signReceivedByCapture").val())
			// enviando
			$( "#WaitMessage" ).dialog('open');
			saveIfConnected();
		}
		else{
			$( "#InvalidMessage" ).dialog('open');
		}
	}

	</script> 
	
	</head>
	<body>
		<div id="content" class="container_16 clearfix">
		<form:form  commandName="serviceOrder" action="/plainService/save.do" method="POST">			
			<div class="grid_16">					
					<div class="box">
						<h2>ORDEN DE SERVICIO</h2>
							<table>
								<tr>
									<td style="width:140px">Folio:</td>
									<td style="width:300px"><form:input path="serviceOrderNumber" type="text" style="width:65%;" maxlength="5" readOnly="true" required="true"/>
										<c:if test="${serviceOrder.serviceOrderId > 0 && serviceOrder.hasPdf == 1}">
											<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>
										</c:if>	
										<form:input path="serviceOrderId" type="hidden"/>
									</td>
									<td style="width:140px">No. de ticket</td>
									<td>
										<form:hidden path="ticketId" />
										<form:hidden path="ticketNumber" />
										<form:hidden path="hasPdf" />
										<form:hidden path="finalUser" />
										<select class="lockOnDetail lockForEng" id="ticketList">
											<option value="">NA</option>
											<c:forEach var="ticket" items="${ticketList}">
										        <option value="${ticket.ticketId}" 
										        <c:if test="${serviceOrder.ticketId == ticket.ticketId}">
										        	selected="true"
										    	</c:if>
										        >${ticket.ticketNumber}</option>
										    </c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<td>Cliente</td>
									<td colspan="3"><form:input cssClass="lockOnDetail" path="customer" type="text" style="width:95%;" required="true"/></td>
									<form:input path="openCustomerId" type="hidden"/>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="3"><form:textarea cssClass="lockOnDetail lockOnPolicy" path="equipmentAddress" style="width:95%;height:50px;" required="true"></form:textarea></td>
								</tr>
								<tr>
									<td>Solicitante</td>
									<td><form:textarea cssClass="lockOnDetail" path="requestedBy" style="width:95%;height:50px;" required="true"></form:textarea></td>
									<td>Teléfono</td>
									<td><form:input type="text" cssClass="lockOnDetail lockOnPolicy" path="contactPhone" style="width:95%;"  required="true"/></td>
								</tr>
								<tr>
									<td>Equipo</td>
									<td>
										<form:hidden path="equipmentTypeId" />
										<select class="lockOnDetail lockOnPolicy" id="equipmentTypeList">
											<c:forEach var="etype" items="${equipmentTypeList}">
										        <option value="${etype.equipmentTypeId}" 
										        <c:if test="${etype.equipmentTypeId == serviceOrder.equipmentTypeId}">
										        	selected="true"
										    	</c:if>
										        >${etype.equipmentType}</option>
										    </c:forEach>
										</select>
										<form:hidden path="equipmentType"/>
									</td>
									<td>Oficina</td>
									<td>
										<form:hidden path="officeId"/>
										<select class="lockOnDetail lockOnPolicy" id="optOffices">
											<c:forEach var="office" items="${offices}">
										        <option value="${office}" 
										        <c:if test="${serviceOrder.officeId == fn:substring(office, 0, 1)}">
										        	selected="true"
										    	</c:if>
										        >${office}</option>
										    </c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<td>Marca</td>
									<td><form:input cssClass="lockOnDetail lockOnPolicy" path="brand" type="text" style="width:95%;" required="true"/></td>
									<td>Modelo</td>
									<td><form:input cssClass="lockOnDetail lockOnPolicy" path="model" type="text" style="width:95%;" required="true"/></td>
								<tr>
									<td>Serie</td>
									<td><form:input cssClass="lockOnDetail lockOnPolicy" path="serialNumber" type="text" style="width:95%;" required="true"/></td>	
									<td>Contrato / Proyecto</td>
									<td colspan="3"><form:input cssClass="lockOnDetail lockOnPolicy" path="project" type="text" style="width:95%;" required="true"/></td>							
								</tr>
								<tr>
									<td>Tipo:</td>
									<td>
										<form:hidden path="serviceTypeId" />
										<form:hidden path="serviceType" />
										<select class="lockOnDetail" id="serviceTypes">
											<c:forEach var="stype" items="${serviceTypes}">
										        <option value="${stype.serviceTypeId}" 
										        <c:if test="${stype.serviceTypeId == serviceOrder.serviceTypeId}">
										        	selected="true"
										    	</c:if>
										        >${stype.serviceType}</option>
										    </c:forEach>
										</select>
									</td>
									<td>Estatus:</td>
									<td>
										<form:hidden path="serviceStatusId" />
										<select name="" id="serviceStatuses" disabled>
											<c:forEach var="ss" items="${serviceStatuses}">
												<option value="ss.serviceStatusId"
												<c:if test="${ss.serviceStatusId == serviceOrder.serviceStatusId}">
													selected="true"
												</c:if>
												>${ss.serviceStatus}</option>
											</c:forEach>
											<option value=""></option>
										</select>
									</td>
								</tr>
								<tr>
									<td>Fecha y hora de llegada</td>
									<td><form:input cssClass="lockOnDetail" path="serviceDate" type="text" style="width:95%;" required="true"/></td>
									<td>Fecha y hora de cierre</td>
									<td><form:input path="closed" type="text" style="width:95%;" readOnly="true"/></td>
								</tr>
							</table>
						</div>					
					</div>
			<div class="grid_16">
				<div class="box">
					<h2>Detalles</h2>
						<table  class="eligible engOnly">
							<thead>
								<tr>
									<th>Situacion encontrada</th>
									<th>Trabajos realizados</th>
								</tr>
							</thead>
							<tr>
								<td style="height:100px;">
									<form:textarea cssClass="lockOnDetail" path="troubleDescription"  style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
								<td rowspan="3" style="height:100px;">
									<form:textarea cssClass="lockOnDetail" path="workDone"  style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
							</tr>
							<thead>
								<tr>
									<th>Parametros tecnicos</th>
								</tr>
							</thead>
							<tr>
								<td style="height:100px;">
									<form:textarea cssClass="lockOnDetail" path="techParam"  style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
							</tr>
						</table>
						<table class="eligible engOnly">
							<thead>
								<tr>
									<th>Requerimientos o material utilizado</th>
								</tr>
							</thead>
							<tr>
								<td style="height:140px;">
									<form:textarea cssClass="lockOnDetail" path="materialUsed"   style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
							</tr>
						</table>
						<table>
							<thead>
								<tr>
									<th>Observaciones / Estatus del equipo</th>
								</tr>
							</thead>
							<tr>
								<td style="height:140px;">
									<form:textarea cssClass="lockOnDetail" path="observations"   style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
							</tr>
						</table>
							<table>
								<thead>
									<tr>
										<th colspan="2" style="width:410px">Realizado Por</th>
										<th colspan="2">Servicio y/o equipo recibido a mi entera satisfaccion</th>
									</tr>
								</thead>
								<tr class="eligible engOnly">
									<td colspan="2">
										<span>Firma</span>
										<div id="leftSign" class="signBox">
											<canvas class="signPad" width="330" height="115"></canvas>
										</div>
									</td>
									<td colspan="2" >
										<span>Firma</span>
										<div id="rightSign" class="signBox">
											<canvas class="signPad" width="330" height="115"></canvas>
										</div>
									</td>
								</tr>
								<tr>
									<td>Nombre</td>
									<td><form:input cssClass="lockOnDetail" path="responsibleName" type="text" style="width:95%;" required="true"/></td>
									<form:hidden path="responsible" style="width:95%;"/>
									<td>Nombre</td>
									<td><form:input cssClass="lockOnDetail" path="receivedBy" type="text" style="width:95%;"/></td>
								</tr>
								<tr>
									<td>Fecha y hora de salida</td>
									<td><form:input cssClass="lockOnDetail lockForEng" path="serviceEndDate" type="text" style="width:95%;" required="true"/></td>
									<td>Puesto</td>
									<td><form:input cssClass="lockOnDetail" path="receivedByPosition"  style="width:95%;" /></td>
								</tr>	
								<tr>
									<td colspan="2"></td>
									<td>Email</td>
									<td><form:input cssClass="lockOnDetail" path="receivedByEmail"  style="width:95%;" /></td>
								</tr>
								<c:if test="${!user.belongsToGroup['Cliente']}">
									<tr class="eligible coorOnly">
										<td colspan="2">Errores de captura<form:checkbox path="isWrong" cssClass="lockOnEngDetail"/></td>
										<td></td>
										<td></td>
									</tr>
									<!-- Link a enuesta de servicio -->
									<c:choose>
										<c:when test="${serviceOrder.surveyServiceId > 0}">
											<tr class="hideOnNew">
												<td colspan="2">Resultado de encuesta: 
													<form:input path="surveyScore" cssClass="lockOnEngDetail" style="width:20px;" disabled="true"/>
													<a href="${pageContext.request.contextPath}/surveyServiceDetail/show.do?operation=2&idObject=${serviceOrder.surveyServiceId}">Ir a Encuesta de Servicio</a>
												</td>
												<td></td>
											</tr>
										</c:when>
										<c:otherwise>
											<tr class="hideOnNew">
												<td colspan="2">Sin encuesta de servicio</td>
												<td></td>
											</tr>
										</c:otherwise>
									</c:choose>
								</c:if>
							</table>

							<table>
								<tbody>
									<tr>
										<td>
										</td>
									</tr>
								<tbody>
							</table>
					</div>
				</div>
										
					<form:hidden path="policyId"/>

					<!-- Campos de firma -->
					<form:hidden path="signCreated"/>
			        <form:hidden path="signReceivedBy"/>

			        <!-- Arvhivo de OS importado -->
			        <form:hidden path="loadedOSFileId"/>
			</form:form>

			<!-- Fragmento de Firma -->
			<c:if test="${user.belongsToGroup['Implementacion y Servicio'] || mode=='detail'}">
				<c:import url="signatureFragment.jsp"></c:import>
			</c:if>
			
			<!-- Importacion del archivo de OS desde GDrive -->
			<c:if test="${(user.belongsToGroup['Coordinador'] || user.belongsToGroup['Call Center']) && serviceOrder.hasPdf != 1}">
				<c:import url="osLoader.jsp"></c:import>
				<script type="text/javascript" charset="utf-8">
					$(function(){
						osLoader_init("loadedOSFileId");
					});
				</script>
			</c:if>

			<!-- Adjuntos -->
			<c:if test="false">
				<c:import url="_attachments.jsp"></c:import>
			</c:if>

			<!-- Control de secuencia y captura de seguimiento -->
			<c:if test="${!user.belongsToGroup['Cliente']}">
				<c:import url="followUpControl.jsp"></c:import>
			
				<script type="text/javascript" charset="utf-8">
					$(function(){
						initFollowUpDlg("os", "/osDetail/show.do?serviceOrderId=${serviceOrder.serviceOrderId}");
					});
				</script>
			</c:if>
			
			<c:if test="${!user.belongsToGroup['Cliente']}">
				<table>
					<tbody>
						<tr>
							<td>
							<c:if test="${serviceOrder.serviceOrderId > 0}">
								<button class="searchButton" onclick="addSeguimiento(${serviceOrder.serviceOrderId}, '${serviceOrder.serviceOrderNumber}');">Agregar seguimiento</button>
								<c:if test="${serviceOrder.serviceStatusId != 'C'}">
									<button class="searchButton eligible coorOnly lockOnEngDetail" id="closeBtn">Cerrar</button>
								</c:if>	
							</c:if>	
							<input class="searchButton lockOnEngDetail" id="guardarServicio" type="submit" onclick="saveService(); return false;" value="Guardar servicio" form="serviceOrder"/>
							<input class="searchButton lockOnDetail" id="guardarServicioCrear" type="submit" onclick="saveAndNew(); return false;" value="Guardar y Nueva OS"/>
							<button class="searchButton" onclick="window.location = '/serviceOrders/show.do'">Cancelar</button>
							</td>
						</tr>
					</tbody>
				</table>
			</c:if>
		</div>
		<div id = "OsLinksImport">
				<c:import url="newOSLinks.jsp"></c:import>
		</div>
		<div id="WaitMessage" title="Guardar Orden de servicio" style="text-align:center">
			Guardando Orden de servicio... <br><br> <img src="/img/processing.gif"/>
		</div>
		<div id="OkNewMessage" title="Orden de servicio guardada">
			La orden de servicio ${serviceOrder.serviceOrderNumber} se guardo exitosamente.
			<br>
			Seleccione Aceptar para crear la nueva orden de servicio.
		</div>
		<div id="OkMessage" title="Orden de servicio guardada">
			La orden de servicio ${serviceOrder.serviceOrderNumber} se guardo exitosamente.
			<br>
			Seleccione Aceptar para volver al inicio.
		</div>
		<div id="FailMessage" title="Error al guardar la OS">
			Ocurrio un error al guardar la orden de servicio ${serviceOrder.serviceOrderNumber}. Por favor verifique los datos e intente nuevamente
		</div>
		<div id="InvalidMessage" title="Revise los datos de la OS">
			Por favor revise que todos los campos hayan sido llenados.
		</div>
		<div id="OfflineSaveMessage" title="Revise los datos de la OS">
			No fué posible conectar con el servidor. La OS fue guardada temporalmente en el dispositivo. Será enviada al servidor al recuperar la conexión.
		</div>
	</body>
	<script type="text/javascript">
		$(function(){
			$("#OsLinksImport").hide();

			$( "#OkNewMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 450,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
		          showEquipmentSelect('X');
		        }
		      }
		    });

		    $( "#OkMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 450,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
					window.location = '/dashboard/show.do';
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

		    $( "#OfflineSaveMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
	        	 Aceptar: function() {
		         	$( this ).dialog( "close" );
					window.location = '/dashboard/show.do';
		        }
		      }
		    });

		    $("#selectSNDialog").dialog({
				autoOpen: false,
				height: 290,
				width: 360,
				modal: true,
				buttons: {
					"Aceptar": function() {
						if(selected){
						  okChain("policy", loadedType);
						} else {
							$( this ).dialog( "close" );
						}
					},
					"Sin Poliza": function(){
						okChain("open", loadedType);
					},

					"Cancelar": function() {
						$( this ).dialog( "close" );
						window.location = '/dashboard/show.do';
					}
				}
			});	
			
			$(".info").hide();

		});

		function saveAndNew(){
			if(validate()){
				// sincronizando firma
				$("#signCreated").val($("#signCreatedCapture").val())
				$("#signReceivedBy").val($("#signReceivedByCapture").val())
				// enviando
				$( "#WaitMessage" ).dialog('open');
				$.post("/plainService/save.do", $("#serviceOrder").serialize()).
				done(function(){
					$( "#WaitMessage" ).dialog('close');
					$( "#OkNewMessage" ).dialog('open');
				});
			}
		}
	</script>
</html>