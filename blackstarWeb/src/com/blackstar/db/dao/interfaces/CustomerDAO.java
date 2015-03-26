package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

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

public interface CustomerDAO {
	public int insertCustomer(Customer customer);

	public boolean updateCustomer(Customer customer);

	public CustomerDTO getCustomerById(Integer id);

	public List<CustomerListDTO> getCustomerList();

	public List<CustomerListDTO> getLeafletList();

	public List<JSONObject> getCustomerJSON();

	public List<JSONObject> getLeafletJSON();

	public List<GovernmentDTO> getGovernmentList();

	public List<PaymentTermsDTO> getPaymentTermsList();

	public List<CurrencyDTO> getCurrencyList();

	public List<SellerDTO> getSellerList();

	public List<ClassificationDTO> getClassificationList();

	public List<IVADTO> getIVAList();

	public List<OriginDTO> getOriginList();
}
