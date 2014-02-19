package com.blackstar.services.interfaces;


import java.util.List;

import com.blackstar.model.dto.CustomerDTO;

public interface CustomerService 
{
public CustomerDTO getCustomerById(Integer customerId);
public List<CustomerDTO> getCustomersList();
public String getCustomerHistory();

}
