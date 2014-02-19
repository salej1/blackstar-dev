package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.CustomerDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Customer;

public class CustomerDAOImpl extends AbstractDAO implements CustomerDAO
{

	@Override
	public Customer findCustomer() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Customer> selectAllCustomer() {
		return null;
		
	}

	@Override
	public Customer getCustomerById(int id) {
		// TODO Auto-generated method stub
		return null;
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
	
	public List<JSONObject> getCustomer() {
		String sqlQuery = "CALL GetAllCustomers();";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}
	

	@Override
	public boolean updateCustomer(Customer customer) {
		// TODO Auto-generated method stub
		return false;
	}

}
