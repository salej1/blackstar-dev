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

<script type="text/javascript">
    $(function(){
       // Sincronizando los campos de firma
        $("#surveyService").submit(function(){
          $("#sign").val($("#signReceivedByCapture").val())
        });

        $("#date").datepicker({ dateFormat: 'dd/mm/yy', onSelect: function(date, obj){$(this).val(date+" 00:00:00")}});
        // bloqueando campos
        var mode = "${mode}";
        if(mode == "new"){
          $("#date").val(dateNow());
        }
        else{
          $("#company").attr("disabled", "");
          $("#name").attr("disabled", "");
          $("#phone").attr("disabled", "");
          $("#email").attr("disabled", "");
          $("#date").attr("disabled", "");
          $("#questionTreatment").attr("disabled", "");
          $("#reasonTreatment").attr("disabled", "");
          $("#questionIdentificationPersonal").attr("disabled", "");
          $("#questionIdealEquipment").attr("disabled", "");
          $("#reasonIdealEquipment").attr("disabled", "");
          $("#questionTime").attr("disabled", "");
          $("#reasonTime").attr("disabled", "");
          $("#questionUniform").attr("disabled", "");
          $("#reasonUniform").attr("disabled", "");
          $("#score").attr("disabled", "");
          $("#serviceOrderList").attr("disabled", "");
        }

        // Signature drawing box # 2 
        var rightSignString = '${surveyService.sign}';
        var rightSign = $('#rightSign').signaturePad({displayOnly:true, lineWidth:0});
        if(rightSignString != null && rightSignString != ''){
          rightSign.regenerate(rightSignString);
        }

    });
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
             <form:input path="serviceOrderList" type="text"/>
          </div>

				  <table>
                <tr>
                  <td>Empresa</td>
                  <td><form:input path="company" type="text" style="width:100%;"/></td>
		            </tr>
                <tr>
                  <td>Nombre</td>
                  <td><form:input path="name" type="text" style="width:50%;"/></td>
			            <td>Telefono</td>
                  <td><form:input path="phone" type="text" style="width:50%;"/></td>
                </tr>
                <tr>
                  <td>Correo electronico </td>
                  <td><form:input path="email" type="text" style="width:50%;"/></td>
                  <td>Fecha </td>
                  <td><form:input path="date" type="text" style="width:50%;"/>
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
                    <td>Bueno<form:radiobutton path="questionTreatment" value="1"/></td>
                    <td>Malo<form:radiobutton path="questionTreatment" value="0"/></td></td>
                    <td>Por que? <form:input path="reasonTreatment" type="text" style="width:80%;"/></td>
                    <td> 
                  </tr> 
                  <tr>
                      <td colspan="3">¿Nuestro personal se identifico como colaborador de nuestra empresa? </td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionIdentificationPersonal" value="1"/></td>
                      <td>No<form:radiobutton path="questionIdentificationPersonal" value="0"/></td>
                      <td></td>
                  </tr>
                  <tr>
                      <td colspan="3">¿Considera que nos presentamos con el equipo adecuado de protección y la herramienta necesaria para la realizacion de nuestro trabajo? </td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionIdealEquipment" value="1"/></td>
                      <td>No<form:radiobutton path="questionIdealEquipment" value="0"/></td>
                      <td>Por que?<form:input path="reasonIdealEquipment" type="text"  style="width:80%;"/></td>
                  </tr>
                  <tr>
                      <td colspan="3">Nuestro personal se presento a su cita de acuerdo al tiempo previamente acordado?</td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionTime" value="1"/></td>
                      <td>No<form:radiobutton path="questionTime" value="0"/></td>
                      <td>Por que?<form:input path="reasonTime" type="text" style="width:80%;"/></td>
                  </tr>
                  <tr>
                      <td colspan="3">¿Nuestro personal se presento con el uniforme de la empresa?</td>
                  </tr>
                  <tr>
                      <td>Si<form:radiobutton path="questionUniform" value="1"/></td>
                      <td>No<form:radiobutton path="questionUniform" value="0"/></td>
                      <td> Por que?<form:input path="reasonUniform" type="text"  style="width:80%;"/></td>
                  </tr>
                  <tr>
                      <td colspan="3">¿Cual es su nivel de satisfacción respecto a la atencion brindada por nuestro personal en general?</td>
                  </tr>
                  <tr>
                      <td><form:select path="score" items="${surveyQualificationList}" /></td>
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
              <form:textarea path="suggestion" cols="150" rows="8"></form:textarea>

				 <div align="right"><input  class="searchButton" type="submit" value="Guardar" id="guardar"/></div>
	  		</div>
        <!-- Campos de firma -->
          <form:hidden path="sign"/>
		</form:form>	

      <!-- Fragmento de Firma -->
      <c:import url="signatureFragment.jsp"></c:import>

		</div>
</body>
</html>