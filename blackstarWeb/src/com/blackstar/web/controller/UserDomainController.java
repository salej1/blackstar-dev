package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/userDomain")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class UserDomainController extends AbstractController{

	// Lista de usuarios por grupo
	@RequestMapping(value = "/getEmployeeListJson.do", method = RequestMethod.GET)
	public @ResponseBody String unnasignedTicketsJson(ModelMap model, @RequestParam(required = true) String group) {
		String retVal;
		try {
			retVal = udService.getStaffByGroupJson(group);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
}
