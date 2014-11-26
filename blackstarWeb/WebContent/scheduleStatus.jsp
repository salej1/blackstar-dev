<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.cookie.js"></script>
<script>
	$(function(){
		// tabla de servicios futuros
		var strServices = '${futureServices}';
		var servData = $.parseJSON(strServices);

		$('#futureServices').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"aaData": servData,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "scheduledDate" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "project" },
						  { "mData": "officeName" },
						  { "mData": "brand" },
						  { "mData": "serialNumber" },
						  { "mData": "scheduledServiceId" }
					  ],
			"aoColumnDefs" : [
						{"mRender" : function(data, type, row){return new Date(data).format("dd/MM/yyyy");}, "aTargets" : [0]},
						{"mRender" : function(data, type, row){return "<a href='/scheduleStatus/scheduledServiceDetail.do?serviceId=" + row.scheduledServiceId + "'>Editar</a>";}, "aTargets" : [7]}
					]}
		);	

		$("#optOffices option[value='" + $.cookie('blackstar_office_pref') + "']").attr("selected", "true");
	});

	function refresh(val){
		// guardamos la preferencia
		$.cookie('blackstar_office_pref', val, { expires: 365, path: "/" });
		window.location = "/scheduleStatus/show.do?office=" + val;
	}
</script>
<body>
	<!--   CONTENT   -->
	<div id="content" class="container_16 clearfix">

		<!--   CONTENT COLUMN   -->
		<div>
			<c:if test="${user.belongsToGroup['Coordinador']}">
				<div>
					<img src="/img/navigate-right.png"/><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=0">Agendar servicio</a>
				</div>
			</c:if>
		</div>
		<p>
			<small>&nbsp;</small>
		</p>
		<div class="grid_16">
			<p>Oficina:
				<select id="optOffices" onchange="refresh($(this).val());">
					<option value="">Todas</option>
					<c:forEach var="office" items="${offices}">
						<option value = "${office}">${office}</option>
					</c:forEach>					
				</select>
			</p>

			<div class="box">
				<h2>Programa semanal de servicios</h2>
				<div class="utils"></div>
				<caption>&nbsp;</caption>
				<table>
					<thead>
						<tr>
							<th colspan="5">${ today }</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach var="service" items="${servicesToday0}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
						
					<thead>
						<tr>
							<th colspan="5">${ today1 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday1}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="5">${ today2 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday2}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="5">${ today3 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday3}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="5">${ today4 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday4}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="5">${ today5 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday5}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
					</tbody>
					<thead>
						<tr>
							<th colspan="5">${ today6 }</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="service" items="${servicesToday6}">
						<tr>
							<td>${ service.equipmentType }</td>
							<td>${ service.customer }</td>
							<td>${ service.serialNumber }</td>
							<td>${ service.defaultEmployee }</td>
							<td><a href="/scheduleStatus/scheduledServiceDetail.do?serviceId=${service.scheduledServiceId}">Editar</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<p>
			<small>&nbsp;</small>
		</p>
		<div class="grid_16">
			<div class="box">
				<h2>Servicios programados a futuro</h2>
				<div class="utils"></div>
				<table id="futureServices">
					<thead>
						<tr>
							<th>Fecha</th>
							<th>Cliente</th>
							<th>Equipo</th>
							<th>Proyecto</th>
							<th>Oficina</th>
							<th>Marca</th>
							<th>No. Serie</th>
							<th>Editar</th>
						</tr>
					</thead>
			
				</table>
			</div>
		</div>
		<!--   ~ CONTENT COLUMN   -->
		<!--   ~ CONTENT   -->
	</div>
</body>
</html>