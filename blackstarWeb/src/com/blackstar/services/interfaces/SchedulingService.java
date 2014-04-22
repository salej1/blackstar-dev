package com.blackstar.services.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.dto.ScheduledServiceDTO;

public interface SchedulingService {
	public List<JSONObject> getFutureServices();
	public List<ScheduledServiceDTO> getScheduledServices(Date date);
	public List<String> getProjectList();
	public ScheduledServiceDTO getScheduledService(Integer serviceId);
	public Integer upsertScheduledService(ScheduledServiceDTO service, String who, String user);
	public List<JSONObject> getEquipmentList();
}
