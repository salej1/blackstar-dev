package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.mapper.CatalogoMapper;

public class InternalTicketsDaoImpl extends AbstractDAO implements InternalTicketsDao {

	private static final String QUERY_TICKETS_PENDIENTES = "CALL getBloomPendingTickets(%s)";
	
    private static final String ERROR_CONSULTA =
            "Error al consultar el catálogo";
    
    private static final String EMPTY_CONSULTA =
            "No se encontraron registros";
	
	
	
    private static final class InternalTicketMapper implements RowMapper<InternalTicketBean> {

        @Override
        public InternalTicketBean mapRow(ResultSet rs, int rowNum) throws SQLException {
            //log.debug(rowNum + ": Ticket=" + rs.getString("ticketNumber"));
            InternalTicketBean ticket = new InternalTicketBean();
            
    		ticket.setId(rs.getLong("id"));
    		ticket.setTicketNumber(rs.getString("ticketNumber"));
    		ticket.setCreated(rs.getTimestamp("created"));
    		ticket.setCreatedStr(DataTypeUtil.formatearFechaDD_MM_AAAA_HH_MM_SS(rs.getTimestamp("created")));
    		ticket.setPetitionerArea(rs.getString("areaName"));
    		ticket.setPetitionerAreaId(rs.getInt("applicantAreaId"));
    		ticket.setServiceTypeDescr(rs.getString("serviceName"));
    		ticket.setServiceTypeId(rs.getInt("serviceTypeId"));
    		
    		//responseTime
    		ticket.setDeadline(rs.getTimestamp("created"));
    		ticket.setDeadlineStr(DataTypeUtil.formatearFechaDD_MM_AAAA(ticket.getCreated()));	
    		
    		ticket.setProject(rs.getString("project"));
    		ticket.setOfficeName(rs.getString("officeId"));
    		ticket.setOfficeId(rs.getString("officeId"));

            return ticket;
        }
    }
	
	
	
    @Override
    public List<InternalTicketBean> getPendingTickets(Long userId) throws DAOException {
    	
        List<InternalTicketBean> listaRegistros = new ArrayList<InternalTicketBean>();

        try {
        	
        	listaRegistros.addAll(getJdbcTemplate().query(String.format(QUERY_TICKETS_PENDIENTES, userId),
                    new InternalTicketMapper()));

            return listaRegistros;

        } catch (EmptyResultDataAccessException e) {
        	Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
            return Collections.emptyList();
        } catch (DataAccessException e) {
        	Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
            throw new DAOException(ERROR_CONSULTA, e);
        }
        
    }
	
	
    

}
