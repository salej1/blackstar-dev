<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!-- Seccion de links que permiten crear nueva orden de servicio : INGENIEROS DE SERVICIO -->
<c:set var="sysServicio" scope="request" value="${user.belongsToGroup['Implementacion y Servicio']}" />
<c:if test="${sysServicio == true}">
	<div>
		<div>
			<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('X'); return false;">Crear Orden de Servicio</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('A'); return false;">Crear Reporte de Aire Acondicionado</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('B'); return false;">Crear Reporte de Baterias</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('P'); return false;">Crear Reporte de Planta de emergencia</a>
		</div>
		<div>
			<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('U'); return false;">Crear Reporte de UPS</a>
		</div>
		<p><small>&nbsp;</small></p>
	</div>
</c:if>
<!-- FIN - Seccion de links que permiten crear nueva orden de servicio : INGENIEROS DE SERVICIO -->

<!-- Seccion de links que permiten crear nueva orden de servicio : COORDINADOR -->
<c:set var="sysCoordinador" scope="request" value="${user.belongsToGroup['Coordinador']}" />
<c:if test="${sysCoordinador == true}">
	<div>
		<div>
			<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('T'); return false;">Crear Orden de Servicio</a>
		</div>
		<p><small>&nbsp;</small></p>
	</div>
</c:if>
<!-- FIN - Seccion de links que permiten crear nueva orden de servicio : COORDINADOR -->

<!-- Seccion de dialgo que se muestra para seleccionar el equipo -->
<script>
	var loadedType="";
    var selected = false;
	// Init
	function newOSLinks_init(){
		//Inicializacion del cuadro de dialogo para seleccionar el equipo
		$("#selectSNDialog").dialog({
			autoOpen: false,
			height: 290,
			width: 360,
			modal: true,
			buttons: {
				"Aceptar": function() {
					if(selected){
					  okChain("policy", loadedType);
					} else {
						$( this ).dialog( "close" );
					}
				},
				"Sin Poliza": function(){
					okChain("open", loadedType);
				},

				"Cancelar": function() {
					$( this ).dialog( "close" );
				}
			}
		});	

		$(".info").hide();
	}

	// Funcion que desencadena validacion-redireccion
	function okChain(captureType, equipmentType){
		validateSoInput(captureType, equipmentType);
	}

	// Funcion de validacion de entradas
	function validateSoInput(captureType, equipmentType){
		// Invocamos el json que indicara si la OS existe o no
		var needsSO = "${sysCoordinador}";
		if(needsSO == "true"){
			var soNumber = $("#soNumber").val();
			$.getJSON("/serviceOrders/checkSoExistance.do?soNumber=" + soNumber, function(data){
				if(data.exists == "true"){
					$("#invalidSo").show();
					$("#invalidSo").html("La orden de servicio " + soNumber + " ya existe");
					return false;
				}
				else{
					moveToCaptureScreen(captureType, equipmentType);
				}
			});
		}
		else{
			moveToCaptureScreen(captureType, equipmentType);
		}
	}

	// Funcion de redireccion a pagina de captura de OS especifica
	function moveToCaptureScreen(captureType, equipmentType){
		var urlTemplate = "";
		if(captureType == "policy"){
			urlTemplate = "PAGE/show.do?operation=3&idObject=SN&soNumber=SON";
			var eq = $("#eqSearch").val();
			urlTemplate = urlTemplate.replace("SN", eq);
		}
		 else{
			urlTemplate = "PAGE/show.do?operation=4&idObject=Open&soNumber=SON";
		}

		var soNum = $("#soNumber").val();
		if(captureType == "policy" && soNum == ""){
			return;
		}

		urlTemplate = urlTemplate.replace('SON', soNum);
		
		switch(equipmentType){
			case 'A': urlTemplate = urlTemplate.replace("PAGE", "/aircoService");
				break;
			case 'B': urlTemplate = urlTemplate.replace("PAGE", "/batteryService");
				break;
			case 'P': urlTemplate = urlTemplate.replace("PAGE", "/emergencyPlantService");
				break;
			case 'U': urlTemplate = urlTemplate.replace("PAGE", "/upsService");
				break;
			default: urlTemplate = urlTemplate.replace("PAGE", "/plainService");
				break;
		}

		window.location = urlTemplate;
	}

	// Funcion de recuperacion de la lista de equipos
	function showEquipmentSelect(type){
		getEquipmentList(type);
		
		var dlgTitle = "Orden de servicio para ";
		switch(type){
			case 'A': dlgTitle = dlgTitle + "Aire acondicionado";
				break;
			case 'B': dlgTitle = dlgTitle + "Baterias";
				break;
			case 'P': dlgTitle = dlgTitle + "Planta de emergencia";
				break;
			case 'U': dlgTitle = dlgTitle + "UPS";
				break;
			default: dlgTitle = dlgTitle + "equipo";
				break;
		}

		selected = false;
		$("#selectSNDialog").dialog('option', 'title', dlgTitle);
		$("#selectSNDialog").dialog('open');
	}

	// Estableciendo el origen para autocomplete
	function setEquipmentListSource(data){
		$("#eqSearch").autocomplete({
			minLength: 0,
			source: data,
			select: function( event, ui ) {
				$( "#eqSearch" ).val( ui.item.value );
				selected = true;
				return false;
			}
		});

		$("#eqSearch").removeAttr("disabled");
		$("#eqSearch").val("");
	}

	function getEquipmentList(type){
		var lookupType = type;
		if(type == 'B'){
			lookupType = 'U';
		}

		if(loadedType != type){
			$("#eqSearch").attr("disabled", "");
			$("#eqSearch").val("Cargando equipos...");
			$("#eqSearch").addClass("XX_REFRESH_CLASS");
			$("#eqSearch").removeClass("XX_REFRESH_CLASS");

			$.getJSON("/serviceOrders/getEquipmentByTypeJson.do?type=" + lookupType, function(data){
				setEquipmentListSource(data);
				loadedType = type;
			});
		}
		else{
			$("#eqSearch").removeAttr("disabled");
			$("#eqSearch").val("");
			$("#eqSearch").addClass("XX_REFRESH_CLASS");
			$("#eqSearch").removeClass("XX_REFRESH_CLASS");
		}
	}

</script>
<div id="selectSNDialog">
	<p>Escriba el numero de serie del equipo
	<input type="text" id="eqSearch" style="width:95%;"></p>
	<c:if test="${user.belongsToGroup['Coordinador']}">
		<p>Escriba el numero de folio del reporte
		<input type="text" id="soNumber" style="width:95%;" required></p>
	</c:if>
	<input type="hidden" id="selectedSerialNumber">
	<div id="invalidSo" class="info">
		La orden de servicio ya existe
	</div>
</div>

<!-- FIN - Seccion de dialgo que se muestra para seleccionar el equipo -->