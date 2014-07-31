package com.codex.db;

import com.codex.vo.PriceProposalEntryVO;
import com.codex.vo.PriceProposalItemVO;
import com.codex.vo.PriceProposalVO;

public interface PriceProposalDAO {
	
  public void insertPriceProposal(PriceProposalVO priceProposal);
  public void insertPriceProposalEntry(PriceProposalEntryVO priceProposalEntry);
  public void insertPriceProposalEntryItem(PriceProposalItemVO priceProposalItem);
  public Integer getNewPriceProposalId();
  public Integer getPriceProposalNumberForProject(Integer projectId);
  public Integer getNewPriceProposalentryId() ;

}
