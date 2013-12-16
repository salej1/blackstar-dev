package com.blackstar.services.report.core;

import java.io.FileOutputStream;
import java.util.Date;

import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServicePolicyDTO;
import com.blackstar.services.report.AbstractReport;
import com.pdfjet.Color;

public class EmergencyPlantServiceReport extends AbstractReport {
		
  private EmergencyPlantServicePolicyDTO data = null;
  
  public void run(Object fillData) throws Exception {
	data = (EmergencyPlantServicePolicyDTO) fillData;
	printHeader("REPORTE DE SERVICIO","PLANTAS DE EMERGENCIA", "1254");
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
	drawer.text("CAPACIDAD: ", 5, 128, false);
	drawer.text(data.getCapacity(), 56, 128, true);
	drawer.text("FECHA Y HORA DE LLEGADA: ", 320, 128, false);
	drawer.text(data.getServiceDate().toString(), 436, 128, true);
	drawer.hLine(0, 555, 132);
	drawer.vLine(87, 132, 0);
	drawer.vLine(87, 132, 555);
  }
  
  private void printInformation() throws Exception {
	drawer.box(0, 141, 555, 13, 0x0155A5, true);
	drawer.text("DATOS DEL EQUIPO", 240, 150, true, Color.white);
	drawer.text("P.E. MARCA: ", 2, 162, false, 0, 6);
	drawer.text(data.getBrandPE(), 95, 162, true);
	drawer.text("MOTOR DIESEL MARCA: ", 186, 162, false, 0, 6);
	drawer.text(data.getBrandMotor(), 279, 162, true);
	drawer.text("CAPACIDAD TANQUE DIESEL: ", 370, 162, false, 0, 6);
	drawer.text(data.getTankCapacity().toString(), 463, 162, true);
	drawer.hLine(0, 555, 164, 0x0155A5);
	drawer.text("MODELO PE: ", 2, 173, false, 0, 6);
	drawer.text(data.getModelPE(), 95, 173, true);
	drawer.text("MODELO MOTOR: ", 186, 173, false, 0, 6);
	drawer.text(data.getModelMotor(), 279, 173, true);
	drawer.text("MOD.DE LA BOMBA DE COMBUST ", 370, 173, false, 0, 5.5F);
	drawer.text(data.getPumpFuelModel(), 463, 173, true);
	drawer.hLine(0, 555, 175, 0x0155A5);
	drawer.text("No. SERIE PE: ", 2, 184, false, 0, 6);
	drawer.text(data.getSerialPE(), 95, 184, true);
	drawer.text("No. DE SERIE MOTOR: ", 186, 184, false, 0, 6);
	drawer.text(data.getSerialMotor(), 279, 184, true);
	drawer.text("FILTRO DE COMBUSTIBLE(SE CAMBIO?): ", 370, 184, false, 0, 4.5F);
	drawer.text(data.getFilterFuelFlag() ? "Sí" : "No", 463, 184, true);
	drawer.hLine(0, 555, 186, 0x0155A5);
	drawer.text("TIPO DE TRANSFERENCIA: ", 2, 195, false, 0, 6);
	drawer.text(data.getTransferType(), 95, 195, true);
	drawer.text("CPL MOTOR: ", 186, 195, false, 0, 6);
	drawer.text(data.getCplMotor(), 279, 195, true);
	drawer.text("FILTRO DE ACEITE (SE CAMBIO?): ", 370, 195, false, 0, 5.5F);
	drawer.text(data.getFilterOilFlag() ? "Sí" : "No", 463, 195, true);
	drawer.hLine(0, 555, 197, 0x0155A5);
	drawer.text("MCA / MODELO TRANS.: ", 2, 206, false, 0, 6);
	drawer.text(data.getModelTransfer(), 95, 206, true);
	drawer.text("GENERADOR MCA: ", 186, 206, false, 0, 6);
	drawer.text(data.getBrandGenerator(), 279, 206, true);
	drawer.text("FILTRO DE AGUA (SE CAMBIO?): ", 370, 206, false, 0, 5.8F);
	drawer.text(data.getFilterWaterFlag() ? "Sí" : "No", 463, 206, true);
	drawer.hLine(0, 555, 208, 0x0155A5);
	drawer.text("MCA / MODELO CONTROL: ", 2, 217, false, 0, 6);
	drawer.text(data.getModelControl(), 95, 217, true);
	drawer.text("MODELO GENERADOR: ", 186, 217, false, 0, 6);
	drawer.text(data.getModelGenerator(), 279, 217, true);
	drawer.text("FILTRO DE AIRE (SE CAMBIO?): ", 370, 217, false, 0, 5.9F);
	drawer.text(data.getFilterAirFlag() ? "Sí" : "No", 463, 217, true);
	drawer.hLine(0, 555, 219, 0x0155A5);
	drawer.text("MCA / MODELO REGULADOR ", 2, 226, false, 0, 6);
	drawer.text("DE VOLTAJE: ", 2, 233, false, 0, 6);
	drawer.text(data.getModelRegVoltage(), 95, 228, true);
	drawer.text("No. DE SERIE GEN.: ", 186, 228, false, 0, 6);
	drawer.text(data.getSerialGenerator(), 279, 228, true);
	drawer.text("RELOJ CUENTA HORAS (LECTURA): ", 370, 228, false, 0, 5.2F);
	drawer.text(data.getBrandGear(), 463, 228, true);
	drawer.hLine(0, 555, 234, 0x0155A5);
	drawer.text("MCA / MODELO REGULADOR ", 2, 241, false, 0, 6);
	drawer.text("DE VELOCIDAD: ", 2, 248, false, 0, 6);
	drawer.text(data.getModelRegVelocity(), 95, 243, true);
	drawer.text("POTENCIA (KW) GEN: ", 186, 243, false, 0, 6);
	drawer.text(data.getPowerWattGenerator().toString(), 279, 243, true);
	drawer.text("MODELO DE BATERIAS: ", 370, 243, false, 0, 6);
	drawer.text(data.getBrandBattery(), 463, 243, true);
	drawer.hLine(0, 555, 249, 0x0155A5);
	drawer.text("MCA / MOD. DEL  ", 2, 255, false, 0, 6);
	drawer.text("CARGADOR BATT: ", 2, 262, false, 0, 6);
	drawer.text(data.getModelCharger(), 95, 258, true);
	drawer.text("TENSION GEN: ", 186, 258, false, 0, 6);
	drawer.text(data.getTensionGenerator().toString(), 279, 258, true);
	drawer.text("RELOJ CUENTA HORAS (LECTURA): ",370, 258, false, 0, 5.2F);
	drawer.text(data.getClockLecture().toString(), 463, 258, true);
	drawer.hLine(0, 555, 264, 0x0155A5);
	drawer.text("ULTIMO CAMBIO DE ACEITE: ", 2, 273, false, 0, 6);
	drawer.text(data.getOilChange().toString(), 95, 273, true);
	drawer.text("ULTIMA FECHA DE AFINACION: ", 186, 273, false, 0, 6);
	drawer.text(data.getTuningDate().toString(), 279, 273, true);
	drawer.text("ULTIMO SERVICIO CORRECTIVO: ", 370, 273, false, 0, 5.6f);
	drawer.text(data.getServiceCorrective().toString(), 463, 273, true);
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
	drawer.text(data.getLevelOilFlag() ? "Sí" : "No", 95, 298, true);
	drawer.text("ZAPATAS DE BATERIA: ", 186, 298, false, 0, 6);
	drawer.text(data.getBatteryCap(), 279, 298, true);
	drawer.text("MANGUERAS COMBUSTIBLE: ", 370, 298, false, 0, 6);
	drawer.text(data.getHoseOil(), 463, 298, true);
	drawer.hLine(0, 555, 303, 0x0155A5);
	drawer.text("NIVEL DE AGUA/ANTICONGELANTE ", 2, 309, false, 0, 5F);
	drawer.text("(SE CAMBIO?): ", 2, 315, false, 0, 5.5F);
	drawer.text(data.getLevelWaterFlag() ? "Sí" : "No", 95, 313, true);
	drawer.text("SUFATACION BATERIA: ", 186, 313, false, 0, 6);
	drawer.text(data.getBatterySulfate(), 279, 313, true);
	drawer.text("MANGUERAS AGUA: ", 370, 313, false, 0, 6);
	drawer.text(data.getHoseWater(), 463, 313, true);
	drawer.hLine(0, 555, 318, 0x0155A5);
	drawer.text("NIVEL ELECTROLITO BATERIA: ", 2, 327, false, 0, 6);
	drawer.text(data.getLevelBattery().toString(), 95, 327, true);
	drawer.text("NIVEL DE COMBUSTIBLE EN %: ", 186, 327, false, 0, 6);
	drawer.text(data.getLevelOil().toString(), 279, 327, true);
	drawer.text("VALVULAS Y TUBERIAS (Cu/NEGRAS): ", 370, 327, false, 0, 4.9F);
	drawer.text(data.getTubeValve(), 463, 327, true);
	drawer.hLine(0, 555, 329, 0x0155A5);
	drawer.text("FUGA EN TUBO DE ESCAPE: ", 2, 338, false, 0, 6);
	drawer.text(data.getTubeLeak()? "Sí" : "No", 95, 338, true);
	drawer.text("PRECALENTADO DE LA MAQUINA: ", 186, 338, false, 0, 5.5F);
	drawer.text(data.getHeatEngine(), 279, 338, true);
	drawer.text("TENSIOND E BANDAS/ESTADO DE ASPAS ", 370, 338, false, 0, 4.5F);
	drawer.text(data.getStripBlades(), 463, 338, true);
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
	drawer.text(data.getWashEngine()? "Sí" : "No", 95, 359, true);
	drawer.text("SOPLETEADO DE TRANSFER: ", 186, 361, false, 0, 6);
	drawer.text(data.getCleanTransfer()? "Sí" : "No", 279, 359, true);
	drawer.text("PRUEBAS DE BATERIAS ", 370, 361, false, 0, 6);
	drawer.text(data.getBatteryTests()? "Sí" : "No", 463, 359, true);
	drawer.hLine(0, 555, 363, 0x0155A5);
	drawer.text("LAVADO DE RADIADOR: ", 2, 371, false, 0, 6);
	drawer.text(data.getWashRadiator()? "Sí" : "No", 95, 371, true);
	drawer.text("LIMPIEZA TARJETAS DE CONTROL: ", 186, 371, false, 0, 5);
	drawer.text(data.getCleanCardControl()? "Sí" : "No", 279, 371, true);
	drawer.text("REV. CARGADOR DE BAT/ALERNADOR ", 370, 371, false, 0, 4.5F);
	drawer.text(data.getCheckCharger()? "Sí" : "No", 463, 371, true);
	drawer.hLine(0, 555, 374, 0x0155A5);
	drawer.text("LIMPIEZA AREA DE TRABAJO: ", 2, 383, false, 0, 6);
	drawer.text(data.getCleanWorkArea()? "Sí" : "No", 95, 383, true);
	drawer.text("AJUSTE CONEXIONES CONTROL: ", 186, 383, false, 0, 5.5F);
	drawer.text(data.getCheckConectionControl()? "Sí" : "No", 279, 383, true);
	drawer.text("PINTURA Y CONSERVACION: ", 370, 383, false, 0, 6);
	drawer.text(data.getCheckPaint()? "Sí" : "No", 463, 383, true);
	drawer.hLine(0, 555, 385, 0x0155A5);
	drawer.text("REVISION DE CABLEADO Y CONEXIONES ", 2, 393, false, 0, 4.5F);
	drawer.text(data.getConectionCheck()? "Sí" : "No", 95, 393, true);
	drawer.text("REV. DE EXITATRIZ/EMBOBINADOS: ", 186, 393, false, 0, 5F);
	drawer.text(data.getCheckWinding()? "Sí" : "No", 279, 393, true);
	drawer.text("SOPLETEADO TAB. GENERADOR: ", 370, 393, false, 0, 5.5F);
	drawer.text(data.getCleanGenerator()? "Sí" : "No", 463, 393, true);
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
	drawer.text(data.getVacuumFrequency().toString(), 95, 416, true);
	drawer.text("VOLTAJE EN VACIO: ", 186, 416, false, 0, 6);
	drawer.text(data.getVacuumVoltage().toString(), 279, 416, true);
	drawer.text("TIEMPO DE ARRANQUE ", 370, 416, false, 0, 6);
	drawer.text(data.getStartTime().toString(), 463, 416, true);
	drawer.hLine(0, 555, 419, 0x0155A5);
	drawer.text("FRECUENCIA CON CARGA: ", 2, 428, false, 0, 6);
	drawer.text(data.getChargeFrequency().toString(), 95, 428, true);
	drawer.text("VOLTAJE CON CARGA: ", 186, 428, false, 0, 6);
	drawer.text(data.getChargeVoltage().toString(), 279, 428, true);
	drawer.text("TIEMPO DE RETRANSFERENCIA ", 370, 428, false, 0, 5.7F);
	drawer.text(data.getTransferTime().toString(), 463, 428, true);
	drawer.hLine(0, 555, 430, 0x0155A5);
	drawer.text("NUM. DE INTENTOS DE ARRANQUE: ", 2, 438, false, 0, 5);
	drawer.text(data.getBootTryouts().toString(), 95, 438, true);
	drawer.text("CALIDAD DE EMISIONES DE HUMO: ", 186, 438, false, 0, 5);
	drawer.text(data.getQualitySmoke().toString(), 279, 438, true);
	drawer.text("TIEMPO DE PARO ", 370, 438, false, 0, 6);
	drawer.text(data.getStopTime().toString(), 463, 438, true);
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
	drawer.text(data.getTempSensor().toString(), 95, 461, true);
	drawer.text("SENSOR DE VOLTAJE O GENERACION:", 186, 461, false, 0, 4.5F);
	drawer.text(data.getVoltageSensor().toString(), 279, 461, true);
	drawer.text("SENSOR BAJA PRESION DE ACEITE:", 370, 461, false, 0, 5F);
	drawer.text(data.getOilPreasureSensor().toString(), 463, 461, true);
	drawer.hLine(0, 555, 464, 0x0155A5);
	drawer.text("SENSOR DE PRESION DE ACEITE:", 2, 472, false, 0, 5);
	drawer.text(data.getOilSensor().toString(), 95, 472, true);
	drawer.text("SENSOR DE SOBREVELOCIDAD:", 186, 472, false, 0, 5.8F);
	drawer.text(data.getOverSpeedSensor().toString(), 279, 472, true);
	drawer.text("SENSOR BDE NIVEL DE AGUA:", 370, 472, false, 0, 6);
	drawer.text(data.getWaterLevelSensor().toString(), 463, 472, true);
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
	drawer.text(data.getMechanicalStatus().toString(), 95, 495, true);
	drawer.text("AJUSTE DE TORNILLERIA:", 186, 495, false, 0, 6);
	drawer.text(data.getScrewAdjust().toString(), 279, 495, true);
	drawer.text("INTERLOOK ELECTRICO:", 370, 495, false, 0, 6);
	drawer.text(data.getElectricInterlock().toString(), 463, 495, true);
	drawer.hLine(0, 555, 498, 0x0155A5);
	drawer.text("LIMPIEZA DE TABLERO:", 2, 506, false, 0, 6);
	drawer.text(data.getBoardClean().toString(), 95, 506, true);
	drawer.text("AJUSTE DE CONEXIONES:", 186, 506, false, 0, 6);
	drawer.text(data.getConectionAdjust().toString(), 279, 506, true);
	drawer.text("INTERLOOK MECANICO:", 370, 506, false, 0, 6);
	drawer.text(data.getMechanicalInterlock().toString(), 463, 506, true);
	drawer.hLine(0, 555, 509, 0x0155A5);
	drawer.text("PRUEBA DE LAMPARAS:", 2, 517, false, 0, 6);
	drawer.text(data.getLampTest().toString(), 95, 517, true);
	drawer.text("MOTOR(ES) DEL SISTEMA:", 186, 517, false, 0, 6);
	drawer.text(data.getSystemMotors().toString(), 279, 517, true);
	drawer.text("CAPACIDAD DE AMPERES:", 370, 517, false, 0, 6);
	drawer.text(data.getCapacityAmp().toString(), 463, 517, true);
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
	drawer.text(data.getVoltageABAN().toString(), 95, 540, true);
	drawer.text("CORRIENTE A (AMP):", 186, 540, false, 0, 6);
	drawer.text(data.getCurrentA().toString(), 279, 540, true);
	drawer.text("FRECUENCIA:", 370, 540, false, 0, 6);
	drawer.text(data.getFrequency().toString(), 463, 540, true);
	drawer.hLine(0, 555, 543, 0x0155A5);
	drawer.text("VOLTAJE AC-CN:", 2, 551, false, 0, 6);
	drawer.text(data.getVoltageACCN().toString(), 95, 551, true);
	drawer.text("CORRIENTE B (AMP):", 186, 551, false, 0, 6);
	drawer.text(data.getCurrentB().toString(), 279, 551, true);
	drawer.text("PRESION DE ACEITE:", 370, 551, false, 0, 6);
	drawer.text(data.getOilPreassure().toString(), 463, 551, true);
	drawer.hLine(0, 555, 554, 0x0155A5);
	drawer.text("VOLTAJE BC-BN:", 2, 562, false, 0, 6);
	drawer.text(data.getVoltageBCBN().toString(), 95, 562, true);
	drawer.text("CORRIENTE C (AMP):", 186, 562, false, 0, 6);
	drawer.text(data.getCurrentC().toString(), 279, 562, true);
	drawer.text("TEMPERATURA:", 370, 562, false, 0, 6);
	drawer.text(data.getTemp().toString(), 463, 562, true);
	drawer.hLine(0, 555, 565, 0x0155A5);
	drawer.text("VOLTAJE NT:", 2, 573, false, 0, 6);
	drawer.text(data.getVoltageNT().toString(), 95, 573, true);
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
	drawer.text(data.getAdjsutmentTherm().toString(), 95, 596, true);
	drawer.text("VOLTAJE FLOTACION BATERIAS:", 186, 596, false, 0, 5.7F);
	drawer.text(data.getBatteryCurrent().toString(), 279, 596, true);
	drawer.text("TIPO DE PROTECCION TRANSFER", 370, 596, false, 0, 5.4F);
	drawer.text(data.getTrasnferTypeProtection().toString(), 463, 596, true);
	drawer.hLine(0, 555, 599, 0x0155A5);
	drawer.text("CORRIENTE PRECALENTADOR:", 2, 607, false, 0, 6);
	drawer.text(data.getCurrent().toString(), 95, 607, true);
	drawer.text("ESTADO RELOJ CUENTAS HORAS", 186, 607, false, 0, 5.5F);
	drawer.text(data.getClockStatus().toString(), 279, 607, true);
	drawer.text("TIPO PROTECCION GENERADOR", 370, 607, false, 0, 5.5F);
	drawer.text(data.getGeneratorTypeProtection().toString(), 463, 607, true);
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
	drawer.textBox(data.getObservations(), 2, 622, 550, 34, true, false);
	drawer.hLine(0, 555, 633, 0x0155A5);
	drawer.hLine(0, 555, 644, 0x0155A5);
	drawer.hLine(0, 555, 655, 0x0155A5);
	drawer.vLine(623, 655, 0, 0x0155A5);
	drawer.vLine(623, 655, 555, 0x0155A5);
  }
  
  public static void main(String [] args) throws Exception{
	EmergencyPlantServiceReport serv = new EmergencyPlantServiceReport();
	Policy policy = new Policy();
	Serviceorder serviceOrder = new Serviceorder();
	EmergencyPlantServicePolicyDTO data = new EmergencyPlantServicePolicyDTO(); 
	EmergencyPlantServiceDTO emergencyPlantService = new EmergencyPlantServiceDTO ();
	FileOutputStream see = new FileOutputStream("C:/EmergencyPlantServiceReport.pdf");
	
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
	
	
	emergencyPlantService.setEpServiceId(1234);
	emergencyPlantService.setBrandPE("BrandPE");
	emergencyPlantService.setModelPE("ModelPE");
	emergencyPlantService.setSerialPE("SerialPE");
	emergencyPlantService.setTransferType("TransferType");
	emergencyPlantService.setModelTransfer("ModelTransfer");
	emergencyPlantService.setModelControl("ModelControl");
	emergencyPlantService.setModelRegVoltage("ModelRegVoltage");
	emergencyPlantService.setModelRegVelocity("ModelRegVelocity");
	emergencyPlantService.setModelCharger("ModelCharger");
	emergencyPlantService.setOilChange(new Date());
	emergencyPlantService.setBrandMotor("BrandMotor");
	emergencyPlantService.setModelMotor("ModelMotor");
	emergencyPlantService.setSerialMotor("SerialMotor");
	emergencyPlantService.setCplMotor("CplMotor");
	emergencyPlantService.setBrandGenerator("BrandGenerator");
	emergencyPlantService.setModelGenerator("ModelGenerator");
	emergencyPlantService.setSerialGenerator("SerialGenerator");
	emergencyPlantService.setPowerWattGenerator(12356);
	emergencyPlantService.setTensionGenerator(3256);
	emergencyPlantService.setTuningDate(new Date());
	emergencyPlantService.setTankCapacity(654);
	emergencyPlantService.setPumpFuelModel("PumpFuelModel");
	emergencyPlantService.setFilterFuelFlag(true);
	emergencyPlantService.setFilterOilFlag(false);
	emergencyPlantService.setFilterWaterFlag(true);
	emergencyPlantService.setFilterAirFlag(false);
	emergencyPlantService.setBrandGear("BrandGear");
	emergencyPlantService.setBrandBattery("BrandBattery");
	emergencyPlantService.setClockLecture("ClockLecture");
	emergencyPlantService.setServiceCorrective(new Date());
	emergencyPlantService.setObservations("Observations");
	emergencyPlantService.setEpServiceSurveyId(2356);
	emergencyPlantService.setLevelOilFlag(false);
	emergencyPlantService.setLevelWaterFlag(true);
	emergencyPlantService.setLevelBattery(52);
	emergencyPlantService.setTubeLeak(false);
	emergencyPlantService.setBatteryCap("BatteryCap");
	emergencyPlantService.setBatterySulfate("BatterySulfate");
	emergencyPlantService.setLevelOil(125);
	emergencyPlantService.setHeatEngine("HeatEngine");
	emergencyPlantService.setHoseOil("HoseOil");
	emergencyPlantService.setHoseWater("HoseWater");
	emergencyPlantService.setTubeValve("TubeValve");
	emergencyPlantService.setStripBlades("StripBlades");
	emergencyPlantService.setEpServiceWorkBasicId(542);
	emergencyPlantService.setWashEngine(false);
	emergencyPlantService.setWashRadiator(true);
	emergencyPlantService.setCleanWorkArea(true);
	emergencyPlantService.setConectionCheck(false);
	emergencyPlantService.setCleanTransfer(true);
	emergencyPlantService.setCleanCardControl(false);
	emergencyPlantService.setCheckConectionControl(false);
	emergencyPlantService.setCheckWinding(true);
	emergencyPlantService.setBatteryTests(false);
	emergencyPlantService.setCheckCharger(false);
	emergencyPlantService.setCheckPaint(true);
	emergencyPlantService.setCleanGenerator(true);
	emergencyPlantService.setEpServiceDynamicTestId(542);
	emergencyPlantService.setVacuumFrequency(12D);
	emergencyPlantService.setChargeFrequency(45D);
	emergencyPlantService.setBootTryouts(45D);
	emergencyPlantService.setVacuumVoltage(78D);
	emergencyPlantService.setChargeVoltage(52D);
	emergencyPlantService.setQualitySmoke(47D);
	emergencyPlantService.setStartTime(12544);
	emergencyPlantService.setTransferTime(5482);
	emergencyPlantService.setStopTime(652);
	emergencyPlantService.setEpServiceTestProtectionId(54);
	emergencyPlantService.setTempSensor(64);
	emergencyPlantService.setOilSensor(56);
	emergencyPlantService.setVoltageSensor(541);
	emergencyPlantService.setOverSpeedSensor(546);
	emergencyPlantService.setOilPreasureSensor(45);
	emergencyPlantService.setWaterLevelSensor(566);
	emergencyPlantService.setEpServiceTransferSwitchId(5645);
	emergencyPlantService.setMechanicalStatus("MechanicalStatus");
	emergencyPlantService.setBoardClean(false);
	emergencyPlantService.setLampTest(true);
	emergencyPlantService.setScrewAdjust(false);
	emergencyPlantService.setConectionAdjust(false);
	emergencyPlantService.setSystemMotors("SystemMotors");
	emergencyPlantService.setElectricInterlock("ElectricInterlock");
	emergencyPlantService.setMechanicalInterlock("MechanicalInterlock");
	emergencyPlantService.setCapacityAmp(652);
	emergencyPlantService.setEpServiceLecturesId(56465);
	emergencyPlantService.setVoltageABAN(1);
	emergencyPlantService.setVoltageACCN(2);
	emergencyPlantService.setVoltageBCBN(3);
	emergencyPlantService.setVoltageNT(4);
	emergencyPlantService.setCurrentA(5);
	emergencyPlantService.setCurrentB(6);
	emergencyPlantService.setCurrentC(7);
	emergencyPlantService.setFrequency(8);
	emergencyPlantService.setOilPreassure(9);
	emergencyPlantService.setTemp(10);
	emergencyPlantService.setEpServiceParamsId(11);
	emergencyPlantService.setAdjsutmentTherm("AdjsutmentTherm");
	emergencyPlantService.setCurrent("Current");
	emergencyPlantService.setBatteryCurrent("BatteryCurrent");
	emergencyPlantService.setClockStatus("ClockStatus");
	emergencyPlantService.setTrasnferTypeProtection("TrasnferTypeProtection");
	emergencyPlantService.setGeneratorTypeProtection("GeneratorTypeProtection");
    
	data = new EmergencyPlantServicePolicyDTO(policy, "equipmentType", serviceOrder,  emergencyPlantService);
	
	see.write(serv.getReport(data));
	see.close();
  }
}
