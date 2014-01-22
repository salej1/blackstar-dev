package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.IndicadoresServicioDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Ticket;

public class IndicadoresServicioDAOImpl extends AbstractDAO 
                                        implements IndicadoresServicioDAO {
	
	public List<JSONObject> getAllTickets(){
		String sqlQuery = "CALL GetAllTickets();";
		return getJdbcTemplate().query(sqlQuery, new Object[]{}
		                                , new JSONRowMapper()); 
	}
}
