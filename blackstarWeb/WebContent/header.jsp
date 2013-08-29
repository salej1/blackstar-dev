<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Grupo SAC</title>
				<link rel="stylesheet" href="css/960.css" type="text/css" media="screen" charset="utf-8" />
				<link rel="stylesheet" href="css/template.css" type="text/css" media="screen" charset="utf-8" />
				<link rel="stylesheet" href="css/colour.css" type="text/css" media="screen" charset="utf-8" />
				<link href="js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
				<link rel="stylesheet" href="css/jquery.ui.theme.css">
				<link rel="stylesheet" href="css/jquery-ui.min.css">
				<script src="js/glow/1.7.0/core/core.js" type="text/javascript"></script>
				<script src="js/glow/1.7.0/widgets/widgets.js" type="text/javascript"></script>
				<script src="js/jquery-1.10.1.min.js"></script>
				<script src="js/jquery-ui.js"></script>
				<script src="js/jquery.signature.min.js"></script>
				<script type="text/javascript">
					glow.ready(function(){
						new glow.widgets.Sortable(
							'#content .grid_5, #content .grid_6',
							{
								draggableOptions : {
									handle : 'h2'
								}
							}
						);
					});
				</script>
		</head>
	<body>
<!--   HEADER   -->
		<h1 id="head">
			<div class="logo">
				<img alt="Grupo Sac" src="img/grupo-sac-logo.png" border="0"/>
			</div>
			<span class="slogan">Portal de servicios</span>
		</h1>
		
		<ul id="navigation">
			<li><span class="active">Inicio</span></li>
			<li><a href="tickets">Tickets</a></li>
			<li><a href="ordenesServicio">Ordenes de servicio</a></li>
			<li><a href="seguimiento">Seguimiento</a></li>
			<li><a href="encuestas">Encuestas de servicio</a></li>
			<li><a href="indicadores">Indicadores Serv.</a></li>
			<li><span style="width:15px;"></span></li>
			<li><input type="text"/></li>
			<li><small>&nbsp;</small></li>
			<li><input type="submit" value="Buscar" class="searchButton" onclick="window.location = 'resultadoBusqueda.html'"/></li>
		</ul>
<!--   ~ HEADER   -->
	</body>
</html>