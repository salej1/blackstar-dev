<!-- Seccion de links que permiten crear nuevo ticket interno -->
<div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="getNewInternalTickets(); return false;">Crear Requisicion</a>
	</div>
	<p><small>&nbsp;</small></p>
</div>
<!-- FIN - Seccion de links que permiten crear nuevo ticket interno -->

<script>
		
	function getNewInternalTickets(){
	    var url = '/bloom/newInternalTicket.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}

</script>
