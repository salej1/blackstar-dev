package com.blackstar.db.dao.impl;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.OpenCustomerDAO;
import com.blackstar.model.OpenCustomer;

public class OpenCustomerDAOImpl extends AbstractDAO implements OpenCustomerDAO {

	@Override
	public Integer SaveOpenCustomer(OpenCustomer customer) {
		String sql = "CALL SaveOpenCustomer(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Integer id = (Integer)getJdbcTemplate().queryForObject(sql, new Object[]{
				customer.getOpenCustomerId(),
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
				customer.getOfficeId(),
				customer.getCreatedBy(),
				customer.getCreatedByUsr(),
				customer.getModifiedBy(),
				customer.getModifiedByUsr()
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
