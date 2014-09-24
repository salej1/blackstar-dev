<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>

<div id="WaitMessage" title="Guardar Orden de servicio" style="text-align:center">
	Guardando Orden de servicio... <br><br> <img src="/img/processing.gif"/>
</div>
<div id="OkMessage" title="Orden de servicio guardada">
	La orden de servicio ${serviceOrder.serviceOrderNumber} se guardo exitosamente.
	<br>
	Seleccione Aceptar para volver al inicio.
</div>
<div id="FailMessage" title="Error al guardar la OS">
	Ocurrio un error al guardar la orden de servicio ${serviceOrder.serviceOrderNumber}. Por favor verifique los datos e intente nuevamente
</div>
<div id="InvalidMessage" title="Revise los datos de la OS">
	Por favor revise que todos los campos hayan sido llenados.
</div>
<div id="OfflineSaveMessage" title="Revise los datos de la OS">
	No fué posible conectar con el servidor. La OS fue guardada temporalmente en el dispositivo. Será enviada al servidor al recuperar la conexión.
</div>

<script type="text/javascript">
	$(function(){
		$( "#OkMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 450,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
					window.location = '/dashboard/show.do';
		        }
		      }
		    });

		    $( "#FailMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
		        }
		      }
		    });

		     $( "#InvalidMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        Aceptar: function() {
		          $( this ).dialog( "close" );
		        }
		      }
		    });

		    $( "#WaitMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
		        
		        }
		    });

		    $( "#OfflineSaveMessage" ).dialog({
		      modal: true,
		      autoOpen: false,
		      width: 350,
		      buttons: {
	        	 Aceptar: function() {
		         	$( this ).dialog( "close" );
					window.location = '/dashboard/show.do';
		        }
		      }
		    });
	});

	function saveIfConnected(osType){
		var handler = "";

		switch(osType){
			case "OS": handler = "plainService";
				break;
			case "AA": handler = "aircoService";
				break;
			case "BB": handler = "batteryService";
				break;
			case "PE": handler = "emergencyPlantService";
				break;
			case "UPS": handler = "upsService";
				break;
		}
		$.get("${pageContext.request.contextPath}/dashboard/ping.do", function(data){
			// send to server
			$.post("${pageContext.request.contextPath}/" + handler + "/save.do", $("#serviceOrder").serialize()).
				done(function(){
					$( "#WaitMessage" ).dialog('close');
					$( "#OkMessage" ).dialog('open');
				}).
				fail(function(){
					$( "#WaitMessage" ).dialog('close');
					$( "#FailMessage" ).dialog('open');
				});
		}).
		fail(function(){
			// localSave for later send
			if(typeof(Storage) !== "undefined") {
			    // Code for localStorage/sessionStorage.
			    var osName = $("#serviceOrderNumber").val();
			    if(localStorage.blackstar_osIndex){
			    	localStorage.blackstar_osIndex = localStorage.blackstar_osIndex + ',' + osName;
			    }
			    else{
			    	localStorage.blackstar_osIndex = osName;
			    }
			    
			    localStorage.setItem("blackstarKey" + osName, osType)
			    localStorage.setItem("blackstarContent" + osName, $("#serviceOrder").serialize());

			    $( "#WaitMessage" ).dialog('close');
				$( "#OfflineSaveMessage" ).dialog('open');
			} else {
			    $( "#WaitMessage" ).dialog('close');
			    $( "#InvalidMessage" ).html("No fué posible conectar con el servidor y el dispositivo no soporta almacenamiento local, por favor espere a tener conexión e intente de nuevo");
				$( "#InvalidMessage" ).dialog('open');
			}
		});
	}


	function saveService(handler, validate){

		if(validate()){
			// enviando
			$( "#WaitMessage" ).dialog('open');
			saveIfConnected(handler);
		}
		else{
			$( "#InvalidMessage" ).dialog('open');
		}
	}
</script>