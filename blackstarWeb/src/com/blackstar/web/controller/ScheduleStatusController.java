package com.blackstar.web.controller;

import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.ScheduledServiceDTO;
import com.blackstar.services.interfaces.SchedulingService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/scheduleStatus")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ScheduleStatusController extends AbstractController{
	SchedulingService service;
	ServiceOrderService osService;
	
	public void setOsService(ServiceOrderService osService) {
		this.osService = osService;
	}

	public void setService(SchedulingService service) {
		this.service = service;
	}
	
	@RequestMapping(value= "/show.do", method = RequestMethod.GET)
	public String show( ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession){
		try{
			// Servicios programados
			Calendar cal = Calendar.getInstance();
			printDates(model);
			
			boolean isLimited = (userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) != null);
			
			for(Integer i = 0; i < 7; i++){
				if(isLimited){
					model.addAttribute("servicesToday" + i.toString(), service.getLimitedScheduledServices(userSession.getUser().getUserEmail(), cal.getTime()));	
				}
				else{
					model.addAttribute("servicesToday" + i.toString(), service.getScheduledServices(cal.getTime()));	
				}
				cal.add(Calendar.DATE, 1);
			}
			
			if(isLimited){
				model.addAttribute("futureServices", service.getLimitedFutureServices(userSession.getUser().getUserEmail()));
			}
			else{
				model.addAttribute("futureServices", service.getFutureServices());				
			}

			
			// Redireccionando el request
			return "scheduleStatus";
		}
		catch(Exception e){
			e.printStackTrace();
			Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
			model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			return "error";
		}
	}
	
	private void printDates(ModelMap model){
		DateFormat dateFormatter = DateFormat.getDateInstance(DateFormat.FULL);
		Calendar cal = Calendar.getInstance();
		
		Date today = new Date();
		cal.setTime(today);
		cal.add(Calendar.DATE, 1);
		Date today1 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today2 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today3 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today4 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today5 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today6 = cal.getTime();
		
		model.addAttribute("today",  dateFormatter.format(today));
		model.addAttribute("today1", dateFormatter.format(today1));
		model.addAttribute("today2", dateFormatter.format(today2));
		model.addAttribute("today3", dateFormatter.format(today3));
		model.addAttribute("today4", dateFormatter.format(today4));
		model.addAttribute("today5", dateFormatter.format(today5));
		model.addAttribute("today6", dateFormatter.format(today6));
	}
	
	@RequestMapping(value= "/scheduledServiceDetail.do", method = RequestMethod.GET)
	public String scheduledServiceDetail( @RequestParam(required = false) String serviceId, ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession){
		ScheduledServiceDTO ss;
		
		try{
			Integer ssId = 0;
			
			if(serviceId != null && !serviceId.equals("")){
				ssId = Integer.parseInt(serviceId);
			}
			
			if(ssId > 0){
				ss = service.getScheduledService(ssId);
			}
			else{
				ss = new ScheduledServiceDTO();
			}

			model.addAttribute("scheduledService", ss);
			// Lista de tipos de equipo
			model.addAttribute("equipmentTypeList", osService.getEquipmentTypeList());
			// Lista de proyectos
			model.addAttribute("projects", service.getProjectList());
			// Lista de empleados del directorio
			model.addAttribute("employees", udService.getStaffJson(Globals.GROUP_SERVICE));
			// Lista de equipos
			model.addAttribute("equipments", service.getEquipmentList());
		}
		catch(Throwable e){
			e.printStackTrace();
			Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
			model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			return "error";
		}
		
		return "scheduledServiceDetail";
	}
	
	@RequestMapping(value= "/save.do", method = RequestMethod.POST)
	public String save( @ModelAttribute("scheduledService") ScheduledServiceDTO scheduledService, ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession){
		try{
			// Creando / Actualizando scheduledService
			service.upsertScheduledService(scheduledService, "ScheduleStatusController", userSession.getUser().getUserEmail());
			
			return "redirect:/scheduleStatus/show.do";
		}
		catch(Exception e){
			e.printStackTrace();
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			return "error";
		}
	}
}
