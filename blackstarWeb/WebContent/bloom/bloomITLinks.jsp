<!-- Seccion de links que permite ver los diferentes reportes de tickets internos -->
<div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="reportStatisticsByAreaSupport(); return false;">Reporte - Tiempo de respuesta por &aacute;rea de apoyo</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="reportStatisticsByHelpDesk(); return false;">Reporte - Tiempo de respuesta de mesa de ayuda</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="reportPercentageTimeClosedTickets(); return false;">Reporte - % Tickets cerrados en tiempo, fuera de tiempo</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="reportPercentageEvaluationTickets(); return false;">Reporte - Tickets por evaluaci&oacute;n</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="reportUnsatisfactoryTicketsByUserEngineeringService(); return false;">Reporte - Tickets no satisfactorios por Ing. Serv</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="reportNumberTicketsByArea(); return false;">Reporte - Tickets por &aacute;rea de apoyo</a>
	</div>
	
	<p><small>&nbsp;</small></p>
</div>
<!-- FIN - Seccion de links resportes de tickets internos -->


<script>
	// Init
	function bloomITLinks_init(){
		//Inicializacion
		
	}
	
	
	function reportStatisticsByAreaSupport(){
	    var url = '/bloomReports/reportStatisticsByAreaSupport.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	function reportStatisticsByHelpDesk(){
	    var url = '/bloomReports/reportStatisticsByHelpDesk.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	function reportPercentageTimeClosedTickets(){
	    var url = '/bloomReports/reportPercentageTimeClosedTickets.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	

	function reportPercentageEvaluationTickets(){
	    var url = '/bloomReports/reportPercentageEvaluationTickets.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	function reportUnsatisfactoryTicketsByUserEngineeringService(){
	    var url = '/bloomReports/reportUnsatisfactoryTicketsByUserEngineeringService.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	
	
	function reportNumberTicketsByArea(){
	    var url = '/bloomReports/reportNumberTicketsByArea.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}
	

</script>
