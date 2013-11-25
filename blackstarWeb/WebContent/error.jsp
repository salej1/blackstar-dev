<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:import url="header.jsp"></c:import>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
		<h1 id="head">
			<div class="logo">
				<img alt="Grupo Sac" src="${pageContext.request.contextPath}/img/grupo-sac-logo.png" border="0"/>
			</div>
			<span class="slogan">Portal de servicios</span>
		</h1>
	   Error general: Favor de comunicarse con el Administrador.
	   
	   <p>${errMessage}</p>
	   <p></p>
	   <c:forEach var="stackTrace" items="${stackTrace}">
						<p>${stackTrace}</p>
				</c:forEach>
</body>
</html>