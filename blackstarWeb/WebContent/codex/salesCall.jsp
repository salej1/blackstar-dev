<script type="text/javascript">

	function initialize_salesCall(){
		$("#okSalesCall").hide();
		$("#errorSalesCall").hide();
	}

	function recordSalesCall(){

		$.post( "/codex/salesCall/record.do", $("#salesCallObj").serialize())
		.done(function( data ) {
			if(data.result == "OK"){
				$("#okSalesCall").show();
				setTimeout(function(){
					$( "#okSalesCall" ).fadeOut( 1600);
				}, 5000);
			}
			else{
				$("#errorSalesCall").show();
				setTimeout(function(){
					$( "#errorSalesCall" ).fadeOut( 1600 );
				}, 5000);
			}
		})
		.fail(function(data, error, what){
			alert("data: " + data + ". Error: " + error + ". What: " + what);
		});
	}

</script>
<div style="margin-bottom:20px;">
	<form id="salesCallObj">
		<input name="cstEmail" type="hidden" value="${user.userEmail}"/>
		<input type="submit" class="searchButton" onclick="recordSalesCall(); return false;" value="Llamada de ventas"/>
		<img id="okSalesCall" src="/img/sucess.png" alt="" style="width:20px; height=20px; vertical-align:bottom"/>
		<img id="errorSalesCall" src="/img/error.png" alt="" style="width:20px; height=20px; vertical-align:bottom"/>
	</form>
</div>