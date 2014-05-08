<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:forEach var="current" items="${followUps}" >
<div class="comment">
   <p><strong>${current.created}: ${current.createdByUsr}: ${current.asignee}</strong></p>
   <p><small>${current.followup}</small></p>
</div>
</c:forEach>