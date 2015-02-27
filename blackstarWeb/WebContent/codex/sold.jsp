<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="sold" />
<c:import url="../header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="/css/jquery-ui.min.css"/>
<script src="/js/jquery-1.10.1.min.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">

	 $(document).ready(function() {

		 try{
		     var cotProjects = $.parseJSON('${soldProjects}');
		 }
		 catch(err){
		 alert(err);
		 }
		 
		 $('#cotProjectsList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": cotProjects,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "projectNumber"},
							  { "mData": "clientDescription" },
							  { "mData": "cstName" },
							  { "mData": "created" },
							  { "mData": "location" },
							  { "mData": "statusDescription" }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){
									return "<div align=left><a href=/codex/client/edit.do?clientId=" + row.clientId + ">" + data + "</a></div>";
								}, "aTargets" : [1]},
								  {"mRender" : function(data, type, row){return "<div align=left><a href=${pageContext.request.contextPath}/codex/project/edit.do?projectId=" + row.id + ">" + data + "</a></div>";}, "aTargets" : [0]}]}

			);
	} );


 </script> 

 <title>Dashboard</title>
 </head>
<body>
	<div id="content" class="container_16 clearfix">
	     
		<div class="grid_16">
			<div class="box">
				<h2>Pedidos</h2>
				<div class="utils">
					
				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="cotProjectsList">
					<thead>
						<tr>
							<th style="width:60px">No. Cédula</th>
							<th style="width:250px">Cliente</th>
							<th style="width:150px">Consultor</th>
							<th>Fecha</th>
							<th style="width:180px">Ubicacion</th>
							<th>Estatus</th>
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
