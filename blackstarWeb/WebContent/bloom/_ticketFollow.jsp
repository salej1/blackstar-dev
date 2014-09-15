<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:forEach var="current" items="${followUps}" >
<div class="comment">
	<c:choose>
		<c:when test="${current.createdByUsr == current.asignee}">
			<p><strong>${current.created}: ${current.createdByUsr} comentó:</strong></p>
		</c:when>
		<c:otherwise>
			<p><strong style="vertical-align:middle">${current.created}: ${current.createdByUsr}</strong> <img src="/img/navigate-right_pre.png" style="vertical-align:middle"> <strong>${current.asignee}</strong></p>
		</c:otherwise>
	</c:choose>
   <p><small>${current.followup}</small></p>
</div>
</c:forEach>