package com.codex.db.impl;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.codex.db.KpiDAO;

public class KpiDAOImpl extends AbstractDAO implements KpiDAO{

	@Override
	public String getInvoicingKpi(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		String sql = "CALL getCodexInvoicingKpi(?,?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst, clientOriginId}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getEffectiveness(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		String sql = "CALL getCodexEffectiveness(?,?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst, clientOriginId}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getProposals(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		String sql = "CALL getCodexProposals(?,?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst, clientOriginId}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getProjectsByStatus(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		String sql = "CALL getCodexProjectsByStatus(?,?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst, clientOriginId}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getProjectsByOrigin(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		String sql = "CALL getCodexProjectsByOrigin(?,?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst, clientOriginId}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getClientVisits(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		String sql = "CALL getCodexClientVisits(?,?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst, clientOriginId}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getNewCustomers(Date startDate, Date endDate, String cst) {
		String sql = "CALL getCodexNewCustomers(?,?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate, cst}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getProductFamilies(Date startDate, Date endDate) {
		String sql = "CALL getCodexProductFamilies(?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

	@Override
	public String getComerceCodes(Date startDate, Date endDate) {
		String sql = "CALL getCodexComerceCodes(?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
		
		if(list != null){
			return list.toString();
		}
		else{
			return "[]";
		}
	}

}
