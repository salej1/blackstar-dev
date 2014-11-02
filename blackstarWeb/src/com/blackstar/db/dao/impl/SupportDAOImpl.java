package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.SupportDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;

public class SupportDAOImpl extends AbstractDAO implements SupportDAO {

	@Override
	public String getServiceOrderDetail(String serviceOrderNumber) {
		String sql = "CALL GetSupportServiceOrderDetail(?)";
		
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{serviceOrderNumber}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String getServiceOrderComments(String serviceOrderNumber) {
		String sql = "CALL GetSupportServiceOrderComments(?)";
			
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{serviceOrderNumber}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String getTicketDetails(String ticketNumber) {
		String sql = "CALL GetSupportTicketDetail(?)";
		
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{ticketNumber}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String getTicketComments(String ticketNumber) {
		String sql = "CALL GetSupportTicketComments(?)";
		
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{ticketNumber}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String getBloomTicketDetails(String ticketNumber) {
		String sql = "CALL GetSupportBloomTicketDetails(?)";
		
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{ticketNumber}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String getBloomTicketComments(String ticketNumber) {
		String sql = "CALL GetSupportBloomTicketComments(?)";
		
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{ticketNumber}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String deleteFollowUp(Integer followUpId) {
		String sql = "CALL DeleteFollowUp(?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{followUpId}, new JSONRowMapper());
		return list.toString();
	}

	@Override
	public String deleteServiceOrder(String serviceOrderNumber) {
		String sql = "CALL DeleteServiceOrder(?)";
		return getJdbcTemplate().query(sql, new Object[]{serviceOrderNumber}, new JSONRowMapper()).toString();
	}

	@Override
	public String deleteTicket(String ticketNumber) {
		String sql = "CALL DeleteTicket(?)";
		return getJdbcTemplate().query(sql, new Object[]{ticketNumber}, new JSONRowMapper()).toString();
	}

	@Override
	public String deleteBloomTicket(String ticketNumber) {
		String sql = "CALL DeleteBloomTicket(?)";
		return getJdbcTemplate().query(sql, new Object[]{ticketNumber}, new JSONRowMapper()).toString();
	}

	@Override
	public String deleteServiceOrderPDF(String serviceOrderNumber) {
		String sql = "CALL DeleteServiceOrderPDF(?)";
		return getJdbcTemplate().query(sql, new Object[]{serviceOrderNumber}, new JSONRowMapper()).toString();
	}

}
