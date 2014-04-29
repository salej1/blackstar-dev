
<script type="text/javascript" src="${pageContext.request.contextPath}/js/bloom/historicalTickets.js"></script>


<!--
	Seccion tabla tickets internos pendientes
-->
<div class="grid_16">

	<div class="box">
		<h2>Historico de Tickets Internos</h2>
		<div class="utils">
		
		<table style="width: 100%;">
			<tr>
				<td style="width: 100px;">Fecha de Registro</td>
				<td style="width: 120px;"><input id="fldFechaIni" type="text" readOnly="true" style="width: 140px;"/></td>
				<td style="width: 60px;"> a</td>
				<td style="width: 120px;"><input id="fldFechaFin" type="text" readOnly="true" style="width: 140px;"/></td>
			</tr>
			
			<tr>
				<td>Estatus Ticket</td>
				<td colspan="3">
					<select name="slEstatusTicket" id="slEstatusTicket" style="width:200px;">
					</select>
				</td>
			</tr>
			
			<!-- tr>
				<td>Responsable</td>
				<td colspan="3">
					<select name="slResponsable" id="slResponsable" style="width:200px;">
					</select>
				</td>
			</tr-->
			<tr colspan="4">
				<td>
					<button id="buscarButtonTicket" class="searchButton">Buscar</button>
				</td>
			</tr>
			
			
			
		</table>
			
		</div>
		<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtGridHistoricalTicketsInternos">
			<thead>
				<tr>
					<th style="width=250px;">Folio</th>
					<th>Estatus</th>
					<th>Creado</th>
					<th>Solicitante</th>
					<th>Tipo</th>
					<th>Fecha Limite</th>
					<th>Proyecto</th>
					<th>Oficina</th>
				</tr>
			</thead>
			<tbody>

			</tbody>
		</table>
	</div>
</div>

<!--
	FIN - Seccion tabla de tickets internos
-->
