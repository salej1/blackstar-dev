package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.CustomerDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Customer;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.GovernmentDTO;

public class CustomerDAOImpl extends AbstractDAO implements CustomerDAO
{

	public CustomerDTO getCustomerById(Integer customerId)
	{
		CustomerDTO customer=null;
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetCustomeById(?)");
		customer = (CustomerDTO) getJdbcTemplate().queryForObject(sqlBuilder.toString()
				, new Object []{customerId}, getMapperFor(CustomerDTO.class));
		return customer;
	}

	@SuppressWarnings("deprecation")
	@Override
	public int insertCustomer(Customer customer) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddCustomer(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		Object [] args=new Object[]
				{
					customer.getCustomerId()+"",
					customer.getCustomerType()+"",
					customer.getRfc()+"",
					customer.getCompanyName()+"",
					customer.getTradeName()+"",
					customer.getPhoneCode1()+"",
					customer.getPhoneCode2()+"",
					customer.getPhone1()+"",
					customer.getPhone2()+"",
					customer.getExtension1()+"",
					customer.getExtension2()+"",
					customer.getEmail1()+"",
					customer.getEmail2()+"",
					customer.getStreet()+"",
					customer.getExternalNumber()+"",
					customer.getInternalNumber()+"",
					customer.getColony()+"",
					customer.getTown()+"",
					customer.getCountry()+"",
					customer.getPostcode()+"",
					customer.getAdvance()+"",
					customer.getTimeLimit()+"",
					customer.getSettlementTimeLimit()+"",
					customer.getCurp()+"",
					customer.getContactPerson()+"",
					customer.getRetention()+"",
					customer.getCityId()+"",
					customer.getPaymentTermsId()+"",
					customer.getCurrencyId()+"",
					customer.getIvaId()+"",
					customer.getClassificationId()+"",
					customer.getOriginId()+"",
					customer.getSeller()+""
				};
		Integer idOS = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		return idOS;
	}
	
	/*public List<JSONObject> getCustomer() {
		String sqlQuery = "CALL GetAllCustomers();";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}
	*/

	@Override
	public boolean updateCustomer(Customer customer) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL UpdateCustomer(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		Object [] args=new Object[]
				{
					customer.getCustomerId()+"",
					customer.getCustomerType()+"",
					customer.getRfc()+"",
					customer.getCompanyName()+"",
					customer.getTradeName()+"",
					customer.getPhoneCode1()+"",
					customer.getPhoneCode2()+"",
					customer.getPhone1()+"",
					customer.getPhone2()+"",
					customer.getExtension1()+"",
					customer.getExtension2()+"",
					customer.getEmail1()+"",
					customer.getEmail2()+"",
					customer.getStreet()+"",
					customer.getExternalNumber()+"",
					customer.getInternalNumber()+"",
					customer.getColony()+"",
					customer.getTown()+"",
					customer.getCountry()+"",
					customer.getPostcode()+"",
					customer.getAdvance()+"",
					customer.getTimeLimit()+"",
					customer.getSettlementTimeLimit()+"",
					customer.getCurp()+"",
					customer.getContactPerson()+"",
					customer.getRetention()+"",
					customer.getCityId()+"",
					customer.getPaymentTermsId()+"",
					customer.getCurrencyId()+"",
					customer.getIvaId()+"",
					customer.getClassificationId()+"",
					customer.getOriginId()+"",
					customer.getSeller()+""
				};
		getJdbcTemplate().update(sqlBuilder.toString(), args);
		return true;
	}
	@Override
	public List<JSONObject> getCustomerJSON() {
		String sqlQuery = "CALL GetAllCustomers('C');";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}

	@Override
	public List<JSONObject> getLeafletJSON() {
		String sqlQuery = "CALL GetAllCustomers('P');";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CustomerListDTO> getCustomerList()
	{
		return (List<CustomerListDTO>) getJdbcTemplate().query("CALL GetAllCustomers('C');", getMapperFor(CustomerListDTO.class));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CustomerListDTO> getLeafletList()
	{
		return (List<CustomerListDTO>) getJdbcTemplate().query("CALL GetAllCustomers('P');", getMapperFor(CustomerListDTO.class));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GovernmentDTO> getGovernmentList()
	{
		return (List<GovernmentDTO>) getJdbcTemplate().query("CALL GetAllGovernments();", getMapperFor(GovernmentDTO.class));
	}
}
