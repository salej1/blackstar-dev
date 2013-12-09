package com.blackstar.services.report.core;

import java.io.FileOutputStream;

import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class EmergencyPlantServiceReport extends AbstractReport {
		
  public void run() throws Exception {
	printHeader("REPORTE DE SERVICIO","PLANTAS DE EMERGENCIA", "PE", "1254");
	printFeatures();
	printInformation();
	printInspection();
	printServices();
	printDynamicTest();
	printProtection();
	printInterruptor();
	printReading();
	printOthers();
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
	drawer.text("CAPACIDAD: ", 5, 128, false);
	drawer.text("FECHA Y HORA DE LLEGADA: ", 320, 128, false);
	drawer.hLine(0, 555, 132);
	drawer.vLine(87, 132, 0);
	drawer.vLine(87, 132, 555);
  }
  
  private void printInformation() throws Exception {
	drawer.box(0, 141, 555, 13, 0x0155A5, true);
	drawer.text("DATOS DEL EQUIPO", 240, 150, true, Color.white);
	drawer.text("P.E. MARCA: ", 2, 162, false, 0, 6);
	drawer.text("MOTOR DIESEL MARCA: ", 186, 162, false, 0, 6);
	drawer.text("CAPACIDAD TANQUE DIESEL: ", 370, 162, false, 0, 6);
	drawer.hLine(0, 555, 164, 0x0155A5);
	drawer.text("MODELO PE: ", 2, 173, false, 0, 6);
	drawer.text("MODELO MOTOR: ", 186, 173, false, 0, 6);
	drawer.text("MOD.DE LA BOMBA DE COMBUST ", 370, 173, false, 0, 5.5F);
	drawer.hLine(0, 555, 175, 0x0155A5);
	drawer.text("No. SERIE PE: ", 2, 184, false, 0, 6);
	drawer.text("No. DE SERIE MOTOR: ", 186, 184, false, 0, 6);
	drawer.text("FILTRO DE COMBUSTIBLE(SE CAMBIO?): ", 370, 184, false, 0, 4.5F);
	drawer.hLine(0, 555, 186, 0x0155A5);
	drawer.text("TIPO DE TRANSFERENCIA: ", 2, 195, false, 0, 6);
	drawer.text("CPL MOTOR: ", 186, 195, false, 0, 6);
	drawer.text("FILTRO DE ACEITE (SE CAMBIO?): ", 370, 195, false, 0, 5.5F);
	drawer.hLine(0, 555, 197, 0x0155A5);
	drawer.text("MCA / MODELO TRANS.: ", 2, 206, false, 0, 6);
	drawer.text("GENERADOR MCA: ", 186, 206, false, 0, 6);
	drawer.text("FILTRO DE AGUA (SE CAMBIO?): ", 370, 206, false, 0, 5.8F);
	drawer.hLine(0, 555, 208, 0x0155A5);
	drawer.text("MCA / MODELO CONTROL: ", 2, 217, false, 0, 6);
	drawer.text("MDOELO GENERADOR: ", 186, 217, false, 0, 6);
	drawer.text("FILTRO DE AIRE (SE CAMBIO?): ", 370, 217, false, 0, 5.9F);
	drawer.hLine(0, 555, 219, 0x0155A5);
	drawer.text("MCA / MODELO REGULADOR ", 2, 226, false, 0, 6);
	drawer.text("DE VOLTAJE: ", 2, 233, false, 0, 6);
	drawer.text("No. DE SERIE GEN.: ", 186, 228, false, 0, 6);
	drawer.text("RELOJ CUENTA HORAS (LECTURA): ", 370, 228, false, 0, 5.2F);
	drawer.hLine(0, 555, 234, 0x0155A5);
	drawer.text("MCA / MODELO REGULADOR ", 2, 241, false, 0, 6);
	drawer.text("DE VELOCIDAD: ", 2, 248, false, 0, 6);
	drawer.text("POTENCIA (KW) GEN: ", 186, 243, false, 0, 6);
	drawer.text("MODELO DE BATERIAS: ", 370, 243, false, 0, 6);
	drawer.hLine(0, 555, 249, 0x0155A5);
	drawer.text("MCA / MOD. DEL  ", 2, 255, false, 0, 6);
	drawer.text("CARGADOR BATT: ", 2, 262, false, 0, 6);
	drawer.text("TENSION GEN: ", 186, 258, false, 0, 6);
	drawer.text("RELOJ CUENTA HORAS (LECTURA): ",370, 258, false, 0, 5.2F);
	drawer.hLine(0, 555, 264, 0x0155A5);
	drawer.text("ULTIMO CAMBIO DE ACEITE: ", 2, 273, false, 0, 6);
	drawer.text("ULTIMA FECHA DE AFINACION: ", 186, 273, false, 0, 6);
	drawer.text("ULTIMO SERVICIO CORRECTIVO: ", 370, 273, false, 0, 5.6f);
	drawer.hLine(0, 555, 275, 0x0155A5);
	
	drawer.vLine(141, 275, 0, 0x0155A5);
	drawer.vLine(141, 275, 555, 0x0155A5);
	
	drawer.vLine(154, 275, 92, 0x0155A5);
	drawer.vLine(154, 275, 184, 0x0155A5);
	drawer.vLine(154, 275, 276, 0x0155A5);
	drawer.vLine(154, 275, 368, 0x0155A5);
	drawer.vLine(154, 275, 460, 0x0155A5);
  }
  
  private void printInspection() throws Exception {
	drawer.box(0, 275, 555, 13, 0x0155A5, true);
	drawer.text("INSPECCION BASICA", 240, 284, true, Color.white);
	drawer.text("NIVEL/LIMP/CAMBIO DE ACEITE ", 2, 294, false, 0, 5.5F);
	drawer.text("LUBRICANTE (SE CAMBIO?): ", 2, 301, false, 0, 5.5F);
	drawer.text("ZAPATAS DE BATERIA: ", 186, 298, false, 0, 6);
	drawer.text("MANGUERAS COMBUSTIBLE: ", 370, 298, false, 0, 6);
	drawer.hLine(0, 555, 303, 0x0155A5);
	drawer.text("NIVEL DE AGUA/ANTICONGELANTE ", 2, 309, false, 0, 5F);
	drawer.text("(SE CAMBIO?): ", 2, 315, false, 0, 5.5F);
	drawer.text("SUFATACION BATERIA: ", 186, 313, false, 0, 6);
	drawer.text("MANGUERAS AGUA: ", 370, 313, false, 0, 6);
	drawer.hLine(0, 555, 318, 0x0155A5);
	drawer.text("NIVEL ELECTROLITO BATERIA: ", 2, 327, false, 0, 6);
	drawer.text("NIVEL DE COMBUSTIBLE EN %: ", 186, 327, false, 0, 6);
	drawer.text("VALVULAS Y TUBERIAS (Cu/NEGRAS): ", 370, 327, false, 0, 4.9F);
	drawer.hLine(0, 555, 329, 0x0155A5);
	drawer.text("FUGA EN TUBO DE ESCAPE: ", 2, 338, false, 0, 6);
	drawer.text("PRECALENTADO DE LA MAQUINA: ", 186, 338, false, 0, 5.5F);
	drawer.text("TENSIOND E BANDAS/ESTADO DE ASPAS ", 370, 338, false, 0, 4.5F);
	drawer.hLine(0, 555, 340, 0x0155A5);
	
	drawer.vLine(288, 340, 0, 0x0155A5);
	drawer.vLine(288, 340, 555, 0x0155A5);
	
	drawer.vLine(288, 340, 92, 0x0155A5);
	drawer.vLine(288, 340, 184, 0x0155A5);
	drawer.vLine(288, 340, 276, 0x0155A5);
	drawer.vLine(288, 340, 368, 0x0155A5);
	drawer.vLine(288, 340, 460, 0x0155A5);
  }
  
  private void printServices() throws Exception {
	drawer.box(0, 340, 555, 13, 0x0155A5, true);
	drawer.text("SERVICIOS BASICOS", 240, 349, true, Color.white);
	drawer.text("LAVADO DE MOTOR/TANQUE (PURGA): ", 2, 359, false, 0, 4.5F);
	drawer.text("SOPLETEADO DE TRANSFER: ", 186, 361, false, 0, 6);
	drawer.text("PRUEBAS DE BATERIAS ", 370, 361, false, 0, 6);
	drawer.hLine(0, 555, 363, 0x0155A5);
	drawer.text("LAVADO DE RADIADOR: ", 2, 371, false, 0, 6);
	drawer.text("LIMPIEZA TARJETAS DE CONTROL: ", 186, 371, false, 0, 5);
	drawer.text("REV. CARGADOR DE BAT/ALERNADOR ", 370, 371, false, 0, 4.5F);
	drawer.hLine(0, 555, 374, 0x0155A5);
	drawer.text("LIMPIEZA AREA DE TRABAJO: ", 2, 383, false, 0, 6);
	drawer.text("AJUSTE CONEXIONES CONTROL: ", 186, 383, false, 0, 5.5F);
	drawer.text("PINTURA Y CONSERVACION: ", 370, 383, false, 0, 6);
	drawer.hLine(0, 555, 385, 0x0155A5);
	drawer.text("REVISION DE CABLEADO Y CONEXIONES ", 2, 393, false, 0, 4.5F);
	drawer.text("REV. DE EXITATRIZ/EMBOBINADOS: ", 186, 393, false, 0, 5F);
	drawer.text("SOPLETEADO TAB. GENERADOR: ", 370, 393, false, 0, 5.5F);
	drawer.hLine(0, 555, 396, 0x0155A5);
	
	drawer.vLine(353, 396, 0, 0x0155A5);
	drawer.vLine(353, 396, 555, 0x0155A5);
	
	drawer.vLine(353, 396, 92, 0x0155A5);
	drawer.vLine(353, 396, 184, 0x0155A5);
	drawer.vLine(353, 396, 276, 0x0155A5);
	drawer.vLine(353, 396, 368, 0x0155A5);
	drawer.vLine(353, 396, 460, 0x0155A5);
  }
  
  private void printDynamicTest() throws Exception {
	drawer.box(0, 396, 555, 13, 0x0155A5, true);
	drawer.text("PRUEBAS DINAMICAS MOTOR DE COMBUSTION", 110, 405, true, Color.white);
	drawer.text("(Solicitar autorizacion para pruebas con carga)", 300, 404, false, Color.white, 6);
	drawer.text("FRECUENCIA EN VACIO: ", 2, 416, false, 0, 6);
	drawer.text("VOLTAJE EN VACIO: ", 186, 416, false, 0, 6);
	drawer.text("TIEMPO DE ARRANQUE ", 370, 416, false, 0, 6);
	drawer.hLine(0, 555, 419, 0x0155A5);
	drawer.text("FRECUENCIA CON CARGA: ", 2, 428, false, 0, 6);
	drawer.text("VOLTAJE CON CARGA: ", 186, 428, false, 0, 6);
	drawer.text("TIEMPO DE RETRANSFERENCIA ", 370, 428, false, 0, 5.7F);
	drawer.hLine(0, 555, 430, 0x0155A5);
	drawer.text("NUM. DE INTENTOS DE ARRANQUE: ", 2, 438, false, 0, 5);
	drawer.text("CALIDAD DE EMISIONES DE HUMO: ", 186, 438, false, 0, 5);
	drawer.text("TIEMPO DE PARO ", 370, 438, false, 0, 6);
	drawer.hLine(0, 555, 441, 0x0155A5);
	
	drawer.vLine(409, 441, 0, 0x0155A5);
	drawer.vLine(409, 441, 555, 0x0155A5);
	
	drawer.vLine(409, 441, 92, 0x0155A5);
	drawer.vLine(409, 441, 184, 0x0155A5);
	drawer.vLine(409, 441, 276, 0x0155A5);
	drawer.vLine(409, 441, 368, 0x0155A5);
	drawer.vLine(409, 441, 460, 0x0155A5);
  }
  
  private void printProtection() throws Exception {
	drawer.box(0, 441, 555, 13, 0x0155A5, true);
	drawer.text("PRUEBAS DE PROTECCION DEL EQUIPO", 190, 450, true, Color.white);
	drawer.text("SENSOR DE TEMPERATURA:", 2, 461, false, 0, 5);
	drawer.text("SENSOR DE VOLTAJE O GENERACION:", 186, 461, false, 0, 4.5F);
	drawer.text("SENSOR BAJA PRESION DE ACEITE:", 370, 461, false, 0, 5F);
	drawer.hLine(0, 555, 464, 0x0155A5);
	drawer.text("SENSOR DE PRESION DE ACEITE:", 2, 472, false, 0, 5);
	drawer.text("SENSOR DE SOBREVELOCIDAD:", 186, 472, false, 0, 5.8F);
	drawer.text("SENSOR BDE NIVEL DE AGUA:", 370, 472, false, 0, 6);
	drawer.hLine(0, 555, 475, 0x0155A5);
	
	
	drawer.vLine(454, 475, 0, 0x0155A5);
	drawer.vLine(454, 475, 555, 0x0155A5);
	
	drawer.vLine(454, 475, 92, 0x0155A5);
	drawer.vLine(454, 475, 184, 0x0155A5);
	drawer.vLine(454, 475, 276, 0x0155A5);
	drawer.vLine(454, 475, 368, 0x0155A5);
	drawer.vLine(454, 475, 460, 0x0155A5);
  }
  
  private void printInterruptor() throws Exception {
	drawer.box(0, 475, 555, 13, 0x0155A5, true);
	drawer.text("INTERRUPTOR DE TRANSFERENCIA AUTOMATICO", 175, 484, true, Color.white);
	drawer.text("ESTADO MECANICO:", 2, 495, false, 0, 6);
	drawer.text("AJUSTE DE TORNILLERIA:", 186, 495, false, 0, 6);
	drawer.text("INTERLOOK ELECTRICO:", 370, 495, false, 0, 6);
	drawer.hLine(0, 555, 498, 0x0155A5);
	drawer.text("LIMPIEZA DE TABLERO:", 2, 506, false, 0, 6);
	drawer.text("AJUSTE DE CONEXIONES:", 186, 506, false, 0, 6);
	drawer.text("INTERLOOK MECANICO:", 370, 506, false, 0, 6);
	drawer.hLine(0, 555, 509, 0x0155A5);
	drawer.text("PRUEBA DE LAMPARAS:", 2, 517, false, 0, 6);
	drawer.text("MOTOR(ES) DEL SISTEMA:", 186, 517, false, 0, 6);
	drawer.text("CAPACIDAD DE AMPERES:", 370, 517, false, 0, 6);
	drawer.hLine(0, 555, 520, 0x0155A5);
	
	drawer.vLine(488, 520, 0, 0x0155A5);
	drawer.vLine(488, 520, 555, 0x0155A5);
	drawer.vLine(488, 520, 92, 0x0155A5);
	drawer.vLine(488, 520, 184, 0x0155A5);
	drawer.vLine(488, 520, 276, 0x0155A5);
	drawer.vLine(488, 520, 368, 0x0155A5);
	drawer.vLine(488, 520, 460, 0x0155A5);
  }
  
  private void printReading() throws Exception {
	drawer.box(0, 520, 555, 13, 0x0155A5, true);
	drawer.text("LECTURAS DEL SISTEMA (CON CARGA / SIN CARGA)", 180, 529, true, Color.white);
	drawer.text("VOLTAJE AB-AN:", 2, 540, false, 0, 6);
	drawer.text("CORRIENTE A (AMP):", 186, 540, false, 0, 6);
	drawer.text("FRECUENCIA:", 370, 540, false, 0, 6);
	drawer.hLine(0, 555, 543, 0x0155A5);
	drawer.text("VOLTAJE AC-CN:", 2, 551, false, 0, 6);
	drawer.text("CORRIENTE B (AMP):", 186, 551, false, 0, 6);
	drawer.text("PRESION DE ACEITE:", 370, 551, false, 0, 6);
	drawer.hLine(0, 555, 554, 0x0155A5);
	drawer.text("VOLTAJE BC-BN:", 2, 562, false, 0, 6);
	drawer.text("CORRIENTE C (AMP):", 186, 562, false, 0, 6);
	drawer.text("TEMPERATURA:", 370, 562, false, 0, 6);
	drawer.hLine(0, 555, 565, 0x0155A5);
	drawer.text("VOLTAJE NT:", 2, 573, false, 0, 6);
	drawer.hLine(0, 555, 576, 0x0155A5);
	
	drawer.vLine(533, 576, 0, 0x0155A5);
	drawer.vLine(533, 576, 555, 0x0155A5);
	drawer.vLine(533, 576, 92, 0x0155A5);
	drawer.vLine(533, 576, 184, 0x0155A5);
	drawer.vLine(533, 576, 276, 0x0155A5);
	drawer.vLine(533, 576, 368, 0x0155A5);
	drawer.vLine(533, 576, 460, 0x0155A5);
  }
  
  private void printOthers() throws Exception {
	drawer.box(0, 576, 555, 13, 0x0155A5, true);
	drawer.text("OTROS PARAMETROS", 235, 585, true, Color.white);
	drawer.text("AJUSTE DEL TERMOSTATO:", 2, 596, false, 0, 6);
	drawer.text("VOLTAJE FLOTACION BATERIAS:", 186, 596, false, 0, 5.7F);
	drawer.text("TIPO DE PROTECCION TRANSFER", 370, 596, false, 0, 5.4F);
	drawer.hLine(0, 555, 599, 0x0155A5);
	drawer.text("CORRIENTE PRECALENTADOR:", 2, 607, false, 0, 6);
	drawer.text("ESTADO RELOJ CUENTAS HORAS", 186, 607, false, 0, 5.5F);
	drawer.text("TIPO PROTECCION GENERADOR", 370, 607, false, 0, 5.5F);
	drawer.hLine(0, 555, 610, 0x0155A5);
	
	
	drawer.vLine(589, 610, 0, 0x0155A5);
	drawer.vLine(589, 610, 555, 0x0155A5);
	drawer.vLine(589, 610, 92, 0x0155A5);
	drawer.vLine(589, 610, 184, 0x0155A5);
	drawer.vLine(589, 610, 276, 0x0155A5);
	drawer.vLine(589, 610, 368, 0x0155A5);
	drawer.vLine(589, 610, 460, 0x0155A5);
  }
  
  private void printObservations() throws Exception {
	drawer.box(0, 610, 555, 13, 0x0155A5, true);
	drawer.text("OBSERVACIONES (HISTORIAL DE ALARMAS CUANDO APLIQUE)", 150, 619, true, Color.white);  
	drawer.hLine(0, 555, 633, 0x0155A5);
	drawer.hLine(0, 555, 644, 0x0155A5);
	drawer.hLine(0, 555, 655, 0x0155A5);
	drawer.vLine(623, 655, 0, 0x0155A5);
	drawer.vLine(623, 655, 555, 0x0155A5);
  }
  
//  public static void main(String [] args) throws Exception{
//	EmergencyPlantServiceReport serv = new EmergencyPlantServiceReport();
//	FileOutputStream see = new FileOutputStream("C:/Test.pdf");
//	see.write(serv.getReport());
//	see.close();
//  }
}
