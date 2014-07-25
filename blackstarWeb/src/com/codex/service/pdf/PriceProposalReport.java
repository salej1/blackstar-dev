package com.codex.service.pdf;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.services.report.AbstractReport;
import com.codex.vo.ProjectEntryItemVO;
import com.codex.vo.ProjectEntryVO;
import com.codex.vo.ProjectVO;
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
	printContract();
	printFooter();
  }
	
	
  private void printHeader() throws Exception {
	drawer.image("pdf/logoSAC.jpg", 0, 10);
	drawer.text("GUADALAJARA", 165,50, true);
	drawer.text("Tel. 01(33) 37-93-01-38", 158,62);
	drawer.text("Fax. 01(33) 37-93-01-44", 158,72);
	drawer.text("M�XICO", 275, 50, true);
	drawer.text("Tel. 01(55) 50-20-21-60", 254,62);
	drawer.text("Fax. 01(55) 50-20-21-63", 254,72);
	drawer.text("QUER�TARO", 360,50, true);
	drawer.text("Tel. 01(442) 295-24-68", 349,62);
	drawer.text("01800.0830203", 360,72, true);
  }
  
  private void printCover() throws Exception {
	  String projectNumber = "CQ" + data.getId() + "-1";
	  drawer.text("Cotizaci�n No.", 267,250, true, 0 , 12);
	  drawer.text(projectNumber, getCenterX(projectNumber),270, false, 0 , 12);
	  drawer.text("Cliente:", 295,300);
	  drawer.text(data.getClientDescription(), getCenterX(data.getClientDescription())
			                                                     ,320, false, 0 , 12);
	  drawer.text("Atenci�n:", 294,350);
	  drawer.text(data.getContactName(), getCenterX(data.getContactName())
                                                     ,370, false, 0 , 12);
	  drawer.text("Fecha de Creaci�n:", 279,400, true);
	  drawer.text("Aviso de Restricciones de Uso y Divulgaci�n:", 40,600, true);
	  drawer.text("La informaci�n contenida en la totalidad de esta Propuesta, constituye un secreto de marca y/o informaci�n comercial y/o financiera", 40,630);
	  drawer.text("propiedad de SISTEMAS AVANZADOS EN COMPUTACI�N DE M�XICO, S.A. DE C.V., en lo sucesivo \"GRUPO SAC\", la cual, se encuentra", 40,645);
	  drawer.text("clasificada como confidencial. Esta informaci�n es proporcionada con la restricci�n de que no podr� ser usada o divulgada sin el permiso", 40,660);
	  drawer.text("de GRUPO SAC para otros prop�sitos que no sean para su evaluaci�n, acordando con el Cliente, el protegerla con el mismo grado de cuidado", 40,675);
	  drawer.text("que el mismo utilizar�a para proteger su propia informaci�n.", 40,690);
  }
  
  private void printFooter() throws Exception {
	  drawer.text("La informaci�n contenida en la totalidad de este documento es clasificada como confidencial y se entrega bajo el entendido de que no ser� usada o divulgada, sin el permiso de Sistemas", 40,785, false, Color.gray, 6);
	  drawer.text("Avanzados en Computaci�n de M�xico, S.A. de C.V.", 40,795, false, Color.gray, 6);
  }
  
  private void printProposal() throws Exception {
	  List<ProjectEntryVO> entries = data.getEntries();
	  List<ProjectEntryItemVO> items = null;
	  int yFactor = 0;
	  int rowCounter = 0, adjusment = 0;
	  float entryPrice = 0F;
	  float totalPrice = 0, totalDiscount = 0;
	  drawer.box(35, 140, 510, 20, Color.gray, true);
	  drawer.text("PROPUESTA", 260, 154, true, 0, 10);
	  drawer.text("El objetivo principal es proveer una soluci�n de ingenier�a, configuraci�n, puesta en operaci�n y mantenimiento para su infraestructura", 40,190);
	  drawer.text("de protecci�n, orientada precisamente a resguardar su aplicaci�n cr�tica.", 40,205);
	  drawer.text("En la misma se detallar�n c�digos y caracter�sticas para que usted tenga una mejor comprensi�n de la soluci�n que estamos ofreciendo,", 40,235);
	  drawer.text("misma que facilitar� su toma de decisi�n sobre el producto y/o servicio de su inter�s.", 40,250);
	  drawer.hLine(40, 545, 290);
	  drawer.hLine(40, 545, 310);
	  drawer.vLine(290, 310, 40);
	  drawer.vLine(290, 310, 120);
	  drawer.vLine(290, 310, 320);
	  drawer.vLine(290, 310, 390);
	  drawer.vLine(290, 310, 460);
	  drawer.vLine(290, 310, 545);
	  drawer.text("No. partida", 60, 303, true);
	  drawer.text("Descripci�n", 200, 303, true);
	  drawer.text("Cantidad", 338, 303, true);
	  drawer.text("P. Unitario", 407, 303, true);
	  drawer.text("Importe", 488, 303, true);
	  for(int i = 0; i < entries.size() ; i++, rowCounter ++){
		  if((yFactor + 335) > 750){
			  yFactor = -190;
			  rowCounter = 0;
			  adjusment = -190;
			  drawer.newPage();
			  printHeader();
			  drawer.hLine(40, 545, 120);
		  }   
		  yFactor = rowCounter * 25 + adjusment;
		  drawer.hLine(40, 545, 335 + yFactor);
		  drawer.vLine(310 + yFactor, 335 + yFactor, 40);
		  drawer.vLine(310 + yFactor, 335 + yFactor, 120);
		  drawer.vLine(310 + yFactor, 335 + yFactor, 320);
		  drawer.vLine(310 + yFactor, 335 + yFactor, 390);
		  drawer.vLine(310 + yFactor, 335 + yFactor, 460);
		  drawer.vLine(310 + yFactor, 335 + yFactor, 545);
		  
		  items = entries.get(i).getItems();
		  entryPrice = 0F;
		  for(ProjectEntryItemVO item :  items){
			  entryPrice += item.getPriceByUnit();
		  }
		  
		  drawer.text(i + 1 + "", 75, 325 + yFactor);
		  drawer.text(entries.get(i).getDescription(), 125, 325 + yFactor);
		  drawer.text("1", 352, 325 + yFactor);
		  drawer.text(entryPrice + "", 420, 325 + yFactor);
		  drawer.text(entryPrice + "", 495, 325 + yFactor);
		  totalPrice += entries.get(i).getTotalPrice();
		  totalDiscount = entries.get(i).getDiscount();
	  }
	  yFactor += 355;
	  if((yFactor + 60) > 750){
		  yFactor = 120;
		  drawer.newPage();
		  printHeader();
	  }
	  drawer.hLine(390, 545, yFactor);
	  drawer.hLine(390, 545, yFactor + 20);
	  drawer.hLine(390, 545, yFactor + 40);
	  drawer.hLine(390, 545, yFactor + 60);
	  drawer.vLine(yFactor, yFactor + 60, 390);
	  drawer.vLine(yFactor, yFactor + 60, 460);
	  drawer.vLine(yFactor, yFactor + 60, 545);
	  
	  
	  drawer.text("Subtotal", 395, yFactor + 13, true);
	  drawer.text(totalPrice + "", 470, yFactor + 13, true);
	  drawer.text("Descuento", 395, yFactor + 33, true);
	  drawer.text(totalDiscount + "", 470, yFactor + 33, true);
	  drawer.text("Total USD", 395, yFactor + 53, true);
	  drawer.text((totalPrice - totalDiscount) + "", 470, yFactor + 53, true);
	  
	  yFactor += 53;
	  
	  if((yFactor + 210) > 750){
		  yFactor = 90;
		  drawer.newPage();
		  printHeader();
	  }
	  
	  drawer.box(35, yFactor + 30, 510, 15, Color.gray, true);
	  drawer.vLine(yFactor + 40, yFactor + 210, 35);
	  drawer.vLine(yFactor + 40, yFactor + 210, 545);
	  drawer.hLine(35, 545, yFactor + 210);
	  
	  yFactor += 40;
	  
	  drawer.text("Al elegirnos como su proveedor, obtendr�, entre otros, los siguientes beneficios:", 75, yFactor);
	  drawer.point(75, yFactor + 40, 1.5F, 0, true);
	  drawer.text("Empresa reconocida en el medio con m�s de 25 a�os de experiencia", 75, yFactor + 23);
	  drawer.point(75, yFactor + 60, 1.5F, 0, true);
	  drawer.text("Presencia Nacional", 75, yFactor + 43);
	  drawer.point(75, yFactor + 80, 1.5F, 0, true);
	  drawer.text("Personal capacitado y certificado en su ramo", 75, yFactor + 63);
	  drawer.point(75, yFactor + 100, 1.5F, 0, true);
	  drawer.text("Representaci�n y soporte directo de los fabricantes de los productos ofrecidos", 75, yFactor + 83);
	  drawer.point(75, yFactor + 120, 1.5F, 0, true);
	  drawer.text("Capacidad t�cnica y financiera", 75, yFactor + 103);
	  drawer.point(75, yFactor + 140, 1.5F, 0, true);
	  drawer.text("Soluciones llave en mano cuidando la eficiencia econ�mica y energ�tica", 75, yFactor + 123);
	  drawer.point(75, yFactor + 160, 1.5F, 0, true);
	  drawer.text("Certificaci�n ISO9001-2008 expertos en configuraci�n, administraci�n y monitoreo de su infraestructura.", 75, yFactor + 143);
	  drawer.point(75, yFactor + 180, 1.5F, 0, true);
	  drawer.text("Atenci�n especializada en cualquiera de las modalidades de servicio 7X24", 75, yFactor + 163);
  }
  
  private void printContract() throws Exception {
	  drawer.box(35, 120, 510, 20, Color.gray, true);
	  drawer.text("T�rminos de Venta", 260, 134, true, 0, 10);
	  drawer.text("1. Validez de Oferta", 40, 160, true);
	  drawer.text("La presente cotizaci�n tiene vigencia hasta el d�a 20/MAY/14", 40, 170);
	  drawer.text("2. Precio", 40, 190, true);
	  drawer.text("Los precios est�n cotizados en USD y no incluyen el impuesto al valor agregado (IVA), el cual se cargar� al momento de la facturaci�n.", 40, 200);
	  drawer.text("3. Condiciones de Pago", 40, 220, true);
	  drawer.text("30 DIAS A MES VENCIDO", 40, 230);
	  drawer.text("Nota: En caso de que se le ofrezca un cr�dito y no cuente con l�nea de cr�dito ya establecida con GRUPO SAC, su autorizaci�n supeditada", 40, 250);
	  drawer.text("al dictamen de nuestro departamento correspondiente. Para las cotizaciones en d�lares el pago podr� ser realizado en moneda nacional con", 40, 260);
	  drawer.text("base al tipo de cambio publicado en el DOF del d�a en que se aplique en firme el deposito en nuestra cuenta bancaria.", 40, 270);
	  drawer.text("4. Entrega", 40, 290, true);
	  drawer.text("a) El tiempo de entrega es de 6 SEMANAS, el cual iniciar� a partir de la recepci�n de su orden de compra y/o contrato y/o nuestra cotizaci�n", 40, 300);
	  drawer.text("y del deposito en firme del anticipo correspondiente.", 40, 310);
	  drawer.text("Los tiempos de entrega aqu� mencionados est�n sujetos a la capacidad de la planta en el momento de recibir su orden de compra o pedido.", 40, 330);
	  drawer.text("b) La entrega ser� DDP en CUAUTITLAN IZCALLI Incoterms 2010.", 40, 350);
	  drawer.text("5. Modificaciones", 40, 370, true);
	  drawer.text("Cualquier modificaci�n a los productos y/o servicios ofertados, una vez colocado su pedido, deber� ser evaluada por GRUPO SAC a fin de", 40, 380);
	  drawer.text("ser aprobada.", 40, 390);
	  drawer.text("Una vez aprobada por GRUPO SAC la modificaci�n, finalmente se aceptar� hasta contar con la confirmaci�n por escrito del cliente, as� como", 40, 410);
	  drawer.text("de precios y tiempos de entrega, en caso de que tambi�n hayan sufrido cambios.", 40, 420);
	  drawer.text("6. Cancelaciones", 40, 440, true);
	  drawer.text("GRUPO SAC no acepta la cancelaci�n de pedidos, ya que su configuraci�n se basa en especificaciones que satisfacen las necesidades", 40, 450);
	  drawer.text("particulares de un cliente.", 40, 460);
	  drawer.text("En caso de que esto ocurriera, el monto del cargo por cancelaci�n se determinar� por las inversiones realizadas espec�ficamente para ese", 40, 480);
	  drawer.text("pedido y dependiendo de la etapa en que se encuentre con base en los siguientes porcentajes:", 40, 490);
	  drawer.point(65, 527, 1F, 0, true);
	  drawer.text("20% cuando se haya recibido el pedido del Cliente.", 50, 510);
	  drawer.point(65, 537, 1F, 0, true);
	  drawer.text("50 al 75% cuando se encuentre en la etapa de compra de equipos.", 50, 520);
	  drawer.point(65, 547, 1F, 0, true);
	  drawer.text("100% cuando los equipos se encuentren listos para ser embarcados.", 50, 530);
	  drawer.text("7. Inspecci�n y Aceptaci�n", 40, 550, true);
	  drawer.text("La entrega de nuestros productos y/o servicios se lleva a cabo previa inspecci�n de los mismos y mediante documentos internos", 40, 560);
	  drawer.text("(Remisi�n y/u Orden de Servicio) en donde el Cliente firma de Aceptaci�n.", 40, 570);
	  drawer.text("8. Empaque y Almacenamiento", 40, 590, true);
	  drawer.text("El empaque de los diferentes productos ser� de acuerdo a los est�ndares de cada uno de los fabricantes.", 40, 600);
	  drawer.text("Cualquier equipo listo para embarcarse o entregarse y que no sea liberado para su env�o por causas imputables al Cliente (condiciones", 40, 620);
	  drawer.text("crediticias, direcci�n de embarque, retrasos en la adecuaci�n del sitio, etc.) causar� un cargo por almacenaje sobre el valor de la ", 40, 630);
	  drawer.text("mercanc�a del 0.15% por cada d�a natural, despu�s de transcurridos cinco d�as naturales desde la fecha de notificaci�n por parte de", 40, 640);
	  drawer.text("nuestro personal.", 40, 650);
	  drawer.text("9. Transferencia de Propiedad", 40, 670, true);
	  drawer.text("La transferencia de propiedad tendr� lugar en el sitio donde se entreguen los equipos, pagados en su totalidad y con la facturaci�n", 40, 680);
	  drawer.text("de los mismos.", 40, 690);
	  drawer.text("10. Riesgos", 40, 710, true);
	  drawer.text("Los riesgos inherentes a los equipos y servicios se tendr�n por traspasados al Cliente en el lugar y fecha en que se pongan a su", 40, 720);
	  drawer.text("disposici�n y se cuente con su firma en el documento de entrega que corresponda.", 40, 730);
	  drawer.text("11. Garant�a", 40, 750, true);
	  drawer.text("Las garant�as de cada uno de los equipos y/o servicios entregados se manifestar� en un documento interno de GRUPO SAC en donde", 40, 760);
	  drawer.text("se especifique el plazo.", 40, 770);
	  printFooter();
	  drawer.newPage();
	  printHeader();
	  drawer.text("12. Causas de Fuerza Mayor", 40, 120, true);
	  drawer.text("GRUPO SAC no ser� responsable por el incumplimiento en las condiciones mencionadas en esta oferta cuando �ste sea consecuencia", 40, 130);
	  drawer.text("de causas de fuerza mayor o caso fortuito.", 40, 140);
	  drawer.text("Se entiende por causas de fuerza mayor o causas ajenas a GRUPO SAC las que se mencionan en forma enunciativa m�s no limitativa:", 40, 160);
	  drawer.text("guerra, disturbios civiles, cataclismos, incendios, cuarentena, requisiciones, condiciones clim�ticas severas, disposici�n gubernamental", 40, 170);
	  drawer.text(", interrupci�n de la disponibilidad de mano de obra o cualquier otra circunstancia fuera del control razonable de GRUPO SAC.", 40, 180);
	  drawer.text("13. Acuerdos", 40, 200, true);
	  drawer.text("En caso de que exista alguna inconformidad respecto a la entrega de los equipos, prestaci�n de los servicios o incumplimiento en su", 40, 210);
	  drawer.text("pedido, esta deber� manifestarse en un lapso que no exceda de 15 (quince) d�as naturales, as� como elaborar el formato de acciones", 40, 220);
	  drawer.text("correctivas con los acuerdos y fechas de cumplimiento.", 40, 230);
	  drawer.text("En el supuesto de que no se llegue a ning�n acuerdo, las partes aceptan que se someter�n expresamente a la jurisdicci�n y competencia", 40, 250);
	  drawer.text("de los Tribunales competentes en la Ciudad de Guadalajara, Jalisco.", 40, 260);
	  drawer.text("14. L�mites de Responsabilidad por Da�o Indirecto Consecuencial", 40, 280, true);
	  drawer.text("Ninguna de las partes ser� responsable ante la otra por cualquier p�rdida de beneficio, p�rdida de uso, p�rdida de producci�n, p�rdida", 40, 290);
	  drawer.text("de contratos o por cualquier otro da�o indirecto o de consecuencia que pueda sufrir la otra parte. En caso de que ocurran da�os en", 40, 300);
	  drawer.text("en terceros, ser� la entidad legal y jur�dica competente en la Ciudad de Guadalajara, Jalisco, la encargada de dictaminar o conciliar", 40, 310);
	  drawer.text("las responsabilidades y penalidades por ley.", 40, 320);
	  drawer.text("En espera de que la presente oferta sea de su agrado y conveniencia, quedamos a sus �rdenes para cualquier duda o aclaraci�n al", 40, 340);
	  drawer.text("respecto.", 40, 350);
	  drawer.text("Atentamente", 45, 480, true);
	  drawer.text("DIRECTO MEXICO", 45, 520);
	  drawer.text("Ingenier�a de Servicio en Protecci�n Integral", 45, 530);
	  drawer.text("Tel: (55) 50202160", 45, 540);
	  drawer.text("nicolas.andrade@gposac.com.mx", 45, 550);
	  drawer.text("www.gposac.com.mx", 45, 560);
	  drawer.text("Aprobado por", 350, 480, true);
	  drawer.text("Nombre:", 350, 520);
	  drawer.text("Firma:", 350, 540);
	  drawer.text("Fecha:", 350, 560);
  }
  
  public static void main(String [] args) throws Exception{
	PriceProposalReport serv = new PriceProposalReport();
	FileOutputStream see = new FileOutputStream("C:/PriceProposal.pdf");
	ProjectVO project = new ProjectVO();
	project.setId(1);
	project.setClientDescription("Sistema Nal. de Aguas");
	project.setContactName("Sergio Gomez A.");
	ProjectEntryVO entry = null;
	List<ProjectEntryVO> entries = new ArrayList<ProjectEntryVO>();
	List<ProjectEntryItemVO> items = null;
	for(int i = 0; i < 63 ; i++){
		entry = new ProjectEntryVO(i, i, i, "Tipo " + i, "Descripcion " + i
			     , Float.valueOf(i), Float.valueOf(i * 10), "Comentarios " + i);
		entries.add(entry);	
		items = new ArrayList<ProjectEntryItemVO>();
		for(int j = 0; j < 5 ; j++){
			items.add(new ProjectEntryItemVO(j, i, j, "", "", "",  j, Float.valueOf(j * i), 0F, 0F, ""));
		}
		entry.setItems(items);
	}
    project.setEntries(entries);
	see.write(serv.getReport(project));
	see.close();
  }

}
