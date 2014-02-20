<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" charset="utf-8">
	 var resumeStr = '${reportOSResume}';
	 $(document).ready(function() {

	   try{
	      var resumeData = $.parseJSON(resumeStr);
	   } catch(err){
	      alert(err);
	   }
	 
	 $('#osResume').dataTable({
			"bProcessing": true,
			"bLengthChange": false,
			"bInfo": false,
			"aaData": resumeData,
			"sDom": '<"top"i>rt<"bottom"><"clear">',
			"aaSorting": [],
			"aoColumns": [
						  { "mData": "office"},
						  { "mData": "numServiceOrders"},
						  { "mData": "numObervations"}
					  ]			  
     });
		
	 
	 $('#osTable').dataTable({
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aaSorting": [],
			"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			      if( $('td:eq(0)', nRow).html().indexOf("lbl-") == 0){
			    	  $('td:eq(0)', nRow).html($('td:eq(0)', nRow).html()
			    	       .substring(4, $('td:eq(0)', nRow).html().length));
			    	  $('td', nRow).css({'background':'#C0E1F3'}).css('font-weight', 'bold');
			      }
			    }      
       });
	 
  });

 </script> 


	<div id="content" class="container_16 clearfix">

			<div class="box">
							<h2>Reporte de Ordenes de Servicio</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="osResume" width="350px">
				<thead>
					<tr>
						<th>Oficina</th>
						<th>Cantidad de O/S</th>
						<th>O/S con observaciones</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			
			
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="osTable">
				<thead>
					<tr bgcolor="#FF0000">
						<th style="width:20%;">Numero de Orden de Servicio</th>
						<th style="width:10%;">Falla u Observacion</th>
						<th style="width:10%;">Acción Tomada</th>
						<th style="width:15%;">Personal que atendió 1</th>
						<th style="width:15%;">Personal que atendió 2</th>
						<th style="width:15%;">Personal que atendió 3</th>
						<th style="width:15%;">Personal que atendió 4</th>
					</tr>
				</thead>
				<tbody>
				   <c:forEach var="row" items="${reportOSTable}" varStatus="status">
				       <tr>
				          <c:set var="assigne" value="${fn:split(row.responsible, '/')}" />
                          <td><c:out value="${row.serviceOrderId}" /></td>
				          <td><c:out value="${row.comments}" /></td>
				          <td><c:out value="${row.serviceComments}" /></td>
				          <c:choose>
                             <c:when test="${fn:length(assigne) gt 0}">
                                 <td><c:out value="${assigne[0]}" /></td>
                             </c:when>
                             <c:otherwise>
                                  <td></td>
                             </c:otherwise>
                          </c:choose>
                          <c:choose>
                             <c:when test="${fn:length(assigne) gt 01}">
                                 <td><c:out value="${assigne[1]}" /></td>
                             </c:when>
                             <c:otherwise>
                                  <td></td>
                             </c:otherwise>
                          </c:choose>
                          <c:choose>
                             <c:when test="${fn:length(assigne) gt 2}">
                                 <td><c:out value="${assigne[2]}" /></td>
                             </c:when>
                             <c:otherwise>
                                  <td></td>
                             </c:otherwise>
                          </c:choose>
                          <c:choose>
                             <c:when test="${fn:length(assigne) gt 3}">
                                 <td><c:out value="${assigne[3]}" /></td>
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

