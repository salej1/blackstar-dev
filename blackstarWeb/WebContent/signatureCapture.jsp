<div id="leftSign" class="signBox">
</div>
<div>
  <form method="post" action="" class="sigPad">
    <div class="sig sigWrapper signBox">
      <canvas class="pad" width="198" height="55"></canvas>
    </div>
  </form>
</div>
  
<div id="signCapDialog" title="Capture su firma en el cuadro" class="signBoxDlg">
  <div id="signCapture">
  </div>
</div>

<script src="http://static.thomasjbradley.ca/signature-pad/jquery.signaturepad.min.js"></script> <script>
<script type="text/javascript">

    function signatureCapture_init(drawingDiv, outField){
      var htmlTemplate = "";
      $('.sigPad').signaturePad({displayOnly:true})
    $("#signCapDialog").dialog({
                autoOpen: false,
                height: 220,
                width: 370,
                modal: true,
                buttons: {
                  "Aceptar": function() {
                    $('#leftSign').signaturePad('draw', $('#signCreated').val()); 
                    $( this ).dialog( "close" );
                  },
                  
                  "Borrar": function() {
                    $('#signCapture').signaturePad('clear'); 
                  },
                  
                  "Cancelar": function() {
                  $( this ).dialog( "close" );
                }}
              });

      $('#leftSign').signaturePad({disabled: true}); 

      $("#"+outfield).addClass("output");
      $("#"+outfield).attr("name", "output");
      $('.sigPad').signaturePad();
    }
</script>
<script src="http://static.thomasjbradley.ca/signature-pad/json2.min.js"></script> </div> <script>

