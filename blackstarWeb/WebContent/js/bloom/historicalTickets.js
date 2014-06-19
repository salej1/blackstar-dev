var listaEstatusTickets;
var listaUsuariosMesaAyuda;
var listaHistoricos;

// Inicializacion de tabla de tickets y dialogo de asignacion
function historicalInternalTicketsInit() {
	
	//inicializamos controles default
	var dia1= new Date(new Date().getFullYear(), 0, 1);
    var mesAnterior = new Date();
    mesAnterior.setTime(mesAnterior.getTime() - (60 * 1000 * 60 * 24 * 30));

	$("#fldFechaIni").datepicker();
	$("#fldFechaIni").datepicker("setDate", dia1);

	$("#fldFechaFin").datepicker();
	$("#fldFechaFin").datepicker("setDate",new Date());
	
	
	$( "#buscarButtonTicket" ).click(function() {
		
		var oTable = $('#dtGridHistoricalTicketsInternos').dataTable();
		oTable.fnDestroy();
		  
		getHistoricalInternalTickets();
		  
	});

	
	
	consultarDatosHistorico();

}


function getHistoricalInternalTickets() {

	$
			.ajax({
				url : "/bloom/getHistoricalInternalTickets.do",
				type : "GET",
				dataType : "json",
				data : {
					startCreationDateTicket:$('#fldFechaIni').val(),
					endCreationDateTicket:$('#fldFechaFin').val(),
					idStatusTicket:$('#slEstatusTicket').val()
				},
				beforeSend : function() {

				},
				success : function(respuestaJson) {
					
					
					if (respuestaJson.estatus === "ok") {
						
						listaHistoricos = respuestaJson.lista;
						
						inicializaGrid();
						
						
					} else if(respuestaJson.estatus === "preventivo") {
						
						listaHistoricos = respuestaJson.lista;
						
						var oTable = $('#dtGridHistoricalTicketsInternos').dataTable();
						oTable.fnDestroy();
						
						inicializaGrid();
						
						//alert(respuestaJson.mensaje);
					} else{
						alert(respuestaJson.mensaje);
					}

				},
				error : function() {
				}
			});

}


function inicializaGrid(){
	
	// Inicializacion de la tabla de nuevas ordenes de servicio
	$('#dtGridHistoricalTicketsInternos')
			.dataTable(
					{
						"bProcessing" : true,
						"bFilter" : true,
						"bLengthChange" : false,
						"iDisplayLength" : 10,
						"bInfo" : false,
						"sPaginationType" : "full_numbers",
						"aaData" : listaHistoricos,
						"sDom" : '<"top"i>rt<"bottom"flp><"clear">',
						"aoColumns" : [ 
						{"mData" : "ticketNumber"}, 
						{"mData" : "statusDescr"}, 
						{"mData" : "createdStr"}, 
						{"mData" : "petitionerArea"}, 
						{"mData" : "serviceTypeDescr"}, 
						{"mData" : "deadlineStr"}, 
						{"mData" : "project"}, 
						{"mData" : "officeName"}
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
	
	
}

function consultarDatosHistorico() {

	$.ajax({
		url : "/bloomCatalog/getDataHistorico.do",
		type : "GET",
		dataType : "json",
		async : false,
		beforeSend : function() {

		},
		success : function(respuestaJson) {

			if (respuestaJson.estatus === "ok") {

				listaEstatusTickets = respuestaJson.listaMap.listaEstatusTickets;
//				listaUsuariosMesaAyuda = respuestaJson.listaMap.listaUsuariosMesaAyuda;

				cargaCombosFormulario();
				
				getHistoricalInternalTickets();

			} else {
				if (respuestaJson.estatus === "preventivo") {
				} else {
				}
			}

		},
		error : function() {
		}
	});
}


function cargaCombosFormulario() {

	for (var i = 0; i < listaEstatusTickets.length; i++) {
		$("#slEstatusTicket").append(
				new Option(listaEstatusTickets[i].descripcion, listaEstatusTickets[i].id));
	}

//	for (var i = 0; i < listaUsuariosMesaAyuda.length; i++) {
//		$("#slResponsable")
//				.append(
//						new Option(listaUsuariosMesaAyuda[i].descripcion,
//								listaUsuariosMesaAyuda[i].id));
//	}
	
	
	$('#slEstatusTicket').val(-1);
//	$('#slResponsable').val(-1);

}




