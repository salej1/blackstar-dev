<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE HTML>
<c:set var="pageSection" scope="request" value="dashboard" />
<c:import url="../header.jsp"></c:import>
<html>
<head>
<link rel="stylesheet" href="/css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="/css/jquery-ui.min.css"/>
<script src="/js/jquery-1.10.1.min.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>

<script type="text/javascript">
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
		     var newProjects = $.parseJSON('${newProjects}');
		     var authProjects = $.parseJSON('${authProjects}');
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
							  { "mData": "cstName" },
							  { "mData": "location" },
							  { "mData": "created" },
							  { "mData": "totalProjectNumber" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center ><a href=/codex/project/advanceStatus.do?projectId=" + row.id + "&projectNumber=" + row.projectNumber + "&deliverableTypeId=1&dashboard=1>" + "Enviar a autorizar" + "</a></div>";}, "aTargets" : [7]},
								  {"mRender" : function(data, type, row){return "<div align=center ><a href=${pageContext.request.contextPath}/codex/project/edit.do?projectId=" + row.id + ">" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){
											return toCurrency(data);
								  		}, "aTargets" : [5]
								  }]}

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
							  { "mData": "cstName" },
							  { "mData": "location" },
							  { "mData": "created" },
							  { "mData": "totalProjectNumber" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=left ><a href=/codex/project/advanceStatus.do?projectId=" + row.id + "&projectNumber=" + row.projectNumber + "&deliverableTypeId=3&dashboard=1>" + "Crear cotización" + "</a></div>";}, "aTargets" : [7]},
								  {"mRender" : function(data, type, row){return "<div align=left ><a href=${pageContext.request.contextPath}/codex/project/edit.do?projectId=" + row.id + ">" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){
											return toCurrency(data);
								  		}, "aTargets" : [5]
								  }]}

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
							  { "mData": "cstName" },
							  { "mData": "location" },
							  { "mData": "created" },
							  { "mData": "totalProjectNumber" },
							  { "mData": "statusDescription" },
							  { "mData": null }
						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=left style='width:75px;'><a href=/codex/project/advanceStatus.do?projectId=" + row.id + "&projectNumber=" + row.projectNumber + "&deliverableTypeId=2&dashboard=1>" + "Autorizar" + "</a></div>";}, "aTargets" : [7]},
								  {"mRender" : function(data, type, row){return "<div align=left ><a href=${pageContext.request.contextPath}/codex/project/edit.do?projectId=" + row.id + ">" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){
											return toCurrency(data);
								  		}, "aTargets" : [5]
								  }]}
			);

		
	} );


 </script> 

 <title>Dashboard</title>
 </head>
<body>
	<div id="content" class="container_16 clearfix">
	     <c:set var="sysSalesManger" scope="request" value="${user.belongsToGroup['Gerente comercial']}" />
	     <c:set var="sysCST" scope="request" value="${user.belongsToGroup['CST']}" />

	     <div class="grid_16">
	     	<!-- Llamadas de ventas	 -->
	     	<c:import url="salesCall.jsp"></c:import>
			<script type="text/javascript">
				$(function(){
					initialize_salesCall();
				});
			</script>
			<p>
				<img src="/img/navigate-right.png"/><a href="${pageContext.request.contextPath}/codex/client/create.do" >Nuevo Prospecto</a>
			</p>
			<p>
				<img src="/img/navigate-right.png"/><a href="${pageContext.request.contextPath}/codex/project/create.do" >Nueva cedula de proyectos</a>
			</p>
		</div>
		
		<c:if test="${user.belongsToGroup['Gerente comercial']}">
        <div class="grid_16">
			<div class="box">
				<h2>C. de proyectos por autorizar</h2>
				<div class="utils">
					
				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="byAuthProjectsList">
					<thead>
						<tr>
							<th style="width:60px">No. Cédula</th>
							<th style="width:250px">Cliente</th>
							<th style="width:120px">Consultor</th>
							<th>Localidad</th>
							<th>Creada</th>
							<th style="width:90px">Total</th>
							<th>Estatus</th>
							<th style="width:90px">Accion</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
        </c:if>   
        <c:if test="${sysCST}" >   
		<div class="grid_16">
			<div class="box">
				<h2>C. de proyectos nuevas</h2>
				<div class="utils">
					
				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="newProjectsList">
					<thead>
						<tr>
							<th style="width:60px">No. Cédula</th>
							<th style="width:250px">Cliente</th>
							<th style="width:120px">Consultor</th>
							<th>Localidad</th>
							<th>Creada</th>
							<th style="width:90px">Total</th>
							<th>Estatus</th>
							<th style="width:90px">Accion</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>

		<div class="grid_16">
			<div class="box">
				<h2>C. de proyectos autorizadas</h2>
				<div class="utils">
					
				</div>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="authProjectsList">
					<thead>
						<tr>
							<th style="width:60px">No. Cédula</th>
							<th style="width:250px">Cliente</th>
							<th style="width:120px">Consultor</th>
							<th>Localidad</th>
							<th>Creada</th>
							<th style="width:90px">Total</th>
							<th>Estatus</th>
							<th style="width:90px">Accion</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>
		</c:if>
		
		<!-- Visitas a clientes -->
		<c:import url="visitList.jsp"></c:import>
		<script type="text/javascript">
			$(function(){
				visitList_init();
			});
		</script>
	</div>
</body>
</html>
