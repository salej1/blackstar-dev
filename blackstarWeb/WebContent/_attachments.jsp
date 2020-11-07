<script type="text/javascript">

    var picker;
    
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
      if(customPickerCallBack == null){
    	  pickerBuilder.setCallback(pickerCallback);
      } else {
    	  pickerBuilder.setCallback(customPickerCallBack);
      }
      picker = pickerBuilder.build();
    }

    function showPicker(){
    	picker.setVisible(true);
    }
    
    function pickerCallback(data) {
      if (data.action == google.picker.Action.PICKED) {
        if(data.docs.length > 0){
          $("#pickedAttachmentId").val(data.docs[0].id);
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
<input type="hidden" id="pickedAttachmentId">

<div id="result"></div>

    <!-- The Google API Loader script. -->
    <script type="text/javascript" src="https://apis.google.com/js/api.js?onload=loadPicker"></script>