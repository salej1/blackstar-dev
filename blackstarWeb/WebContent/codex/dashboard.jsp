<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="dashboard" />
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
		     var newProjects = $.parseJSON('${newProjects}');
		     var authProjects = $.parseJSON('${authProjects}');
		     var cotProjects = $.parseJSON('${cotProjects}');
		     var byAuthProjects = $.parseJSON('${byAuthProjects}');
		 }
		 catch(err){
		 alert(err);
		 }

		 $('#newProjectsList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": newProjects,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "projectNumber"},
							  { "mData": "clientDescription" },
							  { "mData": "created" },
							  { "mData": "location" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:75px;'><a href=/codex/project/advanceStatus.do?projectId=" + row.id + ">" + "Enviar a autorización" + "</a></div>";}, "aTargets" : [5]}]}
			);
		 
		 $('#authProjectsList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": authProjects,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "projectNumber"},
							  { "mData": "clientDescription" },
							  { "mData": "created" },
							  { "mData": "location" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:75px;'><a href=/codex/project/advanceStatus.do?projectId=" + row.id + ">" + "Crear cotización" + "</a></div>";}, "aTargets" : [5]}]}
			);
		 
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
							  { "mData": "created" },
							  { "mData": "location" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:75px;'><a href=/codex/project/advanceStatus.do?projectId=" + row.id + ">" + "Crear pedido" + "</a></div>";}, "aTargets" : [5]}]}
			);
		 
		 
		 $('#byAuthProjectsList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": byAuthProjects,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "projectNumber"},
							  { "mData": "clientDescription" },
							  { "mData": "created" },
							  { "mData": "location" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:75px;'><a href=/codex/project/advanceStatus.do?projectId=" + row.id + ">" + "Autorizar" + "</a></div>";}, "aTargets" : [5]}]}
			);

		
	} );


 </script> 

 <title>Clientes</title>
 </head>
<body>
	<div id="content" class="container_16 clearfix">
	     <div class="grid_16">	
			<p>
				<img src="/img/navigate-right.png"/><a href="${pageContext.request.contextPath}/codex/client/create.do" >Nuevo Prospecto</a>
			</p>
			<p>
				<img src="/img/navigate-right.png"/><a href="${pageContext.request.contextPath}/codex/project/create.do" >Nueva cedula de proyectos</a>
			</p>
		</div>
		
		<div class="grid_16">

			<div class="grid_16">
		<div class="box">
			<h2>C. de proyectos nuevas</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="newProjectsList">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Ultima Actividad</th>
						<th>Ubicacion</th>
						<th>Estatus</th>
						<th>Accion</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	
	
		</div>
		
		<div class="grid_16">
		<div class="box">
			<h2>C. de proyectos por autorizar</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="byAuthProjectsList">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Ultima Actividad</th>
						<th>Ubicacion</th>
						<th>Estatus</th>
						<th>Accion</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
		
		
		<div class="grid_16">

			<div class="grid_16">
		<div class="box">
			<h2>C. de proyectos autorizadas</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="authProjectsList">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Ultima Actividad</th>
						<th>Ubicacion</th>
						<th>Estatus</th>
						<th>Accion</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	
	
		</div>
		
		<div class="grid_16">

			<div class="grid_16">
		<div class="box">
			<h2>C. de proyectos en cotización</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="cotProjectsList">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Ultima Actividad</th>
						<th>Ubicacion</th>
						<th>Estatus</th>
						<th>Accion</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	
	
		</div>
	</div>
</body>
</html>
