<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
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
	 var str = '${ticketsList}';
	 var data = $.parseJSON(str);
	 
	    $('#tickets').dataTable({	    		
	    	"bProcessing": true,
	    	"bFilter": false,
	    	"bLengthChange": false,
	    	"iDisplayLength": 10,
	    	"bInfo": false,
	    	"aaData": data,
	    	"aoColumns": [
	    	              { "mData": "ticketId" },
	    	              { "mData": "created" },
	    	              { "mData": "contactName" },
	    	              { "mData": "serialNumber" },
	    	              { "mData": "customer" },
	    	              { "mData": "equipmenttype" },
	    	              { "mData": "solutionTimeDeviationHr" },
	    	              { "mData": "project" },
	    	              { "mData": "ticketStatus" },
	    	              { "mData": "OS" }
	    	              
	    	          ],
	    	"aoColumnDefs" : [{"mRender" : function(data){return "<div align=center><a href=/ticketDetail.html?ticketId=" + data + ">" + data + "</a></div>";}, "aTargets" : [0]},
	    	                  {"mRender" : function(data){return "<div align=left><a href=/osDetail.html>" + data + "</a></div>";}, "aTargets" : [9]}	    		    	       
	    		    	       ]}
	    		);
	    } );
 </script> 

 <title>Tickets</title>
 </head>
<body>

<div id="content" class="container_16 clearfix">
<div class="grid_16">
			<p>Padrino: Coordinador</p>

		<div class="box">
						<h2>Ultimos tickets asignados</h2>
						<div class="utils">
							<a href="#">Ver Todos</a>
		</div>
	<table cellpadding="0" cellspacing="0" border="0" class="display" id="tickets">
		<thead>
			<tr>
				<th width="10%">Ticket</th>
				<th width="15%">Fecha/Hora</th>
				<th width="10%">Contacto</th>
				<th width="10%">NS</th>
				<th width="10%">Cliente</th>				
				<th width="5%">Equipo</th>
				<th width="10%">TR</th>
				<th width="10%">Proyecto</th>
				<th width="10%">Estatus</th>
				<th width="10%">OS</th>					
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