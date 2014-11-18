<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="encuestas" />
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
<script src="${pageContext.request.contextPath}/js/dateFormat.js"></script>
<script src="${pageContext.request.contextPath}/js/customAutocomplete.js"></script>
<script src="${pageContext.request.contextPath}/js/moment.min.js"></script>

<script type="text/javascript">
    
    $(function(){
       // ocultando el mensaje de error
       $(".info").hide();

        // Sincronizando los campos de firma
        $("#surveyService").submit(function(){
          $("#sign").val($("#signReceivedByCapture").val())
        });

        $("#date").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){$(this).val(date+" 00:00:00")}});
        // bloqueando campos
        var mode = "${mode}";
        if(mode == "new"){
          $("#serviceOrderList").bind("blur", function(){
            var custData = $.getJSON("/surveyServiceDetail/getOsDetailsJson.do?osList=" + $(this).val(), function(data){
                if(data.error != null) {
                  $(".info").show();
                  $("#serviceOrderList").select();
                }
                else{
                  $(".info").hide();
                  $("#company").val(data.company);
                  $("#name").val(data.name);
                  $("#phone").val(data.phone);
                  $("#email").val(data.email);
                  $("#date").val(new Date(data.serviceDate).format('dd/MM/yyyy hh:mm:ss'));
                }
            });
          });
        }
        else{
          $(".lockOnDetail").attr("disabled", "");
        }

        // Signature drawing box # 2 
        var rightSignString = '${surveyService.sign}';
        var rightSign = $('#rightSign').signaturePad({displayOnly:true, lineWidth:0});
        if(rightSignString != null && rightSignString != ''){
          rightSign.regenerate(rightSignString);
        }

        // inicializando autocompletar
        $.get("${pageContext.request.contextPath}/serviceOrders/getServiceOrderListJson.do?startDate=" + moment().add('days', -3).format('DD/MM/YYYY HH:mm:ss'),
         function(data){
          if(data != "error"){
            init_autoComplete(data, "serviceOrderList", "serviceOrderIdList");           
          }
        });

        // Mensaje de error
        $( "#InvalidMessage" ).dialog({
          modal: true,
          autoOpen: false,
          width: 350,
          buttons: {
            Aceptar: function() {
              $( this ).dialog( "close" );
            }
          }
        });

         $( "#flagSuggestionDlg" ).dialog({
          modal: true,
          autoOpen: false,
          width: 350,
          buttons: {
            Positivo: function() {
              sendSuggestionFlag(1);
              $( this ).dialog( "close" );
              location.reload();
            },
            Negativo: function(){
              sendSuggestionFlag(0);
              $( this ).dialog( "close" );
              location.reload();
            },
            Cancelar: function(){
              $( this ).dialog( "close" );
            }
          }
        });
    });

    function sendSuggestionFlag(flag){
        $.ajax("${pageContext.request.contextPath}/surveyServiceDetail/flagSuggestion.do?surveyId=${surveyService.surveyServiceId}&flag=" + flag, function(response){
          location.reload();
        });
    }

    function addSuggestionFlag(){
        $("#flagSuggestionDlg").dialog("open");
    }

    function validate(){
        var timeStamp = Date.parseExact($("#date").val(), 'dd/MM/yyyy HH:mm:ss');
        if(timeStamp == undefined || timeStamp == null){
          $("#InvalidMessage").html("Por favor revise la fecha y hora de la encuesta");
          return false;
        }
        else{
          if($('#surveyService')[0].checkValidity()){
           
            return true;
          }
        }
    }

    function saveSurvey(){
        if(validate()){
           $("#surveyService").submit();
        }
        else{
          $( "#InvalidMessage" ).dialog('open');
        }
    }
</script>
<title>Encuesta de servicio</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">
	<form:form  commandName="surveyService" action="save.do" method="POST">			
	  <div>
          <h2>Encuesta de servicio</h2>
				  <p>Llenar por persona responsable del departamento</p>
          <div>
             Ordenes de servicio:
             <form:input path="serviceOrderList" type="text" style="width:50%;" cssClass="lockOnDetail" required="true"/>
             <input type="hidden" id="serviceOrderIdList"/>
             <div class="info" style="width:200px;margin-left:116px;">Por favor verifique la Orden de servicio</div>
          </div>

				  <table>
                <tr>
                  <td style="width:90px">Empresa</td>
                  <td><form:input path="company" type="text" style="width:95%;" cssClass="lockOnDetail" readOnly="true" required="true"/></td>
		            </tr>
                <tr>
                  <td>Nombre</td>
                  <td><form:input path="name" type="text" style="width:95%;" cssClass="lockOnDetail" readOnly="true" required="true"/></td>
			            <td>Telefono</td>
                  <td><form:input path="phone" type="text" style="width:95%;" cssClass="lockOnDetail" readOnly="true" required="true"/></td>
                </tr>
                <tr>
                  <td>Correo electronico </td>
                  <td><form:input path="email" type="text" style="width:95%;" cssClass="lockOnDetail" readOnly="true" required="true"/></td>
                  <td>Fecha </td>
                  <td><form:input path="date" type="text" style="width:95%;" cssClass="lockOnDetail" required="true"/>
			            </td>
                </tr>
              </table>
  				<div>
  				  <p>Encuesta de satisfaccion del servicio</p>
          </div>
				  <p></p>
          <table>
              <thead>
                  <tr>
                    <td colspan="4">Encuesta de satisfaccion del servicio</td>
                  </tr>
              </thead>
              <tbody>
                  <tr>
                      <td colspan="3">¿Como valora el trato recibido por parte de nuestros ?</td>
                  </tr>
                  <tr>
                    <td>Bueno<form:radiobutton path="questionTreatment" value="1" cssClass="lockOnDetail"/></td>
                    <td>Malo<form:radiobutton path="questionTreatment" value="0" cssClass="lockOnDetail"/></td></td>
                    <td>Por que? <form:input path="reasonTreatment" type="text" style="width:80%;" cssClass="lockOnDetail"/></td>
                    <td> 
                  </tr> 
                  <tr>
                      <td colspan="3">¿Nuestro personal se identifico como colaborador de nuestra empresa? </td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionIdentificationPersonal" value="1" cssClass="lockOnDetail"/></td>
                      <td>No<form:radiobutton path="questionIdentificationPersonal" value="0" cssClass="lockOnDetail"/></td>
                      <td></td>
                  </tr>
                  <tr>
                      <td colspan="3">¿Considera que nos presentamos con el equipo adecuado de protección y la herramienta necesaria para la realizacion de nuestro trabajo? </td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionIdealEquipment" value="1" cssClass="lockOnDetail"/></td>
                      <td>No<form:radiobutton path="questionIdealEquipment" value="0" cssClass="lockOnDetail"/></td>
                      <td>Por que?<form:input path="reasonIdealEquipment" type="text"  style="width:80%;" cssClass="lockOnDetail"/></td>
                  </tr>
                  <tr>
                      <td colspan="3">Nuestro personal se presento a su cita de acuerdo al tiempo previamente acordado?</td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionTime" value="1" cssClass="lockOnDetail"/></td>
                      <td>No<form:radiobutton path="questionTime" value="0" cssClass="lockOnDetail"/></td>
                      <td>Por que?<form:input path="reasonTime" type="text" style="width:80%;" cssClass="lockOnDetail"/></td>
                  </tr>
                  <tr>
                      <td colspan="3">¿Nuestro personal se presento con el uniforme de la empresa?</td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionUniform" value="1" cssClass="lockOnDetail"/></td>
                      <td>No<form:radiobutton path="questionUniform" value="0" cssClass="lockOnDetail"/></td>
                      <td> Por que?<form:input path="reasonUniform" type="text"  style="width:80%;" cssClass="lockOnDetail"/></td>
                  </tr>
                  <tr>
                      <td colspan="3">¿Cual es su nivel de satisfacción respecto a la atencion brindada por nuestro personal en general?</td>
                  </tr>
                  <tr>
                      <td><form:select path="score" items="${surveyQualificationList}" cssClass="lockOnDetail"/></td>
                  </tr>
              </tbody>
          </table>
				 <span>Firma</span>
          <div id="rightSign" class="signBox">
            <canvas class="signPad" width="330" height="115"></canvas>
          </div>
         <div style="height=25px;"></div>
				  				  
				  <p>Sugerencias y comentarios</p>
				  <p>
              <form:textarea path="suggestion" cols="150" rows="8" cssClass="lockOnDetail"></form:textarea>
          <div style="margin-bottom:10px;" >
            <c:choose>
              <c:when test="${surveyService.suggestionFlag != null}">
                Calificación de Comentarios: 
                <c:choose>
                  <c:when test="${surveyService.suggestionFlag == 1}">
                    <img src="/img/sucess.png"> Positivos
                  </c:when>
                  <c:otherwise>
                    <img src="/img/warning.png"> Negativos
                  </c:otherwise>
                </c:choose>
              </c:when>
              <c:otherwise>
                <c:if test="${surveyService.suggestionFlag == null && (user.belongsToGroup['Call Center'] || user.belongsToGroup['Calidad'])}">
                  <input class="searchButton" type="submit" onclick="addSuggestionFlag(); return false;" value="Calificar comentarios" id="flagSuggestion"/>
                </c:if>
              </c:otherwise>
            </c:choose>
          </div>

				 <div align="left"><input class="searchButton lockOnDetail" type="submit" onclick="saveSurvey(); return false;" value="Guardar Encuesta" id="guardar"/></div>
	  		</div>
        <!-- Campos de firma -->
          <form:hidden path="sign"/>
		</form:form>	

      <!-- Fragmento de Firma -->
      <c:import url="signatureFragment.jsp"></c:import>

		</div>
    <div id="InvalidMessage" title="Revise los datos de la OS">
      Por favor revise que todos los campos hayan sido llenados.
    </div>

    <div id="flagSuggestionDlg" title="Calificar comentario"> 
      Por favor califique el comentario:
    </div>
</body>
</html>