package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Policycontact;

public interface PolicyContactDAO {

	public Policycontact findPolicyContact();
	public List<Policycontact> selectAllPolicyContact();
	public Policycontact getPolicyContactById(int id);
	public int insertPolicyContact();
	public boolean updatePolicyContact();
}
