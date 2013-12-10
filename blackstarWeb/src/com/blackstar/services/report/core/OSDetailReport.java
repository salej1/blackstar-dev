package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class OSDetailReport extends AbstractReport {
	
  public void run() throws Exception {
    printHeader("ORDEN DE SERVICIO", "OS", "1245");
	printFeatures();
	printDetails();
	printRequerements();
	printObservations();
	printFooter();
  }

  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.text("No. DE TICKET: ", 375, 98, false);
	drawer.hLine(0, 555, 102);
	drawer.text("DOMICILIO : ", 5, 113, false);
	drawer.text("FECHA Y HORA DE LLEGADA : ", 317, 113, false);
	drawer.hLine(0, 555, 117);
	drawer.text("SOLICITANTE : ", 5, 128, false);
	drawer.text("TELÉFONO : ", 387, 128, false);
	drawer.hLine(0, 555, 132);
	drawer.text("EQUIPO : ", 5, 143, false);
	drawer.text("MARCA : ", 155, 143, false);
	drawer.text("MODELO : ", 305, 143, false);
	drawer.text("SERIE : ", 407, 143, false);
	drawer.hLine(0, 555, 147);
	drawer.text("REPORTE DE FALLA : ", 5, 158, false);
	drawer.hLine(0, 555, 162);
	drawer.text("TIPO DE SERVICIO : ", 5, 173, false);
	drawer.text("CONTRATO / PROYECTO : ", 305, 173, false);
	drawer.hLine(0, 555, 177);
	drawer.vLine(87, 177, 0);
	drawer.vLine(87, 177, 555);
  }
	  
  private void printDetails() throws Exception {
	drawer.box(0, 187, 555, 13, 0x0155A5, true);
	drawer.text("SITUACION ENCONTRADA", 100, 197, true, Color.white);
	drawer.text("TRABAJOS REALIZADOS", 350, 197, true, Color.white);
	drawer.box(0, 280, 275, 13, 0x0155A5, true);
	drawer.text("PARAMETROS TÉCNICOS", 100, 289, true, Color.white);
	drawer.vLine(187, 379, 0, 0x0155A5);
	drawer.vLine(187, 379, 275, 0x0155A5);
	drawer.vLine(187, 379, 555, 0x0155A5);
	drawer.hLine(0, 555, 379, 0x0155A5);
  }
	  
  private void printRequerements() throws Exception {
	drawer.box(0, 390, 555, 13, 0x0155A5, true);
	drawer.text("REQUERIMIENTOS Ó MATERIAL UTILIZADO", 190, 399, true, Color.white);
	drawer.vLine(390, 550, 0, 0x0155A5);
	drawer.vLine(390, 550, 555, 0x0155A5);
	drawer.hLine(0, 555, 550, 0x0155A5);
  }
	  
  private void printObservations() throws Exception {
	drawer.box(0, 560, 555, 13, 0x0155A5, true);
	drawer.text("OBSERVACIONES / ESTATUS DEL EQUIPO", 190, 569, true, Color.white);
	drawer.vLine(560, 660, 0, 0x0155A5);
	drawer.vLine(560, 660, 555, 0x0155A5);
	drawer.hLine(0, 555, 660, 0x0155A5);
  }
  
//  public static void main(String [] args) throws Exception{
//	  OSDetailReport serv = new OSDetailReport();
//	FileOutputStream see = new FileOutputStream("C:/Test.pdf");
//	see.write(serv.getReport());
//	see.close();
//  }

}
