<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>

<div id="offlineSendMsg" title="Enviando Ordenes de servicio locales..." style="text-align:center">
	MESSAGE... <br><br> <img src="/img/processing.gif"/>
</div>

<script type="text/javascript">
	function offlineSoSend_init(){
		$( "#offlineSendMsg" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        
		        }
		    });
	}

	function notifyOfflineSending(soName){
		var content = "Enviando Orden de servicio " + soName + ". Por favor espere... <br><br> <img src='/img/processing.gif'/>";

		$("#offlineSendMsg").html(content);
		$("#offlineSendMsg").dialog('open');
	}

	function sendOfflineSO(){
		if(typeof(Storage) !== "undefined") {
			if(localStorage.blackstar_osIndex){
				var orders = localStorage.blackstar_osIndex.split(",");

				if(typeof(orders) !== "undefined" && orders.length > 0){
				
					$("#offlineSendMsg").dialog('open');
	
					for(var order in orders){
						
						var key = localStorage.getItem("blackstarKey" + orders[order]);
						var content = localStorage.getItem("blackstarContent" + orders[order]);
						var url = "";

						switch(key){
							case "OS": url = "/plainService/save.do";
								break;
							case "AA": url = "/aircoService/save.do"
								break;
							case "BB": url = "/batteryService/save.do";
								break;
							case "PE": url = "/emergencyPlantService/save.do";
								break;
							case "UPS": url = "/upsService/save.do";
								break;
						}

						if(url != "" && content != ""){
							notifyOfflineSending(orders[order]);

							$.post(url, content).
								always(function(){
									localStorage.removeItem("blackstarKey" + orders[order]);
									localStorage.removeItem("blackstarContent" + orders[order]);
									$("#offlineSendMsg").dialog('close');
								});
						}
					}
				}
			}

			localStorage.removeItem("blackstar_osIndex");
		}
	}
</script>
