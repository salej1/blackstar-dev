package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.utils.DataTypeUtil;

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
		
		
		ticket.setId(1);
		ticket.setTicketNumber("SAC32");
		ticket.setCreated(new Date());
		ticket.setCreatedStr(DataTypeUtil.formatearFechaDD_MM_AAAA(ticket.getCreated()));
		
		ticket.setPetitionerArea("Ventas");
		ticket.setServiceTypeDescr("Pregunta Tecnica");
		ticket.setDeadline(new Date());
		ticket.setDeadlineStr(DataTypeUtil.formatearFechaDD_MM_AAAA(ticket.getCreated()));	
		
		ticket.setApplicantAreaName("CG140");
		ticket.setOfficeName("MXO");
		
		
		
		//return getJdbcTemplate().query(sqlQuery, new InternalTicketMapper());
		listaTickets.add(ticket);
		
		return listaTickets;
	}
    

}
