<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="css/jquery-ui.min.css"/>
<script src="js/jquery-1.10.1.min.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
 $(document).ready(function() {
	 var str = '${serviceOrdersToReview}';
	 var dataSOTR = $.parseJSON(str);
	    $('#ordenesPorRevisar').dataTable({	    		
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
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='/osDetail?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data){return "<img src='img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
								  {"mRender" : function(data){return "<div align='center'><a href='/ticketDetail?ticketId=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
								   ]}
		);
	    
	    var strSO = '${serviceOrdersPending}';
		var dataSO = $.parseJSON(strSO);	
		    $('#ordenesPendientes').dataTable({	    		
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
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='/osDetail?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){return "<img src='img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
								  {"mRender" : function(data, type, row){return "<div align='center'><a href='/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
								   ]}
		);
	    } 
 );
 </script> 
 
<title>Ordenes de servicio</title>
</head>
<body>
<div id="content" class="container_16 clearfix">

<div class="grid_16">	
					<div>
						<div>
							<img src="img/navigate-right.png"/><a href="scheduleStatus">Programa de servicios preventivos</a>
						</div>
					</div>
					<p><small>&nbsp;</small></p>
</div>	
<div class="grid_16">					
					<div class="box">
						<h2>Ordenes de servicio por revisar</h2>
						<div class="utils">
							
						</div>
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="ordenesPorRevisar">
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
					<div class="box">
						<h2>Ordenes de servicio con pendientes</h2>
						<div class="utils">
							
						</div>
						<table  cellpadding="0" cellspacing="0" border="0" class="display" id="ordenesPendientes">
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
</body>
</html>