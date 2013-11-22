<script type="text/javascript">

    var picker;
    
    function loadPicker() {
      gapi.load('picker', {'callback': createPicker});
    }

    function createPicker() {
      var attachmentFolderId = '${osAttachmentFolder}';
      var docsView = new google.picker.View(google.picker.ViewId.DOCS_IMAGES);
      var uploadView = new google.picker.DocsUploadView().setParent(attachmentFolderId);
      docsView.setParent(attachmentFolderId);
      picker = new google.picker.PickerBuilder()
          .setAppId("salej1-blackstar-dev")
          .addView(docsView)
          .addView(uploadView)
          .setCallback(pickerCallback)
          .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
          .build();
    }

    function showPicker(){
    	picker.setVisible(true);
    }
    
    function pickerCallback(data) {
      if (data.action == google.picker.Action.PICKED) {
        for(var i = 0 ; i < data.docs.length; i++){
        	window.open('https://docs.google.com/file/d/' + data.docs[i].id);	
        }
      }
    }
    </script>
    

<table id="attachments">
   <thead>
	   <tr>
		  <th>Archivos Adjuntos</th>
	   </tr>
    </thead>
	<tbody>
		<tr>
			<td id="imgPH"></td>
		</tr>
		<tr>
			<td colspan="2"><button class="searchButton" onclick="showPicker();">Archivos Adjuntos</button></td>
		</tr>
	</tbody>
</table>

<div id="result"></div>

    <!-- The Google API Loader script. -->
    <script type="text/javascript" src="https://apis.google.com/js/api.js?onload=loadPicker"></script>