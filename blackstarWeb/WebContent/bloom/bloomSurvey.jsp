<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="tickets" />
<c:import url="/header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
	 $(document).ready(function() {

	 try{
	 var data = $.parseJSON('${surveyTable}');
	 }
	 catch(err){
	 alert(err);
	 }

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
	 
	 
	 try{
		 data = $.parseJSON('${pendingSurveyTable}');
		 }
		 catch(err){
		 alert(err);
		 }

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
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=/bloom/survey/create.do?ticketNumber=" + row.ticketNumber + ">" + "Aplicar" + "</a></div>";}, "aTargets" : [4]}    		    	       
								 ]}
			);
		
	} );

 </script> 

 <title>Evaluación Interna</title>
 </head>
<body>
	<div id="content" class="container_16 clearfix">
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
	</div>
	
	<div id="content" class="container_16 clearfix">
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
	</div>
</body>
</html>
