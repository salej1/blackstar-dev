<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<script type="text/javascript">

    var picker;
    var deliverableTypes = { };
    <c:forEach var="deliverableType" items="${deliverableTypes}">
        deliverableTypes["${deliverableType.id}"] = "${deliverableType.name}";
    </c:forEach>
    
    function loadPicker() {
      gapi.load('picker', {'callback': createPicker});
    }

    function createPicker() {
      var attachmentFolderId = '${osAttachmentFolder}';
      var docsView = new google.picker.View(google.picker.ViewId.DOCS);
      var uploadView = new google.picker.DocsUploadView().setParent(attachmentFolderId);
      docsView.setParent(attachmentFolderId);
      var pickerBuilder = new google.picker.PickerBuilder()
          .addView(docsView)
          .addView(uploadView)
          .setOAuthToken('${accessToken}');
      pickerBuilder.setCallback(pickerCallback);
      picker = pickerBuilder.build();
    }

    function showPicker(){
    	picker.setVisible(true);
    }
    
    function pickerCallback(data) {
      if (data.action == google.picker.Action.PICKED) {
        if(data.docs.length > 0){
          $("#documentId").val(data.docs[0].id);
          $("#deliverableDlg").dialog('open');
        }
      }
    }

    function advanceDeliverable(deliverableTypeId){
        // Validation
        if(deliverableTypeId <0 || deliverableTypeId > 10){
            throw "Invalid deliverable type " + deliverableTypeId;
            return;
        }

        $("#deliverableTypeId").val(deliverableTypeId);
        var deliverableType = deliverableTypes[$("#deliverableTypeId").val()];
        $("#deliverableType").val(deliverableType);

        // Orden de compra
        if(deliverableTypeId == 4){
            // capturar RFC del Cliente
            // cargar orden de compra
            showPicker();
        } else if(deliverableTypeId == 6 || deliverableTypeId == 10){  // Factura o Attachment
            // cargar factura
            $("#deliverableTraceForm").attr("action", "/codex/project/addDeliverableTrace.do");
            showPicker();
        } else if(deliverableTypeId == 8){  // Carta de termino
            // verificar si hay al menos una factura cargada
            // cargar carta de termino
            showPicker();
        }  else { // Avance sin attachment, solo mover status
            $("#WaitMessage").dialog('open');
            $("#deliverableTraceForm").submit();
        }
    }

    function init_projectDeliverables(){
      //Attachment dialog
      $("#deliverableDlg").dialog({
        autoOpen: false,
        height: 270,
        width: 450,
        modal: true,
        buttons: {
          "Aceptar": function() {
            $('#deliverableDlg').dialog('close');
            $('#WaitMessage').dialog('open');
            $("#deliverableTraceForm").submit();
          },
          "Cancelar" : function(){
            $('#deliverableDlg').dialog('close');
          }
        }
      });
    }
    
    </script>
    
<table id="deliverablesTable">
  <thead>
       <tr>
          <th colspan="5">Historial</th>
       </tr>
  </thead>
  <c:forEach var="current" items="${deliverables}" >
     <tr class="comment">
        <td style="width:20%">
           <strong>${current.deliverableTypeDescription}</strong>
        </td>
        <td style="width:20%">${current.userName}</td>
        <td style="width:20%">${current.created}</td>
        <td style="width:20%">${current.documentName}</td>
        <td style="width:20%">
        <c:if test="${current.documentId != null}">
            <a href='https://docs.google.com/a/gposac.com.mx/file/d/${current.documentId}/edit' target='_blank'><img src='${pageContext.request.contextPath}/img/pdf.png'/></a>
        </c:if>
        </td>
    </tr>
  </c:forEach>
</table>
<br>
<button class="searchButton" onclick="advanceDeliverable(10); return false;">Adjuntar Archivo</button>

<!-- Attachment callback section -->
<div id="deliverableDlg" title="Adjuntar archivo">
  <br>
    <form id="deliverableTraceForm" action="/codex/project/advanceStatus.do" method="GET">
        <div style="margin:10px">Nombre del archivo: <input id="documentName" name="documentName" size="75"/> </div>
        
        <div style="margin:10px">Tipo de adjunto: <input type="text" id="deliverableType" size="75" readonly/></div>
        <input type="hidden" id="deliverableTypeId" name="deliverableTypeId"/>
        <input type="hidden" id="projectId" name="projectId" value="${project.id}"/>
        <input type="hidden" id="projectNumber" name="projectNumber" value="${project.projectNumber}"/>
        <input type="hidden" id="documentId" name="documentId"/>
    </form>
</div>  

    <!-- The Google API Loader script. -->
    <script type="text/javascript" src="https://apis.google.com/js/api.js?onload=loadPicker"></script>