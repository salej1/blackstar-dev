package com.blackstar.services.impl;

import com.blackstar.db.dao.interfaces.OpenCustomerDAO;
import com.blackstar.model.OpenCustomer;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.OpenCustomerService;

public class OpenCustomerServiceImpl extends AbstractService implements OpenCustomerService {

	private OpenCustomerDAO dao;

	public void setDao(OpenCustomerDAO dao) {
		this.dao = dao;
	}
	
	@Override
	public Integer SaveOpenCustomer(OpenCustomer customer) {
		return dao.SaveOpenCustomer(customer);
	}

	@Override
	public OpenCustomer GetOpenCustomerById(Integer customerId) {
		return dao.GetOpenCustomerById(customerId);
	}
}
