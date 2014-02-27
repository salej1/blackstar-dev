<script type="text/javascript" charset="utf-8">
	 var str = '${OSResume}';

	 $(document).ready(function() {

	 try{
	 var data = $.parseJSON(str);
	 }
	 catch(err){
		 alert(data);
	 alert(err);
	 }
	 
	 $('#OSResume').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"bPaginate": false,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": data,
			"sDom": '<"top"i>rt<"bottom"><"clear">',
			"aaSorting": [],
			"aoColumns": [
						  { "mData": "serviceUnit" },
						  { "mData": "project" },
						  { "mData": "customer" },
						  { "mData": "equipmentLocation" },
						  { "mData": "equipmentAddress" },
						  { "mData": "serviceTypeId" }, 	              
						  { "mData": "serviceOrderNumber" },
						  { "mData": "ticketId" },
						  { "mData": "created" },
						  { "mData": "equipmentTypeId"},
						  { "mData": "brand"},
						  { "mData": "model"},
						  { "mData": "serialNumber"},
						  { "mData": "capacity"},
						  { "mData": "responsible"},
						  { "mData": "receivedBy"},
						  { "mData": "serviceComments"},
						  { "mData": "closed"},
						  { "mData": "hasErrors"},
						  { "mData": "materialUsed"},
						  { "mData": "cst"},
						  { "mData": "finalUser"},
						  { "mData": "qualification"},
						  { "mData": "comments"}
					  ],
					  "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					      if( aData["serviceUnit"].indexOf("lbl-") == 0){
					    	  $('td:eq(0)', nRow).html(aData["serviceUnit"]
					    	       .substring(4, aData["serviceUnit"].length));
					    	  $('td', nRow).css({'background':'#C0E1F3'}).css('font-weight', 'bold');
					      }
					    }					  
                }
		);
		
	} );

 </script> 


	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Resumen de Ordenes de Servicio</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="OSResume">
				<thead>
					<tr>
						<th>Unidad de servicio</th>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Cuidad</th>
						<th>Direccion</th>
						<th>Tipo de Servicio</th>
						<th>Num. Orden Servicio</th>
						<th>No. de Ticket</th>
						<th>Fecha</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>Modelo</th>
						<th>Num Serie</th>
						<th>Capacidad del Equipo</th>
						<th>Responsable del Servicio</th>
						<th>Recibe Servicio</th>
						<th>Comentarios u Observaciones plasmadas en la orden de servicio</th>
						<th>Fecha de cierre del Pendiente</th>
						<th>Seguimiento a los pendientes</th>
						<th>Refacciones y/o Baterias utilizadas</th>
						<th>Consultor</th>
						<th>Nombre de la empresa contratista</th>
						<th>Calificacion de la encuesta</th>
						<th>Comentarios del cliente</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
	</div>

