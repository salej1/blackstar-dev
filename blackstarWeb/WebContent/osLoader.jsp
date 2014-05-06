<script type="text/javascript">

    var loaderPicker;
    var destField = "";

    function osLoader_init(target){
      destField = target;
    }

    function loadlLoaderPicker() {
      gapi.load('picker', {'callback': createLoaderPicker});
    }

    function createLoaderPicker() {
      var rootFolderId = '${rootFolder}';
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
        $("#" + destField).val(data.docs[0].id);
      }
    }
    </script>
    

<table id="osLoader">
   <thead>
	   <tr>
		  <th>Archivo de Orden de Servicio</th>
	   </tr>
    </thead>
	<tbody>
		<tr>
			<td id="imgPH"></td>
		</tr>
		<tr>
			<td colspan="2"><button class="searchButton" onclick="showLoaderPicker();">Cargar OS</button></td>
		</tr>
	</tbody>
</table>

<div id="result"></div>

    <!-- The Google API Loader script. -->
    <script type="text/javascript" src="https://apis.google.com/js/api.js?onload=loadlLoaderPicker"></script>