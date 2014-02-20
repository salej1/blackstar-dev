package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.CustomerDAO;
import com.blackstar.model.Customer;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.CustomerService;

public class CustomerServiceImpl extends AbstractService implements CustomerService
{

	private CustomerDAO dao=null;
	
	
	public void setDao(CustomerDAO dao) {
		this.dao = dao;
	}

	

	@Override
	public List<CustomerDTO> getCustomersList() {
	return null;
	}

	@Override
	public String getCustomers() {
		List<JSONObject> customers = dao.getCustomers();
		return customers.toString();
	}

	@Override
	public int saveCustomer(Customer customer) {
		return dao.insertCustomer(customer);
	}

	@Override
	public void updateCustomer(Customer customer) {
		dao.updateCustomer(customer);
		
	}



	@Override
	public CustomerDTO getCustomerById(Integer customerId) {
		return dao.getCustomerById(customerId);
	}




}
