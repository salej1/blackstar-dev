<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>

<script type="text/javascript">
	
	// Inicializacion de tabla
	function visitList_init(){

		// Tabla de ordenes de servicio pendientes
		getVisitList();

		$("#closureDialog").dialog({
			autoOpen: false,
			height: 250,
			width: 400,
			modal: true,
			buttons: {
				"Aceptar": function() {
					window.location = "${pageContext.request.contextPath}/codex/visit/resolve.do?codexVisitId=" + $("#closingVisitId").val() + "&closureComment=" + $("#closureComment").val();
					$(this).dialog('close');
				},
				"Cancelar": function() {
					$(this).dialog('close');
				}}
		});
	}	
	
	function closeVisit(){
		$("#closureDialog").dialog('open');
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
							  { "mData": "customerName" },
							  { "mData": "visitStatus" },
							  { "mData": "codexVisitId" }
							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div><a href='${pageContext.request.contextPath}/codex/visit/show.do?codexVisitId=" + row.codexVisitId + "'>" + data + "</a></div>";}, "aTargets" : [2]},
									  {"mRender" : function(data, type, row){
									  		if(row.visitStatusId == "P"){
										  		return "<div align='left'><a href='#' onclick='$(\"#closingVisitId\").val(" + row.codexVisitId + "); closeVisit(); return false;'>Cerrar visita</a></div>";
									  		}
									  		else{
									  			return row.closure;
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
		<div class="box">
			<h2>Visitas de prospección</h2>
			<div class="utils">
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtVisits">
				<thead>
					<tr>
						<th style="width:180px;">CST</th>
						<th style="width:130px;">Fecha</th>
						<th style="width:300px;">Cliente</th>
						<th style="width:70px;">Estatus</th>
						<th>Seguimiento</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	<div id="closureDialog" title="Comentario de cierre">
		Por favor ingrese un comentario de cierre de la visita:
		<input type="hidden" id="closingVisitId">
		<textarea name="" id="closureComment" style="margin-top:15px;width:95%" rows="5"></textarea>
	</div>
<!--
	FIN - Seccion tabla de historial de ordenes de servicio 
-->
