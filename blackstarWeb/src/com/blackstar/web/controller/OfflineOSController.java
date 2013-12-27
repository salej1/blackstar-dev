package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.UserSession;


@Controller
@RequestMapping("/offlineOS")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class OfflineOSController {
	
	@RequestMapping(value = "/save.do")
	public String save(@RequestParam(required = true) String json,
		     @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
            ModelMap model){
	  return "";
	}

}
