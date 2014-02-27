<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" charset="utf-8">

	 $(document).ready(function() {
	 
	 $('#statics').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aaSorting": []	
          });
	 } );
	 

 </script> 

    <c:set var="lastOffice" value="" scope="request" />
    <c:set var="counter" value="0" scope="request" />
    <c:set var="month" value="0" scope="request" />
	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Estadisticas</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="statics">
				<thead>
					<tr bgcolor="#FF0000">
						<th>Oficina</th>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Total de Equipos con poliza en SAC</th>
						<th>Porcentaje del Total de Equipos</th>
						<th>Cantidad de Reportes</th>
						<th>Porcentaje del total de Reportes</th>
						<th>Total de reportes de Oficina</th>
					</tr>
				</thead>
				<tbody>
				   <c:forEach var="row" items="${statics}" varStatus="status">
				       <tr>
				          <c:choose>
                             <c:when test="${lastOffice != row.officeName}">
                                 <c:set var="lastOffice" value="${row.officeName}" scope="request"/>
                                  <td><c:out value="${row.officeName}" /></td>
                             </c:when>
                             <c:otherwise>
                                  <td></td>
                             </c:otherwise>
                           </c:choose>
                           
				            <td><c:out value="${row.project}" /></td>
				            <td><c:out value="${row.customer}" /></td>
				            <td><c:out value="${row.pNumber}" /></td>
				            <td><c:out value="${(row.pNumber * 100) / row.tPolicies}%" /></td>
				            <td><c:out value="${row.nReports}" /></td>
				            <td><c:out value="${(row.nReports * 100) / row.tReports}%" /></td>
				            <td></td>
				       </tr>
				   </c:forEach>
				</tbody>
			</table>
			</div>
		</div>
	</div>

