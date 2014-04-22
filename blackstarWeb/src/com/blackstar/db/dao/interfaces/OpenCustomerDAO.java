package com.blackstar.db.dao.interfaces;

import com.blackstar.model.OpenCustomer;

public interface OpenCustomerDAO {
	public Integer SaveOpenCustomer(OpenCustomer customer);
	public OpenCustomer GetOpenCustomerById(Integer customerId);
}
