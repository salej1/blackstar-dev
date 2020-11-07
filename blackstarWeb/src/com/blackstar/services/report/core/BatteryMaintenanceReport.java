package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.BatteryCellServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.BatteryServicePolicyDTO;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class BatteryMaintenanceReport extends AbstractReport {
	
  private BatteryServicePolicyDTO data = null;
  
  public void run(Object fillData) throws Exception {
	data = (BatteryServicePolicyDTO) fillData;
	printHeader("REPORTE DE MANTENIMIENTO A BATERIAS","", data
			                        .getServiceOrderNumber());
	printFeatures();
	printDetails();
	printGrid();
	printFooter(data.getSignCreated(), data.getResponsible(), data.getClosed()
                       , data.getSignReceivedBy(), data.getReceivedBy(), data
                                                    .getReceivedByPosition());
  }
  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.text(data.getCustomer(), 43, 98, true);
	drawer.hLine(0, 555, 102);
	drawer.text("NO DE ORDEN DE SERVICIO DE REFERENCIA: ", 5, 113, false);
	drawer.text(data.getServiceOrderNumber(), 190, 113, true);
	drawer.text("CONTRATO / PROYECTO:", 338, 113, false);
	drawer.text(data.getProject(), 440, 113, true);
	drawer.hLine(0, 555, 117);
	drawer.text("MARCA: ", 5, 128, false);
	drawer.text(data.getBrand(), 40, 128, true);
	drawer.text("MODELO: ", 200, 128, false);
	drawer.text(data.getModel(), 243, 128, true);
	drawer.text("CAPACIDAD: ", 387, 128, false);
	drawer.text(data.getCapacity(), 440, 128, true);
	drawer.hLine(0, 555, 132);
	drawer.text("NO. DE BATERÍAS: ", 5, 143, false);
	drawer.text(data.getCells().size() + "", 80, 143, true);
	drawer.text("TIPO: ", 200, 143, false);
	drawer.text(data.getEquipmentType(), 223, 143, true);
	drawer.text("FECHA Y HORA DE LLEGADA: ", 323, 143, false);
	drawer.text(data.getServiceDate().toString(), 440, 143, true);
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
	 if(data.getPlugClean()){
		 drawer.line(207, 203, 197, 213, 0, 2);
		 drawer.line(198, 213, 193, 210, 0, 2);
	 } else {
	   drawer.line(196, 203, 206, 213, 0, 2);
	   drawer.line(206, 203, 196, 213, 0, 2);
	 }
	 drawer.text(data.getPlugCleanStatus(), 233, 213, true);
	 drawer.text(data.getPlugCleanComments(), 343, 213, true);
	 
	 drawer.text("CUBIERTA", 5, 241);
	 if(data.getCoverClean()){
		 drawer.line(207, 228, 197, 238, 0, 2);
		 drawer.line(198, 238, 193, 235, 0, 2);
	 } else {
	   drawer.line(196, 228, 206, 238, 0, 2);
	   drawer.line(206, 228, 196, 238, 0, 2);
	 }
	 drawer.text(data.getCoverCleanStatus(), 233, 238, true);
	 drawer.text(data.getCoverCleanComments(), 343, 238, true);
	 
	 
	 drawer.text("TAPONES", 5, 266);
	 if(data.getCapClean()){
		 drawer.line(207, 253, 197, 263, 0, 2);
		 drawer.line(198, 263, 193, 260, 0, 2);
	 } else {
	   drawer.line(196, 253, 206, 263, 0, 2);
	   drawer.line(206, 253, 196, 263, 0, 2);
	 }
	 drawer.text(data.getCapCleanStatus(), 233, 263, true);
	 drawer.text(data.getCapCleanComments(), 343, 263, true);
	 
	 
	 drawer.text("TIERRA FISICA", 5, 291);
	 if(data.getGroundClean()){
		 drawer.line(207, 278, 197, 288, 0, 2);
		 drawer.line(198, 288, 193, 285, 0, 2);
	 } else {
	   drawer.line(196, 278, 206, 288, 0, 2);
	   drawer.line(206, 278, 196, 288, 0, 2);
	 }
	 drawer.text(data.getGroundCleanStatus(), 233, 288, true);
	 drawer.text(data.getGroundCleanComments(), 343, 288, true);
	 
	 drawer.text("ESTANTE/GABINETE/RACK", 5, 316);
	 if(data.getRackClean()){
		 drawer.line(207, 303, 197, 313, 0, 2);
		 drawer.line(198, 313, 193, 310, 0, 2);
	 } else {
	   drawer.line(196, 303, 206, 313, 0, 2);
	   drawer.line(206, 303, 196, 313, 0, 2);
	 }
	 drawer.text(data.getRackCleanStatus(), 233, 313, true);
	 drawer.text(data.getRackCleanComments(), 343, 313, true);
	 
	 drawer.text("# SERIE / LOTE / FECHA DE FABRICACION", 5, 341);
	 drawer.text(data.getSerialNoDateManufact(), 233, 338, true);
	 
	 drawer.text("TEMP. PROMEDIO DE BATERIAS", 5, 366);
	 drawer.text(data.getBatteryTemperature(), 233, 363, true);
	 
	 drawer.hLine(180, 220, 200, 0x0155A5);
	 drawer.hLine(180, 220, 215, 0x0155A5);
	 drawer.vLine(200, 215, 180, 0x0155A5);
	 drawer.vLine(200, 215, 220, 0x0155A5);
	 
	 drawer.hLine(180, 220, 225, 0x0155A5);
	 drawer.hLine(180, 220, 240, 0x0155A5);
	 drawer.vLine(225, 240, 180, 0x0155A5);
	 drawer.vLine(225, 240, 220, 0x0155A5);
	 
	 drawer.hLine(180, 220, 250, 0x0155A5);
	 drawer.hLine(180, 220, 265, 0x0155A5);
	 drawer.vLine(250, 265, 180, 0x0155A5);
	 drawer.vLine(250, 265, 220, 0x0155A5);
	 
	 drawer.hLine(180, 220, 275, 0x0155A5);
	 drawer.hLine(180, 220, 290, 0x0155A5);
	 drawer.vLine(275, 290, 180, 0x0155A5);
	 drawer.vLine(275, 290, 220, 0x0155A5);
	 
	 drawer.hLine(180, 220, 300, 0x0155A5);
	 drawer.hLine(180, 220, 315, 0x0155A5);
	 drawer.vLine(300, 315, 180, 0x0155A5);
	 drawer.vLine(300, 315, 220, 0x0155A5);
	 
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
	drawer.text(data.getVoltageBus().toString(), 170, 396, true);
	drawer.text("V.C.D.", 210, 396);
	drawer.text("TEMPERATURA AMBIENTE:", 380, 396);
	drawer.text(data.getTemperature().toString(), 490, 396, true);
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
	  
	  
	for(int i = 0; i < 4;i++){
	  for(int j = 1 ; j <= 22; j++){
		drawer.text((j + (i*22)) + "", 18 + (i * 137), 425 + ((j - 1) * 11)
				                                            , false, 0, 6);
		if(data.getCells().size() >= (j + (i*22))){
		  drawer.text(data.getCells().get(j + (i*22) - 1).getFloatVoltage() 
			      + "", 18 + (i * 137) + 47, 425 + ((j - 1) * 11), false, 0, 6);
		  drawer.text(data.getCells().get(j + (i*22) - 1).getChargeVoltage() 
				  + "", 18 + (i * 137) + 94, 425 + ((j - 1) * 11), false, 0, 6);
		}
			 
	  }  
	}  
  }
  
  public static void main(String [] args) throws Exception{
	BatteryMaintenanceReport serv = new BatteryMaintenanceReport();
	Policy policy = new Policy();
	Serviceorder serviceOrder = new Serviceorder();
	BatteryServiceDTO batteryServiceDTO = new BatteryServiceDTO();
	
	policy.setPolicyId(1223);
	policy.setCustomer("customer");
	policy.setFinalUser("finalUser");
	policy.setProject("project");
	policy.setEquipmentTypeId('E');
	policy.setBrand("brand");
	policy.setModel("model");
	policy.setSerialNumber("serialNumber");
	policy.setCapacity("capacity");
	policy.setEquipmentAddress("equipmentAddress");
	policy.setOfficeId('A');
	policy.setContactName("contactName");
	policy.setContactPhone("contactPhone");
	
	serviceOrder.setServiceOrderId(12345);
	serviceOrder.setTicketId(54321);
	serviceOrder.setServiceDate(new Date());
	serviceOrder.setResponsible("responsible");
	serviceOrder.setReceivedBy("receivedBy");
	serviceOrder.setStatusId("serviceStatusId");
	serviceOrder.setClosed(new Date());
	serviceOrder.setConsultant("consultant");
	serviceOrder.setCoordinator("coordinator");
	serviceOrder.setAsignee("asignee");
	serviceOrder.setSignCreated("signCreated");
	serviceOrder.setSignReceivedBy("signReceivedBy");
	serviceOrder.setReceivedByPosition("receivedByPosition");
	serviceOrder.setServiceOrderNumber("serviceOrderNumber");
	
	batteryServiceDTO.setBbServiceId(12345);
	batteryServiceDTO.setServiceOrderId(54321);
	batteryServiceDTO.setPlugClean(true);
	batteryServiceDTO.setPlugCleanStatus("plugCleanStatus");
	batteryServiceDTO.setPlugCleanComments("plugCleanComments");
	batteryServiceDTO.setCoverClean(false);
	batteryServiceDTO.setCoverCleanStatus("coverCleanStatus");
	batteryServiceDTO.setCoverCleanComments("coverCleanComments");
	batteryServiceDTO.setCapClean(true);
	batteryServiceDTO.setCapCleanStatus("capCleanStatus");
	batteryServiceDTO.setCapCleanComments("capCleanComments");
	batteryServiceDTO.setGroundClean(true);
	batteryServiceDTO.setGroundCleanStatus("groundCleanStatus");
	batteryServiceDTO.setGroundCleanComments("groundCleanComments");
	batteryServiceDTO.setRackClean(true);
	batteryServiceDTO.setRackCleanStatus("rackCleanStatus");
	batteryServiceDTO.setRackCleanComments("rackCleanComments");
	batteryServiceDTO.setSerialNoDateManufact("serialNoDateManufact");
	batteryServiceDTO.setBatteryTemperature("batteryTemperature");
	batteryServiceDTO.setVoltageBus(123);
	batteryServiceDTO.setTemperature(124);
	
	
	List<BatteryCellServiceDTO>  cells = new ArrayList<BatteryCellServiceDTO> ();
	for(int i = 1; i <= 85; i++){
		cells.add(new BatteryCellServiceDTO(i, i, i, i , i));
	}
	batteryServiceDTO.setCells(cells);
	
	BatteryServicePolicyDTO data = new BatteryServicePolicyDTO(policy,"equipmentType"
			                                , serviceOrder,  batteryServiceDTO);
	
    //FileOutputStream see = new FileOutputStream("C:/BatteryMaintenanceReport.pdf");
    //see.write(serv.getReport(data));
    //see.close();
  }
}
