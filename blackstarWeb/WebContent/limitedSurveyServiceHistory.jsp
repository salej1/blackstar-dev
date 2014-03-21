<script type="text/javascript">
	
	// Inicializacion de encuestas de servicio
	function limitedSurveyServiceHistory_init(){

		// Tabla de historico de encuestas de servicio para clientes
		getLimitedSurveyServiceHistory();
	}	
	 
	function getLimitedSurveyServiceHistory(){
		$.getJSON("/surveyServices/limitedSurveyServiceHistory.do", function(data){
			// Inicializacion de la tabla de nuevas ordenes de servicio
			$('#dtSurveyServiceHistory').dataTable({	    		
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": data,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "surveyServiceNumber" },
							  { "mData": "customer" },
							  { "mData": "project" },
							  { "mData": "surveyDate" },
							  { "mData": "score" }
						  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/surveyServiceDetail/show.do?operation=2&idObject=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]}	    		    	       
									 ]}
			);

		});
	}
	
</script>

<!--
	Seccion tabla nuevas ordenes de servicio
-->
<div class="grid_16">
	<div class="box">
		<h2>Historial de encuestas de servicio</h2>
		<div class="utils">
			
		</div>
		<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtSurveyServiceHistory">
			<thead>
				<tr>
					<th style="width:80px;">No. Encuesta</th>
					<th style="width:350px;">Cliente</th>
					<th>Proyecto</th>
					<th>Fecha</th>
					<th>Calificacion</th>
				</tr>
			</thead>
			<tbody>

			</tbody>
		</table>
	</div>
</div>

<!--
	FIN - Seccion tabla nuevas ordenes de servicio
-->
