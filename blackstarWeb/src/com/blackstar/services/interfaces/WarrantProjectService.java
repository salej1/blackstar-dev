package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.WarrantProject;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.PaymentTermsDTO;
import com.blackstar.model.dto.ServiceTypeDTO;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.model.dto.WarrantProjectListDTO;

public interface WarrantProjectService {
	public WarrantProjectDTO getWarrantProjectById(Integer warrantProjectId);
	
	public int saveWarrantProject(WarrantProject warrantProject);

	public List<CustomerListDTO> getCustomerList();
	
	public List<WarrantProjectListDTO> getWarrantProjectList();

	public String getWarrantProjectJSON();

	public List<PaymentTermsDTO> getPaymentTermsList();
	
	public List<ServiceTypeDTO> getServiceTypesList();
}
