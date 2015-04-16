<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<script src="${pageContext.request.contextPath}/js/datepicker-es.js"></script>
<script src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript">
	var year = moment().year();
	var yearStart = moment({year: year, month: 0, day: 1});
	var month = moment().month();
	var monthStart = moment({year: year, month: month, day: 1});
	var startDateStr = yearStart.format("DD/MM/YYYY") + " 00:00:00";
	var endDateStr = moment().format("DD/MM/YYYY") + " 00:00:00";

	// Inicializacion de tabla

	function limitedServiceOrdersHistory_init(){

		// Tabla de ordenes de servicio pendientes
		getlimitedServiceOrdersHistory();

		$("#dateRange").hide();
		// $.datepicker.setDefaults( $.datepicker.regional[ "es" ] );
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
	}	
	
	function getlimitedServiceOrdersHistory(){
		$.getJSON("/serviceOrders/limitedServiceOrdersHistoryJson.do?startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr), function(data){
			// Inicializacion de tabla de ordenes de servicio con algun pendiente
			$('#dtOrdersHistory').dataTable({	
					"bProcessing": false,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aaSorting": [],
					"aoColumns": [
							  { "mData": "serviceOrderNumber" },
							  { "mData": "placeHolder" },
							  { "mData": "ticketNumber" },
							  { "mData": "serviceType" },
							  { "mData": "serviceDate" },
							  { "mData": "customer" },
							  { "mData": "equipmentType" },
							  { "mData": "brand" },
							  { "mData": "serialNumber" },
							  { "mData": "serviceStatus" }

							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:85px;' ><a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
									  {"mRender" : function(data, type, row){
									  		if(row.hasPdf == "1"){
									  			return "<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=" + row.DT_RowId + "' target='_blank'><img src='${pageContext.request.contextPath}/img/pdf.png'</a>" ;									  			
									  		}
									  		else
									  		{
									  			return "&nbsp";
									  		}
									  	}, "aTargets" : [1]},
									  {"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
									   ]}
			);
		});
	}

	function reloadHistory(){
		$('#dtOrdersHistory').dataTable().fnDestroy();
		getlimitedServiceOrdersHistory();
	}
	
</script>

<!--
	Seccion tabla de historial de ordenes de servicio 
-->
	<div class="grid_16">
		<div class="box">
			<h2>Historial de Ordenes de Servicio</h2>
			<div class="utils">
				
			</div>
			<table style="margin:10px;">
				<tr>
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
			<input style="margin:10px;" type="submit" id="filterHistory" value="Filtrar" class="searchButton" onclick="reloadHistory(); return false;"/>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdersHistory">
				<thead>
					<tr>
						<th style="width:90px">Folio</th>
						<th></th>
						<th>Ticket</th>
						<th>Tipo</th>
						<th>Fecha</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>No. Serie</th>
						<th>Estatus</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>

<!--
	FIN - Seccion tabla de historial de ordenes de servicio 
-->
