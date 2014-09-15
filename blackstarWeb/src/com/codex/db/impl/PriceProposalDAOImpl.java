package com.codex.db.impl;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.PriceProposalDAO;
import com.codex.vo.PriceProposalEntryVO;
import com.codex.vo.PriceProposalItemVO;
import com.codex.vo.PriceProposalVO;

public class PriceProposalDAOImpl extends AbstractDAO 
                                  implements PriceProposalDAO{

  @Override 
  public Integer insertPriceProposal(PriceProposalVO priceProposal){
	String sqlQuery = "CALL CodexInsertPriceProposal(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	Integer propId = getJdbcTemplate().queryForObject(sqlQuery, new Object[]{
			                  priceProposal.getProjectId(), priceProposal.getPriceProposalNumber()
			                , priceProposal.getClientId(), priceProposal.getTaxesTypeId()
				            , priceProposal.getPaymentTypeId(), priceProposal.getCurrencyTypeId()
				            , priceProposal.getCostCenter(), priceProposal.getChangeType()
				            , priceProposal.getCreated(), priceProposal.getContactName()
				            , priceProposal.getLocation(), priceProposal.getAdvance()
				            , priceProposal.getTimeLimit(), priceProposal.getSettlementTimeLimit()
				            , priceProposal.getDeliveryTime(), priceProposal.getIncoterm()
				            , priceProposal.getProductsNumber(), priceProposal.getFinancesNumber()
				            , priceProposal.getServicesNumber(), priceProposal.getTotalProjectNumber()}, Integer.class);
	
	priceProposal.setId(propId);
	return propId;
  }
  
  @Override
  public Integer insertPriceProposalEntry(PriceProposalEntryVO priceProposalEntry) {
	 String sqlQuery = "CALL CodexInsertPriceProposalEntry(?, ?, ?, ?, ?, ?)";
	 Integer propEntryId = getJdbcTemplate().queryForObject(sqlQuery, new Object[]{
		    priceProposalEntry.getPriceProposalId(), priceProposalEntry.getEntryTypeId()
		  , priceProposalEntry.getDescription(), priceProposalEntry.getDiscount()
		  , priceProposalEntry.getTotalPrice(), priceProposalEntry.getComments()}, Integer.class);
	 
	 priceProposalEntry.setId(propEntryId);
	 return propEntryId;
  }
  
  @Override
  public Integer insertPriceProposalEntryItem(PriceProposalItemVO priceProposalItem){
    String sqlQuery = "CALL CodexInsertPriceProposalEntryItem(?, ?, ?, ?, ?, ?, ?, ? ,?)";
	Integer propEntryItemId = getJdbcTemplate().queryForObject(sqlQuery, new Object[]{priceProposalItem.getPriceProposalEntryId()
			              , priceProposalItem.getItemTypeId(), priceProposalItem.getReference()
			              , priceProposalItem.getDescription(), priceProposalItem.getQuantity()
			              , priceProposalItem.getPriceByUnit(), priceProposalItem.getDiscount()
			              , priceProposalItem.getTotalPrice(), priceProposalItem.getComments()}, Integer.class);
	
	priceProposalItem.setId(propEntryItemId);
	return propEntryItemId;
  }
    
  @Override
  public Integer getPriceProposalNumberForProject(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetProposalNumberForProject(?)");
	return getJdbcTemplate().queryForInt(sqlBuilder.toString(), new Object[]{projectId});
  }
}
