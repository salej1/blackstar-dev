

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

	$
			.ajax({
				url : "/bloomReports/getStatisticsByAreaSupport.do",
				type : "GET",
				dataType : "json",
				data : {
					startCreationDateTicket:$('#startCreationDate').val(),
					endCreationDateTicket:$('#endCreationDate').val()
				},
				beforeSend : function() {

				},
				success : function(respuestaJson) {
					var dataList = respuestaJson.lista;
					
					
					
					// Inicializacion de la tabla de nuevas ordenes de servicio
					$('#dtGridReport')
							.dataTable(
									{
										"bProcessing" : true,
										"bFilter" : true,
										"bLengthChange" : false,
										"iDisplayLength" : 10,
										"bInfo" : false,
										"sPaginationType" : "full_numbers",
										"aaData" : dataList,
										"sDom" : '<"top"i>rt<"bottom"flp><"clear">',
										"aoColumns" : [ 
										{"mData" : "value1"}, 
										{"mData" : "value2"}, 
										{"mData" : "value3"}, 
										{"mData" : "value4"}
										]
									});					

				},
				error : function() {
				}
			});

}


