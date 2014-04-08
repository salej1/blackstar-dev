// Inicializacion de tabla de tickets y dialogo de asignacion
function pendingInternalTicketsInit() {

	// Tabla de tickets pendientes
	getPendingInternalTickets();
}

function internalTicketsInit() {

	// Tabla de tickets pendientes
	getInternalsTickets();
}


function getPendingInternalTickets() {

	$
			.ajax({
				url : "/bloom/getPendingInternalTickets.do",
				type : "GET",
				dataType : "json",
				beforeSend : function() {

				},
				success : function(respuestaJson) {
					var listaInternalTickets = respuestaJson.lista;
					
					// Inicializacion de la tabla de nuevas ordenes de servicio
					$('#dtGridTicketsInternos')
							.dataTable(
									{
										"bProcessing" : true,
										"bFilter" : true,
										"bLengthChange" : false,
										"iDisplayLength" : 10,
										"bInfo" : false,
										"sPaginationType" : "full_numbers",
										"aaData" : listaInternalTickets,
										"sDom" : '<"top"i>rt<"bottom"flp><"clear">',
										"aoColumns" : [ {
											"mData" : "ticketNumber"
										}, {
											"mData" : "createdStr"
										}, {
											"mData" : "petitionerArea"
										}, {
											"mData" : "serviceTypeDescr"
										}, {
											"mData" : "deadlineStr"
										}, {
											"mData" : "project"
										}, {
											"mData" : "officeName"
										}

										],
										"aoColumnDefs" : [ {
											"mRender" : function(data, type,
													row) {
												return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/bloom/detailTicket.do?id="
														+ row.DT_RowId
														+ "'>"
														+ data + "</a></div>";
											},
											"aTargets" : [ 0 ]
										}

										]
									});

				},
				error : function() {
				}
			});

}

// // funcion de filtrado por oficina
// function newServiceOrders_filter(office){
// // tabla de OS nuevas
// var newSOTable = $('#dtGridTicketsInternos').dataTable();
// newSOTable.fnFilter(office, 8);
// }

function getInternalsTickets() {

	$
			.ajax({
				url : "/bloom/getInternalTickets.do",
				type : "GET",
				dataType : "json",
				beforeSend : function() {

				},
				success : function(respuestaJson) {
					var listaInternalTickets = respuestaJson.lista;
					
					// Inicializacion de la tabla de nuevas ordenes de servicio
					$('#dtGridTicketsInternos')
							.dataTable(
									{
										"bProcessing" : true,
										"bFilter" : true,
										"bLengthChange" : false,
										"iDisplayLength" : 10,
										"bInfo" : false,
										"sPaginationType" : "full_numbers",
										"aaData" : listaInternalTickets,
										"sDom" : '<"top"i>rt<"bottom"flp><"clear">',
										"aoColumns" : [ {
											"mData" : "ticketNumber"
										}, {
											"mData" : "createdStr"
										}, {
											"mData" : "petitionerArea"
										}, {
											"mData" : "serviceTypeDescr"
										}, {
											"mData" : "deadlineStr"
										}, {
											"mData" : "project"
										}, {
											"mData" : "officeName"
										}

										],
										"aoColumnDefs" : [ {
											"mRender" : function(data, type,
													row) {
												return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/bloom/detailTicket.do?id="
														+ row.DT_RowId
														+ "'>"
														+ data + "</a></div>";
											},
											"aTargets" : [ 0 ]
										}

										]
									});

				},
				error : function() {
				}
			});

}