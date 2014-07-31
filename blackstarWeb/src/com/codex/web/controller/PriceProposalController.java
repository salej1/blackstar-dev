package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.web.AbstractController;
import com.codex.service.PriceProposalService;

@Controller
@RequestMapping("/codex/priceProposal")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class PriceProposalController extends AbstractController{

  private PriceProposalService service;

  public void setService(PriceProposalService service) {
	this.service = service;
  }
  
}
