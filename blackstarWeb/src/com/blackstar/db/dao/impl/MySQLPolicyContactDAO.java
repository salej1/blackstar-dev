package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.MySQLDAOFactory;
import com.blackstar.db.dao.interfaces.PolicyContactDAO;
import com.blackstar.model.Policycontact;

public class MySQLPolicyContactDAO implements PolicyContactDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4137438371500773507L;

	@Override
	public Policycontact findPolicyContact() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Policycontact> selectAllPolicyContact() {
		List<Policycontact> lstPolicyContact = new ArrayList<Policycontact>();
		Policycontact policyContact = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from policycontact");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				policyContact = new Policycontact(rs.getInt("policyContactId"), rs.getString("name"), rs.getString("phone"),
						rs.getString("email"), rs.getDate("created"), rs.getString("createdBy"), rs.getString("createdByUsr"),
						rs.getDate("modified"), rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
				lstPolicyContact.add(policyContact);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return lstPolicyContact;
	}

	@Override
	public int insertPolicyContact() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updatePolicyContact() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Policycontact getPolicyContactById(int id) {
		Policycontact policyContact = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from policycontact where policyContactId = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				policyContact = new Policycontact(rs.getInt("policyContactId"), rs.getString("name"), rs.getString("phone"),
						rs.getString("email"), rs.getDate("created"), rs.getString("createdBy"), rs.getString("createdByUsr"),
						rs.getDate("modified"), rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return policyContact;
	}

}
