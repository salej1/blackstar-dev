package com.bloom.services;

import java.util.List;

import com.blackstar.services.AbstractService;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.db.dao.InternalTicketsDao;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public class InternalTicketsServiceImpl extends AbstractService 
                                        implements InternalTicketsService {

  private InternalTicketsDao internalTicketsDao;

  @Override
  public List<InternalTicketBean> getPendingTickets(){
	List<InternalTicketBean> listaTickets = internalTicketsDao.getPendingTickets();
	return listaTickets;
  }
	
  /**
  * @return the internalTicketsDao
  */
  public InternalTicketsDao getInternalTicketsDao() {
	return internalTicketsDao;
  }

  /**
  * @param internalTicketsDao the internalTicketsDao to set
  */
  public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
	this.internalTicketsDao = internalTicketsDao;
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

}
