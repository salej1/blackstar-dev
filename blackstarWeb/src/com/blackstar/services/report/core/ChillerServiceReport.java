package com.blackstar.services.report.core;

import java.io.FileOutputStream;

import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class ChillerServiceReport extends AbstractReport {
	
  public void run() throws Exception {
	printHeader("REPORTE DE SERVICIO","AIRES ACONDICIONADOS / CHILLER", "1254");
	printFeatures();
	printEvaporator();
	printCondenser();
	printObservations();
	printFooter();
  }
  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.text("CONTRATO / PROYECTO: ", 335, 98, false);
	drawer.hLine(0, 555, 102);
	drawer.text("DOMICILIO: ", 5, 113, false);
	drawer.text("TELÉFONO: ", 389, 113, false);
	drawer.hLine(0, 555, 117);
	drawer.text("MARCA: ", 5, 128, false);
	drawer.text("MODELO: ", 200, 128, false);
	drawer.text("CAPACIDAD: ", 385, 128, false);
	drawer.hLine(0, 555, 132);
	drawer.text("No. DE SERIE: ", 5, 143, false);
	drawer.text("FECHA Y HORA DE LLEGADA: ", 320, 143, false);
	drawer.hLine(0, 555, 147);
	drawer.vLine(87, 147, 0);
	drawer.vLine(87, 147, 555);
  }
  
  private void printEvaporator() throws Exception {
	 drawer.box(0, 157, 555, 13, 0x0155A5, true);
	 drawer.text("1. EVAPORADOR:", 250, 166, true, Color.white);
	 drawer.text("1.1 OPERACION Y ESTADO DE FUNCIONAMIENTO ENCONTRADO", 5, 183, false, 0, 6);
	 drawer.hLine(0, 555, 186, 0x0155A5) ;
	 drawer.text("1.2 VALORES ACTUALES", 5, 197, false, 0, 6);
	 drawer.text("Temp.", 417, 197, false, 0, 6);
	 drawer.text("Hum.", 487, 197, false, 0, 6);
	 drawer.hLine(0, 555, 200, 0x0155A5) ;
	 drawer.text("1.2.1 SETPOINTS", 5, 211, false, 0, 6);
	 drawer.text("Temp.", 417, 211, false, 0, 6);
	 drawer.text("Hum.", 487, 211, false, 0, 6);
	 drawer.hLine(0, 555, 214, 0x0155A5) ;
	 drawer.text("1.3 SE REALIZO COMPARACION Y CALIBRACION T/H MEDIO", 5, 225, false, 0, 6);
	 drawer.hLine(0, 555, 228, 0x0155A5) ;
	 drawer.text("1.4 REVISION Y LIMPIEZA DE FILTROS, EVAPORADOR Y EQUIPO EN GRAL.", 5, 239, false, 0, 6);
	 drawer.hLine(0, 555, 242, 0x0155A5) ;
	 drawer.text("1.5 REVISION Y Y AJUSTE DE BANDAS, ALINEACION Y BALANCEO DE TURBINAS", 5, 253, false, 0, 6);
	 drawer.hLine(0, 555, 256, 0x0155A5) ;
	 drawer.text("1.6 INSPECCION Y LIMPIEZA DE SISTEMA ELECTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES(PLATINOS)", 5, 267, false, 0, 6);
	 drawer.hLine(0, 555, 270, 0x0155A5) ;
	 drawer.text("1.7 REVISION Y LIMPIEZA DE SISTEMA DE CONTROL Y SENSOR DE TEMP/HUM", 5, 281, false, 0, 6);
	 drawer.hLine(0, 555, 284, 0x0155A5) ;
	 drawer.text("1.8 REVISION Y LIMPIEZA DE CHAROLA Y DRENAJE EN CONDENSADOS Y HUMIFICADOR", 5, 295, false, 0, 6);
	 drawer.hLine(0, 555, 298, 0x0155A5) ;
	 drawer.text("1.9 LECTURA DE PRESION DE COMPRESION  EN OPERACION NORMAL", 5, 309, false, 0, 6);
	 drawer.text("Alta", 417, 309, false, 0, 6);
	 drawer.text("Baja(60 psig min)", 465, 309, false, 0, 6);
	 drawer.hLine(0, 555, 312, 0x0155A5) ;
	 drawer.text("1.10 LECTURA DE TEMPERATURA EN SUCCION Y ENTRADA DE VALVULA DE EXPANSION", 5, 323, false, 0, 6);
	 drawer.hLine(0, 555, 326, 0x0155A5) ; 
	 drawer.text("1.11 ESTADO DE ACEITE EN EL COMPRESOR (Cuando aplique)", 5, 337, false, 0, 6);
	 drawer.text("Color", 417, 337, false, 0, 6);
	 drawer.text("Nivel", 487, 337, false, 0, 6);
	 drawer.hLine(0, 555, 340, 0x0155A5) ;
	 drawer.text("1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACION", 5, 351, false, 0, 6);
	 drawer.text("Color", 417, 351, false, 0, 6);
	 drawer.text("Nivel", 487, 351, false, 0, 6);
	 drawer.hLine(0, 555, 354, 0x0155A5) ;
	 drawer.text("1.13 REVISION DE OPERACIÓN DE PROTECCIONES POR BAJA Y ALTA PRESION", 5, 365, false, 0, 6);
	 drawer.hLine(0, 555, 368, 0x0155A5) ;
	 drawer.text("1.14 VERIFICAR RUIDOS EXTRAÑOS, VIBRACIÓN EXCESIVA, SENTADO DEL EQUIPO Y COMPONENTES, Y POSIBLES FUGAS EN EL SISTEMA", 5, 379, false, 0, 6);
	 drawer.hLine(0, 555, 382, 0x0155A5) ;
	 drawer.text("1.15 CORRECTO AISLAMIENTO DE TUBERIA Y TAPAS DEL EQUIPO", 5, 393, false, 0, 6);
	 drawer.hLine(0, 555, 396, 0x0155A5);
	 drawer.text("1.16 TOMA DE LECTURA DE VOLTAJE", 5, 407, false, 0, 6);
	 drawer.text("Fases a tierra", 282, 407, false, 0, 6);
	 drawer.text("Entre fases", 382, 407, false, 0, 6);
	 drawer.text("Control", 482, 407, false, 0, 6);
	 drawer.hLine(0, 555, 410, 0x0155A5);
	 drawer.text("1.17 LECTURA DE CORRIENTE POR FASE", 5, 421, false, 0, 6);
	 drawer.text("Motor", 282, 421, false, 0, 6);
	 drawer.line(340, 415, 338, 421);
	 drawer.line(380, 415, 378, 421);
	 drawer.text("Compresor", 418, 421, false, 0, 6);
	 drawer.line(476, 415, 474, 421);
	 drawer.line(516, 415, 514, 421);
	 
	 drawer.text("Humificador", 282, 435, false, 0, 6);
	 drawer.line(340, 429, 338, 435);
	 drawer.line(380, 429, 378, 435);
	 drawer.text("Calentador", 418, 435, false, 0, 6);
	 drawer.line(476, 429, 474, 435);
	 drawer.line(516, 429, 514, 435);
	 
	 
	 drawer.hLine(0, 555, 439, 0x0155A5);
	 drawer.text("1.18 PRUEBA DE SENSOR DE FLUJO DE AIRE Y FILTRO SUCIO", 5, 450, false, 0, 6);
	 drawer.hLine(0, 555, 453, 0x0155A5);
	 drawer.text("1.19 REQUERIMIENTO DE LAMINADO Y/O  PINTURA EN EQUIPO", 5, 464, false, 0, 6);
	 drawer.hLine(0, 555, 467, 0x0155A5);
	 
	 drawer.vLine(166, 396, 415, 0x0155A5);
	 drawer.vLine(396, 439, 280, 0x0155A5);
	 drawer.vLine(439, 467, 415, 0x0155A5);
	 drawer.vLine(166, 467, 0, 0x0155A5);
	 drawer.vLine(166, 467, 555, 0x0155A5);
	 drawer.vLine(186, 214, 485, 0x0155A5);
	 drawer.vLine(256, 270, 485, 0x0155A5);
	 drawer.vLine(284, 298, 485, 0x0155A5);
	 drawer.vLine(312, 354, 485, 0x0155A5);
  }
  
  private void printCondenser() throws Exception {
	drawer.box(0, 477, 555, 13, 0x0155A5, true);
	drawer.text("2. CONDENSADOR:", 250, 486, true, Color.white);
	drawer.text("2.1 REVISION DE CONDENSADOR (RUIDO, VIBRACION, FUGAS)Y VERIFICACION DE OPERACIONES DEL PROPELAS (ROTACION CORRECTA)", 5, 503, false, 0, 6);
	drawer.hLine(0, 555, 506, 0x0155A5) ;
	drawer.text("2.2 INSPECCION Y LIMPIEZA DEL SISTEMAS ELECTRICO , PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES", 5, 517, false, 0, 6);
	drawer.hLine(0, 555, 520, 0x0155A5);
	drawer.text("2.3 LAVADO DE CONDENSADOR (DRAY/FRUID COOLER) CON LIQUIDO DESINCRUSTANTE Y AGUA A PRESION", 5, 531, false, 0, 6);
	drawer.hLine(0, 555, 534, 0x0155A5);
	drawer.text("2.4 TOMA DE LECTURAS DE VOLTAJE", 5, 545, false, 0, 6);
	drawer.text("Fases a tierra", 282, 545, false, 0, 6);
	drawer.text("Entre fases", 382, 545, false, 0, 6);
	drawer.text("Control", 482, 545, false, 0, 6);
	drawer.hLine(0, 555, 548, 0x0155A5);
	drawer.text("2.5 LECTURA DE CORRIENTE EN MOTORES DE CONDENSADOR", 5, 559, false, 0, 6);
	drawer.hLine(0, 555, 562, 0x0155A5);
	drawer.text("2.6 REVISION Y AJUSTE DE TERMOSTATO (Según aplique)", 5, 573, false, 0, 6);
	drawer.hLine(0, 555, 576, 0x0155A5);
	drawer.text("MODELO:", 5, 587, false, 0, 6);
	drawer.text("No. DE SERIE:", 225, 587, false, 0, 6);
	drawer.text("MARCA:", 425, 587, false, 0, 6);
	drawer.hLine(0, 555, 590, 0x0155A5);
	
	drawer.vLine(490, 590, 0, 0x0155A5);
	drawer.vLine(490, 590, 555, 0x0155A5);
	
	drawer.vLine(486, 534, 415, 0x0155A5);
	drawer.vLine(534, 548, 280, 0x0155A5);
	drawer.vLine(548, 576, 415, 0x0155A5);
  }
  
  private void printObservations() throws Exception {
	drawer.hLine(0, 555, 602, 0x0155A5) ;
	drawer.text("OBSERVACIONES:", 25, 618, true, 0, 10);
	drawer.text("MANTENIMIENTO Y LECTURAS DE OTROS ACCESORIOS (BOMBAS, MANOMETROS, TERMOMETROS, ETC.)", 150, 610, false, 0, 6);
	drawer.text("REALIZAR PRUEBAS DE OPERACION (COOL / REHEAT / HUMIF / DESHUMIF), AJUSTES FINALES E HISTORIAL DE ALARMAS", 150, 620, false, 0, 6);
	drawer.hLine(0, 555, 624, 0x0155A5) ;
	drawer.hLine(0, 555, 660, 0x0155A5) ;
	drawer.vLine(602, 660, 0, 0x0155A5);
	drawer.vLine(602, 660, 555, 0x0155A5);
	
  }
  
  
  
//  public static void main(String [] args) throws Exception{
//	  ChillerServiceReport serv = new ChillerServiceReport();
//		FileOutputStream see = new FileOutputStream("C:/Test.pdf");
//		see.write(serv.getReport());
//		see.close();
//	  }

}
