<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<!--   HEADER   -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>${initParam['globalsSettings_appTitle']}</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
		<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
		<script src="${pageContext.request.contextPath}/js/glow/1.7.0/core/core.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/js/jquery-1.10.1.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
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
        <c:set var="sysCallCenter" scope="request" value="${user.belongsToGroup['Call Center']}" />
		<h1 id="head">
			<div class="logo">
				<img alt="Grupo Sac" src="${pageContext.request.contextPath}/img/grupo-sac-logo.png" border="0"/>
			</div>
			<span class="slogan">Plataforma de Ventas</span>
		</h1>
		<form action="/search" method="GET"></form>
		<ul id="navigation">
		<c:choose>
			<c:when test="${pageSection == 'dashboard'}">
				<li><span class="active" onclick="window.location = '/dashboard/show.do'">Inicio</span></li>
				<li><a href="${pageContext.request.contextPath}/customers">Clientes</a></li>
			</c:when>
			<c:when test="${pageSection == 'customers'}">
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><span class="active" onclick="window.location = '/customers'">Clientes</span></li>
			</c:when>
			<c:otherwise>
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><a href="${pageContext.request.contextPath}/customers">Clientes</a></li>
			</c:otherwise>
		</c:choose>
			<li><span style="width:15px;"></span></li>
			<li><input type="text"/></li>
			<li><small>&nbsp;</small></li>
			<li><input type="submit" value="Buscar" class="searchButton" onclick="window.location = 'resultadoBusqueda.html'"/></li>
		</ul>
		<div id="user" class="container_16 clearfix">
			<div class="grid_16">	
				<p>${ user.fullDescriptor }</p>
			</div>
		</div>
<!--   ~ HEADER   -->