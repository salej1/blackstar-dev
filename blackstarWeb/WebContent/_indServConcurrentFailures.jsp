<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" charset="utf-8">
	 var str = '${tickets}';
	 var sMonth;

	 $(document).ready(function() {
	 
	 $('#tickets').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aaSorting": [],
			"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			      $('td:eq(6)', nRow).css('background', "#86A2CE")
                  .css('font-weight', 'bold')
                  .css('text-align','center');
			      
			      if( $('td:eq(0)', nRow).html().indexOf("lbl-") == 0){
			    	  $('td:eq(0)', nRow).html($('td:eq(0)', nRow).html()
			    	       .substring(4, $('td:eq(0)', nRow).html().length));
			    	  $('td', nRow).css({'background':'#C0E1F3'}).css('font-weight', 'bold');
			      }
			      
			    }	
          });
	 } );
	 

 </script> 

    <c:set var="lastSerial" value="" scope="request" />
    <c:set var="counter" value="0" scope="request" />
    <c:set var="month" value="0" scope="request" />
	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Fallas Concurrentes</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="tickets">
				<thead>
					<tr bgcolor="#FF0000">
						<th>Usuario</th>
						<th>Empresa</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>Serie</th>
						<th>Falla</th>
						<th>Cantidad</th>
						<th>Ingeniero que atendió</th>
						<th>Ticket</th>
						<th>Fecha</th>
					</tr>
				</thead>
				<tbody>
				   <c:forEach var="row" items="${concurrenFailures}" varStatus="status">
				       <tr>
				          <c:choose>
                             <c:when test="${lastSerial != row.serialNumber}">
                                 <c:set var="lastSerial" value="${row.serialNumber}" scope="request"/>
                                  <td><c:out value="${row.employee}" /></td>
				                  <td><c:out value="${row.customer}" /></td>
				                  <td><c:out value="${row.equipmentTypeId}" /></td>
				                  <td><c:out value="${row.brand}" /></td>
				                  <td><c:out value="${row.serialNumber}" /></td>
                             </c:when>
                             <c:otherwise>
                                 <c:set var="counter" value="${counter + 1}" scope="request"/>
                                  <td></td>
				                  <td></td>
				                  <td></td>
				                  <td></td>
				                  <td></td>
                             </c:otherwise>
                           </c:choose>
                           
				         
				          
				          <td><c:out value="${row.observations}" /></td>	          
				          <c:choose>
                             <c:when test="${not status.last and (not empty row.serialNumber) and (concurrenFailures[status.index + 1].serialNumber != row.serialNumber)}">
				                <td ><c:out value="${counter}" /></td>
				                <c:set var="counter" value="${0}" scope="request"/>
                             </c:when>
                             <c:otherwise>
                                       <td></td>
                             </c:otherwise>
                          </c:choose>
                          <td><c:out value="${row.asignee}" /></td>
				          <td><c:out value="${row.ticketNumber}" /></td>
				          <td><c:out value="${row.created}" /></td>
				       </tr>
				   </c:forEach>
				</tbody>
			</table>
			</div>
		</div>
	</div>

