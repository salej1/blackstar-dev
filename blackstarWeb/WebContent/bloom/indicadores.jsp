<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="indicadores" />
<c:import url="/header.jsp"></c:import>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
		<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
		<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

		<title>Indicadores de Servicio</title>

		<script type="text/javascript" charset="utf-8">
		     function go(indAction){
		    	 $("a[href*=#]").css({ "color": "#888", "text-decoration":"underline"});
		    	 $("#indicatorDetail").load( "${pageContext.request.contextPath}/bloom/indServicios/" + indAction + ".do", function() {
		    		  $("#" + indAction).css({ "color": "#800080", "text-decoration":"none"});
		    	  });
		     }
		</script>
	</head>
	<body>

<!--   CONTENT COLUMN   -->		
		<div id="content" class="container_16 clearfix">
		    <div class="box">
			  <h2>Indicadores de Servicio</h2>
		    </div>
			<div>
				<div>
					<img src="/img/navigate-right.png"/><a href="#" id="getTicketByUser" onclick="go('getTicketByUser')">Tickets por usuario</a>
				</div>
				<div>
					<img src="/img/navigate-right.png"/><a href="#" id="getTicketByOffice" onclick="go('getTicketByOffice')">Tickets por oficina</a>
				</div>
				<div>
					<img src="/img/navigate-right.png"/><a href="#" id="getTicketByArea" onclick="go('getTicketByArea')">Tickets por Area</a>
				</div>
				<div>
					<img src="/img/navigate-right.png"/><a href="#" id="getTicketByDay" onclick="go('getTicketByDay')">Tickets por Dia</a>
				</div>
				<div>
					<img src="/img/navigate-right.png"/><a href="#" id="getTicketByProject" onclick="go('getTicketByProject')">Tickets por Proyecto</a>
				</div>
				<div>
					<img src="/img/navigate-right.png"/><a href="#" id="getTicketByServiceAreaKPI" onclick="go('getTicketByServiceAreaKPI')">Solicitudes por tipo de Ticket</a>
				</div>
			</div>	
		</div>
		<div id="indicatorDetail"></div>
	</body>
</html>