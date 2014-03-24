


function mensaje_alerta(output_msg, title_msg)
{
    if (!title_msg) {
        title_msg = 'Alerta';
    }

    if (!output_msg) {
        output_msg = 'No hay mensaje a mostrar.';
    }

    var html = '<div id="dialog-confirm" class="dialogContainer"><p><span id="dialog-text" class="dialogmsj">' + output_msg + '</span></p></div>';

    var diag = $(html);


    diag.dialog({
        title: title_msg,
        resizable: false,
        modal: true,
        buttons: {
            "Aceptar": function()
            {
                $(this).dialog("close");
            }
        }
    });
}


function mensaje_alerta_funcion(output_msg, title_msg, successFuction)
{
    if (!title_msg) {
        title_msg = 'Alerta';
    }

    if (!output_msg) {
        output_msg = 'No hay mensaje a mostrar.';
    }

    var html = '<div id="dialog-confirm" class="dialogContainer"><p><span id="dialog-text" class="dialogmsj">' + output_msg + '</span></p></div>';

    var diag = $(html);


    diag.dialog({
        title: title_msg,
        resizable: false,
        modal: true,
        buttons: {
            "Aceptar": function()
            {
                $(this).dialog("close");
                successFuction();
            }
        }
    });
}




function mensaje_confirmacion(output_msg, title_msg, successFuction, failFuction) {

    if (!title_msg) {
        title_msg = 'Alerta';
    }

    if (!output_msg) {
        output_msg = 'No hay mensaje a mostrar.';
    }

    var html = '<div id="dialog-confirm" class="dialogContainer"><p><span id="dialog-text" class="dialogmsj">' + output_msg + '</span></p></div>';

    var diag = $(html);

    diag.dialog({
        title: title_msg,
        resizable: false,
        height: 200,
        modal: true,
        buttons: {
            "Si": function() {
                $(this).dialog("close");
                successFuction();
            },
            "No": function() {
                $(this).dialog("close");
                if (failFuction !== null) {
                    failFuction();
                }
            }
        }
    });
}

function mensaje_confirmacion_completo(output_msg, title_msg, successFuction, failFuction, sucessButton, failButtom) {

    if (!title_msg) {
        title_msg = 'Alerta';
    }

    if (!output_msg) {
        output_msg = 'No hay mensaje a mostrar.';
    }

    var buttonsOpts = {};
    buttonsOpts[sucessButton] = function() {
        $(this).dialog("close");
        successFuction();
    };
    buttonsOpts[failButtom] = function() {
        $(this).dialog("close");
        if (failFuction !== null) {
            failFuction();
        }
    };


    var html = '<div id="dialog-confirm" class="dialogContainer"><p><span id="dialog-text" class="dialogmsj">' + output_msg + '</span></p></div>';

    var diag = $(html);

    diag.dialog({
        title: title_msg,
        resizable: false,
        height: 200,
        modal: true,
        buttons: buttonsOpts
    });
}


function popup_cargando_mostrar() {
    jQuery("#popupCargando").css('display', 'block');
    jQuery("#popupCargando").fadeIn(500);
}


function popup_cargando_ocultar() {
    jQuery("#popupCargando").hide();
}
