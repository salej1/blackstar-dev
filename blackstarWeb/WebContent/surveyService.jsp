<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:import url="header.jsp"></c:import>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="js/jquery-1.10.1.min.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.ui.touch-punch.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.signature.min.js"></script>
<script src="${pageContext.request.contextPath}/js/surveyValidations/validations.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.datetimepicker.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.signature.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.datetimepicker.css">


<title>Encuesta de servicio</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">
	<form:form  commandName="surveyService" action="save.do" method="POST">			 
	  <div><h2>Encuesta de servicio</h2>
				  <p>Llenar por persona responsable del departamento</p>
				  <table width="608" border="1">
                    <tr>
                      <c:set var="cat" value="${readOnlyOrInsert}"/>                      
                      <c:set var="data" value="${surveyServiceData}"/>
                      <c:out value="${data.company}"></c:out>
                      <td width="89">Empresa</td>
                    	<c:choose>
                         	<c:when test="${cat=='false'}">
                            	<td><form:input path="company" type="text" style="width:100%;"/></td>
                    	 	</c:when>    
    						<c:otherwise>
                           		<td><form:input path="company" type="text" style="width:100%;" readonly="true" value="${data.company}"/></td>
                        	</c:otherwise>
                    	</c:choose>
				    </tr>
                    <tr>
                      <td>Nombre</td>
                      	<c:choose>
                         	<c:when test="${cat=='false'}">
                            	<td><form:input path="name" type="text" style="width:50%;"/></td>
                    	 	</c:when>    
    						<c:otherwise>
                           		<td><form:input path="name" type="text" style="width:50%;" readonly="true" value="${data.name}"/></td>
                        	</c:otherwise>
                    	</c:choose>
                    	
					  <td>Telefono</td>
					  	<c:choose>
                         	<c:when test="${cat=='false'}">
                            	 <td><form:input path="telephone" type="text" style="width:50%;"/></td>
                    	 	</c:when>    
    						<c:otherwise>
                           		 <td><form:input path="telephone" type="text" style="width:50%;" readonly="true" value="${data.telephone}"/></td>
                        	</c:otherwise>
                    	</c:choose>
                    	
                    </tr>
                    <tr>
                      <td>Correo electronico </td>
                      	<c:choose>
                         	<c:when test="${cat=='false'}">
                            	 <td><form:input path="email" type="text" style="width:50%;"/></td>
                    	 	</c:when>    
    						<c:otherwise>
                           		 <td><form:input path="email" type="text" style="width:50%;" readonly="true" value="${data.email}"/></td>
                        	</c:otherwise>
                    	</c:choose>
					  <td>Fecha </td>
					  <c:choose>
                         	<c:when test="${cat=='false'}">
                            	<td>
                      	 			<form:input path="date" type="text" style="width:50%;"/>
                      			</td>
                    	 	</c:when>    
    						<c:otherwise>
                           		 <td>
                      	 			<form:input path="date" type="text" style="width:50%;" readonly="true" value="${data.date}"/>
                      			</td>
                        	</c:otherwise>
                    	</c:choose>
                     
                    </tr>
                  </table>
				<div style="color:#0000FF">
				  <p>Encuesta de satisfaccion del servicio</p></div>
				  <p class="Estilo1">¿Como valora el trato recibido por parte de nuestros ?</p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Bueno
                         	<c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionTreatment" value="Bueno"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionTreatment=='Bueno'}">
                      				<input type="radio" value="${data.questionTreatment}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionTreatment!='Bueno'}">
                      				<input type="radio" value="Bueno" disabled/>
                      			</c:if>
                      		</c:if>		
                      		
                      </td>
                      <td>       
                      Malo
                      <c:if test="${cat=='false'}">
                          <form:radiobutton path="questionTreatment" value="Malo"/>
                      </c:if>
                       <c:if test="${cat=='true'}">
                       		<c:if test="${data.questionTreatment=='Malo'}">
                       		 	<input type="radio" value="${data.questionTreatment}" checked disabled/>
                       		</c:if>
                       		<c:if test="${data.questionTreatment!='Malo'}">
                       		 	<input type="radio" value="Malo" disabled/>
                       		</c:if>
                      </c:if>
                      </td>
                      <td><span class="Estilo1">Por que?</span></td>
                      <td><input type="text" name="reasontreatment"></td>
                    </tr>
                  </table>
				  <p class="Estilo1">¿Nuestro personal se identifico como colaborador de nuestra empresa? </p>
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      		<c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionIdentificationPersonal" value="Si"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionIdentificationPersonal=='Si'}">
                      				<input type="radio" value="${data.questionIdentificationPersonal}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionIdentificationPersonal!='Si'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	
                      </td>
                      <td>No
                      	<c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionIdentificationPersonal" value="No"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionIdentificationPersonal=='No'}">
                      				<input type="radio" value="${data.questionIdentificationPersonal}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionIdentificationPersonal!='No'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	
                      </td>
                      <td>
                    </tr>
                  </table>
				  <p class="Estilo1">¿Considera que nos presentamos con el equipo adecuado de protección y la herramienta necesaria para la realizacion de nuestro trabajo? </p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      <c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionIdealEquipment" value="Si"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionIdealEquipment=='Si'}">
                      				<input type="radio" value="${data.questionIdealEquipment}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionIdealEquipment!='Si'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	 
                     </td>
                      <td>                        No
                      <c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionIdealEquipment" value="No"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionIdealEquipment=='No'}">
                      				<input type="radio" value="${data.questionIdealEquipment}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionIdealEquipment!='No'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	
                      </td>
                      <td>                        Por que?</td>
                      <td><input type="text" name="reasonIdealEquipment"></td>
                    </tr>
                  </table>
				
			    <p>Nuestro personal se presento a su cita de acuerdo al tiempo previamente acordado? </p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      <c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionTime" value="Si"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionTime=='Si'}">
                      				<input type="radio" value="${data.questionTime}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionTime!='Si'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	 
 					</td>
                      <td>                        No
                      
                      <c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionTime" value="No"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionTime=='No'}">
                      				<input type="radio" value="${data.questionTime}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionTime!='No'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	
					</td>
                      <td>                        Por que?</td>
                      <td><input type="text" name="reasonTime"></td>
                    </tr>
                  </table>
				  <p>&nbsp;</p>
				  <p>¿Nuestro personal se presento con el uniforme de la empresa? </p>
				  
				  <table width="421" border="1">
                    <tr>
                      <td>Si
                      
                      <c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionUniform" value="Si"/>
                      		</c:if>
                      		<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       			<c:if test="${data.questionUniform=='Si'}">
                      				<input type="radio" value="${data.questionUniform}" checked disabled/>
                      			</c:if>
                      			<c:if test="${data.questionUniform!='Si'}">
                      				<input type="radio" value="Si" disabled/>
                      			</c:if>
                      		</c:if>	 
					</td>
                      <td>                        No
                      
                       <c:if test="${cat=='false'}">                        
                      			<form:radiobutton path="questionUniform" value="No"/>
                      	</c:if>
                      	<c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       		<c:if test="${data.questionUniform=='No'}">
                      			<input type="radio" value="${data.questionUniform}" checked disabled/>
                      		</c:if>
                      		<c:if test="${data.questionUniform!='No'}">
                      			<input type="radio" value="Si" disabled/>
                      		</c:if>
                      	</c:if>	
					</td>
                      <td>                        Por que?</td>
                      <td><input type="text" name="reasonUniform"></td>
                    </tr>
                  </table>
				  
				  <p>&nbsp;</p>
				  <p>¿Cual es su nivel de satisfacción respecto a la atencion brindada por nuestro personal en general?</p>
				  <p>
				  <c:if test="${cat=='false'}">  
					    <select name="qualification" id="qualification">
					      <option value="10">10 - Excelente</option>
				        </select>	
			       </c:if>	
			      <c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
			      	<select name="qualification" id="qualification" disabled>
					      <option value="10">10 - Excelente</option>
				    </select>
			      </c:if>
			        	        
				<p></p>
				  Firma:     
				  <div id="leftSign" class="signBox" onclick="$('#signCapDialog').dialog('open');"></div>
				  				  
				  <p  style="color:#0000FF">Sugerencias y comentarios</p>
				  <p>
				  <c:if test="${cat=='false'}">
				  		<textarea name="suggestion" cols="150" rows="8"></textarea>
				  </c:if>
				  
				  <c:if test="${cat=='true'}">
				  		<form:input path="suggestion" type="text" style="width:100%;" readonly="true" value="${data.suggestion}"/>
				  		
				  </c:if>
				  
				   
				  </p>
				  <p>&nbsp; </p>
				  <p>&nbsp;</p>
		
				<div align="left">
				Ordenes de servicio:
				 <c:if test="${cat=='false'}">                        
                      	<select name="serviceOrderId" id="serviceOrderId">
	                       <c:forEach var="cat" items="${surveyServiceList}">
	                         <option value="${cat.serviceOrderId}">
	                         <c:out value="${cat.serviceOrderNumber}"/>
	                         </option>
	                       </c:forEach>
	                   </select> 
                  </c:if>
                  
                  
                  <c:if test="${cat=='true'}"><!-- Opcion solo consulta readOnly -->
                       	<select name="serviceOrderId" id="serviceOrderId" disabled>
	                       <c:forEach var="cat" items="${surveyServiceList}">
	                         <option value="${cat.serviceOrderId}">
	                         <c:out value="${cat.serviceOrderNumber}"/>
	                         </option>
	                       </c:forEach>
	                   </select> 
                  </c:if>	
                      	
                      	
					<!-- Ordenes de servicio:
				        <c:catch var ="catchException">
				        <select name="serviceOrderId" id="serviceOrderId">
	                       <c:forEach var="cat" items="${surveyServiceList}">
	                         <option value="${cat.serviceOrderId}">
	                         <c:out value="${cat.serviceOrderNumber}"/>
	                         </option>
	                       </c:forEach>
	                   </select>    
				        </c:catch>
				        
				        
				        <c:if test = "${catchException!=null}">
							The exception is : ${catchException}<br><br>
							There is an exception: ${catchException.message}<br>
						</c:if>	-->
				</div>			
				 <div align="right"><input  class="searchButton" type="submit" value="Guardar" id="guardar"/></div>
	    <p>&nbsp;</p>
				    <p><br>
		                          </p>
		                          					
						
					<!-- Signature capture box # 1 -->
					<form:hidden path="sign"/>
					<hidden id="rightSignJSON"/></hidden>
					<div id="signCapDialog" title="Capture su firma en el cuadro" class="signBoxDlg">
						<div id="sign">
						</div>
					</div>
						
						
	  		</div>
		</form:form>	
		</div>
</body>
</html>