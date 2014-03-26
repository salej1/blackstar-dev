package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.bloom.common.bean.InternalTicketBean;
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
    
}
