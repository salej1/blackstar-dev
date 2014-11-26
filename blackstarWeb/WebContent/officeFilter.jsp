<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<script type="text/javascript" charset="utf-8">
	var officePref = "";
	// Filtrado inicial
	function officeFilter_init(){

		// se filtran las oficinas de acuerdo a la ultima preferencia del usuario
		officePref = $.cookie('blackstar_office_pref');
		if(officePref != null){
			$("#optOffices").val(officePref);
		}
	}

	// Refresh
	function refreshSoListByOffice(office){
		// tabla de OS nuevas
		if(typeof(newServiceOrders_filter) != "undefined"){
			newServiceOrders_filter(office);
		}

		// tabla de OS con pendientes
		if(typeof(pendingServiceOrders_filter) != "undefined"){
			pendingServiceOrders_filter(office);	
		}
			
		// historico de tickets
		if(typeof(serviceOrdersHistory_filter) != "undefined"){
			serviceOrdersHistory_filter(office);	
		}
		
		// se guarda la preferencia del usuario
		$.cookie('blackstar_office_pref', office, { expires: 365, path: "/" });
	}

</script>
<p>Oficina:
	<select id="optOffices" onchange="refreshSoListByOffice($(this).val());">
		<option value="">Todas</option>
		<c:forEach var="office" items="${offices}">
			<option value = "${office}">${office}</option>
		</c:forEach>					
	</select>
</p>