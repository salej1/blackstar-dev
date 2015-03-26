package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.Customer;
import com.blackstar.model.dto.ClassificationDTO;
import com.blackstar.model.dto.CurrencyDTO;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.GovernmentDTO;
import com.blackstar.model.dto.IVADTO;
import com.blackstar.model.dto.OriginDTO;
import com.blackstar.model.dto.PaymentTermsDTO;
import com.blackstar.model.dto.SellerDTO;

public interface CustomerService {
	public CustomerDTO getCustomerById(Integer customerId);

	public List<CustomerListDTO> getCustomerList();

	public List<CustomerListDTO> getLeafletList();

	public String getCustomerJSON();

	public String getLeafletJSON();

	public int saveCustomer(Customer customer);

	public void updateCustomer(Customer customer);

	public List<GovernmentDTO> getGovernmentList();

	public List<PaymentTermsDTO> getPaymentTermsList();

	public List<CurrencyDTO> getCurrencyList();

	public List<SellerDTO> getSellerList();

	public List<ClassificationDTO> getClassficationList();

	public List<IVADTO> getIVAList();

	public List<OriginDTO> getOriginList();
}
