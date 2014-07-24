package com.codex.service.pdf;

import java.io.FileOutputStream;

import com.blackstar.services.report.AbstractReport;
import com.codex.vo.ProjectVO;
import com.pdfjet.Color;

public class PriceProposalReport extends AbstractReport {

  private ProjectVO data = null;
	
  protected void run(Object fillData) throws Exception {
	data = (ProjectVO) fillData;
	printHeader();
	printCover();
	drawer.changeToNewPage();
	printHeader();
	printProposal();
  }
	
	
  private void printHeader() throws Exception {
	drawer.image("pdf/logoSAC.jpg", 0, 10);
	drawer.text("GUADALAJARA", 165,50, true);
	drawer.text("Tel. 01(33) 37-93-01-38", 158,62);
	drawer.text("Fax. 01(33) 37-93-01-44", 158,72);
	drawer.text("MÉXICO", 275, 50, true);
	drawer.text("Tel. 01(55) 50-20-21-60", 254,62);
	drawer.text("Fax. 01(55) 50-20-21-63", 254,72);
	drawer.text("QUERÉTARO", 360,50, true);
	drawer.text("Tel. 01(442) 295-24-68", 349,62);
	drawer.text("01800.0830203", 360,72, true);
  }
  
  private void printCover() throws Exception {
	  drawer.text("Cotización No.", 267,250, true, 0 , 12);
	  drawer.text("Cliente:", 295,300);
	  drawer.text("Atención:", 294,350);
	  drawer.text("Fecha de Creación:", 279,400, true);
	  drawer.text("Aviso de Restricciones de Uso y Divulgación:", 40,600, true);
	  drawer.text("La información contenida en la totalidad de esta Propuesta, constituye un secreto de marca y/o información comercial y/o financiera", 40,630);
	  drawer.text("propiedad de SISTEMAS AVANZADOS EN COMPUTACIÓN DE MÉXICO, S.A. DE C.V., en lo sucesivo \"GRUPO SAC\", la cual, se encuentra", 40,645);
	  drawer.text("clasificada como confidencial. Esta información es proporcionada con la restricción de que no podrá ser usada o divulgada sin el permiso", 40,660);
	  drawer.text("de GRUPO SAC para otros propósitos que no sean para su evaluación, acordando con el Cliente, el protegerla con el mismo grado de cuidado", 40,675);
	  drawer.text("que el mismo utilizaría para proteger su propia información.", 40,690);
	  
	  drawer.text("La información contenida en la totalidad de este documento es clasificada como confidencial y se entrega bajo el entendido de que no será usada o divulgada, sin el permiso de Sistemas", 40,770, false, Color.gray, 6);
	  drawer.text("Avanzados en Computación de México, S.A. de C.V.", 40,780, false, Color.gray, 6);
  }
  
  private void printProposal() throws Exception {
	  drawer.box(35, 140, 510, 20, Color.gray, true);
	  drawer.text("PROPUESTA", 260, 154, true, 0, 10);
	  drawer.text("El objetivo principal es proveer una solución de ingeniería, configuración, puesta en operación y mantenimiento para su infraestructura", 40,190);
	  drawer.text("de protección, orientada precisamente a resguardar su aplicación crítica.", 40,205);
	  drawer.text("En la misma se detallarán códigos y características para que usted tenga una mejor comprensión de la solución que estamos ofreciendo,", 40,235);
	  drawer.text("misma que facilitará su toma de decisión sobre el producto y/o servicio de su interés.", 40,250);
  }
  
  
  
  public static void main(String [] args) throws Exception{
	PriceProposalReport serv = new PriceProposalReport();
	FileOutputStream see = new FileOutputStream("C:/PriceProposal.pdf");
	see.write(serv.getReport(new ProjectVO()));
	see.close();
  }

}
