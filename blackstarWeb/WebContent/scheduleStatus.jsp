<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<c:set var="pageSection" scope="request" value="ordenesServicio" />
<c:import url="header.jsp"></c:import>
<body>
	<!--   CONTENT   -->
	<div id="content" class="container_16 clearfix">

		<!--   CONTENT COLUMN   -->
		<div class="grid_16">
<%-- 			<p>${user.FullDescriptor}</p> --%>
		</div>
		<div class="grid_16">
			<div>
				<div>
					<img src="img/navigate-right.png" /><a
						href="agendaServicio_coo.html">Agendar servicio preventivo</a>
				</div>
			</div>
			<p>
				<small>&nbsp;</small>
			</p>
		</div>
		<div class="grid_16">
			<div class="box">
				<h2>Programa semanal de servicios preventivos</h2>
				<div class="utils"></div>
				<caption>&nbsp;</caption>
				<table>
					<thead>
						<tr>
							<th colspan="4">${ today }</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach var="service" items="${servicesToday}">
						<tr>
							<td>${ service.EquipmentType }</td>
							<td>${ service.Customer }</td>
							<td>${ service.SerialNUmber }</td>
							<td>${ service.Asignee }</td>
						</tr>
					</c:forEach>
						
					<thead>
						<tr>
							<th colspan="4">${ today1 }</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>UPS</td>
							<td>PEMEX</td>
							<td>154654</td>
							<td>Alejandro Monroy, Gonzalo Ramirez</td>
						</tr>
						<tr>
							<td>BB</td>
							<td>PEMEX</td>
							<td>13165</td>
							<td>Armando Perez Pinto, Reynaldo Garcia</td>
						</tr>
						<tr>
							<td>AA</td>
							<td>PEMEX</td>
							<td>4654988</td>
							<td>Martin Vazquez</td>
						</tr>
						<tr>
							<td>BB</td>
							<td>SAC Energia</td>
							<td>149877</td>
							<td>Sergio Gallegos</td>
						</tr>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today2 }</th>
						</tr>
					</thead>
					<thead>
						<tr>
							<th colspan="4">${ today3 }</th>
						</tr>
					</thead>
					<thead>
						<tr>
							<th colspan="4">${ today4 }</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>UPS</td>
							<td>SANMINA</td>
							<td>154654</td>
							<td>Alejandro Monroy, Gonzalo Ramirez, Martin Vazquez</td>
						</tr>
						<tr>
							<td>AA</td>
							<td>PEMEX</td>
							<td>13165</td>
							<td>Armando Perez Pinto, Reynaldo Garcia</td>
						</tr>
						<tr>
							<td>BB</td>
							<td>PEMEX</td>
							<td>4654988</td>
							<td>Martin Vazquez</td>
						</tr>
						<tr>
							<td>PE</td>
							<td>SAC Energia</td>
							<td>149877</td>
							<td>Sergio Gallegos, Gonzalo Ramirez</td>
						</tr>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today5 }</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>UPS</td>
							<td>PEMEX</td>
							<td>26548</td>
							<td>Alejandro Monroy</td>
						</tr>
					</tbody>
					<thead>
						<tr>
							<th colspan="4">${ today6 }</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>
		<p>
			<small>&nbsp;</small>
		</p>
		<div class="grid_16">
			<div class="box">
				<h2>Otros servicios programados</h2>
				<div class="utils"></div>
				<table>
					<thead>
						<tr>
							<th>Fecha<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Fecha:');" /></th>
							<th>Cliente<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Cliente:');" /></th>
							<th>Equipo<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Equipo:');" /></th>
							<th>Proyecto<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Proyecto:');" /></th>
							<th>Oficina<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Oficina:');" /></th>
							<th>Marca<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Marca:');" /></th>
							<th>No. Serie<img class="filterImg" src="img/filter-16.png"
								onclick="filtrar('Modelo:');" /></th>
							<th>Editar</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><small>29/07/2013</small></td>
							<td><small>PEMEX GAI</small></td>
							<td><small>UPS</small></td>
							<td><small>CM150</small></td>
							<td><small>QRO</small></td>
							<td><small>APC</small></td>
							<td><small>PN0633152471</small></td>
							<td><a href="agendaServicio_coo.html">Editar</a></td>
						</tr>
						<tr>
							<td><small>30/07/2013</small></td>
							<td><small>PEMEX GAI</small></td>
							<td><small>AA</small></td>
							<td><small>CM150</small></td>
							<td><small>QRO</small></td>
							<td><small>TRANE</small></td>
							<td><small>3T0110-100821/101845HY4F</small></td>
							<td><a href="agendaServicio_coo.html">Editar</a></td>
						</tr>
						<tr>
							<td><small>31/07/2013</small></td>
							<td><small>PEMEX GAI</small></td>
							<td><small>UPS</small></td>
							<td><small>CM150</small></td>
							<td><small>QRO</small></td>
							<td><small>APC</small></td>
							<td><small>GG0027002256</small></td>
							<td><a href="agendaServicio_coo.html">Editar</a></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!--   ~ CONTENT COLUMN   -->
		<!--   ~ CONTENT   -->
	</div>
</body>
</html>