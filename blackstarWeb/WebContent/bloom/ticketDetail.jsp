<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
<c:import url="/header.jsp"></c:import>
<html>
<head>
	<script type="text/javascript">
			glow.ready(function(){
				new glow.widgets.Sortable(
					'#content .grid_5, #content .grid_6',
					{
						draggableOptions : {
							handle : 'h2'
						}
					}
				);
			});
		</script>
		<!--[if IE]><![endif]><![endif]-->
	</head>
	<body>
<script type="text/javascript">

  var followType;
  
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
};

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
			        data: "ticketId=${ticketDetail.id}&deliverableTypeId=" + $("#attachmentType").val(),
			        success: function(html) {
			        	$('#attachmentDlg').dialog( "close" );
			        }
			    });
			}}
	});
	
	//Save confirm dialog
	$("#saveConfirm").dialog({
		autoOpen: false,
		height: 250,
		width: 380,
		modal: true,
		buttons: {
				"Aceptar": function() {
					window.location.href = 'close.do?ticketId=${ticketDetail.id}&userId=${ user.blackstarUserId }';
				}
					,
			
			"Cancelar": function() {
			$( this ).dialog( "close" );
		}}
	});
	
	//History dialog
	$("#historyDlg").dialog({
		autoOpen: false,
		height: 380,
		width: 500,
		modal: true,
		buttons: {
			"Cerrar": function() {
				$( this ).dialog( "close" );
		}}
	});

	// Seguimiento$("#seguimientoCapture").hide();
	$("#seguimientoCapture").hide();
});


function addSeguimiento(type){
	var d = new Date(); 
	$("#seguimientoCapture").show();	
	$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' ${ user.userName }');
	$("#seguimientoText").val('');
	$("#who").val("-1");
	followType = type;
	if(type == "1"){
		$("#assignamentArea").show();
	} else {
		$("#assignamentArea").hide(); 
	}
}

function applySeguimiento(){
	var who;
	if(followType == "1"){
		who = $("#who").val();
	} else if(followType == "2"){
		who = "-2";
	}else { 
		who = "-3";
	}
	
	$("#followDetail").load("${pageContext.request.contextPath}/bloom/ticketDetail/addFollow.do?ticketId=${ticketDetail.id}&userId=${ user.blackstarUserId }" 
			                    + "&userToAssign=" + who + "&comment=" + $("#seguimientoText").val().replace(/ /g, '%20'));
	$("#seguimientoCapture").hide();	
}

function cancelAddSeguimiento(){
	$("#seguimientoCapture").hide();
}


  function customPickerCallBack(data) {
	$("#attachmentFileName").val(data.docs[0].name);
    $('#attachmentDlg').dialog('open');
  }

</script>
<!--   CONTENT   -->
			<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->			
				<div class="grid_15">					
					<div class="box">
						<h2>Ticket interno</h2>
						<div class="utils">
					
						</div>
						<table>
							<tr>
								<td>Folio:</td>
								<td colspan="3" style="width:200px;"><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${ticketDetail.ticketNumber}"/></td>
								<td>Marca temporal:</td>
								<td><input type="text" id="fldFolio" style="width:95%;" readOnly="true" value="${ticketDetail.created}"/></td>
							</tr>
							<tr>
								<td>Usuario</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.applicantUserName}"/></td>
								<td>Solicitante</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.applicantAreaName}"/></td>
							</tr>
							<tr>
								<td>Tipo</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.serviceTypeName}"/></td>
								<td>Fecha Limite</td>
								<td><input id="myDate" type="text" style="width:95%;" readOnly="true" value="${ticketDetail.dueDate}"/></td>
							</tr>
							<tr>
								<td>Descripcion de la solicitud</td>
								<td colspan="6">										
									<textarea id="fldSitEnc" style="width:100%;height:100%;" rows="15">${ticketDetail.description}</textarea>
								</td>
							</tr>
							<tr>
								<td>Proyecto</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.project}"/></td>
								<td>Oficina</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.officeName}"/></td>
								<!-- <td></td> -->
							</tr>
							<tr>
								<td>Persona asignada
								</td>
								<td colspan="7">
								    <input type="text" style="width:95%;" readOnly="true"
                                             <c:forEach var="current" items="${ticketTeam}">
												    <c:if test="${current.workerRoleTypeId == 1}">
													  value="${current.blackstarUserName}"
												    </c:if>
												  </c:forEach>
                                     />
								 </td>
							</tr>
							<tr>
								<td>Fecha y hora de respuesa</td>
								<td colspan="3"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.responseDate}"/></td>
								<td>Desv. fecha solicitada</td>
								<td><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.desviation}"/></td>
							</tr>		
							<tr>
								<td>Entrega a tiempo?</td>
								<td><input type="checkbox" style="width:95%;" readOnly="true" checked="${ticketDetail.reponseInTime}"/></td>
							</tr>		
							<tr>
								<td>Calificacion interna</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.evaluation}"/></td>
							</tr>
							<tr>
								<td>Estatus</td>
								<td colspan="5"><input type="text" style="width:95%;" readOnly="true" value="${ticketDetail.statusName}"/></td>
							</tr>

						</table>
					</div>					
				</div>
				
<!--   ~ CONTENT COLUMN   -->

<!--   CONTENT COLUMN   -->				
				
				<div class="grid_15">
					<div class="box">
						<h2>Seguimiento</h2>
							<table id="seguimientoTable">
								<thead>
									<th>Seguimiento</th>
								</thead>
									<tr>
										<td id="seguimientoContent">
										</td>
									</tr>
									<tr>
									    <td id="followDetail">
									       <c:import url="_ticketFollow.jsp"></c:import>
									    </td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label>
											</div>
											<div> 
											   <div id="assignamentArea">
											     Asignar a:
												  <select id="who" style="width:200px;">
												    <option value="-1">Seleccione</option>
												    <c:forEach var="current" items="${staff}" >
												       <option value="${current.id}">${current.name}</option>
												    </c:forEach>
												  </select>
												<p></p>
												</div>
												<textarea id="seguimientoText" rows="5" style="width:65%;"></textarea>
												<button class="searchButton" onclick="applySeguimiento();">Agregar</button>
												<button class="searchButton" onclick="cancelAddSeguimiento();">Cancelar</button>
											</div>
										</td>
									</tr>
							</table>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="addSeguimiento(1);">Asignar</button>
										</td>
										<td>
											<button class="searchButton" onclick="addSeguimiento(3);">Responder</button>
										</td>
										<td>
											<button class="searchButton" onclick="addSeguimiento(2);">Comentar</button>
										</td>
									</tr>
								<tbody>
							</table>
							<!-- Adjuntos -->
							<table id="fileTraceTable">
								<thead>
									<th colspan="2">Archivos Requeridos</th>
								</thead>
								    <c:forEach var="current" items="${deliverables}" >
									  <tr>
									    <td  style="width:5%;">
		                                  <c:choose>
											<c:when test="${current.delivered}">
												<img src='${pageContext.request.contextPath}/img/delivered.png'/>
											</c:when>
											<c:otherwise>
												<img src='${pageContext.request.contextPath}/img/notDelivered.png'/>
											</c:otherwise>
										  </c:choose>
												    
										  
										</td>
										<td align="left">
										  ${current.name}
										</td>
									  </tr>
									  </c:forEach>
							</table>
							
							<c:import url="/_attachments.jsp"></c:import>
							<table>
								<tbody>
									<tr>
										<td>
											<button class="searchButton" onclick="$('#saveConfirm').dialog('open');">Resolver Ticket</button>
										</td>
									</tr>
								<tbody>
							</table>
					</div>					
				</div>				
<!--   ~ CONTENT COLUMN   -->
				
				
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
				
				<div id="saveConfirm" title="Cerrar Ticket ${ticketDetail.ticketNumber}">
					<p>¿Confirma que desea cerrar las acciones pendientes en el ticket ${ticketDetail.ticketNumber}?</p>
					<p>El ticket será asignado al personal de mesa de ayuda para su revision</p>
				</div>
				
<!--   ~ CONTENT   -->
			</div>
			
<!--   FOOTER   -->			
		<div id="foot">
			<a href="#">Soporte</a>
		</div>
</body>
</html>