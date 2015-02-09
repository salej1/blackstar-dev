          
           <!-- Signature capture box # 1 -->
            <div id="signCapDialog" title="Capture su firma en el cuadro" class="signBoxDlg">
              <div id="signCapture">
                <canvas class="signPad" width="330" height="115"></canvas>
                <input type="hidden" id="signCreatedCapture" class="output"/>
              </div>
            </div>
            
            <!-- Signature capture box # 2 -->
            <div id="signCapDialog2" title="Capture su firma en el cuadro" class="signBoxDlg">
              <div id="signCapture2">
                <canvas class="signPad" width="330" height="115"></canvas>
                <input type="hidden" id="signReceivedByCapture" class="output"/>
              </div>
            </div>

          <script src="${pageContext.request.contextPath}/js/jquery.signaturepad.min.js"></script>
          <script src="${pageContext.request.contextPath}/js/json2.min.js"></script> 
          <script type="text/javascript">
            function enableSignCapture(side){
                if(side == "left"){
                    $("#leftSign").bind("click", function(){
                      $('#signCapDialog').dialog('open');
                    });
                }
                else if(side == "right"){
                    $("#rightSign").bind("click", function(){
                      $('#signCapDialog2').dialog('open');
                    });
                }
            }

             $(document).ready(function () {
                // Signature drawign boxes click binding
                if("${mode}" == "new"){
                  enableSignCapture("left");
                  enableSignCapture("right");
                }
      
              // Signature drawing box # 1 
              var leftSignString = '${serviceOrder.signCreated}';
              var leftSign = $('#leftSign').signaturePad({displayOnly:true, lineWidth:0});
              if(leftSignString != null && leftSignString != ''){
                leftSign.regenerate(leftSignString);
              }
              // Signature drawing box # 2 
              var rightSignString = '${serviceOrder.signReceivedBy}';
              var rightSign = $('#rightSign').signaturePad({displayOnly:true, lineWidth:0});
              if(rightSignString != null && rightSignString != ''){
                rightSign.regenerate(rightSignString);
              }

               // Signature capture box # 1 
              $('#signCapture').signaturePad({drawOnly:true, lineWidth:0});
              $("#signCapDialog").dialog({
                autoOpen: false,
                height: 220,
                width: 370,
                modal: true,
                buttons: {
                  "Aceptar": function() {
                    $('#leftSign').signaturePad().regenerate($('#signCreatedCapture').val()); 
                    $( this ).dialog( "close" );
                  },
                  
                  "Borrar": function() {
                    $('#signCapture').signaturePad().clearCanvas(); 
                  },
                  
                  "Cancelar": function() {
                  $( this ).dialog( "close" );
                }}
              });
              
              // Signature capture box # 2 
              $('#signCapture2').signaturePad({drawOnly:true, lineWidth:0});
              $("#signCapDialog2").dialog({
                autoOpen: false,
                height: 220,
                width: 370,
                modal: true,
                buttons: {
                  "Aceptar": function() {
                    $('#rightSign').signaturePad().regenerate($('#signReceivedByCapture').val()); 
                    $( this ).dialog( "close" );
                  },
                  
                  "Borrar": function() {
                    $('#signCapture2').signaturePad().clearCanvas(); 
                  },
                  
                  "Cancelar": function() {
                  $( this ).dialog( "close" );
                }}
              });
              });
          </script>