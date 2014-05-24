<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
   <link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
    <script src="${pageContext.request.contextPath}/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
    <script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
    <script src="${pageContext.request.contextPath}/js/glow/1.7.0/core/core.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</head>
<body onload="JavaScript:timedRefresh(60000);">
      <table>
        <tbody>
          <tr>
            <td>
               <div class="box">
              <h2>${charts[0].title}</h2>
              <div class="utils"></div>
              <div id="chart_0" style="width: 700px; height: 400px;"></div>
              <input type="hidden" id ="type_0" value="${charts[0].type}">
              <input type="hidden" id ="is3d_0" value="${charts[0].is3d}">
              <input type="hidden" id ="data_0" value="${charts[0].data}">
              </div>
            </td>
            <td>
               <div class="box">
              <h2>${charts[1].title}</h2>
              <div class="utils"></div>
              <div id="chart_1" style="width: 700px; height: 400px;"></div>
              <input type="hidden" id ="type_1" value="${charts[1].type}">
              <input type="hidden" id ="is3d_1" value="${charts[1].is3d}">
              <input type="hidden" id ="data_1" value="${charts[1].data}">
              </div>
            </td>
          </tr>
          <tr>
            <td >
               <div class="box">
              <h2>${charts[2].title}</h2>
              <div class="utils"></div>
              <div id="chart_2" style="width: 700px; height: 400px;"></div>
              <input type="hidden" id ="type_2" value="${charts[2].type}">
              <input type="hidden" id ="is3d_2" value="${charts[2].is3d}">
              <input type="hidden" id ="data_2" value="${charts[2].data}">
              </div>
            </td>
            <td>
               <div class="box" >
               <h2>DISPONIBILIDAD</h2>
               <div class="utils"></div>
               <div  style="width: 600px; height: 392px;">
                  <div class="kpiDisplay">
                    <span class="kpiWhat">% Disponiblidad: </span>
                    <span class="kpiVal colorCoded">${availabilityKpi.availability}</span>
                  </div>
                 <div class="kpiDisplay">
                    <span class="kpiWhat">% Tickets solucionados en tiempo: </span>
                    <span><span class="kpiVal colorCoded">${availabilityKpi.onTimeResolvedTickets}</span></span>
                  </div>
                  <div class="kpiDisplay">
                    <span class="kpiWhat">% Tickets atendidos en tiempo: </span>
                    <span><span class="kpiVal colorCoded">${availabilityKpi.onTimeAttendedTickets}</span></span>
                  </div>
                   <div class="kpiDisplay">
                    <span class="kpiWhat">Tiempo promedio de solucion (hrs): </span>
                    <span class="kpiVal">${availabilityKpi.solutionAverageTime}</span>
                  </div>
                  <div class="kpiDisplay">
                    <span class="kpiWhat">Numero de tickets recibidos: </span>
                    <span class="kpiVal">${availabilityKpi.totalTickets}</span>
                  </div>
              </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
</body>
</html>
   
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
          options = {colors: ['#2E51DB']};
    	  }  else if ($('#type_' + i).val() == 'donut'){
    		   chart = new google.visualization.PieChart(document.getElementById('chart_' + i));
    		   options = {legend: {position: 'right', alignment: 'center'},
  		       		      chartArea:{left:50,top:10,width:"100%", height:"100%"},
  		       		      is3D: $('#is3d_' + i).val(),
    		        		  pieHole: 0.4,
                      colors: ['#F2E15C', '#109618', '#ff9900', '#ED4F37']};
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

      // aplicacion de codigos de colores
      $(".colorCoded").each(function(){
        updateItemColorDisplay(this);
      });
   });

  function updateItemColorDisplay(item){
    var numberStr= $(item).text();
    var value = parseFloat(numberStr);
    var green = "#109618";
    var orange = "#ff9900";

    // disponibilidad
    $(item).css("color", "#FFFFFF");

    if(value < 90){
      $(item).css("background-color", orange);
    }
    else{
      $(item).css("background-color", green);
    }
  }

  function timedRefresh(timeoutPeriod) {
  setTimeout("location.reload(true);",timeoutPeriod);
}
 </script>


     
	     
