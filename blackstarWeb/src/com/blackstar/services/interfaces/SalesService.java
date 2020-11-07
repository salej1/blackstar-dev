package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.dto.WarrantProjectDTO;

public interface SalesService {
	
	public List<WarrantProjectDTO> getNewSales();
	public List<WarrantProjectDTO> getAuthorizedSales();
	public List<WarrantProjectDTO> getPendingSales();

}