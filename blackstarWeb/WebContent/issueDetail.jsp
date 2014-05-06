<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="dashboard" />
<c:import url="header.jsp"></c:import>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css"/ >
</head>
<body>

<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->		
	<div class="grid_16">					
		<form:form commandName="issue" action="/issues/save.do" method="POST">
			<div class="box">
				<form:hidden path="referenceId"/>
				<h2>Asignacion No: ${issue.referenceNumber} </h2>
				<form:hidden path="referenceNumber"/>
				<form:hidden path="referenceTypeId"/>
				<form:hidden path="referenceStatusId"/>
				<form:hidden path="createdByUsr"/>
				<table>
					<tbody>
						<tr>
							<td style="width:90px;">Titulo:</td>
							<td><form:input path="title" cssClass="lockOnDetail" style="width:95%" required="true"/></td>
						</tr>
						<tr>
							<td>Asignado a:</td>
							<td>
								<form:select cssClass="lockOnDetail" items="${employees}" itemValue="userEmail" itemLabel="userName" path="referenceAsignee"/></select>
							</td>
						</tr>
						<tr>
							<td>Estatus</td>
							<td>
								<form:select disabled="true" items="${issueStatusList}" itemValue="issueStatusId" itemLabel="issueStatus" path="referenceStatusId"/></select>
							</td>
						</tr>
						<tr>
							<td>Detalles</td>
							<td><form:textarea cssClass="lockOnDetail" path="detail" style="width:95%" rows="5" required="true"/></td>
						</tr>
						<tr>
							<td>Proyecto:</td>
							<td><form:input cssClass="lockOnDetail" path="project" style="width:95%"/></td>
						</tr>
						<tr>
							<td>Cliente:</td>
							<td><form:input cssClass="lockOnDetail" path="customer" style="width:95%"/></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>	
			<form:hidden path="resolution"/>
		</form:form>				

		<!-- Control de secuencia y captura de seguimiento -->
		<c:if test="${issue.referenceId > 0}">
			<c:import url="followUpControl.jsp"></c:import>
			<script type="text/javascript">
				$(function(){
					initFollowUpDlg("issue", "issues/show.do?issueId=${issue.referenceId}");
				});
			</script>
		</c:if>
		<table>
			<tbody>
				<tr>
					<td>
						<p></p>
						<c:if test="${mode == 'detail'}">
							<input type="button" class="searchButton" onclick="addSeguimiento(${issue.referenceId}, '${issue.referenceNumber}');" value="Agregar seguimiento"/>
						</c:if>
						<c:if test="${issue.referenceStatusId == 'A' && issue.referenceAsignee == user.userEmail}">
							<input type="button" class="searchButton" onclick="resolveIssue(); return false;" value="Resolver"/></input>
						</c:if>
						<c:if test="${issue.createdByUsr == user.userEmail}">
							<input type="button" class="searchButton" onclick="closeIssue(); return false;" value="Cerrar"/>
						</c:if>
						<c:if test="${mode == 'new'}">
							<input type="button" class="searchButton" onclick="saveIssue(); return false;" value="Guardar"/>
						</c:if>
					</td>
				</tr>
			<tbody>
		</table>
	</div>
	<div id="resolveCommentsDlg" title="Resolver asunto pendiente">
		<div>
		<Label id="resolutionTimeStamp" style="display:inline;">stamp</Label><Label id="seguimientoSender" style="display:inline;">: </Label>
	</div>
	<div> Asignar a: </div>
		<form:select path="issue.createdByUsr" items="${employees}" itemValue="userEmail" itemLabel="userName" disabled="true"/>
		<p style='padding-top=10px;'>
			Resolucion:
		</p>
		<textarea name="" id="resolutionText" style="width:95%" rows="5">
			
		</textarea>
	</div>
</body>
<script type="text/javascript">
	$(function(){
		var mode = "${mode}";

		if(mode == "detail"){
			$(".lockOnDetail").attr("disabled", "");
		}

		$("#resolveCommentsDlg").dialog({
			autoOpen: false,
			height: 340,
			width: 480,
			modal: true,
			buttons: {
				"Agregar": function() {
					applyResolution();
					$( this ).dialog( "close" );
				},							

				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});

		$("#resolutionTimeStamp").html(d.format('dd/MM/yyyy hh:mm:ss'));
	});

	function closeIssue(){
		$("#referenceStatusId").val('C');
		$("input").removeAttr("disabled");
		$("#issue").submit();
	}

	function saveIssue(){
		$("#referenceStatusId").val('A');
		$("input").removeAttr("disabled");
		$("#issue").submit();
	}

	function resolveIssue(){
		$("#resolveCommentsDlg").dialog('open');	
		$("#seguimientoStamp").html(d.format('dd/MM/yyyy hh:mm:ss'));
		$("#seguimientoSender").html(' ${ user.userName }:');
		$("#resolutionText").val('');
		addFollowUpId = id;
	}

	function applyResolution(){
		$("#resolution").val($("#resolutionText").val());
		$("#referenceStatusId").val('R');
		$("input").removeAttr("disabled");
		$("select").removeAttr("disabled");
		$("#issue").submit();
	}
</script>
</html>