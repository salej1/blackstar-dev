var source = "";
var labels = "";
var values = "";

function split( val ) {
  return val.split( /,\s*/ );
}

function extractLast( term ) {
  return split( term ).pop();
}

function init_autoComplete(src, targetLabels, targetValues){
	var source = src;
	var labels = targetLabels;
	var values = targetValues;
	var data = $.parseJSON(source);

	$("#" + labels + "").bind( "keydown", function( event ) {
	    if ( event.keyCode === $.ui.keyCode.TAB && $( this ).data( "ui-autocomplete" ).menu.active ) {
	      event.preventDefault();
	    }
  	}).autocomplete({
		minLength: 0,
		source: function( request, response ) {
	      	response( $.ui.autocomplete.filter(
	        data, extractLast( request.term ) ) );
	    },
		focus: function() {
      		return false;
   		},
   		select: function( event, ui ) {
	    	var terms = this.value.split(/,\s*/);
	        terms.pop();
	        terms.push( ui.item.label );
	        terms.push( "" );
	        this.value = terms.join( ", " );

	        $("#" + values + "").val($("#" + values + "").val() + ";" + ui.item.value );
	        return false;
		}
	});
}

function init_autoComplete(src, targetLabels, targetValues, mode){
	var source = src;
	var labels = targetLabels;
	var values = targetValues;
	var data = $.parseJSON(source);

	$("#" + labels + "").bind( "keydown", function( event ) {
	    if ( event.keyCode === $.ui.keyCode.TAB && $( this ).data( "ui-autocomplete" ).menu.active ) {
	      event.preventDefault();
	    }
  	}).autocomplete({
		minLength: 0,
		source: function( request, response ) {
	      	response( $.ui.autocomplete.filter(
	        data, extractLast( request.term ) ) );
	    },
		focus: function() {
      		return false;
   		},
   		select: function( event, ui ) {
   			if(typeof(mode) != "undefined" && mode == "single"){
   				this.value =  ui.item.label ;
		        $("#" + values + "").val(ui.item.value);
   			}
   			else{
   				var terms = this.value.split(/,\s*/);
		        terms.pop();
		        terms.push( ui.item.label );
		        terms.push( "" );
		        this.value = terms.join( ", " );

		        $("#" + values + "").val($("#" + values + "").val() + ";" + ui.item.value );
   			}
	    	
	        return false;
		}
	});
}

