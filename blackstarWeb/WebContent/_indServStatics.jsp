<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="lastOffice" value="" scope="request" />
    
<script type="text/javascript" charset="utf-8">
      var color;
      var counter = 0;
	 $(document).ready(function() {
	 
	 $('#statics').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"bInfo": false,
			"bPaginate": false,
			"sDom": '<"top"i>rt<"bottom"><"clear">',
			"aaSorting": [],
			"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				 
			     $('td:eq(0)', nRow).css('background', "#D1DDEB")
                .css('font-weight', 'bold')
                .css('text-align','center');
			     
			     $('td:eq(7)', nRow)
	                .css('font-weight', 'bold')
	                .css('text-align','center');
			     
			      if( $('td:eq(0)', nRow).html().indexOf("GDL") == 0){
			    	  color="#E2D1EB";
			    	  counter = 0;
			      } else if( $('td:eq(0)', nRow).html().indexOf("MXO") == 0){
			    	  $(nRow).css('border-top', "2pt solid black");
			    	  counter = 0;
			    	  color="#EBD4CA";
			      } else if( $('td:eq(0)', nRow).html().indexOf("QRO") == 0){
			    	  $(nRow).css('border-top', "2pt solid black");
			    	  counter = 0;
			    	  color="#CECAEB";
			      }
			      $('td:eq(0)', nRow).css('background', color);
			      counter+= parseInt($('td:eq(5)', nRow).html());
			    }		
          });
	 } );
	 

 </script> 

	<div id="content" class="container_16 clearfix">
		<div class="grid_16">

			<div class="box">
							<h2>Estadisticas</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="report" id="statics">
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
				            <td><fmt:formatNumber value="${(row.pNumber * 100) / row.tPolicies}" maxFractionDigits="2"/> %</td>
				            <td><c:out value="${row.nReports}" /></td>
				            <td><fmt:formatNumber value="${(row.nReports * 100) / row.tReports}" maxFractionDigits="2"/> %</td>
				            <c:choose>
                             <c:when test="${row.oReports > 0}">
                                  <td><c:out value="${row.oReports}" /></td>
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

