<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false"%>


<table id="fileTraceTable">
  <thead>
       <tr>
		  <th colspan="3">Historial</th>
	   </tr>
  </thead>
  <c:forEach var="current" items="${deliverables}" >
	 <tr class="comment">
	    <td style="width:30%">
		   <strong>${current.deliverableTypeDescription}</strong>
	    </td>
	    <td style="width:50%">${current.userName}</td>
	    <td style="width:20%">${current.created}</td>
</tr>
  </c:forEach>
</table>