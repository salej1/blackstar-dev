var listaEstatusTickets;
var listaUsuariosMesaAyuda;


$(document)
.ready(
		function() {
			
			initReporte();
			
			
			
		});


// Inicializacion de tabla de tickets y dialogo de asignacion
function initReporte() {
	
	//inicializamos controles default
    var mesAnterior = new Date();
    mesAnterior.setTime(mesAnterior.getTime() - (60 * 1000 * 60 * 24 * 30));

	$("#fldFechaIni").datepicker();
	$("#fldFechaIni").datepicker("setDate", mesAnterior);

	$("#fldFechaFin").datepicker();
	$("#fldFechaFin").datepicker("setDate",new Date());
	
	
	$( "#buscarButtonTicket" ).click(function() {
		
		var oTable = $('#dtGridHistoricalTicketsInternos').dataTable();
		oTable.fnDestroy();
		  
		//getTickets();
		  
	});

	
	
	//consultarDatosReporte();

}


function getTickets() {

	$
			.ajax({
				url : "/bloom/getHistoricalInternalTickets.do",
				type : "GET",
				dataType : "json",
				data : {
					fechaIni:$('#fldFechaIni').val(),
					fechaFin:$('#fldFechaFin').val(),
					idEstatusTicket:$('#slEstatusTicket').val(),
					idResposable:$('#slResponsable').val()
				},
				beforeSend : function() {

				},
				success : function(respuestaJson) {
					var listaInternalTickets = respuestaJson.lista;
					
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
										"aaData" : listaInternalTickets,
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

				},
				error : function() {
				}
			});

}


function consultarDatosReporte() {

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
				listaUsuariosMesaAyuda = respuestaJson.listaMap.listaUsuariosMesaAyuda;

				cargaCombosFormulario();
				
				getTickets();

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

	for (var i = 0; i < listaUsuariosMesaAyuda.length; i++) {
		$("#slResponsable")
				.append(
						new Option(listaUsuariosMesaAyuda[i].descripcion,
								listaUsuariosMesaAyuda[i].id));
	}
	
	
	$('#slEstatusTicket').val(-1);
	$('#slResponsable').val(-1);

}




