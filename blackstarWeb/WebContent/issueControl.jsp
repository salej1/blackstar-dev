<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<script type="text/javascript">
	function issueControl_init(){
		getUserIssues("${user.userEmail}");
		getUserWatchingIssues("${user.userEmail}");
	}

	function getUserWatchingIssues(user){
		$.getJSON("/issues/getUserWatchingIssuesJson.do", function(data){
			$('#userWatchingIssues').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"bAutoWidth": false ,
				"sPaginationType": "full_numbers",
				"aaData": data,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "referenceNumber" },
							  { "mData": "referenceType" },
							  { "mData": "project" },
							  { "mData": "customer" },
							  { "mData": "created" },
							  { "mData": "detail" },
							  { "mData": "createdByUsr" },
							  { "mData": "asignee" },
							  { "mData": "status" }
				],
				"aoColumnDefs": [
								{"mRender": function(data, type, row){
										if(row.referenceTypeId == 'O'){
											return "<a href='/osDetail/show.do?serviceOrderId=" + row.referenceId + "'>" + row.referenceNumber + "</a>";
										}	
										else if(row.referenceTypeId == 'T'){
											return "<a href='/ticketDetail?ticketId=" + row.referenceId + "'>" + row.referenceNumber + "</a>";
										}
										else if(row.referenceTypeId == 'I'){
											return "<a href='/issues/show.do?issueId=" + row.referenceId + "'>" + row.referenceNumber + "</a>";
										}
									}, "aTargets" : [0]}
				]
			});
		});
	}

	function getUserIssues(user){
		$.getJSON("/issues/getUserIssuesJson.do", function(data){
			$('#userIssues').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"bAutoWidth": false ,
				"sPaginationType": "full_numbers",
				"aaData": data,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "referenceNumber" },
							  { "mData": "referenceType" },
							  { "mData": "project" },
							  { "mData": "customer" },
							  { "mData": "created" },
							  { "mData": "detail" },
							  { "mData": "createdByUsr" },
							  { "mData": "asignee" },
							  { "mData": "status" }
				],
				"aoColumnDefs": [
								{"mRender": function(data, type, row){
										if(row.referenceTypeId == 'O'){
											return "<a href='/osDetail/show.do?serviceOrderId=" + row.referenceId + "'>" + row.referenceNumber + "</a>";
										}	
										else if(row.referenceTypeId == 'T'){
											return "<a href='/ticketDetail?ticketId=" + row.referenceId + "'>" + row.referenceNumber + "</a>";
										}
										else if(row.referenceTypeId == 'I'){
											return "<a href='/issues/show.do?issueId=" + row.referenceId + "'>" + row.referenceNumber + "</a>";
										}
									}, "aTargets" : [0]}
				]
			});
		});
	}
		
</script>
<div class="grid_16">
	<div style="padding-top:20px; padding-bottom:10px;"><img src="/img/navigate-right.png"/><a href="/issues/show.do?issueId=0">Agregar pendiente</a></div>
	<div class="box">
		<h2>Pendientes en proceso</h2>
		<div class="utils">
		</div>
		<div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="userWatchingIssues">
				<thead>
					<tr>
						<th style="width:70px;">Folio</th>
						<th>Referencia</th>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Fecha</th>
						<th style="width:250px;">Actividad</th>
						<th>Asignado por</th>
						<th>Asignado a</th>
						<th>Estatus</th>
						<th></th>

					</tr>
				</thead>
				<tbody>  
				</tbody> 
			</table>
		</div>
	</div>
	<div class="box">
		<h2>Pendientes por atender</h2>
		<div class="utils">
		</div>
		<div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="userIssues">
				<thead>
					<tr>
						<th style="width:70px;">Folio</th>
						<th>Referencia</th>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Fecha</th>
						<th style="width:250px;">Actividad</th>
						<th>Asignado por</th>
						<th>Asignado a</th>
						<th>Estatus</th>
						<th></th>

					</tr>
				</thead>
				<tbody>  
				</tbody> 
			</table>
		</div>
	</div>
</div>