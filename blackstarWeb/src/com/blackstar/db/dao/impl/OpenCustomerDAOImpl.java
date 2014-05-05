package com.blackstar.db.dao.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.OpenCustomerDAO;
import com.blackstar.model.OpenCustomer;

public class OpenCustomerDAOImpl extends AbstractDAO implements OpenCustomerDAO {

	@Override
	public Integer AddOpenCustomer(OpenCustomer customer) {
		String sql = "CALL AddOpenCustomer(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		
		Integer id = (Integer)getJdbcTemplate().queryForObject(sql, new Object[]{
				customer.getCustomerName(),
				customer.getAddress(),
				customer.getPhone(),
				customer.getEquipmentTypeId(),
				customer.getBrand(),
				customer.getModel(),
				customer.getCapacity(),
				customer.getSerialNumber(),
				customer.getContactName(),
				customer.getContactEmail(),
				df.format(customer.getCreated()),
				customer.getCreatedBy(),
				customer.getCreatedByUsr()
		}, Integer.class);
		
		return id;
	}

	@Override
	public OpenCustomer GetOpenCustomerById(Integer customerId) {
		String sql = "CALL GetOpenCustomerById(?)";
		
		OpenCustomer oc = (OpenCustomer)getJdbcTemplate().queryForObject(sql, new Object[]{customerId}, getMapperFor(OpenCustomer.class));
		
		return oc;
	}

}
