package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.WarrantProject;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.PaymentTermsDTO;
import com.blackstar.model.dto.ServiceTypeDTO;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.model.dto.WarrantProjectListDTO;

public interface WarrantProjectDAO 
{
	public int insertWarrantProject(WarrantProject warrantProject);

	public WarrantProjectDTO getWarrantProjectById(Integer id);

	public List<CustomerListDTO> getCustomerList();
	
	public List<WarrantProjectListDTO>getWarrantProjectList();

	public List<JSONObject> getWarrantProjectJSON();

	public List<PaymentTermsDTO> getPaymentTermsList();
	
	public List<ServiceTypeDTO> getServiceTypesList();
	
	public List<WarrantProjectDTO> getWarrantProjectListByStatusId(String statusId);

}
