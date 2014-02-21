<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:set var="pageSection" scope="request" value="customers" />
<c:import url="headerSales.jsp" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/jquery.ui.theme.css" />
<link rel="stylesheet" href="/css/jquery-ui.min.css" />
<script src="/js/jquery-1.10.1.min.js"></script>
<script src="/js/jquery-ui.js"></script>
<script src="/DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<title>Clientes</title>
</head>
<body>
	<div id="content" class="container_16 clearfix">
		<form:form commandName="customerDTO" action="save.do" method="POST">
			<div class="grid_16">
				<p>
					<img src="../img/navigate-right.png" /><a href="">Crear cédula de proyecto</a>
				</p>
			</div>

			<div class="grid_16">
				<div class="box">
					<h2>Nuevo prospecto</h2>
					<div class="utils"></div>
					<table>
						<!--  <tr>
								<td style="width:120px;">Número</td>
								<td colspan="2"><form:input path="customerId" type="text" style="width:95%;" value="3413" readonly="true" /></td>
							</tr> -->
						<tr>
							<td>RFC</td>
							<td colspan="4"><form:input path="rfc" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Razón Social</td>
							<td colspan="6"><form:input path="companyName" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Nombre comercial</td>
							<td colspan="6"><form:input path="tradeName" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
						</tr>
						<tr>
							<td>Teléfono 1</td>
							<td>Lada</td>
							<td><form:input path="phoneCode1" type="text" style="width: 95%;" /></td>
							<td>Teléfono</td>
							<td><form:input path="phone1" type="text" style="width: 95%;" /></td>
							<td>Extensión</td>
							<td><form:input path="extension1" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Teléfono 2</td>
							<td>Lada</td>
							<td><form:input path="phoneCode2" type="text" style="width: 95%;" /></td>
							<td>Teléfono</td>
							<td><form:input path="phone2" type="text" style="width: 95%;" /></td>
							<td>Extensión</td>
							<td><form:input path="extension2" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Email 1</td>
							<td colspan="2"><form:input path="email1" type="text" style="width: 95%;" /></td>
							<td>Email 2</td>
							<td colspan="2"><form:input path="email2" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Domicilio:</td>
							<td>Calle</td>
							<td colspan="3"><form:input path="street" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
							<td>Núm. Exterior</td>
							<td><form:input path="externalNumber" type="text" style="width: 95%;" /></td>
							<td>Núm. Interior</td>
							<td><form:input path="internalNumber" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
							<td>Colonia:</td>
							<td><form:input path="colony" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
							<td>Ciudad:</td>
							<td>
							<select name="" id="" style="width: 95%;">
									<option value="">Aguascalientes</option>
									<option value="">Culiacan</option>
									<option value="">Durango</option>
									<option value="">Hermosillo</option>
									<option value="">Morelia</option>
							</select></td>
							<td>Municipio:</td>
							<td><form:input path="town" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
							<td>Estado:</td>
							<td>
								<form:select path="governmentId" items="${governmentList}" itemLabel="name" itemValue="governmentId" style="width: 95%;" />
							</td>
							<td>País:</td>
							<td><form:input path="country" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
							<td>Código postal:</td>
							<td><form:input path="postcode" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td></td>
						</tr>
						<tr>
							<td>Condiciones</td>
							<td colspan="2">
								<form:select path="governmentId" items="${governmentList}" itemLabel="name" itemValue="governmentId" style="width: 95%;" />
							</td>
						</tr>
						<tr id="rowCredito">
							<td></td>
							<td>Anticipo</td>
							<td><form:input path="advance" type="text" /></td>
							<td>Plazo</td>
							<td><form:input path="timeLimit" type="text" /></td>
						</tr>
						<tr>
							<td>Plazo finiquito</td>
							<td colspan="2"><form:input path="timeLimit" type="text" /></td>
						</tr>
						<tr>
							<td>Moneda</td>
							<td colspan="2">
								<select name="" id="" style="width: 95%;">
									<option value="mxn">Pesos</option>
									<option value="usd">Dolares</option>
								</select>
							</td>
							<td>IVA</td>
							<td colspan="2"><select name="" id="" style="width: 95%;">
									<option value="">16%</option>
							</select></td>
						</tr>
						<tr>
							<td>Vendedor</td>
							<td colspan="2"><select name="" id="" style="width: 95%;">
									<option value="">Ivan Ramirez Rios</option>
									<option value="">Rogelio Valadez</option>
									<option value="">Liliana Diaz</option>
							</select></td>
							<td>Contacto</td>
							<td colspan="2"><form:input path="contactPerson" type="text" style="width: 95%;" /></td>
						</tr>
						<tr>
							<td>Clasificacion</td>
							<td colspan="2"><select name="" id="" style="width: 95%;">
									<option value="">Integrador</option>
									<option value="">IP</option>
									<option value="">Gobierno</option>
							</select></td>
							<td>Origen</td>
							<td colspan="2"><select name="" id="">
									<option value="">CLIENTE</option>
									<option value="">CST</option>
									<option value="">INTERNET</option>
									<option value="">MAILING</option>
									<option value="">REVISTA</option>
									<option value="">REFERIDO</option>
									<option value="">OTRO</option>
							</select></td>
						</tr>
						<tr>
							<td>CURP</td>
							<td colspan="2"><form:input path="curp" type="text" style="width: 95%;" /></td>
							<td>Retencion</td>
							<td colspan="2"><form:input path="retention" type="text" style="width: 95%;" /></td>
						</tr>
					</table>
					<p></p>
					<div>
						<button class="searchButton" onclick="window.history.back();">Guardar</button>
						<button class="searchButton" onclick="window.history.back();">Cancelar</button>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</body>
</html>
