package com.codex.service.pdf;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.services.report.AbstractReport;
import com.codex.vo.ProjectEntryItemVO;
import com.codex.vo.ProjectEntryVO;
import com.codex.vo.ProjectVO;
import com.pdfjet.Align;
import com.pdfjet.Color;
import com.pdfjet.Font;

public class PriceProposalReport extends AbstractReport {

  private ProjectVO data = null;
	
  protected void run(Object fillData) throws Exception {
	data = (ProjectVO) fillData;
	printHeader();
	printCover();
	printFooter(1);
	drawer.newPage();
	printHeader();
	printProposal();
	printFooter(2);
	drawer.newPage();
	printHeader();
	printContract();
	printFooter(4);
  }
	
	
  private void printHeader() throws Exception {
	drawer.image("pdf/logoSAC.jpg", 0, 10);
  }
  
  private void printCover() throws Exception {
	  // guides
//	  drawer.text("0",   0, 0, false, 0 , 10);
//	  drawer.text("20",  20, 0, false, 0 , 10);
//	  drawer.text("40",  40, 0, false, 0 , 10);
//	  drawer.text("60",  60, 0, false, 0 , 10);
//	  drawer.text("80",  80, 0, false, 0 , 10);
//	  drawer.text("100", 100, 0, false, 0 , 10);
//	  drawer.text("120", 120, 0, false, 0 , 10);
//	  drawer.text("140", 140, 0, false, 0 , 10);
//	  drawer.text("160", 160, 0, false, 0 , 10);
//	  drawer.text("180", 180, 0, false, 0 , 10);
//	  drawer.text("200", 200, 0, false, 0 , 10);
//	  drawer.text("220", 220, 0, false, 0 , 10);
//	  drawer.text("240", 240, 0, false, 0 , 10);
//	  drawer.text("260", 260, 0, false, 0 , 10);
//	  drawer.text("280", 280, 0, false, 0 , 10);
//	  drawer.text("300", 300, 0, false, 0 , 10);
//	  drawer.text("320", 320, 0, false, 0 , 10);
//	  drawer.text("340", 340, 0, false, 0 , 10);
//	  drawer.text("360", 360, 0, false, 0 , 10);
//	  drawer.text("380", 380, 0, false, 0 , 10);
//	  drawer.text("400", 400, 0, false, 0 , 10);
//	  drawer.text("420", 420, 0, false, 0 , 10);
//	  drawer.text("440", 440, 0, false, 0 , 10);
//	  drawer.text("460", 460, 0, false, 0 , 10);
//	  drawer.text("480", 480, 0, false, 0 , 10);
//	  drawer.text("500", 500, 0, false, 0 , 10);
//	  drawer.text("520", 520, 0, false, 0 , 10);
//	  drawer.text("540", 540, 0, false, 0 , 10);
//	  drawer.text("560", 560, 0, false, 0 , 10);
//	  drawer.text("580", 580, 0, false, 0 , 10);
//	  drawer.text("600", 600, 0, false, 0 , 10);
//	  drawer.text("620", 620, 0, false, 0 , 10);
//	  drawer.text("640", 640, 0, false, 0 , 10);
//	  drawer.text("660", 660, 0, false, 0 , 10);
	  //

	  drawer.text("Propuesta", getCenterX("Propuesta"), 200, true, 0, 12);
	  String projectNumber = data.getProjectNumber() + "-1";
	  drawer.text("Cotización No.", getCenterX("Cotización No."), 250, true, 0, 12);
	  drawer.text(projectNumber, getCenterX(projectNumber), 270, false, 0, 12);
	  drawer.text("Cliente:", getCenterX("Cliente:"), 300, false, 0, 10);
	  drawer.text(data.getClientDescription(), getCenterX(data.getClientDescription()), 320, false, 0, 12);
	  drawer.text("Atención:", getCenterX("Atención:"), 350, false, 0, 10);
	  drawer.text(data.getContactName(), getCenterX(data.getContactName()), 370, false, 0, 12);
	  drawer.text("Fecha de Creación:", getCenterX("Fecha de Creación:"), 400, true, 0, 10);
	  drawer.text("Aviso de Restricciones de Uso y Divulgación:", 0, 600, true, 0, 8);
	  drawer.text("La información contenida en la totalidad de esta Propuesta, constituye un secreto de marca y/o información comercial y/o financiera", 0, 615, true, 0, 8);
	  drawer.text("propiedad de SISTEMAS AVANZADOS EN COMPUTACIÓN DE MÉXICO, S.A. DE C.V., en lo sucesivo \"GRUPO SAC\", la cual, se encuentra", 0, 630, true, 0, 8);
	  drawer.text("clasificada como confidencial. Esta información es proporcionada con la restricción de que no podrá ser usada o divulgada sin el permiso", 0, 645, true, 0, 8);
	  drawer.text("de GRUPO SAC para otros propósitos que no sean para su evaluación, acordando con el Cliente, el protegerla con el mismo grado de cuidado", 0, 660, true, 0, 8);
	  drawer.text("que el mismo utilizaría para proteger su propia información.", 0, 675, true, 0, 8);

  }
  
  private void printFooter(int page) throws Exception {
	  drawer.text("La información contenida en la totalidad de este documento es clasificada como confidencial y se entrega bajo el entendido de que no será usada o", 40,785, false, Color.gray, 7);
	  drawer.text("divulgada, sin el permiso de Sistemas Avanzados en Computación de México, S.A. de C.V.", 40,795, false, Color.gray, 7);
	  drawer.text("4 - VE - 11                Rev. 0           31-08-2014                                                                TRA: Mientras este Activo   TRAM: 1 año", 40,805, false, Color.gray, 7);
	  drawer.text("Pag. " + page + "/4", 500 , 805, false, Color.gray, 7);
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
	  drawer.text("Damos a nuestros clientes la confianza de que sus procesos críticos trabajarán de forma continua gracias a nuestras", 40,190);
	  drawer.text("soluciones en monitoreo, protección eléctrica y climatización. Por lo tanto, el objetivo principal de la presente propuesta", 40,205);
	  drawer.text("es agregar valor a su Organización al proveerle una solución de ingeniería, configuración, puesta en operación y/o", 40,235);
	  drawer.text("mantenimiento para su  infraestructura orientada a resguardar su aplicación crítica.", 40,250);
	  drawer.hLine(40, 545, 290);
	  drawer.hLine(40, 545, 310);
	  drawer.vLine(290, 310, 40);
	  drawer.vLine(290, 310, 120);
	  drawer.vLine(290, 310, 320);
	  drawer.vLine(290, 310, 390);
	  drawer.vLine(290, 310, 460);
	  drawer.vLine(290, 310, 545);
	  drawer.text("No. partida", 60, 303, true);
	  drawer.text("Descripción", 200, 303, true);
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
	  
	  if(totalDiscount > 0){
		  drawer.text("Subtotal", 395, yFactor + 13, true);
		  drawer.text(totalPrice + "", 470, yFactor + 13, true);
		  drawer.text("Descuento", 395, yFactor + 33, true);
		  drawer.text(totalDiscount + "", 470, yFactor + 33, true);
		  drawer.text("Total USD", 395, yFactor + 53, true);
		  drawer.text((totalPrice - totalDiscount) + "", 470, yFactor + 53, true);
	  }
	  else{
		  drawer.text("Total USD", 395, yFactor + 33, true);
		  drawer.text((totalPrice) + "", 470, yFactor + 33, true);
	  }
	  
	  yFactor += 53;
	  
	  if((yFactor + 210) > 750){
		  yFactor = 90;
		  drawer.newPage();
		  printHeader();
	  }
	  
	  drawer.box(35, yFactor + 30, 510, 15, Color.gray, true);
	  drawer.vLine(yFactor + 40, yFactor + 270, 35);
	  drawer.vLine(yFactor + 40, yFactor + 270, 545);
	  drawer.hLine(35, 545, yFactor + 270);
	  
	  yFactor += 40;
	  
	  drawer.text("Al elegirnos como su proveedor, obtendrá, entre otros, los siguientes beneficios:", 75, yFactor);
	  drawer.point(75, yFactor + 40, 1.5F, 0, true);
	  drawer.text("Empresa reconocida en el medio con más de 26 años de experiencia", 75, yFactor + 23);
	  drawer.point(75, yFactor + 60, 1.5F, 0, true);
	  drawer.text("Presencia Nacional", 75, yFactor + 43);
	  drawer.point(75, yFactor + 80, 1.5F, 0, true);
	  drawer.text("Personal capacitado y certificado en su ramo", 75, yFactor + 63);
	  drawer.point(75, yFactor + 100, 1.5F, 0, true);
	  drawer.text("Representación y soporte directo de los fabricantes de los productos ofrecidos", 75, yFactor + 83);
	  drawer.point(75, yFactor + 120, 1.5F, 0, true);
	  drawer.text("Capacidad técnica y financiera", 75, yFactor + 103);
	  drawer.point(75, yFactor + 140, 1.5F, 0, true);
	  drawer.text("Soluciones llave en mano cuidando su efectividad y la eficiencia energética", 75, yFactor + 123);
	  drawer.point(75, yFactor + 160, 1.5F, 0, true);
	  drawer.text("Expertos en configuración, administración y monitoreo de su infraestructura.", 75, yFactor + 143);
	  drawer.point(75, yFactor + 180, 1.5F, 0, true);
	  drawer.text("Centro de Contacto multicanal:  lada gratuita nacional: 01 800 0830 203;  correo “call-center@gposac.com.mx” y", 75, yFactor + 163);

	  drawer.text("vía WEB.", 75, yFactor + 183);
	  drawer.point(75, yFactor + 220, 1.5F, 0, true);
	  drawer.text("Portal personalizado a nuestros clientes para la administración y estadísticas de servicio", 75, yFactor + 203);
	  drawer.point(75, yFactor + 240, 1.5F, 0, true);
	  drawer.text("Atención  especializada en cualquiera de las modalidades de servicio 5x8 ó 7X24", 75, yFactor + 223);
  }
  
  private void printContract() throws Exception {
	  drawer.box(35, 120, 510, 20, Color.gray, true);
	  drawer.text("Términos de Venta", 260, 134, true, 0, 10);
	  drawer.text("1. Validez de Oferta", 40, 160, true);
	  drawer.text("La presente cotización tiene vigencia hasta el día 12/OCT/2014", 40, 170);
	  drawer.text("2. Precio", 40, 190, true);
	  drawer.text("Los precios están cotizados en USD y no incluyen el impuesto al valor agregado (IVA), el cual se cargará al momento de la facturación.", 40, 200);
	  drawer.text("3. Condiciones de Pago", 40, 220, true);
	  drawer.text("30 DIAS A MES VENCIDO", 40, 230);
	  drawer.text("Nota: En caso de que se le ofrezca un crédito y no cuente con línea de crédito ya establecida con GRUPO SAC, su autorización estará supeditada", 40, 250);
	  drawer.text("al dictamen de nuestro departamento correspondiente. Para las cotizaciones en dólares el pago podrá ser realizado en moneda nacional con", 40, 260);
	  drawer.text("base al tipo de cambio publicado en el DOF del día en que se aplique en firme el deposito en nuestra cuenta bancaria.", 40, 270);
	  drawer.text("4. Entrega", 40, 290, true);
	  drawer.text("a) El tiempo de entrega es de " + data.getDeliveryTime() + " DIAS, el cual iniciará a partir de la recepción de su orden de compra y/o contrato y/o nuestra cotización", 40, 300);
	  drawer.text("y del deposito en firme del anticipo correspondiente.", 40, 310);
	  drawer.text("Los tiempos de entrega aquí mencionados están sujetos a la capacidad de la planta en el momento de recibir su orden de compra o pedido.", 40, 330);
	  drawer.text("b) La entrega será " + data.getIncoterm() + " en " + data.getLocation() + " Incoterms 2010.", 40, 350);
	  drawer.text("5. Modificaciones", 40, 370, true);
	  drawer.text("Cualquier modificación a los productos y/o servicios ofertados, una vez colocado su pedido, deberá ser evaluada por GRUPO SAC a fin de", 40, 380);
	  drawer.text("ser aprobada.", 40, 390);
	  drawer.text("Una vez aprobada por GRUPO SAC la modificación, finalmente se aceptará hasta contar con la confirmación por escrito del cliente, así como", 40, 410);
	  drawer.text("de precios y tiempos de entrega, en caso de que también hayan sufrido cambios.", 40, 420);
	  drawer.text("6. Cancelaciones", 40, 440, true);
	  drawer.text("GRUPO SAC no acepta la cancelación de pedidos, ya que su configuración se basa en especificaciones que satisfacen las necesidades", 40, 450);
	  drawer.text("particulares de un cliente.", 40, 460);
	  drawer.text("En caso de que esto ocurriera, el monto del cargo por cancelación se determinará por las inversiones realizadas específicamente para ese", 40, 480);
	  drawer.text("pedido y dependiendo de la etapa en que se encuentre con base en los siguientes porcentajes:", 40, 490);
	  drawer.point(65, 527, 1F, 0, true);
	  drawer.text("20% cuando se haya recibido el pedido del Cliente.", 50, 510);
	  drawer.point(65, 537, 1F, 0, true);
	  drawer.text("50 al 75% cuando se encuentre en la etapa de compra de equipos.", 50, 520);
	  drawer.point(65, 547, 1F, 0, true);
	  drawer.text("100% cuando los equipos se encuentren listos para ser embarcados.", 50, 530);
	  drawer.text("7. Inspección y Aceptación", 40, 550, true);
	  drawer.text("La entrega de nuestros productos y/o servicios se lleva a cabo previa inspección de los mismos y mediante documentos internos", 40, 560);
	  drawer.text("(Remisión y/u Orden de Servicio) en donde el Cliente firma de Aceptación.", 40, 570);
	  drawer.text("8. Empaque y Almacenamiento", 40, 590, true);
	  drawer.text("El empaque de los diferentes productos será de acuerdo a los estándares de cada uno de los fabricantes.", 40, 600);
	  drawer.text("Cualquier equipo listo para embarcarse o entregarse y que no sea liberado para su envío por causas imputables al Cliente (condiciones", 40, 620);
	  drawer.text("crediticias, dirección de embarque, retrasos en la adecuación del sitio, etc.) causará un cargo por almacenaje sobre el valor de la ", 40, 630);
	  drawer.text("mercancía del 0.15% por cada día natural, después de transcurridos cinco días naturales desde la fecha de notificación por parte de", 40, 640);
	  drawer.text("nuestro personal.", 40, 650);
	  drawer.text("9. Transferencia de Propiedad", 40, 670, true);
	  drawer.text("La transferencia de propiedad tendrá lugar en el sitio donde se entreguen los equipos, pagados en su totalidad y con la facturación", 40, 680);
	  drawer.text("de los mismos.", 40, 690);
	  drawer.text("10. Riesgos", 40, 710, true);
	  drawer.text("Los riesgos inherentes a los equipos y servicios se tendrán por traspasados al Cliente en el lugar y fecha en que se pongan a su", 40, 720);
	  drawer.text("disposición y se cuente con su firma en el documento de entrega que corresponda.", 40, 730);
	  drawer.text("11. Garantía", 40, 750, true);
	  drawer.text("La garantía de nuestros productos será de12 meses a partir de la puesta en marcha del equipo o 16 meses", 40, 760);
	  drawer.text("después de la entrega del él. La garantía pudiera variar si así lo indica(n) la(s) partida(s)", 40, 770);
	  printFooter(3);
	  drawer.newPage();
	  printHeader();
	  drawer.text("12. Causas de Fuerza Mayor", 40, 120, true);
	  drawer.text("GRUPO SAC no será responsable por el incumplimiento en las condiciones mencionadas en esta oferta cuando éste sea consecuencia", 40, 130);
	  drawer.text("de causas de fuerza mayor o caso fortuito.", 40, 140);
	  drawer.text("Se entiende por causas de fuerza mayor o causas ajenas a GRUPO SAC las que se mencionan en forma enunciativa más no limitativa:", 40, 160);
	  drawer.text("guerra, disturbios civiles, cataclismos, incendios, cuarentena, requisiciones, condiciones climáticas severas, disposición gubernamental", 40, 170);
	  drawer.text(", interrupción de la disponibilidad de mano de obra o cualquier otra circunstancia fuera del control razonable de GRUPO SAC.", 40, 180);
	  drawer.text("13. Acuerdos", 40, 200, true);
	  drawer.text("En caso de que exista alguna inconformidad respecto a la entrega de los equipos, prestación de los servicios o incumplimiento en su", 40, 210);
	  drawer.text("pedido, esta deberá manifestarse en un lapso que no exceda de 15 (quince) días naturales, así como elaborar el formato de acciones", 40, 220);
	  drawer.text("correctivas con los acuerdos y fechas de cumplimiento.", 40, 230);
	  drawer.text("En el supuesto de que no se llegue a ningún acuerdo, las partes aceptan que se someterán expresamente a la jurisdicción y competencia", 40, 250);
	  drawer.text("de los Tribunales competentes en la Ciudad de Guadalajara, Jalisco.", 40, 260);
	  drawer.text("14. Límites de Responsabilidad por Daño Indirecto Consecuencial", 40, 280, true);
	  drawer.text("Ninguna de las partes será responsable ante la otra por cualquier pérdida de beneficio, pérdida de uso, pérdida de producción, pérdida", 40, 290);
	  drawer.text("de contratos o por cualquier otro daño indirecto o de consecuencia que pueda sufrir la otra parte. En caso de que ocurran daños en", 40, 300);
	  drawer.text("en terceros, será la entidad legal y jurídica competente en la Ciudad de Guadalajara, Jalisco, la encargada de dictaminar o conciliar", 40, 310);
	  drawer.text("las responsabilidades y penalidades por ley.", 40, 320);
	  drawer.text("En espera de que la presente oferta sea de su agrado y conveniencia, quedamos a sus órdenes para cualquier duda o aclaración al", 40, 340);
	  drawer.text("respecto.", 40, 350);
	  drawer.text("Atentamente", 45, 480, true);
	  drawer.text("DIRECTO MEXICO", 45, 520);
	  drawer.text("Ingeniería de Servicio en Protección Integral", 45, 530);
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
			     , Float.valueOf(i), Double.valueOf(i * 10), "Comentarios " + i);
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
