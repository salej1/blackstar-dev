package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.model.dto.CstDTO;
import com.codex.model.dto.VisitDTO;
import com.codex.service.ClientService;
import com.codex.service.CstService;
import com.codex.service.VisitService;

@Controller
@RequestMapping("/codex/visit")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class VisitController extends AbstractController {
	VisitService service;
	ClientService clService;
	CstService cstService;
	
	public void setCstService(CstService cstService) {
		this.cstService = cstService;
	}

	public void setClService(ClientService clService) {
		this.clService = clService;
	}

	public void setService(VisitService service) {
		this.service = service;
	}

	@RequestMapping(value = "/insert.do") 
	public String insert(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@ModelAttribute("visit") VisitDTO visit){
		try{
			visit.setCreatedByUsr(userSession.getUser().getUserEmail());
			visit.setCreatedBy("insert");
			visit.setCreated(Globals.getLocalTime());
			service.upsertVisit(visit);
		}
		catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			return "error";
		}
		
		return "redirect:/dashboard/show.do";
	}
	
	@RequestMapping(value = "/create.do") 
	public String create(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
		try{
			VisitDTO visit = new VisitDTO();
			CstDTO cst = cstService.getCstByEmail(userSession.getUser().getUserEmail());
			
			if(cst == null){
				throw new Exception("Es necesario tener privilegios de CST para registrar visitas a clientes");
			}
			visit.setVisitStatusId("P");
			visit.setCstId(cst.getCstId());
			model.addAttribute("visit", visit);
						
			model.addAttribute("mode", "new");
			model.addAttribute("isEditable", true);
			model.addAttribute("clients", clService.getCLientListJson());
			model.addAttribute("cstList", cstService.getAllCst());
			model.addAttribute("statusList", service.getVisitaStatusList());
		}
		catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}
		
		return "codex/visitDetail";
	}

	@RequestMapping(value = "/show.do") 
	public String show(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@ModelAttribute("codexVisitId") Integer codexVisitId){
		try{
			VisitDTO visit = service.getVisitById(codexVisitId);
			model.addAttribute("visit", visit);
			model.addAttribute("mode", "detail");
			boolean isEditable = (visit.getCstEmail().equals(userSession.getUser().getUserEmail()) && visit.getVisitStatusId().equals("P"));
			model.addAttribute("isEditable", isEditable);
			model.addAttribute("clients", clService.getCLientListJson());
			model.addAttribute("cstList", cstService.getAllCst());
			model.addAttribute("statusList", service.getVisitaStatusList());
		}
		catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}
		
		return "codex/visitDetail";
	}

	@RequestMapping(value = "/resolve.do") 
	public String resolve(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@ModelAttribute("codexVisitId") Integer codexVisitId,
			@ModelAttribute("closureComment") String closureComment){
		try{
			VisitDTO visit = service.getVisitById(codexVisitId);
			visit.setVisitStatusId("R");
			visit.setClosure(closureComment);
			visit.setModifiedByUsr(userSession.getUser().getUserEmail());
			visit.setModifiedBy("resolve");
			visit.setModified(Globals.getLocalTime());
			service.upsertVisit(visit);
		}
		catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}
		
		return "redirect:/dashboard/show.do";
	}
	
	@RequestMapping(value = "/visitListJson.do") 
	public  @ResponseBody String visitListJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
		try{
			String visits;
			if(userSession.getUser().getBelongsToGroup().get("Gerente comercial") != null) {
				visits = service.getVisitListJson();
			}
			else{
				visits = service.getVisitListJson(userSession.getUser().getUserEmail());
			}

			return visits;
		}
		catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}
	}
}
