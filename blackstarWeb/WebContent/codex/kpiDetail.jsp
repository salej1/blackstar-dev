<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<script type="text/javascript" charset="utf-8">
		function toCurrency(n) {
		    	var amount = Number(0.00);
		    	if(n == "" || isNaN(n)){
		    		return "$ 0.00";
		    	}
		    	else{
		    		amount = Number(n);
			   		return "$ " + amount.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
		    	}
			}

			function toPercentage(n) {
		    	var amount = Number(0.00);
		    	if(n == "" || isNaN(n)){
		    		return "0.00 %";
		    	}
		    	else{
		    		amount = Number(n);
			   		return amount.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,") + " %";
		    	}
			}

			function getPosition(element){
		        var e = document.getElementById(element);
		        var top = 0;

		        do{
		        	if(e == null){
		        		break;
		        	}
		            top += e.offsetTop;
		        }while(e = e.offsetParent);

		        return top;
		    }

		    function jumpTo(id){    
		        window.scrollTo(0, getPosition(id));
		    }

		    function finished(tag){
				if(typeof(kpiTag) != 'undefined' && tag == kpiTag){
					setTimeout(function(){ jumpTo(kpiTag) }, 200);					
				}
		    }
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
									  { "mData": "origin" },
									  { "mData": "amount" },
									  { "mData": "coverage" }
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toCurrency(data);
												  		}, "aTargets" : [2]
								  		}]}
					);

					finished("facturacion");
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
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toPercentage(data);
												  		}, "aTargets" : [2]
								  		}]}
					);
					finished("efectividad");
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
									  { "mData": "count" }
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toCurrency(data);
												  		}, "aTargets" : [2]
								  		}]}
					);
					finished("cotizaciones");
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
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toPercentage(data);
												  		}, "aTargets" : [4]
								  		}]}
					);
					finished("estatus");
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
									  { "mData": "count" },
									  { "mData": "contribution" }
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toPercentage(data);
												  		}, "aTargets" : [2]
								  		}]}
					);
					finished("origen");
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
					finished("prospectos");
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
					finished("nuevos");
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
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toCurrency(data);
												  		}, "aTargets" : [1]},
								  		{"mRender" : function(data, type, row){
															return toPercentage(data);
												  		}, "aTargets" : [2]
								  		}]}
					);
					finished("familias");
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
								  ],
						"aoColumnDefs" : [{"mRender" : function(data, type, row){
															return toCurrency(data);
												  		}, "aTargets" : [1]
								  		}]}
					);
					finished("comercia");
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
					finished("salesCalls");
				});
			}

			$(function(){

		    	 loadAllKpi();
			});
</script>
<!--   Facturacion    -->	
<div id="content" class="container_16 clearfix">

					<hr>
					<h2 id="facturacion">
						Facturacion
					</h2>
					<table id="invoicingKpi">
						<thead>
							<tr>
								<th style="width:250px;">CST</th>
								<th>Origen</th>
								<th>Monto</th>
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
								<th style="width:250px;">CST</th>
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
							<th style="width:250px;">CST</th>
							<th>Origen</th>
							<th>Monto</th>
							<th>No. de cotizaciones</th>
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
							<th style="width:250px;">CST</th>
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
							<th style="width:250px;">Origen</th>
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