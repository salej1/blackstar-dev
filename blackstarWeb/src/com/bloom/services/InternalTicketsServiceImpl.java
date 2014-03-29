package com.bloom.services;

import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.services.AbstractService;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.db.dao.InternalTicketsDao;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public class InternalTicketsServiceImpl extends AbstractService 
                                        implements InternalTicketsService {

  private InternalTicketsDao internalTicketsDao = null;
  
  public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
	this.internalTicketsDao = internalTicketsDao;
  }
  
  @Override
  public List<InternalTicketBean> getPendingTickets(){
	List<InternalTicketBean> listaTickets = internalTicketsDao.getPendingTickets();
	return listaTickets;
  }
	
  public TicketDetailDTO getTicketDetail(Integer ticketId){
	List<TicketDetailDTO> details = internalTicketsDao.getTicketDetail(ticketId);
	if(details.size() > 0){
		return details.get(0);
	}
	return null;
  }
  
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId){
	return internalTicketsDao.getTicketTeam(ticketId);
  }
  
  public void addFollow(Integer ticketId, Integer userId, String comment){
	internalTicketsDao.addFollow(ticketId, userId, comment);
  }
  
  public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId){
	internalTicketsDao.addTicketTeam(ticketId, roleId, userId);
  }
  
  public List<Followup> getFollowUps(Integer ticketId){
	return internalTicketsDao.getFollowUps(ticketId);
  }

}
