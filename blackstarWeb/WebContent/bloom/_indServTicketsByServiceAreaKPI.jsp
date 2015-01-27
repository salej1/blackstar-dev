<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<script type="text/javascript">
  $(document).ready(function() {    	  

      google.load('visualization', '1.0', {packages:['corechart'], callback: drawTicketByServiceAreaKPI});
      
      function drawTicketByServiceAreaKPI() {
        var charts = '${ticketByServiceAreaKPI}';
        var chartsNumber = charts.split(",").length;
    	var data;
    	var options;
    	var chart;
    	var row;
    	for(var i = 0; i< chartsNumber; i ++){
    	  json=parse($('#ticketByServiceAreaKPIData_' + i).val());
    	  data = new google.visualization.DataTable();
    	  data.addColumn('string','Area');
    	  data.addColumn('number','No. de Tickets');
    	  for (var j=0;j<json.length;j++) {
    		 row = [];       
    		 row.push(json[j].applicantArea);
    		 row.push(json[j].counter);
    		 data.addRow(row);
         }
    	  chart = new google.visualization.PieChart(document.getElementById('ticketByServiceAreaKPIChart_' + i));
        options = {legend: { position: 'right', alignment: 'center' },
                   chartArea:{left:50,top:10,width:"100%", height:"100%"},
                   is3D: $('#ticketByServiceAreaKPIIs3d_' + i).val()};
    	  chart.draw(data, options);
        }
      } 	
   });
 </script>


	<div id="content" class="container_16 clearfix">
	    <c:forEach var="chart" items="${ticketByServiceAreaKPI}" varStatus="counter">
	      <div class="grid_16">
			  <div class="box">
							<h2>${chart.title}</h2>
							<div class="utils"></div>
			  <div id="ticketByServiceAreaKPIChart_${counter.index}" style="width: 900px; height: 400px;"></div>
			  <input type="hidden" id ="ticketByServiceAreaKPIType_${counter.index}" value="${chart.type}">
			  <input type="hidden" id ="ticketByServiceAreaKPIIs3d_${counter.index}" value="${chart.is3d}">
			  <input type="hidden" id ="ticketByServiceAreaKPIData_${counter.index}" value="${chart.data}">
		    </div>
		  </div>
	    </c:forEach>
	</div>
