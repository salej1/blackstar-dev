<script type="text/javascript" charset="utf-8">
	var str = '${tickets}';
	var sMonth;

	$(document).ready(function() {

	try{
	    var data = $.parseJSON(str);
	} catch(err){
	    alert(err);
	}
	
	$('#tickets').dataTable({
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
						 { "mData": "ticketNumber" },
						 { "mData": "customer" },
						 { "mData": "equipmentLocation" },
						 { "mData": "equipmentType" },
						 { "mData": "equipmentBrand" },
						 { "mData": "created" }, 	             
						 { "mData": "arrival" },
						 { "mData": "closed" },
						 { "mData": "asignee" },
						 { "mData": "contact" },
						 { "mData": "contactEmail" },
						 { "mData": "contactPhone" },
						 { "mData": "ticketStatus"}

					 ],
					 "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
						 var backcolor= 'white';
						 if( aData["ticketStatus"] == "CERRADO" ){
							 backcolor = "#DFF2BF";
						 } else if(aData["ticketStatus"] == 'CERRADO FT' ){
							 backcolor = "#E5F32A";
						 }else if(aData["ticketStatus"] == 'RETRASADO' ){
							 backcolor = "#F0C0C0";
						 }
					     $('td:eq(12)', nRow).css('background', backcolor).css('font-weight', 'bold');
					     if( aData["ticketNumber"].indexOf("lbl-") == 0){
					   	  $('td:eq(0)', nRow).html(aData["ticketNumber"]
					   	       .substring(4, aData["ticketNumber"].length));
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
							<h2>Tickets</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="tickets">
				<thead>
					<tr>
						<th>No. de Ticket</th>
						<th style="width:120px;">Cliente</th>
						<th>Ubicación del equipo</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>Fecha y hora en la que se levanto el reporte</th>
						<th>Hora y fecha de Llegada a Sitio</th>
						<th>Fecha y hora de cierre</th>
						<th>Ingeniero que atendió</th>
						<th>Contacto</th>
						<th>Email Contacto</th>
						<th>Telefono Contacto</th>
						<th>Estatus</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
	</div>

