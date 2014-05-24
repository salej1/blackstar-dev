<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="indicadores" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
		<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
		<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
		<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>

		<title>Ordenes de servicio</title>
		
		<script type="text/javascript" charset="utf-8">
			var project = "All";
			var year = new Date().getYear() + 1900;
			var yearStart = new Date(year,0,1);
			var month = new Date().getMonth();
			var monthStart = new Date(year,month,1);
			var startDateStr = yearStart.format("dd/MM/yyyy") + " 00:00:00";
			var endDateStr = dateNow() + " 00:00:00";;

			$(function(){
				$("#optProjects").bind("change", function(){
					project = $(this).val();
				});

		    	 $("#dateRange").hide();
		    	 $("#startDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){startDateStr = date +" 00:00:00";}});
		    	 $("#endDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){endDateStr = date +" 00:00:00";}});
		    	 $("#dateSelector").bind("change", function(){
		    	 	switch($(this).val()){
		    	 		case "1":
		    	 			startDateStr = yearStart.format("dd/MM/yyyy") + " 00:00:00";
		    	 			endDateStr = new Date().format("dd/MM/yyyy") + " 00:00:00";
		    	 			$("#dateRange").hide();
		    	 			break;
	    	 			case "2":
	    	 				startDateStr = monthStart.format("dd/MM/yyyy") + " 00:00:00";
		    	 			endDateStr = new Date().format("dd/MM/yyyy") + " 00:00:00";
		    	 			$("#dateRange").hide();
		    	 			break;
		    	 		case "3":
		    	 			startDateStr = monthStart.format("dd/MM/yyyy") + " 00:00:00";
		    	 			endDateStr = new Date().format("dd/MM/yyyy") + " 00:00:00";
		    	 			$("#startDate").val(monthStart.format("dd/MM/yyyy"));
		    	 			$("#endDate").val(new Date().format("dd/MM/yyyy"));
		    	 			$("#dateRange").show();
		    	 			break;
		    	 	}
		    	 });
			});
			 function go(indAction, mode){
			 	if(typeof(mode) != undefined && mode == 'display'){
			 		window.open("${pageContext.request.contextPath}/indServicios/" + indAction + ".do?project=" + project + "&startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr));
			 	}
			 	else{
			 		 $("a[href*=#]").css({ "color": "#888", "text-decoration":"underline"});
		    		 $("#indicatorDetail").load("${pageContext.request.contextPath}/indServicios/" + indAction + ".do?project=" + project + "&startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr), function() {
		    		  $("#" + indAction).css({ "color": "#800080", "text-decoration":"none"});
		    	  });
			 	}
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
					<div id="indFilters">
					<table>
						<tr>
							<td style="width:15%;">
								Proyecto:
								<select name="" id="optProjects">
									<option value="All">Todos</option>
									<c:forEach var="project" items="${projects}">
										<option value = "${project}">${project}</option>
									</c:forEach>	
								</select>
							</td>

							<td style="width:20%;">
								Periodo:
								<select id="dateSelector">
									<option value="1" selected>Año Actual</option>
									<option value="2">Mes Actual</option>
									<option value="3">Rango de fechas</option>
								</select>
							</td>
							<td style="width:33%;">
								<div id="dateRange">
									Fecha Inicial
									<input type="text" id="startDate" readonly/>
									Fecha final
									<input type="text" id="endDate" readonly/>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<hr>  
				<!-- Seccion links para acceso a clientes -->
				<c:set var="isCustomer" scope="request" value="${user.belongsToGroup['Cliente']}" />
				<c:choose>
					<c:when test="${isCustomer == true}">
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getCharts" onclick="go('getCharts')">Graficas generales</a>
						</div>
					</c:when>
					<c:otherwise>
						<!-- Seccion links para empleados GPO SAC -->
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getStatics" onclick="go('getStatics')">Estadisticas</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getCharts" onclick="go('getCharts')">Graficas generales</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getMaxReportsByUser" onclick="go('getMaxReportsByUser')">Usuarios que mas reportan</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getTickets" onclick="go('getTickets')">Tickets</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getConcurrentFailures" onclick="go('getConcurrentFailures')">Fallas recurrentes</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getAverage" onclick="go('getAverage')">Promedios</a>
						</div>
						<!-- <div>
							<img src="/img/navigate-right.png"/><a href="#" id="getReportOS" onclick="go('getReportOS')">Reporte Ordenes de servicio</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getOSResume" onclick="go('getOSResume')">Resumen Ordenes de servicio</a>
						</div> -->
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getPolicies" onclick="go('getPolicies')">Concentrado polizas</a>
						</div>
						<c:if test="${user.belongsToGroup['Call Center']}">
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getCharts" onclick="go('getDisplayCharts', 'display')">Display de graficas generales</a>
							</div>
						</c:if>
					</c:otherwise>
				</c:choose>
			</div>	
		</div>
		<div id="indicatorDetail"></div>
	</body>
</html>