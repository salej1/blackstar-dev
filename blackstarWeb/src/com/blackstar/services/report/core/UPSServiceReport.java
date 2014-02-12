package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import java.util.Date;

import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.UpsServiceDTO;
import com.blackstar.model.dto.UpsServicePolicyDTO;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class UPSServiceReport extends AbstractReport {
	
  UpsServicePolicyDTO data =null;
  
  public void run(Object fillData) throws Exception {
	data = (UpsServicePolicyDTO) fillData;
	printHeader("REPORTE DE SERVICIO","UPS", data.getServiceOrderNumber());
	printFeatures();
	printActivities();
	printComments();
	printFooter(data.getSignCreated(), data.getResponsibleName(), data.getClosed()
                       , data.getSignReceivedBy(), data.getReceivedBy(), data
                                                   .getReceivedByPosition());
  }
	  
  private void printFeatures() throws Exception {
	drawer.hLine(0, 555, 87);
	drawer.text("CLIENTE: ", 5, 98, false);
	drawer.text(data.getCustomer(), 43, 98, true);
	drawer.text("CONTRATO / PROYECTO: ", 335, 98, false);
	drawer.text(data.getProject(), 436, 98, true);
	drawer.hLine(0, 555, 102);
	drawer.text("DOMICILIO: ", 5, 113, false);
	drawer.text(trimAddress(data.getEquipmentAddress()), 52, 113, true);
	drawer.text("TELÉFONO: ", 390, 113, false);
	drawer.text(data.getContactPhone(), 436, 113, true);
	drawer.hLine(0, 555, 117);
	drawer.text("MARCA: ", 5, 128, false);
	drawer.text(data.getBrand(), 39, 128, true);
	drawer.text("MODELO: ", 200, 128, false);
	drawer.text(data.getModel(), 240, 128, true);
	drawer.text("CAPACIDAD: ", 385, 128, false);
	drawer.text(data.getCapacity(), 436, 128, true);
	drawer.hLine(0, 555, 132);
	drawer.text("No. DE SERIE: ", 5, 143, false);
	drawer.text(data.getSerialNumber(), 61, 143, true);
	drawer.text("FECHA Y HORA DE LLEGADA: ", 320, 143, false);
	drawer.text(format(data.getServiceDate()), 436, 143, true);
	drawer.hLine(0, 555, 147);
	drawer.vLine(87, 147, 0);
	drawer.vLine(87, 147, 555);
  }
	  
  private void printActivities() throws Exception {
    drawer.box(0, 157, 555, 13, 0x0155A5, true);
    drawer.text("ACTIVIDADES DESARROLLADAS:", 5, 166, true, Color.white);
    drawer.text("Estado del equipo encontrado:", 5, 185);
    drawer.text(data.getEstatusEquipment(), 117, 183, true);
    drawer.hLine(115, 275, 185, 0x0155A5) ;
    drawer.text("Estado de los capacitores:", 285, 185);
    drawer.text(data.getCapacitorStatus(), 381, 183, true);
    drawer.hLine(381, 550, 185, 0x0155A5) ;
    drawer.text("Sopleteado", 5, 200);
    if(data.getCleaned()){
    	drawer.line(263, 188, 256, 198, 0, 2);
    	drawer.line(257, 198, 253, 193, 0, 2);
    } else{
    	drawer.line(262, 188, 253, 198, 0, 2);
    	drawer.line(253, 188, 262, 198, 0, 2);
    }
    
    drawer.text("Verificación de fusibles y protecciones eléctricas", 285, 200);
    if(data.getVerifyFuzz()){
    	drawer.line(538, 188, 531, 198, 0, 2);
    	drawer.line(532, 198, 528, 193, 0, 2);
    } else{
    	drawer.line(538, 188, 528, 198, 0, 2);
    	drawer.line(528, 188, 538, 198, 0, 2);
    }
    
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
    if(data.getHooverClean()){
    	drawer.line(263, 205, 256, 215, 0, 2);
    	drawer.line(257, 215, 253, 210, 0, 2);
    } else{
    	drawer.line(262, 205, 253, 215, 0, 2);
    	drawer.line(253, 205, 262, 215, 0, 2);
    }
    
    drawer.text("Revisión y verificación del rectificador / cargador", 285, 215);
    if(data.getChargerReview()){
    	drawer.line(538, 205, 531, 215, 0, 2);
    	drawer.line(532, 215, 528, 210, 0, 2);
    } else{
    	drawer.line(538, 205, 528, 215, 0, 2);
    	drawer.line(528, 205, 538, 215, 0, 2);
    }
    
    drawer.text("Verificación de conexiones y reapriete tonillería(puntos calientes):", 5, 230);
    if(data.getVerifyConnections()){
    	drawer.line(263, 222, 256, 232, 0, 2);
    	drawer.line(257, 232, 253, 227, 0, 2);
    } else{
    	drawer.line(262, 222, 253, 232, 0, 2);
    	drawer.line(253, 222, 262, 232, 0, 2);
    }
    drawer.text("Estado de ventiladores:", 285, 230);
    drawer.text(data.getFanStatus(), 372, 228, true);
    drawer.hLine(370, 550, 230, 0x0155A5) ;
    drawer.text("BANCO DE BATERIAS:", 5, 260, true);
    drawer.text("Reapriete de puentes / conectores", 5, 275);
    if(data.getCheckConnectors()){
    	drawer.line(263, 265, 256, 275, 0, 2);
    	drawer.line(257, 275, 253, 270, 0, 2);
    } else{
    	drawer.line(262, 265, 253, 275, 0, 2);
    	drawer.line(253, 265, 262, 275, 0, 2);
    }
    
    drawer.text("Temperatura ambiente", 285, 275);
    drawer.text(data.getTemp().toString(), 372, 273, true);
    drawer.hLine(370, 550, 275, 0x0155A5);
    drawer.text("Verificación de fugas y sulfataciones", 5, 290);
    if(data.getCverifyOutflow()){
    	drawer.line(263, 282, 256, 292, 0, 2);
    	drawer.line(257, 292, 253, 287, 0, 2);
    } else{
    	drawer.line(262, 282, 253, 292, 0, 2);
    	drawer.line(253, 282, 262, 292, 0, 2);
    }
    
    drawer.text("Pruebas de carga y descarga", 285, 290);
    if(data.getCverifyOutflow()){
    	drawer.line(539, 278, 532, 288, 0, 2);
    	drawer.line(533, 288, 529, 283, 0, 2);
    } else{
    	drawer.line(538, 278, 529, 288, 0, 2);
    	drawer.line(529, 278, 538, 288, 0, 2);
    }
    
    drawer.text("No. Baterías", 5, 305);
    drawer.text(data.getNumberBatteries().toString(), 54, 303, true);
    drawer.hLine(52, 180, 305, 0x0155A5);
    drawer.text("Marca, modelo y capacidad", 186, 305);
    drawer.text(data.getBrandModel(), 288, 303, true);
    drawer.hLine(286, 550, 305, 0x0155A5);
    drawer.text("Fecha o serie de fabricación", 5, 320);
    drawer.text(data.getManufacturedDateSerial(), 111, 318, true);
    drawer.hLine(109, 275, 320, 0x0155A5);
    drawer.text("Voltaje promedio de baterias", 285, 320);
    drawer.text(data.getBatteryVoltage().toString(), 392, 318, true);
    drawer.hLine(390, 550, 320, 0x0155A5);
    drawer.text("Baterias dañadas (cant. y voltaje c/carga)", 5, 335);
    drawer.text(data.getDamageBatteries(), 157, 333, true);
    drawer.hLine(155, 550, 335, 0x0155A5);
    drawer.text("Otro (modelo banco externo)", 5, 350);
    drawer.text(data.getOther(), 114, 348, true);
    drawer.hLine(112, 550, 350, 0x0155A5);
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
    if(data.getTrasferLine()){
    	drawer.line(263, 385, 256, 395, 0, 2);
    	drawer.line(257, 395, 253, 390, 0, 2);
    } else{
    	drawer.line(262, 385, 253, 395, 0, 2);
    	drawer.line(253, 385, 262, 395, 0, 2);
    }
    
    drawer.text("Transferencia y retransferencia con planta de emergencia", 5, 410);
    if(data.getTransferEmergencyPlant()){
    	drawer.line(263, 402, 256, 412, 0, 2);
    	drawer.line(257, 412, 253, 407, 0, 2);
    } else{
    	drawer.line(262, 402, 253, 412, 0, 2);
    	drawer.line(253, 402, 262, 412, 0, 2);
    }
    
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
    if(data.getBackupBatteries()){
    	drawer.line(539, 385, 532, 395, 0, 2);
    	drawer.line(533, 395, 529, 390, 0, 2);
    } else{
    	drawer.line(538, 385, 529, 395, 0, 2);
    	drawer.line(529, 385, 538, 395, 0, 2);
    }
    
    drawer.text("Verificacion de voltaje de baterias y de salida durante la prueba", 285, 410);
    if(data.getBackupBatteries()){
    	drawer.line(539, 402, 532, 412, 0, 2);
    	drawer.line(533, 412, 529, 407, 0, 2);
    } else{
    	drawer.line(538, 402, 529, 412, 0, 2);
    	drawer.line(529, 402, 538, 412, 0, 2);
    }
    
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
    drawer.text(data.getInputVoltagePhase().toString() + " Volts", 190, 446, true);
    drawer.hLine(0, 555, 449, 0x0155A5);
    drawer.text("VOLTAJE SALIDA FASE A FASE:", 285, 446);
    drawer.text(data.getOutputVoltagePhase().toString() + " Volts", 450, 446, true);
    drawer.hLine(0, 555, 449, 0x0155A5);
    drawer.text("VOLTAJE ENTRADA FASE A NEUTRO:", 5, 458);
    drawer.text(data.getInputVoltageNeutro().toString() + " Volts", 190, 458, true);
    drawer.hLine(0, 555, 461, 0x0155A5);
    drawer.text("VOLTAJE SALIDA FASE A NEUTRO:", 285, 458);
    drawer.text(data.getOutputVoltageNeutro().toString() + " Volts", 450, 458, true);
    drawer.hLine(0, 555, 461, 0x0155A5);
    drawer.text("VOLTAJE ENTRE NEUTRO Y TIERRA:", 5, 470);
    drawer.text(data.getInputVoltageNeutroGround().toString() + " Volts", 190, 470, true);
    drawer.hLine(0, 555, 473, 0x0155A5);
    drawer.text("FREC. ENTRADA/SALIDA:", 285, 470);
    drawer.text(data.getInOutFrecuency().toString() + " Hz", 450, 470, true);
    drawer.hLine(0, 555, 473, 0x0155A5);
    drawer.text("PORCENTAJE DE CARGA O CORRIENTE:", 5, 482);
    drawer.text(data.getPercentCharge().toString() + " %", 190, 482, true);
    drawer.hLine(0, 555, 485, 0x0155A5);
    drawer.text("VOLTAJE DEL BUS CD:", 285, 482);
    drawer.text(data.getBusVoltage().toString() + " Volts", 450, 482, true);
    drawer.hLine(0, 555, 485, 0x0155A5);
    drawer.vLine(166, 485, 0);
    drawer.vLine(166, 485, 555);
  }
  
  private void printComments() throws Exception {
	drawer.box(0, 496, 555, 13, 0x0155A5, true);
	drawer.text("ACTIVIDADES DESARROLLADAS:", 5, 506, true, Color.white);
	drawer.text("Anotar comentarios del usuario (alarmas, respaldos o anomalías en el equipo). Anotar alarmas inusuales.", 5, 520);
	drawer.text("Indicar condiciones del lugar y estado final del equipo. Otras observaciones.", 5, 530);
	drawer.textBox(data.getObservations(), 2, 535, 550, 120, true, false);
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
	  
	
  public static void main(String [] args) throws Exception{
	UPSServiceReport serv = new UPSServiceReport();
	Policy policy = new Policy();
	Serviceorder serviceOrder = new Serviceorder();
	UpsServiceDTO upsService = new UpsServiceDTO();
	UpsServicePolicyDTO data = null;
	 
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
	
	
	upsService.setUpsServiceId(1254);
	upsService.setEstatusEquipment("EstatusEquipment");
	upsService.setCleaned(true);
	upsService.setHooverClean(true);
	upsService.setVerifyConnections(true);
	upsService.setCapacitorStatus("CapacitorStatus");
	upsService.setVerifyFuzz(true);
	upsService.setChargerReview(true);
	upsService.setFanStatus("FanStatus");
	upsService.setObservations("Observations Observations Observations Observations Observations Observations Observations Observations Observations Observations Observations Observations Observations Observations ");
	upsService.setUpsServiceBatteryBankId(3251);
	upsService.setCheckConnectors(true);
	upsService.setCverifyOutflow(true);
	upsService.setNumberBatteries(15);
	upsService.setManufacturedDateSerial("ManufacturedDateSerial");
	upsService.setDamageBatteries("DamageBatteries");
	upsService.setOther("Other");
	upsService.setTemp(18D);
	upsService.setChargeTest(true);
	upsService.setBrandModel("BrandModel");
	upsService.setBatteryVoltage(15D);
	upsService.setUpsServiceGeneralTestId(5685);
	upsService.setTrasferLine(true);
	upsService.setTransferEmergencyPlant(true);
	upsService.setBackupBatteries(true);
	upsService.setVerifyVoltage(true);
	upsService.setUpsServiceParamsId(6523);
	upsService.setInputVoltagePhase(1D);
	upsService.setInputVoltageNeutro(2D);
	upsService.setInputVoltageNeutroGround(3D);
	upsService.setPercentCharge(4D);
	upsService.setOutputVoltagePhase(5D);
	upsService.setOutputVoltageNeutro(6D);
	upsService.setInOutFrecuency(7D);
	upsService.setBusVoltage(8D);
	data = new UpsServicePolicyDTO(policy, "equipmentType", serviceOrder,  upsService);
	
	//FileOutputStream see = new FileOutputStream("C:/UPSServiceReport.pdf");
	//see.write(serv.getReport(data));
	//see.close();
  }

  }
