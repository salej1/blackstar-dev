package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.WarrantProjectDAO;
import com.blackstar.model.WarrantProject;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.PaymentTermsDTO;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.model.dto.WarrantProjectListDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.WarrantProjectService;

public class WarrantProjectServiceImpl extends AbstractService implements
WarrantProjectService{

	private WarrantProjectDAO dao = null;
	
	
	public void setDao(WarrantProjectDAO dao) {
		this.dao = dao;
	}

	@Override
	public WarrantProjectDTO getWarrantProjectById(Integer warrantProjectId) {
		return dao.getWarrantProjectById(warrantProjectId);
	}

	@Override
	public int saveWarrantProject(WarrantProject warrantProject) {
		return dao.insertWarrantProject(warrantProject);
	}

	@Override
	public List<CustomerListDTO> getCustomerList() {
		return dao.getCustomerList();
	}

	@Override
	public List<WarrantProjectListDTO> getWarrantProjectList() {
		return dao.getWarrantProjectList();
	}

	@Override
	public String getWarrantProjectJSON() {
		List<JSONObject> warrantProjects = dao.getWarrantProjectJSON();
		return warrantProjects.toString();
	}

	@Override
	public List<PaymentTermsDTO> getPaymentTermsList() {
		return dao.getPaymentTermsList();
	}

}
