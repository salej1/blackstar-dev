package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Policy;

public interface PolicyDAO {

	public Policy findPolicy();
	public List<Policy> selectAllPolicy();
	public Policy getPolicyById(int id);
	public Policy getPolicyBySerialNo(String serialNo);
	public int insertPolicy();
	public boolean updatePolicy();
	public String getJsonEqupmentCollectionByCustomer(String customer);
}
