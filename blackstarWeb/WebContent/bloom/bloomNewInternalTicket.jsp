<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Ticket Interno</title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/bloom/newInternalTicket.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common/popup.js"></script>
	<script type="text/javascript" charset="utf-8">

	function split( val ) {
      return val.split( /,\s*/ );
    }

    function extractLast( term ) {
      return split( term ).pop();
    }

	$(document).ready(function () {
			
	
	});

	function isNumberKey(evt){
	      var charCode = (evt.which) ? evt.which : event.keyCode;
	    	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
	    	            return false;

	    	         return true;
	}

	</script> 
	
		 
	</head>
	<body>
		<div id="contentInternalTicket" class="container_16 clearfix">
					
			<div class="grid_16">					
					<div class="box">
						<h2>TICKET INTERNO</h2>
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
								<td><input type="text" id="fldEmail" style="width:95%;" readOnly="true" value="${emailTicket}"/></td>
							</tr>
							<tr>
								<td>Solicitante</td>
								<td>
									<select name="slAreaSolicitante" id="slAreaSolicitante" style="width:200px;">
									</select>
								</td>
							</tr>
							
							<tr>
								<td>Tipo</td>
								<td>
									<select name="slTipoServicio" id="slTipoServicio" style="width:200px;" onchange="updateAttItems();">
									</select>
								</td>
							</tr>
							<tr>
								<td>Fecha Limite</td>
								<td><input id="fldLimite" type="text" style="width:95%;" readOnly="true"/></td>
							</tr>
							<tr>
								<td><span id="descrLabel" >Descripci&oacute;n de la solicitud</span></td>
								<td>										
									<textarea id="fldDescripcion" style="width:100%;height:100%;" rows="10"></textarea>
								</td>
							</tr>
							<tr>
								<td>Proyecto</td>
								<td>
									<select name="slProyecto" id="slProyecto" style="width:200px;">
									</select>
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
			
			
				<div class="grid_15">
					<div class="box">
						<h2>Archivos adjuntos</h2>
							<div id="legend">Por favor proporcione los siguientes archivos:</div>
							<ol id="attItems">
							
							</ol>
							<table id="attachments">
								<thead>
									<tr>
										<th colspan="3">Archivos Adjuntos</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td id="img1PH" style="width:150px;"></td>
										<td id="img2PH" style="width:150px;"></td>
										<td id="img3PH" style="width:150px;"></td>
									</tr>
									<tr>
										<td id="img1Desc"></td>
										<td id="img2Desc"></td>
										<td id="img3Desc"></td>
									</tr>
									<tr>
										<td><button id="attachButtonTicket" class="searchButton">Adjuntar Archivo</button></td>
									</tr>
								</tbody>
							</table>
							<table>
								<tbody>
									<tr>
										<td>
											<button id="saveButtonTicket" class="searchButton">Enviar</button>
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
</html>