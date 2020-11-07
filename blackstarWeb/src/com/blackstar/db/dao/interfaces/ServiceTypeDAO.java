package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Servicetype;
import com.blackstar.model.dto.ServiceTypeDTO;

public interface ServiceTypeDAO {
	public Servicetype getServiceTypeById(char id);
	public List<ServiceTypeDTO> getServiceTypeList();
}
