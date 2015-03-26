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
			<span style="display:inline-block;width:180px;"><small>v3.382</small></span>
			<span><small><a href="${pageContext.request.contextPath}/dashboard/logout.do">Salir</a></small></span>
		</h1>

		<form action="/search" method="GET"></form>
		<ul id="navigation">
		<!-- Inicio -->
		<c:choose>
			<c:when test="${pageSection == 'dashboard'}">
				<li><span class="active" onclick="window.location = '/dashboard/show.do'">Inicio</span></li>
			</c:when>
			<c:otherwise>
				<li><a href="${pageContext.request.contextPath}/dashboard/show.do">Inicio</a></li>
			</c:otherwise>
		</c:choose>

		<!-- Tickets -->
		<c:choose>
			<c:when test="${pageSection == 'tickets'}">
				<li><span class="active" onclick="window.location = '/tickets'">Tickets</span></li>
			</c:when>
			<c:otherwise>
				<li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
			</c:otherwise>
		</c:choose>

		<!-- Ordenes de servicio -->
		<c:choose>
			<c:when test="${pageSection == 'ordenesServicio'}">
				<li><span class="active" onclick="window.location = '/serviceOrders/show.do'">Ordenes de servicio</span></li>
			</c:when>
			<c:otherwise>
				<li><a href="${pageContext.request.contextPath}/serviceOrders/show.do">Ordenes de servicio</a></li>
			</c:otherwise>
		</c:choose>
			<c:if test="${!user.belongsToGroup['Cliente']}">
				<!-- Requisiciones -->
				<c:choose>
					<c:when test="${pageSection == 'requisiciones'}">
						<li><span class="active" onclick="window.location = '/bloom/bloomTicketPage/show.do'">Requisiciones</span></li>
					</c:when>
					<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/bloom/bloomTicketPage/show.do">Requisiciones</a></li>
					</c:otherwise>
				</c:choose>

				<!-- Encuestas -->
				<c:choose>
					<c:when test="${pageSection == 'encuestas'}">
						<li><span class="active" onclick="window.location = '/surveyServices/show.do'">Encuestas</span></li>
					</c:when>
					<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/surveyServices/show.do">Encuestas</a></li>
					</c:otherwise>
				</c:choose>

				<!-- Clientes -->
				<c:choose>
					<c:when test="${pageSection == 'clientes'}">
						<li><span class="active" onclick="window.location = '${pageContext.request.contextPath}/codex/client/showClientList.do'">Clientes</span></li>
					</c:when>
					<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/codex/client/showClientList.do">Clientes</a></li>
					</c:otherwise>
				</c:choose>
				
				<!-- Cedulas de proyecto -->
				<c:choose>
					<c:when test="${pageSection == 'projects'}">
						<li><span class="active" onclick="window.location = '${pageContext.request.contextPath}/codex/project/showList.do'">Cedulas de Proyectos</span></li>
					</c:when>
					<c:otherwise>
			    		<li><a href="${pageContext.request.contextPath}/codex/project/showList.do">Cedulas de Proyectos</a></li>
					</c:otherwise>
				</c:choose>
				
				<!-- Cotizaciones -->
				<c:choose>
					<c:when test="${pageSection == 'proposals'}">
						<li><span class="active" onclick="window.location = '${pageContext.request.contextPath}/codex/priceProposal/showProposals.do">Cotizaciones</span></li>
					</c:when>
					<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/codex/priceProposal/showProposals.do">Cotizaciones</a></li>
					</c:otherwise>
				</c:choose>

				<!-- Pedidos -->
				<c:choose>
					<c:when test="${pageSection == 'sold'}">
						<li><span class="active" onclick="window.location = '${pageContext.request.contextPath}/codex/priceProposal/showSold.do">Pedidos</span></li>
					</c:when>
					<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/codex/priceProposal/showSold.do">Pedidos</a></li>
					</c:otherwise>
				</c:choose>
			</c:if>

			<!-- Indicadores -->
			<c:choose>
				<c:when test="${pageSection == 'indicadores'}">
					<li><span class="active" onclick="window.location = '/indServicios/show.do'">Indicadores</span></li>
				</c:when>
				<c:otherwise>
					<li><a href="${pageContext.request.contextPath}/indServicios/show.do">Indicadores</a></li>
				</c:otherwise>
			</c:choose>
		</ul>
		<div id="user" class="container_16 clearfix" style="margin-bottom:10px;">
			<div class="grid_16">	
				<span style="width:300px;">
					${ user.fullDescriptor }
				</span>
				<span style="float:right;">
					<input type="text"/>
					<small>&nbsp;</small>
					<input type="submit" value="Buscar" class="searchButton" onclick="window.location = 'resultadoBusqueda.html'"/>
				</span>
			</div>
		</div>
<!--   ~ HEADER   -->
