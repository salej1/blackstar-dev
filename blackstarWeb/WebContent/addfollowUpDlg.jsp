<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<script type="text/javascript">
	var addFollowUpId = 0;
	var addFollowUpType = "";
	var referer = ""
	var d = new Date(); 
			
	function initFollowUpDlg(type, sender) {		
		$("#seguimientoCaptureDlg").dialog({
			autoOpen: false,
			height: 400,
			width: 550,
			modal: true,
			buttons: {
				"Agregar": function() {
					applySeguimiento();
					$( this ).dialog( "close" );
				},							

				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});
		
		addFollowUpType = type;
		referer = sender;
	}

	// Seguimiento
	function applySeguimiento(){
		// enviar datos del formulario a servlet que agrega seguimiento
		$("#id").val(addFollowUpId);
		$("#type").val(addFollowUpType);
		$("#sender").val('${ user.userEmail }');
		$("#timeStamp").val(d.format('yyyy-MM-dd h:mm:ss'));
		$("#asignee").val($("#employeeSelect option:selected").val());
		$("#message").val($("#seguimientoText").val());
		$("#redirect").val(referer);
		$("#formAddFollowUp").submit();
	}
	
	function addSeguimiento(id, number){
		$("#seguimientoCaptureDlg").dialog('open');	
		$("#seguimientoCaptureDlg").dialog({ title: "Agregar seguimiento: " + number });
		$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss'));
		$("#seguimientoSender").html(' ${ user.userName }:');
		$("#seguimientoText").val();
		addFollowUpId = id;
	}

	function cancelAddSeguimiento(){
		$("#seguimientoCapture").hide();
	}

	Date.prototype.format = function(format) //author: meizz
	{
	  var o = {
		"M+" : this.getMonth()+1, //month
		"d+" : this.getDate(),    //day
		"h+" : this.getHours(),   //hour
		"m+" : this.getMinutes(), //minute
		"s+" : this.getSeconds(), //second
		"q+" : Math.floor((this.getMonth()+3)/3),  //quarter
		"S" : this.getMilliseconds() //millisecond
	  }

	  if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
		(this.getFullYear()+"").substr(4 - RegExp.$1.length));
	  for(var k in o)if(new RegExp("("+ k +")").test(format))
		format = format.replace(RegExp.$1,
		  RegExp.$1.length==1 ? o[k] :
			("00"+ o[k]).substr((""+ o[k]).length));
	  return format;
	}

</script>

<div id="seguimientoCaptureDlg" title="">
	<div>
		<Label id="seguimientoStamp" style="display:inline;">stamp</Label><Label id="seguimientoSender" style="display:inline;">: </Label>
	</div>
	<div> Asignar a:
		<select id="employeeSelect">
			<c:forEach var="employee" items="${employees}">
				<option value = "${employee.key}">${employee.value}</option>
			</c:forEach>
		</select>
		<p></p>
		<textarea id="seguimientoText" rows="10"cols="60"></textarea>
	</div>
	<form id = "formAddFollowUp" action="/addFollowUp" method="POST">
		<input id="id" name="id" type="hidden"/>
		<input id="type" name="type" type="hidden"/>
		<input id="sender" name="sender" type="hidden"/>
		<input id="timeStamp" name="timeStamp" type="hidden"/>
		<input id="asignee" name="asignee" type="hidden"/>
		<input id="message" name="message" type="hidden"/>
		<input id="redirect" name="redirect" type="hidden"/>
	</form>
</div>