package com.blackstar.db.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.SchedulingDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.ScheduledService;
import com.blackstar.model.dto.ScheduledServiceDTO;

public class SchedulingDAOImpl extends AbstractDAO implements SchedulingDAO {

	@Override
	public List<JSONObject> getFutureServices() {

		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 7);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "CALL GetFutureServicesSchedule(?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{sdf.format(cal.getTime())}, new JSONRowMapper());
		
		return list;
	}

	@Override
	public List<JSONObject> getLimitedFutureServices(String user) {

		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 7);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "CALL GetLimitedFutureServicesSchedule(?,?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{user, sdf.format(cal.getTime())}, new JSONRowMapper());
		
		return list;
	}

	@Override
	public List<ScheduledServiceDTO> getScheduledServices(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "CALL GetServicesSchedule(?)";
		
		@SuppressWarnings("unchecked")
		List<ScheduledServiceDTO> list = (List<ScheduledServiceDTO>)getJdbcTemplate().query(sql, new Object[]{sdf.format(date)}, getMapperFor(ScheduledServiceDTO.class));
		
		return list;
	}
	
	@Override
	public List<ScheduledServiceDTO> getLimitedScheduledServices(String user, Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "CALL GetLimitedServicesSchedule(?,?)";
		
		@SuppressWarnings("unchecked")
		List<ScheduledServiceDTO> list = (List<ScheduledServiceDTO>)getJdbcTemplate().query(sql, new Object[]{user, sdf.format(date)}, getMapperFor(ScheduledServiceDTO.class));
		
		return list;
	}

	@Override
	public List<String> getProjectList() {
		String sqlQuery = "CALL GetProjectList()";
		return (List<String>) getJdbcTemplate().queryForList(sqlQuery, String.class);
	}

	@Override
	public ScheduledService getScheduledService(Integer serviceId) {
		// Scheduled service
		String sqlQuery = "CALL GetScheduledServiceById(?)";
		ScheduledService service = (ScheduledService)getJdbcTemplate().queryForObject(sqlQuery, new Object[]{serviceId}, getMapperFor(ScheduledService.class));
		
		return  service;
	}

	@Override
	public Integer upsertScheduledService(ScheduledService service) {
		String sql = "CALL UpsertScheduledService(?,?,?,?,?,?,?,?)";
		Integer id = getJdbcTemplate().queryForObject(sql, new Object[]{
				service.getScheduledServiceId(), 
				service.getDescription(),
				service.getOpenCustomerId(),
				service.getProject(),
				service.getServiceContact(),
				service.getServiceContactEmail(),
				service.getModifiedBy() == null? service.getCreatedBy() : service.getModifiedBy(),
				service.getModifiedByUsr() == null? service.getCreatedByUsr():service.getModifiedByUsr()
			}, Integer.class);
		
		return id;
	}

	@Override
	public List<Integer> getScheduledServicePolicies(Integer serviceId) {
		String sql = "CALL GetScheduledServicePolicies(?)";
		List<Integer> policies = (List<Integer>)getJdbcTemplate().queryForList(sql, new Object[]{serviceId}, Integer.class);
		return policies;
	}

	@Override
	public List<String> getScheduledServiceEmployees(Integer serviceId) {
		String sql =  "CALL GetScheduledServiceEmployees(?)";
		List<String> employees = (List<String>)getJdbcTemplate().queryForList(sql, new Object[]{serviceId}, String.class);
		return employees;
	}

	@Override
	public List<Date> getScheduledServiceDates(Integer serviceId) {
		String sql =  "CALL GetScheduledServiceDates(?)";
		List<Date> dates = (List<Date>)getJdbcTemplate().queryForList(sql, new Object[]{serviceId}, Date.class);
		return dates;
	}

	@Override
	public void addScheduledServiceEmployee(Integer serviceId, String employee, Integer isDefault,
			String who, String user) {
		String sql = "CALL AddScheduledServiceEmployee(?,?,?,?,?)";
		getJdbcTemplate().update(sql, new Object[]{serviceId, employee, isDefault, who, user});
	}

	@Override
	public void addScheduledServicePolicy(Integer serviceId, Integer policyId,
			String who, String user) {
		String sql = "CALL AddScheduledServicePolicy(?,?,?,?)";
		getJdbcTemplate().update(sql, new Object[]{serviceId, policyId, who, user});
	}

	@Override
	public void addScheduledServiceDate(Integer serviceId, Date date,
			String who, String user) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		String sql = "CALL AddScheduledServiceDate(?,?,?,?)";
		getJdbcTemplate().update(sql, new Object[]{serviceId, sdf.format(date), who, user});
	}

	@Override
	public List<JSONObject> getEquipmentList() {
		String sql = "CALL GetEquipmentList()";
		List<JSONObject> list = getJdbcTemplate().query(sql, new JSONRowMapper());
		return list;
	}
}
