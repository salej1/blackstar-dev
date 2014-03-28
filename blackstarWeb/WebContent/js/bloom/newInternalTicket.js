var listaProyectos;
var listaAreas;
var listaServicios;
var listaOficinas;
					



$(document).ready(function () {
						var attCounter = 0;
						
						$("#myDate").datepicker();
						
						//Attachment dialog
						$("#attachmentDlg").dialog({
							autoOpen: false,
							height: 270,
							width: 420,
							modal: true,
							buttons: {
								"Aceptar": function() {
									$( this ).dialog( "close" );
									var af = $("#folioAttached").val();
									$("#fldFolio").val(af);
								},
								
								"Cancelar": function() {
								$( this ).dialog( "close" );
							}}
						});
						
						//Save confirm dialog
						$("#saveConfirm").dialog({
							autoOpen: false,
							height: 150,
							width: 380,
							modal: true,
							buttons: {
								"Aceptar": function() {
									$( this ).dialog( "close" );
									window.location = 'dashboard.html';
								},
								
								"Cancelar": function() {
								$( this ).dialog( "close" );
							}}
						});
						
						//History dialog
						$("#historyDlg").dialog({
							autoOpen: false,
							height: 380,
							width: 500,
							modal: true,
							buttons: {
								"Cerrar": function() {
									$( this ).dialog( "close" );
							}}
						});
						
						//Attachment Img dialog
						$("#attachmentImgDlg").dialog({
							autoOpen: false,
							height: 340,
							width: 420,
							modal: true,
							buttons: {
								"Aceptar": function() {
									$( this ).dialog( "close" );
									attCounter++;
									$('#img'+attCounter+'PH').html("<img src='img/bigPdf.png'/>");
									$('#img'+attCounter+'Desc').html($("#attachment option:selected").val());
								},
								
								"Cancelar": function() {
								$( this ).dialog( "close" );
							}}
						});
						
						// Seguimiento$("#seguimientoCapture").hide();
						$("#seguimientoCapture").hide();
						
						
						consultarDatosFormulario();
						
					
					});
					
					
					function cargaCombosFormulario() {
						
					    for (var i = 0; i < listaAreas.length; i++) {
					    	$("#slAreaSolicitante").append(new Option(listaAreas[i].descripcion, listaAreas[i].id));
					    }
					    
					    
					    for (var i = 0; i < listaServicios.length; i++) {
					    	$("#slTipoServicio").append(new Option(listaServicios[i].descripcion, listaServicios[i].id));
					    }

					    for (var i = 0; i < listaProyectos.length; i++) {
					    	$("#slProyecto").append(new Option(listaProyectos[i].descripcion, listaProyectos[i].id));
					    }

					    for (var i = 0; i < listaOficinas.length; i++) {
					    	$("#slOficina").append(new Option(listaOficinas[i].descripcion, listaOficinas[i].id));
					    }

						
					}
					
					
					function consultarDatosFormulario() {
					
					    $.ajax({
					        url: "/bloomCatalog/getData.do",
					        type: "GET",
					        dataType: "json",
					        async: false,
					        beforeSend: function() {
					            
					        },
					        success: function(respuestaJson) {
					            
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
					        error: function() {
					        }
					    });
					}
					
					
					
					function updateAttItems(){
						var tickType = $("#reqType option:selected").val();
						
						$("#legend").show();
						if(tickType == "Planos 3D"){
							$("#attItems").html("<li>Floor MAP del SITE</li><li>Hoja de Vista</li><li>Cedula de Proyectos</li>");
						}
						else if(tickType == "Cedula de Costos"){
							$("#attItems").html("<li>CHECKLIST de Levantamiento</li><li>Pre-Cedula de Proyectos</li>");
						}
						else if(tickType == "Cedula de Proyectos"){
							$("#attItems").html("<li>CHECKLIST de Levantamiento</li><li>Pre-Cedula de Proyectos</li>");
						}
						else if(tickType == "Aprobación de Proy. > 50K USD"){
							$("#attItems").html("<li>Cedula de Proyectos</li><li>Cedula de Costos</li><li>Levantamiento</li>");
						}
						else{
							$("#attItems").html("");
							$("#legend").hide();
						}
					}
					
					function addSeguimiento(){
						var d = new Date(); 
						$("#seguimientoCapture").show();	
						$("#seguimientoStamp").html(d.format('dd/MM/yyyy h:mm:ss') + ' Raul:');
						$("#seguimientoText").val('');
					}
					
					function applySeguimiento(){
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
					
					function cancelAddSeguimiento(){
						$("#seguimientoCapture").hide();
					}
					
					function fillSeguimiento(){
						$("#seguimientoText").val('Se conocen los precios de los fletes y el precio unitario de unas de las baterias esprando el precio que falta. Ya fue enviado via correo el precio que faltaba.');
					}
