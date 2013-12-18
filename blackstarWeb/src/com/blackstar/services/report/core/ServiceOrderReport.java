package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import java.util.Date;

import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class ServiceOrderReport extends AbstractReport {
	
  private OrderserviceDTO data = null;
  
  public void run(Object fillData) throws Exception {
	  drawer.drawSignature("{\"lines\":[[[93.4,77.3],[93.4,79.3],[91.4,80.3],[89.4,81.3],[87.4,82.3],[83.4,82.3],[76.4,82.3],[69.4,82.3],[60.4,80.3],[50.4,77.3],[40.4,74.3],[33.4,67.3],[27.4,62.3],[22.4,54.3],[20.4,49.3],[20.4,40.3],[20.4,32.3],[20.4,23.3],[25.4,13.3],[29.4,6.3],[35.4,0.3],[44.4,-5.7],[53.4,-9.7],[61.4,-11.7],[71.4,-12.7],[81.4,-12.7],[92.4,-12.7],[108.4,-12.7],[121.4,-8.7],[137.4,-4.7],[144.4,0.3],[147.4,3.3],[147.4,5.3],[147.4,9.3],[147.4,13.3],[146.4,18.3],[139.4,23.3],[131.4,28.3],[116.4,37.3],[103.4,42.3],[92.4,45.3],[78.4,50.3],[67.4,52.3],[56.4,55.3],[43.4,59.3],[35.4,61.3],[26.4,64.3],[22.4,65.3],[19.4,67.3],[19.4,68.3],[19.4,69.3],[20.4,69.3],[23.4,69.3],[29.4,69.3],[43.4,69.3],[60.4,69.3],[72.4,69.3],[84.4,67.3],[91.4,64.3],[93.4,63.3],[92.4,63.3],[87.4,63.3],[74.4,68.3],[60.4,71.3],[48.4,76.3],[40.4,78.3],[39.4,79.3],[40.4,79.3],[44.4,79.3],[53.4,79.3],[62.4,79.3],[70.4,79.3],[75.4,79.3],[77.4,79.3],[79.4,79.3],[85.4,79.3],[92.4,79.3],[96.4,79.3],[98.4,79.3],[99.4,79.3],[100.4,79.3],[101.4,79.3],[103.4,79.3],[109.4,79.3],[113.4,79.3],[115.4,79.3],[112.4,79.3],[108.4,79.3],[106.4,79.3],[108.4,79.3],[115.4,79.3],[132.4,78.3],[155.4,78.3],[172.4,78.3],[184.4,78.3],[192.4,78.3],[193.4,78.3],[192.4,78.3],[189.4,78.3],[179.4,78.3],[168.4,78.3],[159.4,78.3],[155.4,78.3],[154.4,78.3],[154.4,77.3],[155.4,77.3],[158.4,75.3],[164.4,71.3],[174.4,64.3],[186.4,57.3],[199.4,49.3],[209.4,41.3],[222.4,35.3],[240.4,28.3],[257.4,23.3],[274.4,18.3],[288.4,15.3],[293.4,14.3],[293.4,13.3],[291.4,12.3],[285.4,11.3],[274.4,9.3],[255.4,9.3],[227.4,9.3],[207.4,9.3],[190.4,9.3],[176.4,9.3],[165.4,9.3],[155.4,12.3],[145.4,16.3],[135.4,23.3],[125.4,30.3],[116.4,38.3],[109.4,45.3],[104.4,54.3],[102.4,60.3],[101.4,63.3],[100.4,66.3],[100.4,67.3],[100.4,68.3],[100.4,69.3],[99.4,69.3],[99.4,70.3],[98.4,71.3],[98.4,72.3]]]}','{\"lines\":[[[249.4,72.3],[249.4,71.3],[248.4,70.3],[244.4,70.3],[239.4,68.3],[229.4,64.3],[217.4,60.3],[198.4,56.3],[164.4,47.3],[121.4,38.3],[75.4,32.3],[36.4,30.3],[-14.6,28.3],[-42.6,27.3],[-57.6,27.3],[-61.6,27.3],[-60.6,27.3],[-57.6,27.3],[-51.6,27.3],[-40.6,27.3],[-28.6,27.3],[-14.6,28.3],[4.4,30.3],[22.4,32.3],[44.4,32.3],[80.4,32.3],[108.4,32.3],[142.4,32.3],[170.4,32.3],[186.4,32.3],[196.4,32.3],[200.4,32.3],[201.4,32.3]]]}','vcbcvb',0),(667,'','I',NULL,354,'null','2013-11-30 01:22:26','','\'\'','','null','N','2013-11-30 01:22:26','null','null','',0,'2013-11-30 01:23:24','EmergencyPlantServiceController','Jorge A. Garcia',NULL,NULL,NULL,'{\"lines\":[[[219.4,18.3],[216.4,18.3],[212.4,18.3],[206.4,18.3],[196.4,18.3],[181.4,18.3],[164.4,18.3],[145.4,18.3],[114.4,18.3],[92.4,18.3],[55.4,17.3],[30.4,17.3],[8.4,17.3],[-4.6,17.3],[-5.6,17.3],[-5.6,18.3],[-3.6,19.3],[2.4,19.3],[11.4,21.3],[26.4,21.3],[38.4,21.3],[52.4,22.3],[66.4,22.3],[81.4,22.3],[98.4,26.3],[125.4,29.3],[160.4,36.3],[198.4,44.3],[230.4,49.3],[250.4,54.3],[258.4,56.3],[259.4,56.3],[259.4,57.3],[258.4,57.3],[257.4,57.3],[256.4,57.3],[254.4,58.3],[254.4,59.3],[254.4,60.3],[253.4,61.3],[252.4,63.3]]]}','{\"lines\":[[[220.4,14.3],[211.4,12.3],[207.4,12.3],[204.4,12.3],[200.4,12.3],[195.4,12.3],[189.4,13.3],[183.4,17.3],[177.4,24.3],[171.4,32.3],[165.4,41.3],[161.4,49.3],[158.4,57.3],[158.4,61.3],[158.4,65.3],[160.4,69.3],[161.4,70.3],[161.4,71.3],[161.4,70.3],[159.4,68.3],[154.4,66.3],[150.4,63.3],[146.4,60.3],[140.4,57.3],[136.4,54.3],[134.4,52.3],[133.4,52.3],[133.4,51.3],[130.4,51.3],[126.4,48.3],[119.4,46.3],[114.4,44.3],[110.4,43.3],[107.4,41.3],[103.4,41.3],[100.4,41.3],[98.4,41.3],[96.4,41.3],[95.4,41.3],[92.4,42.3],[92.4,43.3],[91.4,43.3]]]}", .5F, 100,680);
	data = (OrderserviceDTO) fillData;
    printHeader("ORDEN DE SERVICIO","", data.getServiceOrderNo());
	printFeatures();
	printDetails();
	printRequerements();
	printObservations();
	printFooter(data.getSignCreated(), data.getResponsible(), data.getClosed()
			              , data.getSignReceivedBy(), data.getReceivedBy(), data
			                                          .getReceivedByPosition());
  }
  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: " , 5, 98, false);
	drawer.text(data.getCustomer(), 43, 98, true);
	drawer.text("No. DE TICKET: " , 375, 98, false);
	drawer.text(data.getTicketNo(), 438, 98, true);
	drawer.hLine(0, 555, 102);
	drawer.text("DOMICILIO : ", 5, 113, false);
	drawer.text(data.getEquipmentAddress(), 55, 113, true);
	drawer.text("FECHA Y HORA DE LLEGADA : ", 317, 113, false);
	drawer.text(data.getServiceDate().toString(), 438, 113, true);
	drawer.hLine(0, 555, 117);
	drawer.text("SOLICITANTE : ", 5, 128, false);
	drawer.text(data.getContactName(), 64, 128, true);
	drawer.text("TELÉFONO : ", 387, 128, false);
	drawer.text(data.getContactPhone(), 438, 128, true);
	drawer.hLine(0, 555, 132);
	drawer.text("EQUIPO : ", 5, 143, false);
	drawer.text(data.getEquipmentType(), 43, 143, true);
	drawer.text("MARCA : ", 155, 143, false);
	drawer.text(data.getEquipmentBrand(), 190, 143, true);
	drawer.text("MODELO : ", 290, 143, false);
	drawer.text(data.getEquipmentModel(), 332, 143, true);
	drawer.text("SERIE : ", 407, 143, false);
	drawer.text(data.getEquipmentSerialNo(), 438, 143, true);
	drawer.hLine(0, 555, 147);
	drawer.text("REPORTE DE FALLA : ", 5, 158, false);
	drawer.text(data.getFailureDescription(), 90, 158, true);
	drawer.hLine(0, 555, 162);
	drawer.text("TIPO DE SERVICIO : ", 5, 173, false);
	drawer.text(data.getServiceType(), 85, 173, true);
	drawer.text("CONTRATO / PROYECTO : " , 305, 173, false);
	drawer.text(data.getProyectNumber(), 408, 173, true);
	drawer.hLine(0, 555, 177);
	drawer.vLine(87, 177, 0);
	drawer.vLine(87, 177, 555);
  }
	  
  private void printDetails() throws Exception {
	drawer.box(0, 187, 555, 13, 0x0155A5, true);
	drawer.text("SITUACION ENCONTRADA", 100, 197, true, Color.white);
	drawer.textBox(data.getDetailIssue(), 2, 200, 270, 78, true, false);
	drawer.text("TRABAJOS REALIZADOS", 350, 197, true, Color.white);
	drawer.textBox(data.getDetailWorkDone(), 277, 200, 276, 175, true, false);
	drawer.box(0, 280, 275, 13, 0x0155A5, true);
	drawer.text("PARAMETROS TÉCNICOS", 100, 289, true, Color.white);
	drawer.textBox(data.getDetailTechnicalJob(), 2, 293, 270, 82, true, false);
	drawer.vLine(187, 379, 0, 0x0155A5);
	drawer.vLine(187, 379, 275, 0x0155A5);
	drawer.vLine(187, 379, 555, 0x0155A5);
	drawer.hLine(0, 555, 379, 0x0155A5);
  }
	  
  private void printRequerements() throws Exception {
	drawer.box(0, 390, 555, 13, 0x0155A5, true);
	drawer.text("REQUERIMIENTOS Ó MATERIAL UTILIZADO", 190, 399, true, Color.white);
	drawer.textBox(data.getDetailTechnicalJob(), 2, 404, 550, 143, true, false);
	drawer.vLine(390, 550, 0, 0x0155A5);
	drawer.vLine(390, 550, 555, 0x0155A5);
	drawer.hLine(0, 555, 550, 0x0155A5);
  }
	  
  private void printObservations() throws Exception {
	drawer.box(0, 560, 555, 13, 0x0155A5, true);
	drawer.text("OBSERVACIONES / ESTATUS DEL EQUIPO", 190, 569, true, Color.white);
	drawer.textBox(data.getDetailStatus(), 2, 575, 550, 82, true, false);
	drawer.vLine(560, 660, 0, 0x0155A5);
	drawer.vLine(560, 660, 555, 0x0155A5);
	drawer.hLine(0, 555, 660, 0x0155A5);
  }
  
  public static void main(String [] args) throws Exception{
	ServiceOrderReport serv = new ServiceOrderReport();
	FileOutputStream see = new FileOutputStream("C:/Test.pdf");
	OrderserviceDTO data = new OrderserviceDTO("coordinator", 3215, "3215", "ticketNo", 5123, 
			"customer", "equipmentAddress", "contactName", new Date(),"contactPhone", 
			"equipmentType", "equipmentBrand", "Model", "equipmentSerialNo", "failureDescription", 
			"serviceType", "proyectNumber", "Equipo apagado, presenta falla general del sistema. Se revisa estado de baterias encontrando las 4 dañadas ", "Se intenta poner en modo Bypass sin exito, se realiza un reset generaal a la configuraciond e fabrica sin exito. Se indica al cliente que se solicitara soporte al corporativo.", "detailTechnicalJob", 
			"detailRequirments", "detailStatus", "signCreated", "signReceivedBy", "receivedBy", "responsible", new Date(), "receivedByPosition");
	see.write(serv.getReport(data));
	see.close();
  }

}
