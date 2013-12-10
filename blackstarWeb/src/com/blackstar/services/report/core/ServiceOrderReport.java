package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import java.util.Date;

import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class ServiceOrderReport extends AbstractReport {
	
  private OrderserviceDTO data = null;
  
  public void run() throws Exception {
    printHeader("ORDEN DE SERVICIO","", "OS", data.getServiceOrderNo());
	printFeatures();
	printDetails();
	printRequerements();
	printObservations();
	printFooter();
  }
  
  @Override
  protected void setFillingData(Object data) throws Exception{
	this.data = (OrderserviceDTO) data;
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
	drawer.text("MODELO : ", 305, 143, false);
	drawer.text(data.getEquipmentModel(), 347, 143, true);
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
	drawer.textBox(data.getDetailTechnicalJob(), 2, 575, 550, 82, true, false);
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
	serv.setFillingData(data);
	see.write(serv.getReport());
	see.close();
  }

}
