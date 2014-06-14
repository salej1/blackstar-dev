var listaProyectos;
var listaAreas;
var listaServicios;
var listaOficinas;

var serviceTypeId;
var applicantAreaId;

var diasLimitesTipoServicio=null;

var fechaLimite;

$(document)
		.ready(
				function() {

					var attCounter = 0;

					fechaLimite = new Date();

					$("#fldLimite").datepicker();
					$("#fldLimite").datepicker("setDate", new Date());

					// Attachment dialog
					$("#attachmentDlg").dialog({
						autoOpen : false,
						height : 270,
						width : 420,
						modal : true,
						buttons : {
							"Aceptar" : function() {
								$(this).dialog("close");
								var af = $("#folioAttached").val();
								$("#fldFolio").val(af);
							},

							"Cancelar" : function() {
								$(this).dialog("close");
							}
						}
					});


					// History dialog
					$("#historyDlg").dialog({
						autoOpen : false,
						height : 380,
						width : 500,
						modal : true,
						buttons : {
							"Cerrar" : function() {
								$(this).dialog("close");
							}
						}
					});

					// Attachment Img dialog
					$("#attachmentImgDlg")
							.dialog(
									{
										autoOpen : false,
										height : 340,
										width : 700,
										modal : true,
										buttons : {
											"Aceptar" : function() {
												$(this).dialog("close");
												attCounter++;
												$('#img' + attCounter + 'PH').html("<img src='img/bigPdf.png'/>");
												$('#img' + attCounter + 'Desc').html($("#attachment option:selected").val());
											},

											"Cancelar" : function() {
												$(this).dialog("close");
											}
										}
									});

					// Seguimiento$("#seguimientoCapture").hide();
					$("#seguimientoCapture").hide();

					
					$('#slAreaSolicitante').on('change',function(){
						
						consultServiceType();
						
					});
					
					
					$('#slTipoServicio').on('change',
									function() {
										// when game select changes, filter the
										// character list to the selected game
										serviceTypeId = parseInt($(
												'#slTipoServicio').val());

										diasLimitesTipoServicio = 0;
										for (var i = 0; i < listaServicios.length; i++) {
											if (listaServicios[i].id === serviceTypeId) {
												diasLimitesTipoServicio = parseInt(listaServicios[i].extra);
												break;
											}
										}

										fechaLimite = new Date();

										fechaLimite.setDate(fechaLimite
												.getDate()
												+ diasLimitesTipoServicio);

										$("#fldLimite").datepicker("setDate",
												fechaLimite);
										
										configureAdditionalFields();
										
										consultDeliverableType();

									});

					

					$( "#saveButtonTicket" ).click(function() {
						  
						  mensaje_confirmacion("\u00BF Confirma que desea enviar la requisici\u00f3n general "+$("#fldFolio").val()+"?",
								  "Alta Ticket Interno","Aceptar","Cancelar",
								  guardarAtencion,
								  function(){window.location = '/dashboard/show.do';});
						  
					});
					

					$( "#attachButtonTicket" ).click(function() {
						consultDeliverableType(function(){
							$('#attachmentImgDlg').dialog('open');
						});
					});

					readDataForm();
					
				});



function configureAdditionalFields(){
	
	iniHideAdditionalFields();
	
	var serviceTypeId = parseInt($('#slTipoServicio').val());
	
	
	if (serviceTypeId===1  ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Objetivo de Visita y Tipo de Equipo que se pretende ofertar o revisar");
		
	}
	if (serviceTypeId===2  ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Objetivo de Visita y Tipo de Equipo que se pretende ofertar o revisar");
		
	}
	if (serviceTypeId===3  ){
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Diagrama en borrador");
		$('#additionalDataLabel2').text("Ced\u00fala de Proyectos");
		
	}
	if (serviceTypeId===4  ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		$('#additionalDataTR3').show();
		
		$('#additionalDataLabel1').text("Observaciones y/o ligas de fotos");
		$('#additionalDataLabel2').text("Plano en borrador");
		$('#additionalDataLabel3').text("Ced\u00fala de Proyectos");
		
		
	}
	if (serviceTypeId===5  ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		$('#additionalDataTR3').show();
		
		$('#additionalDataLabel1').text("Observaciones y/o ligas de fotos");
		$('#additionalDataLabel2').text("Check-List de Levantamiento o lista de materiales a utilizar");
		$('#additionalDataLabel3').text("Ced\u00fala de Proyectos");
		
	}
	if (serviceTypeId===6  ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Pregunta");
		
	}
	if (serviceTypeId===7  ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Observaciones y/o ligas de mas anexos");
		$('#additionalDataLabel2').text("Ced\u00fala de Proyectos");
		
	}
	if (serviceTypeId===8  ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Producto a solicitar Precio (Marca, modelo, descripci\u00f3n)");
		
	}
	if (serviceTypeId===9  ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Observaciones");
		$('#additionalDataLabel2').text("Diagrama o Plano en borrador");
		
	}
	if (serviceTypeId===10 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Observaciones y/o ligas de fotos");
		$('#additionalDataLabel2').text("Anexar Datos Descargados del Analizador");
		
	}
	if (serviceTypeId===11 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Equipo a monitorear (marca, modelo)");
		$('#additionalDataLabel2').text("Observaciones (incluir interface utilizada) y/o ligas de fotos");
		
	}
	if (serviceTypeId===12 ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Pregunta");
		
	}
	if (serviceTypeId===13 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		$('#additionalDataTR3').show();
		
		$('#additionalDataLabel1').text("Ticket");
		$('#additionalDataLabel2').text("Modelo, Marca y N\u00famero de parte");
		$('#additionalDataLabel3').text("Observaciones y/o ligas de anexos como fotos");
		
		
	}
	if (serviceTypeId===14 ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Producto a solicitar Precio (Marca, modelo, descripci\u00f3n)");
		
		
	}
	if (serviceTypeId===15 ){}
	if (serviceTypeId===16 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		$('#additionalDataTR3').show();
		
		$('#additionalDataLabel1').text("Puesto");
		$('#additionalDataLabel2').text("Nombre del colaborador");
		$('#additionalDataLabel3').text("Suledo");
		
		$('#descrLabel').text("Justificaci\u00f3n del Req.");		
		
	}
	if (serviceTypeId===17 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		$('#additionalDataTR3').show();
		$('#additionalDataTR4').show();
		$('#additionalDataTR5').show();
		
		
		$('#additionalDataLabel1').text("Puesto");
		$('#additionalDataLabel2').text("Comentarios o Preferencias");
		$('#additionalDataLabel3').text("Plan de desarrollo");
		$('#additionalDataLabel4').text("Objetivos");
		$('#additionalDataLabel5').text("Suledo");
		
		
	}
	if (serviceTypeId===18 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		$('#additionalDataTR3').show();
		$('#additionalDataTR4').show();
		
		$('#additionalDataLabel1').text("Puesto");
		$('#additionalDataLabel2').text("Plan de desarrollo");
		$('#additionalDataLabel3').text("Objetivos");
		$('#additionalDataLabel4').text("Suledo");
		
		$('#descrLabel').text("Justificaci\u00f3n del Req.");		
		
	}
	if (serviceTypeId===19 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Puesto");
		$('#additionalDataLabel2').text("Nombre del colaborador");
		
		$('#descrLabel').text("Justificaci\u00f3n del Req.");
		
	}
	if (serviceTypeId===20 ){
		
		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Puesto");
		$('#additionalDataLabel2').text("Nombre del colaborador");
		
		$('#descrLabel').text("Justificaci\u00f3n del Req.");
		
	}
	if (serviceTypeId===21 ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("FORMATO DE REQUISICI\u00d3N DE CURSO DE CAPACITACI\u00d3N");
		
		
	}
	if (serviceTypeId===22 ){
		
		$('#additionalDataTR1').show();
		
		$('#additionalDataLabel1').text("Liga del documento");
		
		$('#descrLabel').text("Justificaci\u00f3n del Requisici\u00f3n");
		
	}
	if (serviceTypeId===23 ){

		$('#additionalDataTR1').show();
		$('#additionalDataTR2').show();
		
		$('#additionalDataLabel1').text("Sugerencia");
		$('#additionalDataLabel2').text("Código del documento");
		
		
		$('#descrLabel').text("Justificaci\u00f3n del Requisici\u00f3n");
		
		
	}
	if (serviceTypeId===24 ){
		
		$('#descrLabel').text("Descripci\u00f3n del Problema");
		
	}
	
}



function iniHideAdditionalFields(){
	
	
	$('#descrLabel').text("Descripci\u00f3n de la solicitud");
	
	$('#additionalDataTR1').hide();
	$('#additionalDataTR2').hide();
	$('#additionalDataTR3').hide();
	$('#additionalDataTR4').hide();
	$('#additionalDataTR5').hide();
	
	$('#additionalDataLabel1').text("");
	$('#additionalDataLabel2').text("");
	$('#additionalDataLabel3').text("");
	$('#additionalDataLabel4').text("");
	$('#additionalDataLabel5').text("");
	
	$('#additionalData1').val("");
	$('#additionalData1').val("");
	$('#additionalData3').val("");
	$('#additionalData4').val("");
	$('#additionalData5').val("");
	
}


function guardarAtencion() {
	// ocultarMensajes();

	if(diasLimitesTipoServicio===null){
		diasLimitesTipoServicio=-1;
	}
	
	$.ajax({
		url : "/bloom/guardarTicket.do",
		type : "POST",
		data : {
			fldFolio:$('#fldFolio').val(),
			fldFechaRegsitro:$('#fldFechaRegsitro').val(),
			fldEmail:$('#fldEmail').val(),
			slAreaSolicitante:$('#slAreaSolicitante').val(),
			slTipoServicio:$('#slTipoServicio').val(),
			fldLimite:$('#fldLimite').val(),
			slProyecto:$('#slProyecto').val(),
			slOficina:$('#slOficina').val(),
			slDocumento:$('#slDocumento').val(),
			fldDescripcion:$('#fldDescripcion').val(),
			fldDiasRespuesta:diasLimitesTipoServicio,
			slAreaSolicitanteLabel: $('#slAreaSolicitante option:selected').text(),
			slTipoServicioLabel:$('#slTipoServicio option:selected').text(),
			slOficinaLabel:$('#slOficina option:selected').text(),
			additionalData1:$('#additionalData1').val(),
			additionalData2:$('#additionalData2').val(),
			additionalData3:$('#additionalData3').val(),
			additionalData4:$('#additionalData4').val(),
			additionalData5:$('#additionalData5').val()
		},
		dataType : "json",
		beforeSend : function() {
			// mostrarMensajeCargando("Por favor espere, guardando solicitud,
			// puede tardar varios minutos");
		},
		success : function(respuestaJson) {
			// ocultarMensajes();
			if (respuestaJson.estatus === "ok") {
				
				mensaje_alerta(respuestaJson.mensaje,"Alta Ticket Interno", function(){
					window.location = '/dashboard/show.do';
				});
				
				// limpiarCampos();

			} else {
				if (respuestaJson.estatus === "preventivo") {
					mensaje_alerta(respuestaJson.mensaje,"Alta Ticket Interno");
				} else {
					mensaje_alerta(respuestaJson.mensaje,"Alta Ticket Interno");
				}
			}
		},
		error : function() {
			mensaje_alerta("Ocurri&oacute; un error al guardar solicitud","Alta Ticket Interno");
		}
	});

}

function loadFormsCombos() {

	for (var i = 0; i < listaAreas.length; i++) {
		$("#slAreaSolicitante").append(
				new Option(listaAreas[i].descripcion, listaAreas[i].id));
	}

	/*for (var i = 0; i < listaServicios.length; i++) {
		$("#slTipoServicio")
				.append(
						new Option(listaServicios[i].descripcion,
								listaServicios[i].id));
	}*/

	for (var i = 0; i < listaProyectos.length; i++) {
		$("#slProyecto")
				.append(
						new Option(listaProyectos[i].descripcion,
								listaProyectos[i].id));
	}

	for (var i = 0; i < listaOficinas.length; i++) {
		$("#slOficina").append(
				new Option(listaOficinas[i].descripcion, listaOficinas[i].id));
	}

}

function readDataForm() {

	$.ajax({
		url : "/bloomCatalog/getData.do",
		type : "GET",
		dataType : "json",
		async : false,
		beforeSend : function() {

		},
		success : function(respuestaJson) {

			if (respuestaJson.estatus === "ok") {

				listaProyectos = respuestaJson.listaMap.listaProyectos;
				listaAreas = respuestaJson.listaMap2.listaAreas;
				//listaServicios = respuestaJson.listaMap2.listaServicios;
				listaOficinas = respuestaJson.listaMap2.listaOficinas;

				loadFormsCombos();
				
				consultServiceType(function(){
					consultDeliverableType();
				});
				

			} else {
				if (respuestaJson.estatus === "preventivo") {
				} else {
				}
			}

		},
		error : function() {
		}
	});
}



function tableListDeliverableType(listaDocumentos){
	
	$("#attItems").find(".itemFile").remove();
	
	for (var i = 0; i < listaDocumentos.length; i++) {
		$('#attItems').append("<li class='itemFile'>"+listaDocumentos[i].descripcion+"</li>");
	}
	
}

function consultDeliverableType(callBackFunction) {
	
	serviceTypeId = parseInt($('#slTipoServicio').val());

	$.ajax({
		url : "/bloomCatalog/getDocumentos.do",
		type : "POST",
		data : {
			idTipoServicio : serviceTypeId
		},
		dataType : "json",
		beforeSend : function() {
			// mostrarMensajeCargando
		},
		success : function(respuestaJson) {

			if (respuestaJson.estatus === "ok") {

				listaDocumentos = respuestaJson.lista;

				$('#slDocumento').children().remove();

				for (var i = 0; i < listaDocumentos.length; i++) {
					$("#slDocumento").append(
							new Option(listaDocumentos[i].descripcion,
									listaDocumentos[i].id));
				}
				
				if ((typeof (callBackFunction) === "function") && callBackFunction !== null) {
					callBackFunction();
		        }else{
		        	tableListDeliverableType(listaDocumentos);
		        }

			} else {
				if (respuestaJson.estatus === "preventivo") {
					// mostrarMensajePreventivo
				} else {
					// mostrarMensajeError
				}
			}

		},
		error : function() {
			// mostrarMensajeError
		}
	});
}


function consultServiceType(callBackFunction) {
	
	applicantAreaId = parseInt($('#slAreaSolicitante').val());

	$.ajax({
		url : "/bloomCatalog/getServiceTypeList.do",
		type : "POST",
		data : {
			applicantAreaId : applicantAreaId
		},
		dataType : "json",
		beforeSend : function() {
			// mostrarMensajeCargando
		},
		success : function(respuestaJson) {

			if (respuestaJson.estatus === "ok") {

				listaServicios = respuestaJson.lista;

				$('#slTipoServicio').children().remove();

				for (var i = 0; i < listaServicios.length; i++) {
					$("#slTipoServicio").append(
							new Option(listaServicios[i].descripcion,
									listaServicios[i].id));
				}
				
				configureAdditionalFields();
				
				if ((typeof (callBackFunction) === "function") && callBackFunction !== null) {
					callBackFunction();
		        }
				
				/*else{
		        	tableListDeliverableType(listaDocumentos);
		        }*/

			} else {
				if (respuestaJson.estatus === "preventivo") {
					// mostrarMensajePreventivo
				} else {
					// mostrarMensajeError
				}
			}

		},
		error : function() {
			// mostrarMensajeError
		}
	});
}




function updateAttItems() {
	var tickType = $("#reqType option:selected").val();

	$("#legend").show();
	if (tickType == "Planos 3D") {
		$("#attItems")
				.html(
						"<li>Floor MAP del SITE</li><li>Hoja de Vista</li><li>Cedula de Proyectos</li>");
	} else if (tickType == "Cedula de Costos") {
		$("#attItems")
				.html(
						"<li>CHECKLIST de Levantamiento</li><li>Pre-Cedula de Proyectos</li>");
	} else if (tickType == "Cedula de Proyectos") {
		$("#attItems")
				.html(
						"<li>CHECKLIST de Levantamiento</li><li>Pre-Cedula de Proyectos</li>");
	} else if (tickType == "Aprobación de Proy. > 50K USD") {
		$("#attItems")
				.html(
						"<li>Cedula de Proyectos</li><li>Cedula de Costos</li><li>Levantamiento</li>");
	} else {
		$("#attItems").html("");
		$("#legend").hide();
	}
}

function addSeguimiento() {
	var d = new Date();
	$("#seguimientoCapture").show();
	$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Raul:');
	$("#seguimientoText").val('');
}

function applySeguimiento() {
	var template = '<div class="comment"><p><strong>TIMESTAMP: Raul: WHO</strong></p><p><small>MYCOMMENT</small></p></div>';
	var d = new Date();
	var content = template.replace('TIMESTAMP', d.format('dd/MM/yyyy h:mm:ss'));
	content = content.replace('MYCOMMENT', $("#seguimientoText").val());
	content = content.replace('WHO', $("#who option:selected").val());
	var currSegContent = $("#seguimientoContent").html();
	currSegContent = currSegContent + content;
	$("#seguimientoContent").html(currSegContent);
	$("#seguimientoCapture").hide();
}

function cancelAddSeguimiento() {
	$("#seguimientoCapture").hide();
}

function fillSeguimiento() {
	$("#seguimientoText")
			.val(
					'Se conocen los precios de los fletes y el precio unitario de unas de las baterias esprando el precio que falta. Ya fue enviado via correo el precio que faltaba.');
}
