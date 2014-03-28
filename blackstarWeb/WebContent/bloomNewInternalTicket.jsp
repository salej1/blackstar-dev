<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
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
		<div id="content" class="container_16 clearfix">
		<form:form  commandName="serviceOrder" action="save.do" method="POST">			
			<div class="grid_16">					
					<div class="box">
						<h2>TICKET INTERNO</h2>
							<table>

							<tr>
								<td style="width:200px;">Folio:</td>
								<td><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="SAC45"/></td>
								<td></td>
							</tr>
							<tr>
								<td>Marca temporal:</td>
								<td><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="29/10/2013 6:14:12 PM"/></td>
							</tr>
							<tr>
								<td>Usuario</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="luis.andrade@gposac.com.mx"/></td>
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
								<td><input id="myDate" type="text" style="width:95%;" readOnly="true" value="3/04/2013"/></td>
							</tr>
							<tr>
								<td>Descripcion de la solicitud</td>
								<td>										
									<textarea id="fldSitEnc" style="width:100%;height:100%;" rows="15"></textarea>
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
										<td><button class="searchButton" onclick="$('#attachmentImgDlg').dialog('open');">Adjuntar Archivo</button></td>
									</tr>
								</tbody>
							</table>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="$('#saveConfirm').dialog('open');">Enviar</button>
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
					<select name="attachment" id="attachment">
						<option value="Cedula de costos">Cedula de costos</option>
						<option value="Cedula de proyectos">Cedula de proyectos</option>
						<option value="CheckList de levantamiento">CheckList de levantamiento</option>
						<option value="Encuesta de satisfaccion">Encuesta de satisfaccion</option>
						<option value="Floor Map">Floor Map</option>
						<option value="Hoja de visita">Hoja de visita</option>
						<option value="Imagenes 3D del site">Imagenes 3D del site</option>
						<option value="Validacion de proyecto">Validacion de proyecto</option>
						<option value="Propuesta de unifilar">Propuesta de unifilar</option>
					</select>

				</div>
				
				<div id="saveConfirm" title="Cerrar Ticket SAC45">
					<p>¿Confirma que desea enviar la requisicion general SAC45?</p>
				</div>
						
			
			
		</form:form>
		</div>
	</body>
</html>