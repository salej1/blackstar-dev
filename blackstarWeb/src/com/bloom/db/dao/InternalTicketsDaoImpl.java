package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.bloom.common.bean.InternalTicketBean;

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
		return getJdbcTemplate().query(sqlQuery, new InternalTicketMapper());  
	}
    

}
