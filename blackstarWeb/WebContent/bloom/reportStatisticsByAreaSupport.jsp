<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<script type="text/javascript">
	

$(document)
.ready(
		function() {
			
			initReport();
		});


function initReport() {
	
	//inicializamos controles default
	var day1= new Date(new Date().getFullYear(), 0, 1);

	$("#startCreationDate").datepicker();
	$("#startCreationDate").datepicker("setDate", day1);

	$("#endCreationDate").datepicker();
	$("#endCreationDate").datepicker("setDate",new Date());
	
	
	$( "#searchButtonTicket" ).click(function() {
		
		var oTable = $('#dtGridReport').dataTable();
		oTable.fnDestroy();
		  
		consultingReportData();
		  
	});
	
	
	consultingReportData();

}


function consultingReportData() {

	$.ajax({
		url : "/bloom/bloomKpi/getStatisticsByAreaSupport.do?startDate=" + encodeURIComponent(startDateStr) + "&endDate=" + encodeURIComponent(endDateStr),
		type : "GET",
		dataType : "json",
		success : function(data) {
			
			// Inicializacion de la tabla de nuevas ordenes de servicio
			$('#dtGridReport').dataTable({
					"bProcessing" : true,
					"bFilter" : true,
					"bLengthChange" : false,
					"iDisplayLength" : 100,
					"bInfo" : false,
					"sPaginationType" : "full_numbers",
					"aaData" : data,
					"aaSorting": [],
					"sDom" : '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns" : [ 
						{"mData" : "area"}, 
						{"mData" : "total"}, 
						{"mData" : "minRespTime"}, 
						{"mData" : "avgRespTime"}, 
						{"mData" : "maxRespTime"}, 
						{"mData" : "onTime"}, 
						{"mData" : "outTime"}, 
						{"mData" : "ok"}, 
						{"mData" : "notOk"}
						]
				});					

		},
		error : function() {
		}
	});
}



</script>
<script type="text/javascript" charset="utf-8">

	function split( val ) {
      return val.split( /,\s*/ );
    }

    function extractLast( term ) {
      return split( term ).pop();
    }

	function isNumberKey(evt){
	      var charCode = (evt.which) ? evt.which : event.keyCode;
	    	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
	    	            return false;

	    	         return true;
	}

	</script>

	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
			<h2>Requisiciones - Resultados por Area de apoyo</h2>
			<div class="utils">
				* Los tiempos de respuesta se muestran en Horas.
			</div>
			
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtGridReport">
				<thead>
					<tr>
						<th style="width:100px">Area de Apoyo</th>
						<th>Total Reqs.</th>
						<th>T. Min. Resp.</th>
						<th>T. Prom. Resp.</th>
						<th>T. Max. Resp.</th>
						<th>En tiempo</th>
						<th>Fuera de tiempo</th>
						<th>Satisfactorias</th>
						<th>No satisfactorias</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>
		</div>
	</div>
