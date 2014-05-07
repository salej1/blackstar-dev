function redirect(url, data, method) {
    $('body').append('<form id="redirePantallaForm">');
    $('#redirePantallaForm').attr({
        method: !method ? "post" : method,
        action: url
    });
    $(data).each(function() {
        $('<input>').attr({
            type: 'hidden',
            id: 'id_' + this.name,
            name: this.name,
            value: this.data
        }).appendTo('#redirePantallaForm');
    });
    $('#redirePantallaForm').submit();
    $('#redirePantallaForm').remove();
}



/**
 * Detiene el parpadeo de un control
 * @returns {undefined}
 */
jQuery.fn.detieneParpadeo = function()
{
    this.each(function parpadear()
    {
        $(this).fadeIn(1500).delay(100);
    });
};



/**
 * Inicia parpade de un control
 * @returns {undefined}
 */
jQuery.fn.iniciaParpadeo = function()
{
    this.each(function parpadear()
    {
        $(this).fadeIn(500).delay(250).fadeOut(500, parpadear);
    });
};


/**
 * Valores permitidos a un control
 * @returns {unresolved}
 */
jQuery.fn.ForceNumericOnly =
        function()
        {
            return this.each(function()
            {
                $(this).keydown(function(e)
                {
                    var key = e.charCode || e.keyCode || 0;
                    if (key != 16) {
                        return (
                                key == 9 || //tab
                                key == 8 || //backspace
                                key == 46 || //delete
                                (key >= 48 && key <= 57) ||
                                (key >= 96 && key <= 105));
                    }
                });






            });
        };


/**
 * Valores permitidos a un control
 * @returns {unresolved}
 */
jQuery.fn.ForceNumeric =
        function()
        {
            return this.each(function()
            {
                $(this).keydown(function(e)
                {
                    var key = e.charCode || e.keyCode || 0;
                    // allow backspace, tab, delete, arrows, numbers and keypad numbers ONLY
                    // home, end, period, and numpad decimal
                    return (
                            key == 8 || //backspace
                            key == 9 || //tab
                            key == 46 || //delete
                            key == 110 || //decimal point
                            key == 190 || //period
                            (key >= 35 && key <= 40) ||
                            (key >= 48 && key <= 57) ||
                            (key >= 96 && key <= 105));
                });
            });
        };


/**
 * Valores permitidos a un control
 * @returns {unresolved}
 */
jQuery.fn.ForceNumericTel =
        function()
        {
            return this.each(function()
            {
                $(this).keydown(function(e)
                {
                    var key = e.charCode || e.keyCode || 0;
                    return (
                            key == 9 || //tab
                            key == 8 || //backspace
                            key == 46 || //delete
                            key == 219 || //open bracket
                            key == 221 || //close bracket
                            (key >= 48 && key <= 57) ||
                            (key >= 96 && key <= 105));
                });
            });
        };  