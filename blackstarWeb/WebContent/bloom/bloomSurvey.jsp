<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<script type="text/javascript" charset="utf-8">
	 function bloomSurvey_init(){
	
     var user = "${user.userEmail}";

	 $.getJSON('/bloom/survey/getSurveyTable.do', function(data){
		$('#surveys').dataTable({
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"lp><"clear">',
					"aoColumns": [
								  { "mData": "id" },
								  { "mData": "ticketNumber" },
								  { "mData": "applicantArea" },
								  { "mData": "project" },
								  { "mData": "created" },
								  { "mData": "evaluation" }
							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){if(row.evaluation == 1){return "Satisfactoria"} else return "No Satisfactoria";}, "aTargets" : [5]}
									 ]}
				);
	 });
	
	$.getJSON('/bloom/survey/pendingSurveyTable.do', function(data){
		$('#pendingSurveys').dataTable({
						"bProcessing": true,
						"bFilter": true,
						"bLengthChange": false,
						"iDisplayLength": 10,
						"bInfo": false,
						"sPaginationType": "full_numbers",
						"aaData": data,
						"sDom": '<"top"i>rt<"bottom"lp><"clear">',
						"aoColumns": [
									  { "mData": "ticketNumber" },
									  { "mData": "applicantArea" },
									  { "mData": "project" },
									  { "mData": "risponsableName" },
									  { "mData": null}
								  ],
						"aoColumnDefs" : [
											{"mRender" : function(data, type, row){
												if(row.createdByUsr == user){
													return "<div align=center style='width:60px;'><a href=/bloom/survey/create.do?ticketNumber=" + row.ticketNumber + ">" + "Aplicar" + "</a></div>";
												}
												else{
													return "";
												}
											}, "aTargets" : [4]} 
												
										 ]}
					);
		});
		
	} 

 </script> 


<div class="grid_16">

	<div class="box">
					<h2>Encuestas de Requisiciones</h2>
					<div class="utils">
						
	</div>
	<table cellpadding="0" cellspacing="0" border="0" class="display" id="surveys">
		<thead>
			<tr>
				<th>No. Encuesta</th>
				<th>Requisicion</th>
				<th>Area Solicitante</th>
				<th>Proyecto</th>
				<th>Fecha de creación</th>
				<th>Resultado</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	</div>
</div>

<div class="grid_16">

	<div class="box">
					<h2>Requisiciones sin encuesta</h2>
					<div class="utils">
						
	</div>
	<table cellpadding="0" cellspacing="0" border="0" class="display" id="pendingSurveys">
		<thead>
			<tr>
				<th>Requisicion</th>
				<th>Area Solicitante</th>
				<th>Proyecto</th>
				<th>Responsable</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	</div>
</div>

