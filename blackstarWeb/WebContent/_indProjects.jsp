<script type="text/javascript" charset="utf-8">
	 var str = '${projectsKpi}';
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
						  { "mData": "time"},
						  { "mData": "cost"},
						  { "mData": "contactName"},
						  { "mData": "contactPhone"}],
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
							<h2>Proyectos</h2>
							<div class="utils">
								
			</div>
			
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="policy">
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
						<th>Tiempo dedicado (hr)</th>
						<th>Costo dedicado ($)</th>
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

