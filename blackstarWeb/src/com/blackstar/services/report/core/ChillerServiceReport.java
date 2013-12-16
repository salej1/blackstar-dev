package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import java.util.Date;

import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.model.dto.BatteryServicePolicyDTO;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class ChillerServiceReport extends AbstractReport {
	
  private AirCoServicePolicyDTO data = null;
  
  public void run(Object fillData) throws Exception {
	data = (AirCoServicePolicyDTO) fillData;
	printHeader("REPORTE DE SERVICIO","AIRES ACONDICIONADOS / CHILLER", "1254");
	printFeatures();
	printEvaporator();
	printCondenser();
	printObservations();
	printFooter(data.getSignCreated(), data.getResponsible(), data.getClosed()
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
	drawer.text(data.getEquipmentAddress(), 52, 113, true);
	drawer.text("TELÉFONO: ", 389, 113, false);
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
	drawer.text(data.getServiceDate().toString(), 436, 143, true);
	drawer.hLine(0, 555, 147);
	drawer.vLine(87, 147, 0);
	drawer.vLine(87, 147, 555);
  }
  
  private void printEvaporator() throws Exception {
	 drawer.box(0, 157, 555, 13, 0x0155A5, true);
	 drawer.text("1. EVAPORADOR:", 250, 166, true, Color.white);
	 drawer.text("1.1 OPERACION Y ESTADO DE FUNCIONAMIENTO ENCONTRADO", 5, 183, false, 0, 6);
	 drawer.text(data.getEvaDescription(), 418, 183, true);
	 drawer.hLine(0, 555, 186, 0x0155A5) ;
	 drawer.text("1.2 VALORES ACTUALES", 5, 197, false, 0, 6);
	 drawer.text("Temp.", 417, 197, false, 0, 6);
	 drawer.text(data.getEvaValTemp().toString(), 437, 197, true);
	 drawer.text("Hum.", 487, 197, false, 0, 6);
	 drawer.text(data.getEvaValHum().toString(), 505, 197, true);
	 drawer.hLine(0, 555, 200, 0x0155A5) ;
	 drawer.text("1.2.1 SETPOINTS", 5, 211, false, 0, 6);
	 drawer.text("Temp.", 417, 211, false, 0, 6);
	 drawer.text(data.getEvaSetpointTemp().toString(), 437, 211, true);
	 drawer.text("Hum.", 487, 211, false, 0, 6);
	 drawer.text(data.getEvaSetpointHum().toString(), 505, 211, true);
	 drawer.hLine(0, 555, 214, 0x0155A5) ;
	 drawer.text("1.3 SE REALIZO COMPARACION Y CALIBRACION T/H MEDIO", 5, 225, false, 0, 6);
	 drawer.text(data.getEvaFlagCalibration() ? "Sí" : "No", 418, 225, true);
	 drawer.hLine(0, 555, 228, 0x0155A5) ;
	 drawer.text("1.4 REVISION Y LIMPIEZA DE FILTROS, EVAPORADOR Y EQUIPO EN GRAL.", 5, 239, false, 0, 6);
	 drawer.text(data.getEvaReviewFilter() ? "Sí" : "No", 418, 239, true);
	 drawer.hLine(0, 555, 242, 0x0155A5) ;
	 drawer.text("1.5 REVISION Y Y AJUSTE DE BANDAS, ALINEACION Y BALANCEO DE TURBINAS", 5, 253, false, 0, 6);
	 drawer.text(data.getEvaReviewStrip() ? "Sí" : "No", 418, 253, true);
	 drawer.hLine(0, 555, 256, 0x0155A5) ;
	 drawer.text("1.6 INSPECCION Y LIMPIEZA DE SISTEMA ELECTRICO, PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES(PLATINOS)", 5, 267, false, 0, 6);
	 drawer.text(data.getEvaCleanElectricSystem() ? "Sí" : "No", 418, 267, true);
	 drawer.hLine(0, 555, 270, 0x0155A5) ;
	 drawer.text("1.7 REVISION Y LIMPIEZA DE SISTEMA DE CONTROL Y SENSOR DE TEMP/HUM", 5, 281, false, 0, 6);
	 drawer.text(data.getEvaCleanControlCard() ? "Sí" : "No", 418, 281, true);
	 drawer.hLine(0, 555, 284, 0x0155A5) ;
	 drawer.text("1.8 REVISION Y LIMPIEZA DE CHAROLA Y DRENAJE EN CONDENSADOS Y HUMIFICADOR", 5, 295, false, 0, 6);
	 drawer.text(data.getEvaCleanTray() ? "Sí" : "No", 418, 295, true);
	 drawer.hLine(0, 555, 298, 0x0155A5) ;
	 drawer.text("1.9 LECTURA DE PRESION DE COMPRESION  EN OPERACION NORMAL", 5, 309, false, 0, 6);
	 drawer.text("Alta", 417, 309, false, 0, 6);
	 drawer.text(data.getEvaLectrurePreasureHigh().toString(), 432, 309, true);
	 drawer.text("Baja(60 psig min)", 465, 309, false, 0, 6);
	 drawer.text(data.getEvaLectrurePreasureLow().toString(), 518, 309, true);
	 drawer.hLine(0, 555, 312, 0x0155A5) ;
	 drawer.text("1.10 LECTURA DE TEMPERATURA EN SUCCION Y ENTRADA DE VALVULA DE EXPANSION", 5, 323, false, 0, 6);
	 drawer.text(data.getEvaLectureTemp().toString(), 418, 323, true);
	 drawer.hLine(0, 555, 326, 0x0155A5) ; 
	 drawer.text("1.11 ESTADO DE ACEITE EN EL COMPRESOR (Cuando aplique)", 5, 337, false, 0, 6);
	 drawer.text("Color", 417, 337, false, 0, 6);
	 drawer.text(data.getEvaLectureOilColor(), 433, 337, true);
	 drawer.text("Nivel", 487, 337, false, 0, 6);
	 drawer.text(data.getEvaLectureOilLevel().toString(), 502, 337, true);
	 drawer.hLine(0, 555, 340, 0x0155A5) ;
	 drawer.text("1.12 VERIFICAR MIRILLA DEL SISTEMA DE REFRIGERACION", 5, 351, false, 0, 6);
	 drawer.text("Color", 417, 351, false, 0, 6);
	 drawer.text(data.getEvaLectureCoolerColor(), 433, 351, true);
	 drawer.text("Nivel", 487, 351, false, 0, 6);
	 drawer.text(data.getEvaLectureCoolerLevel().toString(), 502, 351, true);
	 drawer.hLine(0, 555, 354, 0x0155A5) ;
	 drawer.text("1.13 REVISION DE OPERACIÓN DE PROTECCIONES POR BAJA Y ALTA PRESION", 5, 365, false, 0, 6);
	 drawer.text(data.getEvaCheckOperatation(), 418, 365, true);
	 drawer.hLine(0, 555, 368, 0x0155A5) ;
	 drawer.text("1.14 VERIFICAR RUIDOS EXTRAÑOS, VIBRACIÓN EXCESIVA, SENTADO DEL EQUIPO Y COMPONENTES, Y POSIBLES FUGAS EN EL SISTEMA", 5, 379, false, 0, 6);
	 drawer.text(data.getEvaCheckNoise(), 418, 379, true);
	 drawer.hLine(0, 555, 382, 0x0155A5) ;
	 drawer.text("1.15 CORRECTO AISLAMIENTO DE TUBERIA Y TAPAS DEL EQUIPO", 5, 393, false, 0, 6);
	 drawer.text(data.getEvaCheckIsolated(), 418, 393, true);
	 drawer.hLine(0, 555, 396, 0x0155A5);
	 drawer.text("1.16 TOMA DE LECTURA DE VOLTAJE", 5, 407, false, 0, 6);
	 drawer.text("Fases a tierra", 282, 407, false, 0, 6);
	 drawer.text(data.getEvaLectureVoltageGroud().toString(), 325, 407, true);
	 drawer.text("Entre fases", 382, 407, false, 0, 6);
	 drawer.text(data.getEvaLectureVoltagePhases().toString(), 418, 407, true);
	 drawer.text("Control", 482, 407, false, 0, 6);
	 drawer.text(data.getEvaLectureVoltageControl().toString(), 507, 407, true);
	 drawer.hLine(0, 555, 410, 0x0155A5);
	 drawer.text("1.17 LECTURA DE CORRIENTE POR FASE", 5, 421, false, 0, 6);
	 drawer.text("Motor", 282, 421, false, 0, 6);
	 drawer.text(data.getEvaLectureCurrentMotor1().toString(), 322, 421, true);
	 drawer.line(340, 415, 338, 421);
	 drawer.text(data.getEvaLectureCurrentMotor2().toString(), 353, 421, true);
	 drawer.line(380, 415, 378, 421);
	 drawer.text(data.getEvaLectureCurrentMotor3().toString(), 390, 421, true);
	 drawer.text("Compresor", 418, 421, false, 0, 6);
	 drawer.text(data.getEvaLectureCurrentCompressor1().toString(), 455, 421, true);
	 drawer.line(476, 415, 474, 421);
	 drawer.text(data.getEvaLectureCurrentCompressor2().toString(), 490, 421, true);
	 drawer.line(516, 415, 514, 421);
	 drawer.text(data.getEvaLectureCurrentCompressor3().toString(), 525, 421, true);
	 
	 drawer.text("Humificador", 282, 435, false, 0, 6);
	 drawer.text(data.getEvaLectureCurrentHumidifier1().toString(), 322, 435, true);
	 drawer.line(340, 429, 338, 435);
	 drawer.text(data.getEvaLectureCurrentHumidifier2().toString(), 353, 435, true);
	 drawer.line(380, 429, 378, 435);
	 drawer.text(data.getEvaLectureCurrentHumidifier3().toString(), 390, 435, true);
	 drawer.text("Calentador", 418, 435, false, 0, 6);
	 drawer.text(data.getEvaLectureCurrentHeater1().toString(), 455, 435, true);
	 drawer.line(476, 429, 474, 435);
	 drawer.text(data.getEvaLectureCurrentHeater2().toString(), 490, 435, true);
	 drawer.line(516, 429, 514, 435);
	 drawer.text(data.getEvaLectureCurrentHeater3().toString(), 525, 435, true);
	 
	 drawer.hLine(0, 555, 439, 0x0155A5);
	 drawer.text("1.18 PRUEBA DE SENSOR DE FLUJO DE AIRE Y FILTRO SUCIO", 5, 450, false, 0, 6);
	 drawer.text(data.getEvaCheckFluidSensor() ? "Sí" : "No" , 418, 450, true);
	 drawer.hLine(0, 555, 453, 0x0155A5);
	 drawer.text("1.19 REQUERIMIENTO DE LAMINADO Y/O  PINTURA EN EQUIPO", 5, 464, false, 0, 6);
	 drawer.text(data.getEvaRequirMaintenance() ? "Sí" : "No" , 418, 464, true);
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
	drawer.text(data.getCondReview(), 418, 503, true);
	drawer.hLine(0, 555, 506, 0x0155A5) ;
	drawer.text("2.2 INSPECCION Y LIMPIEZA DEL SISTEMAS ELECTRICO , PROTECCIONES, CABLEADO, TERMINALES Y CONTACTORES", 5, 517, false, 0, 6);
	drawer.text(data.getCondCleanElectricSystem() ? "Sí" : "No" , 418, 517, true);
	drawer.hLine(0, 555, 520, 0x0155A5);
	drawer.text("2.3 LAVADO DE CONDENSADOR (DRAY/FRUID COOLER) CON LIQUIDO DESINCRUSTANTE Y AGUA A PRESION", 5, 531, false, 0, 6);
	drawer.text(data.getCondClean() ? "Sí" : "No" , 418, 531, true);
	drawer.hLine(0, 555, 534, 0x0155A5);
	drawer.text("2.4 TOMA DE LECTURAS DE VOLTAJE", 5, 545, false, 0, 6);
	drawer.text("Fases a tierra", 282, 545, false, 0, 6);
	drawer.text(data.getCondLectureVoltageGroud().toString() , 325, 545, true);
	drawer.text("Entre fases", 382, 545, false, 0, 6);
	drawer.text(data.getCondLectureVoltagePhases().toString() , 418, 545, true);
	drawer.text("Control", 482, 545, false, 0, 6);
	drawer.text(data.getCondLectureVoltageControl().toString() , 507, 545, true);
	drawer.hLine(0, 555, 548, 0x0155A5);
	drawer.text("2.5 LECTURA DE CORRIENTE EN MOTORES DE CONDENSADOR", 5, 559, false, 0, 6);
	drawer.text(data.getCondLectureMotorCurrent().toString() , 418, 559, true);
	drawer.hLine(0, 555, 562, 0x0155A5);
	drawer.text("2.6 REVISION Y AJUSTE DE TERMOSTATO (Según aplique)", 5, 573, false, 0, 6);
	drawer.text(data.getCondReviewThermostat() , 418, 573, true);
	drawer.hLine(0, 555, 576, 0x0155A5);
	drawer.text("MODELO:", 5, 587, false, 0, 6);
	drawer.text(data.getCondModel() , 36, 587, true);
	drawer.text("No. DE SERIE:", 225, 587, false, 0, 6);
	drawer.text(data.getCondSerialNumber() , 270, 587, true);
	drawer.text("MARCA:", 425, 587, false, 0, 6);
	drawer.text(data.getCondBrand() , 452, 587, true);
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
	drawer.textBox(data.getObservations(), 2, 626, 550, 32, true, false);
	
  }
 
  public static void main(String [] args) throws Exception{
	ChillerServiceReport serv = new ChillerServiceReport();
	Policy policy = new Policy();
	Serviceorder serviceOrder = new Serviceorder();
	AirCoServiceDTO airCo = new AirCoServiceDTO();
	FileOutputStream see = new FileOutputStream("C:/ChillerServiceReport.pdf");
	
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
	
	airCo.setAaServiceId(12345);
	airCo.setEvaDescription("evaDescription");
	airCo.setEvaValTemp(12D);
	airCo.setEvaValHum(21D);
	airCo.setEvaSetpointTemp(215D);
	airCo.setEvaSetpointHum(512D);
	airCo.setEvaFlagCalibration(true);
	airCo.setEvaReviewFilter(false);
	airCo.setEvaReviewStrip(false);
	airCo.setEvaCleanElectricSystem(true);
	airCo.setEvaCleanControlCard(false);
	airCo.setEvaCleanTray(true);
	airCo.setEvaLectrurePreasureHigh(54D);
	airCo.setEvaLectrurePreasureLow(12D);
	airCo.setEvaLectureTemp(25d);
	airCo.setEvaLectureOilColor("Color");
	airCo.setEvaLectureOilLevel(12D);
	airCo.setEvaLectureCoolerColor("Color");
	airCo.setEvaLectureCoolerLevel(14D);
	airCo.setEvaCheckOperatation("evaCheckOperatation");
	airCo.setEvaCheckNoise("evaCheckNoise");
	airCo.setEvaCheckIsolated("evaCheckIsolated");
	airCo.setEvaLectureVoltageGroud(123D);
	airCo.setEvaLectureVoltagePhases(41D);
	airCo.setEvaLectureVoltageControl(23D);
	airCo.setEvaLectureCurrentMotor1(1d);
	airCo.setEvaLectureCurrentMotor2(2d);
	airCo.setEvaLectureCurrentMotor3(3d);
	airCo.setEvaLectureCurrentCompressor1(1D);
	airCo.setEvaLectureCurrentCompressor2(2D);
	airCo.setEvaLectureCurrentCompressor3(3D);
	airCo.setEvaLectureCurrentHumidifier1(1D);
	airCo.setEvaLectureCurrentHumidifier2(2D);
	airCo.setEvaLectureCurrentHumidifier3(3D);
	airCo.setEvaLectureCurrentHeater1(1D);
	airCo.setEvaLectureCurrentHeater2(2D);
	airCo.setEvaLectureCurrentHeater3(3D);
	airCo.setEvaCheckFluidSensor(true);
	airCo.setEvaRequirMaintenance(true);
	airCo.setCondReview("condReview");
    airCo.setCondCleanElectricSystem(false);
    airCo.setCondClean(true);
    airCo.setCondLectureVoltageGroud(12D);
    airCo.setCondLectureVoltagePhases(14D);
    airCo.setCondLectureVoltageControl(1D);
    airCo.setCondLectureMotorCurrent(8D);
    airCo.setCondReviewThermostat("condReviewThermostat");
    airCo.setCondModel("condModel");
    airCo.setCondSerialNumber("condSerialNumber");
    airCo.setCondBrand("condBrand");
    airCo.setObservations("observations");
	
	see.write(serv.getReport(new AirCoServicePolicyDTO(policy, "equipmentType"
			                                        , serviceOrder,  airCo)));
	see.close();
  }

}
