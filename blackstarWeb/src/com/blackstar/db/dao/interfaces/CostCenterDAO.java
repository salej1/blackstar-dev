package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.CostCenter;
import com.blackstar.model.dto.CostCenterDTO;

public interface CostCenterDAO {
	
	public int insertCostCenter(CostCenter costCenter);
	
	public List<CostCenter> getAllCostCenterByOfficeId(char office_id);
	
	public List<CostCenterDTO> getAllCostCenterByOfficeIdDTO(char office_id);
	
	public List<JSONObject> getAllCostCenterByOfficeIdJSON(char office_id);
	
}
