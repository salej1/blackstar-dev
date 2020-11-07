<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<html>
	<head>
		
	</head>
	<body>
		<h2>Firma Izquierda</h2>
		<div id="leftSign" class="signBox">
			<canvas class="signPad" width="330" height="115"></canvas>
		</div>
		<h2>Firma Derecha</h2>
		<div id="rightSign" class="signBox">
			<canvas class="signPad" width="330" height="115"></canvas>
		</div>
	</body>
</html>