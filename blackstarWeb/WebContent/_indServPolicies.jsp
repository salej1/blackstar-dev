<script type="text/javascript" charset="utf-8">
	 var str = '${policies}';

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
			"sDom": '<"top"if>rt<"bottom"><"clear">',
			"aaSorting": [],
			"aoColumns": [
						  { "mData": "officeName" },
						  { "mData": "policyTypeId" },
						  { "mData": "customerContract" },
						  { "mData": "customer" },
						  { "mData": "finalUser" },
						  { "mData": "project" }, 	              
						  { "mData": "cst" },
						  { "mData": "equipmentType" },
						  { "mData": "brand" },
						  { "mData": "model"},
						  { "mData": "serialNumber"},
						  { "mData": "capacity"},
						  { "mData": "equipmentAddress"},
						  { "mData": "equipmentLocation"},
						  { "mData": "contactName"},
						  { "mData": "contactEmail"},
						  { "mData": "contactPhone"},
						  { "mData": "startDate"},
						  { "mData": "endDate"},
						  { "mData": "visitsPerYear"},
						  { "mData": "responseTimeHR"},
						  { "mData": "solutionTimeHR"},
						  { "mData": "penalty"},
						  { "mData": "service"},
						  { "mData": "includesParts"},
						  { "mData": "exceptionParts"},
						  { "mData": "serviceCenter"}

					  ]				  
                }
		);
		
	} );

 </script> 


	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Polizas</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="policy">
				<thead>
					<tr>
						<th>OFICINA</th>
						<th>GARANTIA</th>
						<th>NUMERO DE CONTRATO DEL CLIENTE</th>
						<th>CLIENTE</th>
						<th>USUARIO FINAL</th>
						<th>NUMEROD E PROYECTO DE SAC</th>
						<th>CST</th>
						<th>EQUIPO</th>
						<th>MARCA</th>
						<th>MODELO</th>
						<th>No. SERIE</th>
						<th>CAP</th>
						<th>DIRECCION DE DONDE SE ENCUENTRA EL EQUIPO</th>
						<th>UBICACION DEL EQUIPO DENTRO DE LAS INSTALACIONES</th>
						<th>CONTACTO</th>
						<th>E-MAIL</th>
						<th>TEL.</th>
						<th>FECHA DE INICIO</th>
						<th>FECHA DE TERMINO</th>
						<th>VISITAS POR AÑO</th>
						<th>TMPO. RESP. EN HORAS</th>
						<th>TMPO. SOL. EN HORAS</th>
						<th>PENALIZ.</th>
						<th>ATENCION</th>
						<th>INCLUYE PARTES</th>
						<th>EXCEPCIÓN DE PARTES</th>
						<th>CENTRO DE SERVICIO</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
	</div>

