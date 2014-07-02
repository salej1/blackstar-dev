
<!--
	Seccion tabla tickets internos pendientes
-->
<div class="grid_16">

	<div class="box">
		<h2>Historico de Requisiciones</h2>
		<div class="utils">
		
		<table style="width: 100%;">
			<tr>
				<td style="width: 100px;">Fecha de Registro</td>
				<td style="width: 90px;"><input id="fldFechaIni" type="text" readOnly="true" style="width: 95%;"/></td>
				<td style="width: 60px;text-align:center;"> a</td>
				<td style="width: 90px;"><input id="fldFechaFin" type="text" readOnly="true" style="width: 95%;"/></td>
				<td style="width: 30px;"></td>
				<td>Estatus</td>
				<td colspan="3">
					<select name="slEstatusTicket" id="slEstatusTicket" style="width:200px;">
					</select>
				</td>
			</tr>
			
			<!-- <tr>
				<td>Responsable</td>
				<td colspan="3">
					<select name="slResponsable" id="slResponsable" style="width:200px;">
					</select>
				</td>
			</tr> -->
			<tr colspan="4">
				<td>
					<button id="buscarButtonTicket" class="searchButton">Buscar</button>
				</td>
			</tr>
			
		</table>
			
		</div>
		<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtGridHistoricalTicketsInternos" >
			<thead>
				<tr>
					<th style="width:80px;">Folio</th>
					<th>Estatus</th>
					<th style="width:140px;">Creado</th>
					<th>Solicitante</th>
					<th style="width:300px;">Tipo</th>
					<th>Fecha Limite</th>
					<th>Proyecto</th>
					<th>Oficina</th>
				</tr>
			</thead>
			<tbody>

			</tbody>
		</table>
	</div>
</div>

<!--
	FIN - Seccion tabla de tickets internos
-->


<script type="text/javascript">
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

		$.ajax({
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
									return "<div align='center' style='width:70px;' ><a href='/bloom/ticketDetail/show.do?ticketId="
											+ row.id
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
		
		$('#slEstatusTicket').val(-1);
	}

</script>

