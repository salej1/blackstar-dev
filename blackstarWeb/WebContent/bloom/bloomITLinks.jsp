<!-- Seccion de links que permite ver los diferentes reportes de tickets internos -->
<div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getReporteTiempoRespuestaAreaApoyo(); return false;">Reporte - Tiempo de respuesta por &aacute;rea de apoyo</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getReporteTiempoRespuestaMesaAyuda(); return false;">Reporte - Tiempo de respuesta de mesa de ayuda</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getReporteTicketsCerrados(); return false;">Reporte - % Tickets cerrados en tiempo, fuera de tiempo</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getReporteTicketsEvaluacion(); return false;">Reporte - Tickets por evaluaci&oacute;n</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getReporteTicketsNoSatisfactorios(); return false;">Reporte - Tickets no satisfactorios por Ing. Serv</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getReporteTicketsPorAreaApoyo(); return false;">Reporte - Tickets por &aacute;rea de apoyo</a>
	</div>
	
	<p><small>&nbsp;</small></p>
</div>
<!-- FIN - Seccion de links resportes de tickets internos -->


<script>
	// Init
	function bloomITLinks_init(){
		//Inicializacion
		
	}
	
	
	function getReporteTiempoRespuestaAreaApoyo(){
	    var url = '/bloomReports/reporteTiempoRespuestaAreaApoyo.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	function getReporteTiempoRespuestaMesaAyuda(){
	    var url = '/bloomReports/reporteTiempoRespuestaMesaAyuda.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	function getReporteTicketsCerrados(){
	    var url = '/bloomReports/reporteTicketsCerrados.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	

	function getReporteTicketsEvaluacion(){
	    var url = '/bloomReports/reporteTicketsEvaluacion.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	function getReporteTicketsNoSatisfactorios(){
	    var url = '/bloomReports/reporteTicketsNoSatisfactorios.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	
	function getReporteTicketsPorAreaApoyo(){
	    var url = '/bloomReports/reporteTicketsAreaApoyo.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	

</script>
