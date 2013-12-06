package com.blackstar.services.report.core;

import java.io.FileOutputStream;

import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class BatteryMaintenanceReport extends AbstractReport {
	
  public void run() throws Exception {
	printHeader("REPORTE DE MANTENIMIENTO A BATERIAS","", "BB", "1245");
	printFeatures();
	printDetails();
	printGrid();
	printFooter();
  }
  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.hLine(0, 555, 102);
	drawer.text("NO DE ORDEN DE SERVICIO DE REFERENCIA: ", 5, 113, false);
	drawer.text("CONTRATO / PROYECTO:", 338, 113, false);
	drawer.hLine(0, 555, 117);
	drawer.text("MARCA: ", 5, 128, false);
	drawer.text("MODELO: ", 200, 128, false);
	drawer.text("CAPACIDAD: ", 387, 128, false);
	drawer.hLine(0, 555, 132);
	drawer.text("NO. DE BATERÍAS: ", 5, 143, false);
	drawer.text("TIPO: ", 200, 143, false);
	drawer.text("FECHA Y HORA DE LLEGADA: ", 323, 143, false);		
	drawer.hLine(0, 555, 147);
	drawer.vLine(87, 147, 0);
	drawer.vLine(87, 147, 555);
  }
  
  private void printDetails() throws Exception {
	 drawer.box(0, 157, 555, 35, 0x0155A5, true);
	 drawer.text("LIMPIEZA", 100, 167, true, Color.white);
	 drawer.text("EN CASO NECESARIO NEUTRALIZAR DERRAMES", 20, 177, true, Color.white);
	 drawer.text("DE ELECTROLITO CON LA SOLUCION ADECUADA", 20, 187, true, Color.white);
	 drawer.text("ESTADO FISICO", 255, 177, true, Color.white);
	 drawer.text("OBSERVACIONES", 410, 177, true, Color.white);
	 
	 drawer.text("CONECTORES/TERMINALES", 5, 208);
	 drawer.text("(APRIETE Y SULFATACION)", 5, 216);
	 
	 drawer.text("CUBIERTA", 5, 241);
	 drawer.text("TAPONES", 5, 266);
	 drawer.text("TIERRA FISICA", 5, 291);
	 drawer.text("ESTANTE/GABINETE/RACK", 5, 316);
	 drawer.text("# SERIE / LOTE / FECHA DE FABRICACION", 5, 341);
	 drawer.text("TEMP. PROMEDIO DE BATERIAS", 5, 366);
	 
	 drawer.hLine(180, 220, 200, 0x0155A5);
	 drawer.hLine(180, 220, 215, 0x0155A5);
	 drawer.vLine(200, 215, 180);
	 drawer.vLine(200, 215, 220);
	 
	 drawer.hLine(180, 220, 225, 0x0155A5);
	 drawer.hLine(180, 220, 240, 0x0155A5);
	 drawer.vLine(225, 240, 180);
	 drawer.vLine(225, 240, 220);
	 
	 drawer.hLine(180, 220, 250, 0x0155A5);
	 drawer.hLine(180, 220, 265, 0x0155A5);
	 drawer.vLine(250, 265, 180);
	 drawer.vLine(250, 265, 220);
	 
	 drawer.hLine(180, 220, 275, 0x0155A5);
	 drawer.hLine(180, 220, 290, 0x0155A5);
	 drawer.vLine(275, 290, 180);
	 drawer.vLine(275, 290, 220);
	 
	 drawer.hLine(180, 220, 300, 0x0155A5);
	 drawer.hLine(180, 220, 315, 0x0155A5);
	 drawer.vLine(300, 315, 180);
	 drawer.vLine(300, 315, 220);
	 
	 drawer.hLine(230, 555, 215, 0x0155A5);
	 drawer.hLine(230, 555, 240, 0x0155A5);
	 drawer.hLine(230, 555, 265, 0x0155A5);
	 drawer.hLine(230, 555, 290, 0x0155A5);
	 drawer.hLine(230, 555, 315, 0x0155A5);
	 drawer.hLine(230, 555, 340, 0x0155A5);
	 drawer.hLine(230, 555, 365, 0x0155A5);
	 
	 drawer.vLine(157, 192, 230, Color.white);
	 drawer.vLine(157, 192, 340, Color.white);
	 drawer.vLine(192, 365, 340, 0x0155A5);
	 drawer.hLine(0, 555, 375, 0x0155A5);
	 drawer.vLine(157, 375, 0, 0x0155A5);
	 drawer.vLine(157, 375, 555, 0x0155A5);
  }

  private void printGrid() throws Exception {
	  drawer.hLine(0, 555, 385, 0x0155A5);
	  drawer.text("VOLTAJE DE FLOTACION DEL BUS:", 30, 396);
	  drawer.text("V.C.D.", 210, 396);
	  drawer.text("TEMPERATURA AMBIENTE:", 380, 396);
	  drawer.text("°C", 510, 396);
	  drawer.hLine(0, 555, 400, 0x0155A5);
	  drawer.vLine(385, 659, 0, 0x0155A5);
	  drawer.text("BAT. Y/O", 9, 407, false, 0, 6);
	  drawer.text("CELDA No.", 6, 415, false, 0, 6);
	  
	  drawer.vLine(400, 659, 42, 0x0155A5);
	  drawer.text("VOLTAJE", 53, 407, false, 0, 6);
	  drawer.text("FLOTACION", 49, 415, false, 0, 6);
	  drawer.vLine(400, 659, 90, 0x0155A5);
	  drawer.text("VOLTAJE", 100, 407, false, 0, 6);
	  drawer.text("CON CARGA", 95, 415, false, 0, 6);
	  drawer.vLine(400, 659, 137, 0x0155A5);
	  
	  drawer.text("BAT. Y/O", 146, 407, false, 0, 6);
	  drawer.text("CELDA No.", 143, 415, false, 0, 6);
	  drawer.vLine(400, 659, 179, 0x0155A5);
	  drawer.text("VOLTAJE", 190, 407, false, 0, 6);
	  drawer.text("FLOTACION", 186, 415, false, 0, 6);
	  drawer.vLine(400, 659, 227, 0x0155A5);
	  drawer.text("VOLTAJE", 237, 407, false, 0, 6);
	  drawer.text("CON CARGA", 232, 415, false, 0, 6);
	  drawer.vLine(400, 659, 274, 0x0155A5);
	  
	  drawer.text("BAT. Y/O", 283, 407, false, 0, 6);
	  drawer.text("CELDA No.", 280, 415, false, 0, 6);
	  drawer.vLine(400, 659, 316, 0x0155A5);
	  drawer.text("VOLTAJE", 327, 407, false, 0, 6);
	  drawer.text("FLOTACION", 323, 415, false, 0, 6);
	  drawer.vLine(400, 659, 364, 0x0155A5);
	  drawer.text("VOLTAJE", 374, 407, false, 0, 6);
	  drawer.text("CON CARGA", 369, 415, false, 0, 6);
	  drawer.vLine(400, 659, 411, 0x0155A5);
	  
	  drawer.text("BAT. Y/O", 421, 407, false, 0, 6);
	  drawer.text("CELDA No.", 418, 415, false, 0, 6);
	  drawer.vLine(400, 659, 454, 0x0155A5);
	  
	  drawer.text("VOLTAJE", 466, 407, false, 0, 6);
	  drawer.text("FLOTACION", 462, 415, false, 0, 6);
	  drawer.vLine(400, 659, 503, 0x0155A5);

	  drawer.text("VOLTAJE", 515, 407, false, 0, 6);
	  drawer.text("CON CARGA", 510, 415, false, 0, 6);
	  drawer.vLine(385, 659, 555, 0x0155A5);
	  
	  
	  
	  drawer.hLine(0, 555, 417, 0x0155A5);
	  
	  drawer.hLine(0, 555, 428, 0x0155A5);
	  drawer.hLine(0, 555, 439, 0x0155A5);
	  drawer.hLine(0, 555, 450, 0x0155A5);
	  drawer.hLine(0, 555, 461, 0x0155A5);
	  drawer.hLine(0, 555, 472, 0x0155A5);
	  drawer.hLine(0, 555, 483, 0x0155A5);
	  drawer.hLine(0, 555, 494, 0x0155A5);
	  
	  drawer.hLine(0, 555, 505, 0x0155A5);
	  drawer.hLine(0, 555, 516, 0x0155A5);
	  drawer.hLine(0, 555, 527, 0x0155A5);
	  drawer.hLine(0, 555, 538, 0x0155A5);
	  drawer.hLine(0, 555, 549, 0x0155A5);
	  drawer.hLine(0, 555, 560, 0x0155A5);
	  drawer.hLine(0, 555, 571, 0x0155A5);
	  drawer.hLine(0, 555, 582, 0x0155A5);
	  
	  drawer.hLine(0, 555, 593, 0x0155A5);
	  drawer.hLine(0, 555, 604, 0x0155A5);
	  drawer.hLine(0, 555, 615, 0x0155A5);
	  drawer.hLine(0, 555, 626, 0x0155A5);
	  drawer.hLine(0, 555, 637, 0x0155A5);
	  drawer.hLine(0, 555, 648, 0x0155A5);
	  drawer.hLine(0, 555, 659, 0x0155A5);
	  
	  
	  
	  drawer.text("1", 19, 425, false, 0, 6);
	  drawer.text("2", 19, 436, false, 0, 6);
	  drawer.text("3", 19, 447, false, 0, 6);
	  drawer.text("4", 19, 458, false, 0, 6);
	  drawer.text("5", 19, 469, false, 0, 6);
	  drawer.text("6", 19, 480, false, 0, 6);
	  drawer.text("7", 19, 491, false, 0, 6);
	  drawer.text("8", 19, 502, false, 0, 6);
	  drawer.text("9", 19, 513, false, 0, 6);
	  drawer.text("10", 17, 524, false, 0, 6);
	  drawer.text("11", 17, 535, false, 0, 6);
	  drawer.text("12", 17, 546, false, 0, 6);
	  drawer.text("13", 17, 557, false, 0, 6);
	  drawer.text("14", 17, 568, false, 0, 6);
	  drawer.text("15", 17, 579, false, 0, 6);
	  drawer.text("16", 17, 590, false, 0, 6);
	  drawer.text("17", 17, 601, false, 0, 6);
	  drawer.text("18", 17, 612, false, 0, 6);
	  drawer.text("19", 17, 623, false, 0, 6);
	  drawer.text("20", 17, 634, false, 0, 6);
	  drawer.text("21", 17, 645, false, 0, 6);
	  drawer.text("22", 17, 656, false, 0, 6);
	  
	  
	  drawer.text("23", 154, 425, false, 0, 6);
	  drawer.text("24", 154, 436, false, 0, 6);
	  drawer.text("25", 154, 447, false, 0, 6);
	  drawer.text("26", 154, 458, false, 0, 6);
	  drawer.text("27", 154, 469, false, 0, 6);
	  drawer.text("28", 154, 480, false, 0, 6);
	  drawer.text("29", 154, 491, false, 0, 6);
	  drawer.text("30", 154, 502, false, 0, 6);
	  drawer.text("31", 154, 513, false, 0, 6);
	  drawer.text("32", 154, 524, false, 0, 6);
	  drawer.text("33", 154, 535, false, 0, 6);
	  drawer.text("34", 154, 546, false, 0, 6);
	  drawer.text("35", 154, 557, false, 0, 6);
	  drawer.text("36", 154, 568, false, 0, 6);
	  drawer.text("37", 154, 579, false, 0, 6);
	  drawer.text("38", 154, 590, false, 0, 6);
	  drawer.text("39", 154, 601, false, 0, 6);
	  drawer.text("40", 154, 612, false, 0, 6);
	  drawer.text("41", 154, 623, false, 0, 6);
	  drawer.text("42", 154, 634, false, 0, 6);
	  drawer.text("43", 154, 645, false, 0, 6);
	  drawer.text("44", 154, 656, false, 0, 6);
	  
	  drawer.text("45", 291, 425, false, 0, 6);
	  drawer.text("46", 291, 436, false, 0, 6);
	  drawer.text("47", 291, 447, false, 0, 6);
	  drawer.text("48", 291, 458, false, 0, 6);
	  drawer.text("49", 291, 469, false, 0, 6);
	  drawer.text("50", 291, 480, false, 0, 6);
	  drawer.text("51", 291, 491, false, 0, 6);
	  drawer.text("52", 291, 502, false, 0, 6);
	  drawer.text("53", 291, 513, false, 0, 6);
	  drawer.text("54", 291, 524, false, 0, 6);
	  drawer.text("55", 291, 535, false, 0, 6);
	  drawer.text("56", 291, 546, false, 0, 6);
	  drawer.text("57", 291, 557, false, 0, 6);
	  drawer.text("58", 291, 568, false, 0, 6);
	  drawer.text("59", 291, 579, false, 0, 6);
	  drawer.text("60", 291, 590, false, 0, 6);
	  drawer.text("61", 291, 601, false, 0, 6);
	  drawer.text("62", 291, 612, false, 0, 6);
	  drawer.text("63", 291, 623, false, 0, 6);
	  drawer.text("64", 291, 634, false, 0, 6);
	  drawer.text("65", 291, 645, false, 0, 6);
	  drawer.text("66", 291, 656, false, 0, 6);
	  
	  drawer.text("67", 429, 425, false, 0, 6);
	  drawer.text("68", 429, 436, false, 0, 6);
	  drawer.text("69", 429, 447, false, 0, 6);
	  drawer.text("70", 429, 458, false, 0, 6);
	  drawer.text("71", 429, 469, false, 0, 6);
	  drawer.text("72", 429, 480, false, 0, 6);
	  drawer.text("73", 429, 491, false, 0, 6);
	  drawer.text("74", 429, 502, false, 0, 6);
	  drawer.text("75", 429, 513, false, 0, 6);
	  drawer.text("76", 429, 524, false, 0, 6);
	  drawer.text("77", 429, 535, false, 0, 6);
	  drawer.text("78", 429, 546, false, 0, 6);
	  drawer.text("79", 429, 557, false, 0, 6);
	  drawer.text("80", 429, 568, false, 0, 6);
	  drawer.text("81", 429, 579, false, 0, 6);
	  drawer.text("82", 429, 590, false, 0, 6);
	  drawer.text("83", 429, 601, false, 0, 6);
	  drawer.text("84", 429, 612, false, 0, 6);
	  drawer.text("85", 429, 623, false, 0, 6);
	  drawer.text("86", 429, 634, false, 0, 6);
	  drawer.text("87", 429, 645, false, 0, 6);
	  drawer.text("88", 429, 656, false, 0, 6);
	  
	  
  }
  
//  public static void main(String [] args) throws Exception{
//	  BatteryMaintenanceReport serv = new BatteryMaintenanceReport();
//    FileOutputStream see = new FileOutputStream("C:/Test.pdf");
//    see.write(serv.getReport());
//    see.close();
//  }
}
