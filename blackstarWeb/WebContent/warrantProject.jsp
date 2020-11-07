<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="warrantProjects" />
<c:import url="headerSales.jsp" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/jquery.ui.theme.css" />
<link rel="stylesheet" href="/css/jquery-ui.min.css" />
<script src="/js/jquery-1.10.1.min.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<title>Cedula de Proyecto</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">
		<form:form commandName="warrantProjectDTO" action="save.do" method="POST">
			<div class="grid_16">
				<div class="box">
					<h2>Cedula de proyectos</h2>
					<div class="utils">
							<p></p>							
							<button class="searchButton" onclick="window.location = 'intTicketDetail_new.html'">Agregar Req. Gral.</button>
							<button class="searchButton" onclick="window.history.back();">Guardar</button>
							<button class="searchButton" onclick="window.history.back();">Enviar a autorizar</button>
							<button class="searchButton" onclick="window.history.back();">Cancelar</button>
							<button class="searchButton" onclick="$('#discardProject').dialog('open')">Descartar</button>
							<hr>
						</div>		
					<table>
						<tr>
							<td>Estatus</td>
							<td colspan="4"><form:input path="status" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Cliente</td>
							<td colspan="2">
								<form:select path="customerId" items="${customerList}" itemLabel="companyName" itemValue="customerId" style="width: 95%;" />
							</td>
						</tr>
						<tr>
						<td>Centro de costos</td>
						<td colspan="4"><form:input path="costCenter" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td colspan=2>Tipo de cambio</td>
							<td><form:input path="exchangeRate" type="text" style="width: 95%;" /></td>
							<td>Fecha</td>
							<td><form:input path="updateDate" type="text" id="fecha" style="width: 95%;" />
							<script type="text/javascript">
     $(function(){
         $("#fecha").datepicker();
     });
</script>
							</td>
						</tr>
						<tr>
							<td>Nombre del contacto</td>
							<td ><form:input path="contactName" type="text" style="width: 95%;" cssStyle=" width : 305px;"/></td>
						</tr>
						<tr>
							<td>Ubicacion(es) del proyecto</td>
							<td colspan="3"><form:input path="ubicationProject" type="text" style="width: 95%;" /></td>
							<td>Forma de pago:</td>
							<td colspan="2">
								<form:select path="paymentTermsId" items="${paymentTermsList}" itemLabel="name" itemValue="paymentTermsId" style="width: 95%;" />
							</td>
						</tr>
						<tr>
							<td>Tiempo de entrega:</td>
							<td><form:input path="deliveryTime" type="text" style="width: 95%;" /></td>
							<td>Dias<td>
							<td>Intercom:</td>
							<td><form:input path="intercom" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Total del proyecto:</td>
							<td><form:input path="totalProject" type="text" style="width: 95%;" /></td>
							<td>Fianzas:</td>
							<td><form:input path="bonds" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Total de productos y servicios:</td>
							<td><form:input path="totalProductsServices" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
						<td>Partida no.</td>
						<td><form:input path="entryId" type="text" style="width: 95%;" /></td>
						</tr>
					</table>
					<p></p>
				</div>
			</div>
		</form:form>
		<form:form commandName="entryDTO" action="saveEntry.do" method="POST">
					<div class="grid_16">
				<div class="box">
					<div class="utils"></div>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="entryTable">
						<thead>
							<tr>
								<th>Partida</th>
								<th>Tipo</th>
								<th>Referencia</th>
								<th>Descripcion</th>
								<th>Cantidad</th>
								<th>Precio unit.</th>
								<th>Descuento</th>
								<th>Total</th>
								<th>Observaciones</th>
							</tr>
						</thead>
						<tbody>
						<tr>
						<td><form:select path="type">
						<form:option value="Lista de precios"></form:option>
						<form:option value="Mesa de ayuda"></form:option>
						<form:option value="Abierto"></form:option>
						</form:select></td>
						<td>
						<form:select path="serviceTypeId">
						<form:options items="${serviceTypeList}" itemValue="serviceTypeId" itemLabel="serviceType"></form:options>
						</form:select>
						</td>
						<td><form:input path="description" type="text" style="width: 95%;" /></td>
						<td><form:input path="amount" type="text" style="width: 95%;" /></td>
						<td><form:input path="unitPrice" type="text" style="width: 95%;" /></td>
						<td><form:input path="discount" type="text" style="width: 95%;" /></td>
						<td><form:input path="total" type="text" style="width: 95%;" /></td>
						<td><form:input path="observations" type="text" style="width: 95%;" /></td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
			</form:form>
	</div>
</body>
</html>
