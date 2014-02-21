package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.Customer;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.model.dto.CustomerListDTO;

public interface CustomerService 
{
	public CustomerDTO getCustomerById(Integer customerId);
	public List<CustomerListDTO> getCustomerList();
	public List<CustomerListDTO> getLeafletList();
	public String getCustomerJSON();
	public String getLeafletJSON();
	public int saveCustomer(Customer customer);
	public void updateCustomer(Customer customer);
}
