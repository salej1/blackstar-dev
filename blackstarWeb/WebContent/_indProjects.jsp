<script type="text/javascript" charset="utf-8">
	 var str = '${projectsKpi}';

	 $(document).ready(function() {

	 try{
	 	var data = $.parseJSON(str);
	 }
		 catch(err){
		 alert(err);
	 }
	 
	 $('#policy').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"bPaginate": false,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": data,
			"sDom": '<"top"fi>rt<"bottom"><"clear">',
			"aaSorting": [],
			"aoColumns": [
						  { "mData": "project" },
						  { "mData": "officeName" },
						  { "mData": "warranty" },
						  { "mData": "contract" },
						  { "mData": "customer" },
						  { "mData": "finalUser" }, 	              
						  { "mData": "cst" },
						  { "mData": "startDate" },
						  { "mData": "endDate" },
						  { "mData": "contactName"},
						  { "mData": "contactPhone"}]
			}
		);
	} );
 </script> 


	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Proyectos</h2>
							<div class="utils">
								
			</div>
			
			<table cellpadding="5" cellspacing="0" border="0" class="display" id="policy">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Oficina</th>
						<th>Garantia</th>
						<th>Contrato</th>
						<th style="width:90px;">Cliente</th>
						<th>Usuario final</th>
						<th>CST</th>
						<th>Fecha de inicio</th>
						<th>Fecha de termino</th>
						<th>Contacto</th>
						<th>Telefono de contacto</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
	</div>

