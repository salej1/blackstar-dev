package com.blackstar.services.interfaces;

import com.blackstar.model.OpenCustomer;

public interface OpenCustomerService {
	public Integer SaveOpenCustomer(OpenCustomer customer);
	public OpenCustomer GetOpenCustomerById(Integer customerId);
}
