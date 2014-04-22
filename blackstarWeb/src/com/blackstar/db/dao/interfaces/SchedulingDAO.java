package com.blackstar.db.dao.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.ScheduledService;
import com.blackstar.model.dto.ScheduledServiceDTO;

public interface SchedulingDAO {
	public List<JSONObject> getFutureServices();
	public List<ScheduledServiceDTO> getScheduledServices(Date date);
	public List<String> getProjectList();
	public ScheduledService getScheduledService(Integer serviceId);
	public List<Integer> getScheduledServicePolicies(Integer serviceId);
	public List<String> getScheduledServiceEmployees(Integer serviceId);
	public List<Date> getScheduledServiceDates(Integer serviceId);
	public Integer upsertScheduledService(ScheduledService service);
	public void addScheduledServiceEmployee(Integer serviceId, String employee, Integer isDefault, String who, String user);
	public void addScheduledServicePolicy(Integer serviceId, Integer policyId, String who, String user);
	public void addScheduledServiceDate(Integer serviceId, Date date, String who, String user);
	public List<JSONObject> getEquipmentList();
}
