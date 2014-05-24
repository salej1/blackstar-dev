package com.blackstar.web.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.common.Utils;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.SurveyService;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.SurveyServiceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.services.interfaces.SurveyServiceService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/surveyServiceDetail")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class SurveyServiceDetialController extends AbstractController{

	private SurveyServiceService service;
	private ServiceOrderService osService;

	public void setService(SurveyServiceService surveyServiceService) {
		this.service = surveyServiceService;
	}

	public void setOsService(ServiceOrderService osService) {
		this.osService = osService;
	}

	@RequestMapping(value= "/show.do", method = RequestMethod.GET)
	  public String  surveyServiceInitial(
			  @RequestParam(required = true) Integer operation, // 1 nuevo, 2 detalle
			  @RequestParam(required = true) Integer idObject,
			  ModelMap model)
	  {
		if(operation == 1){
			SurveyServiceDTO surveyService = new SurveyServiceDTO();
			  model.addAttribute("surveyQualificationList", getQualificationsList());
			  model.addAttribute("surveyService", surveyService);
			  model.addAttribute("mode","new");
		}
		else if(operation == 2){
			SurveyService source = service.getSurveyServiceById(idObject);
			List<String> linkedServices = service.getSurveyLinkedServices(source.getSurveyServiceId());
			SurveyServiceDTO dto = new SurveyServiceDTO(source, linkedServices);
		    model.addAttribute("surveyQualificationList", getQualificationsList());
			model.addAttribute("surveyService", dto);
			model.addAttribute("mode", "detail");
		}
	  
		  return "surveyServiceDetail";
	  }
		
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	   public String save(
	   		@ModelAttribute("surveyService") SurveyServiceDTO surveyService,
	   		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
	             ModelMap model, HttpServletRequest req, HttpServletResponse resp){
		 
		try{
			// crear el objeto de negocio y poblarlo
			SurveyService ss = new SurveyService();
			ss.setSurveyServiceId(surveyService.getSurveyServiceId());
			ss.setCompany(surveyService.getCompany());
			ss.setDate(surveyService.getDate());
			ss.setEmail(surveyService.getEmail());
			ss.setName(surveyService.getName());
			ss.setPhone(surveyService.getPhone());
			ss.setScore(surveyService.getScore());
			ss.setQuestionTreatment(surveyService.getQuestionTreatment());
			ss.setReasonTreatment(surveyService.getReasonTreatment());
			ss.setQuestionIdealEquipment(surveyService.getQuestionIdealEquipment());
			ss.setReasonIdealEquipment(surveyService.getReasonIdealEquipment());
			ss.setQuestionIdentificationPersonal(surveyService.getQuestionIdentificationPersonal());
			ss.setQuestionTime(surveyService.getQuestionTime());
			ss.setReasonTime(surveyService.getReasonTime());
			ss.setQuestionUniform(surveyService.getQuestionUniform());
			ss.setReasonUniform(surveyService.getReasonUniform());
			ss.setSuggestion(surveyService.getSuggestion());
			ss.setSign(surveyService.getSign());
			ss.setCreated(Utils.getCurerntDateTime());
			ss.setCreatedBy("SurveyServiceController");
			ss.setCreatedByUsr(userSession.getUser().getUserEmail());
			
			String[] orders = surveyService.getServiceOrderList().split(",");
			
			service.saveSurvey(ss, orders);
			
		}catch(Exception e){
   		 Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			 return "error";
		}
		
		return "redirect:/surveyServices/show.do";
		 
	 }
	
	// Recuperacion de datos de la OS para encuesta
	@RequestMapping(value = "/getOsDetailsJson.do", method = RequestMethod.GET)
	public @ResponseBody String getOsDetailsJson(@RequestParam(required = true) String osList, ModelMap model) {
		String retVal;
		try {
			// Solo obtenemos los datos dela primer OS
			String[] oss = osList.split(",");
			if(oss.length > 0){
				retVal = osService.getServiceOrderDetails(oss[0]);
			}
			else{
				retVal = "error";
			}
		} catch (Exception ex) {
			Logger.Log(LogLevel.ERROR,
					Thread.currentThread().getStackTrace()[1].toString(), ex);
			ex.printStackTrace();
			retVal = "error";
		}
		return retVal;
	}
	
	private Map<Integer, String> getQualificationsList(){
		Map<Integer, String> qMap = new LinkedHashMap<Integer, String>();
		qMap.put(2, "2. Pesimo");
		qMap.put(4, "4. Malo");
		qMap.put(6, "6. Regular");
		qMap.put(8, "8. Bueno");
		qMap.put(10, "10. Excelente");
		
		return qMap;
	}
}
