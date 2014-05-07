package com.blackstar.db.dao.interfaces;

import com.blackstar.model.OpenCustomer;

public interface OpenCustomerDAO {
	Integer AddOpenCustomer(OpenCustomer customer);
	OpenCustomer GetOpenCustomerById(Integer customerId);
}
