<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:import url="../header.jsp"></c:import>
<html>
<head>
<title>Tickets por Evaluacion - Tickets Interno</title>

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
	src="${pageContext.request.contextPath}/js/bloom/reportPercentageEvaluationTickets.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/common/popup.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>	
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
				<h2>Reporte - Tickets por Evaluaci&oacute;n</h2>
				<div class="utils">
					<table>

						<tr>
							<td style="width: 100px;">Fecha de Registro</td>
							<td style="width: 120px;"><input id="startCreationDate"
								type="text" readOnly="true" style="width: 140px;" /></td>
							<td style="width: 60px;">a</td>
							<td style="width: 120px;"><input id="endCreationDate"
								type="text" readOnly="true" style="width: 140px;" /></td>
						</tr>

						<tr colspan="4">
							<td>
								<button id="searchButtonTicket" class="searchButton">Buscar</button>
							</td>
						</tr>

					</table>

				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtGridReport">
					<thead>
						<tr>
							<th>Tickets por evaluacion</th>
							<th>Porcentaje</th>
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