package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.CustomerDAO;
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
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.CustomerService;

public class CustomerServiceImpl extends AbstractService implements
		CustomerService {

	private CustomerDAO dao = null;

	public void setDao(CustomerDAO dao) {
		this.dao = dao;
	}

	@Override
	public List<CustomerListDTO> getCustomerList() {
		return dao.getCustomerList();
	}

	@Override
	public List<CustomerListDTO> getLeafletList() {
		return dao.getLeafletList();
	}

	@Override
	public String getCustomerJSON() {
		List<JSONObject> customers = dao.getCustomerJSON();
		return customers.toString();
	}

	@Override
	public String getLeafletJSON() {
		List<JSONObject> customers = dao.getLeafletJSON();
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

	@Override
	public List<GovernmentDTO> getGovernmentList() {
		return dao.getGovernmentList();
	}

	@Override
	public List<PaymentTermsDTO> getPaymentTermsList() {
		return dao.getPaymentTermsList();
	}

	@Override
	public List<CurrencyDTO> getCurrencyList() {
		return dao.getCurrencyList();
	}

	@Override
	public List<SellerDTO> getSellerList() {
		return dao.getSellerList();
	}

	@Override
	public List<ClassificationDTO> getClassficationList() {
		return dao.getClassificationList();
	}

	@Override
	public List<IVADTO> getIVAList() {
		return dao.getIVAList();
	}

	@Override
	public List<OriginDTO> getOriginList() {
		return dao.getOriginList();
	}
}
