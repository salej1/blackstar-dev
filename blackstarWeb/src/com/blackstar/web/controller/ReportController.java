package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/report")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ReportController extends AbstractController {
	
  private String urlPreffix = null;
  private String urlSufix = null;
  
  public void setUrlSufix(String urlSufix) {
	this.urlSufix = urlSufix;
  }

  public void setUrlPreffix(String urlPreffix) {
	this.urlPreffix = urlPreffix;
  }

  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
  public String  show(@RequestParam(required = true) Integer serviceOrderId
		                                                , ModelMap model) {
	String fileId = null;
	try {
		fileId = gdService.getReportFileId(serviceOrderId, "ServiceOrder.pdf");
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "redirect: " + urlPreffix + fileId + urlSufix;
  }

}