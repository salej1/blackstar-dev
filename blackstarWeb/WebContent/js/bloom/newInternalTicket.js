var listaProyectos;
var listaAreas;
var listaServicios;
var listaOficinas;

var idTipoServicio;
var diasLimitesTipoServicio;
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

					// Save confirm dialog
					$("#saveConfirm").dialog({
						autoOpen : false,
						height : 150,
						width : 380,
						modal : true,
						buttons : {
							"Aceptar" : function() {
								$(this).dialog("close");
								
								guardarAtencion();
								
								//window.location = 'dashboard.html';
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
										width : 420,
										modal : true,
										buttons : {
											"Aceptar" : function() {
												$(this).dialog("close");
												attCounter++;
												$('#img' + attCounter + 'PH')
														.html(
																"<img src='img/bigPdf.png'/>");
												$('#img' + attCounter + 'Desc')
														.html(
																$(
																		"#attachment option:selected")
																		.val());
											},

											"Cancelar" : function() {
												$(this).dialog("close");
											}
										}
									});

					// Seguimiento$("#seguimientoCapture").hide();
					$("#seguimientoCapture").hide();

					$('#slTipoServicio')
							.on(
									'change',
									function() {
										// when game select changes, filter the
										// character list to the selected game
										idTipoServicio = parseInt($(
												'#slTipoServicio').val());

										diasLimitesTipoServicio = 0;
										for (var i = 0; i < listaServicios.length; i++) {
											if (listaServicios[i].id === idTipoServicio) {
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

									});

					consultarDatosFormulario();

					attachmentFolderId = $("#fldFolio").val();

				});


function guardarAtencion() {
	// ocultarMensajes();

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
			fldFolio:$('#fldFolio').val(),
			slDocumento:$('#slDocumento').val(),
			fldDescripcion:$('#fldDescripcion').val(),
			fldDiasRespuesta:diasLimitesTipoServicio,
			slAreaSolicitanteLabel: $('#slAreaSolicitante option:selected').text(),
			slTipoServicioLabel:$('#slTipoServicio option:selected').text(),
			slOficinaLabel:$('#slOficina option:selected').text()
		},
		dataType : "json",
		beforeSend : function() {
			// mostrarMensajeCargando("Por favor espere, guardando solicitud,
			// puede tardar varios minutos");
		},
		success : function(respuestaJson) {
			// ocultarMensajes();
			if (respuestaJson.estatus === "ok") {
				// limpiarCampos();
				// mostrarMensajeOK(respuestaJson.mensaje);

			} else {
				if (respuestaJson.estatus === "preventivo") {
					// mostrarMensajePreventivo(respuestaJson.mensaje);
				} else {
					// mostrarMensajeError(respuestaJson.mensaje);
				}
			}
		},
		error : function() {
			// ocultarMensajes();
			// mostrarMensajeError("Ocurri&oacute; un error al guardar
			// solicitud");
		}
	});

}

function cargaCombosFormulario() {

	for (var i = 0; i < listaAreas.length; i++) {
		$("#slAreaSolicitante").append(
				new Option(listaAreas[i].descripcion, listaAreas[i].id));
	}

	for (var i = 0; i < listaServicios.length; i++) {
		$("#slTipoServicio")
				.append(
						new Option(listaServicios[i].descripcion,
								listaServicios[i].id));
	}

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

function consultarDatosFormulario() {

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
				listaServicios = respuestaJson.listaMap2.listaServicios;
				listaOficinas = respuestaJson.listaMap2.listaOficinas;

				cargaCombosFormulario();

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

function consultarDocumentos() {

	$.ajax({
		url : "/bloomCatalog/getDocumentos.do",
		type : "POST",
		data : {
			idTipoServicio : idTipoServicio
		},
		dataType : "json",
		beforeSend : function() {
			// mostrarMensajeCargando
		},
		success : function(respuestaJson) {

			if (respuestaJson.estatus === "ok") {

				listaDocuentos = respuestaJson.lista;

				$('#slDocumento').children().remove();

				for (var i = 0; i < listaDocuentos.length; i++) {
					$("#slDocumento").append(
							new Option(listaDocuentos[i].descripcion,
									listaDocuentos[i].id));
				}

				$('#attachmentImgDlg').dialog('open');

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
