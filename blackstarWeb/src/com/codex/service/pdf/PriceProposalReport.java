package com.codex.service.pdf;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import com.blackstar.common.Globals;
import com.blackstar.services.report.AbstractReport;
import com.blackstar.services.report.util.NoSpaceInPageException;
import com.codex.model.CurrencyType;
import com.codex.vo.ProjectEntryVO;
import com.codex.vo.ProjectVO;
import com.pdfjet.Align;
import com.pdfjet.Color;

public class PriceProposalReport extends AbstractReport {

  private ProjectVO data = null;
	
  protected void run(Object fillData) throws Exception {
	data = (ProjectVO) fillData;
	printHeader();
	printCover();
	
	drawer.newPage();
	printHeader();
	printProposal();
	
	drawer.newPage();
	printHeader();
	printContract(data);
	
	for(int i = 0; i < drawer.getPageCount(); i++){
		drawer.gotoPage(i);
		printFooter(i+1, drawer.getPageCount());
	}
	
	drawer.commit();
  }
	
	
  private void printHeader() throws Exception {
	drawer.image("pdf/logoSAC.jpg", 0, 10, 0.82);
  }
  
  private void printCover() throws Exception {
	  
	  int yAdj = 40;
	  drawer.textBlock("INGENERIA DE SERVICIO", Align.CENTER, 20, 120 + yAdj, 520, true, Color.darkblue, 16);
	  drawer.textBlock("EN PROTECCION INTEGRAL", Align.CENTER, 20, 140 + yAdj, 520, true, Color.darkblue, 16);
	  drawer.textBlock("Proyecto:", Align.CENTER, 20, 180 + yAdj, 520, false, 14);
	  drawer.textBlock(data.getProjectNumber(), Align.CENTER, 20, 200 + yAdj, 520, true, 14);
	  drawer.textBlock("Cotizaci�n No.", Align.CENTER, 20, 230 + yAdj, 520, false, 14);
	  drawer.textBlock(data.getPriceProposalNumber(), Align.CENTER, 20, 250 + yAdj, 520, true, 14);
	  drawer.textBlock("Cliente:", Align.CENTER, 20, 280 + yAdj, 520, false, 12);
	  drawer.textBlock(data.getClientDescription(), Align.CENTER, 20, 300 + yAdj, 520, true, 14);
	  drawer.textBlock("Atenci�n:", Align.CENTER, 20, 330 + yAdj, 520, false, 12);
	  drawer.textBlock(data.getContactName(), Align.CENTER, 20, 350 + yAdj, 520, true, 14);
	  drawer.textBlock("Fecha de Creaci�n:", Align.CENTER, 20, 380 + yAdj, 520, false, 12);
	  drawer.textBlock(Globals.getLocalDateString(), Align.CENTER, 20, 410 + yAdj, 520, false, 12);
	  drawer.textBlock("Aviso de Restricciones de Uso y Divulgaci�n:", Align.JUSTIFY, 40, 630, 520, true, 9);
	  String s = "La informaci�n contenida en la totalidad de esta Propuesta, constituye un secreto de marca y/o informaci�n comercial y/o financiera " +
	  "propiedad de SISTEMAS AVANZADOS EN COMPUTACI�N DE M�XICO, S.A. DE C.V., en lo sucesivo \"GRUPO SAC\", la cual, se encuentra " +
	  "clasificada como confidencial. Esta informaci�n es proporcionada con la restricci�n de que no podr� ser usada o divulgada sin el permiso " +
	  "de GRUPO SAC para otros prop�sitos que no sean para su evaluaci�n, acordando con el Cliente, el protegerla con el mismo grado de cuidado " +
	  "que el mismo utilizar�a para proteger su propia informaci�n.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 655, 500, false, 8);

  }
  
  private void printFooter(int page, int pageCount) throws Exception {
	  // drawer.textBlock(s, Align.JUSTIFY, 40, 725, 480, false, Color.gray, 7);
	  drawer.text("4 - VE - 11                Rev. 1           15-01-2015                                                                TRA: Mientras este Activo   TRAM: 1 a�o", 40,745, false, Color.gray, 7);
	  drawer.text("Pag. " + page + "/" + pageCount, 500 , 745, false, Color.gray, 7);
  }
  
  private void printProposal() throws Exception {
	  List<ProjectEntryVO> entries = data.getEntries();
	  int yFactor = 0;
	  float rawEntryPrice = 0F;
	  float totalPrice = 0;
	  drawer.box(40, 140, 490, 20, Color.gray, true);
	  drawer.text("Propuesta", 260, 154, true, 0, 10);
	  String s = "Damos a nuestros clientes la confianza de que sus procesos cr�ticos trabajar�n de forma continua gracias a nuestras soluciones en monitoreo, " + 
			  "protecci�n el�ctrica y climatizaci�n. Por lo tanto, el objetivo principal de la presente propuesta es agregar valor a su Organizaci�n al proveerle " +
			  "una soluci�n de ingenier�a, configuraci�n, puesta en operaci�n y/o mantenimiento para su  infraestructura orientada a resguardar su aplicaci�n cr�tica.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 190, 490, false, 9);
	  
	  drawer.hLine(40, 525, 290);
	  drawer.hLine(40, 525, 310);
	  drawer.vLine(290, 310, 40);
	  drawer.vLine(290, 310, 90);
	  drawer.vLine(290, 310, 320);
	  drawer.vLine(290, 310, 370);
	  drawer.vLine(290, 310, 440);
	  drawer.vLine(290, 310, 525);
	  drawer.text("Partida", 50, 303, true);
	  drawer.text("Descripci�n", 185, 303, true);
	  drawer.text("Cantidad", 328, 303, true);
	  drawer.text("P. Unitario", 387, 303, true);
	  drawer.text("Importe", 468, 303, true);
	  for(int i = 0; i < entries.size() ; i++){
		  int descOffset = 0;
		  
		  try{
			  descOffset = drawer.textBlock(entries.get(i).getDescription(), Align.JUSTIFY, 105, 325 + yFactor, 200, false, 8);
			  descOffset *= 12;
			  drawer.text(i + 1 + "", 60, 325 + yFactor);
		  }
		  
		  catch(NoSpaceInPageException ex){
			  yFactor = -190;
			  drawer.newPage();
			  printHeader();
			  drawer.hLine(40, 525, 120);
			  descOffset = drawer.textBlock(entries.get(i).getDescription(), Align.JUSTIFY, 105, 325 + yFactor, 200, false, 8);
			  descOffset *= 12;
			  drawer.text(i + 1 + "", 60, 325 + yFactor);
		  }
		  
		  drawer.text(entries.get(i).getQty().toString(), 342, 325 + yFactor);
		  	
		  drawer.hLine(40, 525, 335 + yFactor + descOffset);
		  drawer.vLine(310 + yFactor, 335 + yFactor + descOffset, 40);
		  drawer.vLine(310 + yFactor, 335 + yFactor + descOffset, 90);
		  drawer.vLine(310 + yFactor, 335 + yFactor + descOffset, 320);
		  drawer.vLine(310 + yFactor, 335 + yFactor + descOffset, 370);
		  drawer.vLine(310 + yFactor, 335 + yFactor + descOffset, 440);
		  drawer.vLine(310 + yFactor, 335 + yFactor + descOffset, 525);
		  
		  rawEntryPrice = entries.get(i).getUnitPrice();
		  Double actualEntryPrice = entries.get(i).getTotalPrice();
		  
		  if(data.getCurrencyTypeId() == CurrencyType.MXN){
			  rawEntryPrice = rawEntryPrice * data.getChangeType();
			  actualEntryPrice = actualEntryPrice * data.getChangeType();
		  }
		  		  
		  drawer.text(DecimalFormat.getCurrencyInstance().format(rawEntryPrice) + "", 385, 325 + yFactor);
		  drawer.text(DecimalFormat.getCurrencyInstance().format(actualEntryPrice) + "", 455, 325 + yFactor);
		  
		  yFactor += descOffset + 25;
		  		  
		  totalPrice += actualEntryPrice;
		  
		  if(entries.get(i).getDiscount() > 0){
		  }	  
	  }
	  
	  
	  yFactor += 355;
	  if((yFactor + 60) > 690){
		  yFactor = 120;
		  drawer.newPage();
		  printHeader();
	  }

	  
	  drawer.hLine(370, 525, yFactor);
	  drawer.hLine(370, 525, yFactor + 20);
	  drawer.vLine(yFactor, yFactor + 20, 370);
	  drawer.vLine(yFactor, yFactor + 20, 440);
	  drawer.vLine(yFactor, yFactor + 20, 525);
	  
	  drawer.text("Total " + data.getCurrencyCode(), 375, yFactor + 13, true);
	  drawer.text(DecimalFormat.getCurrencyInstance().format(totalPrice) + "", 450, yFactor + 13, true);
	  
	  yFactor += 53;
	  
	  if((yFactor + 210) > 690){
		  yFactor = 90;
		  drawer.newPage();
		  printHeader();
	  }
	  
	  drawer.box(35, yFactor + 30, 490, 15, Color.gray, true);
	  drawer.vLine(yFactor + 30, yFactor + 190, 35);
	  drawer.vLine(yFactor + 30, yFactor + 190, 525);
	  drawer.hLine(35, 525, yFactor + 190);
	  drawer.hLine(35, 525, yFactor + 30);
	  
	  yFactor += 40;
	  
	  drawer.text("Al elegirnos como su proveedor, obtendr�, entre otros, los siguientes beneficios:", 75, yFactor);
	  drawer.point(75, yFactor + 20, 1.5F, 0, true);
	  drawer.text("Empresa reconocida en el medio con m�s de 26 a�os de experiencia", 75, yFactor + 23);
	  drawer.point(75, yFactor + 30, 1.5F, 0, true);
	  drawer.text("Presencia Nacional", 75, yFactor + 33);
	  drawer.point(75, yFactor + 40, 1.5F, 0, true);
	  drawer.text("Personal capacitado y certificado en su ramo", 75, yFactor + 43);
	  drawer.point(75, yFactor + 50, 1.5F, 0, true);
	  drawer.text("Representaci�n y soporte directo de los fabricantes de los productos ofrecidos", 75, yFactor + 53);
	  drawer.point(75, yFactor + 60, 1.5F, 0, true);
	  drawer.text("Capacidad t�cnica y financiera", 75, yFactor + 63);
	  drawer.point(75, yFactor + 70, 1.5F, 0, true);
	  drawer.text("Soluciones llave en mano cuidando su efectividad y la eficiencia energ�tica", 75, yFactor + 73);
	  drawer.point(75, yFactor + 80, 1.5F, 0, true);
	  drawer.text("Expertos en configuraci�n, administraci�n y monitoreo de su infraestructura.", 75, yFactor + 83);
	  drawer.point(75, yFactor + 90, 1.5F, 0, true);
	  drawer.text("Centro de Contacto multicanal:  lada gratuita nacional: 01 800 0830 203;  correo �call-center@gposac.com.mx� y", 75, yFactor + 93);
	  drawer.text("v�a WEB.", 75, yFactor + 103);
	  drawer.point(75, yFactor + 110, 1.5F, 0, true);
	  drawer.text("Portal personalizado a nuestros clientes para la administraci�n y estad�sticas de servicio", 75, yFactor + 113);
	  drawer.point(75, yFactor + 120, 1.5F, 0, true);
	  drawer.text("Atenci�n  especializada en cualquiera de las modalidades de servicio 5x8 � 7X24", 75, yFactor + 123);
  }
  
  private void printContract(ProjectVO data) throws Exception {
	  drawer.box(35, 120, 490, 20, Color.gray, true);
	  drawer.text("T�rminos de Venta", 240, 134, true, 0, 10);
	  drawer.text("1. Validez de Oferta", 40, 160, true);
	  Calendar c = Calendar.getInstance();
	  c.add(Calendar.DATE, 30);
	  SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	  drawer.text("La presente cotizaci�n tiene vigencia hasta el d�a " + sdf.format(c.getTime()), 40, 170);

	  drawer.text("2. Precio", 40, 190, true);
	  drawer.text("Los precios est�n cotizados en " + data.getCurrencyCode() + " y no incluyen el impuesto al valor agregado (IVA), el cual se cargar� al momento de la facturaci�n.", 40, 200);
	  
	  drawer.text("3. Condiciones de Pago", 40, 220, true);
	  String paymentType;
	  if(data.getPaymentTypeId() == 1){
		  paymentType = "Pago de contado. ";
	  }
	  else{
		  paymentType = "A cr�dito. ";
	  }
	  drawer.text(paymentType + data.getPaymentConditions().replace("\r\n", ". "), 40, 230);
	  String s = "Nota: En caso de que se le ofrezca un cr�dito y no cuente con l�nea de cr�dito ya establecida con GRUPO SAC, su autorizaci�n estar�  " +
			  "supeditada al dictamen de nuestro departamento correspondiente. Para las cotizaciones en d�lares el pago podr� ser realizado en moneda " +
			  "nacional con base al tipo de cambio publicado en el DOF del d�a en que se aplique en firme el deposito en nuestra cuenta bancaria.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 250, 490, false, 8);

	  drawer.text("4. Entrega", 40, 310, true);
	  String weekText = data.getDeliveryTimeDisplay().equals("1")? "SEMANA" : "SEMANAS";
	  s = "a) El tiempo de entrega es de " + data.getDeliveryTimeDisplay() + " " + weekText + ", el cual iniciar� a partir de la recepci�n de su orden de compra y/o contrato y/o nuestra cotizaci�n " +
			  "y del deposito en firme del anticipo correspondiente.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 320, 490, false, 8);
	  
	  drawer.text("Los tiempos de entrega aqu� mencionados est�n sujetos a la capacidad de la planta en el momento de recibir su orden de compra o pedido.", 40, 350);
	  drawer.text("b) La entrega ser� " + data.getIncoterm() + " en " + data.getLocation() + " Incoterms 2010.", 40, 370);
	  
	  drawer.text("5. Modificaciones", 40, 390, true);
	  s = "Cualquier modificaci�n a los productos y/o servicios ofertados, una vez colocado su pedido, deber� ser evaluada por GRUPO SAC a fin de " +
			  "ser aprobada.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 400, 490, false, 8);
	  s = "Una vez aprobada por GRUPO SAC la modificaci�n, finalmente se aceptar� hasta contar con la confirmaci�n por escrito del cliente, as� como " + 
			  "de precios y tiempos de entrega, en caso de que tambi�n hayan sufrido cambios.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 430, 490, false, 8);

	  drawer.text("6. Cancelaciones", 40, 460, true);
	  s = "GRUPO SAC no acepta la cancelaci�n de pedidos, ya que su configuraci�n se basa en especificaciones que satisfacen las necesidades " +
			  "particulares de un cliente.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 470, 490, false, 8);
	  s = "En caso de que esto ocurriera, el monto del cargo por cancelaci�n se determinar� por las inversiones realizadas espec�ficamente para ese " +
			  "pedido y dependiendo de la etapa en que se encuentre con base en los siguientes porcentajes:";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 500, 490, false, 8);
	
	  drawer.point(65, 527, 1F, 0, true);
	  drawer.text("20% cuando se haya recibido el pedido del Cliente.", 50, 530);
	  drawer.point(65, 537, 1F, 0, true);
	  drawer.text("50 al 75% cuando se encuentre en la etapa de compra de equipos.", 50, 540);
	  drawer.point(65, 547, 1F, 0, true);
	  drawer.text("100% cuando los equipos se encuentren listos para ser embarcados.", 50, 550);
	 
	  drawer.text("7. Inspecci�n y Aceptaci�n", 40, 570, true);
	  drawer.text("La entrega de nuestros productos y/o servicios se lleva a cabo previa inspecci�n de los mismos y mediante documentos internos", 40, 580);
	  drawer.text("(Remisi�n y/u Orden de Servicio) en donde el Cliente firma de Aceptaci�n.", 40, 600);
	  
	  drawer.text("8. Empaque y Almacenamiento", 40, 620, true);
	  drawer.text("El empaque de los diferentes productos ser� de acuerdo a los est�ndares de cada uno de los fabricantes.", 40, 630);
	  s = "Cualquier equipo listo para embarcarse o entregarse y que no sea liberado para su env�o por causas imputables al Cliente (condiciones " +
			  "crediticias, direcci�n de embarque, retrasos en la adecuaci�n del sitio, etc.) causar� un cargo por almacenaje sobre el valor de la " +
			  "mercanc�a del 0.15% por cada d�a natural, despu�s de transcurridos cinco d�as naturales desde la fecha de notificaci�n por parte de" +
			  "nuestro personal.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 640, 490, false, 8);

	  drawer.newPage();
	  printHeader();
	  
	  drawer.text("9. Transferencia de Propiedad", 40, 120, true);
	  s = "La transferencia de propiedad tendr� lugar en el sitio donde se entreguen los equipos, pagados en su totalidad y con la facturaci�n " +
			  "de los mismos.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 130, 490, false, 8);

	  drawer.text("10. Riesgos", 40, 160, true);
	  s = "Los riesgos inherentes a los equipos y servicios se tendr�n por traspasados al Cliente en el lugar y fecha en que se pongan a su " +
			  "disposici�n y se cuente con su firma en el documento de entrega que corresponda.";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 170, 490, false, 8);
	  	 
	  drawer.text("11. Garant�a", 40, 200, true);
	  s = "La garant�a de nuestros productos ser� de12 meses a partir de la puesta en marcha del equipo o 16 meses " +
			  "despu�s de la entrega del �l. La garant�a pudiera variar si as� lo indica(n) la(s) partida(s)";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 210, 490, false, 8);

	  drawer.text("12. Causas de Fuerza Mayor", 40, 240, true);
	  s = "GRUPO SAC no ser� responsable por el incumplimiento en las condiciones mencionadas en esta oferta cuando �ste sea consecuencia " +
		  "de causas de fuerza mayor o caso fortuito. " +
		  "Se entiende por causas de fuerza mayor o causas ajenas a GRUPO SAC las que se mencionan en forma enunciativa m�s no limitativa: " +
		  "guerra, disturbios civiles, cataclismos, incendios, cuarentena, requisiciones, condiciones clim�ticas severas, disposici�n gubernamental " +
		  ", interrupci�n de la disponibilidad de mano de obra o cualquier otra circunstancia fuera del control razonable de GRUPO SAC. ";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 250, 490, false, 8);
	  
	  drawer.text("13. Acuerdos", 40, 310, true);
	  s = "En caso de que exista alguna inconformidad respecto a la entrega de los equipos, prestaci�n de los servicios o incumplimiento en su " +
		"pedido, esta deber� manifestarse en un lapso que no exceda de 15 (quince) d�as naturales, as� como elaborar el formato de acciones " +
		"correctivas con los acuerdos y fechas de cumplimiento. " +
		"En el supuesto de que no se llegue a ning�n acuerdo, las partes aceptan que se someter�n expresamente a la jurisdicci�n y competencia " +
		"de los Tribunales competentes en la Ciudad de Guadalajara, Jalisco. ";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 320, 490, false, 8);

	  
	  drawer.text("14. L�mites de Responsabilidad por Da�o Indirecto Consecuencial", 40, 370, true);
	  s = "Ninguna de las partes ser� responsable ante la otra por cualquier p�rdida de beneficio, p�rdida de uso, p�rdida de producci�n, p�rdida " +
	  "de contratos o por cualquier otro da�o indirecto o de consecuencia que pueda sufrir la otra parte. En caso de que ocurran da�os en " +
	  "en terceros, ser� la entidad legal y jur�dica competente en la Ciudad de Guadalajara, Jalisco, la encargada de dictaminar o conciliar " +
	  "las responsabilidades y penalidades por ley. " +
	  "En espera de que la presente oferta sea de su agrado y conveniencia, quedamos a sus �rdenes para cualquier duda o aclaraci�n al " +
	  "respecto. ";
	  drawer.textBlock(s, Align.JUSTIFY, 40, 380, 490, false, 8);
	 
	  drawer.text("Atentamente", 45, 480, true);
	  drawer.image("pdf/" + data.getCstEmail() + ".png", 45, 490, 0.25);
	  drawer.text(data.getCstName(), 45, 610);
	  drawer.text("Ingenier�a de Servicio en Protecci�n Integral", 45, 620);
	  drawer.text("Tel: " + data.getCstPhone() + ". Ext: " + data.getCstPhoneExt(), 45, 630);
	  drawer.text("Cel: " + data.getCstMobile(), 45, 640);
	  drawer.text(data.getCstEmail(), 45, 650);
	  drawer.text("www.gposac.com.mx", 45, 660);
	  drawer.text("Aprobado por", 350, 480, true);
	  drawer.text("Nombre:", 350, 610);
	  drawer.text("Firma:", 350, 620);
	  drawer.text("Fecha:", 350, 630);
	 
  }
  
  public static void main(String [] args) throws Exception{
//	PriceProposalReport serv = new PriceProposalReport();
//	FileOutputStream see = new FileOutputStream("C:/PriceProposal.pdf");
//	ProjectVO project = new ProjectVO();
//	project.setId(1);
//	project.setClientDescription("Sistema Nal. de Aguas");
//	project.setContactName("Sergio Gomez A.");
//	ProjectEntryVO entry = null;
//	List<ProjectEntryVO> entries = new ArrayList<ProjectEntryVO>();
//	List<ProjectEntryItemVO> items = null;
//	for(int i = 0; i < 63 ; i++){
//		entry = new ProjectEntryVO(i, i, i, "Tipo " + i, "Descripcion " + i
//			     , Float.valueOf(i), Double.valueOf(i * 10), "Comentarios " + i);
//		entries.add(entry);	
//		items = new ArrayList<ProjectEntryItemVO>();
//		for(int j = 0; j < 5 ; j++){
//			items.add(new ProjectEntryItemVO(j, i, j, "", "", "",  j, Float.valueOf(j * i), 0F, 0F, ""));
//		}
//		entry.setItems(items);
//	}
//    project.setEntries(entries);
//	see.write(serv.getReport(project));
//	see.close();
  }

}
