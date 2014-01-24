<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/jquery.ui.theme.css"/>
<link rel="stylesheet" href="css/jquery-ui.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.signature.css">
<script src="js/jquery-1.10.1.min.js"></script>
<script src="js/jquery-ui.js"></script>

<script type="text/javascript" charset="utf-8">
function guardarInformacion()
{
     alert('La información se guardo exitosamente');
     //document.formSurveyService.submit() ;
}
</script>
 
<title>Encuesta de servicio</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">
	<form:form  commandName="surveyService" action="save.do" method="POST">			 
	  <div><h2>Encuesta de servicio</h2>
				  <p>Llenar por persona responsable del departamento</p>
				  <table width="608" border="1">
                    <tr>
                      <td width="89">Empresa</td>
                      <td width="153"><input type="text" name="company" size="80"></td>
				    </tr>
                    <tr>
                      <td>Nombre</td>
                      <td><input type="text" name="name"></td>
					  <td>Telefono</td>
           			  <td width="277"><input type="text" name="telephone"></td>
                    </tr>
                    <tr>
                      <td>Correo electronico </td>
                      <td><input type="text" name="email"></td>
					  <td>Fecha </td>
                      <td><input type="text" name="date" /></td>
                    </tr>
                  </table>
				<div style="color:#0000FF">
				  <p>Encuesta de satisfaccion del servicio</p></div>
				  <p class="Estilo1">ï¿½como valora el trato recibido por parte de nuestros ?</p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Bueno
                      <input type="checkbox" name="lQuestionTreatment" value="checkbox"></td>
                      <td>                        Malo</span>
                      <input type="checkbox" name="lQuestionTreatment" value="checkbox"></td>
                      <td><span class="Estilo1">Por que?</span></td>
                      <td><input type="text" name="reasontreatment"></td>
                    </tr>
                  </table>
				  <p class="Estilo1">¿Nuestro personal se identifico como colaborador de nuestra empresa? </p>
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      <input type="checkbox" name="lQuestionIdentificationPersonal" value="checkbox"></td>
                      <td>                        No
                      <input type="checkbox" name="lQuestionIdentificationPersonal" value="checkbox"></td>
                      <td>
                    </tr>
                  </table>
				  <p class="Estilo1">¿Considera que nos presentamos con el equipo adecuado de protección y la herramienta necesaria para la realizacion de nuestro trabajo? </p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      <input type="checkbox" name="lQuestionIdealEquiment" value="checkbox"></td>
                      <td>                        No
                      <input type="checkbox" name="lQuestionIdealEquiment" value="checkbox"></td>
                      <td>                        Por que?</td>
                      <td><input type="text" name="reasonIdealEquipment"></td>
                    </tr>
                  </table>
				
			    <p>Nuestro personal se presento a su cita de acuerdo al tiempo previamente acordado? </p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      <input type="checkbox" name="lQuestionTime" value="checkbox"></td>
                      <td>                        No
                      <input type="checkbox" name="lQuestionTime" value="checkbox"></td>
                      <td>                        Por que?</td>
                      <td><input type="text" name="reasonTime"></td>
                    </tr>
                  </table>
				  <p>&nbsp;</p>
				  <p>¿Nuestro personal se presento con el uniforme de la empresa? </p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      <input type="checkbox" name="lQuestionUniform" value="checkbox"></td>
                      <td>                        No
                      <input type="checkbox" name="lQuestionUniform" value="checkbox"></td>
                      <td>                        Por que?</td>
                      <td><input type="text" name="reasonUniform"></td>
                    </tr>
                  </table>
				  
				  <p>&nbsp;</p>
				  <p>ï¿½Cual es su nivel de satisfacción respecto a la atencion brindada por nuestro personal en general?</p>
				  <p>
				    <select name="qualification" id="qualification">
				      <option value="10">10 - Excelente</option>
			        </select>
				  Firma <div id="sign" class="signBox">
						</div>
						
					
					
				  
				  <p class="Estilo2">Sugerencias y comentarios</p>
				  <p class="Estilo2">
				    <textarea name="suggestion" cols="150" rows="8"></textarea>
				  </p>
				  <p>&nbsp; </p>
				  <p>&nbsp;</p>
		
				 <div align="right"><input type="submit" value="Guardar" id="guardar"/></div>
	    <p>&nbsp;</p>
				    <p><br>
		                          </p>
	  		</div>
		</form:form>	
		</div>
</body>
</html>