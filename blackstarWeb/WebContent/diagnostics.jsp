<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<p>Error: ${ error }</p>
<p>User Id: ${ userId }</p>
<p>User name: ${ userName }</p>
<p>User groups:</p>
<c:forEach var="group" items="${userGroups }">
	<p>${ group }</p>
</c:forEach>
<p>Employee List: </p>
<c:forEach var="employee" items="${ employeeList }">
	<p>${ employee.value }: ${ employee.key }</p>
</c:forEach>
</body>
</html>