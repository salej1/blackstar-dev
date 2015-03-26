package com.codex.db;

import com.codex.vo.PriceProposalEntryVO;
import com.codex.vo.PriceProposalItemVO;
import com.codex.vo.PriceProposalVO;

public interface PriceProposalDAO {
	
  public Integer insertPriceProposal(PriceProposalVO priceProposal);
  public Integer insertPriceProposalEntry(PriceProposalEntryVO priceProposalEntry);
  public Integer insertPriceProposalEntryItem(PriceProposalItemVO priceProposalItem);
  public Integer getPriceProposalNumberForProject(Integer projectId);
}
