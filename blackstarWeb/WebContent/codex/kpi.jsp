<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

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
			var kpiTag;

			function applyFilter(tag){
				// $('#invoicingKpi').dataTable().fnDestroy();
				// $('#effectivenessKpi').dataTable().fnDestroy();
				// $('#proposalsKpi').dataTable().fnDestroy();
				// $('#projectsByStatus').dataTable().fnDestroy();
				// $('#projectsByOrigin').dataTable().fnDestroy();
				// $('#clientVisits').dataTable().fnDestroy();
				// $('#newCustomers').dataTable().fnDestroy();
				// $('#productFamilies').dataTable().fnDestroy();
				// $('#comerceCodes').dataTable().fnDestroy();
				// $('#salesCallsRecords').dataTable().fnDestroy();
				$("#indicatorDetail").load("${pageContext.request.contextPath}/codex/kpi/kpiDetail.do");
				kpiTag = tag; 
			}
		</script>
		
<!--   CONTENT   -->
			
<!--   CONTENT COLUMN   -->			
				<div>	
					<table>
						<tr>
							<td style="width:350px">
								CST
								<select name="" id="cstList">
									<option value="">Todos</option>
									<c:forEach var="cst" items="${cstList}">
										<option value="${cst.email}">${cst.name}</option>
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
					</table>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("facturacion"); return false;'>Facturacion</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("efectividad"); return false;'>Efectividad</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("cotizaciones"); return false;'>Cotizaciones enviadas</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("estatus"); return false;'>Cedulas por estatus</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("origen"); return false;'>Cedulas por origen</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("prospectos"); return false;'>Visitas a prospectos</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("nuevos"); return false;'>Clientes nuevos</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("familias"); return false;'>Familias de productos</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("comercia"); return false;'>Codigos Comercia</a>
					</div>
					<div>
						<img src="/img/navigate-right.png"/><a href="#" onclick='applyFilter("salesCalls"); return false;'>Llamadas de ventas</a>
					</div>
				</div>				
<!--   ~ CONTENT COLUMN   -->			
				<div>

				</div>
<!--   ~ CONTENT   -->
