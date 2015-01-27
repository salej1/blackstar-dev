<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" charset="utf-8">
	 var str = '${tickets}';
	 var sMonth;

	 $(document).ready(function() {
	 
	 $('#tickets').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"bPaginate": false,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"sDom": '<"top"i>rt<"bottom"><"clear">',
			"aaSorting": []	
          });
	 } );
	 

 </script> 

    <c:set var="lastSerial" value="" scope="request" />
    <c:set var="counter" value="0" scope="request" />
    <c:set var="month" value="0" scope="request" />
	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Fallas Recurrentes</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="tickets">
				<thead>
					<tr bgcolor="#FF0000">
						<th style="width:130px">Fecha</th>
						<th style="width:70px">Ticket</th>
						<th>Empresa</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>Serie</th>
						<th>Falla</th>
						<th>Ticket anterior</th>
						<th>Ingeniero que atendió</th>
						<th>Mantto. anterior</th>
					</tr>
				</thead>
				<tbody>
				   <c:forEach var="row" items="${concurrenFailures}" varStatus="status">
				       <tr>
                       		<td><c:out value="${row.created}" /></td>
                       		<td><a href='/ticketDetail?ticketNumber=${row.ticketNumber}'>${row.ticketNumber}</a></td>
                       		<td><c:out value="${row.customer}" /></td>
                       		<td><c:out value="${row.equipmentTypeId}" /></td>
                       		<td><c:out value="${row.brand}" /></td>
                       		<td><c:out value="${row.serialNumber}" /></td>
                       		<td><c:out value="${row.observations}" /></td>
                       		<td><a href='/ticketDetail?ticketNumber=${row.lastTicketNumber}'>${row.lastTicketNumber}</a></td>
                       		<td><c:out value="${row.employee}" /></td>
                       		<c:choose>
	                       		<c:when test="${not empty row.lastServiceNumber}">
	                       			<td><a href='/osDetail/show.do?serviceOrderId=0&serviceOrderNumber=${row.lastServiceNumber}'>${row.lastServiceNumber}</a></td>
								</c:when>
	                       		<c:otherwise>
	                       			<td></td>
	                       		</c:otherwise>
                       		</c:choose>
				       </tr>
				   </c:forEach>
				</tbody>
			</table>
			</div>
		</div>
	</div>

