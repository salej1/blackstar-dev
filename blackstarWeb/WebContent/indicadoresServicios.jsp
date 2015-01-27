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
		<script src="${pageContext.request.contextPath}/js/moment.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/linkConverter.js"></script>

		<title>Indicadores de servicio</title>
		
		<script type="text/javascript" charset="utf-8">
			var project = "All";
			var year = moment().year();
			var yearStart = moment({year: year, month: 0, day: 1});
			var month = moment().month();
			var monthStart = moment({year: year, month: month, day: 1});
			var startDateStr = yearStart.format("DD/MM/YYYY") + " 00:00:00";
			var endDateStr = moment().format("DD/MM/YYYY") + " 00:00:00";
			var policySearch = "";
			var chartList = ['getTicketByUser','getTicketByOffice','getTicketByArea','getTicketByDay','getTicketByProject','getTicketByServiceAreaKPI'];

			$(function(){
				
				$("#optProjects").bind("change", function(){
					project = $(this).val();
				});

		    	 $("#dateRange").hide();
		    	 $("#startDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){startDateStr = date +" 00:00:00";}, changeMonth: true, changeYear: true});
		    	 $("#endDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){endDateStr = date +" 00:00:00";}, changeMonth: true, changeYear: true});
		    	 $("#dateSelector").bind("change", function(){
		    	 	switch($(this).val()){
		    	 		case "1":
		    	 			startDateStr = yearStart.format("DD/MM/YYYY") + " 00:00:00";
		    	 			endDateStr = moment().format("DD/MM/YYYY") + " 00:00:00";
		    	 			$("#dateRange").hide();
		    	 			break;
	    	 			case "2":
	    	 				startDateStr = monthStart.format("DD/MM/YYYY") + " 00:00:00";
		    	 			endDateStr = moment().format("DD/MM/YYYY") + " 00:00:00";
		    	 			$("#dateRange").hide();
		    	 			break;
		    	 		case "3":
		    	 			startDateStr = monthStart.format("DD/MM/YYYY") + " 00:00:00";
		    	 			endDateStr = moment().format("DD/MM/YYYY") + " 00:00:00";
		    	 			$("#startDate").val(monthStart.format("DD/MM/YYYY"));
		    	 			$("#endDate").val(moment().format("DD/MM/YYYY"));
		    	 			$("#dateRange").show();
		    	 			break;
		    	 	}
		    	 });

		    	 $(".links").accordion({
		    	 	collapsible: true,
		    	 	active: false,
		    	 	event: "click",
		    	 	icons: false,
		    	 	heightStyle: "content"
		    	 });
			});

			 function go(indAction, mode){
			 	// Indicador para incluir o no polizas ya renovadas
			 	var param = "0";
			 	if(indAction == 'getPolicies'){
			 		if($('#includeRenewedPolicies').prop('checked') ){
			 			param = 1;
			 		}
			 	}
			 	if(typeof(mode) != undefined && mode == 'display'){
			 		window.open("${pageContext.request.contextPath}/indServicios/" + indAction + ".do?project=" + project + "&startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr));
			 	}
			 	else{
			 		 $("a[href*=#]").css({ "color": "#888", "text-decoration":"underline"});
		    		 $("#indicatorDetail").load("${pageContext.request.contextPath}/indServicios/" + indAction + ".do?project=" + project + "&startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr) + "&param=" + param, function() {
		    		  $("#" + indAction).css({ "color": "#800080", "text-decoration":"none"});
		    	  });
			 	}
		     }

		     function getChainedChart(chartNum){
		     	if(chartNum < chartList.length){
		     		var chartName = chartList[chartNum];
		     		
		     		// healt hcheck
		     		if(typeof(chartName) == 'undefined'){
			     		throw new Error('Grafica ' + chartNum + ' invalida');
			     	}

			     	// content
					var url = "${pageContext.request.contextPath}/bloom/bloomKpi/" + chartName + ".do?startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr);
					$("#chartDetail" + chartNum).load(url, function() {
						$("#" + chartName).css({ "color": "#800080", "text-decoration":"none"});
						// next chart
						getChainedChart(chartNum + 1);
					});
		     	}
		     }

		     function goBloom(indAction){
		     	var url = "";

				$("a[href*=#]").css({ "color": "#888", "text-decoration":"underline"});
				if(indAction == 'getGeneralCharts'){
					$("#indicatorDetail").html('');
					getChainedChart(0);
				}
				else{
					var url = "${pageContext.request.contextPath}/bloom/bloomKpi/" + indAction + ".do?startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr);
					$("#indicatorDetail").load(url, function() {
						$("#" + indAction).css({ "color": "#800080", "text-decoration":"none"});
					});
				}
		     }


			function parse(input){
				var output;
				try {
				    output = $.parseJSON(input.replace(/'/g, '"'));
				} catch(err){
					alert(err);
				}
				console.log(input.replace(/'/g, '"'));
				return output;
			}
		</script>
	</head>
	<body>

<!--   CONTENT COLUMN   -->		
		<div id="all" class="container_16 clearfix">
			<div id="content">
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
			<div id="content" class="links">
				<h3>Indicadores de Servicio</h3>
				<div>
					<!-- Seccion links para acceso a clientes -->
					<c:set var="isCustomer" scope="request" value="${user.belongsToGroup['Cliente']}" />
					<c:choose>
						<c:when test="${isCustomer == true}">
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getCharts" onclick="go('getCharts')">Graficas generales</a>
							</div>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getConcurrentFailures" onclick="go('getConcurrentFailures')">Fallas recurrentes</a>
							</div>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getTickets" onclick="go('getTickets')">Tickets</a>
							</div>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getPolicies" onclick="go('getPolicies');">Concentrado polizas</a>
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
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getPolicies" onclick="go('getPolicies');">Concentrado polizas</a>
								<input type="checkbox" name="includeRenewedPolicies"/>Incluir renovadas
							</div>
							<c:if test="${user.belongsToGroup['Call Center']}">
								<div>
									<img src="/img/navigate-right.png"/><a href="#" id="getCharts" onclick="go('getDisplayCharts', 'display')">Display de graficas generales</a>
								</div>
							</c:if>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getAverage" onclick="go('getProjects')">Proyectos</a>
							</div>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getAverage" onclick="go('getPolicyExport', 'display')">Exportar Polizas</a>
							</div>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getAverage" onclick="go('getTicketsExport', 'display')">Exportar Tickets</a>
							</div>
							<div>
								<img src="/img/navigate-right.png"/><a href="#" id="getAverage" onclick="go('getSOExport', 'display')">Exportar Ordenes de servicio</a>
							</div>
						</c:otherwise>
					</c:choose>
				</div>	

				<c:if test="${isCustomer == null}">
					<!-- Indicadores de Requisiciones -->
		  		  	<h3>Indicadores de Requisiciones</h3>
					<div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getTicketByServiceAreaKPI" onclick="goBloom('getGeneralCharts')">Graficas Generales</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getTicketStatsByServiceAreaKPI" onclick="goBloom('getTicketStatsByServiceAreaKPI')">Resultados por Area de apoyo</a>
						</div>
						<div>
							<img src="/img/navigate-right.png"/><a href="#" id="getNonSatisfactoryTicketsByUsr" onclick="goBloom('getNonSatisfactoryTicketsByUsr')">Requisiciones no satisfactorias por usuario</a>
						</div>
					</div>	
				</c:if>
			</div>
			<div id="indicatorDetail">
				
			</div>
			<div id="chartDetail0">
				
			</div>
			<div id="chartDetail1">
				
			</div>
			<div id="chartDetail2">
				
			</div>
			<div id="chartDetail3">
				
			</div>
			<div id="chartDetail4">
			
			</div>
			<div id="chartDetail5">
				
			</div>
		</div>
	</body>
</html>