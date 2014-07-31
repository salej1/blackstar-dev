package com.codex.service;

import com.codex.vo.PriceProposalVO;
import com.codex.vo.ProjectVO;

public interface PriceProposalService {
	
  public PriceProposalVO getProposalFromProject(ProjectVO project);
  public void insertPriceProposal(PriceProposalVO priceProposal);

}
