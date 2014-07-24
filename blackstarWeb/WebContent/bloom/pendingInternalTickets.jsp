
<script type="text/javascript">
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
										"aoColumns" : [ 
										{"mData" : "ticketNumber"}, 
										{"mData" : "statusDescr"}, 
										{"mData" : "created"}, 
										{"mData" : "petitionerArea"}, 
										{"mData" : "serviceTypeDescr"}, 
										{"mData" : "deadline"}, 
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
										"aoColumns" : [ 
										                
										                {
											"mData" : "ticketNumber"
										}, {
											"mData" : "statusDescr"
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
												return "<div align='center' style='width:70px;' ><a href='/bloom/ticketDetail/show.do?ticketNumber="
														+ data
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
</script>


<!--
	Seccion tabla tickets internos pendientes
-->
<div class="grid_16">
	<div class="box">
		<h2>Requisiciones Pendientes</h2>
		<div class="utils">
			
		</div>
		<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtGridTicketsInternos">
			<thead>
				<tr>
					<th style="width=250px;">Folio</th>
					<th>Creado</th>
					<th>Solicitante</th>
					<th>Tipo</th>
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
