<script type="text/javascript" charset="utf-8">
	 var str = '${ticketsByUser}';

	 $(document).ready(function() {

	 try{
	 var data = $.parseJSON(str);
	 }
	 catch(err){
	 alert(err);
	 }

	 $('#ticketsByUser').dataTable({
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
						  { "mData": "name" },
						  { "mData": "email" },
						  { "mData": "applicantArea" },
						  { "mData": "counter" }
					  ],
		     "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
						      $('td:eq(4)', nRow).css('background', "#86A2CE")
			                                     .css('font-weight', 'bold')
			                                     .css('text-align','center');
						    }						  
     });

  });

 </script> 

<div id="content" class="container_16 clearfix">
		<div class="grid_16" >

			<div class="box">
							<h2>Tickets por Usuario</h2>
							<div class="utils">

			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="ticketsByUser" >
				<thead>
					<tr>
						<th>Usuario</th>
						<th>Email</th>
						<th>Area</th>
						<th>Numero de Tickets</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
		</div>