<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false"%>

<script>

  $(document).ready(function () {
	  $("#seguimientoCapture").hide();
  });

   function addSeguimiento(type){
	 var d = new Date(); 
	 $("#seguimientoCapture").show();	
	 $("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' ${ user.userName }');
	 $("#seguimientoText").val('');
	 $("#who").val("-1");
	 followType = type;
	 if(type == "1"){
		$("#assignamentArea").show();
	 } else {
		$("#assignamentArea").hide(); 
	 }
  }

  function applySeguimiento(){
    var who;
	if(followType == "1"){
		who = $("#who").val();
	} else if(followType == "2"){
		who = "-2";
	}else { 
		who = "-3";
	}
	$("#followDetail").load("${pageContext.request.contextPath}/codex/project/addFollow.do?projectId=${project.id}&userId=${ user.blackstarUserId }" 
			                    + "&userToAssign=" + who + "&comment=" + $("#seguimientoText").val().replace(/ /g, '%20'));
	$("#seguimientoCapture").hide();	
  }

  function cancelAddSeguimiento(){
	$("#seguimientoCapture").hide();
  }

</script>

							<!-- Seguimiento -->
							<table id="seguimientoTable">
								<thead>
									<th>Seguimiento</th>
								</thead>
									<tr>
										<td id="seguimientoContent">
										</td>
									</tr>
									<tr>
									    <td id="followDetail">
									       <c:import url="_follow.jsp"></c:import>
									    </td>
									</tr>
									<tr>
										<td id="seguimientoCapture" class="comment">
											<div>
												<Label id="seguimientoStamp">stamp</Label>
											</div>
											<div> 
											   <div id="assignamentArea">
											     Asignar a:
												  <select id="who" style="width:200px;">
												    <option value="-1">Seleccione</option>
												    <c:forEach var="current" items="${staff}" >
												       <option value="${current.id}">${current.name}</option>
												    </c:forEach>
												  </select>
												<p></p>
												</div>
												<textarea id="seguimientoText" rows="5" style="width:65%;"></textarea>
												<button class="searchButton" onclick="applySeguimiento();">Agregar</button>
												<button class="searchButton" onclick="cancelAddSeguimiento();">Cancelar</button>
											</div>
										</td>
									</tr>
							</table>

							<!-- Botones para seguimiento -->
							<table>
								<tbody>
									<tr>
										<td style="width: 100px;">
											<button class="searchButton" onclick="addSeguimiento(1);">Asignar</button>
										</td>
										<c:if test="${fn:length(followUps) > 0}">
											<td style="width: 100px;">
												<button class="searchButton" onclick="addSeguimiento(3);">Responder</button>
											</td>
										</c:if>
										<td style="width: 100px;">
											<button class="searchButton" onclick="addSeguimiento(2);">Comentar</button>
										</td>
										<td></td>
									</tr>
								<tbody>
							</table>

