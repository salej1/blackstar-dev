<script type="text/javascript">
	
	// Inicializacion de tabla
	function visitList_init(){

		// Tabla de ordenes de servicio pendientes
		getVisitList();
	}	
	
	function getVisitList(){
		$.getJSON("/codex/visit/visitListJson.do", function(data){
			// Inicializacion de tabla de ordenes de servicio con algun pendiente
			$('#dtVisits').dataTable({	
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
							  { "mData": "cstName" },
							  { "mData": "visitDate" },
							  { "mData": "clientName" },
							  { "mData": "visitStatus" },
							  { "mData": "codexVisitId" }
							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div><a href='${pageContext.request.contextPath}/codex/visit/show.do?codexVisitId=" + row.codexVisitId + "'>" + data + "</a></div>";}, "aTargets" : [2]},
									  {"mRender" : function(data, type, row){
									  		if(row.visitStatusId == "P"){
										  		return "<div align='center'><a href='${pageContext.request.contextPath}/codex/visit/resolve.do?codexVisitId=" + row.codexVisitId + "'>Visita realizada</a></div>";
									  		}
									  		else{
									  			return "";
									  		}
									  	}, "aTargets" : [4]}	    		    	       
									   ]}
			);
		});
	}
	
</script>

<!--
	Seccion tabla de visitas a clientes
-->
	<div class="grid_16">
		<div>
			<img src="/img/navigate-right.png"/><a href="${pageContext.request.contextPath}/codex/visit/create.do" >Registrar visita</a>
		</div>
		
		<br>				

		<div class="box">
			<h2>Visitas a clientes</h2>
			<div class="utils">
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtVisits">
				<thead>
					<tr>
						<th style="width:200px;">CST</th>
						<th>Fecha</th>
						<th style="width:350px;">Cliente</th>
						<th>Estatus</th>
						<th>Accion</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>

<!--
	FIN - Seccion tabla de historial de ordenes de servicio 
-->
