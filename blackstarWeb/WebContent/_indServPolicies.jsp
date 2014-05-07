<script type="text/javascript" charset="utf-8">
	 var str = '${policies}';
	Date.isLeapYear = function (year) { 
	    return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0)); 
	};

	Date.getDaysInMonth = function (year, month) {
	    return [31, (Date.isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
	};

	Date.prototype.isLeapYear = function () { 
	    var y = this.getFullYear(); 
	    return (((y % 4 === 0) && (y % 100 !== 0)) || (y % 400 === 0)); 
	};

	Date.prototype.getDaysInMonth = function () { 
	    return Date.getDaysInMonth(this.getFullYear(), this.getMonth());
	};

	Date.prototype.addMonths = function (value) {
	    var n = this.getDate();
	    this.setDate(1);
	    this.setMonth(this.getMonth() + value);
	    this.setDate(Math.min(n, this.getDaysInMonth()));
	    return this;
	};

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
						  { "mData": "serviceCenter"}],
			"fnRowCallback": function(nRow, aData, iDisplayIndex, iDisplayIndexFull){
								var ed = new Date(aData.endDate);
								var today = new Date();
								var criticalDate = new Date(aData.endDate).addMonths(-2);

								if(ed.getTime() < today.getTime()){
									$(nRow).css('background-color', '#F5A2A4');
								}
								else if(criticalDate.getTime() < today.getTime()){
									$(nRow).css('background-color', '#F2CF83');
								}
								else{
									$(nRow).css('background-color', '#FFFFFF');
								}
							}
                }
		);
		$("td", "#policy").css("background-color", "transparent");
	} );

 </script> 


	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Polizas</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="5" cellspacing="0" border="0" class="display" id="policy">
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

