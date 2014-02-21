package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Customer;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.GovernmentDTO;

public interface CustomerDAO 
{
	public int insertCustomer(Customer customer);
	public boolean updateCustomer(Customer customer);
	
	public CustomerDTO getCustomerById(Integer id);
	public List<CustomerListDTO> getCustomerList();
	public List<CustomerListDTO> getLeafletList();
	public List<JSONObject> getCustomerJSON();
	public List<JSONObject> getLeafletJSON();
	public List<GovernmentDTO> getGovernmentList();
}
