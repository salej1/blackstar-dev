package com.blackstar.services.interfaces;

import com.blackstar.model.OpenCustomer;

public interface OpenCustomerService {
	Integer AddOpenCustomer(OpenCustomer customer);
	OpenCustomer GetOpenCustomerById(Integer customerId);
}
