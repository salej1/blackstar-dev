<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="dashboard" />
<c:import url="../header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="/css/jquery-ui.min.css"/>
<script src="/js/jquery-1.10.1.min.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<script src="/js/jquery.ui.datepicker.js"></script>
<script src="/js/moment.min.js"></script>

<script type="text/javascript" charset="utf-8">
			var year = moment().year();
			var yearStart = moment({year: year, month: 0, day: 1});
			var month = moment().month();
			var monthStart = moment({year: year, month: month, day: 1});
			var startDateStr = yearStart.format("DD/MM/YYYY") + " 00:00:00";
			var endDateStr = moment().format("DD/MM/YYYY") + " 23:59:59";

			function loadAllKpi(){
				// invoicing KPI
				var parametersTemplate = "?startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr) + "&cst=" + $("#cstList").val() + "&clientOriginId=" + $("#originList").val();
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getInvoicingKpi.do" + parametersTemplate, function(data){
					$("#invoicingKpi").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cstName"},
									  { "mData": "amount" },
									  { "mData": "origin" },
									  { "mData": "coverage" }
								  ]}
					);
				});

				// Effectiveness KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getEffectiveness.do" + parametersTemplate, function(data){
					$("#effectivenessKpi").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cstName"},
									  { "mData": "origin" },
									  { "mData": "effectiveness" }
								  ]}
					);
				});

				// Proposals KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getProposals.do" + parametersTemplate, function(data){
					$("#proposalsKpi").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cstName"},
									  { "mData": "origin" },
									  { "mData": "amount" },
									  { "mData": "status" }
								  ]}
					);
				});

				// Projects by status KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getProjectsByStatus.do" + parametersTemplate, function(data){
					$("#projectsByStatus").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cstName"},
									  { "mData": "origin" },
									  { "mData": "status" },
									  { "mData": "count" },
									  { "mData": "contribution" }
								  ]}
					);
				});

				// Projects by origin KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getProjectsByOrigin.do" + parametersTemplate, function(data){
					$("#projectsByOrigin").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "origin" },
									  { "mData": "amount" },
									  { "mData": "contribution" }
								  ]}
					);
				});

				// Client Visits KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getClientVisits.do" + parametersTemplate, function(data){
					$("#clientVisits").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cstName" },
									  { "mData": "origin" },
									  { "mData": "count" }
								  ]}
					);
				});

				// New Customers KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getNewCustomers.do" + parametersTemplate, function(data){
					$("#newCustomers").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cstName" },
									  { "mData": "count" }
								  ]}
					);
				});

				// Product families KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getProductFamilies.do" + parametersTemplate, function(data){
					$("#productFamilies").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "productFamily" },
									  { "mData": "amount" },
									  { "mData": "contribution" }
								  ]}
					);
				});

				// Comerce Codes KPI
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getComerceCodes.do" + parametersTemplate, function(data){
					$("#comerceCodes").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "code" },
									  { "mData": "amount" }
								  ]}
					);
				});

				// Llamadas de ventas
				$.getJSON("${pageContext.request.contextPath}/codex/kpi/getSalesCallsRecords.do" + parametersTemplate, function(data){
					$("#salesCallsRecords").dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 1000,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns": [
									  { "mData": "cst" },
									  { "mData": "month" },
									  { "mData": "year" },
									  { "mData": "callCount" }
								  ]}
					);
				});
			}

			function applyFilter(){
				$('#invoicingKpi').dataTable().fnDestroy();
				$('#effectivenessKpi').dataTable().fnDestroy();
				$('#proposalsKpi').dataTable().fnDestroy();
				$('#projectsByStatus').dataTable().fnDestroy();
				$('#projectsByOrigin').dataTable().fnDestroy();
				$('#clientVisits').dataTable().fnDestroy();
				$('#newCustomers').dataTable().fnDestroy();
				$('#productFamilies').dataTable().fnDestroy();
				$('#comerceCodes').dataTable().fnDestroy();
				$('#salesCallsRecords').dataTable().fnDestroy();
				loadAllKpi();
			}

			$(function(){
				
				 $(".dateRange").hide();
		    	 $("#startDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){startDateStr = date +" 00:00:00";}, changeMonth: true, changeYear: true});
		    	 $("#endDate").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){endDateStr = date +" 23:59:59";}, changeMonth: true, changeYear: true});
		    	 $("#dateSelector").bind("change", function(){
		    	 	switch($(this).val()){
		    	 		case "1":
		    	 			startDateStr = yearStart.format("DD/MM/YYYY") + " 00:00:00";
		    	 			endDateStr = moment().format("DD/MM/YYYY") + " 23:59:59";
		    	 			$(".dateRange").hide();
		    	 			break;
	    	 			case "2":
	    	 				startDateStr = monthStart.format("DD/MM/YYYY") + " 00:00:00";
		    	 			endDateStr = moment().format("DD/MM/YYYY") + " 23:59:59";
		    	 			$(".dateRange").hide();
		    	 			break;
		    	 		case "3":
		    	 			startDateStr = monthStart.format("DD/MM/YYYY") + " 00:00:00";
		    	 			endDateStr = moment().format("DD/MM/YYYY") + " 23:59:59";
		    	 			$("#startDate").val(monthStart.format("DD/MM/YYYY"));
		    	 			$("#endDate").val(moment().format("DD/MM/YYYY"));
		    	 			$(".dateRange").show();
		    	 			break;
		    	 	}
		    	 });

		    	 loadAllKpi();
			});

		</script>
		
 	<title>Indicadores</title>
	</head>
	<body>

<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">	
					<table>
						<tr>
							<td>
								Periodo:
								<select id="dateSelector">
									<option value="1" selected>Año Actual</option>
									<option value="2">Mes Actual</option>
									<option value="3">Rango de fechas</option>
								</select>
							</td>
							<td class="dateRange">
								Fecha Inicial
								<input type="text" id="startDate" readonly/>
							</td>
							<td class="dateRange">
								Fecha final
								<input type="text" id="endDate" readonly/>
							</td>
							<td>
								CST
								<select name="" id="cstList">
									<option value="0">Todos</option>
									<c:forEach var="cst" items="${cstList}">
										<option value="${cst.cstId}">${cst.name}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								Origen
								<select name="" id="originList">
									<option value="0">Todos</option>
									<c:forEach var="origin" items="${originList}">
										<option value="${origin.id}">${origin.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td><button id="filter" onclick="applyFilter();">Filtrar</button></td>
						</tr>
					</table>
					<div>
						<img src="/img/navigate-right.png"/><a href="#facturacion">Facturacion</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#efectividad" >Efectividad</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#cotizaciones" >Cotizaciones enviadas</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#estatus" >Cedulas por estatus</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#origen" >Cedulas por origen</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#prospectos" >Visitas a prospectos</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#nuevos" >Clientes nuevos</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#familias" >Familias de productos</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#comercia" >Codigos Comercia</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#salesCalls" >Llamadas de ventas</a>
					</div>
				</div>				
<!--   ~ CONTENT COLUMN   -->			
				<div class="grid_16">
<!--   Facturacion    -->	
					<hr>
					<h2 id="facturacion">
						Facturacion
					</h2>
					<table id="invoicingKpi">
						<thead>
							<tr>
								<th>CST</th>
								<th>Monto</th>
								<th>Origen</th>
								<th>Cumplimiento Cuota %</th>
							</tr>
						</thead>
					</table>
<!--   ~ Facturacion  -->		

<!--   Efectividad    -->	
					<hr>
					<h2 id="efectividad">
						Efectividad
					</h2>
					<table id="effectivenessKpi">
						<thead>
							<tr>
								<th>CST</th>
								<th>Origen</th>
								<th>Efectividad</th>
							</tr>
						</thead>
					</table>
<!--   ~ Efectividad  -->		

<!--   Cotizaciones    -->	
					<hr>
					<h2 id="cotizaciones">
						Cotizaciones Enviadas
					</h2>
					<table id="proposalsKpi">
						<thead>
						<tr>
							<th>CST</th>
							<th>Origen</th>
							<th>Monto</th>
							<th>Estatus</th>
						</tr>
						</thead>
					</table>
<!--   ~ Cotizaciones  -->	

<!--   Estatus    -->	
					<hr>
					<h2 id="estatus">
						Cedulas por Estatus
					</h2>
					<table id="projectsByStatus">
						<thead>
						<tr>
							<th>CST</th>
							<th>Origen</th>
							<th>Estatus</th>
							<th>Cantidad</th>
							<th>Porcentaje</th>
						</tr>
						</thead>
					</table>
<!--   ~ Estatus  -->	

<!--   Origen    -->	
					<hr>
					<h2 id="origen">
						Cedulas por Origen
					</h2>

					<table id="projectsByOrigin">
						<thead>
						<tr>
							<th>Origen</th>
							<th>Cantidad</th>
							<th>Porcentaje</th>
						</tr>
						</thead>
					</table>
<!--   ~ Origen  -->	

<!--   Prospectos    -->	
					<hr>
					<h2 id="prospectos">
						Visitas a Prospectos
					</h2>
					<table id="clientVisits">
						<thead>
						<tr>
							<th>CST</th>
							<th>Origen</th>
							<th>Cantidad</th>
						</tr>
						</thead>
					</table>					
<!--   ~ Prospectos  -->	

<!--   Nuevos    -->	
					<hr>
					<h2 id="nuevos">
						Nuevos Clientes
					</h2>
					<table id="newCustomers">
						<thead>
						<tr>
							<th>CST</th>
							<th>Cantidad</th>
						</tr>
						</thead>
					</table>
<!--   ~ Nuevos  -->	

<!--   Familias    -->	
					<hr>
					<h2 id="familias">
						Familias de Productos
					</h2>
					<table id="productFamilies">
						<thead>
						<tr>
							<th>Familia de productos</th>
							<th>Monto</th>
							<th></th>
							<th>Contribucion %</th>
						</tr>
						</thead>
					</table>
<!--   ~ Familias  -->	

<!--   Comercia    -->	
					<hr>
					<h2 id="comercia">
						Codigos Comercia
					</h2>
					<table id="comerceCodes">
						<thead>
						<tr>
							<th>Codigo Comercia</th>
							<th>Monto</th>
						</tr>
						</thead>
					</table>
<!--   ~ Comercia  -->	

<!--   Llamadas de ventas    -->	
					<hr>
					<h2 id="salesCalls">
						Llamadas de Ventas
					</h2>
					<table id="salesCallsRecords">
						<thead>
						<tr>
							<th>CST</th>
							<th>Mes</th>
							<th>Año</th>
							<th>Llamadas</th>
						</tr>
						</thead>
					</table>
<!--   ~ Llamadas de ventas  -->	
				</div>
			</div>
<!--   ~ CONTENT   -->
			
	</body>
</html>