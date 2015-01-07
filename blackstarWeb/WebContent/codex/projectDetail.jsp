<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="clientDetail" />
<c:import url="../header.jsp"></c:import>
<html>
	<head>
	<title>Cédula de Proyecto</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen"/>
	<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common/popup.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/customAutocomplete.js"></script>
	
	<script type="text/javascript">
	    var entryNumber = 0;
	    var itemNumber = 0;
	    var totProducts = 0;
	    var totServices = 0;
	    var totDiscount = 0;
	    var priceList = $.parseJSON('${priceListJson}');
	    var productTypeMap = {};

    	<c:forEach var="pt" items="${entryTypes}">
		<c:out value='productTypeMap[${pt.id}] = "${pt.productType}";' escapeXml='false'/>
		</c:forEach>
	   

	    $(document).ready(function () {

			//Attachment dialog
			$("#attachmentDlg").dialog({
				autoOpen: false,
				height: 270,
				width: 420,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$.ajax({
					        type: "GET",
					        url: "addDeliverableTrace.do",
					        data: "projectId=${project.id}&deliverableTypeId=" + $("#attachmentType").val() + "&userId=${user.blackstarUserId}",
					        success: function(html) {
					        	$('#attachmentDlg').dialog( "close" );
					        	$("#fileTraceArea").load("${pageContext.request.contextPath}/codex/project/getDeliverables.do?projectId=${project.id}");
					        }
					    });
					}}
			});

			setButtonStatusText();
			
			// Bloqueo de campos
			if('${enableEdition}' == 'true')
			{
				$("#created").val(dateNow());				
			}
			else
			{
				$(".lockOnDetail").attr("readonly");
				$("select .lockOnDetail").attr("disabled", "true");
			}

			// Calc binding
			bindCalc();

			// paymentTypeId
			$("#paymentTypeId").bind('change', function(){
				if($("#paymentTypeId").val() == '1'){
					$("#creditInputLine").hide();
				}
				else{
					$("#creditInputLine").show();
				}
			});

			// init
			if("${project.paymentTypeId}" == "1"){
				$("#creditInputLine").hide();
			}
			else{
				$("#creditInputLine").show();
			}

			$("#warningMsg").dialog({
				autoOpen: false,
				height: 150,
				width: 320,
				modal: true,
				buttons: {
					"Aceptar": function() {
						$(this).dialog('close');
					}}
			});

			// Initial values set
			set("productsNumber", '${project.productsNumber}');
			set("servicesNumber", '${project.servicesNumber}');
			set("discountNumber", '${project.discountNumber}');
			set("totalProjectNumber", '${project.totalProjectNumber}');

			// Description dialog
			$("#descriptionDialog").dialog({
				autoOpen: false,
				height: 350,
				width: 550,
				modal: true,
				buttons: {
					"Aceptar": function() {
						bindDescription($("#getDescriptionNumber").val(), $("#descriptionCapture").val());
						$(this).dialog('close');
					},
					"Cancelar": function() {
						$(this).dialog('close');
					}}
			});

			// Comments dialog
			$("#commentsDialog").dialog({
				autoOpen: false,
				height: 350,
				width: 550,
				modal: true,
				buttons: {
					"Aceptar": function() {
						bindComments($("#getCommentsField").val(), $("#getCommentsNumber").val(), $("#commentsCapture").val());
						$(this).dialog('close');
					},
					"Cancelar": function() {
						$(this).dialog('close');
					}}
			});
	    });
	    
	    function warning(msg){
	    	$("#warningMsg").html(msg);
	    	$("#warningMsg").dialog("open");
	    }

	    function bindCalc(){
	    	$(".calc").unbind();
			$(".calc").bind("change", function(){
				calc();
			});
	    }

	    function setButtonStatusText(){
	      var projectStatus = '${project.statusId}';
		  if(projectStatus == '1'){
		  	if('${enableEdition}' == 'true'){
			  	$(".statusButton").html("Enviar a Autorización");
		  	}
		  	else{
		  		$(".statusButton").hide();
		  	}
		  } else if(projectStatus == '2'){
		  	if('${userCanAuth}' == 'true'){
			  	$(".statusButton").html("Autorizar");
		  	}
		  	else{
		  		$(".statusButton").hide();
		  	}
		  } else if(projectStatus == '3'){
		  	$(".statusButton").html("Enviar cotización");
		  } else if(projectStatus == '4'){
		  	$(".statusButton").html("Adjuntar orden de compra");
		  } else if(projectStatus == '5'){
		  	$(".statusButton").html("Adjuntar factura");
		  }
	    }
	    
	    function bindEntryProductType(entryNum, prodId){
	    	$("#productType_" + entryNum).val(productTypeMap[prodId]);
	    	if(prodId != ""){
	    		enableEntry(entryNum);
	    	}
	    }

	    function addEntry(){
	    	entryNumber++;
	    	$('#entryTable').append('\
	    		<tr class="part" id="entry_' + entryNumber + '" name="' + entryNumber + '"><td>' + entryNumber + '</td>\
		    		<td>\
		    			<select name="" id="entryTypeId_' + entryNumber + '" style="width:95%" required onchange="bindEntryProductType(' + entryNumber + ', this.value);">\
		    				<option value="">Seleccione</option>\
			    			<c:forEach var="ss" items="${entryTypes}">\
			    				<option value="${ss.id}">${ss.name}</option>\
			    			</c:forEach>\
			    		</select>\
		    		</td>\
		    		<td colspan="2"><a id="description_' + entryNumber + 'Display" class="total" href="#" onclick="getDescription(' + entryNumber + '); return false;"></a><input type="hidden" id="description_' + entryNumber + '"/></td>\
		    		<td><input type="text" id="qty_' + entryNumber + '" style="width:20px" class="calc" value="1"/></td> \
					<td><span class="total" id="unitPrice_' + entryNumber + 'Display"></span><input type="hidden" id="unitPrice_' + entryNumber + '"/></td>\
					<td><input type="text" id="discount_' + entryNumber + '" style="width:20px" class="calc" value="0" disabled/>%</td>\
		    		<td><span class="total" id="totalPrice_' + entryNumber + 'Display"></span><input type="hidden" id="totalPrice_' + entryNumber + '"/></td>\
		    		<td><a href="#" id="comments_' + entryNumber + 'Display" onclick="getComments(\'comments_\', ' + entryNumber + '); return false;"></a><input type="hidden" id="comments_' + entryNumber + '" /><hidden id="productType_' + entryNumber + '"/></td>\
	    		</tr>\
	    		<tr class="item_part' + entryNumber + '">\
	    			<td colspan="9"><table class="items" id="items_'+ entryNumber + '" style="width:100%"></table></td>\
	    		</tr>\
	    		<tr>\
	    			<td></td>\
	    			<c:if test="${enableEdition}"><td><button class="searchButton" onclick="addItem(' + entryNumber +');" id="addItemButton">+ Item</button></td></c:if>\
	    		</tr>');
			
			bindCalc();
			bindDescription(entryNumber, "");
			bindComments("comments_", entryNumber, "");
	    } 

	    function addItem(entryNumber){
	    	itemNumber++;
	    	$('#items_' + entryNumber).append('\
	    		<tr id="item_' + itemNumber + '" name="' + itemNumber + '">\
	    			<td style="width:45px" >\
	    				<c:if test="${enableEdition}"><button class="searchButton" onclick="removeItem(\'item_' + itemNumber +'\')" id="removeItemButton_' + itemNumber +'" >-</button></c:if>\
	    			</td>\
	    			<td><select onchange="setReferenceTypes(this.value, referenceId_' + itemNumber + ', reference_' + itemNumber + ', ' + itemNumber + ')" id="entryItemTypeId_' + itemNumber + '" style="width:110px" required>\
	    				<option value="">Seleccione</option>\
	    				<c:forEach var="ss" items="${entryItemTypes}"><option value="${ss.id}">${ss.name}</option>\
	    				</c:forEach></select>\
	    			</td>\
	    			<td  style="width:338px">\
	    				<input type="text" id="reference_' + itemNumber + '" style="width:95%" required disabled>\
	    				<input type="hidden" id="referenceId_' + itemNumber + '"/>\
	    			</td>\
	    			<td><input type="text" id="itemQuantity_' 	+ itemNumber + '" style="width:20px" required value="1" onchange="calcItem(' + itemNumber + ');" disabled/></td>\
	    			<td><input type="text" id="itemPriceByUnit_'+ itemNumber + '" style="width:45px" required onchange="calcItem(' + itemNumber + ');" disabled/></td>\
	    			<td><input type="text" id="itemDiscount_' 	+ itemNumber + '" style="width:25px" required value="0" onchange="calcItem(' + itemNumber + ');" disabled/>%</td>\
	    				<input type="hidden" id="itemDiscountNum_' + itemNumber + '"/>\
	    			<td style="width:110px"><input type="text" id="itemTotalPrice_' + itemNumber + '" style="width:95%" required readonly disabled/></td>\
	    			<td style="width:65px"><a href="#" id="itemComments_' + entryNumber + 'Display" onclick="getComments(\'itemComments_\', ' + entryNumber + '); return false;"></a><input type="hidden" id="itemComments_' 	+ itemNumber + '"/></td>\
	    		</tr>');

	    	bindCalc();
			bindComments("itemComments_", entryNumber, "");
	    }
	    
	    function removeItem(itemId){
	    	$('#' + itemId).remove();
	    }
	    
	    function customPickerCallBack(data) {
			$("#attachmentFileName").val(data.docs[0].name);
			$('#attachmentDlg').dialog('open');
		}
	    
	    function prepareSubmit(){
	     	var entries = $( "tr.part" );
	     	var strEntries = '';
	     	var entryId, itemId;
	     	var items;
	     	var itemReference;
	     	var description;
	     	var itemTypeId;

	     	for(var i = 0; i < entries.length ; i++){
	     		entryId = entries[i].id.substring(6);
	     		strEntries += $("#entryTypeId_" + entryId).val()
	     		              + "|"  + $("#description_" + entryId).val()
	     		              + "|"  + $("#qty_" + entryId).val()
	     		              + "|"  + $("#unitPrice_" + entryId).val()
	     		              + "|"  + $("#discount_" + entryId).val()
	     		              + "|"  + $("#totalPrice_" + entryId).val()
	     		              + "|"  + $("#comments_" + entryId).val()
	     		              + "|"  + entryId
	     		              + "|";
	     		items = $("#" + entries[i].id).next().find("table.items tr");
	     		for(var j = 0; j < items.length ; j++){
	     			itemId = items[j].id.substring(5);
	     			itemTypeId = $("#entryItemTypeId_" + itemId).val();
	     			if(itemTypeId == 1 || itemTypeId == 2){
	     				itemReference = $("#referenceId_" + itemId).val();
	     				description = $("#reference_" + itemId).val();
	     			} else {
	     				itemReference = $("#reference_" + itemId).val();
	     				description = $("#reference_" + itemId).val();
	     			}
	     			strEntries += $("#entryItemTypeId_" + itemId).val()
	     			           +  "°" + itemReference
	     			           +  "°" + description
	     			           +  "°" + $("#itemQuantity_" + itemId).val()
	     			           +  "°" + $("#itemPriceByUnit_" + itemId).val()
	     			           +  "°" + $("#itemDiscount_" + itemId).val()
	     			           +  "°" + $("#itemTotalPrice_" + itemId).val()
	     			           +  "°" + $("#itemComments_" + itemId).val()
	     			           +  "°" + itemId
	     			           +  "^";
	     		}
	     		strEntries += "~";
	     	}
	     	$("#strEntries").val(strEntries);
	     	console.log(strEntries);
	     	
	    }
	    
	    function validate(){
	    	var entries = $( "tr.part" );
	    	var items;

	    	// Cliente
	    	if($("#clientId").val() == ""){
	    		warning ("Favor de seleccionar el cliente");
	    		return false;
	    	}

	    	// Cliente
	    	if($("#contactName").val() == ""){
	    		warning ("Favor de seleccionar nombre del contacto");
	    		return false;
	    	}

			// Plazo finiquito
	    	if($("#settlementTimeLimit").val() == ""){
	    		warning ("Favor de ingresar el plazo para finiquito");
	    		return false;
	    	}

	    	// Plazo finiquito
	    	if($("#deliveryTime").val() == ""){
	    		warning ("Favor de tiempo de entrega");
	    		return false;
	    	}

	    	if(entries.length == 0){
	    		warning ("Favor de ingresar al menos una partida");
	    		return false;
	    	}
	    	for(var i = 0; i < entries.length ; i++){
	    		items = $("#" + entries[i].id).next().find("table.items tr");
	    		if(items.length == 0){
	    			warning ("Favor de ingresar al menos un Item para cada partida");
	    			return false;
	    		}
	    	}
	    	return true;
	    }
	    
	    function commit(){
	      var isUpdate = '${isUpdate}';
	      if(validate()){
	    	prepareSubmit();
	    	if(isUpdate == 'true'){
	    	  $('#mainForm').attr('action', '/codex/project/update.do');
	    	}
	    	$("#mainForm").submit();
	      }
	    }
	    
	    function setReferenceTypes(value, idsFld, descFld, itemNumber){
	    	enableItem(itemNumber);

	    	var idsFldId = idsFld.id;
	    	var descFldId = descFld.id;
	    	if(idsFldId == undefined){
	    		idsFldId = idsFld.attr('id');
	    	}
	    	if(descFldId == undefined){
	    		descFldId = descFld.attr('id');
	    	}
	    	if(value == 1 || value == 2){
	    		$.ajax({
				       url: "${pageContext.request.contextPath}/codex/project/getReferenceTypes.do?itemTypeId=" + value,
				       type: 'get',
                       dataType: 'json',
                       async:false,
				       success: function(data){
				       		$("#" + descFldId).val("");
				       		$("#" + idsFldId).val("");
				       		$("#itemPriceByUnit_" + itemNumber).val("");
					         init_autoComplete(data, descFldId, idsFldId, "single", function(refId){
					         	if(value == 1){
					         		setPrice(itemNumber, refId);					         		
					         	}
					         });
                       } 
				});
	    	}
	    	if(value == 1){
				$("#itemPriceByUnit_" + itemNumber).attr("readonly", "");
	    	}
	    	else{
				$("#itemPriceByUnit_" + itemNumber).removeAttr("readonly");
	    	}
	    }

	    function advanceStatus(){
			var isUpdate = '${isUpdate}';
			var target = '';

			if(isUpdate == 'true'){
				target = '/codex/project/update.do';
			}
			else{
				target = "/codex/project/insert.do";
			}
			if(validate()){
				prepareSubmit();
				$.ajax({
				  type: "POST",
				  url: target,
				  data: $("#mainForm").serialize()
				}).done(function(){
			      $('#mainForm').attr('action', '/codex/project/advanceStatus.do?projectId=' +  $("#projectId").val());
			      $("#mainForm").submit();
				});
			}
	    }

	    function fallBackStatus(){
	      $('#mainForm').attr('action', '/codex/project/fallbackStatus.do?projectId=' +  $("#projectId").val());
	      $("#mainForm").submit();
	    }

	    function calcItem(itemNumber){
	    	var rawQty = $("#itemQuantity_" + itemNumber).val();
	    	var rawPrice = $("#itemPriceByUnit_" + itemNumber).val();
	    	var rawDiscount = $("#itemDiscount_" + itemNumber).val();
	    	if(isNaN(rawQty) || isNaN(rawPrice) || isNaN(rawDiscount)){
	    		warning("Por favor verifique las cantidades");
	    	}
	    	else{
	    		var qty = Number(rawQty);
	    		var price = Number(rawPrice);
	    		var discount = Number(rawDiscount);

	    		var tot = (qty * price);
	    		var rawTot = tot;

	    		tot = tot * ((100 - discount)/100);
	    		var discountNum = rawTot - tot;
	    		$("#itemDiscountNum_" + itemNumber).val(discountNum);

	    		$("#itemTotalPrice_" + itemNumber).val(tot);
	    	}

	    	calc();
	    }

	    function set(fieldName, value){
	    	$("#" + fieldName + "Display").html(toCurrency(value));
	    	$("#" + fieldName).val(value);
	    }

	    function calcEntry(entryNumber){
	    	var entryTotPrice = 0;
	    	var entryUnitPrice = 0;

	    	$("input[id^='itemTotalPrice_']", "table#items_" + entryNumber).each(function(index, value){
	    		entryUnitPrice = entryUnitPrice + Number($(value).val());
	    	});

	    	$("input[id^='itemDiscountNum_']", "table#items_" + entryNumber).each(function(index, value){
	    		totDiscount = totDiscount + Number($(value).val());
	    	});

	    	// calcular precio total de la partida
	    	var qty = Number($("#qty_" + entryNumber).val());
	    	entryTotPrice = qty * entryUnitPrice;

	    	// aplicar descuento por partida
	    	var discount = 0;
	    	var rawEntryPrice = entryTotPrice;

	    	discount = Number($("#discount_" + entryNumber).val());
	    	entryTotPrice = ((100 - discount)/100) * entryTotPrice;
	    	totDiscount = totDiscount + (rawEntryPrice * (discount)/100);

	    	set("discountNumber", totDiscount);

	    	// sumarizar partidas de productos y servicios
	    	if($("#productType_" + entryNumber).val() == 'S'){
	    		totServices = totServices + entryTotPrice;
	    	}
	    	else{
	    		totProducts = totProducts + entryTotPrice;
	    	}

    		set("productsNumber", totProducts);
    		set("servicesNumber", totServices);
    		set("unitPrice_" + entryNumber, entryUnitPrice)
    		set("totalPrice_" + entryNumber, entryTotPrice)
	    }

	    function distributeFine(entryNumber, fine, total){
	    	var entryTotal = Number($("#totalPrice_" + entryNumber).val());
	    	var entryPart = (entryTotal / (total - fine)) * fine;
	    	entryTotal = entryTotal + entryPart;
	    	if($("#productType_" + entryNumber).val() == 'S'){
	    		totServices = totServices + entryPart;
	    	}
	    	else{
	    		totProducts = totProducts + entryPart;
	    	}

    		set("productsNumber", totProducts);
    		set("servicesNumber", totServices);
    		set("totalPrice_" + entryNumber, entryTotal)

    		// unit price
    		var qty = Number($("#qty_" + entryNumber).val());
    		var unitPart = entryPart / qty;
    		var unitPrice = Number($("#unitPrice_" + entryNumber).val());
    		unitPrice = unitPrice + unitPart;
    		set("unitPrice_" + entryNumber, unitPrice);
	    }

	    function calc(){
	    	totProducts = 0;
	    	totServices = 0;
	    	totDiscount = 0;

	    	// sumarizar items por partida
	    	for(entryNum = 1; entryNum <= entryNumber; entryNum ++){
	    		calcEntry(entryNum);
	    	}

	    	// fianza
	    	var projectFine = 0;
	    	if(!isNaN($("#financesNumber").val())){
	    		projectFine = Number($("#financesNumber").val());
	    	}

	    	// total del proyecto
	    	var projectTotal = totServices + totProducts + projectFine;
	    	set("totalProjectNumber", projectTotal);

	    	// aplicacion de la fianza
	    	for(entryNum = 1; entryNum <= entryNumber; entryNum ++){
	    		distributeFine(entryNum, projectFine, projectTotal);
	    	}
	    }

	    function setPrice(itemNumber, priceId){
	    	var myPrice = getPrice(priceId);

	    	$("#itemPriceByUnit_" + itemNumber).val(myPrice);

	    	calcItem(itemNumber);
	    }

	    function getPrice(itemId){

	    	for(var item in priceList){
	    		if(priceList[item].id == itemId){
	    			return priceList[item].price;
	    		}
	    	}

	    	return 0;
	    }
	    
	    function updateDeliveryTime(weeks){
	    	$('#deliveryTime').val(Number(weeks) * 7);
	    }

	    function toCurrency(n) {
	    	var amount = Number(0.00);
	    	if(n == "" || isNaN(n)){
	    		return "$ 0.00";
	    	}
	    	else{
	    		amount = Number(n);
		   		return "$ " + amount.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
	    	}
		}

		function enableEntry(entryNumber){
			$("#description_" + entryNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS").attr("required");
			$("#discount_" + entryNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#comments_" + entryNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#description_" + entryNumber).focus();
		}

		function enableItem(itemNumber){
			$("#reference_" + itemNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#itemQuantity_" + itemNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#itemPriceByUnit_" + itemNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#itemDiscount_" + itemNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#itemTotalPrice_" + itemNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
			$("#itemComments_" + itemNumber).removeAttr("disabled").addClass("DUMMY_CLASS").removeClass("DUMMY_CLASS");
		}

		function bindDescription(entryNumber, description){
			$("#description_" + entryNumber + "Display").removeAttr("title");
			if(description == ""){
				$("#description_" + entryNumber + "Display").html("Click para agregar descripcion...");
				$("#description_" + entryNumber + "Display").attr("title", "Haga click sobre el link para agregar la descripción de la partida");
			}
			else{
				if(description.length > 60){
					var shortDesc = description.substring(0,60) + "...";
					$("#description_" + entryNumber + "Display").html(shortDesc);
				}
				else{
					$("#description_" + entryNumber + "Display").html(description);
				}
				$("#description_" + entryNumber + "Display").attr("title", description);
			}
			$("#description_" + entryNumber).val(description);
		}

		function getDescription(entryNumber){
			$("#getDescriptionNumber").val(entryNumber);
			$("#descriptionCapture").val($("#description_" + entryNumber).val());
			$("#descriptionDialog").dialog('open');
		}

		function bindComments(field, number, comments){
			// field = comments_ OR itemComments_
			var id = "#" + field + number;
			$(id + "Display").removeAttr("title");
			if(comments == ""){
				if('${enableEdition}' == 'true'){
					$(id + "Display").html("Agregar...");
					$(id + "Display").attr("title", "Haga click sobre el link para agregar comentarios");
				}
			}
			else{
				$(id + "Display").html(comments.substring(0,10) + "...");
				$(id + "Display").attr("title", comments);
			}
			$(id).val(comments);
		}

		function getComments(field, number){
			$("#getCommentsNumber").val(number);
			$("#getCommentsField").val(field);
			$("#commentsCapture").val($("#" + field + number).val());
			$("#commentsDialog").dialog('open');
		}
	</script>
	
<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_16">					
					<div class="box">
						<h2>Cedula de proyectos</h2>				
						<div>
							<p></p>							
							<button class="searchButton statusButton" onclick="advanceStatus();"></button>
							<c:if test="${enableEdition}">
								<button class="searchButton" onclick="commit();">Guardar</button>
								<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							</c:if>
							<c:if test="${!enableEdition}">
								<button class="searchButton" onclick="fallBackStatus();">Editar</button>
							</c:if>
							<button class="searchButton" onclick="window.history.back();">Descartar</button>
							<hr>
						</div>		
<!--   ENCABEZADO CEDULA   -->			
                        <form:form  id="mainForm" commandName="project" action="/codex/project/insert.do">
                           <table>
							  <tr>
								<td  style="width:140px">No. Cedula</td>
								<td><form:input type="text" path="projectNumber" style="width:100%" class="lockOnDetail"/></td>
								<td style="width:120px">Estatus</td>
								<td><form:input type="text" path="statusDescription" readOnly="true" style="width:95%"/></td>
							  </tr>
							  <tr>
								<td>Cliente</td>
								<td colspan="4"><form:select name="" id="clientId" path="clientId" style="width:100%" required="true" >
								            <option value="">Seleccione</option>
											<c:forEach var="ss" items="${clients}">
												<option value="${ss.id}"
												<c:if test="${ss.id == project.clientId}">
													selected="true"
												</c:if>
												>${ss.corporateName}</option>
											</c:forEach>
											
										</form:select>
							  <tr>
							  </tr>
								<td>Proyecto:</td>
								<td>
									<form:input type="text" path="costCenter" style="width:100%" class="lockOnDetail" required="true"/>
								</td>
							  </tr>
							  <tr>
								<td>Tipo de cambio:</td>
								<td><form:input type="text" id="changeType" path="changeType" style="width:100%" class="lockOnDetail" maxlength="5" required="true"/></td>
								<td>Fecha:</td>
								<td><form:input type="text" id="created" path="created" style="width:95%" readOnly="true" required="true"/></td>
							  <tr>
								<td>Nombre del Contacto:</td>
								<td><form:input type="text" id="contactName" path="contactName"  style="width:100%" class="lockOnDetail" required="true"/></td>
							  </tr>
							  <tr>
								<td>Ubicación(es) del Proyecto:</td>
								<td><form:input type="text" id="location" path="location"  style="width:100%" class="lockOnDetail" required="true"/></td>
								<td>Forma de pago:</td>
								<td><form:select name="" id="paymentTypeId" path="paymentTypeId" style="width:95%" class="lockOnDetail" required="true">
											<c:forEach var="ss" items="${paymentTypes}">
												<option value="${ss.id}"
												<c:if test="${ss.id == project.paymentTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
											
										</form:select>
							  </tr>
							  <tr id="creditInputLine">
								<td>Condiciones de pago:</td>
								<td><form:textarea path="paymentConditions" style="width:100%" class="lockOnDetail" rows="4" /></td>
							  </tr>
							 <tr>
								<td>Moneda:</td>
								<td><form:select name="" id="currencyTypeId" path="currencyTypeId" style="width:100%" class="lockOnDetail" required="true">
											<c:forEach var="ss" items="${currencyTypes}">
												<option value="${ss.id}"
												<c:if test="${ss.id == project.currencyTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
											
										</form:select></td>
								<td>IVA:</td>
								<td><form:select name="" id="taxesTypeId" path="taxesTypeId" style="width:100%" class="lockOnDetail" >
											<c:forEach var="ss" items="${taxesTypes}">
												<option value="${ss.id}"
												<c:if test="${ss.id == project.taxesTypeId}">
													selected="true"
												</c:if>
												>${ss.name}</option>
											</c:forEach>
											
										</form:select></td>
							  </tr>
							  <tr>
								<td>Tiempo de entrega:</td>
								<td>
									<form:input type="text" path="deliveryTimeDisplay" style="width:65%" class="lockOnDetail" maxlength="3" onchange="updateDeliveryTime(this.value);" required="true"/> Semanas
									<form:hidden path="deliveryTime"/>
								</td>
								<td>Incoterm:</td>
								<td><form:select items="${incotermList}" path="incoterm" style="width:100%" class="lockOnDetail" required="true"/></td>
							  </tr>
							  <tr>
								<td>TOTAL DE PRODUCTOS</td>
								<td>
									<form:input type="hidden" path="productsNumber"/>
									<span class="total" id="productsNumberDisplay"></span>
								</td>
								<td>FIANZA(S)</td>
								<td><form:input type="text" path="financesNumber" style="width:95%" class="calc" title="Monto de fianza = Monto del proyecto * % a afianzar * 2.0 % * numero de años * numero de fianzas. Si es < $ 4,000.00 fianza es $ 4,000.00"/></td>
							  </tr>
							  <tr>
								<td>TOTAL DE SERVICIOS</td>
								<td>
									<form:input type="hidden" path="servicesNumber" style="width:100%" readOnly="true"/>
									<span class="total" id="servicesNumberDisplay"></span>
								</td>
								<td>TOTAL DESCUENTO</td>
								<td>
									<form:input type="hidden" path="discountNumber" style="width:95%" readOnly="true"/>
									<span class="total" id="discountNumberDisplay"></span>
								</td>
							  </tr>
							  <tr>
								<td>TOTAL DEL PROYECTO</td>
								<td>
									<form:input type="hidden" path="totalProjectNumber" style="width:100%" readOnly="true"/>
									<span class="total" id="totalProjectNumberDisplay"></span>
								</td>
							  </tr>
						   </table>
						   <form:input type="hidden" path="strEntries"/>
						   <form:input type="hidden" path="statusId"/>
						   <form:input type="hidden" path="id" id="projectId"/>
						   <form:input type="hidden" path="cstName"/>
						   <form:input type="hidden" path="cstPhone"/>
						   <form:input type="hidden" path="cstPhoneExt"/>
						   <form:input type="hidden" path="cstMobile"/>
						   <form:input type="hidden" path="cstEmail"/>
						   <form:input type="hidden" path="cstAutoAuth"/>
						   
                       </form:form>
						
<!--   ~ ENCABEZADO CEDULA   -->

			
<!--   PARTIDAS   -->	
						<hr>
						<p></p>
						<table id="entryTable">
							<thead>
								<tr>
									<th style="width:5px;">Part.</th>
									<th style="width:80px;">Tipo</th>
									<th style="width:220px;">Referencia</th>
									<th style="width:210px;">Descripcion</th>
									<th style="width:15px;">Cant.</th>
									<th style="width:90px;">P. Unt.</th>
									<th style="width:50px;">Descto.</th>
									<th style="width:100px;">P. Tot.</th>
									<th>Observaciones</th>
								</tr>
							</thead>
							<tbody>
							   <c:forEach var="entry" items="${project.entries}" varStatus="index">
							      <script type="text/javascript">
                                       addEntry();
                                       enableEntry(entryNumber);
                                       $("#entryTypeId_" + entryNumber).val('${entry.entryTypeId}');
                                       bindDescription(entryNumber, '${entry.description}');
                 	     		       $("#qty_" + entryNumber).val(${entry.qty});
                 	     		       set("unitPrice_" + entryNumber, ${entry.unitPrice});
                 	     		       $("#discount_" + entryNumber).val('${entry.discount}');
                 	     		       set("totalPrice_" + entryNumber, ${entry.totalPrice});
                 	     		       bindComments("comments_", entryNumber, "${entry.comments}");
                 	     		       if('${enableEdition}' == 'false'){
                 	     		    	 $("#entryTypeId_" + entryNumber).prop( "disabled", true );
                   	     		         $("#qty_" + entryNumber).prop( "disabled", true );
                   	     		         $("#description_" + entryNumber).prop( "disabled", true );
                   	     		         $("#unitPrice_" + entryNumber).prop( "disabled", true );
                   	     		         $("#discount_" + entryNumber).prop( "disabled", true );
                   	     		         $("#totalPrice_" + entryNumber).prop( "disabled", true );
                 	     		       }
                                  </script>
                                   <c:forEach var="item" items="${entry.items}" varStatus="index1">
                                           <script type="text/javascript">
                                                 addItem(entryNumber);
                                                 enableItem(itemNumber);
                                                 $("#entryItemTypeId_" + itemNumber).val('${item.itemTypeId}');
                                                 $("#referenceId_" + itemNumber).val('${item.reference}');
                  	     			             $("#reference_" + itemNumber).val('${item.description}');
                  	     			             $("#itemQuantity_" + itemNumber).val('${item.quantity}');
                  	     			             $("#itemPriceByUnit_" + itemNumber).val('${item.priceByUnit}');
                  	     			             $("#itemDiscount_" + itemNumber).val('${item.discount}');
                  	     			             $("#itemTotalPrice_" + itemNumber).val('${item.totalPrice}');
                  	     			             bindComments("itemComments_", itemNumber, "${item.comments}");
                  	     			             if('${enableEdition}' == 'false'){
                  	     			            	$("#entryItemTypeId_" + itemNumber).prop( "disabled", true );
                  	     			            	$("#reference_" + itemNumber).prop( "disabled", true );
                  	     			            	$("#referenceId_" + itemNumber).prop( "disabled", true );
                  	     			            	$("#itemDescription_" + itemNumber).prop( "disabled", true );
                     	     			            $("#itemQuantity_" + itemNumber).prop( "disabled", true );
                     	     			            $("#itemPriceByUnit_" + itemNumber).prop( "disabled", true );
                     	     			            $("#itemDiscount_" + itemNumber).prop( "disabled", true );
                     	     			            $("#itemTotalPrice_" + itemNumber).prop( "disabled", true );
                  	     			             }
                                            </script>
                                   </c:forEach>
                              </c:forEach>
							</tbody>
						</table>
						<c:if test="${enableEdition}">
						   <div>
							  <button class="searchButton" onclick="addEntry();">+ Partida</button>
						   </div>
						</c:if>
<!--   ~PARTIDAS   -->		

                         <c:if test="${not enableEdition}">
                         
<!--   SEGUIMIENTO   -->		
						<br /><br />		
						<c:import url="_followTable.jsp"></c:import>
<!--   ~ SEGUIMIENTO   -->		

<!-- ADJUNTOS -->
						<br><br>		
                            <div id="fileTraceArea">
                               <c:import url="/codex/_fileTraceTable.jsp"></c:import>
                            </div>
							<c:import url="/_attachments.jsp"></c:import>
						</c:if>
<!-- ~ ADJUNTOS -->

<!--   BOTONES    -->
						<div>
							<hr>
							<button class="searchButton statusButton" onclick="advanceStatus();"></button>
							<c:if test="${enableEdition}">
								<button class="searchButton" onclick="commit();">Guardar</button>
								<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							</c:if>
							<c:if test="${!enableEdition}">
								<button class="searchButton" onclick="fallBackStatus();">Editar</button>
							</c:if>
							<button class="searchButton" onclick="window.history.back();">Descartar</button>
						</div>
					</div>					
				</div>
				 
                 <!-- Attachment Img section -->
				<div id="attachmentDlg" title="Referencia">
					<p></p>
					<p>Tipo de archivo</p>
					<input id="attachmentFileName" size="80" readOnly="true"/> 
					<select id="attachmentType" style="width:200px;">
					   <option value="-1">Sin referencia</option>
					     <c:forEach var="current" items="${deliverableTypes}" >
					        <option value="${current.id}">${current.name}</option>
					     </c:forEach>
					</select>

				</div>		

				<div id="warningMsg" title="Advertencia">
					
				</div>

				<div id="descriptionDialog" title="Descripción del producto o servicio:">
					Descripción:
					<input type="hidden" id="getDescriptionNumber">
					<textarea name="" id="descriptionCapture" style="margin-top:15px;width:95%" rows="10" class="lockOnDetail"
					<c:if test="${enableEdition == false}">
						disabled
					</c:if>
					></textarea>
				</div>

				<div id="commentsDialog" title="Observaciones:">
					Observaciones:
					<input type="hidden" id="getCommentsNumber">
					<input type="hidden" id="getCommentsField">
					<textarea name="" id="commentsCapture" style="margin-top:15px;width:95%" rows="10" class="lockOnDetail"
					<c:if test="${enableEdition == false}">
						disabled
					</c:if>
					></textarea>
				</div>
								
<!--   ~ CONTENT COLUMN   -->

				<script type="text/javascript">
					$(document).ready(function () {
						$("#fecha").val(new Date().format("yyyy-MM-dd"));
						//$("#fecha").datepicker({ dateFormat: 'yy-mm-dd' });
					});
				</script>

<!--   ~ CONTENT   -->
			</div>
			
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
<!--   ~ FOOTER   -->
	</body>
</html>