<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="requisiciones" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Requsición</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
			 
	</head>
	<body>
		<div id="contentInternalTicket" class="container_16 clearfix">
					
			<div class="grid_16">					
					<div class="box">
						<h2>Nueva Requisición</h2>
						<table>

							<tr>
								<td style="width:200px;">Folio:</td>
								<td><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${folioTicket}"/></td>
								<td></td>
							</tr>
							<tr>
								<td>Marca temporal:</td>
								<td><input type="text" id="fldFechaRegsitro" style="width:95%;" readOnly="true" value="${horaTicket}"/></td>
							</tr>
							<tr>
								<td>Usuario</td>
								<td><input type="text" id="fldEmail" style="width:95%;" readOnly="true" value="${user.userName}"/></td>
							</tr>
							<tr>
								<td>Solicitante</td>
								<td>
									<select name="slAreaSolicitante" id="slAreaSolicitante" style="width:400px;">
									</select>
								</td>
							</tr>
							
							<tr>
								<td>Tipo</td>
								<td>
									<select name="slTipoServicio" id="slTipoServicio" style="width:400px;" onchange="updateAttItems();">
									</select>
								</td>
							</tr>
							<tr>
								<td>Fecha Compromiso</td>
								<td><input id="fldLimite" type="text" style="width:200px;" readonly="true"/></td>
							</tr>
							<tr>
								<td>Fecha Deseada</td>
								<td><input id="fldDesiredDate" type="text" style="width:200px;;" readonly="true"/></td>
							</tr>
							<tr>
								<td>Proyecto</td>
								<td>
									<input type="text" name="slProyecto" id="slProyecto" style="width:200px;"/>
								</td>
							</tr>
							<tr>
								<td>Oficina</td>
								<td>
								
								<select name="slOficina" id="slOficina" style="width:200px;">
									</select>
								
								</td>
								<!-- <td></td> -->
							</tr>
							<tr>
								<td><span id="descrLabel" >Descripci&oacute;n de la solicitud</span></td>
								<td>										
									<textarea id="fldDescripcion" style="width:100%;height:100%;" rows="10"></textarea>
								</td>
							</tr>
										
							<tr id='tr_purposeVisitVL'>
								<td><span id='sp_purposeVisitVL'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_purposeVisitVL' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_purposeVisitVISAS'>
								<td><span id='sp_purposeVisitVISAS'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_purposeVisitVISAS' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_draftCopyDiagramVED'>
								<td><span id='sp_draftCopyDiagramVED'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_draftCopyDiagramVED' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_formProjectVED'>
								<td><span id='sp_formProjectVED'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_formProjectVED' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsVEPI'>
								<td><span id='sp_observationsVEPI'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsVEPI' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_draftCopyPlanVEPI'>
								<td><span id='sp_draftCopyPlanVEPI'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_draftCopyPlanVEPI' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_formProjectVEPI'>
								<td><span id='sp_formProjectVEPI'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_formProjectVEPI' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsVRCC'>
								<td><span id='sp_observationsVRCC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsVRCC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_checkListVRCC'>
								<td><span id='sp_checkListVRCC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_checkListVRCC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_formProjectVRCC'>
								<td><span id='sp_formProjectVRCC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_formProjectVRCC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_questionVPT'>
								<td><span id='sp_questionVPT'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_questionVPT' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsVSA'>
								<td><span id='sp_observationsVSA'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsVSA' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_formProjectVSA'>
								<td><span id='sp_formProjectVSA'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_formProjectVSA' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_productInformationVSP'>
								<td><span id='sp_productInformationVSP'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_productInformationVSP' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsISED'>
								<td><span id='sp_observationsISED'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsISED' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_draftCopyPlanISED'>
								<td><span id='sp_draftCopyPlanISED'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_draftCopyPlanISED' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsISRC'>
								<td><span id='sp_observationsISRC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsISRC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_attachmentsISRC'>
								<td><span id='sp_attachmentsISRC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_attachmentsISRC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_apparatusTraceISSM'>
								<td><span id='sp_apparatusTraceISSM'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_apparatusTraceISSM' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsISSM'>
								<td><span id='sp_observationsISSM'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsISSM' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_questionISPT'>
								<td><span id='sp_questionISPT'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_questionISPT' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_ticketISRPR'>
								<td><span id='sp_ticketISRPR'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_ticketISRPR' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_modelPartISRPR'>
								<td><span id='sp_modelPartISRPR'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_modelPartISRPR' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_observationsISRPR'>
								<td><span id='sp_observationsISRPR'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_observationsISRPR' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_productInformationISSPC'>
								<td><span id='sp_productInformationISSPC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_productInformationISSPC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_positionPGCAS'>
								<td><span id='sp_positionPGCAS'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_positionPGCAS' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_collaboratorPGCAS'>
								<td><span id='sp_collaboratorPGCAS'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_collaboratorPGCAS' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_justificationPGCAS'>
								<td><span id='sp_justificationPGCAS'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_justificationPGCAS' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_salaryPGCAS'>
								<td><span id='sp_salaryPGCAS'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_salaryPGCAS' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_positionPGCCP'>
								<td><span id='sp_positionPGCCP'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_positionPGCCP' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_commentsPGCCP'>
								<td><span id='sp_commentsPGCCP'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_commentsPGCCP' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_developmentPlanPGCCP'>
								<td><span id='sp_developmentPlanPGCCP'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_developmentPlanPGCCP' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_targetPGCCP'>
								<td><span id='sp_targetPGCCP'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_targetPGCCP' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_salaryPGCCP'>
								<td><span id='sp_salaryPGCCP'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_salaryPGCCP' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_positionPGCNC'>
								<td><span id='sp_positionPGCNC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_positionPGCNC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_developmentPlanPGCNC'>
								<td><span id='sp_developmentPlanPGCNC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_developmentPlanPGCNC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_targetPGCNC'>
								<td><span id='sp_targetPGCNC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_targetPGCNC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_salaryPGCNC'>
								<td><span id='sp_salaryPGCNC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_salaryPGCNC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_justificationPGCNC'>
								<td><span id='sp_justificationPGCNC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_justificationPGCNC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_positionPGCF'>
								<td><span id='sp_positionPGCF'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_positionPGCF' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_collaboratorPGCF'>
								<td><span id='sp_collaboratorPGCF'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_collaboratorPGCF' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_justificationPGCF'>
								<td><span id='sp_justificationPGCF'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_justificationPGCF' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_positionPGCAA'>
								<td><span id='sp_positionPGCAA'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_positionPGCAA' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_collaboratorPGCAA'>
								<td><span id='sp_collaboratorPGCAA'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_collaboratorPGCAA' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_justificationPGCAA'>
								<td><span id='sp_justificationPGCAA'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_justificationPGCAA' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_requisitionFormatGRC'>
								<td><span id='sp_requisitionFormatGRC'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_requisitionFormatGRC' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_linkDocumentGM'>
								<td><span id='sp_linkDocumentGM'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_linkDocumentGM' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_suggestionGSM'>
								<td><span id='sp_suggestionGSM'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_suggestionGSM' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_documentCodeGSM'>
								<td><span id='sp_documentCodeGSM'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_documentCodeGSM' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_justificationGSM'>
								<td><span id='sp_justificationGSM'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_justificationGSM' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>
							<tr id='tr_problemDescriptionGPTR'>
								<td><span id='sp_problemDescriptionGPTR'>Datos Adicionales 1</span></td>
								<td><textarea id='txt_problemDescriptionGPTR' style='width: 100%; height: 100%;' rows='2'></textarea></td>
							</tr>

						</table>
					</div>
				</div>
			
			
				<div class="grid_16">
					<div class="box">
							<table>
								<tbody>
									<tr>
										<td>
											<button id="saveButtonTicket" class="searchButton">Guardar Requisición</button>
											<button class="searchButton" onclick="window.location = '/bloom/bloomTicketPage/show.do'">Cancelar</button>
										</td>
									</tr>
								<tbody>
							</table>
					</div>					
				</div>		
				
				
				
			<!-- Attachment Img section -->
				<div id="attachmentImgDlg" title="Adjuntar archivo">
					<p></p>
					<p>Seleccione el archivo que desea adjuntar</p>
					<input type="file" name="somename" size="80"/> 
					<p>Seleccione la entrada que corresponde al archivo</p>
					<select name="slDocumento" id="slDocumento"></select>

				</div>
		
		</div>
	</body>
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common/popup.js"></script>
	<script type="text/javascript" charset="utf-8">

	function split( val ) {
      return val.split( /,\s*/ );
    }

    function extractLast( term ) {
      return split( term ).pop();
    }

	function isNumberKey(evt){
	      var charCode = (evt.which) ? evt.which : event.keyCode;
	    	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
	    	            return false;

	    	         return true;
	}

	// Importado de newInternalTicket.js
	var listaProyectos;
	var listaAreas;
	var listaServicios;
	var listaOficinas;
	var serviceTypeId;
	var applicantAreaId;
	var diasLimitesTipoServicio=null;
	var fechaLimite;

	$(document)
			.ready(
					function() {

						var attCounter = 0;

						fechaLimite = new Date();

						//$("#fldFechaRegsitro").val("${horaTicket}");

						$("#fldDesiredDate").datepicker({ dateFormat: 'dd/mm/yy' });
						$("#fldDesiredDate").datepicker("setDate", new Date());

						// Attachment dialog
						$("#attachmentDlg").dialog({
							autoOpen : false,
							height : 270,
							width : 420,
							modal : true,
							buttons : {
								"Aceptar" : function() {
									$(this).dialog("close");
									var af = $("#folioAttached").val();
									$("#fldFolio").val(af);
								},

								"Cancelar" : function() {
									$(this).dialog("close");
								}
							}
						});


						// History dialog
						$("#historyDlg").dialog({
							autoOpen : false,
							height : 380,
							width : 500,
							modal : true,
							buttons : {
								"Cerrar" : function() {
									$(this).dialog("close");
								}
							}
						});

						// Attachment Img dialog
						$("#attachmentImgDlg")
								.dialog(
										{
											autoOpen : false,
											height : 340,
											width : 700,
											modal : true,
											buttons : {
												"Aceptar" : function() {
													$(this).dialog("close");
													attCounter++;
													$('#img' + attCounter + 'PH').html("<img src='img/bigPdf.png'/>");
													$('#img' + attCounter + 'Desc').html($("#attachment option:selected").val());
												},

												"Cancelar" : function() {
													$(this).dialog("close");
												}
											}
										});

						// Seguimiento$("#seguimientoCapture").hide();
						$("#seguimientoCapture").hide();

						
						$('#slAreaSolicitante').on('change',function(){
							
							consultServiceType();
							
						});
						
						
						$('#slTipoServicio').on('change',
										function() {
											
												updateDueDate();

										});

						

						$( "#saveButtonTicket" ).click(function() {
							  
							  mensaje_confirmacion("\u00BF Confirma que desea enviar la requisición general "+$("#fldFolio").val()+"?",
									  "Alta Ticket Interno","Aceptar","Cancelar",
									  saveInternalTicket,
									  function(){window.location = '/bloom/bloomTicketPage/show.do';});
							  
						});
						

						$( "#attachButtonTicket" ).click(function() {
							consultDeliverableType(function(){
								$('#attachmentImgDlg').dialog('open');
							});
						});

						readDataForm();
						
					});




	function updateDueDate(){
		
		serviceTypeId = parseInt($(
				'#slTipoServicio').val());

		diasLimitesTipoServicio = 0;
		for (var i = 0; i < listaServicios.length; i++) {
			if (listaServicios[i].id === serviceTypeId) {
				diasLimitesTipoServicio = parseInt(listaServicios[i].extra);
				break;
			}
		}

		fechaLimite = new Date();

		fechaLimite.setDate(fechaLimite
				.getDate()
				+ diasLimitesTipoServicio);

		$("#fldLimite").val(fechaLimite.format("dd/MM/yyyy"));
		
		configureAdditionalFields();
		
		consultDeliverableType();	
		
		
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

			$('#tr_questionVPT').show();

			$('#sp_questionVPT').text("Pregunta");

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

			$('#tr_observationsISED').show();
			$('#tr_draftCopyPlanISED').show();

			$('#sp_observationsISED').text("Observaciones");
			$('#sp_draftCopyPlanISED').text("Diagrama o Plano en borrador");

		}
		if (serviceTypeId === 10) {

			$('#tr_observationsISRC').show();
			$('#tr_attachmentsISRC').show();

			$('#sp_observationsISRC').text("Observaciones y/o ligas de fotos");
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

			$('#tr_questionISPT').show();

			$('#sp_questionISPT').text("Pregunta");

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
			//$('#tr_justificationPGCAA').show();

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
			//$('#tr_justificationGSM').show();

			$('#sp_suggestionGSM').text("Sugerencia");
			$('#sp_documentCodeGSM').text("Código del documento");
			$('#descrLabel').text("Justificación del requerimiento");

		}
		if (serviceTypeId === 24) {

			$('#tr_problemDescriptionGPTR').show();
			$('#sp_problemDescriptionGPTR').text("Descripción del Problema");

		}

	}





	function saveInternalTicket() {
		// ocultarMensajes();

		if(diasLimitesTipoServicio===null){
			diasLimitesTipoServicio=-1;
		}
		
		$.ajax({
			url : "/bloom/saveTicket.do",
			type : "POST",
			data : {
				fldFolio:$('#fldFolio').val(),
				fldFechaRegsitro:$('#fldFechaRegsitro').val(),
				fldEmail:$('#fldEmail').val(),
				slAreaSolicitante:$('#slAreaSolicitante').val(),
				slTipoServicio:$('#slTipoServicio').val(),
				fldLimite:$('#fldLimite').val() + " 00:00:00",
				fldDesiredDate:$('#fldDesiredDate').val() + " 00:00:00",
				slProyecto:$('#slProyecto').val(),
				slOficina:$('#slOficina').val(),
				slDocumento:$('#slDocumento').val(),
				fldDescripcion:$('#fldDescripcion').val(),
				fldDiasRespuesta:diasLimitesTipoServicio,
				slAreaSolicitanteLabel: $('#slAreaSolicitante option:selected').text(),
				slTipoServicioLabel:$('#slTipoServicio option:selected').text(),
				slOficinaLabel:$('#slOficina option:selected').text(),
				purposeVisitVL:$('#txt_purposeVisitVL').val(),
				purposeVisitVISAS:$('#txt_purposeVisitVISAS').val(),
				draftCopyDiagramVED:$('#txt_draftCopyDiagramVED').val(),
				formProjectVED:$('#txt_formProjectVED').val(),
				observationsVEPI:$('#txt_observationsVEPI').val(),
				draftCopyPlanVEPI:$('#txt_draftCopyPlanVEPI').val(),
				formProjectVEPI:$('#txt_formProjectVEPI').val(),
				observationsVRCC:$('#txt_observationsVRCC').val(),
				checkListVRCC:$('#txt_checkListVRCC').val(),
				formProjectVRCC:$('#txt_formProjectVRCC').val(),
				questionVPT:$('#txt_questionVPT').val(),
				observationsVSA:$('#txt_observationsVSA').val(),
				formProjectVSA:$('#txt_formProjectVSA').val(),
				productInformationVSP:$('#txt_productInformationVSP').val(),
				observationsISED:$('#txt_observationsISED').val(),
				draftCopyPlanISED:$('#txt_draftCopyPlanISED').val(),
				observationsISRC:$('#txt_observationsISRC').val(),
				attachmentsISRC:$('#txt_attachmentsISRC').val(),
				apparatusTraceISSM:$('#txt_apparatusTraceISSM').val(),
				observationsISSM:$('#txt_observationsISSM').val(),
				questionISPT:$('#txt_questionISPT').val(),
				ticketISRPR:$('#txt_ticketISRPR').val(),
				modelPartISRPR:$('#txt_modelPartISRPR').val(),
				observationsISRPR:$('#txt_observationsISRPR').val(),
				productInformationISSPC:$('#txt_productInformationISSPC').val(),
				positionPGCAS:$('#txt_positionPGCAS').val(),
				collaboratorPGCAS:$('#txt_collaboratorPGCAS').val(),
				justificationPGCAS:$('#txt_justificationPGCAS').val(),
				salaryPGCAS:$('#txt_salaryPGCAS').val(),
				positionPGCCP:$('#txt_positionPGCCP').val(),
				commentsPGCCP:$('#txt_commentsPGCCP').val(),
				developmentPlanPGCCP:$('#txt_developmentPlanPGCCP').val(),
				targetPGCCP:$('#txt_targetPGCCP').val(),
				salaryPGCCP:$('#txt_salaryPGCCP').val(),
				positionPGCNC:$('#txt_positionPGCNC').val(),
				developmentPlanPGCNC:$('#txt_developmentPlanPGCNC').val(),
				targetPGCNC:$('#txt_targetPGCNC').val(),
				salaryPGCNC:$('#txt_salaryPGCNC').val(),
				justificationPGCNC:$('#txt_justificationPGCNC').val(),
				positionPGCF:$('#txt_positionPGCF').val(),
				collaboratorPGCF:$('#txt_collaboratorPGCF').val(),
				justificationPGCF:$('#txt_justificationPGCF').val(),
				positionPGCAA:$('#txt_positionPGCAA').val(),
				collaboratorPGCAA:$('#txt_collaboratorPGCAA').val(),
				justificationPGCAA:$('#txt_justificationPGCAA').val(),
				requisitionFormatGRC:$('#txt_requisitionFormatGRC').val(),
				linkDocumentGM:$('#txt_linkDocumentGM').val(),
				suggestionGSM:$('#txt_suggestionGSM').val(),
				documentCodeGSM:$('#txt_documentCodeGSM').val(),
				justificationGSM:$('#txt_justificationGSM').val(),
				problemDescriptionGPTR:$('#txt_problemDescriptionGPTR').val()		

			},
			dataType : "json",
			beforeSend : function() {
				// mostrarMensajeCargando("Por favor espere, guardando solicitud,
				// puede tardar varios minutos");
			},
			success : function(respuestaJson) {
				// ocultarMensajes();
				if (respuestaJson.estatus === "ok") {
					
					mensaje_alerta(respuestaJson.mensaje,"Alta Ticket Interno", function(){
						window.location = '/bloom/bloomTicketPage/show.do';
					});
					
					// limpiarCampos();

				} else {
					if (respuestaJson.estatus === "preventivo") {
						mensaje_alerta(respuestaJson.mensaje,"Alta Ticket Interno");
					} else {
						mensaje_alerta(respuestaJson.mensaje,"Alta Ticket Interno");
					}
				}
			},
			error : function() {
				mensaje_alerta("Ocurri&oacute; un error al guardar solicitud","Alta Ticket Interno");
			}
		});

	}

	function loadFormsCombos() {

		for (var i = 0; i < listaAreas.length; i++) {
			$("#slAreaSolicitante").append(
					new Option(listaAreas[i].descripcion, listaAreas[i].id));
		}

		// SELECCION DE PROYECTO DESDE LISTA DESHABILITADA HASTA IMPLEMENTACION DE PROYECTO CODEX
		// // Proyecto vacio
		// $("#slProyecto").append(new Option('N/A', 'N/A'));
		// for (var i = 0; i < listaProyectos.length; i++) {
		// 	$("#slProyecto")
		// 			.append(
		// 					new Option(listaProyectos[i].descripcion,
		// 							listaProyectos[i].id));
		// }

		for (var i = 0; i < listaOficinas.length; i++) {
			$("#slOficina").append(
					new Option(listaOficinas[i].descripcion, listaOficinas[i].id));
		}

	}

	function readDataForm() {

		$.ajax({
			url : "/bloomCatalog/getData.do",
			type : "GET",
			dataType : "json",
			async : false,
			beforeSend : function() {

			},
			success : function(respuestaJson) {

				if (respuestaJson.estatus === "ok") {

					listaProyectos = respuestaJson.listaMap.listaProyectos;
					listaAreas = respuestaJson.listaMap2.listaAreas;
					//listaServicios = respuestaJson.listaMap2.listaServicios;
					listaOficinas = respuestaJson.listaMap2.listaOficinas;

					loadFormsCombos();
					
					consultServiceType(function(){
						consultDeliverableType();
					});
					

				} else {
					if (respuestaJson.estatus === "preventivo") {
					} else {
					}
				}

			},
			error : function() {
			}
		});
	}



	function tableListDeliverableType(listaDocumentos){
		
		$("#attItems").find(".itemFile").remove();
		
		for (var i = 0; i < listaDocumentos.length; i++) {
			$('#attItems').append("<li class='itemFile'>"+listaDocumentos[i].descripcion+"</li>");
		}
		
	}

	function consultDeliverableType(callBackFunction) {
		
		serviceTypeId = parseInt($('#slTipoServicio').val());

		$.ajax({
			url : "/bloomCatalog/getDocumentos.do",
			type : "POST",
			data : {
				idTipoServicio : serviceTypeId
			},
			dataType : "json",
			beforeSend : function() {
				// mostrarMensajeCargando
			},
			success : function(respuestaJson) {

				if (respuestaJson.estatus === "ok") {

					listaDocumentos = respuestaJson.lista;

					$('#slDocumento').children().remove();

					for (var i = 0; i < listaDocumentos.length; i++) {
						$("#slDocumento").append(
								new Option(listaDocumentos[i].descripcion,
										listaDocumentos[i].id));
					}
					
					if ((typeof (callBackFunction) === "function") && callBackFunction !== null) {
						callBackFunction();
			        }else{
			        	tableListDeliverableType(listaDocumentos);
			        }

				} else {
					if (respuestaJson.estatus === "preventivo") {
						// mostrarMensajePreventivo
					} else {
						// mostrarMensajeError
					}
				}

			},
			error : function() {
				// mostrarMensajeError
			}
		});
	}


	function consultServiceType(callBackFunction) {
		
		applicantAreaId = parseInt($('#slAreaSolicitante').val());

		$.ajax({
			url : "/bloomCatalog/getServiceTypeList.do",
			type : "POST",
			data : {
				applicantAreaId : applicantAreaId
			},
			dataType : "json",
			beforeSend : function() {
				// mostrarMensajeCargando
			},
			success : function(respuestaJson) {

				if (respuestaJson.estatus === "ok") {

					listaServicios = respuestaJson.lista;

					$('#slTipoServicio').children().remove();

					for (var i = 0; i < listaServicios.length; i++) {
						$("#slTipoServicio").append(
								new Option(listaServicios[i].descripcion,
										listaServicios[i].id));
					}
					
					configureAdditionalFields();
					updateDueDate();
					
					if ((typeof (callBackFunction) === "function") && callBackFunction !== null) {
						callBackFunction();
			        }
					
					/*else{
			        	tableListDeliverableType(listaDocumentos);
			        }*/

				} else {
					if (respuestaJson.estatus === "preventivo") {
						// mostrarMensajePreventivo
					} else {
						// mostrarMensajeError
					}
				}

			},
			error : function() {
				// mostrarMensajeError
			}
		});
	}




	function updateAttItems() {
		var tickType = $("#reqType option:selected").val();

		$("#legend").show();
		if (tickType == "Planos 3D") {
			$("#attItems")
					.html(
							"<li>Floor MAP del SITE</li><li>Hoja de Vista</li><li>Cedula de Proyectos</li>");
		} else if (tickType == "Cedula de Costos") {
			$("#attItems")
					.html(
							"<li>CHECKLIST de Levantamiento</li><li>Pre-Cedula de Proyectos</li>");
		} else if (tickType == "Cedula de Proyectos") {
			$("#attItems")
					.html(
							"<li>CHECKLIST de Levantamiento</li><li>Pre-Cedula de Proyectos</li>");
		} else if (tickType == "Aprobación de Proy. > 50K USD") {
			$("#attItems")
					.html(
							"<li>Cedula de Proyectos</li><li>Cedula de Costos</li><li>Levantamiento</li>");
		} else {
			$("#attItems").html("");
			$("#legend").hide();
		}
	}

	function addSeguimiento() {
		var d = new Date();
		$("#seguimientoCapture").show();
		$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Raul:');
		$("#seguimientoText").val('');
	}

	function applySeguimiento() {
		var template = '<div class="comment"><p><strong>TIMESTAMP: Raul: WHO</strong></p><p><small>MYCOMMENT</small></p></div>';
		var d = new Date();
		var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
		content = content.replace('MYCOMMENT', $("#seguimientoText").val());
		content = content.replace('WHO', $("#who option:selected").val());
		var currSegContent = $("#seguimientoContent").html();
		currSegContent = currSegContent + content;
		$("#seguimientoContent").html(currSegContent);
		$("#seguimientoCapture").hide();
	}

	function cancelAddSeguimiento() {
		$("#seguimientoCapture").hide();
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

		

		
		$('#txt_purposeVisitVL').val("");
		$('#txt_purposeVisitVISAS').val("");
		$('#txt_draftCopyDiagramVED').val("");
		$('#txt_formProjectVED').val("");
		$('#txt_observationsVEPI').val("");
		$('#txt_draftCopyPlanVEPI').val("");
		$('#txt_formProjectVEPI').val("");
		$('#txt_observationsVRCC').val("");
		$('#txt_checkListVRCC').val("");
		$('#txt_formProjectVRCC').val("");
		$('#txt_questionVPT').val("");
		$('#txt_observationsVSA').val("");
		$('#txt_formProjectVSA').val("");
		$('#txt_productInformationVSP').val("");
		$('#txt_observationsISED').val("");
		$('#txt_draftCopyPlanISED').val("");
		$('#txt_observationsISRC').val("");
		$('#txt_attachmentsISRC').val("");
		$('#txt_apparatusTraceISSM').val("");
		$('#txt_observationsISSM').val("");
		$('#txt_questionISPT').val("");
		$('#txt_ticketISRPR').val("");
		$('#txt_modelPartISRPR').val("");
		$('#txt_observationsISRPR').val("");
		$('#txt_productInformationISSPC').val("");
		$('#txt_positionPGCAS').val("");
		$('#txt_collaboratorPGCAS').val("");
		$('#txt_justificationPGCAS').val("");
		$('#txt_salaryPGCAS').val("");
		$('#txt_positionPGCCP').val("");
		$('#txt_commentsPGCCP').val("");
		$('#txt_developmentPlanPGCCP').val("");
		$('#txt_targetPGCCP').val("");
		$('#txt_salaryPGCCP').val("");
		$('#txt_positionPGCNC').val("");
		$('#txt_developmentPlanPGCNC').val("");
		$('#txt_targetPGCNC').val("");
		$('#txt_salaryPGCNC').val("");
		$('#txt_justificationPGCNC').val("");
		$('#txt_positionPGCF').val("");
		$('#txt_collaboratorPGCF').val("");
		$('#txt_justificationPGCF').val("");
		$('#txt_positionPGCAA').val("");
		$('#txt_collaboratorPGCAA').val("");
		$('#txt_justificationPGCAA').val("");
		$('#txt_requisitionFormatGRC').val("");
		$('#txt_linkDocumentGM').val("");
		$('#txt_suggestionGSM').val("");
		$('#txt_documentCodeGSM').val("");
		$('#txt_justificationGSM').val("");
		$('#txt_problemDescriptionGPTR').val("");
	}
	</script> 
	
</html>