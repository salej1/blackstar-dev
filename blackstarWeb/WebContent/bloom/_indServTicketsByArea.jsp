<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<script type="text/javascript">
  $(document).ready(function() {    	  

      google.load('visualization', '1.0', {packages:['corechart'], callback: drawTicketByArea});
      
      function drawTicketByArea() {
        var charts = '${ticketByArea}';
        var chartsNumber = charts.split(",").length;
    	var data;
    	var options;
    	var chart;
    	var row;
    	for(var i = 0; i< chartsNumber; i ++){
    	  json=parse($('#ticketByAreaData_' + i).val());
    	  data = new google.visualization.DataTable();
    	  data.addColumn('string','applicantArea');
    	  data.addColumn('number','counter');
    	  for (var j=0;j<json.length;j++) {
    		 row = [];       
    		 row.push(json[j].applicantArea);
    		 row.push(json[j].counter);
    		 data.addRow(row);
         }
         chart = new google.visualization.PieChart(document.getElementById('ticketByAreaChart_' + i));
    	 options = {legend: { position: 'right', alignment: 'center' },
   		      		   chartArea:{left:50,top:10,width:"100%", height:"100%"},
   		        	   is3D: $('#ticketByAreaIs3d_' + i).val()};
    	 chart.draw(data, options);
        }
      } 	
   });
 </script>


	<div id="content" class="container_16 clearfix">
	    <c:forEach var="chart" items="${ticketByArea}" varStatus="counter">
	      <div class="grid_16">
			  <div class="box">
							<h2>${chart.title}</h2>
							<div class="utils"></div>
			  <div id="ticketByAreaChart_${counter.index}" style="width: 900px; height: 400px;"></div>
			  <input type="hidden" id ="ticketByAreaType_${counter.index}" value="${chart.type}">
			  <input type="hidden" id ="ticketByAreaIs3d_${counter.index}" value="${chart.is3d}">
			  <input type="hidden" id ="ticketByAreaData_${counter.index}" value="${chart.data}">
		    </div>
		  </div>
	    </c:forEach>
	</div>
