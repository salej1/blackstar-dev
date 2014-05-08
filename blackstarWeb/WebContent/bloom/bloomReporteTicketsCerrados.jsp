<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:import url="../header.jsp"></c:import>
<html>
<head>
<title>% Tickets Cerrados - Tickets Interno</title>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/960.css" type="text/css"
	media="screen" charset="utf-8" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/template.css"
	type="text/css" media="screen" charset="utf-8" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/colour.css"
	type="text/css" media="screen" charset="utf-8" />
<link
	href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css"
	type="text/css" rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/bloom/reporteTicketsCerrados.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/common/popup.js"></script>
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

	</script>


</head>
<body>
	<div id="contentReportInternalTicket" class="container_16 clearfix">


		<div class="grid_16">

			<div class="box">
				<h2>Reporte - % Tickets Cerrados</h2>
				<div class="utils">

		<table>
			<tr>
				<td>Fecha de Registro</td>
				<td><input id="fldFechaIni" type="text" style="width:50%;" readOnly="true"/></td>
				<td> a</td>
				<td><input id="fldFechaFin" type="text" style="width:50%;" readOnly="true"/></td>
			</tr>
			<tr colspan="4">
				<td>
					<button id="buscarButtonTicket" class="searchButton">Buscar</button>
				</td>
			</tr>
			
			
		</table>

				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display"
					id="dtGridTicketsInternos">
					<thead>
						<tr>
							<th style="">Folio</th>
							<th>Estatus</th>
							<th>Creado</th>
							<th>Solicitante</th>
							<th>Tipo</th>
							<th>Fecha Limite</th>
							<th>Proyecto</th>
							<th>Oficina</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>





	</div>
</body>
</html>