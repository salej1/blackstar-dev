<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="projects" />
<c:import url="../header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
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

	 $(document).ready(function() {

		 try{
		     var projects = $.parseJSON('${projects}');
		 }
		 catch(err){
		 alert(err);
		 }

		 $('#projectList').dataTable({
				"bProcessing": true,
				"bFilter": true,
				"bLengthChange": false,
				"iDisplayLength": 10,
				"bInfo": false,
				"sPaginationType": "full_numbers",
				"aaData": projects,
				"sDom": '<"top"i>rt<"bottom"flp><"clear">',
				"aoColumns": [
							  { "mData": "projectNumber"},
							  { "mData": "clientDescription" },
							  { "mData": "cstName" },
							  { "mData": "location" },
							  { "mData": "created" },
							  { "mData": "totalProjectNumber" },
							  { "mData": "statusDescription" }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){
											return toCurrency(data);
								  		}, "aTargets" : [5]
								  },
								{"mRender" : function(data, type, row){
											return "<div align=center style='width:75px;'><a href=${pageContext.request.contextPath}/codex/project/edit.do?projectId=" + row.id + ">" + data + "</a></div>";
										}, "aTargets" : [0]
								},
								{"mRender" : function(data, type, row){
									return "<div align=left><a href=/codex/client/edit.do?clientId=" + row.clientId + ">" + data + "</a></div>";
								}, "aTargets" : [1]}]
			});
		
	} );


 </script> 

 <title>Cedulas de Proyecto</title>
 </head>
<body>
	<div id="content" class="container_16 clearfix">
		<c:if test="${user.belongsToGroup['Gerente comercial'] || user.belongsToGroup['CST']}">
		     <div class="grid_16">	
				<p>
					<img src="/img/navigate-right.png"/><a href="${pageContext.request.contextPath}/codex/project/create.do" >Nueva cedula de proyectos</a>
				</p>
			</div>
		</c:if>
		<div class="grid_16">

			<div class="grid_16">
		<div class="box">
			<h2>Cedulas de proyecto</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="projectList">
				<thead>
					<tr>
						<th style="width:60px">No. C�dula</th>
						<th style="width:250px">Cliente</th>
						<th style="width:150px">Consultor</th>
						<th>Localidad</th>
						<th>Creada</th>
						<th>Total</th>
						<th>Estatus</th>
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
