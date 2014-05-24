<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" charset="utf-8">
	 var generalStr = '${generalAverage}';
	 var userStr = '${userAverage}';
	 $(document).ready(function() {

	   try{
	      var generalData = $.parseJSON(generalStr);
	      var userData = $.parseJSON(userStr);
	   } catch(err){
	      alert(err);
	   }
	 
	 $('#generalAverage').dataTable({
			"bProcessing": true,
			"bLengthChange": false,
			"bInfo": false,
			"aaData": generalData,
			"sDom": '<"top"i>rt<"bottom"><"clear">',
			"aaSorting": [],
			"aoColumns": [
						  { "mData": "office"},
						  { "mData": "services"},
						  { "mData": "average"}
					  ]			  
     });
		
	 
	 $('#userAverage').dataTable({
			"bProcessing": true,
			"bLengthChange": false,
			"bInfo": false,
			"aaData": userData,
			"sDom": '<"top"i>rt<"bottom"><"clear">',
			"aaSorting": [],
			"aoColumns": [
						  { "mData": "name"},
						  { "mData": "average"},
						  { "mData": "services"},
						  { "mData": "wrongOs"},
						  { "mData": "badComments"}
					  ]			  
       });
	 
  });

 </script> 


	<div id="content" class="container_16 clearfix">

			<div class="box">
							<h2>Promedios</h2>
							<div class="utils">
								
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="generalAverage" width="350px">
				<thead>
					<tr>
						<th>Oficina</th>
						<th>Servicios</th>
						<th>Promedio</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			
			
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="userAverage">
				<thead>
					<tr>
						<th>Nombre</th>
						<th>Promedio</th>
						<th>Servicios</th>
						<th>OS con errores</th>
						<th>Malos comentarios</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			
			
			
			</div>
	</div>

