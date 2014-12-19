<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<script type="text/javascript">
  $(document).ready(function() {    	  

      google.load('visualization', '1.0', {packages:['corechart'], callback: draw});
      
      function draw() {
        var charts = '${graphics}';
        var chartsNumber = charts.split(",").length;
    	var data;
    	var options;
    	var chart;
    	 var row;
    	for(var i = 0; i< chartsNumber; i ++){
    	  json=pase($('#data_' + i).val());
    	  data = new google.visualization.DataTable();
    	  data.addColumn('string','createdStr');
    	  data.addColumn('number','No. de Tickets');
    	  for (var j=0;j<json.length;j++) {
    		 row = [];       
    		 row.push(json[j].created);
    		 row.push(json[j].counter);
    		 data.addRow(row);
         }
    	 chart = new google.visualization.LineChart(document.getElementById('chart_' + i));  
    	 chart.draw(data, options);
        }
      } 	
      
      function pase(input){
    	var output;
    	try {
    	    output = $.parseJSON(input.replace(/'/g, '"'));
    	} catch(err){
    		alert(err);
    	}
    	console.log(input.replace(/'/g, '"'));
    	return output;
      }
   });
 </script>

<div id="content" class="container_16 clearfix">

	    <c:forEach var="chart" items="${graphics}" varStatus="counter">
	      <div class="grid_16">
			  <div class="box">
							<h2>${chart.title}</h2>
							<div class="utils"></div>
			  <div id="chart_${counter.index}" style="width: 900px; height: 400px;"></div>
			  <input type="hidden" id ="type_${counter.index}" value="${chart.type}">
			  <input type="hidden" id ="is3d_${counter.index}" value="${chart.is3d}">
			  <input type="hidden" id ="data_${counter.index}" value="${chart.data}">
		    </div>
		  </div>
	    </c:forEach>
    </div>
