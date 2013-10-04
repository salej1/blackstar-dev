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
<script type="text/javascript" charset="utf-8" src="/media/js/jquery.js"></script>
<script type="text/javascript" charset="utf-8" src="/media/js/jquery.dataTables.js"></script>
<script type="text/javascript" language="javascript" src="/DataTables-1.9.4/media/js/jquery.js"></script>
<script type="text/javascript" language="javascript" src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf-8">
 $(document).ready(function() {
	 var str = '${serviceOrdersToReview}';
	 var data = $.parseJSON(str);
	    $('#ordenesPorRevisar').dataTable({	    		
	    	"bProcessing": true,
	    	"bFilter": false,
	    	"bLengthChange": false,
	    	"iDisplayLength": 10,
	    	"bInfo": false,
	    	"aaData": data,
	    	"aoColumns": [
	    	              { "mData": "serviceOrderId" },
	    	              { "mData": "ticketId" },
	    	              { "mData": "serviceType" },
	    	              { "mData": "created" },
	    	              { "mData": "customer" },
	    	              { "mData": "equipmentType" },
	    	              { "mData": "project" },
	    	              { "mData": "officeName" },
	    	              { "mData": "brand" },
	    	              { "mData": "serialNumber" }
	    	              
	    	          ],
	    	"aoColumnDefs" : [{"mRender" : function(data){return "<div align='center'><a href='/osDetail.html?ticketId=" + data + "'>" + data + "</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='img/pdf.png' onclick=window.open('img/UPSPreview.png', '_blank');/></div>";}, "aTargets" : [0]},
	    	                  {"mRender" : function(data){return "<div align='center'><a href='/ticketDetail.html?ticketId=" + data + "'>" + data + "</a></div>";}, "aTargets" : [1]}	    		    	       
	    		    	       ]}
	    		);
	    
	    var strSO = '${serviceOrdersPending}';
		var dataSO = $.parseJSON(strSO);	
		    $('#ordenesPendientes').dataTable({	    		
		    	"bProcessing": true,
		    	"bFilter": false,
		    	"bLengthChange": false,
		    	"iDisplayLength": 10,
		    	"bInfo": false,
		    	"aaData": dataSO,
		    	"aoColumns": [
		    	              { "mData": "serviceOrderId" },
		    	              { "mData": "ticketId" },
		    	              { "mData": "serviceType" },
		    	              { "mData": "created" },
		    	              { "mData": "customer" },
		    	              { "mData": "equipmentType" },
		    	              { "mData": "project" },
		    	              { "mData": "officeName" },
		    	              { "mData": "brand" },
		    	              { "mData": "serialNumber" }
		    	              
		    	          ],
		    	"aoColumnDefs" : [{"mRender" : function(dataSO){return "<div align='center'><a href='/osDetail.html?ticketId=" + dataSO + "'>" + dataSO + "</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='img/pdf.png' onclick=window.open('img/UPSPreview.png', '_blank');/></div>";}, "aTargets" : [0]},
		    	                  {"mRender" : function(dataSO){return "<div align='center'><a href='/ticketDetail.html?ticketId=" + dataSO + "'>" + dataSO + "</a></div>";}, "aTargets" : [1]}	    		    	       
		    		    	       ]}
		    		);	    
	    } 
 );
 </script> 
 
<title>Tickets</title>
</head>
<body>
<div id="content" class="container_16 clearfix">
<div class="grid_16">
			<p>Padrino: Coordinador</p>
</div>
<div class="grid_15">	
					<div>
						<div>
							<img src="img/navigate-right.png"/><a href="agendaServicio_coo.html">Agendar servicio preventivo</a>
						</div>
						<div>
							<img src="img/navigate-right.png"/><a href="programaServicio_coo.html">Programa de servicios preventivos</a>
						</div>
					</div>
					<p><small>&nbsp;</small></p>
</div>	
<div class="grid_15">					
					<div class="box">
						<h2>Ordenes de servicio por revisar</h2>
						<div class="utils">
							<a href="#">Ver Todos</a>
						</div>
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="ordenesPorRevisar">
							<thead>
								<tr>
									<th>Folio<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Folio:');"/></th>
									<th>Ticket<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Ticket:');"/></th>
									<th>Tipo<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Tipo:');"/></th>
									<th>Fecha<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Fecha:');"/></th>
									<th>Cliente<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Cliente:');"/></th>
									<th>Equipo<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Equipo:');"/></th>
									<th>Proyecto<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Proyecto:');"/></th>
									<th>Oficina<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Oficina:');"/></th>
									<th>Marca<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Marca:');"/></th>
									<th>No. Serie<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Modelo:');"/></th>
								</tr>
							</thead>
							<tbody>
								
							</tbody>
						</table>
					</div>	
					<div class="box">
						<h2>Ordenes de servicio con pendientes</h2>
						<div class="utils">
							<a href="#">Ver Todos</a>
						</div>
						<table  cellpadding="0" cellspacing="0" border="0" class="display" id="ordenesPendientes">
							<thead>
								<tr>
									<th>Folio<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Folio:');"/></th>
									<th>Ticket<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Ticket:');"/></th>
									<th>Tipo<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Tipo:');"/></th>
									<th>Fecha<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Fecha:');"/></th>
									<th>Cliente<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Cliente:');"/></th>
									<th>Equipo<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Equipo:');"/></th>
									<th>Proyecto<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Proyecto:');"/></th>
									<th>Oficina<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Oficina:');"/></th>
									<th>Marca<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Marca:');"/></th>
									<th>No. Serie<img class="filterImg" src="img/filter-16.png" onclick="filtrar('Modelo:');"/></th>
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