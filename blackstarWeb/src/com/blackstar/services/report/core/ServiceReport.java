package com.blackstar.services.report.core;

import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class ServiceReport extends AbstractReport {
	
  public void run() throws Exception {
	printHeader("REPORTE DE SERVICIO", "UPS", "1254");
	printFeatures();
	printActivities();
	printComments();
	printFooter();
  }
	  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.text("CONTRATO / PROYECTO: ", 340, 98, false);
	drawer.hLine(0, 555, 102);
	drawer.text("DOMICILIO: ", 5, 113, false);
	drawer.text("TELÉFONO: ", 390, 113, false);
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
	  
  private void printActivities() throws Exception {
    drawer.box(0, 157, 555, 13, 0x0155A5, true);
    drawer.text("ACTIVIDADES DESARROLLADAS:", 5, 166, true, Color.white);
    drawer.text("Estado del equipo encontrado:", 5, 185);
    drawer.hLine(103, 275, 185, 0x0155A5) ;
    drawer.text("Estado de los capacitores:", 285, 185);
    drawer.hLine(369, 550, 185, 0x0155A5) ;
    drawer.text("Sopleteado", 5, 200);
    drawer.text("Verificación de fusibles y protecciones eléctricas", 285, 200);
    drawer.vLine(185, 235, 240, 0x0155A5);
    drawer.vLine(185, 235, 275, 0x0155A5);
    drawer.hLine(240, 275, 201, 0x0155A5);
    drawer.hLine(240, 275, 218, 0x0155A5);
    drawer.hLine(240, 275, 235, 0x0155A5);
    drawer.vLine(185, 219, 515, 0x0155A5);
    drawer.vLine(185, 219, 550, 0x0155A5);
    drawer.hLine(515, 550, 202, 0x0155A5);
    drawer.hLine(515, 550, 219, 0x0155A5);
    drawer.hLine(251, 264, 187);
    drawer.hLine(251, 264, 200);
    drawer.vLine(187, 200, 251);
    drawer.vLine(187, 200, 264);
    drawer.hLine(251, 264, 203);
    drawer.hLine(251, 264, 216);
    drawer.vLine(203, 216, 251);
    drawer.vLine(203, 216, 264);
    drawer.hLine(251, 264, 220);
    drawer.hLine(251, 264, 233);
    drawer.vLine(220, 233, 251);
    drawer.vLine(220, 233, 264);
    drawer.hLine(526, 539, 187);
    drawer.hLine(526, 539, 200);
    drawer.vLine(187, 200, 526);
    drawer.vLine(187, 200, 539);
    drawer.hLine(526, 539, 204);
    drawer.hLine(526, 539, 217);
    drawer.vLine(204, 217, 526);
    drawer.vLine(204, 217, 539);
    drawer.text("Limpieza por aspirado y brocha:", 5, 215);
    drawer.text("Revisión y verificación del rectificador / cargador", 285, 215);
    drawer.text("Verificación de conexiones y reapriete tonillería(puntos calientes):", 5, 230);
    drawer.text("Estado de ventiladores:", 285, 230);
    drawer.hLine(360, 550, 230, 0x0155A5) ;
    drawer.text("BANCO DE BATERIAS:", 5, 260, true);
    drawer.text("Reapriete de puentes / conectores", 5, 275);
    drawer.text("Temperatura ambiente", 285, 275);
    drawer.hLine(360, 550, 275, 0x0155A5);
    drawer.text("Verificación de fugas y sulfataciones", 5, 290);
    drawer.text("Pruebas de carga y descarga", 285, 290);
    drawer.text("No. Baterías", 5, 305);
    drawer.hLine(48, 180, 305, 0x0155A5);
    drawer.text("Marca, modelo y capacidad", 186, 305);
    drawer.hLine(285, 550, 305, 0x0155A5);
    drawer.text("Fecha o serie de fabricación", 5, 320);
    drawer.text("Voltaje promedio de baterias", 285, 320);
    drawer.hLine(381, 550, 320, 0x0155A5); 
    drawer.hLine(98, 275, 320, 0x0155A5);
    drawer.text("Baterias dañadas (cant. y voltaje c/carga)", 5, 335);
    drawer.hLine(140, 550, 335, 0x0155A5);
    drawer.text("Otro (modelo banco externo)", 5, 350);
    drawer.hLine(100, 550, 350, 0x0155A5);
    drawer.vLine(262, 296, 240, 0x0155A5);
    drawer.vLine(262, 296, 275, 0x0155A5);
    drawer.hLine(240, 275, 262, 0x0155A5);
    drawer.hLine(240, 275, 279, 0x0155A5);
    drawer.hLine(240, 275, 296, 0x0155A5);
    drawer.hLine(251, 264, 264);
    drawer.hLine(251, 264, 277);
    drawer.vLine(264, 277, 251);
    drawer.vLine(264, 277, 264);
    drawer.hLine(251, 264, 281);
    drawer.hLine(251, 264, 294);
    drawer.vLine(281, 294, 251);
    drawer.vLine(281, 294, 264);
    drawer.vLine(275, 292, 515, 0x0155A5);
    drawer.vLine(275, 292, 550, 0x0155A5);
    drawer.hLine(515, 550, 292, 0x0155A5);
    drawer.hLine(527, 540, 277);
    drawer.hLine(527, 540, 290);
    drawer.vLine(277, 290, 527);
    drawer.vLine(277, 290, 540);
    drawer.text("PRUEBAS GENERALES:", 5, 380, true);
    drawer.text("(solicitar autorización para pruebas)", 100, 380);
    drawer.text("Transferencia y retransferencia a linea comercial (Bypass)", 5, 395);
    drawer.text("Transferencia y retransferencia con planta de emergencia", 5, 410);
    drawer.vLine(382, 416, 240, 0x0155A5);
    drawer.vLine(382, 416, 275, 0x0155A5);
    drawer.hLine(240, 275, 382, 0x0155A5);
    drawer.hLine(240, 275, 399, 0x0155A5);
    drawer.hLine(240, 275, 416, 0x0155A5);
    drawer.hLine(251, 264, 384);
    drawer.hLine(251, 264, 397);
    drawer.vLine(384, 397, 251);
    drawer.vLine(384, 397, 264);
    drawer.hLine(251, 264, 401);
    drawer.hLine(251, 264, 414);
    drawer.vLine(401, 414, 251);
    drawer.vLine(401, 414, 264);
    drawer.text("Respaldo en baterias con falla en linea", 285, 395);
    drawer.text("Verificacion de voltaje de baterias y de salida durante las pruebas", 285, 410);
    drawer.vLine(382, 416, 515, 0x0155A5);
    drawer.vLine(382, 416, 550, 0x0155A5);
    drawer.hLine(515, 550, 382, 0x0155A5);
    drawer.hLine(515, 550, 399, 0x0155A5);
    drawer.hLine(515, 550, 416, 0x0155A5);
    drawer.hLine(527, 540, 384);
    drawer.hLine(527, 540, 397);
    drawer.vLine(384, 397, 527);
    drawer.vLine(384, 397, 540);
    drawer.hLine(527, 540, 401);
    drawer.hLine(527, 540, 414);
    drawer.vLine(401, 414, 527);
    drawer.vLine(401, 414, 540);
    drawer.text("PARÁMETROS DE OPERACIÓN:", 5, 434, true);
    drawer.hLine(0, 555, 437, 0x0155A5);
    drawer.text("VOLTAJE ENTRADA FASE A FASE:", 5, 446);
    drawer.hLine(0, 555, 449, 0x0155A5);
    drawer.text("VOLTAJE SALIDA FASE A FASE:", 285, 446);
    drawer.hLine(0, 555, 449, 0x0155A5);
    drawer.text("VOLTAJE ENTRADA FASE A NEUTRO:", 5, 458);
    drawer.hLine(0, 555, 461, 0x0155A5);
    drawer.text("VOLTAJE SALIDA FASE A NEUTRO:", 285, 458);
    drawer.hLine(0, 555, 461, 0x0155A5);
    drawer.text("VOLTAJE ENTRE NEUTRO Y TIERRA:", 5, 470);
    drawer.hLine(0, 555, 473, 0x0155A5);
    drawer.text("VOLTAJE SALIDA FASE A NEUTRO:", 285, 470);
    drawer.hLine(0, 555, 473, 0x0155A5);
    drawer.text("PORCENTAJE DE CARGA O CORRIENTE:", 5, 482);
    drawer.hLine(0, 555, 485, 0x0155A5);
    drawer.text("VOLTAJE DEL BUS CD:", 285, 482);
    drawer.hLine(0, 555, 485, 0x0155A5);
    drawer.vLine(166, 485, 0);
    drawer.vLine(166, 485, 555);
  }
  
  private void printComments() throws Exception {
	drawer.box(0, 496, 555, 13, 0x0155A5, true);
	drawer.text("ACTIVIDADES DESARROLLADAS:", 5, 506, true, Color.white);
	drawer.text("Anotar comentarios del usuario (alarmas, respaldos o anomalías en el equipo). Anotar alarmas inusuales.", 5, 520);
	drawer.text("Indicar condiciones del lugar y estado final del equipo. Otras observaciones.", 5, 530);
    drawer.hLine(0, 555, 535, 0x0155A5);
    drawer.hLine(0, 555, 547, 0x0155A5);
    drawer.hLine(0, 555, 559, 0x0155A5);
    drawer.hLine(0, 555, 571, 0x0155A5);
    drawer.hLine(0, 555, 583, 0x0155A5);
    drawer.hLine(0, 555, 595, 0x0155A5);
    drawer.hLine(0, 555, 607, 0x0155A5);
    drawer.hLine(0, 555, 619, 0x0155A5);
    drawer.hLine(0, 555, 631, 0x0155A5);
    drawer.hLine(0, 555, 643, 0x0155A5);
    drawer.hLine(0, 555, 655, 0x0155A5);
    drawer.vLine(496, 655, 0, 0x0155A5);
    drawer.vLine(496, 655, 555, 0x0155A5);
  }
	  
	
//  public static void main(String [] args) throws Exception{
//	ServiceReport serv = new ServiceReport();
//	FileOutputStream see = new FileOutputStream("C:/Test.pdf");
//	see.write(serv.getReport());
//	see.close();
//  }

	}
