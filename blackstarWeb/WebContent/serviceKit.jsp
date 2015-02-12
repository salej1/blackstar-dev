<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>GPO. SAC - Kit de Servicios</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
	<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript">
	$(function(){
		// Hide object tables.
		$(".lateLoad").hide();
		$(".lateEnable").attr("disabled","");

		$("#okMessageBox").dialog({
				autoOpen: false,
				height: 150,
				width: 360,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$( this ).dialog( "close" );
					}
				}
			});	
	});

	function loadServiceOrder(){
		var soNum = $("#serviceOrderDeleteNumber").val();
		$.getJSON("${pageContext.request.contextPath}/support/getServiceOrderDetails.do?serviceOrderNumber=" + soNum, function(data){
				$('#serviceOrderDetail').dataTable().fnDestroy()
				$("#serviceOrderDetail").dataTable({
					"bProcessing": true,
					"bFilter": false,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "serviceOrderNumber" },
								  { "mData": "serviceDate" },
								  { "mData": "createdByUsr" },
								  { "mData": "created" },
								  { "mData": "ticket" },
								  { "mData": "policy" },
								  { "mData": "openCustomer" }, 	              
								  { "mData": "hasPdf" }
							  ]
				});

				$("#serviceOrderDetail").show();
				$(".soButton").removeAttr("disabled");
			});
	}

	function loadServiceOrderComments(){
		var soNum = $("#serviceOrderDeleteNumber").val();
		var data = $.getJSON("${pageContext.request.contextPath}/support/getServiceOrderComments.do?serviceOrderNumber=" + soNum, function(data){
				$('#serviceOrderComment').dataTable().fnDestroy()
				$("#serviceOrderComment").dataTable({
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "created" },
								  { "mData": "createdByUsr" },
								  { "mData": "followUp" },
								  { "mData": "followUpId" }
							  ],
					"aoColumnDefs" : [
									{"mRender" : function(data, type, row){return "<div><a href='' onclick='deleteComment(" + row.followUpId + "); return false;'>Borrar</a></div>";}, "aTargets" : [3]}]
				});

				$("#serviceOrderComment").show();
			});
	}

	function deleteServiceOrder(){
		$.getJSON("${pageContext.request.contextPath}/support/deleteServiceOrder.do?serviceOrderNumber=" + $("#serviceOrderDeleteNumber").val(), function(data){
			if(data[0].OK == "OK"){
				$("#okMessageBox").html("La orden de servicio ha sido eliminada");
				$("#okMessageBox").dialog("open");
			}
		});
	}

	function deleteServiceOrderPDF(){
		$.getJSON("${pageContext.request.contextPath}/support/deleteServiceOrderPDF.do?serviceOrderNumber=" + $("#serviceOrderDeleteNumber").val(), function(data){
			if(data[0].OK == "OK"){
				$("#okMessageBox").html("El PDF de la orden de servicio ha sido cancelado");
				$("#okMessageBox").dialog("open");
			}
		});
	}

	function deleteComment(followUpId){
		$.getJSON("${pageContext.request.contextPath}/support/deleteComment.do?followUpId=" + followUpId, function(data){
			if(data[0].OK == "OK"){
				$("#okMessageBox").html("El comentario ha sido eliminado");
				$("#okMessageBox").dialog("open");
			}
		});
	}

	function loadTicket(){
		var tickNum = $("#ticketNumber").val();
		$.getJSON("${pageContext.request.contextPath}/support/getTicketDetail.do?ticketNumber=" + tickNum, function(data){
				$('#ticketDetail').dataTable().fnDestroy()
				$("#ticketDetail").dataTable({
					"bProcessing": true,
					"bFilter": false,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "ticketNumber" },
								  { "mData": "createdByUsr" },
								  { "mData": "created" },
								  { "mData": "status" }
							  ]
				});

				$("#ticketDetail").show();
				$(".ticketButton").removeAttr("disabled");
			});
	}

	function deleteTicket(){
		$.getJSON("${pageContext.request.contextPath}/support/deleteTicket.do?ticketNumber=" + $("#ticketNumber").val(), function(data){
			if(data[0].OK == "OK"){
				$("#okMessageBox").html("El ticket ha sido eliminado");
				$("#okMessageBox").dialog("open");
			}
			else{
				$("#okMessageBox").html(data[0].OK);
				$("#okMessageBox").dialog("open");
			}
		});
	}

	function loadTicketComments(){
		var tickNum = $("#ticketNumber").val();
		var data = $.getJSON("${pageContext.request.contextPath}/support/getTicketComments.do?ticketNumber=" + tickNum, function(data){
				$('#ticketComments').dataTable().fnDestroy()
				$("#ticketComments").dataTable({
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "created" },
								  { "mData": "createdByUsr" },
								  { "mData": "followUp" },
								  { "mData": "followUpId" }
							  ],
					"aoColumnDefs" : [
									{"mRender" : function(data, type, row){return "<div><a href='' onclick='deleteComment(" + row.followUpId + "); return false;'>Borrar</a></div>";}, "aTargets" : [3]}]
				});

				$("#ticketComments").show();
			});
	}

	function loadBloomTicket(){
		var tickNum = $("#bloomTicketNumber").val();
		$.getJSON("${pageContext.request.contextPath}/support/getBloomTicketDetails.do?ticketNumber=" + tickNum, function(data){
				$('#bloomTicketDetail').dataTable().fnDestroy()
				$("#bloomTicketDetail").dataTable({
					"bProcessing": true,
					"bFilter": false,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "ticketNumber" },
								  { "mData": "ticketType" },
								  { "mData": "createdByUsr" },
								  { "mData": "created" },
								  { "mData": "status" }
							  ]
				});

				$("#bloomTicketDetail").show();
				$(".bloomTicketButton").removeAttr("disabled");
			});
	}

	function deleteBloomTicket(){
		$.getJSON("${pageContext.request.contextPath}/support/deleteBloomTicket.do?ticketNumber=" + $("#bloomTicketNumber").val(), function(data){
			if(data[0].OK == "OK"){
				$("#okMessageBox").html("La requisicion ha sido eliminada");
				$("#okMessageBox").dialog("open");
			}
			else{
				$("#okMessageBox").html(data[0].OK);
				$("#okMessageBox").dialog("open");
			}
		});
	}

	function loadBloomTicketComments(){
		var tickNum = $("#bloomTicketNumber").val();
		var data = $.getJSON("${pageContext.request.contextPath}/support/getBloomTicketComments.do?ticketNumber=" + tickNum, function(data){
				$('#bloomTicketComments').dataTable().fnDestroy()
				$("#bloomTicketComments").dataTable({
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "created" },
								  { "mData": "createdByUsr" },
								  { "mData": "followUp" },
								  { "mData": "followUpId" }
							  ],
					"aoColumnDefs" : [
									{"mRender" : function(data, type, row){return "<div><a href='' onclick='deleteComment(" + row.followUpId + "); return false;'>Borrar</a></div>";}, "aTargets" : [3]}]
				});

				$("#bloomTicketComments").show();
			});
	}

</script>
</head>
<body>
	<div id="content" class="container_16 clearfix">
		<div class="grid_16">					
			<h1>Kit de Soporte</h1>
			Hora servidor: ${serverTime}
			<br>
			Hora local: ${localTime}

			<!-- Ordenes de servicio -->
			<div  class="box">
				<h2>Ordenes de servicio</h2>
				<br>
				<div>Orden de servicio:</div>
				<input type="text" id="serviceOrderDeleteNumber"/> <button id="loadServiceOrder" onclick="loadServiceOrder();">Cargar</button>
				<div style="margin-top:10px;">
					<table class="lateLoad" id="serviceOrderDetail">
						<thead>
							<tr>
								<th>No. orden</th>
								<th>Fecha Serv.</th>
								<th>Creada por</th>
								<th>Creada el</th>
								<th>Ticket</th>
								<th>Poliza</th>
								<th>Sin poliza</th>
								<th>PDF</th>
							</tr>
						</thead>
					</table>
				</div>
				<div style="margin-top:10px;">
					<button class="lateEnable soButton" onclick="deleteServiceOrder();">Borrar</button>
					<button class="lateEnable soButton" onclick="deleteServiceOrderPDF();">Cancelar PDF</button>
					<button class="lateEnable soButton" onclick="loadServiceOrderComments();">Cargar comentarios</button>
				</div>
				<div style="margin-top:10px;">
					Comentarios:
					<table class="lateLoad" id="serviceOrderComment">
						<thead>
							<tr>
								<th>Fecha</th>
								<th>Creado por</th>
								<th>Comentario</th>
								<th></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>

			<!-- Tickets -->
			<div class="box">
				<h2>Tickets</h2>
				<br>
				<div>Ticket:</div>
				<input type="text" id="ticketNumber"/> <button id="loadTicket" onclick="loadTicket();">Cargar</button>
				<div style="margin-top:10px;">
					<table class="lateLoad" id="ticketDetail">
						<thead>
							<tr>
								<th>Ticket</th>
								<th>Creado por</th>
								<th>Creado el</th>
								<th>Estatus</th>
							</tr>
						</thead>
					</table>
				</div>
				<div style="margin-top:10px;">
					<button class="lateEnable ticketButton" onclick="deleteTicket();">Borrar</button>
					<button class="lateEnable ticketButton" onclick="loadTicketComments();">Cargar comentarios</button>
				</div>
				<div style="margin-top:10px;">
					Comentarios:
					<table class="lateLoad" id="ticketComments">
						<thead>
							<tr>
								<th>Fecha</th>
								<th>Creado por</th>
								<th>Comentario</th>
								<th></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>

			<!-- Requisiciones -->
			<div class="box">
				<h2>Requisiciones</h2>
				<br>
				<div>Requisicion:</div>
				<input type="text" id="bloomTicketNumber"/> <button id="loadBloomTicket" onclick="loadBloomTicket();">Cargar</button>
				<div style="margin-top:10px;">
					<table class="lateLoad" id="bloomTicketDetail">
						<thead>
							<tr>
								<th>Folio</th>
								<th>Tipo</th>
								<th>Creado por</th>
								<th>Creado el</th>
								<th>Estatus</th>
							</tr>
						</thead>
					</table>
				</div>
				<div style="margin-top:10px;">
					<button class="lateEnable bloomTicketButton" onclick="deleteBloomTicket();">Borrar</button>
					<button class="lateEnable bloomTicketButton" onclick="loadBloomTicketComments();">Cargar comentarios</button>
				</div>
				<div style="margin-top:10px;">
					Comentarios:
					<table class="lateLoad" id="bloomTicketComments">
						<thead>
							<tr>
								<th>Fecha</th>
								<th>Creado por</th>
								<th>Comentario</th>
								<th></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>	

	<!-- Message box -->
	<div id="okMessageBox">

	</div>
</body>
</html>