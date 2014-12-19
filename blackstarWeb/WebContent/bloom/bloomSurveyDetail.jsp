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

<title>Evaluación Interna</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">
			
<!--   CONTENT COLUMN   -->		
				<div class="grid_16">					
					<div class="box">
						<h2>Requisicion ${ticketNumber}</h2>
						<div class="utils">
						</div>
						<form action="" id="mainform">
				          <input type="hidden" name="ticketNumber" id="ticketNumber" value="${ticketNumber}" readonly/>
			
						<table>
							<tbody>
								<tr>
								   <td>Marca temporal</td>
								   <td><input id="marcaTemporal" name="marcaTemporal" type="text" readonly  value="${marcaTemporal}" readonly/></td>
								</tr>
								<tr>
								   <td>La resolución fue satisfactoria ?</td>
								   <td>Sí <input name="evaluation" id="evaluationOk" type="radio" value="1" disabled/> No <input name="evaluation" id="evaluationKO" type="radio" value="0" disabled/></td>
								</tr>
								<tr>
								    <td>Observaciones</td>
								    <td><textarea id="observations" name="observations"  rows="7" readonly>${observations}</textarea></td>
								</tr>
							</tbody>
						</table>
						
						</form>
					</div>					
				</div>
</div>
</body>
<script src="${pageContext.request.contextPath}/js/"></script>
<script type="text/javascript">
	$(function(){
		$("input[name='evaluation'][value='${evaluation}']").attr("selected", "true");
	});
</script>
</html>
