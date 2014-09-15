package com.codex.service.impl;

import java.util.ArrayList;
import java.util.List;

import com.blackstar.services.AbstractService;
import com.codex.db.PriceProposalDAO;
import com.codex.service.PriceProposalService;
import com.codex.vo.PriceProposalEntryVO;
import com.codex.vo.PriceProposalItemVO;
import com.codex.vo.PriceProposalVO;
import com.codex.vo.ProjectEntryItemVO;
import com.codex.vo.ProjectEntryVO;
import com.codex.vo.ProjectVO;

public class PriceProposalServiceImpl extends AbstractService
                                      implements PriceProposalService{
	
  private PriceProposalDAO dao;

  public void setDao(PriceProposalDAO dao) {
	this.dao = dao;
  }
  
  @Override
  public PriceProposalVO getProposalFromProject(ProjectVO project){
	 PriceProposalVO priceProposal = new PriceProposalVO();
	 List<PriceProposalEntryVO> entries;
	 List<PriceProposalItemVO> items;
	 PriceProposalEntryVO entry = null;
	 PriceProposalItemVO item = null;
	 
	 Integer entryId = null;
	 priceProposal.setProjectId(project.getId());
	 String proposalNumber = "CQ-" + project.getProjectNumber() + "-" + dao.getPriceProposalNumberForProject(project.getId());
	 priceProposal.setPriceProposalNumber(proposalNumber);
     priceProposal.setClientId(project.getClientId());
     priceProposal.setTaxesTypeId(project.getTaxesTypeId());
     priceProposal.setPaymentTypeId(project.getPaymentTypeId());
     priceProposal.setCurrencyTypeId(project.getCurrencyTypeId());
     priceProposal.setCostCenter(project.getCostCenter());
     priceProposal.setChangeType(project.getChangeType());
     priceProposal.setCreated(project.getCreated());
     priceProposal.setContactName(project.getContactName());
     priceProposal.setLocation(project.getLocation());
     priceProposal.setAdvance(project.getAdvance());
     priceProposal.setTimeLimit(project.getTimeLimit());
     priceProposal.setSettlementTimeLimit(project.getSettlementTimeLimit());
     priceProposal.setDeliveryTime(project.getDeliveryTime());
     priceProposal.setIncoterm(project.getIncoterm());
     priceProposal.setProductsNumber(project.getProductsNumber() != null? project.getProductsNumber() : 0);
     priceProposal.setFinancesNumber(project.getFinancesNumber() != null? project.getFinancesNumber() : 0);
     priceProposal.setServicesNumber(project.getServicesNumber() != null? project.getServicesNumber() : 0);
     priceProposal.setTotalProjectNumber(project.getTotalProjectNumber());
     entries = new ArrayList<PriceProposalEntryVO>();
     
     for(ProjectEntryVO projectEntry :  project.getEntries()){
       entry = new PriceProposalEntryVO();
       entry.setComments(projectEntry.getComments());
       entry.setDescription(projectEntry.getDescription());
       entry.setDiscount(projectEntry.getDiscount());
       entry.setEntryTypeId(projectEntry.getEntryTypeId());
       entry.setTotalPrice(projectEntry.getTotalPrice());
       
       items = new ArrayList<PriceProposalItemVO>();
       for(ProjectEntryItemVO projectItem :  projectEntry.getItems()){
    	   item = new PriceProposalItemVO();
    	   item.setComments(projectItem.getComments());
    	   item.setDescription(projectItem.getDescription());
    	   item.setDiscount(projectItem.getDiscount());
    	   item.setItemTypeId(projectItem.getItemTypeId());
    	   item.setPriceByUnit(projectItem.getPriceByUnit());
    	   item.setPriceProposalEntryId(entryId);
    	   item.setQuantity(projectItem.getQuantity());
    	   item.setReference(projectItem.getReference());
    	   item.setTotalPrice(projectItem.getTotalPrice());
    	   items.add(item);
       }
       entry.setItems(items);
       entries.add(entry);
     }
     priceProposal.setEntries(entries);
     return priceProposal;
  }
  
  @Override 
  public void insertPriceProposal(PriceProposalVO priceProposal){
	List<PriceProposalItemVO> items = null;
	List<PriceProposalEntryVO> entries = priceProposal.getEntries();
	
	dao.insertPriceProposal(priceProposal);
	for(PriceProposalEntryVO entry : entries){
	  items = entry.getItems();
	  entry.setPriceProposalId(priceProposal.getId());
	  dao.insertPriceProposalEntry(entry);
	  
	  for(PriceProposalItemVO item : items){
		item.setPriceProposalEntryId(entry.getId());  
		dao.insertPriceProposalEntryItem(item);
	  }
	}  
  }

}
