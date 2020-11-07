package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.WarrantProjectDAO;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.model.dto.WarrantProjectListDTO;
import com.blackstar.services.interfaces.SalesService;

public class SalesServiceImpl implements SalesService {

private WarrantProjectDAO dao = null;
	
	public void setDao(WarrantProjectDAO dao) {
		this.dao = dao;
	}
	
	@Override
	public List<WarrantProjectDTO> getNewSales() {
		// TODO Auto-generated method stub
		return dao.getWarrantProjectListByStatusId("QO");
		//return null;
	}

	@Override
	public List<WarrantProjectDTO> getAuthorizedSales() {
		// TODO Auto-generated method stub
		return dao.getWarrantProjectListByStatusId("AU");		
	}

	@Override
	public List<WarrantProjectDTO> getPendingSales() {
		// TODO Auto-generated method stub
		return dao.getWarrantProjectListByStatusId("PA");		
	}
	

	
}
