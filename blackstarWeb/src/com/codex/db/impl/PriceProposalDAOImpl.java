package com.codex.db.impl;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.PriceProposalDAO;
import com.codex.vo.PriceProposalEntryVO;
import com.codex.vo.PriceProposalItemVO;
import com.codex.vo.PriceProposalVO;

public class PriceProposalDAOImpl extends AbstractDAO 
                                  implements PriceProposalDAO{

  @Override 
  public void insertPriceProposal(PriceProposalVO priceProposal){
	String sqlQuery = "CALL CodexInsertPriceProposal(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	getJdbcTemplate().update(sqlQuery, new Object[]{priceProposal.getId()
			                , priceProposal.getProjectId(), priceProposal.getPriceProposalNumber()
			                , priceProposal.getClientId(), priceProposal.getTaxesTypeId()
				            , priceProposal.getPaymentTypeId(), priceProposal.getCurrencyTypeId()
				            , priceProposal.getCostCenter(), priceProposal.getChangeType()
				            , priceProposal.getCreated(), priceProposal.getContactName()
				            , priceProposal.getLocation(), priceProposal.getAdvance()
				            , priceProposal.getTimeLimit(), priceProposal.getSettlementTimeLimit()
				            , priceProposal.getDeliveryTime(), priceProposal.getIncoterm()
				            , priceProposal.getProductsNumber(), priceProposal.getFinancesNumber()
				            , priceProposal.getServicesNumber(), priceProposal.getTotalProjectNumber()});
  }
  
  @Override
  public void insertPriceProposalEntry(PriceProposalEntryVO priceProposalEntry) {
	 String sqlQuery = "CALL CodexInsertPriceProposalEntry(?, ?, ?, ?, ?, ?, ?)";
	 getJdbcTemplate().update(sqlQuery, new Object[]{priceProposalEntry.getId()
		  , priceProposalEntry.getPriceProposalId(), priceProposalEntry.getEntryTypeId()
		  , priceProposalEntry.getDescription(), priceProposalEntry.getDiscount()
		  , priceProposalEntry.getTotalPrice(), priceProposalEntry.getComments()});
  }
  
  @Override
  public void insertPriceProposalEntryItem(PriceProposalItemVO priceProposalItem){
    String sqlQuery = "CALL CodexInsertPriceProposalEntryItem(?, ?, ?, ?, ?, ?, ?, ? ,?)";
	getJdbcTemplate().update(sqlQuery, new Object[]{priceProposalItem.getPriceProposalEntryId()
			              , priceProposalItem.getItemTypeId(), priceProposalItem.getReference()
			              , priceProposalItem.getDescription(), priceProposalItem.getQuantity()
			              , priceProposalItem.getPriceByUnit(), priceProposalItem.getDiscount()
			              , priceProposalItem.getTotalPrice(), priceProposalItem.getComments()});
  }
  
  @Override
  public Integer getNewPriceProposalId() {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetNextPriceProposalId()");
	return getJdbcTemplate().queryForInt(sqlBuilder.toString());
  }
  
  @Override
  public Integer getPriceProposalNumberForProject(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetProposalNumberForProject(?)");
	return getJdbcTemplate().queryForInt(sqlBuilder.toString(), new Object[]{projectId});
  }
  
  @Override
  public Integer getNewPriceProposalentryId() {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetNextProposalEntryId()");
	return getJdbcTemplate().queryForInt(sqlBuilder.toString());
  }
}
