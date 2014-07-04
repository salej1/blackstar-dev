package com.blackstar.services.report;

import java.util.Date;

import com.blackstar.common.Utils;
import com.blackstar.services.report.util.PDFDrawer;
import com.pdfjet.Color;

public abstract class AbstractReport {
	
  protected PDFDrawer drawer = null;
  
  private static final int MAX_ADDRES_LEN = 60;
	
  protected abstract void run(Object data) throws Exception;
	
  public byte [] getReport(Object data) throws Exception {
	drawer = new PDFDrawer();
	run(data);
	drawer.close();
	return drawer.getStream().toByteArray();
  }
	
  protected void printHeader(String title,String description, String number) throws Exception {
	drawer.image("pdf/logoSAC.jpg", 0, 15, 0.82);
	drawer.image("pdf/TUV.jpg", 155, -5, 0.50);
	drawer.text("GUADALAJARA", 165,50, true);
	drawer.text("Tel. 01(33) 37-93-01-38", 158,62);
	drawer.text("Fax. 01(33) 37-93-01-44", 158,72);
	drawer.text("MÉXICO", 275, 50, true);
	drawer.text("Tel. 01(55) 50-20-21-60", 254,62);
	drawer.text("Fax. 01(55) 50-20-21-63", 254,72);
	drawer.text("QUERÉTARO", 360,50, true);
	drawer.text("Tel. 01(442) 295-24-68", 349,62);
	drawer.text("01800.0830203", 360,72, true);
	drawer.box(435, 47, 120, 12, true);
	drawer.text("FOLIO", 485, 56, true, Color.white);
	drawer.text(title, 550 - (title.length() *6), 35, true, 0x0155A5, 10);
	drawer.text(description, 345 - ((description.length() / 2 ) * 6), 30, true, 0, 8);
	drawer.box(435, 47, 120, 40, false);
	drawer.text(number, 440, 76, false, 0, 12);
  }
	  
  protected void printFooter(String signCreated, String responsible, Date closed
		  , String signReceivedBy, String receivedBy, String receivedByPosition) 
				                                              throws Exception {
	drawer.box(0, 670, 555, 13, true);
	drawer.text("REALIZADO POR:", 100, 679, true, Color.white);
	drawer.text("SERVICIO Y/O EQUIPO RECIBIDO A MI ENTERA SATISFACCION:", 287, 679, true, Color.white);
	drawer.vLine(670, 770, 275);
	drawer.hLine(0, 555, 740);
	drawer.hLine(0, 555, 755);
	drawer.hLine(0, 555, 770);
	drawer.vLine(670, 770, 0);
	drawer.vLine(670, 770, 555);
		
	drawer.text("FIRMA:", 5, 695);
	drawer.drawSignature(signCreated, .4F, 40,687);
	drawer.text("NOMBRE:", 5, 750);
	drawer.text(noCommas(responsible), 45, 750, true);
	drawer.text("FECHA Y HORA DE SALIDA:", 5, 765);
	drawer.text(format(closed), 113, 765, true);
		
	drawer.text("FIRMA:", 281, 695);
	drawer.drawSignature(signReceivedBy, .4F, 320,687);
	drawer.text("NOMBRE:", 281, 750);
	drawer.text(receivedBy, 321, 750, true);
	drawer.text("PUESTO:", 281, 765);	  
	drawer.text(receivedByPosition, 321, 765, true);
	
	drawer.text("REV-1 31-12-2012", 0, 780);
	drawer.text("TRA:MIENTRAS ESTE ACTIVO", 443, 780);
	drawer.text("4-SE-08", 0, 790);
	drawer.text("TRAM: 1 AÑO", 443, 790);
	drawer.text("www.gposac.com.mx", 235, 785, true, 0x0155A5);
  }
  
  protected String format(Date date){
	  return Utils.getDateString(date);
  }
  
  protected String noCommas(String string){
	 return  Utils.noCommas(string);
  }
  
  protected String trimAddress(String address){
	  if(address.length() > MAX_ADDRES_LEN){
		  address = address.substring(0, MAX_ADDRES_LEN);
	  }
	  return address;
  }
}
