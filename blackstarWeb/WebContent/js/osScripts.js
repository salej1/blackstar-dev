
		function split( val ) {
	      return val.split( /,\s*/ );
	    }

	    function extractLast( term ) {
	      return split( term ).pop();
	    }

		
		$(document).ready(function () {
					
			// Asignacion de campos iniciales
			var mode = "${mode}";
			var hasPolicy =  "${hasPolicy}"
			
			if(mode == "detail"){
				$(".lockOnDetail").attr("disabled", "");
			}

			if(mode == "new"){
				$("#serviceDate").val(dateNow());
				$("#responsibleName").val("${ user.userName }");
				$("#responsible").val("${ user.userEmail }");

				init_autoComplete('${serviceEmployees}', "responsibleName", "responsible");

				// Habilitar datetime picker
				$("#serviceDate").datetimepicker({format:'d/m/Y H:i:s', lang:'es'});

				// Habilitando campos de captura del cliente
				if(hasPolicy == "true"){
					$(".lockOnPolicy").attr("disabled", "");
				}


				// Binding officeId
				$("#optOffices").bind('change', function(){
					$("#officeId").val($(this).val());
				});

				$("#officeId").val("G"); // valor inicial
			}

			// inicializando el dialogo para agregar seguimientos
			initFollowUpDlg("serviceOrder", "osDetail?serviceOrderId=${serviceOrder.serviceOrderId}");

		});

		function isNumberKey(evt){
		     var charCode = (evt.which) ? evt.which : event.keyCode;
	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
	            return false;
	         }

	         return true;
		}
		
		function saveService(){
			var startTimestamp = new Date($("#serviceDate").val());
			if(startTimestamp == undefined || startTimestamp == null){
				$("#serviceDate").val("");
			}
			
			if($('#serviceOrder')[0].checkValidity()){
				$('input').removeAttr("disabled");
				$('select').removeAttr("disabled");
				$('textarea').removeAttr("disabled");
				if($("#responsible").val().indexOf(';') == 0){
					$("#responsible").val($("#responsible").val().substring(1));
				}
				$("#signCreated").val($("#signCreatedCapture").val())
				$("#signReceivedBy").val($("#signReceivedByCapture").val())
				$("#serviceEndDate").val(dateNow());
				$('#serviceOrder').submit();
			}
			else{
				setTimeout(function() { $(event.target).focus();}, 50);
			}
		}
		
		function isNumberKey(evt){
		     var charCode = (evt.which) ? evt.which : event.keyCode;
	         if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
	            return false;
	         }

	         return true;
		}
		