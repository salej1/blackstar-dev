<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="dashboard" />
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
	var strSO = '${serviceOrdersPendingDashboard}';
	var strSOTR = '${serviceOrdersToReviewDashboard}';
	var assignedTicket = 0;
	
	function refreshTicketList(){
  
		// Tabla de Ordenes de servicio nuevas
		 var dataSOTR  = $.parseJSON(strSOTR);
		 
		$('#dtOrdenesPorRevisar').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": dataSOTR,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "serviceOrderNumber" },
						  { "mData": "placeHolder" },
						  { "mData": "ticketNumber" },
						  { "mData": "serviceType" },
						  { "mData": "created" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "project" },
						  { "mData": "officeName" },
						  { "mData": "brand" },
						  { "mData": "serialNumber" }

					  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data){return "<img src='${pageContext.request.contextPath}/img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
								  {"mRender" : function(data){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketId=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
								   ]}
		);

		// Tabla de ordenes de servicio pendientes
		var dataSO = $.parseJSON(strSO);	

		$('#dtOrdenesPendientes').dataTable({	
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": dataSO,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
						  { "mData": "serviceOrderNumber" },
						  { "mData": "placeHolder" },
						  { "mData": "ticketNumber" },
						  { "mData": "serviceType" },
						  { "mData": "created" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "project" },
						  { "mData": "officeName" },
						  { "mData": "brand" },
						  { "mData": "serialNumber" }

						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){return "<img src='${pageContext.request.contextPath}/img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
								  {"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
								   ]}
		);
	 }
	 
 
 $(document).ready(function() {

	
	refreshTicketList();
	
});
</script> 
<title>Tickets</title>
</head>
<body>
<div id="content" class="container_16 clearfix">

<!--   CONTENT COLUMN   -->		
	<c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['sysCallCenter']}" />
	<c:if test="${sysCallCenter == true}">
		<c:import url="unassignedTickets.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				unassignedTickets_init();
			});
		</script>
	</c:if>

	<div class="grid_16">
		<div class="box">
			<h2>Ordenes de servicio por revisar</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPorRevisar">
				<thead>
					<tr>
						<th style="width=250px;">Folio</th>
						<th style="width=50px;"></th>
						<th>Ticket</th>
						<th>Tipo</th>
						<th>Fecha</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Proyecto</th>
						<th>Oficina</th>
						<th>Marca</th>
						<th>No. Serie</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>

	</div>

	<div class="grid_16">
		<div class="box">
			<h2>Ordenes de servicio con pendientes</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPendientes">
				<thead>
					<tr>
						<th>Folio</th>
						<th></th>
						<th>Ticket</th>
						<th>Tipo</th>
						<th>Fecha</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Proyecto</th>
						<th>Oficina</th>
						<th>Marca</th>
						<th>No. Serie</th>
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