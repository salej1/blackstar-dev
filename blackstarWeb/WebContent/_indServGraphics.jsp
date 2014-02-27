<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<script type="text/javascript">
  $(document).ready(function() {    	  
	  
      google.load('visualization', '1.0', {packages:['corechart'], callback: draw});
      
      function draw() {
        var charts = '${charts}';
        var chartsNumber = charts.split(",").length;
    	var data;
    	var options;
    	var chart;
    	 var row;
    	for(var i = 0; i< chartsNumber; i ++){
    	  json=pase($('#data_' + i).val());
    	  data = new google.visualization.DataTable();
    	  data.addColumn('string','Nombre');
    	  data.addColumn('number','Valor');
    	  for (var j=0;j<json.length;j++) {
    		 row = [];       
    		 row.push(json[j].name);
    		 row.push(json[j].value);
    		 data.addRow(row);
         }
    	  if($('#type_' + i).val() == 'pie'){
    		chart = new google.visualization.PieChart(document.getElementById('chart_' + i));
    		options = {legend: { position: 'right', alignment: 'center' },
   		      		   chartArea:{left:50,top:10,width:"100%", height:"100%"},
   		        	   is3D: $('#is3d_' + i).val()};
    	  } else if ($('#type_' + i).val() == 'bar'){
    		  chart = new google.visualization.BarChart(document.getElementById('chart_' + i));
    	  }  else if ($('#type_' + i).val() == 'donut'){
    		   chart = new google.visualization.PieChart(document.getElementById('chart_' + i));
    		   options = {legend: {position: 'right', alignment: 'center'},
  		       		      chartArea:{left:50,top:10,width:"100%", height:"100%"},
  		       		      is3D: $('#is3d_' + i).val(),
  		        		  pieHole: 0.4,};
    	  } 
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
	    <c:forEach var="chart" items="${charts}" varStatus="counter">
	      <div class="grid_16">
			  <div class="box">
							<h2>${chart.title}</h2>
							<div class="utils"></div>
			  <div id="chart_${counter.index}" style="width: 900px; height: 300px;"></div>
			  <input type="hidden" id ="type_${counter.index}" value="${chart.type}">
			  <input type="hidden" id ="is3d_${counter.index}" value="${chart.is3d}">
			  <input type="hidden" id ="data_${counter.index}" value="${chart.data}">
		    </div>
		  </div>
	    </c:forEach>
	</div>
