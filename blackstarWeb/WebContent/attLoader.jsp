<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<script type="text/javascript">

    var loaderPicker;
    var idField = "";
    var nameField = "";

    function attLoader_init(targetId, targetName){
      idField = targetId;
      nameField = targetName;
    }

    function loadlLoaderPicker() {
      gapi.load('picker', {'callback': createLoaderPicker});
    }

    function createLoaderPicker() {
      var rootFolderId = '${attachmentFolder}';
      var docsView = new google.picker.DocsView(google.picker.ViewId.PDFS)
        .setOwnedByMe(false)
        .setIncludeFolders(true) ;
      var uploadView = new google.picker.DocsUploadView().setParent(rootFolderId);
      loaderPicker = new google.picker.PickerBuilder()
          .addView(docsView)
          .addView(uploadView)
          .setCallback(loaderPickerCallback)
          .setOAuthToken('${accessToken}')
          .setLocale('es')
          .build();
    }

    function showLoaderPicker(){
    	loaderPicker.setVisible(true);
    }
    
    function loaderPickerCallback(data) {
      if (data.action == google.picker.Action.PICKED) {
        customPickerCallBack(data);
      }
    }
    </script>
    

<table id="attLoader">
   <thead>
	   <tr>
		  <th colspan="${fn:length(deliverableTrace)+1}">Archivos Adjuntos</th>
	   </tr>
    </thead>
	<tbody>
		<tr>
      <c:forEach items="${deliverableTrace}" var="item">
        <c:if test="${item.delivered}">
          <td style="width:80px;">
            <span style="display:block;text-align:center;"><a href="https://docs.google.com/a/gposac.com.mx/file/d/${item.docId}/edit" target="_blank"><img src="/img/readme.png">${item.name}</a></span>
          </td>
        </c:if>
      </c:forEach>
      <td></td>
		</tr>
		<tr>
			<td colspan="2"><button class="searchButton" onclick="showLoaderPicker();">Adjuntar Archivo</button></td>
		</tr>
	</tbody>
</table>

<div id="result"></div>

    <!-- The Google API Loader script. -->
    <script type="text/javascript" src="https://apis.google.com/js/api.js?onload=loadlLoaderPicker"></script>