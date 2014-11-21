<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<!--   HEADER   -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>GPO. SAC - Portal de Servicios</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/960.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/template.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colour.css" type="text/css" media="screen" charset="utf-8" />
		<link href="${pageContext.request.contextPath}/js/glow/1.7.0/widgets/widgets.css" type="text/css" rel="stylesheet" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.ui.theme.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
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
			<span class="slogan">Portal de servicios</span>
			<span style="display:inline-block;width:180px;"><small>v2.365</small></span>
			<span><small><a href="${pageContext.request.contextPath}/dashboard/logout.do">Salir</a></small></span>
		</h1>

		<form action="/search" method="GET"></form>
		<ul id="navigation">
		<c:choose>
			<c:when test="${pageSection == 'dashboard'}">
				<li><span class="active" onclick="window.location = '/dashboard/show.do'">Inicio</span></li>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
			</c:when>
			<c:when test="${pageSection == 'tickets'}">
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><span class="active" onclick="window.location = '/tickets'">Tickets</span></li>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
			</c:when>
			<c:when test="${pageSection == 'ordenesServicio'}">  
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
				<li><span class="active" onclick="window.location = '/serviceOrders/show.do'">Ordenes de servicio</span></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
			</c:when>
			<c:when test="${pageSection == 'requisiciones'}">
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><span class="active" onclick="window.location = '/bloom/bloomTicketPage/show.do'">Requisiciones</span></li>
					<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
			</c:when>			
			<c:when test="${pageSection == 'encuestas'}">
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					<li><span class="active" onclick="window.location = '/surveyServices/show.do'">Encuestas</span></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
			</c:when>			
			<c:when test="${pageSection == 'indicadores'}">
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
				</c:if>
				<li><span class="active" onclick="window.location = '/indServicios/show.do'">Indicadores</span></li>
			</c:when>		
			<c:otherwise>
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
				<c:if test="${!user.belongsToGroup['Cliente']}">
					<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
				</c:if>
				<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
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
