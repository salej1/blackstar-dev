package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.common.Globals;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/security")
public class SecurityController extends AbstractController {
  
  @RequestMapping("/loginCallback.do")
  public String handleLoginCallback(@RequestParam(required = false) String code
			                   , HttpServletRequest request) throws Exception {
	UserSession userSession = null;
	if (code != null && ((userSession = secService.getSession(code)) != null)) {
		System.out.println("bsMessage = > New gId : " + userSession.getGoogleId());
		request.getSession().setAttribute(Globals.SESSION_KEY_PARAM, userSession);
		//TODO Se mantienen de forma provisional por compatibilidad con version actual
		request.getSession().setAttribute("user_id", userSession.getUser().getUserEmail());
		request.getSession().setAttribute("user", userSession.getUser());
		return ("forward:/dashboard/show.do");
	} 
	return ("noUser");
  }
  
  @RequestMapping("/loadSession.do")
  public String loadSession(@RequestParam(required = false) String code
			                   , HttpServletRequest request) throws Exception {
	  return ("noUser");
  }
	 
}
