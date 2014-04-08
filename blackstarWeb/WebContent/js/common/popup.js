
function mensaje_alerta(output_msg, title_msg, successFuctionCallBack)
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
        resizable: false,
        height: 150,
        width : 380,
        buttons: {
            "Aceptar": function()
            {
                $(this).dialog("close");
                $( ".dialogContainer" ).remove();
                
                if ((typeof (successFuctionCallBack) === "function") && successFuctionCallBack !== null) {
                	successFuctionCallBack();
                }
            }
        }
    });
}




/**
 * 
 * @param output_msg Mensaje de salida
 * @param title_msg Titulo del cuador de dialogo
 * @param sucessButton Etiqueta boton "Aceptar"
 * @param failButtom Etiqueta boton "Cancelar"
 * @param successFuctionCallBack successFuctionCallBack
 * @param failFuctionCallBack failFuctionCallBack
 */
function mensaje_confirmacion(output_msg, title_msg, sucessButton, failButtom, successFuctionCallBack, failFuctionCallBack) {

    if (!title_msg) {
        title_msg = 'Alerta';
    }

    if (!output_msg) {
        output_msg = 'No hay mensaje a mostrar.';
    }

    var html = '<div id="dialog-confirm" class="dialogContainer"><p><span id="dialog-text" class="dialogmsj">' + output_msg + '</span></p></div>';
    
    var buttonsOpts = {};
    buttonsOpts[sucessButton] = function() {
        $(this).dialog("close");
        //$( ".dialogContainer" ).remove();
        if ((typeof (successFuctionCallBack) === "function") && successFuctionCallBack !== null) {
        	successFuctionCallBack();
        }
    };
    buttonsOpts[failButtom] = function() {
        $(this).dialog("close");
        //$( ".dialogContainer" ).remove();
        if ((typeof (failFuctionCallBack) === "function") && failFuctionCallBack !== null) {
        	failFuctionCallBack();
        }
    };

    var diag = $(html);
    
    diag.dialog({
        title: title_msg,
        resizable: false,
        height: 150,
        width : 380,
        modal: true,
        buttons: buttonsOpts
    });
}
