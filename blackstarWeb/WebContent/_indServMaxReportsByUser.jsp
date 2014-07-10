<script type="text/javascript" charset="utf-8">
	 var str = '${maxReportsByUser}';
	 var sMonth;

	 $(document).ready(function() {

	 try{
	 var data = $.parseJSON(str);
	 }
	 catch(err){
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
						  { "mData": "employee" },
						  { "mData": "customer" },
						  { "mData": "counter" },
						  { "mData": "ticketList" }
					  ],
					  "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					      if( aData["employee"].indexOf("lbl-") == 0){
					    	  $('td:eq(0)', nRow).html(aData["employee"]
					    	       .substring(4, aData["employee"].length));
					    	  $('td', nRow).css({'background':'#C0E1F3'}).css('font-weight', 'bold');
					      }
					    },
			"aoColumnDefs" : [
								{"mRender" : function(data, type, row){
									var tickets = data.split(",");
									var ticketLinkList ="";
									var ticket;

									for(ticket in tickets){
										var ticketLink = convertToLink("T", tickets[ticket]);
										if(ticketLinkList.length > 0){
											ticketLinkList  = ticketLinkList + ", ";
										}
										ticketLinkList = ticketLinkList + ticketLink;
									}

									return ticketLinkList;
								}, "aTargets" : [3]},
							 ]					  
            }
		);
		
	} );

 </script> 


	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>USUARIOS QUE MAS REPORTAN</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="tickets">
				<thead>
					<tr>
						<th style="width:20%">Usuarios que mas reportan</th>
						<th style="width:30%">Empresa</th>
						<th style="width:20%"># Tickets</th>
						<th style="width:30%">Tickets</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
	</div>

