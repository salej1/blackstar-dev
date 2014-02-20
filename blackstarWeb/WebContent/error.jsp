<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="error" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
	<title>GPO SAC</title>
	<script type="text/javascript">
		$(function(){
			$("#detailsLink").bind("click", function(){
				$("#details").show();
				return false;
			});
		});
	</script>
	</head>
<body>
<!-- Seccion de despliegue del error -->
<div id="content" class="container_16 clearfix">
	<div><p><img src="/img/error.png" alt=""> Error. No se pudo completar la operación</p></div>
	<p><a href="" id="detailsLink">Mostrar Detalles</a></p>
</div>
<div id="details" style="display:none;"  class="container_16 clearfix">
	<small>Error: ${errorDetails}</small>
</div>