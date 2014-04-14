<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
	<script type="text/javascript" charset="utf-8">

	function split( val ) {
      return val.split( /,\s*/ );
    }

    function extractLast( term ) {
      return split( term ).pop();
    }

	$(document).ready(function () {
		var mode = "${mode}";
		var isCoord = "${user.belongsToGroup['Coordinador']}";
		var isEng = "${user.belongsToGroup['Implementacion y Servicio']}";
		var hasPolicy = "${hasPolicy}";

		// Bloquear los campos de entrada en modo detalle
		if(mode == "detail"){
			$(".lockOnDetail").attr("disabled", "");
		}

		if(hasPolicy == "true"){
			$(".lockOnPolicy").attr("disabled", "");
		}
		// Auto-llenar campos iniciales (solo para OS nuevas)
		if(mode == "new"){
			if(isEng == "true"){
				$("#serviceDate").val(dateNow());
			}

			$("#responsibleName").val("${ user.userName }");
			$("#responsible").val("${ user.userEmail }");
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

		    if(isEng) {
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
		}

		// Binding serviceTypes con campo oculto de tipo de servicio
		$("#serviceTypes").bind("change", function(){
			$("#serviceTypeId").val($(this).val());
			$("#serviceType").val($('#serviceTypes').find('option:selected').text());
		});

		// Binding equipmentTypes con campo oculto de tipo de servicio
		$("#equipmentTypesList").bind("change", function(){
			$("#equipmentTypeId").val($(this).val());
		});
		
		// inicializando el dialogo para agregar seguimientos
		if(mode == "new"){
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrder.serviceOrderId}");			
		}

		// Cierre de la OS
		$("#closeBtn").bind("click", function(){
			$("serviceStatusId").val('C');
		});
	});

	</script> 
	
	</head>
	<body>
		<div id="content" class="container_16 clearfix">
		<form:form  commandName="serviceOrder" action="save.do" method="POST">			
			<div class="grid_16">					
					<div class="box">
						<h2>ORDEN DE SERVICIO</h2>
							<table>
								<tr>
									<td>Folio:</td>
									<td><form:input path="serviceOrderNumber" type="text" style="width:95%;" maxlength="5" readOnly="true" required="true"/></td>
									<td colspan="2">
										<c:if test="${serviceOrder.serviceOrderId > 0}">
											<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=${serviceOrder.serviceOrderId}' target="_blank">Ver PDF</a><img src='${pageContext.request.contextPath}/img/pdf.png'/>
										</c:if>	
									</td>
								</tr>
								<tr>
									<td>Cliente</td>
									<td colspan="5"><form:input class="lockOnDetail lockOnPolicy" path="customer" type="text" style="width:95%;" required="true"/></td>
									<td>No. de ticket</td>
									<td colspan="3"><form:input class="lockOnDetail" path="ticketNumber" type="text" style="width:95%;"/></td>
								</tr>
								<tr>
									<td>Domicilio</td>
									<td colspan="5"><form:textarea class="lockOnDetail lockOnPolicy" path="equipmentAddress" style="width:95%;height:50px;" required="true"></form:textarea></td>
									<td>Fecha y hora de llegada</td>
									<td colspan="3"><form:input class="lockOnDetail lockForEng" path="serviceDate" type="text" style="width:95%;" required="true"/></td>
								</tr>
								<tr>
									<td>Solicitante</td>
									<td colspan="5"><form:textarea class="lockOnDetail" path="finalUser" style="width:95%;height:50px;" required="true"></form:textarea></td>
									<td>Teléfono</td>
									<td><form:input type="text" class="lockOnDetail" path="contactPhone" style="width:95%;"  required="true"/></td>
								</tr>
								
								<tr>
									<td>Equipo</td>
									<td colspan="5">
										<form:hidden path="equipmentTypeId" />
										<select class="lockOnDetail" id="equipmentTypeList">
											<c:forEach var="etype" items="${equipmentTypeList}">
										        <option value="${etype.equipmentTypeId}" 
										        <c:if test="${etype.equipmentTypeId == serviceOrder.equipmentTypeId}">
										        	selected="true"
										    	</c:if>
										        >${etype.equipmentType}</option>
										    </c:forEach>
										</select>
									</td>
									<td style="padding-left:10px;">Marca</td>
									<td><form:input class="lockOnDetail lockOnPolicy" path="brand" type="text" style="width:95%;" required="true"/></td>
									<td>Modelo</td>
									<td><form:input class="lockOnDetail lockOnPolicy" path="model" type="text" style="width:95%;" required="true"/></td>
									<td>Serie</td>
									<td><form:input class="lockOnDetail lockOnPolicy" path="serialNumber" type="text" style="width:95%;" required="true"/></td>								
								</tr>
								<tr>
									<td>Tipo:</td>
									<td colspan="5">
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
									<td>Contrato / Proyecto</td>
									<td colspan="3"><form:input class="lockOnDetail lockOnPolicy" path="project" type="text" style="width:95%;" required="true"/></td>
								</tr>
								<tr>
									<td>Estatus:</td>
									<td colspan="5">
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
									<form:textarea class="lockOnDetail" path="troubleDescription"  style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
								<td rowspan="3" style="height:100px;">
									<form:textarea class="lockOnDetail" path="workDone"  style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
							</tr>
							<thead>
								<tr>
									<th>Parametros tecnicos</th>
								</tr>
							</thead>
							<tr>
								<td style="height:100px;">
									<form:textarea class="lockOnDetail" path="techParam"  style="width:100%;height:100%;" required="true"></form:textarea>
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
									<form:textarea class="lockOnDetail" path="materialUsed"   style="width:100%;height:100%;" required="true"></form:textarea>
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
									<form:textarea class="lockOnDetail" path="observations"   style="width:100%;height:100%;" required="true"></form:textarea>
								</td>
							</tr>
						</table>
							<table>
								<thead>
									<tr>
										<th colspan="2">Realizado Por</th>
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
									<td><form:input class="lockOnDetail" path="responsibleName" type="text" style="width:95%;" required="true"/></td>
									<form:hidden path="responsible" style="width:95%;"/>
									<td>Nombre</td>
									<td><form:input class="lockOnDetail" path="receivedBy" type="text" style="width:95%;"/></td>
								</tr>
								<tr>
									<td colspan="2"></td>
									<td>Puesto</td>
									<td><form:input class="lockOnDetail" path="receivedByPosition"  style="width:95%;" /></td>
								</tr>	
								<tr>
									<td colspan="2"></td>
									<td>Email</td>
									<td><form:input class="lockOnDetail" path="receivedByEmail"  style="width:95%;" /></td>
								</tr>
								<tr class="eligible coorOnly">
									<td>Errores de captura<form:checkbox path="isWrong" /></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</table>

							<table>
								<tbody>
									<tr>
										<td>
											<input class="searchButton" id="guardarServicio" type="submit" value="Guardar servicio">
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
			</form:form>

			<!-- Fragmento de Firma -->
			<c:if test="${user.belongsToGroup['Implementacion y Servicio']}">
				<c:import url="signatureFragment.jsp"></c:import>
			</c:if>
			
			<!-- Adjuntos -->
			<c:import url="_attachments.jsp"></c:import>

			<!-- Control de secuencia y captura de seguimiento -->
			<c:import url="followUpControl.jsp"></c:import>
			<script type="text/javascript" charset="utf-8">
				$(function(){
					initFollowUpDlg("os", "/osDetail/show.do?serviceOrderId=${serviceOrder.serviceOrderId}");
				});
			</script>
			<c:if test="${serviceOrder.serviceOrderId > 0}">
				<table>
					<tbody>
						<tr>
							<td>
								<button class="searchButton" onclick="addSeguimiento(${serviceOrder.serviceOrderId}, '${serviceOrder.serviceOrderNumber}');">Agregar seguimiento</button>
								<button class="searchButton eligible coorOnly" id="closeBtn">Cerrar</button>
							</td>
						</tr>
					<tbody>
				</table>
			</c:if>	
		</div>
	</body>
</html>