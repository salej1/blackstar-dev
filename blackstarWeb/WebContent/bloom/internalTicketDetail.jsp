<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="requisiciones" />
<c:import url="/header.jsp"></c:import>

<body>

<script type="text/javascript">

  var followType;
	  
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
	};

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
				        data: "ticketId=${ticketDetail._id}&deliverableTypeId=" + $("#attachmentType").val() + 
				        		"&prevId=" + $('#attachmentFileId').val() + 
				        		"&deliverableName=" + $("#attachmentType option:selected").text() + 
				        		"&ticketNumber=${ticketDetail.ticketNumber}"
				    })
				    .done(function(){
			        	$('#attachmentDlg').dialog( "close" );
			        	location.reload();
				    });
				}}
		});
		
		//Save confirm dialog
		$("#resolveConfirm").dialog({
			autoOpen: false,
			height: 250,
			width: 380,
			modal: true,
			buttons: {
					"Aceptar": function() {
						window.location.href = 'resolve.do?ticketId=${ticketDetail._id}&userId=${ user.blackstarUserId }';
					},
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});

		$("#closeConfirm").dialog({
			autoOpen: false,
			height: 150,
			width: 380,
			modal: true,
			buttons: {
					"Aceptar": function() {
						window.location.href = 'close.do?ticketId=${ticketDetail._id}&userId=${ user.blackstarUserId }';
					},
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});
		
		
		//History dialog
		$("#historyDlg").dialog({
			autoOpen: false,
			height: 380,
			width: 500,
			modal: true,
			buttons: {
				"Cerrar": function() {
					$( this ).dialog( "close" );
			}}
		});

		// Seguimiento$("#seguimientoCapture").hide();
		$("#seguimientoCapture").hide();

		// Mosrtar - ocultar campos complementarios
		configureAdditionalFields();

		attLoader_init("attachmentFileId");
	});

		
	function addSeguimiento(type){
		var d = new Date(); 
		$("#seguimientoCapture").show();	
		$("#seguimientoStamp").html(d.format('dd/MM/yyyy hh:mm:ss') + ' ${ user.userName }');
		$("#seguimientoText").val('');
		$("#who").val("-1");
		followType = type;
		if(type == "1"){
			$("#assignamentArea").show();
		} else {
			$("#assignamentArea").hide(); 
		}
	}

	function applySeguimiento(){
		var who;
		if(followType == 1){
			who = $("#who").val();
		} else if(followType == 2){
			who = "";
		}else { 
			who = "${fn:length(followUps) > 0? followUps[fn:length(followUps)-1].createdByUsrEmail : ""}";
		}

		$("#followDetail").load("${pageContext.request.contextPath}/bloom/ticketDetail/addFollowUp.do?ticketId=${ticketDetail._id}&userId=${ user.blackstarUserId }" + "&userToAssign=" + who + "&comment=" + $("#seguimientoText").val().replace(/ /g, '%20'));
		$("#seguimientoCapture").hide();	
	}

	function cancelAddSeguimiento(){
		$("#seguimientoCapture").hide();
	}

	function customPickerCallBack(data) {
		$("#attachmentFileName").val(data.docs[0].name);
		$("#attachmentFileId").val(data.docs[0].id);
		$('#attachmentDlg').dialog('open');
	}


	function iniHideAdditionalFields(){
		
		$('#descrLabel').text("Descripción de la solicitud");
		
		$('#tr_purposeVisitVL').hide();
		$('#tr_purposeVisitVISAS').hide();
		$('#tr_draftCopyDiagramVED').hide();
		$('#tr_formProjectVED').hide();
		$('#tr_observationsVEPI').hide();
		$('#tr_draftCopyPlanVEPI').hide();
		$('#tr_formProjectVEPI').hide();
		$('#tr_observationsVRCC').hide();
		$('#tr_checkListVRCC').hide();
		$('#tr_formProjectVRCC').hide();
		$('#tr_questionVPT').hide();
		$('#tr_observationsVSA').hide();
		$('#tr_formProjectVSA').hide();
		$('#tr_productInformationVSP').hide();
		$('#tr_observationsISED').hide();
		$('#tr_draftCopyPlanISED').hide();
		$('#tr_observationsISRC').hide();
		$('#tr_attachmentsISRC').hide();
		$('#tr_apparatusTraceISSM').hide();
		$('#tr_observationsISSM').hide();
		$('#tr_questionISPT').hide();
		$('#tr_ticketISRPR').hide();
		$('#tr_modelPartISRPR').hide();
		$('#tr_observationsISRPR').hide();
		$('#tr_productInformationISSPC').hide();
		$('#tr_positionPGCAS').hide();
		$('#tr_collaboratorPGCAS').hide();
		$('#tr_justificationPGCAS').hide();
		$('#tr_salaryPGCAS').hide();
		$('#tr_positionPGCCP').hide();
		$('#tr_commentsPGCCP').hide();
		$('#tr_developmentPlanPGCCP').hide();
		$('#tr_targetPGCCP').hide();
		$('#tr_salaryPGCCP').hide();
		$('#tr_positionPGCNC').hide();
		$('#tr_developmentPlanPGCNC').hide();
		$('#tr_targetPGCNC').hide();
		$('#tr_salaryPGCNC').hide();
		$('#tr_justificationPGCNC').hide();
		$('#tr_positionPGCF').hide();
		$('#tr_collaboratorPGCF').hide();
		$('#tr_justificationPGCF').hide();
		$('#tr_positionPGCAA').hide();
		$('#tr_collaboratorPGCAA').hide();
		$('#tr_justificationPGCAA').hide();
		$('#tr_requisitionFormatGRC').hide();
		$('#tr_linkDocumentGM').hide();
		$('#tr_suggestionGSM').hide();
		$('#tr_documentCodeGSM').hide();
		$('#tr_justificationGSM').hide();
		$('#tr_problemDescriptionGPTR').hide();

		
		$('#sp_purposeVisitVL').text("");
		$('#sp_purposeVisitVISAS').text("");
		$('#sp_draftCopyDiagramVED').text("");
		$('#sp_formProjectVED').text("");
		$('#sp_observationsVEPI').text("");
		$('#sp_draftCopyPlanVEPI').text("");
		$('#sp_formProjectVEPI').text("");
		$('#sp_observationsVRCC').text("");
		$('#sp_checkListVRCC').text("");
		$('#sp_formProjectVRCC').text("");
		$('#sp_questionVPT').text("");
		$('#sp_observationsVSA').text("");
		$('#sp_formProjectVSA').text("");
		$('#sp_productInformationVSP').text("");
		$('#sp_observationsISED').text("");
		$('#sp_draftCopyPlanISED').text("");
		$('#sp_observationsISRC').text("");
		$('#sp_attachmentsISRC').text("");
		$('#sp_apparatusTraceISSM').text("");
		$('#sp_observationsISSM').text("");
		$('#sp_questionISPT').text("");
		$('#sp_ticketISRPR').text("");
		$('#sp_modelPartISRPR').text("");
		$('#sp_observationsISRPR').text("");
		$('#sp_productInformationISSPC').text("");
		$('#sp_positionPGCAS').text("");
		$('#sp_collaboratorPGCAS').text("");
		$('#sp_justificationPGCAS').text("");
		$('#sp_salaryPGCAS').text("");
		$('#sp_positionPGCCP').text("");
		$('#sp_commentsPGCCP').text("");
		$('#sp_developmentPlanPGCCP').text("");
		$('#sp_targetPGCCP').text("");
		$('#sp_salaryPGCCP').text("");
		$('#sp_positionPGCNC').text("");
		$('#sp_developmentPlanPGCNC').text("");
		$('#sp_targetPGCNC').text("");
		$('#sp_salaryPGCNC').text("");
		$('#sp_justificationPGCNC').text("");
		$('#sp_positionPGCF').text("");
		$('#sp_collaboratorPGCF').text("");
		$('#sp_justificationPGCF').text("");
		$('#sp_positionPGCAA').text("");
		$('#sp_collaboratorPGCAA').text("");
		$('#sp_justificationPGCAA').text("");
		$('#sp_requisitionFormatGRC').text("");
		$('#sp_linkDocumentGM').text("");
		$('#sp_suggestionGSM').text("");
		$('#sp_documentCodeGSM').text("");
		$('#sp_justificationGSM').text("");
		$('#sp_problemDescriptionGPTR').text("");
	}

	function configureAdditionalFields() {

		iniHideAdditionalFields();

		var serviceTypeId = parseInt($('#slTipoServicio').val());

		if (serviceTypeId === 1) {

			$('#tr_purposeVisitVL').show();

			$('#sp_purposeVisitVL')
					.text("Tipo de Equipo a ofertar o revisar o liga de Cédula de Proyectos");

		}
		if (serviceTypeId === 2) {

			$('#tr_purposeVisitVISAS').show();

			$('#sp_purposeVisitVISAS')
					.text("Tipo de Equipo a ofertar o revisar o liga de Cédula de Proyectos");

		}
		if (serviceTypeId === 3) {
			$('#tr_draftCopyDiagramVED').show();
			$('#tr_formProjectVED').show();

			$('#sp_draftCopyDiagramVED').text("Diagrama en borrador");
			$('#sp_formProjectVED').text("Cédula de Proyectos");

		}
		if (serviceTypeId === 4) {

			$('#tr_observationsVEPI').show();
			$('#tr_draftCopyPlanVEPI').show();
			$('#tr_formProjectVEPI').show();

			$('#sp_observationsVEPI').text("Observaciones y/o ligas de fotos");
			$('#sp_draftCopyPlanVEPI').text("Plano en borrador");
			$('#sp_formProjectVEPI').text("Cédula de Proyectos");

		}
		if (serviceTypeId === 5) {

			$('#tr_observationsVRCC').show();
			$('#tr_checkListVRCC').show();
			$('#tr_formProjectVRCC').show();

			$('#sp_observationsVRCC').text("Observaciones y/o ligas de fotos");
			$('#sp_checkListVRCC').text(
					"Check-List de Levantamiento o lista de materiales a utilizar");
			$('#sp_formProjectVRCC').text("Cédula de Proyectos");

		}
		if (serviceTypeId === 6) {

			$('#descrLabel').text("Pregunta");

		}
		if (serviceTypeId === 7) {

			$('#tr_observationsVSA').show();
			$('#tr_formProjectVSA').show();

			$('#sp_observationsVSA').text("Observaciones y/o ligas de mas anexos");
			$('#sp_formProjectVSA').text("Cédula de Proyectos");

		}
		if (serviceTypeId === 8) {

			$('#tr_productInformationVSP').show();

			$('#sp_productInformationVSP').text("Producto a solicitar Precio (Marca, modelo, descripción)");

		}
		if (serviceTypeId === 9) {

			$('#tr_draftCopyPlanISED').show();

			$('#sp_draftCopyPlanISED').text("Diagrama o Plano en borrador");

		}
		if (serviceTypeId === 10) {

			$('#tr_observationsISRC').show();
			$('#tr_attachmentsISRC').show();

			$('#sp_observationsISRC').text("Ligas de fotos");
			$('#sp_attachmentsISRC').text("Anexar Datos Descargados del Analizador");

		}
		if (serviceTypeId === 11) {

			$('#tr_apparatusTraceISSM').show();
			$('#tr_observationsISSM').show();
			$('#tr_questionISSM').show();

			$('#sp_apparatusTraceISSM').text("Equipo a monitorear (marca, modelo)");
			$('#sp_observationsISSM').text("Observaciones (incluir interface utilizada) y/o ligas de fotos");

		}
		if (serviceTypeId === 12) {

			$('#descrLabel').text("Pregunta");

		}
		if (serviceTypeId === 13) {

			$('#tr_ticketISRPR').show();
			$('#tr_modelPartISRPR').show();
			$('#tr_observationsISRPR').show();

			$('#sp_ticketISRPR').text("Ticket");
			$('#sp_modelPartISRPR').text("Modelo, Marca y N\u00famero de parte");
			$('#sp_observationsISRPR').text("Observaciones y/o ligas de anexos como fotos");

		}
		if (serviceTypeId === 14) {

			$('#tr_productInformationISSPC').show();

			$('#sp_productInformationISSPC').text("Producto a solicitar Precio (Marca, modelo, descripción)");

		}
		if (serviceTypeId === 15) {
		}
		if (serviceTypeId === 16) {

			$('#tr_positionPGCAS').show();
			$('#tr_collaboratorPGCAS').show();
			//$('#tr_justificationPGCAS').show();
			$('#tr_salaryPGCAS').show();

			$('#sp_positionPGCAS').text("Puesto");
			$('#sp_collaboratorPGCAS').text("Nombre del colaborador");
			$('#descrLabel').text("Justificación del requerimiento");
			$('#sp_salaryPGCAS').text("Sueldo");

		}
		if (serviceTypeId === 17) {

			$('#tr_positionPGCCP').show();
			$('#tr_commentsPGCCP').show();
			$('#tr_developmentPlanPGCCP').show();
			$('#tr_targetPGCCP').show();
			$('#tr_salaryPGCCP').show();

			$('#sp_positionPGCCP').text("Puesto");
			$('#sp_commentsPGCCP').text("Comentarios o Preferencias");
			$('#sp_developmentPlanPGCCP').text("Plan de desarrollo");
			$('#sp_targetPGCCP').text("Objetivos");
			$('#sp_salaryPGCCP').text("Sueldo");

		}
		if (serviceTypeId === 18) {

			$('#tr_positionPGCNC').show();
			$('#tr_developmentPlanPGCNC').show();
			$('#tr_targetPGCNC').show();
			$('#tr_salaryPGCNC').show();
			//$('#tr_justificationPGCNC').show();

			$('#sp_positionPGCNC').text("Puesto");
			$('#sp_developmentPlanPGCNC').text("Plan de desarrollo");
			$('#sp_targetPGCNC').text("Objetivos");
			$('#sp_salaryPGCNC').text("Sueldo");
			$('#descrLabel').text("Justificación del requerimiento");

		}
		if (serviceTypeId === 19) {

			$('#tr_positionPGCF').show();
			$('#tr_collaboratorPGCF').show();
			//$('#tr_justificationPGCF').show();

			$('#sp_positionPGCF').text("Puesto");
			$('#sp_collaboratorPGCF').text("Nombre del colaborador");
			$('#descrLabel').text("Justificación del requerimiento");

		}
		if (serviceTypeId === 20) {

			$('#tr_positionPGCAA').show();
			$('#tr_collaboratorPGCAA').show();
			// $('#tr_justificationPGCAA').show();

			$('#sp_positionPGCAA').text("Puesto");
			$('#sp_collaboratorPGCAA').text("Nombre del colaborador");
			$('#descrLabel').text("Justificación del requerimiento");

		}
		if (serviceTypeId === 21) {

			$('#tr_requisitionFormatGRC').show();

			$('#sp_requisitionFormatGRC').text("Formato de requisición de curso de capacitación");

		}
		if (serviceTypeId === 22) {

			$('#tr_linkDocumentGM').show();

			$('#sp_linkDocumentGM').text("Liga del documento");

		}
		if (serviceTypeId === 23) {

			$('#tr_suggestionGSM').show();
			$('#tr_documentCodeGSM').show();
			// $('#tr_justificationGSM').show();

			$('#sp_suggestionGSM').text("Sugerencia");
			$('#sp_documentCodeGSM').text("Código del documento");
			$('#descrLabel').text("Justificación del requerimiento");

		}
		if (serviceTypeId === 24) {

			$('#tr_problemDescriptionGPTR').show();
			$('#sp_problemDescriptionGPTR').text("Descripción del Problema");

		}
	}


</script>	
<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_15">					
					<div class="box">
						<h2>Requisición ${ticketDetail.ticketNumber}</h2>
						<div class="utils">
					
						</div>
						<table>
							<tr>
								<td style="width:180px;">Folio:</td>
								<td colspan="3" style="width:200px;"><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${ticketDetail.ticketNumber}"/></td>
								<td>Marca temporal:</td>
								<td><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${ticketDetail.createdDisplay}"/></td>
							</tr>
							<tr>
								<td>Usuario</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.applicantUserName}"/></td>
								<td>Solicitante</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.applicantAreaName}"/></td>
							</tr>
							<tr>
								<td>Tipo</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.serviceTypeName}"/></td>
							</tr>
							<tr>	
								<td>Fecha Compromiso</td>
								<td><input id="myDate" type="text" style="width:95%;" readOnly="true" value="${ticketDetail.dueDateDisplay}"/></td>
								<td colspan="2"></td>
								<td>Fecha Deseada</td>
								<td><input id="myDesiredDate" type="text" style="width:95%;" readOnly="true" value="${ticketDetail.desiredDateDisplay}"/></td>
							</tr>
							<tr>
								<td>Proyecto</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.project}"/></td>
								<td>Oficina</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.officeName}"/></td>
								<!-- <td></td> -->
							</tr>
							<tr>
								<td>Persona asignada
								</td>
								<td colspan="7">
								    <select id="selectAsignee"  style="width:78%;" disabled>
										<option value="0"></option>
											<c:forEach var="employee" items="${employees}">
												<option value="${employee.userEmail}"
												<c:if test="${ employee.userEmail == ticketDetail.asignee }">
													selected = "true"
												</c:if>
												>${ employee.userName }</option>
											</c:forEach>
										</select>
								 </td>
							</tr>
							<tr>
								<td>Fecha y hora de respuesta</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.responseDateDisplay}"/></td>
								<td>Desv. fecha compromiso</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.desviation}"/></td>
							</tr>		
							<tr>
								<td>Entrega en tiempo</td>
								<td style="text-align:left;"><input type="checkbox" style="width:95%;" 
									<c:if test="${ticketDetail.resolvedOnTime > 0}">
										checked
									</c:if>
									disabled/></td>
							</tr>		
							<tr>
								<td>Calificacion interna</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.evaluation}"/></td>
							</tr>
							<tr>
								<td>Estatus</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.statusName}"/></td>
							</tr>
							<!-- Inicia seccion de campos dinamicos -->
							<tr>
								<td><span id="descrLabel">Descripción de la solicitud</span></td>
								<td colspan="5">										
									<textarea id="fldSitEnc" style="width:100%;height:100%;" readOnly="true" rows="8">${ticketDetail.description}</textarea>
								</td>
							</tr>
							<!-- Datos complementarios -->
							<input type="hidden" id="slTipoServicio" value="${ticketDetail.serviceTypeId}"/>
							<tr id='tr_purposeVisitVL'>
								<td><span id='sp_purposeVisitVL'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_purposeVisitVL' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.purposeVisitVL}</textarea></td>
							</tr>
							<tr id='tr_purposeVisitVISAS'>
								<td><span id='sp_purposeVisitVISAS'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_purposeVisitVISAS' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.purposeVisitVISAS}</textarea></td>
							</tr>
							<tr id='tr_draftCopyDiagramVED'>
								<td><span id='sp_draftCopyDiagramVED'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_draftCopyDiagramVED' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.draftCopyDiagramVED}</textarea></td>
							</tr>
							<tr id='tr_formProjectVED'>
								<td><span id='sp_formProjectVED'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_formProjectVED' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.formProjectVED}</textarea></td>
							</tr>
							<tr id='tr_observationsVEPI'>
								<td><span id='sp_observationsVEPI'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsVEPI' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsVEPI}</textarea></td>
							</tr>
							<tr id='tr_draftCopyPlanVEPI'>
								<td><span id='sp_draftCopyPlanVEPI'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_draftCopyPlanVEPI' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.draftCopyPlanVEPI}</textarea></td>
							</tr>
							<tr id='tr_formProjectVEPI'>
								<td><span id='sp_formProjectVEPI'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_formProjectVEPI' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.formProjectVEPI}</textarea></td>
							</tr>
							<tr id='tr_observationsVRCC'>
								<td><span id='sp_observationsVRCC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsVRCC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsVRCC}</textarea></td>
							</tr>
							<tr id='tr_checkListVRCC'>
								<td><span id='sp_checkListVRCC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_checkListVRCC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.checkListVRCC}</textarea></td>
							</tr>
							<tr id='tr_formProjectVRCC'>
								<td><span id='sp_formProjectVRCC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_formProjectVRCC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.formProjectVRCC}</textarea></td>
							</tr>
							<tr id='tr_questionVPT'>
								<td><span id='sp_questionVPT'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_questionVPT' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.questionVPT}</textarea></td>
							</tr>
							<tr id='tr_observationsVSA'>
								<td><span id='sp_observationsVSA'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsVSA' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsVSA}</textarea></td>
							</tr>
							<tr id='tr_formProjectVSA'>
								<td><span id='sp_formProjectVSA'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_formProjectVSA' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.formProjectVSA}</textarea></td>
							</tr>
							<tr id='tr_productInformationVSP'>
								<td><span id='sp_productInformationVSP'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_productInformationVSP' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.productInformationVSP}</textarea></td>
							</tr>
							<tr id='tr_observationsISED'>
								<td><span id='sp_observationsISED'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsISED' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsISED}</textarea></td>
							</tr>
							<tr id='tr_draftCopyPlanISED'>
								<td><span id='sp_draftCopyPlanISED'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_draftCopyPlanISED' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.draftCopyPlanISED}</textarea></td>
							</tr>
							<tr id='tr_observationsISRC'>
								<td><span id='sp_observationsISRC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsISRC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsISRC}</textarea></td>
							</tr>
							<tr id='tr_attachmentsISRC'>
								<td><span id='sp_attachmentsISRC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_attachmentsISRC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.attachmentsISRC}</textarea></td>
							</tr>
							<tr id='tr_apparatusTraceISSM'>
								<td><span id='sp_apparatusTraceISSM'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_apparatusTraceISSM' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.apparatusTraceISSM}</textarea></td>
							</tr>
							<tr id='tr_observationsISSM'>
								<td><span id='sp_observationsISSM'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsISSM' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsISSM}</textarea></td>
							</tr>
							<tr id='tr_questionISPT'>
								<td><span id='sp_questionISPT'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_questionISPT' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.questionISPT}</textarea></td>
							</tr>
							<tr id='tr_ticketISRPR'>
								<td><span id='sp_ticketISRPR'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_ticketISRPR' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.ticketISRPR}</textarea></td>
							</tr>
							<tr id='tr_modelPartISRPR'>
								<td><span id='sp_modelPartISRPR'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_modelPartISRPR' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.modelPartISRPR}</textarea></td>
							</tr>
							<tr id='tr_observationsISRPR'>
								<td><span id='sp_observationsISRPR'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_observationsISRPR' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.observationsISRPR}</textarea></td>
							</tr>
							<tr id='tr_productInformationISSPC'>
								<td><span id='sp_productInformationISSPC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_productInformationISSPC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.productInformationISSPC}</textarea></td>
							</tr>
							<tr id='tr_positionPGCAS'>
								<td><span id='sp_positionPGCAS'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_positionPGCAS' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.positionPGCAS}</textarea></td>
							</tr>
							<tr id='tr_collaboratorPGCAS'>
								<td><span id='sp_collaboratorPGCAS'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_collaboratorPGCAS' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.collaboratorPGCAS}</textarea></td>
							</tr>
							<tr id='tr_justificationPGCAS'>
								<td><span id='sp_justificationPGCAS'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_justificationPGCAS' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.justificationPGCAS}</textarea></td>
							</tr>
							<tr id='tr_salaryPGCAS'>
								<td><span id='sp_salaryPGCAS'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_salaryPGCAS' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.salaryPGCAS}</textarea></td>
							</tr>
							<tr id='tr_positionPGCCP'>
								<td><span id='sp_positionPGCCP'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_positionPGCCP' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.positionPGCCP}</textarea></td>
							</tr>
							<tr id='tr_commentsPGCCP'>
								<td><span id='sp_commentsPGCCP'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_commentsPGCCP' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.commentsPGCCP}</textarea></td>
							</tr>
							<tr id='tr_developmentPlanPGCCP'>
								<td><span id='sp_developmentPlanPGCCP'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_developmentPlanPGCCP' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.developmentPlanPGCCP}</textarea></td>
							</tr>
							<tr id='tr_targetPGCCP'>
								<td><span id='sp_targetPGCCP'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_targetPGCCP' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.targetPGCCP}</textarea></td>
							</tr>
							<tr id='tr_salaryPGCCP'>
								<td><span id='sp_salaryPGCCP'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_salaryPGCCP' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.salaryPGCCP}</textarea></td>
							</tr>
							<tr id='tr_positionPGCNC'>
								<td><span id='sp_positionPGCNC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_positionPGCNC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.positionPGCNC}</textarea></td>
							</tr>
							<tr id='tr_developmentPlanPGCNC'>
								<td><span id='sp_developmentPlanPGCNC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_developmentPlanPGCNC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.developmentPlanPGCNC}</textarea></td>
							</tr>
							<tr id='tr_targetPGCNC'>
								<td><span id='sp_targetPGCNC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_targetPGCNC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.targetPGCNC}</textarea></td>
							</tr>
							<tr id='tr_salaryPGCNC'>
								<td><span id='sp_salaryPGCNC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_salaryPGCNC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.salaryPGCNC}</textarea></td>
							</tr>
							<tr id='tr_justificationPGCNC'>
								<td><span id='sp_justificationPGCNC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_justificationPGCNC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.justificationPGCNC}</textarea></td>
							</tr>
							<tr id='tr_positionPGCF'>
								<td><span id='sp_positionPGCF'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_positionPGCF' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.positionPGCF}</textarea></td>
							</tr>
							<tr id='tr_collaboratorPGCF'>
								<td><span id='sp_collaboratorPGCF'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_collaboratorPGCF' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.collaboratorPGCF}</textarea></td>
							</tr>
							<tr id='tr_justificationPGCF'>
								<td><span id='sp_justificationPGCF'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_justificationPGCF' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.justificationPGCF}</textarea></td>
							</tr>
							<tr id='tr_positionPGCAA'>
								<td><span id='sp_positionPGCAA'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_positionPGCAA' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.positionPGCAA}</textarea></td>
							</tr>
							<tr id='tr_collaboratorPGCAA'>
								<td><span id='sp_collaboratorPGCAA'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_collaboratorPGCAA' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.collaboratorPGCAA}</textarea></td>
							</tr>
							<tr id='tr_justificationPGCAA'>
								<td><span id='sp_justificationPGCAA'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_justificationPGCAA' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.justificationPGCAA}</textarea></td>
							</tr>
							<tr id='tr_requisitionFormatGRC'>
								<td><span id='sp_requisitionFormatGRC'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_requisitionFormatGRC' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.requisitionFormatGRC}</textarea></td>
							</tr>
							<tr id='tr_linkDocumentGM'>
								<td><span id='sp_linkDocumentGM'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_linkDocumentGM' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.linkDocumentGM}</textarea></td>
							</tr>
							<tr id='tr_suggestionGSM'>
								<td><span id='sp_suggestionGSM'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_suggestionGSM' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.suggestionGSM}</textarea></td>
							</tr>
							<tr id='tr_documentCodeGSM'>
								<td><span id='sp_documentCodeGSM'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_documentCodeGSM' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.documentCodeGSM}</textarea></td>
							</tr>
							<tr id='tr_justificationGSM'>
								<td><span id='sp_justificationGSM'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_justificationGSM' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.justificationGSM}</textarea></td>
							</tr>
							<tr id='tr_problemDescriptionGPTR'>
								<td><span id='sp_problemDescriptionGPTR'>Datos Adicionales 1</span></td>
								<td colspan="5"><textarea id='txt_problemDescriptionGPTR' style='width: 100%; height: 100%;' rows='3' >${ticketDetail.problemDescriptionGPTR}</textarea></td>
							</tr>
						</table>
					</div>					
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
				
				<div class="grid_15">
					<div class="box">
						<h2>Seguimiento</h2>
							<!-- Seguimiento -->
							<table id="seguimientoTable">
								<thead>
									<th>Seguimiento</th>
								</thead>
									<tr>
										<td id="seguimientoContent">
										</td>
									</tr>
									<tr>
									    <td id="followDetail">
									       <c:import url="_ticketFollow.jsp"></c:import>
									    </td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label>
											</div>
											<div> 
											   <div id="assignamentArea">
											     Asignar a:
												  <select id="who" style="width:200px;">
												    <option value="-1">Seleccione</option>
												    <c:forEach var="current" items="${staff}" >
												       <option value="${current.email}">${current.name}</option>
												    </c:forEach>
												  </select>
												<p></p>
												</div>
												<textarea id="seguimientoText" rows="5" style="width:65%;"></textarea>
												<button class="searchButton" onclick="applySeguimiento();">Agregar</button>
												<button class="searchButton" onclick="cancelAddSeguimiento();">Cancelar</button>
											</div>
										</td>
									</tr>
							</table>

							<!-- Botones para seguimiento -->
							<table>
								<tbody>
									<tr>
										<c:if test="${ticketDetail.userCanAssign == true && ticketDetail.statusId < 6}">
											<td style="width: 100px;">
												<button class="searchButton" onclick="addSeguimiento(1);">Asignar</button>
											</td>
										</c:if>
										<c:if test="${fn:length(followUps) > 0 && ticketDetail.statusId < 6}">
											<td style="width: 100px;">
												<button class="searchButton" onclick="addSeguimiento(3);">Responder</button>
											</td>
										</c:if>
										<td style="width: 100px;">
											<button class="searchButton" onclick="addSeguimiento(2);">Comentar</button>
										</td>
										<td></td>
									</tr>
								<tbody>
							</table>
							
							<!-- Adjuntos -->
                            <table id="fileTraceTable">
								<thead>
									<th colspan="2">Archivos Requeridos</th>
								</thead>
								    <c:forEach var="current" items="${deliverableTrace}" >
									  <tr>
									    <td  style="width:5%;">
		                                  <c:choose>
											<c:when test="${current.delivered}">
												<img src='${pageContext.request.contextPath}/img/delivered.png'/>
											</c:when>
										  </c:choose>
												    
										  
										</td>
										<td align="left">
										  ${current.name}
										</td>
									  </tr>
									  </c:forEach>
							</table>
							
							<c:import url="/attLoader.jsp"></c:import>
							<table>
								<tbody>
									<tr>
										<c:if test="${ticketDetail.statusId < 4 && ticketDetail.userCanAssign}">
											<td>
												<button class="searchButton" onclick="$('#resolveConfirm').dialog('open');">Resolver Requisicion</button>
											</td>
										</c:if>
										<c:if test="${ticketDetail.statusId == 5 && ticketDetail.userCanClose == true}">
											<td>
												<button class="searchButton" onclick="$('#closeConfirm').dialog('open');">Cerrar Requisicion</button>
											</td>
										</c:if>
									</tr>
								<tbody>
							</table>
					</div>					
				</div>				
<!--   ~ CONTENT COLUMN   -->
				
				
				<!-- Attachment Img section -->
				<div id="attachmentDlg" title="Referencia">
					<p></p>
					<p>Nombre del archivo:</p>
					<input id="attachmentFileName" style="width:80px;" readOnly="true"/> 
					<input type="hidden" id="attachmentFileId"/> 
					<br>
					<p>Referencia:</p>
					<select id="attachmentType" style="width:200px;">
					   <option value="-1">Sin referencia</option>
					     <c:forEach var="current" items="${deliverableTypes}" >
					        <option value="${current.id}">${current.name}</option>
					     </c:forEach>
					</select>

				</div>
				
				<div id="resolveConfirm" title="Marcar Requisicion ${ticketDetail.ticketNumber} como resuelta?">
					<p>¿Confirma que desea cerrar las acciones pendientes en el ticket ${ticketDetail.ticketNumber}?</p>
					<p>La requisicion será asignada al personal que lo solicito para su revision</p>
				</div>

				<div id="closeConfirm" title="Cerrar Requisicion ${ticketDetail.ticketNumber}?">
					<p>¿Confirma que dar por cerrada la requisicion ${ticketDetail.ticketNumber}?</p>
				</div>
				
<!--   ~ CONTENT   -->
			</div>
			
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
</body>
</html>