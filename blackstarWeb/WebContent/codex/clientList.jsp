<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="clientes" />
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
		     var prospects = $.parseJSON('${prospects}');
		     var clients = $.parseJSON('${clients}');
		 }
		 catch(err){
		 alert(err);
		 }

		 $('#propectList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": prospects,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "id"},
							  { "mData": "clientTypeId" },
							  { "mData": "corporateName" },
							  { "mData": "city" },
							  { "mData": "contactName" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:75px;'><a href=${pageContext.request.contextPath}/codex/project/create.do?clientId=" + row.id + ">" + "Crear Cedula" + "</a></div>";}, "aTargets" : [5]},
				                  {"mRender" : function(data, type, row){return "<div><a href=${pageContext.request.contextPath}/codex/client/edit.do?clientId=" + row.id + ">" + data + "</a></div>";}, "aTargets" : [2]}]}
			);
		 
		 $('#clientList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": clients,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "id"},
							  { "mData": "clientTypeId" },
							  { "mData": "corporateName" },
							  { "mData": "city" },
							  { "mData": "contactName" },
							  { "mData": null}
							  
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:75px;'><a href=${pageContext.request.contextPath}/codex/project/create.do?clientId=" + row.id + ">" + "Crear Cedula" + "</a></div>";}, "aTargets" : [5]},
				                  {"mRender" : function(data, type, row){return "<div><a href=${pageContext.request.contextPath}/codex/client/edit.do?clientId=" + row.id + ">" + data + "</a></div>";}, "aTargets" : [2]}]}
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
		</div>
		
		<div class="grid_16">

			<div class="grid_16">
		<div class="box">
			<h2>Prospectos</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="propectList">
				<thead>
					<tr>
						<th style="width:30px">Numero</th>
						<th style="width:60px">Tipo</th>
						<th>Cliente</th>
						<th style="width:100px">Ciudad</th>
						<th style="width:150px">Contacto</th>
						<th style="width:80px">Crear CP</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	
	<div class="grid_16">
		<div class="box">
			<h2>Clientes</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="clientList">
				<thead>
					<tr>
						<th style="width:30px">Numero</th>
						<th style="width:60px">Tipo</th>
						<th>Cliente</th>
						<th style="width:100px">Ciudad</th>
						<th style="width:150px">Contacto</th>
						<th style="width:80px">Crear CP</th>
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
