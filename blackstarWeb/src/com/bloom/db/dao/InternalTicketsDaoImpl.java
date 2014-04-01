package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.model.Followup;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

@SuppressWarnings("unchecked")
public class InternalTicketsDaoImpl extends AbstractDAO implements InternalTicketsDao {

	
  private static final class InternalTicketMapper implements RowMapper<InternalTicketBean> {
    @Override
    public InternalTicketBean mapRow(ResultSet rs, int rowNum) throws SQLException {
      //log.debug(rowNum + ": Ticket=" + rs.getString("IDTICKET"));
      InternalTicketBean ticket = new InternalTicketBean();
	  // atencion.setIdAtencion(rs.getLong(""));
	  // atencion.setNoReporte(rs.getString(""));
	  // atencion.setIdUsuario(rs.getLong(""));
      return ticket;
    }
  }
	
  public List<InternalTicketBean> getPendingTickets(){
	String sqlQuery = "CALL getPendingTickets();";	
	List<InternalTicketBean> listaTickets = new ArrayList<InternalTicketBean>();	
	InternalTicketBean ticket = new InternalTicketBean();	
	return getJdbcTemplate().query(sqlQuery, new InternalTicketMapper());  
  }
	
  public List<TicketDetailDTO> getTicketDetail(Integer ticketId){
	StringBuilder sqlBuilder = new StringBuilder("CALL GetBloomTicketDetail(?);");
	return (List<TicketDetailDTO>) getJdbcTemplate().query(sqlBuilder.toString()
			     , new Object[]{ticketId}, getMapperFor(TicketDetailDTO.class));
  }
  
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId){
	StringBuilder sqlBuilder = new StringBuilder("CALL GetBloomTicketTeam(?);");
	return (List<TicketTeamDTO>) getJdbcTemplate().query(sqlBuilder.toString()
			     , new Object[]{ticketId}, getMapperFor(TicketTeamDTO.class));
  }
  
  public void addFollow(Integer ticketId, Integer userId, String comment){
	 StringBuilder sqlBuilder = new StringBuilder("CALL AddFollowUpToBloomTicket(?, ?, ?);");
	 getJdbcTemplate().update(sqlBuilder.toString(), new Object[]{ticketId, userId, comment});
  }
  
  public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId){
     StringBuilder sqlBuilder = new StringBuilder("CALL UpsertBloomTicketTeam(?, ?, ?);");
	 getJdbcTemplate().update(sqlBuilder.toString(), new Object[]{ticketId, roleId, userId});
  }
  
  public List<Followup> getFollowUps(Integer ticketId){
	StringBuilder sqlBuilder = new StringBuilder("CALL GetBloomFollowUpByTicket(?);");
	return (List<Followup>) getJdbcTemplate().query(sqlBuilder.toString()
		        , new Object[]{ticketId}, getMapperFor(Followup.class));
  }
  
  public List<DeliverableTypeDTO> getDeliverableTypes(){
	StringBuilder sqlBuilder = new StringBuilder("CALL GetBloomDeliverableType();");
	return (List<DeliverableTypeDTO>) getJdbcTemplate().query(sqlBuilder.toString()
			                             , getMapperFor(DeliverableTypeDTO.class));
  }
  
  public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId){
	StringBuilder sqlBuilder = new StringBuilder("CALL AddBloomDelivarable(?, ?);");
	getJdbcTemplate().update(sqlBuilder.toString(), new Object[]{ticketId
			                                       , deliverableTypeId});
  } 
    
}
