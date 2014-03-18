// Inicializacion de tabla de tickets y dialogo de asignacion
function pendingInternalTicketsInit() {

	// Tabla de tickets pendientes
	getPendingTickets();
}

function getPendingTickets() {

	$
			.ajax({
				url : "/bloom/getPendingTickets.do",
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
											"mData" : "applicantAreaName"
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

function getPendingTickets2() {
	$
			.getJSON(
					"/bloom/getPendingTickets.do",
					function(data) {

						var listaInternalTickets = data.lista;

						// Inicializacion de la tabla de nuevas ordenes de
						// servicio
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
												"mData" : "TicketNumber"
											}, {
												"mData" : "CreatedStr"
											}, {
												"mData" : "petitionerArea"
											}, {
												"mData" : "ServiceTypeDescr"
											}, {
												"mData" : "DeadlineStr"
											}, {
												"mData" : "ApplicantAreaName"
											}, {
												"mData" : "OfficeName"
											}

											],
											"aoColumnDefs" : [ {
												"mRender" : function(data,
														type, row) {
													return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/bloom/detailTicket.do?id="
															+ row.DT_RowId
															+ "'>"
															+ data
															+ "</a></div>";
												},
												"aTargets" : [ 0 ]
											}

											]
										});

						// newServiceOrders_filter(officePref);
					});
}
