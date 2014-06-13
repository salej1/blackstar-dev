<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" charset="utf-8">
	function convertOSToLinks(data) {
	    var osList = data.split(',');
	    var osNum;
	    var linkArray = [];

	    if (osList.length == 0) {
	        return "";
	    } else {

	        for (osNum in osList) {
	            var osLink = " <a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=0&serviceOrderNumber=" + osList[osNum] + "'>" + osList[osNum] + "</a>";
	            linkArray.push(osLink);
	        }
	    }

	    return linkArray.toString();
	}

	function convertSSToLinks(data) {
	    var ssList = data.split(',');
	    var ssNum;
	    var linkArray = [];

	    if (ssList.length == 0) {
	        return "";
	    } else {

	        for (ssNum in ssList) {
	            var ssLink = " <a href='${pageContext.request.contextPath}/surveyServiceDetail/show.do?operation=2&idObject=" + ssList[ssNum] + "'>" + ssList[ssNum] + "</a>";
	            linkArray.push(ssLink);
	        }
	    }

	    return linkArray.toString();
	}

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
						  { "mData": "wrongOsList"},
						  { "mData": "badComments"},
						  { "mData": "badCommentsOsList"}
					  ],
			"aoColumnDefs" : [{"mRender" : function(data, type, row){
												return convertOSToLinks(data);
											}, "aTargets" : [4]},
							  {"mRender" : function(data, type, row){
												return convertSSToLinks(data);
											}, "aTargets" : [6]}]
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
						<th style="width:150px">Nombre</th>
						<th>Promedio</th>
						<th>Servicios</th>
						<th style="width:70px;">OS con errores</th>
						<th style="width:200px;"></th>
						<th style="width:70px;">Malos comentarios</th>
						<th style="width:200px;"></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			
			
			
			</div>
	</div>

