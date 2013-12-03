package com.blackstar.services.impl;

import com.blackstar.services.report.AbstractReport;
import com.blackstar.services.report.util.PDFDrawer;
import com.pdfjet.Color;

public class ReporterServiceImpl extends AbstractReport {
	
  private PDFDrawer drawer = null;
	
  
  public void run() throws Exception {
	printHeader("REPORTE DE SERVICIO", "UPS", "1254");
	printFeatures();
	printDetails();
	printRequerements();
	printObservations();
	printSingns();
	printFooter();
  }
  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.text("CONTRATO / PROYECTO: ", 375, 98, false);
	drawer.hLine(0, 555, 102);
	drawer.text("DOMICILIO : ", 5, 113, false);
	drawer.text("TELÉFONO : ", 317, 113, false);
	drawer.hLine(0, 555, 117);
	drawer.text("MARCA : ", 5, 128, false);
	drawer.text("MODELO : ", 200, 128, false);
	drawer.text("CAPACIDAD : ", 305, 128, false);
	drawer.hLine(0, 555, 132);
	drawer.text("No. DE SERIE : ", 5, 143, false);
	drawer.text("FECHA Y HORA DE LLEGADA : ", 155, 143, false);
	drawer.hLine(0, 555, 147);
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
  
  private void printSingns() throws Exception {
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
	drawer.text("NOMBRE:", 5, 750);
	drawer.text("FECHA Y HORA DE SALIDA:", 5, 765);
	
	drawer.text("FIRMA:", 281, 695);
	drawer.text("NOMBRE:", 281, 750);
	drawer.text("PUESTO:", 281, 765);
  }

}
